import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_principal/ifeed.dart';

// Entry point
void main() => runApp(
  MaterialApp(home: const TelaPrincipal(), debugShowCheckedModeBanner: false),
);

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
    _paginas = [const PesquisaWidget(), const Perfilpessoa()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar movido para cá - apenas na página de pesquisa
      appBar:
          _paginaAtual == 0
              ? AppBar(
                title: const Text("Pesqsa"),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(context: context, delegate: BarraDePesquisa());
                    },
                  ),
                ],
              )
              : AppBar(
                title: const Text("Perfil"),
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
              ),
      body: IndexedStack(index: _paginaAtual, children: _paginas),
      floatingActionButton:
          _paginaAtual == 0
              ? FloatingActionButton(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const CadastroCardPage(),
                    ),
                  );
                  if (resultado != null && mounted) {
                    // Lógica para lidar com o resultado
                  }
                },
                backgroundColor: Colors.indigoAccent,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de pesquisa SEM Scaffold aninhado
class PesquisaWidget extends StatefulWidget {
  const PesquisaWidget({super.key});

  @override
  State<PesquisaWidget> createState() => _PesquisaWidgetState();
}

class _PesquisaWidgetState extends State<PesquisaWidget> {
  
  List<Ifeed> feed = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount:feed.length,
        itemBuilder: (context, index) => feed[index].reader(),

      ),
    );

  }
}

// Classe que define como a barra de pesquisa funciona
class BarraDePesquisa extends SearchDelegate<String> {
  final List<String> dados = [
    "Pedreiro",
    "Pintor",
    "Eletricista",
    "Encanador",
    "Marceneiro",
    "Jardineiro",
    "Carpinteiro",
    "Soldador",
    "Técnico em Refrigeração",
    "Instalador de Ar Condicionado",
  ];

  @override
  String get searchFieldLabel => "Buscar profissionais...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ""; // limpa o campo de busca
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {
    final resultados =
        dados
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (resultados.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum profissional encontrado",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              child: Text(
                resultados[index][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              resultados[index],
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              "Toque para ver detalhes",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              close(context, resultados[index]); // retorna o item selecionado
              // Aqui você pode navegar para uma tela de detalhes do profissional
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes =
        query.isEmpty
            ? dados
                .take(5)
                .toList() // Mostra primeiros 5 se query vazia
            : dados
                .where(
                  (item) => item.toLowerCase().startsWith(query.toLowerCase()),
                )
                .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey),
          title: RichText(
            text: TextSpan(
              children: _destacarTexto(sugestoes[index], query),
              style: const TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
          ),
          onTap: () {
            query = sugestoes[index];
            showResults(context);
          },
        );
      },
    );
  }

  // Função para destacar o texto da busca
  List<TextSpan> _destacarTexto(String texto, String pesquisa) {
    if (pesquisa.isEmpty) {
      return [TextSpan(text: texto)];
    }

    final textoLower = texto.toLowerCase();
    final pesquisaLower = pesquisa.toLowerCase();
    final index = textoLower.indexOf(pesquisaLower);

    if (index == -1) {
      return [TextSpan(text: texto)];
    }

    return [
      TextSpan(text: texto.substring(0, index)),
      TextSpan(
        text: texto.substring(index, index + pesquisa.length),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.indigoAccent,
        ),
      ),
      TextSpan(text: texto.substring(index + pesquisa.length)),
    ];
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

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

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
    if (nomeController.text.isEmpty || localController.text.isEmpty) {
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
            _input("Nome", nomeController),
            SizedBox(height: altura * 0.02),
            _input("Local", localController),
            SizedBox(height: altura * 0.02),
            _botaoGradient(
              texto:
                  dataSelecionada == null
                      ? "Selecionar Data"
                      : "Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
              onTap: _selecionarData,
            ),
            SizedBox(height: altura * 0.02),
            _botaoGradient(
              texto: "Selecionar Imagem",
              onTap: _selecionarImagem,
            ),
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

// Widget de pesquisa SEM Scaffold aninhado
class pesquisaWidget extends StatefulWidget {
  const pesquisaWidget({super.key});

  @override
  State<pesquisaWidget> createState() => _pesquisaWidgetState();
}

class _pesquisaWidgetState extends State<pesquisaWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            "Encontre Profissionais",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Use o ícone de pesquisa no topo da tela para buscar profissionais da sua região.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Perfil da pessoa
class Perfilpessoa extends StatelessWidget {
  const Perfilpessoa({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigoAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            "Seu Perfil",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Gerencie suas informações pessoais aqui.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
