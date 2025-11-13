import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/config.dart';

// ------------------------ CARD DE PORTFÓLIO ------------------------
class FeedPerfilPortfolio extends StatelessWidget {
  final Portfolio post;

  const FeedPerfilPortfolio({
    super.key,
    required this.post,

  });

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    final user = authController.usuario;
    final fotoUrl = user?.fotoURL ?? 'https://via.placeholder.com/150';

    // 🔹 Lista de imagens e vídeos para o carrossel
    List<Widget> carouselItems = [];

    // Vídeos
    if (post.videos!.isNotEmpty) {
      for (var v in post.videos!) {
        carouselItems.add(_CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}'));
      }
    }

    // Fotos
    carouselItems.addAll(post.fotos!.map((f) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          '${URLAPISTORAGE}${f.url}',
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image, size: 40)),
        ),
      );
    }));

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Cabeçalho com nome e foto do usuário
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(fotoUrl),
              radius: 25,
            ),
            title: Text(
              user?.nome ?? 'Usuário',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user?.ramoNome ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

        
          // 🔹 Carrossel de imagens/vídeos
          if (carouselItems.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 240,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
              ),
              items: carouselItems,
            ),
          // 🔹 Descrição do post
          if (post.descricao != null && post.descricao!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    post.descricao!,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
            

          // 🔹 Botão "Ver mais"
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),  ],
            ),
        ],
      ),
    );
  }
}

// ------------------------ COMPONENTE DE VÍDEO ------------------------
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: const Color(0xB3FFFFFF),
            size: 50,
      ),
        ],
      ),
    );
  }
}
