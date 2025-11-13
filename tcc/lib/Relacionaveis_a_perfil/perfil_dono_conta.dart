import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/cadastro/cadastro1.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';
import 'package:tcc/service_post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'system_star.dart';

class PerfilDono extends StatefulWidget {
  PerfilDono({super.key});

  @override
  State<PerfilDono> createState() => _PerfilDonoState();
}

class _PerfilDonoState extends State<PerfilDono> {
  bool isLoved = false;
  int loveCount = 1247;
  String? telefone = '1';
  String? whatsapp;
  String? email;
  String? website;
  String? x;
  String? instagram;

  final List<ServicePostFeed> posts = [];
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
    posts.addAll(
      List.generate(10, (index) {
        return ServicePostFeed(
          id: 'post_$index',
          providerName: 'Usuário $index',
          providerCompany: 'Empresa $index',
          providerAvatar: 'https://picsum.photos/seed/avatar$index/100/100',
          location: 'São Paulo - SP',
          description: 'Serviço inicial número $index - descrição curta',
          fullDescription:
              'Descrição completa do serviço inicial número $index.',
          images: ['https://picsum.photos/seed/$index/600/400'],
          likes: 0,
          isLiked: false,
        );
      }),
    );
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    final currentLength = posts.length;

    posts.addAll(
      List.generate(5, (index) {
        final i = currentLength + index;
        return ServicePostFeed(
          id: 'post_$i',
          providerName: 'Usuário $i',
          providerCompany: 'Empresa $i',
          providerAvatar: 'https://picsum.photos/seed/avatar$i/100/100',
          location: 'São Paulo - SP',
          description: 'Serviço número $i - descrição de teste',
          fullDescription: 'Descrição completa do serviço número $i',
          images: ['https://picsum.photos/seed/$i/600/400'],
          likes: 0,
          isLiked: false,
        );
      }),
    );

    setState(() => isLoadingMore = false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
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
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ),
          // Espaço para o avatar
          SliverToBoxAdapter(child: _buildDescription()),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
          SliverToBoxAdapter(child: _buildEspecializacao()),
          SliverToBoxAdapter(
            child: _buildContactSection(
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.45, // define a altura total do cabeçalho
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Imagem de capa
          Container(
            height: height * 0.25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradiente para contraste
          Container(
            height: height * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Botão de voltar

          // Avatar
          Positioned(
            top: height * 0.17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                  ),
                ),
              ),
            ),
          ),

          // Nome e informações
          Positioned(
            top: height * 0.32,
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
            top: MediaQuery.of(context).size.height * 0.25,
            right: MediaQuery.of(context).size.width * 0.06,
            child: IconButton(
              icon: const Icon(
                Icons.photo,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              onPressed: () {
                fundo();  
              },
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
          const Icon(Icons.favorite, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          const Text(
            'Curtidas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Text(
            '$loveCount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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

// Seção de contato (mantida)
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

class fundo extends StatefulWidget {
  const fundo({super.key});

  @override
  State<fundo> createState() => _fundoState();
}

class _fundoState extends State<fundo> {
  File? _image; // Armazena a imagem escolhida
  final ImagePicker _picker = ImagePicker(); // Picker de imagens

  // Função para escolher imagem
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Mostra opções de Galeria ou Câmera
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar uma Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: ClipOval(
          child: _image != null
              ? Image.file(
                  _image!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.white70,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}