import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:tcc/ver_mais/VerMais.dart';

class EditarPostPage extends StatefulWidget {
  final ServicePost post;

  const EditarPostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<EditarPostPage> createState() => _EditarPostPageState();
}

class _EditarPostPageState extends State<EditarPostPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late TextEditingController _serviceNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _providerNameController;
  late TextEditingController _providerCompanyController;

  late List<String> _mediaUrls;
  late String _providerPhotoUrl;
  final ImagePicker _picker = ImagePicker();
  int _currentMediaIndex = 0;
  final PageController _pageController = PageController();

  Map<int, VideoPlayerController?> _videoControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _serviceNameController =
        TextEditingController(text: widget.post.serviceName);
    _descriptionController =
        TextEditingController(text: widget.post.description);
    _providerNameController =
        TextEditingController(text: widget.post.providerName);
    _providerCompanyController =
        TextEditingController(text: widget.post.providerCompany);

    _mediaUrls = List.from(widget.post.mediaUrls ?? []);
    _providerPhotoUrl = widget.post.providerPhotoUrl ?? '';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < _mediaUrls.length; i++) {
      final url = _mediaUrls[i];
      if (_isVideo(url)) {
        final controller =
            url.startsWith('http') ? VideoPlayerController.network(url) : VideoPlayerController.file(File(url));
        controller.initialize().then((_) {
          if (mounted) setState(() {});
        });
        _videoControllers[i] = controller;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _providerNameController.dispose();
    _providerCompanyController.dispose();
    _pageController.dispose();
    _videoControllers.forEach((_, controller) => controller?.dispose());
    super.dispose();
  }

  bool _isVideo(String url) {
    return url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.avi');
  }

  Future<void> _pickProviderPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _providerPhotoUrl = image.path;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao selecionar foto: $e');
    }
  }

  Future<void> _pickMedia() async {
    try {
      final XFile? media = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (media != null) {
        setState(() {
          _mediaUrls.add(media.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao selecionar mídia: $e');
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _videoControllers[index]?.dispose();
      _videoControllers.remove(index);
      _mediaUrls.removeAt(index);
      if (_currentMediaIndex >= _mediaUrls.length && _currentMediaIndex > 0) {
        _currentMediaIndex = _mediaUrls.length - 1;
      }
    });
  }

  Future<void> _replaceMedia(int index) async {
    try {
      final XFile? media = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (media != null) {
        setState(() {
          _videoControllers[index]?.dispose();
          _videoControllers.remove(index);
          _mediaUrls[index] = media.path;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao substituir mídia: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_serviceNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Nome do serviço não pode estar vazio');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Descrição não pode estar vazia');
      return;
    }

    if (_providerNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Nome do prestador não pode estar vazio');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final updatedPost = widget.post.copyWith(
      serviceName: _serviceNameController.text.trim(),
      description: _descriptionController.text.trim(),
      providerName: _providerNameController.text.trim(),
      providerCompany: _providerCompanyController.text.trim(),
      mediaUrls: _mediaUrls,
      providerPhotoUrl: _providerPhotoUrl,
    );

    setState(() {
      _isLoading = false;
    });

    _showSuccessSnackBar('Post atualizado com sucesso!');
    Navigator.pop(context, updatedPost);
  }

  void _cancelChanges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Todas as alterações não salvas serão perdidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar editando'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade700,
                          Colors.purple.shade600,
                        ],
                      ),
                    ),
                  ),
                  title: const Text(
                    'Editar Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _cancelChanges,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save, color: Colors.white),
                    onPressed: _isLoading ? null : _saveChanges,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMediaCarousel(isSmallScreen),
                          const SizedBox(height: 24),
                          _buildProviderSection(isSmallScreen),
                          const SizedBox(height: 24),
                          _buildTextField(
                            controller: _serviceNameController,
                            label: 'Nome do Serviço',
                            icon: Icons.work,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Descrição',
                            icon: Icons.description,
                            maxLines: null,
                            minLines: 3,
                          ),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // --- MÉTODOS AUXILIARES COMPLETOS ---
  Widget _buildMediaCarousel(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: isSmallScreen ? 250 : 400,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              color: Colors.grey.shade200,
            ),
            child: _mediaUrls.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Nenhuma mídia', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _mediaUrls.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentMediaIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final url = _mediaUrls[index];
                          return _buildMediaItem(url, index);
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            _buildMediaButton(
                              icon: Icons.swap_horiz,
                              onPressed: () => _replaceMedia(_currentMediaIndex),
                              tooltip: 'Substituir',
                            ),
                            const SizedBox(width: 8),
                            _buildMediaButton(
                              icon: Icons.delete,
                              onPressed: () => _removeMedia(_currentMediaIndex),
                              tooltip: 'Remover',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      if (_mediaUrls.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _mediaUrls.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentMediaIndex == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _pickMedia,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Adicionar Mídia'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(String url, int index) => _isVideo(url) ? _buildVideoPlayer(url, index) : _buildImageViewer(url);

  Widget _buildImageViewer(String url) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: url.startsWith('http')
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildMediaError(),
              loadingBuilder: (_, child, progress) => progress == null ? child : _buildMediaLoading(),
            )
          : Image.file(
              File(url),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildMediaError(),
            ),
    );
  }

  Widget _buildVideoPlayer(String url, int index) {
    if (!_videoControllers.containsKey(index)) {
      final controller = url.startsWith('http') ? VideoPlayerController.network(url) : VideoPlayerController.file(File(url));
      controller.initialize().then((_) { if (mounted) setState(() {}); });
      _videoControllers[index] = controller;
    }

    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) return _buildMediaLoading();
    if (controller.value.hasError) return _buildMediaError();

    return GestureDetector(
      onTap: () {
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
          ),
          if (!controller.value.isPlaying)
            Container(
              decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaLoading() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando...')]));

  Widget _buildMediaError() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400), const SizedBox(height: 16), Text('Erro ao carregar mídia', style: TextStyle(color: Colors.grey.shade600, fontSize: 16))]));

  Widget _buildMediaButton({required IconData icon, required VoidCallback onPressed, required String tooltip, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed, tooltip: tooltip),
    );
  }

  Widget _buildProviderSection(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informações do Prestador', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: _pickProviderPhoto,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue.shade300, width: 3)),
                      child: ClipOval(
                        child: _providerPhotoUrl.startsWith('http')
                            ? Image.network(_providerPhotoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder())
                            : Image.file(File(_providerPhotoUrl), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder()),
                      ),
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(controller: _providerNameController, label: 'Nome', icon: Icons.person, compact: true),
                    const SizedBox(height: 12),
                    _buildTextField(controller: _providerCompanyController, label: 'Empresa', icon: Icons.business, compact: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() => Container(color: Colors.grey.shade300, child: Icon(Icons.person, size: 40, color: Colors.grey.shade600));

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, int? maxLines = 1, int? minLines, bool compact = false}) {
    return Container(
      decoration: BoxDecoration(
        color: compact ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: const Text('Salvar'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: _cancelChanges,
            child: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ],
    );
  }
}
