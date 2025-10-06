import 'package:flutter/material.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';
import 'package:projeto_principal/data/controllers/portfolio_controller.dart';
import 'package:projeto_principal/data/models/post.dart';
import 'package:projeto_principal/data/repositories/portfolio_repository.dart';
import 'package:projeto_principal/data/services/portfolio_service.dart';
import 'package:projeto_principal/FeedPerfil/service_provider_feed.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:projeto_principal/FeedPerfil/system_star.dart';

class ProfileScreen extends StatefulWidget {
  final AuthController authController;
  ProfileScreen({super.key, required this.authController});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isLoved = false;
  int loveCount = 1247;
  String? foto;
  double avaliacao = 0.0;
  

  void loadFoto() async {
    final imagem = await widget.authController.getFoto(); // seu AuthService
    setState(() {
      foto = imagem;
    });
  }

  final List<Portfolio> posts = [];
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    PortfolioRepository().getPortfolioUser();
    PortfolioService().getPortfolio();
    final portfolioController = Provider.of<PortfolioController>(context, listen: false);
    portfolioController.fetchPortfolio();
    portfolioController.fetchPortfolio();
    loadFoto(); 

     _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        portfolioController.loadMorePosts();
      }
    });
    }

    void _toggleLove() {
      setState(() {
        if (isLoved) {
          isLoved = false;
          loveCount--;
        } else {
          isLoved = true;
          loveCount++;
        }
      });
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          SliverList.builder(
            itemCount: posts.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return ServiceProviderFeed(post: posts[index], authController: widget.authController,);
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
    final user = widget.authController.usuario;
    final ramo = widget.authController.ramo;
    final f = widget.authController.foto;
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.11,
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
                    backgroundImage: (f != null && f.isNotEmpty)
                        ? NetworkImage(f)
                        : null,
                    child: (f == null || f.isEmpty)
                        ? const Icon(Icons.person, size: 40)
                        : null,
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
                  '${user?.razao_social ?? user?.nome ?? 'nulo'}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${user?.ramoNome}',
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                EstrelaRating(estrelas: 5,),
                
                const SizedBox(height: 12),
                _buildLoveButton(),
              ],
            ),
          ),
        ],
      )
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


