import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tcc/ver_mais/editar_post.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/data/config.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/post.dart';
import 'package:tcc/ver_mais/editar_post.dart' show EditarPostPage;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tcc/service_post.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/editar_servico/editar.dart';

class VerMaisPageDono extends StatefulWidget {
  final ServicePost post;

  const VerMaisPageDono({Key? key, required this.post}) : super(key: key);
  
  final Portfolio post; // Recebe os dados do post
  final AuthController authController;

  const VerMaisPageDono({Key? key, required this.post, required this.authController}) : super(key: key);

  @override
  State<VerMaisPageDono> createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPageDono> {
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initVideos();

    // Configura animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward(); // Inicia animação
    _initializeVideoControllers(); // Inicializa vídeos
  }

  void _initVideos() {
    if (widget.post.mediaUrls != null) {
      for (int i = 0; i < widget.post.mediaUrls!.length; i++) {
        final url = widget.post.mediaUrls![i];
        if (_isVideo(url)) {
          final controller = VideoPlayerController.network(url)
  // Inicializa controladores de vídeo para cada URL de vídeo
  void _initializeVideoControllers() {
    if (widget.post.videos != null) {
      for (int i = 0; i < widget.post.videos.length; i++) {
        String url = '${URLAPISTORAGE}${widget.post.videos[i].url}';
        if (_isVideoUrl(url)) {
          _videoControllers[i] = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
          _controllers[i] = controller;
        }
      }
    }
  }

  bool _isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith(".mp4") || lower.endsWith(".mov") || lower.endsWith(".avi");
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  // Alterna o estado do like
  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
  }

  // Compartilha informações do post
  
  // Cria cada item do carrossel com borda
  Widget _buildMediaItem(String mediaUrl, int index) {
    bool isVideo = _isVideoUrl(mediaUrl);

    if (isVideo) {
      VideoPlayerController? controller = _videoControllers[index];
      if (controller != null && controller.value.isInitialized) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              IconButton(
                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  size: 64,
                  color: Colors.white.withOpacity(0.9),
                ),
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
              ),
            ],
          ),
        );
      } else {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.3,
          color: const Color(0xFFF5F7FA),
          child: const Center(child: CircularProgressIndicator()),
        );
      }
    } else {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF5F7FA),
              child: const Center(
                child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
              ),
            );
          },
        ),
      );
    }
  }

  // Carrossel de imagens/vídeos
 // Carrossel de imagens/vídeos corrigido
  Widget _buildMediaCarousel() {
    // Combina fotos e vídeos em uma lista única
    final List<String> mediaUrls = [
      if (widget.post.fotos != null)
        ...widget.post.fotos!.map((f) => '${URLAPISTORAGE}${f.url}'),
      if (widget.post.videos != null)
        ...widget.post.videos!.map((v) => '${URLAPISTORAGE}${v.url}'),
    ];

    if (mediaUrls.isEmpty) {
      return Container(
        height: 300,
        color: const Color(0xFFF5F7FA),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    // Inicializa controladores de vídeo considerando índice correto
    for (int i = 0; i < mediaUrls.length; i++) {
      if (_isVideoUrl(mediaUrls[i]) && !_videoControllers.containsKey(i)) {
        _videoControllers[i] = VideoPlayerController.network(mediaUrls[i])
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      }
    }

    return CarouselSlider.builder(
      itemCount: mediaUrls.length,
      itemBuilder: (context, index, realIndex) {
        return _buildMediaItem(mediaUrls[index], index);
      },
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        enableInfiniteScroll: mediaUrls.length > 1,
        autoPlay: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentMediaIndex = index;
          });
          // Pausa vídeos que estão tocando
          _videoControllers.forEach((key, controller) {
            if (controller != null && controller.value.isPlaying) {
              controller.pause();
            }
          });
        },
      ),
    );
  }


  // Informações do user
  Widget _buildProviderInfo() {
    final user = widget.authController.usuario;
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilDeOutroUsuario()),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundImage: widget.post.providerPhotoUrl != null
                  ? NetworkImage(widget.post.providerPhotoUrl!)
                  : null,
              backgroundColor: const Color(0xFFE6E8EB),
              child: widget.post.providerPhotoUrl == null
                  ? const Icon(Icons.person, color: Colors.white, size: 26)
                  : null,
            ),
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFFF5F7FA),
            backgroundImage: user?.fotoURL != null
                ? NetworkImage(user!.fotoURL ?? '')
                : null,
            child: user?.fotoURL == null
                ? const Icon(Icons.person, size: 32, color: Color(0xFF1A202C))
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.providerName ?? "Prestador",
                  user?.nome ?? user?.razao_social ?? 'sem nome',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.3,
                  ),
                ),
                if (widget.post.providerCompany != null)
                if (user?.ramoNome != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.post.providerCompany!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF777777),
                    ),
                  ),
                    user!.ramoNome!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1A202C).withOpacity(0.7),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    
                    if (user!.cidade != null) ...[
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFF1A202C)),
                      const SizedBox(width: 4),
                      Text(
                        user!.cidade!,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF1A202C).withOpacity(0.7),
                        ),
                      ),
                    ],
                    if (widget.post.createdAt != null) ...[
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.createdAt!.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
              ],
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildMedia(String url, int index) {
    final isVideo = _isVideo(url);
    if (isVideo) {
      final controller = _controllers[index];
      if (controller == null || !controller.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return VisibilityDetector(
        key: Key(url),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.6) {
            controller.play();
          } else {
            controller.pause();
          }
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: ClipRRect(
          
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
  // Descrição do serviço
  Widget _buildDescription() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9, // largura fixa a 90% da tela
    padding: const EdgeInsets.all(16.0),
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
          Text(
            'Descrição do Serviço',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
     
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFE6E8EB),
          child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
        ),
      ),
    );
  }
          const SizedBox(height: 12),
        Text(
          widget.post.descricao ?? 'Sem descrição disponível.',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: const Color(0xFF1A202C).withOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildMediaCarousel() {
    final media = widget.post.mediaUrls ?? [];
    if (media.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: media.length,
          itemBuilder: (context, index, _) => _buildMedia(media[index], index),
          options: CarouselOptions(
            height: 420,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (i, _) {
              setState(() {
                _currentIndex = i;
              });
              _controllers.forEach((_, c) => c.pause());
            },
          ),
        ),
        if (media.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                media.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 9 : 6,
                  height: _currentIndex == i ? 9 : 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? Colors.black
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    final name = widget.post.providerName ?? 'Prestador';
    final service = widget.post.serviceName ?? '';
    final desc = widget.post.description ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$name ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15.5,
                  ),
                ),
                TextSpan(
                  text: service,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15.5,
                  ),
                ),
              ],
            ),
          ),
          if (desc.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                desc,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: Color(0xFF444444),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            "Publicado há 2h",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.5,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
        elevation: 0.8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Detalhes",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
             IconButton(onPressed:() => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditarPostPage(post: ServicePost(),))), icon: Icon(Icons.edit_note_outlined, color: Colors.black,size: MediaQuery.of(context).size.width *0.1,))
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildMediaCarousel(),
            _buildDescription(),
            const SizedBox(height: 30),
          ],
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar( flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    )),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.post.descricao ?? 'Detalhes do Serviço',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
  icon: const Icon(Icons.edit, color: Colors.white),
  onPressed: () async {
    final updatedPost = await Navigator.of(context).push<ServicePost>(
      MaterialPageRoute(
        builder: (context) => EditarPostPage(post: widget.post),
      ),
    );

    // if (updatedPost != null) {
    //   setState(() {
    //     widget.post.updateFrom(updatedPost); // método para atualizar o post atual
    //   });
    // }
  },
),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              _buildProviderInfo(), 
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                       _buildMediaCarousel(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                  
                     
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
