import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tcc/Relacionaveis_a_perfil/feed_perfil_outro.dart';
import 'dart:async';
import 'package:tcc/Relacionaveis_a_perfil/system_star.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/public_user_controller.dart';
import 'package:tcc/data/models/user_public/post_user.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/data/repositories/auth_repository.dart';
import 'package:tcc/data/services/public_user_service.dart';
import 'package:tcc/service_post.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilDeOutroUsuario extends StatefulWidget {
  final int id;
  PerfilDeOutroUsuario({super.key, required this.id});

  @override
  State<PerfilDeOutroUsuario> createState() => _PerfilDeOutroUsuarioState();
}

class _PerfilDeOutroUsuarioState extends State<PerfilDeOutroUsuario> {
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final UserPublicController _user = UserPublicController(PublicUserService());

  UsuarioPublic? user;
  bool isLoved = false;
  int loveCount = 0;
  
  String? urlPerfil;
  String? urlCapa;
  String? nome;
  String? razao_social;
  String? tipo;
  String? area;
  String? cat;

  // contatos (preenchidos a partir de user.contato se houver)
  String? telefone;
  String? whatsapp;
  String? email;
  String? website;
  String? x;
  String? instagram;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _user.addListener(() {
      setState(() {
        user = _user.user;
        if (user != null) {
          loveCount = user?.curtidasQueRecebi ?? 0;
          urlCapa = user?.dados.capa;
          urlPerfil = user?.dados.foto;
          nome = user?.dados.nome;
          razao_social = user?.dados.razao_social;
          tipo = user?.type;
          area = user?.dados.ramoNome;
          cat = user?.dados.categoriaNome;

          // contatos
          telefone = user?.contato?.telefone;
          whatsapp = user?.contato?.whatsapp;
          email = user?.email;
          website = user?.contato?.site;
          // x = user?.contato?.x;
          instagram = user?.contato?.instagram;
          loveCount = user?.curtidasQueRecebi ?? 0;
      // aqui podemos setar isLoved
          // isLoved = user!.; 
        }
      });
    });

    // carregar usuário pelos dados do backend
    _user.loadUser(id: widget.id);
    // se você tiver carregamento inicial de posts, chame aqui
    // carregarPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    // se você tiver paginação real, chame o serviço aqui.
    await Future.delayed(const Duration(seconds: 1));
    // adicionar posts fictícios / ou buscar novos posts via serviço
    setState(() {
      isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  final repository = AuthRepository();

  void _toggleLove(int perfilId) async {
  if (isLoved) {
    await repository.descurtirPerfil(perfilId);
  } else {
    await repository.curtirPerfil(perfilId);
  }

  // Recarrega o usuário para atualizar curtidas, foto, etc
  await _user.loadUser(id: widget.id);
}



  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final portfolios = user?.portfolios ?? [];
    print("skills: ${user?.dados.skills?.length}");
    print("curtida: ${user!.curtidasQueRecebi}");
    final skillsNomes = user?.dados.skills
      ?.map((s) => s?.nome)
      .where((nome) => nome != null)
      .join(', ');

    print('skills nomes: ${skillsNomes}');


    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).size.height * 0.01)),
          SliverToBoxAdapter(child: _buildDescription(user?.dados.descricao ?? '')),
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).size.height * 0.02)),
          SliverToBoxAdapter(child: _buildEspecializacao(skillsNomes)),
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
              if (index < portfolios.length) {
                return FeedPerfilUser(post: portfolios[index], user: user,);
              } else if (isLoadingMore && index == portfolios.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const SizedBox.shrink();
              }
            }, childCount: portfolios.length + (isLoadingMore ? 1 : 0)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final coverUrl = urlCapa != null ? '$URLAPISTORAGE$urlCapa' : null;
    final profileUrl = urlPerfil != null ? '${URLAPISTORAGE}''/storage/''${urlPerfil}' : null;
    print("foto perfil: ${profileUrl}");

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Capa com gradiente overlay
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  image: coverUrl != null
                      ? DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover)
                      : null,
                  color: Colors.grey.shade200,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.2)],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: MediaQuery.of(context).size.width * 0.07),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),

          // Avatar, nome e informações
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
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profileUrl != null ? NetworkImage(profileUrl) : null,
                      backgroundColor: Colors.grey.shade300,
                      child: profileUrl == null ? const Icon(Icons.person, size: 48, color: Colors.white70) : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  nome ?? razao_social ?? 'Sem nome',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A202C)),
                ),
                const SizedBox(height: 4),
                Text(
                  area ?? cat ?? '',
                  style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
                ),
                const SizedBox(height: 2),
                Text(
                  tipo ?? '',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
                ),
                const SizedBox(height: 12),
                const EstrelaRating(),
                Text('Avaliações'),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLoveButton(),
                    const SizedBox(width: 12),
                    const SizedBox(width: 6),
                    disponivel(status: user!.dados.disponivel,), // widget de disponibilidade visual
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveButton(){
    return GestureDetector(
      onTap:() => _toggleLove(user!.id),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF4A5568), height: 1.6, fontSize: 14)),
    );
  }

  Widget _buildEspecializacao(String? skills) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Especializações",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            textAlign: TextAlign.justify,
          ),
          // aqui você pode adicionar a lista real de especializações se vier do backend
          Text(skills ?? '')
        ],
      ),
    );
  }
}

/// Seção de contato (reutilizável)
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
    if (telefone != null && telefone.isNotEmpty) {'icon': Icons.phone, 'label': 'Telefone', 'url': telefone, 'color': const Color(0xFF2196F3)},
    if (whatsapp != null && whatsapp.isNotEmpty) {'icon': Icons.message, 'label': 'WhatsApp', 'url': whatsapp, 'color': const Color(0xFF25D366)},
    if (email != null && email.isNotEmpty) {'icon': Icons.email, 'label': 'Email', 'url': 'mailto:$email', 'color': const Color(0xFF2196F3)},
    if (website != null && website.isNotEmpty) {'icon': Icons.language, 'label': 'Website', 'url': website, 'color': const Color(0xFF2196F3)},
    if (x != null && x.isNotEmpty) {'icon': Icons.alternate_email, 'label': 'X', 'url': x, 'color': const Color(0xFF2196F3)},
    if (instagram != null && instagram.isNotEmpty) {'icon': Icons.camera_alt, 'label': 'Instagram', 'url': instagram, 'color': const Color(0xFF2196F3)},
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const Text("Entre em Contato", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 16,
            children: contacts.map((contact) {
              return GestureDetector(
                onTap: () async {
                  final urlString = contact['url'] as String;
                  Uri url;
                  try {
                    url = Uri.parse(urlString);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URL inválida')));
                    return;
                  }
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o link')));
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
                          colors: [(contact['color'] as Color).withOpacity(0.7), contact['color'] as Color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [BoxShadow(color: (contact['color'] as Color).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Center(child: Icon(contact['icon'] as IconData, color: Colors.white, size: 28)),
                    ),
                    const SizedBox(height: 6),
                    Text(contact['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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

/// Disponibilidade visual (mantive como estava na versão frontend)
class disponivel extends StatefulWidget {
  final bool status;
  disponivel({Key? key,required this.status }) : super(key: key);

  @override
  State<disponivel> createState() => _disponivelState();
}

class _disponivelState extends State<disponivel> {
  

  @override
  Widget build(BuildContext context) {
    return Center(
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: widget.status ? Colors.green : const Color.fromARGB(255, 255, 0, 0),
          borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(widget.status ? Icons.check_circle : Icons.cancel, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              widget.status ? 'Disponível' : 'Indisponível',
              style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

}