import 'package:flutter/material.dart';

class feedperfil extends StatelessWidget {
  final ServicePost post;

  const feedperfil({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
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
                Text("Empresa: ${post.provider.company}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${post.category} • ${post.location}"),
              ],
            ),
          ),

          // 🔹 Imagens
          if (post.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.images
                    .map((img) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            img,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
            ),

          // 🔹 Descrição
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
