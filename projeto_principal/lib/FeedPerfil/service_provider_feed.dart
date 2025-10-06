import 'package:flutter/widgets.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';
import 'package:projeto_principal/data/models/post.dart';

class ServiceProviderFeed extends StatelessWidget {
  final Portfolio post;
  final AuthController authController;
   

   ServiceProviderFeed({required this.post, super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final user = authController.usuario;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "http://192.168.1.8:8000${user?.foto ?? ''}"),
            ),
            title: Text(user?.nome ?? 'Usuário'),
            subtitle: Text(user?.ramoNome ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.descricao ?? ''),
          ),
          if (post.fotos.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.fotos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(
                        "http://192.168.1.8:8000${post.fotos[index].url}"),
                  );
                },
              ),
            ),
          if (post.videos.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.videos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: VideoPlayerWidget(
                        url: "http://192.168.1.8:8000${post.videos[index].url}"),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
