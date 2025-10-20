import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:tcc/service_post.dart';

/// Página principal que exibe o feed aleatório de postagens
class AleatorioFeed extends StatefulWidget {
  const AleatorioFeed({super.key});

  @override
  State<AleatorioFeed> createState() => _AleatorioFeedState();
}

class _AleatorioFeedState extends State<AleatorioFeed> {
  final List<ServicePostFeed> _posts = []; // Lista de posts exibidos no feed
  final ScrollController _scrollController = ScrollController(); // Controla a rolagem
  bool _isLoading = false; // Indica se está carregando novos posts

  @override
  void initState() {
    super.initState();
    _loadInitialPosts(); // Carrega os posts iniciais
  }

  /// Carrega alguns posts de exemplo (mock)
  void _loadInitialPosts() {
    List<ServicePostFeed> initialPosts = [
      // 🔹 Post 1 — Somente texto
      ServicePostFeed(
        id: '1',
        providerName: 'João Silva',
        providerCompany: 'Serviços Gerais',
        providerAvatar: 'https://picsum.photos/100/100?random=1',
        location: 'São Paulo - SP',
        description: 'Atendimento rápido e confiável!',
        fullDescription:
            'Ofereço serviços gerais residenciais com qualidade e preço justo.',
        images: null,
        videoUrl: null,
        likes: 12,
        isLiked: false,
      ),

      // 🔹 Post 2 — Somente imagem
      ServicePostFeed(
        id: '2',
        providerName: 'Maria Oliveira',
        providerCompany: 'Jardinagem Pro',
        providerAvatar: 'https://picsum.photos/100/100?random=2',
        location: 'Rio de Janeiro - RJ',
        description: 'Paisagismo moderno e criativo.',
        fullDescription:
            'Transforme seu jardim em um verdadeiro paraíso verde!',
        images: [
          'https://picsum.photos/600/400?random=20',
          'https://picsum.photos/600/400?random=21'
        ],
        videoUrl: null,
        likes: 30,
        isLiked: false,
      ),

      // 🔹 Post 3 — Mistura (vídeo + imagem)
      ServicePostFeed(
        id: '3',
        providerName: 'Carlos Mendes',
        providerCompany: 'TechFix',
        providerAvatar: 'https://picsum.photos/100/100?random=3',
        location: 'Curitiba - PR',
        description: 'Assistência técnica especializada!',
        fullDescription:
            'Reparo de celulares, notebooks e tablets. Garantia de qualidade!',
        images: [
          'https://picsum.photos/600/400?random=40',
        ],
        videoUrl: [
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
        ],
        likes: 45,
        isLiked: true,
      ),
    ];

    setState(() {
      _posts.addAll(initialPosts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          // Cada item da lista é um card de serviço
          return ServiceProviderFeed(post: _posts[index]);
        },
      ),
    );
  }
}

/// Widget responsável por exibir um card de postagem (com mídia, descrição, etc)
class ServiceProviderFeed extends StatelessWidget {
  final ServicePostFeed post;

  const ServiceProviderFeed({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final hasVideo = post.videoUrl != null && post.videoUrl!.isNotEmpty;
    final hasImages = post.images != null && post.images!.isNotEmpty;

    // Lista que conterá as mídias do carrossel (imagens e/ou vídeos)
    List<Widget> carouselItems = [];

    // Se tiver vídeo, adiciona ao carrossel
    if (hasVideo) {
      carouselItems.add(_CarouselVideoItem(videoUrl: post.videoUrl![0]));
    }

    // Se tiver imagens, adiciona ao carrossel também
    if (hasImages) {
      carouselItems.addAll(
        post.images!.map((url) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          );
        }),
      );
    }

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
            builder: (_) => PerfilDeOutroUsuario(),
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
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          post.providerCompany!,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
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
                      post.description ?? "",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.fullDescription != null)
                    InkWell(
                      onTap: () {
                        // Abre a tela "Ver Mais"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerMaisPage(post: post.toDetail()),
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
