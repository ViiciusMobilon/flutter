import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_principal/FeedCards/Cards.dart';
import 'package:projeto_principal/FeedPerfil/Perfil.dart';
import 'package:projeto_principal/FeedPerfil/criacao_de%20_card.dart';
import 'package:projeto_principal/FeedCards/Cards.dart';

// Entry point
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
    _paginas = [const FeedPrincipal(), const PerfilPrincipal()];
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
                 automaticallyImplyLeading: false,
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                 
              ),
      body: IndexedStack(index: _paginaAtual, children: _paginas),
      floatingActionButton:
          _paginaAtual == 1
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
