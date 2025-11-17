import 'package:flutter/material.dart';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil_outro.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/system_star.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/public_user_controller.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/data/services/public_user_service.dart';
import 'package:tcc/service_post.dart';

class PerfilDeOutroUsuario extends StatefulWidget {
  final int id;
  PerfilDeOutroUsuario({super.key, required this.id});

  @override
  State<PerfilDeOutroUsuario> createState() => _PerfilDeOutroUsuarioState();
}

class _PerfilDeOutroUsuarioState extends State<PerfilDeOutroUsuario> {
  final List<ServicePostFeed> posts = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final UserPublicController _user = UserPublicController(PublicUserService());
  UsuarioPublic? user;
  bool isLoved = false;
  int? loveCount;
  String? urlPerfil;
  String? urlCapa;
  String? nome;
  String? razao_social;
  String? tipo;
  String? area;
  String? cat;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _user.addListener(() {
      setState(() {
        user = _user.user;
        user = _user.user;
        loveCount = user!.curtidasQueRecebi;
        urlCapa = user?.dados.capa;
        urlPerfil = user?.dados.foto;
        nome = user?.dados.nome;
        razao_social = user?.dados.razao_social;
        tipo = user?.type;
        area = user?.dados.ramoNome;
        cat = user?.dados.categoriaNome;
      });
    });

    _user.loadUser(id: widget.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  void _toggleLove() {
    setState(() {
      isLoved = !isLoved;
      // loveCount += isLoved ? 1 : -1?
    });
  }

  Widget _buildLoveButton() {
    return GestureDetector(
      onTap: _toggleLove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isLoved ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isLoved ? Icons.favorite : Icons.favorite_border,
                color: isLoved ? Colors.white : Colors.grey[700], size: 18),
            const SizedBox(width: 6),
            Text(isLoved ? 'Amei' : 'Amar',
                style: TextStyle(
                    color: isLoved ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Text('$loveCount',
                style: TextStyle(
                    color: isLoved ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(text,
          style: const TextStyle(
              color: Color(0xFF4A5568), height: 1.6, fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {

    print("Tela do user");
    print("id do user: ${widget.id}");
    print("O user: ${user?.toJson()}");
    print("O user.dados: ${user?.dados?.toJson()}");
    print("O user.dados.cat: ${user?.dados?.categoriaNome}");
    print("O user.dados.ramo: ${user?.dados?.ramoNome}");
    print("O user.portfolio: ${user?.portfolios.toString()}");
    print("O user.contatos: ${user?.contato?.toJson()}");
    print("user curtidas: ${user?.curtidasQueRecebi}");
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader(urlCapa, urlPerfil, nome, razao_social, tipo, area, cat)),
          SliverToBoxAdapter(
              child: _buildDescription(
                  user?.dados.descricao! ?? '')),
          SliverList.builder(
            itemCount: posts.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < posts.length) ; 
              if (index < posts.length) return FeedPerfilUser();
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String? urlCapa,String? urlPerfil, String? nome, String? razao_social, String? type, String? area, String? cat) {
    print("${area} ou cat ${cat}");
    print("url final perfil(capa):${URLAPISTORAGE}${urlCapa}");
    print("url final perfil(perfil):${URLAPISTORAGE}${urlPerfil}");
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          '${URLAPISTORAGE}${urlCapa}'),
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -50),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF5E35B1)],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:
                        const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        '${URLAPISTORAGE}${urlPerfil}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(nome ?? razao_social ?? 'sem nome',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A202C))),
                const SizedBox(height: 4),
                Text(area ?? cat ?? 'vagabundo',
                    style: TextStyle(fontSize: 16, color: Color(0xFF718096))),
                const SizedBox(height: 2),
                Text(type ?? 's/n',
                    style: TextStyle(fontSize: 14, color: Color(0xFF718096))),
                const SizedBox(height: 12),
                const EstrelaRating(),
                const SizedBox(height: 16),
                _buildLoveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
