import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil.dart';
import 'package:tcc/cadastro/cadastro1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'system_star.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/controllers/portfolio_controller.dart';
import 'package:intl/intl.dart';

// Arquivo resultante do merge - combina a UI atualizada (frontend) com
// a lógica de backend/estado já existente (PortfolioController / AuthController).

class PerfilUser extends StatefulWidget {
  const PerfilUser({super.key});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  bool isLoved = false;
  int? loveCount;

  // campos opcionais para exibir contatos (poderão vir do user)
  String? telefone;
  String? whatsapp;
  String? email;
  String? website;
  String? x;
  String? instagram;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final portfolioController = context.read<PortfolioController>();
      if (!portfolioController.carregadoAuth) {
        portfolioController.fetchPortfolioAuth();
      }

      // inicializar contadores a partir do usuário (se disponível)
      final user = context.read<AuthController>().usuario;
      if (user != null) {
        // valores padrão — sobrescreva conforme sua API
        // loveCount = user.likesCount ?? 0;
        telefone = user.telefone;
        whatsapp = user.whatsapp;
        email = user.email;
        website = user.site;
        instagram = user.instagram;
        loveCount = user.avaliacaoTotal!.toInt();
        // x = user.x;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final portfolioController = context.read<PortfolioController>();

    if (portfolioController.loadingAuth || !portfolioController.hasMoreAuth) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      portfolioController.loadMorePostsAuth();
    }
  }

  // void _toggleLove() {
  //   setState(() {
  //     isLoved = !isLoved;
  //     loveCount += isLoved ? 1 : -1;
  //   });

  //   // Lógica de backend: faça uma chamada à API para atualizar o "like" do perfil.
  //   // Exemplo (pseudo): context.read<ProfileController>().toggleLove(userId, isLoved);
  // }

  @override
  Widget build(BuildContext context) {
    final _portfolioController = context.watch<PortfolioController>();
    final user = context.watch<AuthController>().usuario;
    print('user tell: ${user?.telefone}');
    print('user skills: ${user?.skills.length}');
    final skillsNomes = user?.skills
      ?.map((s) => s?.nome)
      .where((nome) => nome != null)
      .join(', ');
      print('nomes skills: ${skillsNomes}');
    // String data = DateFormat('dd/MM/yyyy').format(user!.createdAt!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader(user)),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
          SliverToBoxAdapter(
            child: _buildDescription(user?.descricao ?? ''),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
          SliverToBoxAdapter(child: _buildEspecializacao(skillsNomes!)),
          SliverToBoxAdapter(
            child: buildContactSection(
              context: context,
              telefone: telefone ?? user?.telefone,
              whatsapp: whatsapp ?? user?.whatsapp,
              email: email ?? user?.email,
              website: website ?? user?.site,
              instagram: instagram ?? user?.instagram,
            ),
          ),

          // Lista de posts / portfolio — usa PortfolioController
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_portfolioController.loadingAuth && _portfolioController.portfoliosAuth.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (index < _portfolioController.portfoliosAuth.length) {
                  final post = _portfolioController.portfoliosAuth[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: FeedPerfil(post: post),
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
    print('estrelas: ${user.avaliacaoTotal}');

    return SizedBox(
      height: height * 0.40,
      child: Stack(
        children: [
          Container(
            height: height * 0.16,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('',),
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
                Text('${user?.categoriaNome ?? user?.ramoNome}', style: TextStyle(color: Colors.grey[700])),
                Text('${user?.tipo}', style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 8),
                estrelaperfil(star: user.avaliacaoTotal),
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

  Widget _buildLoveButton() {
    return Container(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.grey[700],
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Curtidas',
                style: TextStyle(
                  color:Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$loveCount',
                style: TextStyle(
                  color:Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildEspecializacao(String skills) {
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
          Text(
            "Especializações",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
          Text(skills ?? ''),
        ],
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
}

// Seção de contato (mantida fora da classe para facilitar reuso)
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
      {'icon': Icons.phone, 'label': 'Telefone', 'url': telefone, 'color': const Color(0xFF2196F3)},
    if (whatsapp != null && whatsapp.isNotEmpty)
      {'icon': Icons.message, 'label': 'WhatsApp', 'url': whatsapp, 'color': const Color(0xFF2196F3)},
    if (email != null && email.isNotEmpty)
      {'icon': Icons.email, 'label': 'Email', 'url': email, 'color': const Color(0xFF2196F3)},
    if (website != null && website.isNotEmpty)
      {'icon': Icons.language, 'label': 'Website', 'url': website, 'color': const Color(0xFF2196F3)},
    if (x != null && x.isNotEmpty)
      {'icon': Icons.alternate_email, 'label': 'X', 'url': x, 'color': const Color(0xFF2196F3)},
    if (instagram != null && instagram.isNotEmpty)
      {'icon': Icons.camera_alt, 'label': 'Instagram', 'url': instagram, 'color': const Color(0xFF2196F3)},
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
                  final urlString = contact['url'] as String;

                  // Se for telefone/whatsapp, podemos prefixar "tel:" ou link do whatsapp
                  Uri url;
                  if (contact['label'] == 'Telefone') {
                    url = Uri.parse('tel:$urlString');
                  } else if (contact['label'] == 'WhatsApp') {
                    final cleaned = urlString.replaceAll(RegExp(r"[^0-9+]"), '');
                    url = Uri.parse('https://wa.me/$cleaned');
                  } else if (contact['label'] == 'Email') {
                    url = Uri.parse('mailto:$urlString');
                  } else {
                    url = Uri.parse(urlString);
                  }

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
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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

// Widget auxiliar para escolher/upload de imagem
class Fundo extends StatefulWidget {
  const Fundo({super.key});

  @override
  State<Fundo> createState() => _FundoState();
}

class _FundoState extends State<Fundo> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // aqui: envie a imagem para o backend se necessário
      // Exemplo: context.read<ProfileController>().uploadAvatar(File(pickedFile.path));
    }
  }

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
                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(Icons.camera_alt, size: MediaQuery.of(context).size.width * 0.1, color: Colors.white70),
                  ),
                ),
        ),
      ),
    );
  }
}
