import 'package:flutter/material.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';
import 'package:projeto_principal/feed_principal/feed_aleatorio.dart';
import 'package:projeto_principal/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:projeto_principal/FeedCards/Cards.dart';
import 'package:projeto_principal/paginas principais/pesquisa.dart';
import 'package:projeto_principal/settins/pgsettins.dart';

/// Tela principal com barra de navegação inferior
class TelaPrincipal extends StatefulWidget {
  final AuthController authController;

  const TelaPrincipal({super.key, required this.authController});

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
      AleatorioFeed(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final foto = widget.authController.foto;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: IndexedStack(index: _paginaAtual, children: _paginas),
      floatingActionButton: _paginaAtual == 1
          ? FloatingActionButton(
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => NovoPostPage(foto: foto),
                  ),
                );
                if (resultado != null && mounted) {
                  // lógica pós-retorno (ex: atualizar feed)
                }
              },
              backgroundColor: Colors.indigoAccent,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Constrói o AppBar conforme a página atual
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (_paginaAtual == 0) {
      return AppBar(
        automaticallyImplyLeading: false,
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
                  // Barra de pesquisa
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
                        showSearch(
                          context: context,
                          delegate: BarraDePesquisa(),
                        );
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
      );
    } else {
      return AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => settinspage(
                    authController: widget.authController,
                  ),
                ),
              );
            },
          ),
        ],
      );
    }
  }

  /// Barra inferior com gradiente
  Widget _buildBottomNavBar() {
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
            currentIndex: _paginaAtual,
            onTap: (i) => setState(() => _paginaAtual = i),
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

/// Widget exibido quando não há pesquisa ativa
class PesquisaWidget extends StatelessWidget {
  const PesquisaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone circular
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2196F3).withOpacity(0.2),
                      const Color(0xFF5E35B1).withOpacity(0.2),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 60,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                "Encontre Profissionais",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A202C),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                "Use a barra de pesquisa no topo da tela para encontrar os melhores profissionais da sua região.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF718096),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Botão decorativo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF5E35B1)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Começar Busca",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
