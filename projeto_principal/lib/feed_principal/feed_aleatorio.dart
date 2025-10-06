import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_principal/main.dart';
import 'package:projeto_principal/paginas%20principais/pagina_principal.dart';
import 'package:video_player/video_player.dart';

class AleatorioFeed extends StatefulWidget {
  const AleatorioFeed({super.key});

  @override
  State<AleatorioFeed> createState() => _AleatorioFeedState();
}

class _AleatorioFeedState extends State<AleatorioFeed> {
  final List<ServicePost> _posts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadMorePosts();
      }
    });
  }

  void _loadMorePosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    List<ServicePost> newPosts = List.generate(3, (index) {
      int id = _posts.length + index + 1;

      // Gera até 50 imagens aleatórias do Picsum
      List<String> imageUrls = List.generate(
        50,
        (imgIndex) => "https://picsum.photos/600/400?random=${id * 100 + imgIndex}",
      );

      return ServicePost(
        id: id.toString(),
        provider: Provider(
          name: "Prestador $id",
          company: "Empresa $id",
          avatar: "https://picsum.photos/100/100?random=$id",
          rating: 4.5,
          reviewCount: 50,
        ),
        images: imageUrls,
        description: "Descrição breve do serviço $id...",
        fullDescription: "Descrição completa do serviço $id...",
        category: "Categoria $id",
        location: "Cidade $id",
        completedAt: "2025-01-0$id",
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
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return ServiceProviderFeed(post: _posts[index]);
          } else {
            return _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class ServicePost {
  final String id;
  final Provider provider;
  final List<String> images; // URLs de imagens/vídeos
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

class ServiceProviderFeed extends StatelessWidget {
  final ServicePost post;

  const ServiceProviderFeed({super.key, required this.post});

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
          // Cabeçalho
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.provider.avatar),
                  radius: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.provider.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post.provider.company,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(post.location, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Carrossel de até 50 mídias
          if (post.images.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 240,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                scrollPhysics: const BouncingScrollPhysics(),
              ),
              items: post.images.map((mediaUrl) {
                // Aqui no futuro dá pra verificar se é vídeo
                // if (mediaUrl.endsWith(".mp4")) => widget de vídeo
                return ClipRRect(
               
                  child: Image.network(
                    mediaUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                );
              }).toList(),
            ),

          // Descrição
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  post.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const Spacer(),
                 GestureDetector(
                  onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => TelaPrincipal())),
                   child: Material( color: Colors.transparent, child: InkWell( onTap: () {  }, borderRadius: BorderRadius.circular(20), child: Container( padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 8, ), decoration: BoxDecoration( color: const Color(0xFF1A202C), borderRadius: BorderRadius.circular(20), ), child: Row( mainAxisSize: MainAxisSize.min, children: const [ Text( 'Ver mais', style: TextStyle( color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, ), ), SizedBox(width: 4), Icon( Icons.arrow_forward, color: Colors.white, size: 16,
                             ) ],
                         ),
                   ))),
                 )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
