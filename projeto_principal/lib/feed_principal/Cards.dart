import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    _loadMorePosts(); // carregamento inicial
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

    // Simula um delay (poderia ser API de verdade)
    await Future.delayed(const Duration(seconds: 2));

    List<ServicePost> newPosts = List.generate(5, (index) {
      int id = _posts.length + index + 1;
      return ServicePost(
        id: id.toString(),
        provider: Provider(
          name: "Prestador $id",
          company: "Empresa $id",
          avatar: "https://via.placeholder.com/150",
          rating: 4.5,
          reviewCount: 50,
        ),
        images: ["https://via.placeholder.com/300x200?text=Post+$id"],
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

    return ListView.builder(
      controller: _scrollController,
  physics: const BouncingScrollPhysics(), // ou ClampingScrollPhysics()
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
    );
  }
}

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

class ServiceProviderFeed extends StatelessWidget {
  final ServicePost post;

  const ServiceProviderFeed({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.provider.avatar),
              radius: 28,
            ),
            title: Text(
              post.provider.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Empresa: ${post.provider.company}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("• ${post.location}"),
              ],
            ),
          ),

          // Imagens
          if (post.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: CarouselSlider(
  options: CarouselOptions(
    height: 200,
    enlargeCenterPage: true,
    enableInfiniteScroll: false,
    autoPlay: false,
    viewportFraction: 0.9,
    scrollPhysics: const BouncingScrollPhysics(), // força o scroll horizontal
  ),
  items: post.images.map((img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        img,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }).toList(),
              )),

          // Descrição
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

final List<ServicePost> servicePosts = List.generate(5, (index) {
  return ServicePost(
    id: "$index",
    provider: Provider(
      name: "Profissional $index",
      company: "Empresa $index",
      avatar: "https://picsum.photos/100/100?random=$index",
      rating: 4.5,
      reviewCount: 20 + index,
    ),
    // Cada post vai ter 3 imagens diferentes
   images: List.generate( 3, (imgIndex) => "https://picsum.photos/400/200?random=${index * 3 + imgIndex}", ),

    description: "Descrição curta do serviço $index...",
    fullDescription: "Descrição detalhada do serviço $index...",
    category: "Categoria $index",
    location: "Cidade $index",
    completedAt: "2025-10-01",
    likes: index * 5,
    isLiked: false,
  );
});

