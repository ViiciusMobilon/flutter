import 'package:flutter/material.dart';
import 'package:projeto_principal/FeedCards/Cards.dart';
import 'package:projeto_principal/FeedPerfil/Perfil.dart';
import 'package:projeto_principal/FeedPerfil/criacao_de%20_card.dart';
import 'package:projeto_principal/paginas%20principais/pesquisa.dart';
import 'package:projeto_principal/settins/pgsettins.dart';

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
                 actions: [
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
                
                  )
                 ],
              ),
      body: IndexedStack(index: _paginaAtual, children: _paginas),
      floatingActionButton:
          _paginaAtual == 1
              ? FloatingActionButton(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const NovoPostPage(),),
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
        child: WillPopScope(
      onWillPop: () async {
        // retorna false = cancela o botão voltar
        return false; 
      },
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
      ),
    );
  }
}

// Widget de pesquisa SEM Scaffold aninhado


// Classe que define como a barra de pesquisa funciona


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
