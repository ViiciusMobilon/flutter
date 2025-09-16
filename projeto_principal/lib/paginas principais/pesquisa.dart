import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_principal/cadastro/cadastro1.dart';
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
                resultados[index][1],
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
            onTap:  () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Cadastro())),
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