import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/ver_mais/VerMais.dart';

// ------------------------ FEED DE PORTFÓLIO ------------------------
class FeedPerfilPortfolio extends StatefulWidget {
  final AuthController authController;

  const FeedPerfilPortfolio({super.key, required this.authController});

  @override
  State<FeedPerfilPortfolio> createState() => _FeedPerfilPortfolioState();
}

class _FeedPerfilPortfolioState extends State<FeedPerfilPortfolio> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() => context.read<PortfolioController>().fetchPortfolio());
  }

  void _onScroll() {
    final controller = context.read<PortfolioController>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolioController = context.watch<PortfolioController>();
    final portfolios = portfolioController.portfolios;

    if (portfolioController.loading && portfolios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (portfolios.isEmpty) {
      return const Center(child: Text("Nenhum serviço encontrado."));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: portfolios.length,
      itemBuilder: (context, index) {
        final post = portfolios[index];

        return ServiceProviderFeedPortfolio(
          post: post,
          authController: widget.authController,
        );
      },
    );
  }
}

// ------------------------ CARD DE PORTFÓLIO ------------------------
class ServiceProviderFeedPortfolio extends StatelessWidget {
  final Portfolio post;
  final AuthController authController;

  const ServiceProviderFeedPortfolio({
    super.key,
    required this.post,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    final user = authController.usuario;
    final fotoUrl = user?.fotoURL ?? 'https://via.placeholder.com/150';

    List<Widget> carouselItems = [];

    // Vídeos
    if (post.videos.isNotEmpty) {
      for (var v in post.videos) {
        carouselItems.add(_CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}'));
      }
    }

    // Fotos
    carouselItems.addAll(post.fotos.map((f) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            '${URLAPISTORAGE}${f.url}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 40)),
          ),
        ),
      );
    }));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(fotoUrl),
              radius: 25,
            ),
            title: Text(user?.nome ?? 'Usuário', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user?.ramoNome ?? '', style: const TextStyle(color: Colors.grey)),
          ),

          // Descrição
          if (post.descricao != null && post.descricao!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                post.descricao!,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),

          // Carrossel de fotos e vídeos
          if (carouselItems.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(height: 240, viewportFraction: 1.0, enableInfiniteScroll: false),
              items: carouselItems,
            ),

          // Botão "Ver mais"
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Container()),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VerMaisPage(post: post),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A202C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver mais',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 16),
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

// ------------------------ COMPOSANTE DE VÍDEO ------------------------
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
      ..initialize().then((_) => setState(() {}));
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
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Center(
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white70,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
