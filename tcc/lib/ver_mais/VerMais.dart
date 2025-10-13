import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/service_post.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';

// Página de detalhes do post
class VerMaisPage extends StatefulWidget {
  final ServicePost post;

  const VerMaisPage({Key? key, required this.post}) : super(key: key);

  @override
  State<VerMaisPage> createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage> with SingleTickerProviderStateMixin {
  int _currentMediaIndex = 0;
  Map<int, VideoPlayerController?> _videoControllers = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    if (widget.post.mediaUrls != null) {
      for (int i = 0; i < widget.post.mediaUrls!.length; i++) {
        final url = widget.post.mediaUrls![i];
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
    _videoControllers.forEach((_, controller) => controller?.dispose());
    super.dispose();
  }

  Widget _buildMediaItem(String mediaUrl, int index) {
    bool isVideo = _isVideoUrl(mediaUrl);

    if (isVideo) {
      VideoPlayerController? controller = _videoControllers[index];
      if (controller == null || !controller.value.isInitialized) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      Duration position = controller.value.position;
      Duration duration = controller.value.duration;
      double progress = duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0;

      return VisibilityDetector(
        key: Key(mediaUrl),
        onVisibilityChanged: (info) {
          final visible = info.visibleFraction > 0.6;
          if (visible && !controller.value.isPlaying) {
            controller.play();
          } else if (!visible && controller.value.isPlaying) {
            controller.pause();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            // Gradiente
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Play/Pause central
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.value.isPlaying ? controller.pause() : controller.play();
                });
              },
              child: AnimatedOpacity(
                opacity: controller.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 72),
                ),
              ),
            ),
            // Controles inferiores
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (value) {
                          final newPosition = duration * value;
                          controller.seekTo(newPosition);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(controller.value.volume > 0 ? Icons.volume_up : Icons.volume_off, color: Colors.white, size: 22),
                              onPressed: () {
                                setState(() {
                                  controller.setVolume(controller.value.volume > 0 ? 0 : 1);
                                });
                              },
                            ),
                            if (controller.value.position >= controller.value.duration)
                              IconButton(
                                icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
                                onPressed: () {
                                  controller.seekTo(Duration.zero);
                                  controller.play();
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 22),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => _FullscreenVideoPage(controller: controller)),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(_formatDuration(duration), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF5F7FA),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFF5F7FA),
            child: const Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
          ),
        ),
      );
    }
  }

  Widget _buildMediaCarousel() {
    if (widget.post.mediaUrls == null || widget.post.mediaUrls!.isEmpty) {
      return Container(
        height: 300,
        color: const Color(0xFFF5F7FA),
        child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)),
      );
    }

    return CarouselSlider.builder(
      itemCount: widget.post.mediaUrls!.length,
      itemBuilder: (context, index, realIndex) {
        return _buildMediaItem(widget.post.mediaUrls![index], index);
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
            if (controller != null && controller.value.isPlaying) controller.pause();
          });
        },
      ),
    );
  }

  Widget _buildProviderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilDeOutroUsuario())),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFFF5F7FA),
              backgroundImage: widget.post.providerPhotoUrl != null ? NetworkImage(widget.post.providerPhotoUrl!) : null,
              child: widget.post.providerPhotoUrl == null ? const Icon(Icons.person, size: 32, color: Color(0xFF1A202C)) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.providerName ?? 'Prestador', overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (widget.post.providerCompany != null)
                    Text(widget.post.providerCompany!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.serviceName != null)
            Text(widget.post.serviceName!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(widget.post.description ?? 'Sem descrição disponível.', style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.post.providerName ?? 'Detalhes do serviço'),
        backgroundColor: Colors.blue,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildProviderInfo()),
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildMediaCarousel()),
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildDescription()),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tela cheia do vídeo
class _FullscreenVideoPage extends StatelessWidget {
  final VideoPlayerController controller;
  const _FullscreenVideoPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => controller.value.isPlaying ? controller.pause() : controller.play(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller))),
            if (!controller.value.isPlaying) const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 64),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
}
