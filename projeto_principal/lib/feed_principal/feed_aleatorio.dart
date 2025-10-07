import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projeto_principal/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:projeto_principal/Relacionaveis_a_perfil/perfil_dono_conta.dart';
import 'package:projeto_principal/ver_mais/VerMais.dart';
import 'package:share_plus/share_plus.dart';

// ------------------------ ALEATORIO FEED ------------------------
class AleatorioFeed extends StatefulWidget {
  const AleatorioFeed({super.key});

  @override
  State<AleatorioFeed> createState() => _AleatorioFeedState();
}

class _AleatorioFeedState extends State<AleatorioFeed> {
  final List<ServicePostFeed> _posts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadMorePosts();
      }
    });
  }

  void _loadMorePosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    List<ServicePostFeed> newPosts = List.generate(3, (index) {
      int id = _posts.length + index + 1;

      List<String> imageUrls = List.generate(
        50,
        (imgIndex) => "https://picsum.photos/600/400?random=${id * 100 + imgIndex}",
      );

      return ServicePostFeed(
        id: id.toString(),
        providerName: "Prestador $id",
        providerCompany: "Empresa $id",
        providerAvatar: "https://picsum.photos/100/100?random=$id",
        location: "Cidade $id",
        description: "Descrição breve do serviço $id...",
        fullDescription: "Descrição completa do serviço $id...",
        images: imageUrls,
        likes: 0,
        isLiked: false,
      );
    });

    setState(() {
      _posts.addAll(newPosts);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_posts.isEmpty && !_isLoading) {
      return const Center(child: Text("Nenhum serviço encontrado."));
    }

    return Container(
      color: const Color(0xFFF5F7FA),
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return ServiceProviderFeed(post: _posts[index]);
          } else {
            return _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class ServicePostFeed {
  final String id;
  final String providerName;
  final String providerCompany;
  final String providerAvatar;
  final String location;
  final String description;
  final String fullDescription;
  final List<String> images;
  int likes;
  bool isLiked;

  ServicePostFeed({
    required this.id,
    required this.providerName,
    required this.providerCompany,
    required this.providerAvatar,
    required this.location,
    required this.description,
    required this.fullDescription,
    required this.images,
    required this.likes,
    required this.isLiked,
  });
}

class ServiceProviderFeed extends StatelessWidget {
  final ServicePostFeed post;
  const ServiceProviderFeed({super.key, required this.post});
  


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PerfilDeOutroUsuario(
                                ),
                                )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.providerAvatar),
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.providerName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(post.providerCompany,
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey)),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(post.location,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Carrossel
            if (post.images.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 240,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                ),
                items: post.images.map((url) {
                  return ClipRRect(
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image, size: 40)),
                    ),
                  );
                }).toList(),
              ),
            // Descrição + botão ver mais
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(post.description,
                        style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VerMaisPage(
                                  post: ServicePostDetail.fromFeedPost(post),
                                )));
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A202C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Ver mais',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 16)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}