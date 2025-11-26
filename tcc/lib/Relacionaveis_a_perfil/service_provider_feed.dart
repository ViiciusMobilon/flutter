import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:video_player/video_player.dart';

class ServiceProviderFeed extends StatefulWidget {
  final Portfolio post;
   

  ServiceProviderFeed({
    super.key,
    required this.post,

  });

  @override
  State<ServiceProviderFeed> createState() => _ServiceProviderFeedState();
}

class _ServiceProviderFeedState extends State<ServiceProviderFeed> {

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.usuario;
    final fotoUrl = user?.fotoURL != null 
        ? '${user?.fotoURL}'
        : 'https://via.placeholder.com/150';
    print('foto perfil card:: ${fotoUrl}');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user, fotoUrl),
          if (widget.post.descricao != null && widget.post.descricao!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.post.descricao!,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          if (widget.post.fotos!.isNotEmpty) _buildImageGallery(widget.post),
          if (widget.post.videos!.isNotEmpty) _buildVideoGallery(widget.post),
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
      itemCount: post.fotos!.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final imageUrl = '${URLAPISTORAGE}${post.fotos![index].url}' ;
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
        itemCount: post.videos!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final videoUrl = '${URLAPISTORAGE}${post.videos![index].url}';
          print('url video portfolio:${videoUrl}');

          return VideoItem(url: videoUrl);
        },
      ),
    );
  }
}




class VideoItem extends StatefulWidget {
  final String url;
  const VideoItem({required this.url, super.key});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Atualiza a interface após inicialização
        _controller.setLooping(true); // Faz o vídeo repetir
        _controller.play(); // Se quiser autoplay
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(
        width: 200,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      width: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

