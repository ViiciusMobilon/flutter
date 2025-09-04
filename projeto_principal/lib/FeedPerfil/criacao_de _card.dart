import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Midia {
  final File arquivo;
  final bool isVideo;
  VideoPlayerController? controller;

  Midia({required this.arquivo, required this.isVideo, this.controller});
}

class NovoPostPage extends StatefulWidget {
  const NovoPostPage({super.key});

  @override
  State<NovoPostPage> createState() => _NovoPostPageState();
}

class _NovoPostPageState extends State<NovoPostPage> with WidgetsBindingObserver {
  final TextEditingController _postController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Midia> _midias = [];
  bool _tecladoAberto = false;
  bool _abrindoGaleria = false;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _postController.dispose();
    for (var midia in _midias) {
      midia.controller?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final estavaAberto = _tecladoAberto;
    _tecladoAberto = bottomInset > 0.0;

    if (estavaAberto && !_tecladoAberto && !_abrindoGaleria) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _adicionarImagem() async {
    _abrindoGaleria = true;
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    _abrindoGaleria = false;

    if (imagem != null) {
      setState(() {
        _midias.add(Midia(arquivo: File(imagem.path), isVideo: false));
      });
    }
  }

  Future<void> _adicionarVideo() async {
    _abrindoGaleria = true;
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    _abrindoGaleria = false;

    if (video != null) {
      final controller = VideoPlayerController.file(File(video.path));
      await controller.initialize();
      controller.play();

      setState(() {
        _midias.add(Midia(arquivo: File(video.path), isVideo: true, controller: controller));
      });
    }
  }

  void _removerMidia(int index) {
    final midia = _midias[index];
    midia.controller?.dispose();
    setState(() {
      _midias.removeAt(index);
    });
  }

  void _publicarPost() {
    if (_postController.text.isEmpty && _midias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite algo ou selecione uma mídia"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post publicado!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, "post_publicado");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Novo Post",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: _publicarPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Postar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Campo de texto
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      focusNode: _focusNode,
                      maxLength: 280,
                      maxLines: null,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "O que está acontecendo?",
                        hintStyle: TextStyle(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Carrossel de mídias
              if (_midias.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _midias.length,
                    itemBuilder: (context, index) {
                      final midia = _midias[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: midia.isVideo
                                ? midia.controller != null && midia.controller!.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio: midia.controller!.value.aspectRatio,
                                        child: VideoPlayer(midia.controller!),
                                      )
                                    : const Center(child: CircularProgressIndicator())
                                : Image.file(
                                    midia.arquivo,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _removerMidia(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              // Botões de adicionar mídia
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.blue),
                    onPressed: _adicionarImagem,
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.blue),
                    onPressed: _adicionarVideo,
                  ),

                  Text("Role para o lado para ver as mídias",
                   style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: const Color.fromARGB(255, 8, 8, 8),
                        fontFamily: "Poppins",
                      ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
