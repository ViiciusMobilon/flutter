import 'package:flutter/material.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';
import 'package:projeto_principal/data/models/post.dart';

class ServiceProviderFeed extends StatelessWidget {
  final Portfolio post;
  final AuthController authController;

  ServiceProviderFeed({
    super.key,
    required this.post,
    required this.authController,
  });

  static const String _baseUrl = "http://172.20.192.1:8000";

  @override
  Widget build(BuildContext context) {
    final user = authController.usuario;
    final fotoUrl = user?.foto != null 
        ? '${user?.foto}'
        : 'https://via.placeholder.com/150';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user, fotoUrl),
          if (post.descricao != null && post.descricao!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                post.descricao!,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          if (post.fotos.isNotEmpty) _buildImageGallery(post),
          if (post.videos.isNotEmpty) _buildVideoGallery(post),
        ],
      ),
    );
  }

  /// Cabeçalho do card com nome, ramo e foto do usuário
  Widget _buildHeader(user, String fotoUrl) {
    return ListTile(
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
    );
  }

  /// Galeria de fotos horizontal
  Widget _buildImageGallery(Portfolio post) {
  return SizedBox(
    height: 250, // altura visível do carrossel
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      itemCount: post.fotos.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final imageUrl = '$_baseUrl${post.fotos[index].url}';
        print('url foto portfolio:${imageUrl}');
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width *
                  0.83, 
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
            ),
          ),
        );
      },
    ),
  );
}


  /// Galeria de vídeos horizontal
  Widget _buildVideoGallery(Portfolio post) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: post.videos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final videoUrl = '$_baseUrl${post.videos[index].url}';
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
          );
        },
      ),
    );
  }
}
