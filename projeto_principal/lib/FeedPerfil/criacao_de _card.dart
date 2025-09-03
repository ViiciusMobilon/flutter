import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NovoTweetPage extends StatefulWidget {
  const NovoTweetPage({super.key});

  @override
  State<NovoTweetPage> createState() => _NovoTweetPageState();
}

class _NovoTweetPageState extends State<NovoTweetPage> {
  final TextEditingController _tweetController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _imagemSelecionada;
  bool _tecladoAberto = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    _focusNode.dispose();
    _tweetController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final estavaAberto = _tecladoAberto;
    _tecladoAberto = bottomInset > 0.0;

    if (estavaAberto && !_tecladoAberto) {
      // teclado fechado
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // você pode decidir fechar ou não, aqui deixei comentado
          // Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  void _publicarTweet() {
    if (_tweetController.text.isEmpty && _imagemSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite algo ou selecione uma imagem"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Aqui você implementaria a lógica de publicação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Tweet publicado!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, "tweet_publicado");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Novo Tweet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _publicarTweet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Tweet"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3"), // foto do usuário
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _tweetController,
                    focusNode: _focusNode,
                    maxLength: 280,
                    maxLines: null,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "O que está acontecendo?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            if (_imagemSelecionada != null) ...[
              const SizedBox(height: 12),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imagemSelecionada!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _imagemSelecionada = null;
                        });
                      },
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
                  )
                ],
              ),
            ],
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: _selecionarImagem,
                ),
                // Você pode adicionar outros ícones (GIF, enquete, emoji)
              ],
            )
          ],
        ),
      ),
    );
  }
}
