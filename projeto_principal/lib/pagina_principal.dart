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
  final GlobalKey<_CriacaoDeCardState> _cardKey = GlobalKey<_CriacaoDeCardState>();
  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      CriacaoDeCard(key: _cardKey),
      const Center(child: Text("Buscar")),
      const Perfileditar(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App com Cards"),
        backgroundColor: Colors.indigoAccent,
      ),
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
                  _cardKey.currentState?.adicionarCard(resultado);
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
class CriacaoDeCard extends StatefulWidget {
  const CriacaoDeCard({super.key});

  @override
  State<CriacaoDeCard> createState() => _CriacaoDeCardState();
}

class _CriacaoDeCardState extends State<CriacaoDeCard> {
  final List<Map<String, dynamic>> _dadosCards = [];

  void adicionarCard(Map<String, dynamic> dados) {
    setState(() => _dadosCards.add(dados));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _dadosCards.map((card) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (card['imagem'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      card['imagem'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(
                    card['nome'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Data: ${card['data'].day}/${card['data'].month}/${card['data'].year}",
                  ),
                  trailing: const Icon(Icons.info_outline),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.indigoAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        card['local'] ?? 'Local não informado',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

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
