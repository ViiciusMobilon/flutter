import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

class VerMaisPage extends StatefulWidget {
  final ServicePost post;

  const VerMaisPage({Key? key, required this.post}) : super(key: key);

  @override
  State<VerMaisPage> createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  int likeCount = 0;
  int _currentMediaIndex = 0;
  Map<int, VideoPlayerController?> _videoControllers = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked ?? false;
    likeCount = widget.post.likeCount ?? 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    if (widget.post.mediaUrls != null) {
      for (int i = 0; i < widget.post.mediaUrls!.length; i++) {
        String url = widget.post.mediaUrls![i];
        if (_isVideoUrl(url)) {
          _videoControllers[i] = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
        }
      }
    }
  }

  bool _isVideoUrl(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.avi');
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoControllers.forEach((key, controller) {
      controller?.dispose();
    });
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
  }

  void _sharePost() {
    Share.share(
      'Confira este serviço: ${widget.post.serviceName}\n'
      'Por ${widget.post.providerName} - ${widget.post.providerCompany}\n'
      '${widget.post.description}',
      subject: widget.post.serviceName,
    );
  }

  Widget _buildMediaCarousel() {
    if (widget.post.mediaUrls == null || widget.post.mediaUrls!.isEmpty) {
      return Container(
        height: 300,
        color: const Color(0xFFF5F7FA),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.post.mediaUrls!.length,
          itemBuilder: (context, index, realIndex) {
            String mediaUrl = widget.post.mediaUrls![index];
            bool isVideo = _isVideoUrl(mediaUrl);

            if (isVideo) {
              VideoPlayerController? controller = _videoControllers[index];
              if (controller != null && controller.value.isInitialized) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: 64,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.value.isPlaying
                              ? controller.pause()
                              : controller.play();
                        });
                      },
                    ),
                  ],
                );
              } else {
                return Container(
                  color: const Color(0xFFF5F7FA),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5F7FA),
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 64, color: Colors.grey),
                      ),
                    );
                  },
                ),
              );
            }
          },
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enableInfiniteScroll: widget.post.mediaUrls!.length > 1,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentMediaIndex = index;
              });
              _videoControllers.forEach((key, controller) {
                if (controller != null && controller.value.isPlaying) {
                  controller.pause();
                }
              });
            },
          ),
        ),
        if (widget.post.mediaUrls!.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.post.mediaUrls!.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentMediaIndex == entry.key
                        ? const Color(0xFF1A202C)
                        : const Color(0xFF1A202C).withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFF5F7FA),
            backgroundImage: widget.post.providerPhotoUrl != null
                ? NetworkImage(widget.post.providerPhotoUrl!)
                : null,
            child: widget.post.providerPhotoUrl == null
                ? const Icon(Icons.person, size: 32, color: Color(0xFF1A202C))
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.providerName ?? 'Prestador',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
                if (widget.post.providerCompany != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.post.providerCompany!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1A202C).withOpacity(0.7),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (widget.post.providerRating != null) ...[
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.providerRating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (widget.post.providerCity != null) ...[
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFF1A202C)),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.providerCity!,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1A202C).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.serviceName != null) ...[
            Text(
              widget.post.serviceName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            widget.post.description ?? 'Sem descrição disponível.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: const Color(0xFF1A202C).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: InkWell(
                onTap: _toggleLike,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isLiked
                        ? const Color(0xFF1A202C)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.white : const Color(0xFF1A202C),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$likeCount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isLiked ? Colors.white : const Color(0xFF1A202C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: InkWell(
                onTap: _sharePost,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Color(0xFF1A202C), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Compartilhar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A202C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.post.providerName ?? 'Detalhes do Serviço',
          style: const TextStyle(
            color: Color(0xFF1A202C),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF1A202C)),
            onPressed: _sharePost,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMediaCarousel(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildProviderInfo(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ServicePost model
class ServicePost {
  final String? id;
  final String? serviceName;
  final String? description;
  final List<String>? mediaUrls;
  final String? providerName;
  final String? providerCompany;
  final String? providerPhotoUrl;
  final double? providerRating;
  final String? providerCity;
  final bool? isLiked;
  final int? likeCount;

  ServicePost({
    this.id,
    this.serviceName,
    this.description,
    this.mediaUrls,
    this.providerName,
    this.providerCompany,
    this.providerPhotoUrl,
    this.providerRating,
    this.providerCity,
    this.isLiked,
    this.likeCount,
  });
}
