import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tcc/main.dart' show Main;

class FeedPerfil extends StatelessWidget {
  final ServicePost post;

  const FeedPerfil({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final limitedMedia = post.images.take(50).toList(); // 🔹 Máximo 50 mídias

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
          // 🔹 Cabeçalho do prestador
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
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

          // 🔹 Carrossel de imagens/vídeos
          if (limitedMedia.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 260,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: limitedMedia.length > 1,
                    viewportFraction: 1.0,
                    autoPlay: limitedMedia.length > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                  ),
                  items:
                      limitedMedia.map((mediaUrl) {
                        final isVideo =
                            mediaUrl.endsWith('.mp4') ||
                            mediaUrl.endsWith('.mov') ||
                            mediaUrl.endsWith('.avi');

                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              color:
                                  Colors
                                      .grey[200], // fundo neutro enquanto carrega
                              child:
                                  isVideo
                                      ? Center(
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 64,
                                        ),
                                      )
                                      : Image.network(
                                        mediaUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ),
            ),

          // 🔹 Descrição e botão "Ver mais"
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
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap:
                          () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Main()),
                          ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Main(),
                                  ),
                                ),
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
