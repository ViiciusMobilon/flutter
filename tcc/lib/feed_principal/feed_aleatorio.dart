import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_dono_conta.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMais.dart';

/// Página principal que exibe o feed aleatório de postagens
class AleatorioFeed extends StatefulWidget {
   

  AleatorioFeed({super.key,  });

  @override
  State<AleatorioFeed> createState() => _AleatorioFeedState();
}

class _AleatorioFeedState extends State<AleatorioFeed> {
  late ScrollController _scrollController;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<PortfolioController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.portfoliosGeral.isEmpty) { // 🔹 evita repetir
        controller.fetchPortfolios(refresh: true);
      }
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if(!controller.loadingGeral && controller.hasMoreGeral) {
          controller.loadMorePostsAll();
          print('Fui chamado');
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
    // final authController = context.watch<AuthController>();
    // final user = authController.usuario;
    
    return Consumer<PortfolioController>(
        builder: (context, controller, child) { 
          final _posts = controller.portfoliosGeral;   
          if (_posts.isEmpty && !controller.loadingGeral) {
            return const Center(child: Text("Nenhum serviço encontrado."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchPortfolios(refresh: true);
            },
            color: const Color(0xFFF5F7FA),
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              // itemCount: _posts.length + 1,
              itemCount: _posts.length + (controller.loadingGeral && controller.hasMoreGeral ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _posts.length) {
                  print('novo post geral: ${_posts[index]}');
                  return ServiceProviderFeed(post: _posts[index]);
                } else if (controller.hasMoreGeral) {
                  return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                } else{
                  return const SizedBox.shrink();
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
   

  ServiceProviderFeed({super.key, required this.post,  });

  @override
  State<ServiceProviderFeed> createState() => _ServiceProviderFeedState();
}

class _ServiceProviderFeedState extends State<ServiceProviderFeed> {
  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    final user = authController.usuario;
    // final hasVideo = widget.post.videos != null && widget.post.videos!.isNotEmpty;
    // final hasImages = widget.post.images != null && widget.post.images!.isNotEmpty;

    // Lista que conterá as mídias do carrossel (imagens e/ou vídeos)
    List<Widget> carouselItems = [];

    if (widget.post.videos!.isNotEmpty) {
      for (var v in widget.post.videos!) {
        carouselItems.add(_CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}'));
        print('url video: ${URLAPISTORAGE}${v.url}');
      }
    }

    carouselItems.addAll(
      widget.post.fotos!.map((f) {
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PerfilDeOutroUsuario(id: widget.post.userId!,),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Cabeçalho do post (foto, nome, empresa, localização)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.user_foto ?? ''),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.user_nome ?? 'Sem nome',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          widget.post.user_ramo ?? 'Sem ramo',
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
                                '${widget.post.user_cidade}, ${widget.post.user_estado}',
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
        
            // 🔹 Carrossel de imagens/vídeo (se existir)
            if (carouselItems.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 240,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false, // evita scroll infinito
                ),
                items: carouselItems,
              ),
        
            // 🔹 Descrição e botão "Ver mais"
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
                  if (widget.post.descricao != null)
                    InkWell(
                      onTap: () {
                        // Abre a tela "Ver Mais"
                        if (widget.post.userId == user!.id) {
                          print('Eu sou o dono');
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VerMaisPage(post:widget.post),
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
                              "Ver mais",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 16),
                          ],
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

/// ------------------- WIDGET DE VÍDEO -------------------
class _CarouselVideoItem extends StatefulWidget {
  final String videoUrl;
  const _CarouselVideoItem({required this.videoUrl});

  @override
  State<_CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<_CarouselVideoItem> {
  late VideoPlayerController _controller; // Controlador do player
  bool _isVisible = false; // Detecta se o vídeo está visível na tela

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Função que controla quando o vídeo deve tocar ou pausar
  void _handleVisibility(double visibleFraction) {
    final wasVisible = _isVisible;
    _isVisible = visibleFraction > 0.6;

    // Toca ou pausa automaticamente dependendo da visibilidade
    if (_isVisible && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!_isVisible && _controller.value.isPlaying) {
      _controller.pause();
    }

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
            // Gradiente escuro para melhorar contraste
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
            // Botão de play/pausa
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
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
