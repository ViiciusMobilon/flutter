import 'package:flutter/material.dart';
import 'package:projeto_principal/data/repositories/portfolio_repository.dart';
import 'package:projeto_principal/data/services/portfolio_service.dart';
import 'package:video_player/video_player.dart';

class TesteVideo extends StatefulWidget{
  @override
  State<TesteVideo> createState() => _TesteVideoState();
}

class _TesteVideoState extends State<TesteVideo>{
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'http://192.168.1.8:8000/storage/fotos/portfolio/59ywFkbo8me4bxNsG0hnPN6EasmMQVnI2CyfKKMk.mp4',
    )..initialize().then((_) {
        setState(() {}); // Atualiza a interface após a inicialização do vídeo
        PortfolioService();
        PortfolioRepository();

      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),

    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}