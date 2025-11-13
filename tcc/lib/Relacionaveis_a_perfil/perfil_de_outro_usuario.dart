import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/Relacionaveis_a_perfil/system_star.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';
import 'package:tcc/service_post.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilDeOutroUsuario extends StatefulWidget {
  const PerfilDeOutroUsuario({super.key});

  @override
  State<PerfilDeOutroUsuario> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<PerfilDeOutroUsuario> {
  bool isLoved = false;
  int loveCount = 1247;
   String? telefone = '1';
  String? whatsapp;
  String? email;
  String? website;
  String? x;
  String? instagram;


  final List<ServicePostFeed > posts = [];
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
  posts.addAll(List.generate(10, (index) {
    return ServicePostFeed(
      id: 'post_$index',
      providerName: 'Usuário $index',
      providerCompany: 'Empresa $index',
      providerAvatar: 'https://picsum.photos/seed/avatar$index/100/100',
      location: 'São Paulo - SP',
      description: 'Serviço inicial número $index - descrição curta',
      fullDescription: 'Descrição completa do serviço inicial número $index.',
      images: [
        'https://www.youtube.com/watch?v=i2PHZ9ARdzg',
      ],
      likes: 0,
      isLiked: false,
    );
  }));
}

  Future<void> _loadMorePosts() async {
  if (isLoadingMore) return;

  setState(() => isLoadingMore = true);

  await Future.delayed(const Duration(seconds: 2));

  setState(() {
    final currentLength = posts.length;

    posts.addAll(List.generate(5, (index) {
      final i = currentLength + index;
      return ServicePostFeed(
        id: 'post_$i',
        providerName: 'Usuário $i',
        providerCompany: 'Empresa $i',
        providerAvatar: 'https://picsum.photos/seed/avatar$i/100/100',
        location: 'São Paulo - SP',
        description: 'Serviço número $i - descrição de teste',
        fullDescription: 'Descrição completa do serviço número $i',
        images: [
          'https://www.youtube.com/watch?v=i2PHZ9ARdzg',
        ],
        likes: 0,
        isLiked: false,
      );
    }));

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

 

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ),
          // Espaço para o avatar
          SliverToBoxAdapter(child: _buildDescription()),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
          SliverToBoxAdapter(child: _buildEspecializacao()),
          SliverToBoxAdapter(
            child: buildContactSection(
              context: context,
              telefone: telefone,
              whatsapp: whatsapp,
              email: email,
              website: website,
              x: x,
              instagram: instagram,
            ),
          ),
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Imagem de capa com gradiente
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
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
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),

              Positioned(
                top: 30,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                     
                    
                  },
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
                  'João Silva',
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
                  style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
                ),
                const SizedBox(height: 12),

                // Rating com widget customizado
                const EstrelaRating(),
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
          style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: const Color(0xFFE2E8F0));
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
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2196F3)),
        ),
      ),
    );
  }
}

 Widget _buildEspecializacao() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Especializações",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
 // Seção de contato (mantida)
Widget buildContactSection({
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
      {
        'icon': Icons.phone,
        'label': 'Telefone',
        'url': telefone,
        'color': Color(0xFF2196F3),
      },
    if (whatsapp != null && whatsapp.isNotEmpty)
      {
        'icon': Icons.message,
        'label': 'WhatsApp',
        'url': whatsapp,
        'color': Color(0xFF2196F3),
      },
    if (email != null && email.isNotEmpty)
      {
        'icon': Icons.email,
        'label': 'Email',
        'url': email,
        'color': Color(0xFF2196F3),
      },
    if (website != null && website.isNotEmpty)
      {
        'icon': Icons.language,
        'label': 'Website',
        'url': website,
        'color': Color(0xFF2196F3),
      },
    if (x != null && x.isNotEmpty)
      {
        'icon': Icons.alternate_email,
        'label': 'X',
        'url': x,
        'color': Color(0xFF2196F3),
      },
    if (instagram != null && instagram.isNotEmpty)
      {
        'icon': Icons.camera_alt,
        'label': 'Instagram',
        'url': instagram,
        'color': Color(0xFF2196F3),
      },
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
            children:
                contacts.map((contact) {
                  return GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(contact['url'] as String);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Não foi possível abrir o link'),
                          ),
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
                                color: (contact['color'] as Color).withOpacity(
                                  0.3,
                                ),
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