import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMaisDono.dart';
import 'package:tcc/service_post.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedPerfil extends StatefulWidget {
  final ServicePostFeed post;
  const FeedPerfil({super.key, required this.post});

  @override
  State<FeedPerfil> createState() => _FeedPerfilState();
}

class _FeedPerfilState extends State<FeedPerfil> {
  final List<ServicePostFeed> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
   
  }

 

  @override
  Widget build(BuildContext context) {
  
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Column(
        children: [
          for (var post in _posts) ServiceProviderFeed(post: post),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

// ------------------- COMPONENTE DE CADA CARD -------------------
class ServiceProviderFeed extends StatelessWidget {
  final ServicePostFeed post;

  const ServiceProviderFeed({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [];

    if (post.videoUrl != null) {
      carouselItems.add(_CarouselVideoItem(videoUrl: post.videoUrl![0]));
    }

    carouselItems.addAll(post.images!.map((url) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 40),
            ),
          ),
        ),
      );
    }));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.providerAvatar!),
                  radius: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.providerName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        post.providerCompany!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              post.location!,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      
          // Carrossel de imagens e vídeo
          if (carouselItems.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 240,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
              ),
              items: carouselItems,
            ),
      
          // Descrição + botão "Ver mais"
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    post.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VerMaisPageDono(post: post.toDetail()),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A202C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver mais',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- VÍDEO -------------------
class _CarouselVideoItem extends StatefulWidget {
  final String videoUrl;

  const _CarouselVideoItem({required this.videoUrl});

  @override
  State<_CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<_CarouselVideoItem> {
  late VideoPlayerController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibility(double visibleFraction) {
    final wasVisible = _isVisible;
    _isVisible = visibleFraction > 0.5; // mais de 50% visível

    if (_isVisible && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!_isVisible && _controller.value.isPlaying) {
      _controller.pause();
    }

    // Evita setState redundante
    if (wasVisible != _isVisible) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),

            // Gradiente sutil para legibilidade
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black26,
                        Colors.black45,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),

            // Botão Play/Pause manual
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),

            // Indicador de carregamento
            if (_controller.value.isBuffering)
              const Positioned(
                bottom: 12,
                right: 12,
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}