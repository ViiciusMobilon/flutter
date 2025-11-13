import 'package:flutter/material.dart';
import 'package:tcc/Relacionaveis_a_perfil/favoritos.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_dono_conta.dart';
import 'package:tcc/feed_principal/feed_aleatorio.dart';
import 'package:tcc/Relacionaveis_a_perfil/criacao_de%20_card.dart';
import 'package:tcc/paginas_principais/filtro/pesquisa.dart';
import 'package:tcc/settins/pgsettins.dart';

// Tela principal do app (com navegação inferior entre Início e Perfil)
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // Índice da página atual (controla qual tela está visível)
  int paginaAtual = 0;

  // Lista das páginas que podem ser exibidas
  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    // Define as páginas: feed principal e perfil do dono
    _paginas = [AleatorioFeed(), PerfilDono()];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
        // Retornar false bloqueia o botão de voltar
        return false;},
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
      
        // AppBar muda dependendo da página
        appBar: paginaAtual == 0
            // AppBar da tela inicial (com barra de pesquisa)
            ? PreferredSize(
                preferredSize: Size.fromHeight(
                  MediaQuery.of(context).size.height * 0.085,
                ),
                child: AppBar(
                    surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: Container(
                    // Gradiente de fundo do AppBar
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
                            // Container da barra de pesquisa
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
                                readOnly: true, // Impede digitação direta
                                onTap: () {
                                  // Ao tocar, abre a tela de pesquisa personalizada
                                  showSearch(
                                    context: context,
                                    delegate: BarraDePesquisa(),
                                  );
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  hintText: "Pesquisar serviços...",
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.04,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height * 0.012,
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
              )
            // AppBar da página de Perfil
            : AppBar(
                surfaceTintColor: Colors.transparent,
                title: const Text(
                  "Perfil",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
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
              icon: const Icon(
                Icons.photo,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                
              },
            ),
                   IconButton(
                    icon: const Icon(Icons.favorite,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritosPage(),
                        ),
                      );
                    },
                  ),
                  // Ícone de configurações no canto direito
                  IconButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const settinspage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
      
        // IndexedStack mantém o estado das páginas mesmo ao trocar
        body: IndexedStack(index: paginaAtual, children: _paginas),
      
        // Botão flutuante aparece apenas na página de Perfil
        floatingActionButton: paginaAtual == 1
            ? FloatingActionButton(
                onPressed: () async {
                  // Abre a página para criar novo post
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const NovoPostPage()),
                  );
                  if (resultado != null && mounted) {
                    // Aqui você pode atualizar o feed com o novo post
                  }
                },
                backgroundColor: const Color(0xFF5E35B1),
                elevation: 4,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      
        // Barra de navegação inferior com gradiente
        bottomNavigationBar: Container(
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
            onWillPop: () async {
              // Impede o usuário de sair com o botão de voltar
              return false;
            },
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
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600),
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
        ),
      ),
    );
  }
}

// ===================
// Widget de placeholder de pesquisa
// ===================
class pesquisaWidget extends StatefulWidget {
  const pesquisaWidget({super.key});

  @override
  State<pesquisaWidget> createState() => _pesquisaWidgetState();
}

class _pesquisaWidgetState extends State<pesquisaWidget> {
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
              // Ícone dentro de um círculo com gradiente
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
                child: Icon(
                  Icons.search_rounded,
                  size: 60,
                  color: const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 32),

              // Título principal
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

              // Texto explicativo
              Text(
                "Use a barra de pesquisa no topo da tela para encontrar os melhores profissionais da sua região.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF718096),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // Botão estilizado (não funcional aqui)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
             
              ),
            ],
          ),
        ),
      ),
    );
  }
}
