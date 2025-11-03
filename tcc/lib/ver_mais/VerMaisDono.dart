import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ver_mais/editar_post.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


class VerMaisPageDono extends StatefulWidget {
  final Portfolio post;
   

  const VerMaisPageDono({
    super.key,
    required this.post,
  });

  @override
  State<VerMaisPageDono> createState() => _VerMaisPageDonoState();
}

class _VerMaisPageDonoState extends State<VerMaisPageDono>
    with SingleTickerProviderStateMixin {
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initVideos();

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
  }

  void _initVideos() {
    if (widget.post.videos != null) {
      for (int i = 0; i < widget.post.videos!.length; i++) {
        final url = '${URLAPISTORAGE}${widget.post.videos![i]}';
        if (_isVideo(url)) {
          final controller = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
          _controllers[i] = controller;
        }
      }
    }
  }

  bool _isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith(".mp4") ||
        lower.endsWith(".mov") ||
        lower.endsWith(".avi");
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    final authController = context.watch<AuthController>();
    final user = authController.usuario;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFF5F7FA),
            backgroundImage:
                user?.fotoURL != null ? NetworkImage(user!.fotoURL!) : null,
            child: user?.fotoURL == null
                ? const Icon(Icons.person, size: 32, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.nome ?? user?.razao_social ?? 'Usuário',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (user?.ramoNome != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user!.ramoNome!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(String url, int index) {
    final isVideo = _isVideo(url);
    if (isVideo) {
      final controller = _controllers[index];
      if (controller == null || !controller.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return VisibilityDetector(
        key: Key(url),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.6) {
            controller.play();
          } else {
            controller.pause();
          }
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE6E8EB),
            child: const Icon(Icons.broken_image,
                size: 60, color: Colors.grey),
          ),
        ),
      );
    }
  }

  Widget _buildMediaCarousel() {
    final media = widget.post.videos;
    if (media!.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: media.length,
          itemBuilder: (context, index, _) => _buildMedia('${URLAPISTORAGE}${media[index]}', index),
          options: CarouselOptions(
            height: 400,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (i, _) {
              setState(() {
                _currentIndex = i;
              });
              _controllers.forEach((_, c) => c.pause());
            },
          ),
        ),
        if (media.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                media.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 9 : 6,
                  height: _currentIndex == i ? 9 : 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? Colors.black
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    final desc = widget.post.descricao ?? 'Sem descrição disponível.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Text(
        desc,
        style: const TextStyle(
          fontSize: 15.5,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes do Serviço',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditarPostPage(post: widget.post),
                ),
              );
            },
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
                _buildHeader(),
                const SizedBox(height: 8),
                _buildMediaCarousel(),
                const SizedBox(height: 12),
                _buildDescription(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
