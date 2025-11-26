import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/models/user_public/post_user.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/ver_mais/VerMais.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/config.dart';

// ------------------------ CARD DE PORTFÓLIO ------------------------
class FeedPerfilUser extends StatelessWidget {
  final PortfolioUser? post;
  final UsuarioPublic? user;

  FeedPerfilUser({
    super.key,
    this.post,
    this.user
  });

  @override
  Widget build(BuildContext context) {
    print('estou no feed do outro user nome: ${post?.user_nome}');
    print('estou no feed do outro user desc: ${post?.descricao}');
    print('estou no feed do outro user nome user: ${user?.dados.nome}');
    
    // ✅ Use os dados do dono do post, não do user logado
    final fotoUrl = user?.dados.foto != null 
        ? '${URLAPISTORAGE}''/storage/''${user?.dados.foto}'
        : 'https://via.placeholder.com/150';
        print('foto: ${fotoUrl}');

    // 🔹 Lista de imagens e vídeos para o carrossel
    List<Widget> carouselItems = [];

    // Vídeos
    if (post?.videos?.isNotEmpty ?? false) {
      for (var v in post!.videos!) {
        carouselItems.add(
          _CarouselVideoItem(videoUrl: '${URLAPISTORAGE}${v.url}')
        );
      }
    }

    // Fotos
    if (post?.fotos?.isNotEmpty ?? false) {
      carouselItems.addAll(post!.fotos!.map((f) {
        print('card perfil:${URLAPISTORAGE}''${f.url}');
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            '${URLAPISTORAGE}''${f.url}',
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Center(child: Icon(Icons.broken_image, size: 40)),
          ),
        );
      }));
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Cabeçalho com nome e foto do DONO DO POST
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(fotoUrl),
              radius: 25,
            ),
            title: Text(
              user?.dados.nome ?? 'Usuário', // ✅ Nome do dono do post
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post?.user_ramo ?? '', // ✅ Ramo do dono do post
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
          if (post?.descricao?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                post!.descricao!,
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
                      builder: (context) => VerMaisPage(postUser: post!),
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
          ),
        ],
      ),
    );
  }
}
// widget para mostrar um vídeo no carrossel
class _CarouselVideoItem extends StatefulWidget {
  final String videoUrl;
  const _CarouselVideoItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<_CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<_CarouselVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..setLooping(true)
      ..setVolume(0.0) // mudo por padrão
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _isInitializing = false);
        _controller?.play();
      }).catchError((err) {
        // opcional: trate erro aqui
        if (mounted) setState(() => _isInitializing = false);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // altura do carrossel no seu código é 240
    const double height = 240;
    if (_isInitializing) {
      return SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return SizedBox(
        height: height,
        child: const Center(child: Icon(Icons.error)),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ajusta para preencher mantendo a proporção
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),

            // Overlay sutil (opcional)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(_controller!.value.isPlaying ? 0.0 : 0.15),
              ),
            ),

            // Ícone de play/pause central (pequeno)
            Center(
              child: AnimatedOpacity(
                opacity: _controller!.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
