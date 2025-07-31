import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Entry point
void main() => runApp(const TelaPrincipal());




// Tela principal com nav bar
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _paginaAtual = 0;
  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      const Center(child: Text("inicio")),
      const Center(child: Text("Buscar")),
      const Perfileditar(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: _paginas[_paginaAtual],
        ),
      ),
      floatingActionButton: _paginaAtual == 0
          ? FloatingActionButton(
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const CadastroCardPage()),
                );
                if (resultado != null && mounted) {
                
                }
              },
              backgroundColor: Colors.indigoAccent,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BottomNavigationBar(
            currentIndex: _paginaAtual,
            onTap: (i) => setState(() => _paginaAtual = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}

// Lista de cards

// Tela de cadastro de card
class CadastroCardPage extends StatefulWidget {
  const CadastroCardPage({super.key});

  @override
  State<CadastroCardPage> createState() => _CadastroCardPageState();
}

class _CadastroCardPageState extends State<CadastroCardPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  DateTime? dataSelecionada;
  File? imagemSelecionada;

  Future<void> _selecionarData() async { /* mesmo código */}
  Future<void> _selecionarImagem() async { /* mesmo código */}
  void _salvar() { /* mesmo código */ }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Card"), backgroundColor: Colors.indigoAccent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _input("Nome", nomeController),
            SizedBox(height: altura * 0.02),
            _input("Local", localController),
            SizedBox(height: altura * 0.02),
            _botaoGradient(
              texto: dataSelecionada == null
                  ? "Selecionar Data"
                  : "Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
              onTap: _selecionarData,
            ),
            SizedBox(height: altura * 0.02),
            _botaoGradient(texto: "Selecionar Imagem", onTap: _selecionarImagem),
            if (imagemSelecionada != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(imagemSelecionada!, height: 150),
                ),
              ),
            SizedBox(height: altura * 0.04),
            _botaoGradient(texto: "Criar Card", onTap: _salvar),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "Poppins", color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromRGBO(121, 180, 217, 1), width: 1.5),
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
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// Perfil estilizado
class Perfileditar extends StatefulWidget {
  const Perfileditar({super.key});

  @override
  State<Perfileditar> createState() => _PerfileditarState();
}

class _PerfileditarState extends State<Perfileditar> {
  final nomeCtrl = TextEditingController(text: "João da Silva");
  final emailCtrl = TextEditingController(text: "joao@email.com");
  final telCtrl = TextEditingController(text: "11999999999");

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _campoTexto("Nome", nomeCtrl),
            SizedBox(height: altura * 0.02),
            _campoTexto("E-mail", emailCtrl),
            SizedBox(height: altura * 0.02),
            _campoTexto("Telefone", telCtrl),
            SizedBox(height: altura * 0.04),
            _botaoGradient(texto: "Salvar", onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Informações salvas!")));
            }),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "Poppins", color: Colors.black),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromRGBO(121, 180, 217, 1), width: 1.5),
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
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
