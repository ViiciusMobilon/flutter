// Código resolvido sem conflitos de merge
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_dono_conta.dart';
import 'package:tcc/Relacionaveis_a_perfil/favoritos.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/cadastro/Contratante.dart';
import 'package:tcc/feed_principal/feed_aleatorio.dart';
import 'package:tcc/Relacionaveis_a_perfil/criacao_de%20_card.dart';
import 'package:tcc/paginas_principais/filtro/pesquisa.dart';
import 'package:tcc/settins/pgsettins.dart';

class TelaPrincipal extends StatefulWidget {
  TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;
  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [AleatorioFeed(), PerfilUser()];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),

        appBar: paginaAtual == 0
            ? _appBarHome(context)
            : _appBarPerfil(context),

        body: IndexedStack(index: paginaAtual, children: _paginas),

        floatingActionButton: paginaAtual == 1
            ? FloatingActionButton(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => NovoPostPage()),
                  );

                  if (resultado == "post_publicado") {
                    final controller = context.read<PortfolioController>();
                    controller.resetarFeed();
                    controller.fetchPortfolioAuth(refresh: true);
                  }
                },
                backgroundColor: const Color(0xFF5E35B1),
                elevation: 4,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,

        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  PreferredSizeWidget _appBarHome(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.085),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.045,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      readOnly: true,
                      onTap: () {
                        showSearch(context: context, delegate: BarraDePesquisa(context));
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        hintText: "Pesquisar serviços...",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.012,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBarPerfil(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text("Perfil", style: TextStyle(fontWeight: FontWeight.w600)),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.photo, color: Colors.white),
          onPressed: () async {
            final img = await escolherImagemDaGaleria();
            if (img != null) print("Imagem selecionada: ${img.path}");
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritosPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettinsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF5E35B1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.4),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: paginaAtual,
            onTap: (i) => setState(() => paginaAtual = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final ImagePicker picker = ImagePicker();

Future<File?> escolherImagemDaGaleria() async {
  final XFile? imagem = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
  if (imagem == null) return null;
  return File(imagem.path);
}
