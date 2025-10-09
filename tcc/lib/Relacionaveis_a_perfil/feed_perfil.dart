import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:tcc/service_post.dart';

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
    _loadMorePosts();
  }

  void _loadMorePosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    List<ServicePostFeed> newPosts = List.generate(3, (index) {
      int id = _posts.length + index + 1;

      List<String> imageUrls = List.generate(
        3,
        (imgIndex) =>
            "https://picsum.photos/600/400?random=${id * 100 + imgIndex}",
      );

      String videoUrl =
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

      return ServicePostFeed(
        id: id.toString(),
        providerName: "Prestador $id",
        providerCompany: "Empresa $id",
        providerAvatar: "https://picsum.photos/100/100?random=$id",
        location: "Cidade $id",
        description: "Descrição breve do serviço $id...",
        fullDescription: "Descrição completa do serviço $id...",
        images: imageUrls,
        videoUrl: [videoUrl],
        likes: 0,
        isLiked: false,
      );
    });

    setState(() {
      _posts.addAll(newPosts);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_posts.isEmpty && !_isLoading) {
      return const Center(child: Text("Nenhum serviço encontrado."));
    }

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
                                VerMaisPage(post: post.toDetail()),
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
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Center(
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
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

import 'package:flutter/material.dart';

class feedperfil extends StatelessWidget {
  final ServicePost post;

  const feedperfil({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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
          // Header com informações do prestador
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar com borda
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(post.provider.avatar),
                    radius: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Informações
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.provider.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post.provider.company,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFF718096),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
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

          // Grid de Imagens
          if (post.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageGrid(context),
              ),
            ),

          // Descrição
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A5568),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Footer com categoria, rating e botão
                Row(
                  children: [
                    // Badge de Categoria
                   

                    const Spacer(),

                    // Botão Ver Mais
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Ação ao clicar em "Ver mais"
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Constrói o grid de imagens de forma inteligente
  Widget _buildImageGrid(BuildContext context) {
    final imageCount = post.images.length;
    
    if (imageCount == 1) {
      // Uma imagem: ocupa toda a largura
      return Image.network(
        post.images[0],
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
      );
    } else if (imageCount == 2) {
      // Duas imagens: lado a lado
      return Row(
        children: [
          Expanded(
            child: Image.network(
              post.images[0],
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Image.network(
              post.images[1],
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    } else if (imageCount == 3) {
      // Três imagens: uma grande + duas pequenas
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              post.images[0],
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Image.network(
                  post.images[1],
                  height: 118,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 4),
                Image.network(
                  post.images[2],
                  height: 118,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Quatro ou mais imagens: grid 2x2 com contador
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Image.network(
                  post.images[0],
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Image.network(
                  post.images[1],
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Image.network(
                  post.images[2],
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Stack(
                  children: [
                    Image.network(
                      post.images[3],
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    if (imageCount > 4)
                      Container(
                        height: 120,
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            '+${imageCount - 4}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

// ---------------------
// 🔹 MODELOS
// ---------------------
class ServicePost {
  final String id;
  final Provider provider;
  final List<String> images;
  final String description;
  final String fullDescription;
  final String category;
  final String location;
  final String completedAt;
  int likes;
  bool isLiked;

  ServicePost({
    required this.id,
    required this.provider,
    required this.images,
    required this.description,
    required this.fullDescription,
    required this.category,
    required this.location,
    required this.completedAt,
    required this.likes,
    required this.isLiked,
  });
}

class Provider {
  final String name;
  final String company;
  final String avatar;
  final double rating;
  final int reviewCount;

  Provider({
    required this.name,
    required this.company,
    required this.avatar,
    required this.rating,
    required this.reviewCount,
  });
}