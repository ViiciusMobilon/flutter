import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/Relacionaveis_a_perfil/system_star.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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
    posts.addAll(List.generate(
      10,
      (index) => generateFakeServicePost(index),
    ));
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final currentLength = posts.length;
      posts.addAll(List.generate(
        5,
        (index) => generateFakeServicePost(currentLength + index),
      ));
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(child: _buildDescription()),
          SliverList.builder(
            itemCount: posts.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return feedperfil(post: posts[index]);
              } else {
                return _buildLoadingIndicator();
              }
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
          // Imagem de capa com gradiente
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradiente overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Avatar e informações
          Transform.translate(
            offset: const Offset(0, -50),
            child: Column(
              children: [
                // Avatar com borda gradiente
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Nome e título
                const Text(
                  'hahahahah',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Desenvolvedor Mobile',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tech Solutions Inc.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 12),

                // Rating com widget customizado
                EstrelaRating(estrelas: 5,),
                const SizedBox(height: 16),

                // Botão de Love
                _buildLoveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
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
            Icon(
              isLoved ? Icons.favorite : Icons.favorite_border,
              color: isLoved ? Colors.white : Colors.grey[700],
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              isLoved ? 'Amei' : 'Amar',
              style: TextStyle(
                color: isLoved ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$loveCount',
              style: TextStyle(
                color: isLoved ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildDescription() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sobre mim',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Desenvolvedor mobile apaixonado por criar experiências incríveis. '
            'Especialista em Flutter e React Native, sempre buscando as melhores práticas. '
            'Adoro trabalhar em equipe e compartilhar conhecimento com a comunidade.',
            style: TextStyle(
              color: Color(0xFF4A5568),
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            const Color(0xFF2196F3),
          ),
        ),
      ),
    );
  }
}