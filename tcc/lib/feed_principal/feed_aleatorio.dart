import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:tcc/service_post.dart';

// ------------------------ ALEATORIO FEED ------------------------
class AleatorioFeed extends StatefulWidget {

  AleatorioFeed({super.key});

  @override
  State<AleatorioFeed> createState() => _AleatorioFeedState();
}

class _AleatorioFeedState extends State<AleatorioFeed> {
  late ScrollController _scrollController;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<PortfolioController>(context, listen: false);
      controller.fetchPortfolios(refresh: true);
    });

    _scrollController = ScrollController();
    final controller = Provider.of<PortfolioController>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if(!controller.loading && controller.hasMore) {
          controller.fetchPortfolios();
        }
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<PortfolioController>(
        builder: (context, controller, child) { 
          final _posts = controller.portfolios;   
          if (_posts.isEmpty && !controller.loading) {
            return const Center(child: Text("Nenhum serviço encontrado."));
          }

          return Container(
            color: const Color(0xFFF5F7FA),
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index < _posts.length) {
                  return ServiceProviderFeed(post: _posts[index]);
                } else {
                  return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                }
              },
            ),
          );
        }
    );
  }
}

class ServiceProviderFeed extends StatefulWidget {
  final Portfolio post;

  ServiceProviderFeed({super.key, required this.post});

  @override
  State<ServiceProviderFeed> createState() => _ServiceProviderFeedState();
}

class _ServiceProviderFeedState extends State<ServiceProviderFeed> {
  @override
  Widget build(BuildContext context) {
    // Combina vídeo e imagens em um único array de widgets
    List<Widget> carouselItems = [];

    if (widget.post.videos.isNotEmpty) {
      for (var v in widget.post.videos) {
        carouselItems.add(_CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}'));
        print('url video: ${URLAPISTORAGE}${v.url}');
      }
    }

    carouselItems.addAll(
      widget.post.fotos.map((f) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              '${URLAPISTORAGE}${f.url}',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 40)),
            ),
          ),
        );
      }),
    );

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
      child: GestureDetector(
        onTap:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PerfilDeOutroUsuario(),
              ),
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
                    backgroundImage: NetworkImage(widget.post.avatar ?? ''),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.nome ?? 'Sem nome',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.post.ramo ?? 'Sem ramo',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.post.cidade ?? 'Sem localização',
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

            // Carrossel de imagens + vídeo
            if (carouselItems.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 240,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                ),
                items: carouselItems,
              ),

            // Descrição e botão "Ver mais"
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.post.descricao!,
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
                            builder:
                                (context) => VerMaisPage(post: ServicePost()),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
      ),
    );
  }
}

// ------------------- VIDEO WIDGET -------------------
class _CarouselVideoItem extends StatefulWidget {
  final String videoUrl;

  const _CarouselVideoItem({required this.videoUrl});

  @override
  State<_CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<_CarouselVideoItem> {
  late VideoPlayerController _controller;

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

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRRect(
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

          // Botão Play/Pause com design aprimorado
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

          // Indicador de carregamento quando estiver iniciando
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
    );
  }
}
