import 'package:flutter/material.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_dono_conta.dart';

class PerfilFavorito {
  final String nome;
  final String segmento;
  final double rating;
  final int likes;
  final int views;

  PerfilFavorito({
    required this.nome,
    required this.segmento,
    required this.rating,
    required this.likes,
    required this.views,
  });
}

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with TickerProviderStateMixin {
  List<PerfilFavorito> favoritos = [
    PerfilFavorito(
        nome: "Ana Silva",
        segmento: "Designer UX/UI",
        rating: 4.9,
        likes: 152,
        views: 1250),
    PerfilFavorito(
        nome: "Carlos Mendes",
        segmento: "Desenvolvedor Full Stack",
        rating: 4.8,
        likes: 133,
        views: 980),
    PerfilFavorito(
        nome: "Beatriz Costa",
        segmento: "Product Manager",
        rating: 4.7,
        likes: 87,
        views: 740),
  ];

  String pesquisa = "";

  @override
  Widget build(BuildContext context) {
    final filtrados = favoritos
        .where((p) =>
            p.nome.toLowerCase().contains(pesquisa.toLowerCase()) ||
            p.segmento.toLowerCase().contains(pesquisa.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
          surfaceTintColor: Colors.transparent,
        elevation: 0.8,
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.favorite, color: Colors.redAccent, size: 26),
            SizedBox(width: 8),
            Text(
              "Favoritos",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Campo de busca
            if (favoritos.isNotEmpty)
              TextField(
                decoration: InputDecoration(
                  hintText: "Buscar por nome ou segmento...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Colors.redAccent, width: 1.4),
                  ),
                ),
                onChanged: (valor) => setState(() => pesquisa = valor),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: filtrados.isEmpty
                  ? Center(
                      child: Text(
                        favoritos.isEmpty
                            ? "Você ainda não favoritou nenhum perfil."
                            : "Nenhum perfil encontrado para \"$pesquisa\"",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        final perfil = filtrados[index];
                        return Dismissible(
                          key: Key(perfil.nome),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            setState(() {
                              favoritos.remove(perfil);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${perfil.nome} foi removido dos favoritos."),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.delete,
                                color: Colors.white, size: 26),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PerfilUser()),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Avatar circular gradiente
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF2196F3),
                                            Color(0xFF5E35B1)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          perfil.nome[0].toUpperCase(),
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.028,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Informações
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  perfil.nome,
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                 Row(
                                crossAxisAlignment: CrossAxisAlignment.start, // Alinha ao topo
                                children: [
                                  Text(
                                    "empresa" ?? "Serviço",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: MediaQuery.of(context).size.width * 0.035,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "poppis",
                                    ),
                                  ),
                                  Text(
                                    " ● ",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.03,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "desenvolvedor full stackssssssssssssssssssss" ?? perfil.segmento,
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.035,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "poppis",
                                        color: Colors.black,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                                          const SizedBox(height: 8),

                                          // Estatísticas
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded,
                                                  color: Color(0xFFFFB300),
                                                  size: 18),
                                              Text(
                                                  " ${perfil.rating.toStringAsFixed(1)}  "),
                                              const Icon(Icons.favorite_rounded,
                                                  color: Colors.pinkAccent,
                                                  size: 17),
                                              Text(" ${perfil.likes}  "),
                                             
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
