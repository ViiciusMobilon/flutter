import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil_portfolio.dart';
import 'package:tcc/cadastro/cadastro1.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'system_star.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';

class PerfilUser extends StatefulWidget {
  final AuthController authController;
  PerfilUser({super.key, required this.authController});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  bool isLoved = false;
  int loveCount = 0;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() =>
        context.read<PortfolioController>().fetchPortfolioAuth());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PortfolioController>().loadMorePostsAuth();
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

  Widget _buildDescription(String text) {
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
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87, height: 1.4),
        textAlign: TextAlign.justify,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _portfolioController = context.watch<PortfolioController>();
    final user = context.watch<AuthController>().usuario;
    print('user tell: ${user?.telefone}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader(user)),
          SliverToBoxAdapter(
            child: _buildDescription(
              user?.descricao ?? '',
            ),
          ),
          SliverToBoxAdapter(child: _buildContactSection(
            context: context,
            telefone: user?.telefone ?? null,
            whatsapp: user?.whatsapp ?? null,
            email: user?.email ?? null,
            website: user?.site ?? null,
            instagram: user?.instagram ?? null,
          )),  
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_portfolioController.loadingAuth &&
                    _portfolioController.portfoliosAuth.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (index < _portfolioController.portfoliosAuth.length) {
                  final post = _portfolioController.portfoliosAuth[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: FeedPerfil(
                      post: post,
                      authController: widget.authController,
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text('No more posts')),
                  );
                }
              },
              childCount: _portfolioController.portfoliosAuth.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height:height*0.40,
      child: Stack(
        children: [
          Container(
            height: height*0.16,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  '',
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
                  '${user?.nome ?? user?.razao_social ?? 'Não definido'}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${user?.categoriaNome ?? ''}',
                    style: TextStyle(color: Colors.grey[700])),
                Text('${user?.razao_social ?? user?.tipo}',
                    style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 8),
                const EstrelaPerfil(),
                const SizedBox(height: 12),
                _buildLoveButton(),
              ],
            ),
          ),
         
          Positioned(
            bottom: height * 0.25,
            right: width * 0.05,
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const imagem()),
              ),
              icon: const Icon(
                Icons.photo_camera_back,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection({
      required BuildContext context,
      String? telefone,
      String? whatsapp,
      String? email,
      String? website,
      String? x,
      String? instagram,
    }) {
      final List<Map<String, dynamic>> contacts = [
        if (telefone != null && telefone.isNotEmpty)
          {'icon': Icons.phone, 'label': 'Telefone', 'url': telefone, 'color': Color(0xFF2196F3),},
        if (whatsapp != null && whatsapp.isNotEmpty)
          {'icon': Icons.message, 'label': 'WhatsApp', 'url': whatsapp, 'color': Color(0xFF2196F3)},
        if (email != null && email.isNotEmpty)
          {'icon': Icons.email, 'label': 'Email', 'url': email, 'color': Color(0xFF2196F3)},
        if (website != null && website.isNotEmpty)
          {'icon': Icons.language, 'label': 'Website', 'url': website, 'color': Color(0xFF2196F3)},
        if (x != null && x.isNotEmpty)
          {'icon': Icons.alternate_email, 'label': 'X', 'url': x, 'color': Color(0xFF2196F3)},
        if (instagram != null && instagram.isNotEmpty)
          {'icon': Icons.camera_alt, 'label': 'Instagram', 'url': instagram, 'color': Color(0xFF2196F3)},
      ];

      if (contacts.isEmpty) return const SizedBox.shrink();

      return Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Entre em Contato",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 16,
                children: contacts.map((contact) {
                  return GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(contact['url'] as String);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Não foi possível abrir o link')),
                        );
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                (contact['color'] as Color).withOpacity(0.7),
                                contact['color'] as Color,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (contact['color'] as Color).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              contact['icon'] as IconData,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          contact['label'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
  }
}
