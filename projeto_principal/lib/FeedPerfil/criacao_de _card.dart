import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroCardPage extends StatefulWidget {
  const CadastroCardPage({super.key});

  @override
  State<CadastroCardPage> createState() => _CadastroCardPageState();
}

class _CadastroCardPageState extends State<CadastroCardPage> {
  final TextEditingController nomeController = TextEditingController();
  File? imagemSelecionada;



  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        imagemSelecionada = File(imagem.path);
      });
    }
  }

  void _salvar() {
    if (nomeController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos obrigatórios"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Aqui você implementaria a lógica de salvamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Card criado com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, "card_criado");
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Card"),
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           
           
        
          
             _botaoGradient(
      texto: "Selecionar Imagem",
      onTap: _selecionarImagem,
    ),

    // Espaço
    const SizedBox(height: 12),

    // Imagem selecionada (opcional)
    if (imagemSelecionada != null)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            imagemSelecionada!,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.height * 1,
            fit: BoxFit.fill,
          ),
        ),
      ),

    const SizedBox(height: 16),

    // Input de descrição vem por último
    _input("Descrição", nomeController
    ),

    const SizedBox(height: 32),

    // Botão Criar Card
    _botaoGradient(texto: "Criar Card", onTap: _salvar),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      maxLength: 255,
       keyboardType: TextInputType.multiline,
       minLines: 1,       // começa com 1 linha
       maxLines: null,    // cres
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "Poppins", color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _botaoGradient({required String texto, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
