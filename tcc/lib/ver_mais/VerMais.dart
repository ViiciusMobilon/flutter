import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tcc/service_post.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';

class VerMaisPage extends StatefulWidget {
  final ServicePost post;

  const VerMaisPage({Key? key, required this.post}) : super(key: key);

  @override
  State<VerMaisPage> createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage> {
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initVideos();
  }

  void _initVideos() {
    if (widget.post.mediaUrls != null) {
      for (int i = 0; i < widget.post.mediaUrls!.length; i++) {
        final url = widget.post.mediaUrls![i];
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
    return lower.endsWith(".mp4") || lower.endsWith(".mov") || lower.endsWith(".avi");
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilDeOutroUsuario()),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: widget.post.providerPhotoUrl != null
                  ? NetworkImage(widget.post.providerPhotoUrl!)
                  : null,
              backgroundColor: const Color(0xFFE6E8EB),
              child: widget.post.providerPhotoUrl == null
                  ? const Icon(Icons.person, color: Colors.white, size: 26)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.providerName ?? "Prestador",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.3,
                  ),
                ),
                if (widget.post.providerCompany != null)
                  Text(
                    widget.post.providerCompany!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF777777),
                    ),
                  ),
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
          
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
     
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFE6E8EB),
          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMediaCarousel() {
    final media = widget.post.mediaUrls ?? [];
    if (media.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: media.length,
          itemBuilder: (context, index, _) => _buildMedia(media[index], index),
          options: CarouselOptions(
            height: 420,
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
    final name = widget.post.providerName ?? 'Prestador';
    final service = widget.post.serviceName ?? '';
    final desc = widget.post.description ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$name ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15.5,
                  ),
                ),
                TextSpan(
                  text: service,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
          ),
          if (desc.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                desc,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: Color(0xFF444444),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            "Publicado há 2h",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.5,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
        elevation: 0.8,
        title: const Text(
          "Detalhes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildMediaCarousel(),
            _buildDescription(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
