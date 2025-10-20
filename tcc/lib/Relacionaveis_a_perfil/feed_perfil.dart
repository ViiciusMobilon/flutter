import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/ver_mais/VerMaisDono.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:tcc/service_post.dart';

// ------------------------ FEED DE PERFIL ------------------------
class FeedPerfil extends StatefulWidget {
  final Portfolio post;
  final AuthController authController;
  FeedPerfil({super.key, required this.post, required this.authController});

  @override
  State<FeedPerfil> createState() => _FeedPerfilState();
}

// class _FeedPerfilState extends State<FeedPerfil> {
//   // final List<ServicePostFeed> _posts = [];
//   // bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // _loadMorePosts();
//   }

//   // void _loadMorePosts() async {
//   //   setState(() => _isLoading = true);
//   //   await Future.delayed(const Duration(seconds: 2));

//   //   List<ServicePostFeed> newPosts = List.generate(3, (index) {
//   //     int id = _posts.length + index + 1;

//   //     List<String> imageUrls = List.generate(
//   //       3,
//   //       (imgIndex) => "https://picsum.photos/600/400?random=${id * 100 + imgIndex}",
//   //     );

//   //     String videoUrl = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

//   //     return ServicePostFeed(
//   //       id: id.toString(),
//   //       providerName: "Prestador $id",
//   //       providerCompany: "Empresa $id",
//   //       providerAvatar: "https://picsum.photos/100/100?random=$id",
//   //       location: "Cidade $id",
//   //       description: "Descrição breve do serviço $id...",
//   //       fullDescription: "Descrição completa do serviço $id...",
//   //       images: imageUrls,
//   //       videoUrl: [videoUrl],
//   //       likes: 0,
//   //       isLiked: false,
//   //     );
//   //   });

//   //   setState(() {
//   //     _posts.addAll(newPosts);
//   //     _isLoading = false;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (_posts.isEmpty && !_isLoading) {
//       return const Center(child: Text("Nenhum serviço encontrado."));
//     }

//     return Container(
//       color: const Color(0xFFF5F7FA),
//       child: Column(
//         children: [
//           for (var post in _posts) ServiceProviderFeed(post: widget.post, authController: widget.authController,),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }
// }

// ------------------------ COMPONENTE DE CADA CARD ------------------------
class _FeedPerfilState extends State<FeedPerfil> {

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.usuario;
    final post = widget.post;
    List<Widget> carouselItems = [];
    //videos
    if (post.videos.isNotEmpty) {
      for (var v in post.videos) {
        carouselItems.add(_CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}'));
      }
    }

    //fotos
     carouselItems.addAll(post.fotos.map((f) {
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
        onTap: () => Navigator.of(context).push(
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
                    backgroundImage: NetworkImage(user!.fotoURL!),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nome!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.nome ?? user.razao_social ?? 'sem nome',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                user.cidade!,
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

            // Carrossel
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
                      post.descricao!,
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
                            builder: (context) => VerMaisPageDono(post: post, authController: widget.authController,),
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
                ],
              ),
            ),
          ],
        ),
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
