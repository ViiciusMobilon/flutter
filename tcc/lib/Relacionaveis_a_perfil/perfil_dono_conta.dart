import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/Relacionaveis_a_perfil/service_provider_feed.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:tcc/data/repositories/portfolio_repository.dart';
import 'package:tcc/data/services/portfolio_service.dart';
import 'system_star.dart';
import 'package:provider/provider.dart';

class PerfilUser extends StatefulWidget {
  final AuthController authController;
   PerfilUser({super.key, required this.authController});

  @override
  State<PerfilUser> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilUser> {
  bool isLoved = false;
  int loveCount = 1247;

  final List<ServicePost> posts = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(()  {
      context.read<PortfolioController>().fetchPortfolio();
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
        context.read<PortfolioController>().loadMorePosts();
    }
  }

  void _toggleLove() {
    setState(() {
      isLoved = !isLoved;
      loveCount += isLoved ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _portfolioController = context.watch<PortfolioController>();
    final user = widget.authController.usuario;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(child: _buildDescription()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                print('Rebuild da lista com ${_portfolioController.portfolios.length} posts');
                if(_portfolioController.loading && _portfolioController.portfolios.isEmpty){
                  return _buildLoadingIndicator();
                }

                if(index < _portfolioController.portfolios.length){
                  final post = _portfolioController.portfolios[index];
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ServiceProviderFeed(post: post, authController: widget.authController,));
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text('No more posts')),
                  );
                }
              },
              childCount: context.watch<PortfolioController>().portfolios.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
  final user = widget.authController.usuario;
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 180,
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
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(
                    '${user?.fotoURL ?? 'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png'}',
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
                 Text(
                  '${user?.nome ?? user?.razao_social ?? 'não existo'}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${user?.ramoNome ?? ''}',
                    style: TextStyle(color: Colors.grey[700])),
                Text('${user?.razao_social ?? user?.tipo}',
                    style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 8),
                estrelaperfil(),
                const SizedBox(height: 12),
                _buildLoveButton(),
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

