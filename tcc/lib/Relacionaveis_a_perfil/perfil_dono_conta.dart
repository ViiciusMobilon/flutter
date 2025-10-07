import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/paginas%20principais/pagina_principal.dart';
import 'system_star.dart';

class PerfilDono extends StatefulWidget {
  const PerfilDono({super.key});

  @override
  State<PerfilDono> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilDono> {
  bool isLoved = false;
  int loveCount = 1247;

  final List<ServicePost> posts = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialPosts() {
    posts.addAll(List.generate(10, (index) => generateFakeServicePost(index)));
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final currentLength = posts.length;
      posts.addAll(
        List.generate(
          5,
          (index) => generateFakeServicePost(currentLength + index),
        ),
      );
      isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  // 🔹 Função para gerar posts fake
  ServicePost generateFakeServicePost(int index) {
    return ServicePost(
      id: index.toString(),
      provider: Provider(
        name: "João Silva",
        company: "Tech Solutions",
        avatar: "https://via.placeholder.com/150",
        rating: 4.5,
        reviewCount: 10 + index,
      ),
      images: ["https://via.placeholder.com/300x200"],
      description: "Conteúdo do post ${index + 1}",
      fullDescription: "Conteúdo completo do post ${index + 1}",
      category: "Desenvolvimento",
      location: "Brasil",
      completedAt: DateTime.now().toIso8601String(),
      likes: index * 2,
      isLiked: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(child: _buildDescription()),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < posts.length) {
                return FeedPerfil(post: posts[index]);
              } else {
                return _buildLoadingIndicator();
              }
            }, childCount: posts.length + (isLoadingMore ? 1 : 0)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: const CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'João Silva',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Desenvolvedor Mobile',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  'Tech Solutions Inc.',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                estrelaperfil(),
                const SizedBox(height: 12),
                _buildLoveButton(),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.87,
            top: MediaQuery.of(context).size.height * 0.17,
            child: IconButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TelaPrincipal()),
                  ),
              icon: Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            'Curtidas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Text(
            '$loveCount',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'Desenvolvedor mobile apaixonado por criar experiências incríveis. '
        'Especialista em Flutter e React Native, sempre buscando as melhores práticas. '
        'Adoro trabalhar em equipe e compartilhar conhecimento com a comunidade.',
        style: TextStyle(color: Colors.black87, height: 1.4),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
