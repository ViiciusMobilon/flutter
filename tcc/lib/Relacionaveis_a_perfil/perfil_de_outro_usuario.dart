import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/Relacionaveis_a_perfil/system_star.dart';
import 'package:tcc/service_post.dart';
import 'package:tcc/paginas%20principais/pagina_principal.dart';

class PerfilDeOutroUsuario extends StatefulWidget {
  const PerfilDeOutroUsuario({super.key});

  @override
  State<PerfilDeOutroUsuario> createState() => _PerfilDeOutroUsuarioState();
}

class _PerfilDeOutroUsuarioState extends State<PerfilDeOutroUsuario> {
  bool isLoved = false;
  int loveCount = 1247;
  final List<ServicePostFeed> posts = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialPosts() {
    posts.addAll(List.generate(10, (index) => _generateFakePost(index)));
  }

  ServicePostFeed _generateFakePost(int index) {
    return ServicePostFeed(
      id: 'post_$index',
      providerName: 'Usuário $index',
      providerCompany: 'Empresa $index',
      providerAvatar: 'https://picsum.photos/seed/avatar$index/100/100',
      location: 'São Paulo - SP',
      description: 'Serviço $index',
      fullDescription: 'Descrição completa do serviço $index',
      images: ['https://www.youtube.com/watch?v=i2PHZ9ARdzg'],
      likes: 0,
      isLiked: false,
    );
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final currentLength = posts.length;
      posts.addAll(
          List.generate(5, (index) => _generateFakePost(currentLength + index)));
      isLoadingMore = false;
    });
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
      loveCount += isLoved ? 1 : -1;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(
              child: _buildDescription(
                  'Desenvolvedor mobile apaixonado por criar experiências incríveis. '
                  'Especialista em Flutter e React Native, sempre buscando as melhores práticas. '
                  'Adoro trabalhar em equipe e compartilhar conhecimento com a comunidade.')),
          SliverList.builder(
            itemCount: posts.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < posts.length) return FeedPerfil(post: posts[index]);
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

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4'),
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('João Silva',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A202C))),
                const SizedBox(height: 4),
                const Text('Desenvolvedor Mobile',
                    style: TextStyle(fontSize: 16, color: Color(0xFF718096))),
                const SizedBox(height: 2),
                const Text('Tech Solutions Inc.',
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
