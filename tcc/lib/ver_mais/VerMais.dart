import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/models/user_public/post_user.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';

class VerMaisPage extends StatelessWidget {
  final PortfolioUser? postUser;
  final Portfolio? post;

  const VerMaisPage({
    super.key,
    this.postUser,
    this.post,
  }) : assert(postUser != null || post != null);

  @override
  Widget build(BuildContext context) {
    // Se vier PortfolioUser
    final fotosUser = postUser?.fotos ?? [];
    final videosUser = postUser?.videos ?? [];

    // Se vier Portfolio (modelo novo do feed)
    final fotos = post?.fotos ?? [];
    final videos = post?.videos ?? [];

    // Junta os dois ORIGENS, mas mantendo foto/vídeo separados
    final allFotos = [...fotosUser, ...fotos];
    final allVideos = [...videosUser, ...videos];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Veja mais"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (allFotos.isNotEmpty) ...[
            const Text(
              "Fotos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // GALERIA DE FOTOS
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allFotos.map((fotoObj) {
                final foto = fotoObj as dynamic;

                final fotoUrl = foto.url ?? foto.foto ?? "";

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '${URLAPISTORAGE}$fotoUrl',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
          ],

          if (allVideos.isNotEmpty) ...[
            const Text(
              "Vídeos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // LISTA DE VÍDEOS
            Column(
              children: allVideos.map((video) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
