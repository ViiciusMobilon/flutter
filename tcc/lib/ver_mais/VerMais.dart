import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tcc/Relacionaveis_a_perfil/perfil_de_outro_usuario.dart';
import 'package:tcc/ver_mais/editar_post.dart' show EditarPostPage;
import 'package:video_player/video_player.dart';
  import 'package:tcc/service_post.dart';

// Widget principal da página de detalhes do post
class VerMaisPage extends StatefulWidget {
  final ServicePost post; // Recebe os dados do post


  VerMaisPage({Key? key, required this.post}) : super(key: key);

  @override
  State<VerMaisPage> createState() => _VerMaisPageState();
}

class _VerMaisPageState extends State<VerMaisPage>
    with SingleTickerProviderStateMixin {
  bool isLiked = false; // Estado do like
  int likeCount = 0; // Contador de likes
  int _currentMediaIndex = 0; // Índice atual do carrossel
  Map<int, VideoPlayerController?> _videoControllers = {}; // Controladores de vídeo

  late AnimationController _animationController; // Controlador de animação
  late Animation<double> _fadeAnimation; // Animação de fade
  late Animation<Offset> _slideAnimation; // Animação de slide

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked ?? false; // Inicializa o like
    likeCount = widget.post.likeCount ?? 0; // Inicializa contagem de likes

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

  // Inicializa controladores de vídeo para cada URL de vídeo
  void _initializeVideoControllers() {
    if (widget.post.mediaUrls != null) {
      for (int i = 0; i < widget.post.mediaUrls!.length; i++) {
        String url = widget.post.mediaUrls![i];
        if (_isVideoUrl(url)) {
          _videoControllers[i] = VideoPlayerController.network(url)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
        }
      }
    }
  }

  // Checa se o arquivo é vídeo
  bool _isVideoUrl(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.avi');
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoControllers.forEach((key, controller) {
      controller?.dispose();
    });
    super.dispose();
  }

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
  Widget _buildMediaCarousel() {
    if (widget.post.mediaUrls == null || widget.post.mediaUrls!.isEmpty) {
      return Container(
        height: 300,
        color: const Color(0xFFF5F7FA),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: widget.post.mediaUrls!.length,
      itemBuilder: (context, index, realIndex) {
        return _buildMediaItem(widget.post.mediaUrls![index], index);
      },
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        enableInfiniteScroll: widget.post.mediaUrls!.length > 1,
        autoPlay: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentMediaIndex = index;
          });
          _videoControllers.forEach((key, controller) {
            if (controller != null && controller.value.isPlaying) {
              controller.pause();
            }
          });
        },
      ),
    );
  }

  // Informações do prestador
  Widget _buildProviderInfo() {
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
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PerfilDeOutroUsuario(),
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFF5F7FA),
                  backgroundImage: widget.post.providerPhotoUrl != null
                      ? NetworkImage(widget.post.providerPhotoUrl!)
                      : null,
                  child: widget.post.providerPhotoUrl == null
                      ? const Icon(Icons.person, size: 32, color: Color(0xFF1A202C))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.providerName ?? 'Prestador',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      if (widget.post.providerCompany != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.post.providerCompany!,
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
                          if (widget.post.providerRating != null) ...[
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              widget.post.providerRating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A202C),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          if (widget.post.providerCity != null) ...[
                            const Icon(Icons.location_on,
                                size: 16, color: Color(0xFF1A202C)),
                            const SizedBox(width: 4),
                            Text(
                              widget.post.providerCity!,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF1A202C).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        if (widget.post.serviceName != null) ...[
          Text(
            widget.post.serviceName!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          widget.post.description ?? 'Sem descrição disponível.',
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


  // Botões de ação (like e compartilhar)

  // Build principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          widget.post.providerName ?? 'Detalhes do Serviço',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
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

// Modelo de dados do post
