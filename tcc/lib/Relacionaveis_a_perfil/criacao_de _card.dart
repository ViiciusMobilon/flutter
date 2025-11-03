import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/models/postForm.dart';
import 'package:video_player/video_player.dart';

class Midia {
  final File arquivo;
  final bool isVideo;
  VideoPlayerController? controller;

  Midia({required this.arquivo, required this.isVideo, this.controller});
}

class NovoPostPage extends StatefulWidget {
   
  final String? foto;

  NovoPostPage({super.key, this.foto,  });

  @override
  State<NovoPostPage> createState() => _NovoPostPageState();
}

class _NovoPostPageState extends State<NovoPostPage> with WidgetsBindingObserver {
  final PortfolioController portfolioController = PortfolioController();
  final Postform postForm = Postform();
  final TextEditingController _descController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Midia> _midias = [];
  bool _tecladoAberto = false;
  bool _abrindoGaleria = false;
  bool _fechandoManualmente = false; // Flag para controlar fechamento manual

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
    _descController.dispose();
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

    // Só fecha automaticamente se não estiver fechando manualmente
    if (estavaAberto && !_tecladoAberto && !_abrindoGaleria && !_fechandoManualmente) {
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

  void _publicarPost() async {
    if (_descController.text.isEmpty && _midias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite algo ou selecione uma mídia"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    postForm.descricao = _descController.text;

    postForm.foto = _midias.where((m) => !m.isVideo).map((m) => m.arquivo).toList();
    postForm.video = _midias.where((m) => m.isVideo).map((m) => m.arquivo).toList();
    
    try {
      final postFinal = await portfolioController.create(postForm);

      // ignore: unnecessary_null_comparison
      if (postFinal != null) {
        context.read<PortfolioController>().fetchPortfolioAuth();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Post publicado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      print('erro post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao publicar post: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    _fechandoManualmente = true; // Marca como fechamento manual
    Navigator.pop(context, "post_publicado");
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.usuario;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _fechandoManualmente = true; // Marca como fechamento manual
              Navigator.pop(context);
            },
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: (user!.fotoURL != null)
                        ? NetworkImage(user.fotoURL!)
                        : null,
                    child: (user.fotoURL == null || user.fotoURL!.isEmpty)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _descController,
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
                                  color: Colors.white,
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
                  Text(
                    "Role para o lado para ver as mídias",
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