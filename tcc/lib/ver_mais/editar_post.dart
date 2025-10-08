import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/service_post.dart';

class Midia {
  final String? url; // pode ser local ou remoto
  final File? arquivo;
  final bool isVideo;
  VideoPlayerController? controller;

  Midia({this.url, this.arquivo, required this.isVideo, this.controller});
}

class EditarPostPage extends StatefulWidget {
  final ServicePost post;

  const EditarPostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<EditarPostPage> createState() => _EditarPostPageState();
}

class _EditarPostPageState extends State<EditarPostPage> {
  final TextEditingController _descricaoController = TextEditingController();
  List<Midia> _midias = [];
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descricaoController.text = widget.post.description ?? '';

    // Inicializa mídias existentes
    if (widget.post.mediaUrls != null) {
      for (var url in widget.post.mediaUrls!) {
        bool isVideo = url.toLowerCase().endsWith('.mp4') ||
            url.toLowerCase().endsWith('.mov') ||
            url.toLowerCase().endsWith('.avi');
        VideoPlayerController? controller;
        if (isVideo) {
          controller = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
        }
        _midias.add(Midia(url: url, isVideo: isVideo, controller: controller));
      }
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _midias.forEach((m) => m.controller?.dispose());
    _pageController.dispose();
    super.dispose();
  }

  bool _isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.avi');
  }

  Future<void> _adicionarImagem() async {
    final XFile? imagem =
        await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (imagem != null) {
      setState(() {
        _midias.add(Midia(arquivo: File(imagem.path), isVideo: false));
      });
    }
  }

  Future<void> _adicionarVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
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
    _midias[index].controller?.dispose();
    setState(() {
      _midias.removeAt(index);
    });
  }

  Future<void> _salvarAlteracoes() async {
    if (_descricaoController.text.isEmpty && _midias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite algo ou selecione uma mídia"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simula delay de salvamento
    await Future.delayed(const Duration(seconds: 1));

    // Atualiza post
    final updatedPost = widget.post.copyWith(
      description: _descricaoController.text,
      mediaUrls: _midias.map((m) => m.arquivo?.path ?? m.url!).toList(),
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post atualizado com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, updatedPost);
  }

  Widget _buildMidiaItem(Midia midia, int index) {
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
              : midia.arquivo != null
                  ? Image.file(midia.arquivo!, fit: BoxFit.cover)
                  : Image.network(midia.url!, fit: BoxFit.cover),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _removerMidia(index),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _salvarAlteracoes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                 
                  const SizedBox(height: 16),
                  if (_midias.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _midias.length,
                        itemBuilder: (context, index) =>
                            _buildMidiaItem(_midias[index], index),
                      ),
                    ),
                  const SizedBox(height: 16),
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
                      const Text("Adicionar mídia"),
                    ],
                  ),
                   TextField(
                    maxLength: 280,
                    controller: _descricaoController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: "Descrição",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
