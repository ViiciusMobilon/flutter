import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/data/models/postForm.dart';
import 'package:video_player/video_player.dart';

class Midia {
  final String? url; // pode ser local ou remoto
  final File? arquivo;
  final bool isVideo;
  VideoPlayerController? controller;

  Midia({this.url, this.arquivo, required this.isVideo, this.controller});
}

class EditarPostPage extends StatefulWidget {
  // final Portfolio post;

  const EditarPostPage({Key? key}) : super(key: key);

  @override
  State<EditarPostPage> createState() => _EditarPostPageState();
}

class _EditarPostPageState extends State<EditarPostPage> {
  final TextEditingController _descricaoController = TextEditingController();
  List<Midia> _midias = [];
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  bool _isLoading = false;
  late Portfolio? _portfolio;

  @override
  void initState() {
    super.initState();
    final _portfolioController = context.read<PortfolioController>();
    _portfolio = _portfolioController.post; 
    _descricaoController.text = _portfolio!.descricao ?? '';

    // Inicializa fotos existentes
    if (_portfolio != null) {
      if(_portfolio!.fotos != null && _portfolio!.fotos!.isNotEmpty){
        for (var fotos in _portfolio!.fotos!) {
          final url = '${URLAPISTORAGE}${fotos.url}';
          _midias.add(Midia(isVideo: false, url: url));
        }
      }
    }

    // Inicializa videos existentes
    if (_portfolio != null) {
      if(_portfolio!.videos != null && _portfolio!.videos!.isNotEmpty){
        for (var videos in _portfolio!.videos!) {
          final url = '${URLAPISTORAGE}${videos.url}';
          final controller = VideoPlayerController.network(url)
          ..initialize().then((_){
            if(mounted) setState(() {});
          });
          _midias.add(Midia(isVideo: true, url: url, controller: controller));
        }
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

  // ignore: unused_element
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

  Future<void> _salvarAlteracoes(TextEditingController descricao, List<File?> foto, List<File?> video, {required int id}) async {
    try {
          if (descricao.text.isEmpty && foto.isEmpty && video.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite algo ou selecione uma mídia"),
          backgroundColor: Colors.red,
        ),
      );
      return;
      }
      final form = Postform();

      form.descricao = descricao.text;
      form.foto = foto;
      form.video = video;
      print("form debug: ${form.descricao}");

      setState(() => _isLoading = true);

      // Simula delay de salvamento
      await Future.delayed(const Duration(seconds: 1));

      final portfolioController = context.read<PortfolioController>();

      final postEdit = await portfolioController.updade(idPost: id, form);
      print("POst: ${form.toString()} e id${id}");
      

      setState(() => _isLoading = false);
      if (postEdit != null) {
      print("POst: ${form.toString()} e id${id}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Post atualizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context, true);
      }

      

      
    } catch (e) {
      print("Erro ao atualizar post: ${e}");
    }
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
    final postForm = Postform();
    final postId = _portfolio!.id;

    postForm.descricao = _descricaoController.text;
    final foto = _midias.where((m) => !m.isVideo).map((m) => m.arquivo).toList();
    final video = _midias.where((m) => m.isVideo).map((m) => m.arquivo).toList();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Post"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _isLoading ? null : _salvarAlteracoes(id: postId!, _descricaoController,foto, video ),
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
