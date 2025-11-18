// merged_editar_perfil.dart
// Mantém design do GPT (CustomDropdownMultiSelect, seções) + backend do usuário (Provider, AuthController, Userform, repositórios)

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

// Seus imports de backend / models / repos
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/models/ramo.dart';
import 'package:tcc/data/models/Categoria.dart';
import 'package:tcc/data/repositories/ramo_repository.dart';
import 'package:tcc/data/repositories/categoria_repository.dart';
import 'package:tcc/data/http/dio_client.dart' as apiHttp;

final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  // controllers -> usamos os mesmos nomes do seu código original
  final telefoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final siteController = TextEditingController();
  final instagramController = TextEditingController();
  final descricaoController = TextEditingController();
  final nomeController = TextEditingController();

  // foto e fotoUrl (mesma lógica do seu Perfil)
  File? foto;
  String? fotoUrl;

  // listas para o CustomDropdownMultiSelect (valores como String)
  List<String> listaAreas = [];
  List<String> listaCategorias = [];
  List<String> areasSelecionadas = [];
  List<String> categoriasSelecionadas = [];

  // loading
  bool loading = true;

  // repositórios
  late final RamoRepository ramoRepository;
  late final CategoriaRepository categoriaRepository;

  // tipo de usuário (empresa, prestador, etc)
  String tipoUsuario = '';

  @override
  void initState() {
    super.initState();
    ramoRepository = RamoRepository(client: apiHttp.DioClient.dio);
    categoriaRepository = CategoriaRepository(client: apiHttp.DioClient.dio);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarTela();
    });
  }

  Future<void> _iniciarTela() async {
    setState(() => loading = true);

    final authController = context.read<AuthController>();
    final user = authController.usuario;

    // preenche controllers com dados do usuário (se houver)
    descricaoController.text = user?.descricao ?? '';
    telefoneController.text = user?.telefone ?? '';
    whatsappController.text = user?.whatsapp ?? '';
    instagramController.text = user?.instagram ?? '';
    siteController.text = user?.site ?? '';
    nomeController.text = user?.nome ?? '';

    tipoUsuario = user?.tipo ?? '';

    // carrega foto URL pelo AuthController (se existir)
    try {
      final imagem = await authController.getFoto();
      fotoUrl = imagem;
    } catch (_) {
      fotoUrl = null;
    }

    // carregar listas de ramos (áreas) e categorias a partir dos repositórios
    try {
      final ramos = await ramoRepository.getRamo();
      listaAreas = ramos.map((r) => r.nome ?? '').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      listaAreas = [];
      // opcional: print erro
      // print("Erro ao carregar ramos: $e");
    }

    try {
      final categorias = await categoriaRepository.getCategoria();
      listaCategorias = categorias.map((c) => c.nome ?? '').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      listaCategorias = [];
      // print("Erro ao carregar categorias: $e");
    }

    // se o usuário já tiver ramos/categorias gravadas, pre-popular seleção (por nome)
    try {
      if (user != null) {
        if (tipoUsuario == 'prestador') {
          if (user.ramoNome != null && user.ramoNome!.isNotEmpty) {
            areasSelecionadas = [user.ramoNome!];
          }
        }
        if (tipoUsuario == 'empresa') {
          if (user.categoriaNome != null && user.categoriaNome!.isNotEmpty) {
            categoriasSelecionadas = [user.categoriaNome!];
          }
        }
      }
    } catch (_) {}

    setState(() => loading = false);
  }

  Future<void> _salvarEdicoes() async {
    final authController = context.read<AuthController>();
    final userForm = Userform();

    userForm.foto = foto;
    userForm.telefone = telefoneController.text;
    userForm.whatsapp = whatsappController.text;
    userForm.instagram = instagramController.text;
    userForm.site = siteController.text;
    userForm.descricao = descricaoController.text;

    // se quiser enviar ramo/categoria por nome ou id, depende do Userform.
    // Aqui enviamos nomes (já que CustomDropdownMultiSelect trabalha com strings).
    if (tipoUsuario == 'prestador' && areasSelecionadas.isNotEmpty) {
      userForm.ramo = areasSelecionadas.join(','); // ajuste conforme seu backend espera
    }
    if (tipoUsuario == 'empresa' && categoriasSelecionadas.isNotEmpty) {
      userForm.categoria = categoriasSelecionadas.join(','); // ajuste conforme backend
    }

    try {
      final userEdit = await authController.update(userForm);
      if (userEdit != null) {
        context.read<AuthController>().setUsuario(userEdit);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Perfil atualizado com sucesso!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      // lidar com erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao atualizar perfil: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // handler de imagem (usa a mesma abordagem do seu Perfil widget)
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        foto = File(pickedFile.path);
      });
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
  void dispose() {
    telefoneController.dispose();
    whatsappController.dispose();
    siteController.dispose();
    instagramController.dispose();
    descricaoController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // se quiser: final auth = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(15),
              children: [
                // PERFIL (foto + nome) — usando design do GPT (CircleAvatar + onTap)
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: foto != null
                              ? FileImage(foto!)
                              : (fotoUrl != null && fotoUrl!.isNotEmpty)
                                  ? NetworkImage(fotoUrl!) as ImageProvider
                                  : null,
                          child: (foto == null && (fotoUrl == null || fotoUrl!.isEmpty))
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // mostra nome do auth controller se existir
                      Builder(builder: (ctx) {
                        final authController = context.read<AuthController>();
                        final user = authController.usuario;
                        return Text(
                          user?.nome ?? '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Descrição (MyTextField do GPT substituído por um TextField customizado)
                DescricaoSection(controller: descricaoController),

                const SizedBox(height: 20),

                // Area de atuação (apenas prestador) -> CustomDropdownMultiSelect
                if (tipoUsuario == 'prestador')
                  AreaAtuacaoSection(
                    items: listaAreas,
                    selectedItems: areasSelecionadas,
                    onChanged: (v) => setState(() => areasSelecionadas = v),
                  ),

                // Categoria (apenas empresa)
                if (tipoUsuario == 'empresa')
                  CategoriaSection(
                    items: listaCategorias,
                    selectedItems: categoriasSelecionadas,
                    onChanged: (v) => setState(() => categoriasSelecionadas = v),
                  ),

                const SizedBox(height: 20),

                // CONTATOS
                ContatosSection(
                  telefoneController: telefoneController,
                  whatsappController: whatsappController,
                  instagramController: instagramController,
                  siteController: siteController,
                ),

                const SizedBox(height: 30),

                // Botão salvar (mantém lógica do seu update via AuthController)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.indigoAccent,
                  ),
                  onPressed: _salvarEdicoes,
                  child: const Text(
                    "Salvar Alterações",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// DESCRIÇÃO (simples TextField, aparência parecida com seu código)
///////////////////////////////////////////////////////////////
class DescricaoSection extends StatelessWidget {
  final TextEditingController controller;

  const DescricaoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 6,
      maxLength: 255,
      decoration: InputDecoration(
        hintText: "Escreva uma breve descrição...",
        labelText: "Informações de descrição",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// ÁREA DE ATUAÇÃO — usa CustomDropdownMultiSelect (strings)
///////////////////////////////////////////////////////////////
class AreaAtuacaoSection extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const AreaAtuacaoSection({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMultiSelect(
      label: "Áreas de Atuação",
      items: items,
      selectedItems: selectedItems,
      onChanged: onChanged,
    );
  }
}

///////////////////////////////////////////////////////////////
/// CATEGORIA — usa CustomDropdownMultiSelect (strings)
///////////////////////////////////////////////////////////////
class CategoriaSection extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const CategoriaSection({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMultiSelect(
      label: "Categorias",
      items: items,
      selectedItems: selectedItems,
      onChanged: onChanged,
    );
  }
}

///////////////////////////////////////////////////////////////
/// CONTATOS (telefone, Whatsapp, Instagram, site)
///////////////////////////////////////////////////////////////
class ContatosSection extends StatelessWidget {
  final TextEditingController telefoneController;
  final TextEditingController whatsappController;
  final TextEditingController instagramController;
  final TextEditingController siteController;

  const ContatosSection({
    super.key,
    required this.telefoneController,
    required this.whatsappController,
    required this.instagramController,
    required this.siteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
          controller: telefoneController,
          hintText: "Telefone",
          keyboardType: TextInputType.phone,
          inputFormatters: [maskFormatter],
        ),
        const SizedBox(height: 15),
        MyTextField(
          controller: whatsappController,
          hintText: "Whatsapp",
          keyboardType: TextInputType.phone,
          inputFormatters: [maskFormatter],
        ),
        const SizedBox(height: 15),
        MyTextField(
          controller: instagramController,
          hintText: "Instagram",
        ),
        const SizedBox(height: 15),
        MyTextField(
          controller: siteController,
          hintText: "Site",
        ),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final List? inputFormatters;

  const MyTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: 1,
      maxLines: maxLines,
      inputFormatters: inputFormatters?.cast() ?? null,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// CustomDropdownMultiSelect (do GPT) — sem mudanças lógicas significativas
///////////////////////////////////////////////////////////////
class CustomDropdownMultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;
  final String label;
  final String hintText;

  const CustomDropdownMultiSelect({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.label = '',
    this.hintText = 'Selecione',
  });

  @override
  State<CustomDropdownMultiSelect> createState() =>
      _CustomDropdownMultiSelectState();
}

class _CustomDropdownMultiSelectState extends State<CustomDropdownMultiSelect> {
  late List<String> _currentSelected;
  late List<String> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSelected = List.from(widget.selectedItems);
    _filteredItems = List.from(widget.items);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant CustomDropdownMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      _currentSelected = List.from(widget.selectedItems);
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((e) => e.toLowerCase().contains(q))
            .toList(growable: false);
      }
    });
  }

  Future<void> _openDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return _MultiSelectDialog(
          items: widget.items,
          initialSelected: _currentSelected,
          hintText: widget.label.isEmpty ? widget.hintText : widget.label,
        );
      },
    );

    if (result != null) {
      setState(() {
        _currentSelected = result;
      });
      widget.onChanged(_currentSelected);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final display = _currentSelected.isEmpty ? widget.hintText : _currentSelected.join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        GestureDetector(
          onTap: _openDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    display,
                    style: TextStyle(
                      color: _currentSelected.isEmpty ? Colors.grey.shade600 : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog usado pelo CustomDropdownMultiSelect
class _MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelected;
  final String hintText;

  const _MultiSelectDialog({
    required this.items,
    required this.initialSelected,
    required this.hintText,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> _tempSelected;
  late List<String> _filtered;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.initialSelected);
    _filtered = List.from(widget.items);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(widget.items);
      } else {
        _filtered = widget.items.where((e) => e.toLowerCase().contains(q)).toList(growable: false);
      }
    });
  }

  void _onItemToggle(String item, bool value) {
    setState(() {
      if (value) {
        if (!_tempSelected.contains(item)) _tempSelected.add(item);
      } else {
        _tempSelected.remove(item);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.hintText),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Nenhum item encontrado'))
                  : Scrollbar(
                      child: ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = _filtered[index];
                          final checked = _tempSelected.contains(item);
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(item),
                            value: checked,
                            onChanged: (v) => _onItemToggle(item, v ?? false),
                            activeColor: theme.colorScheme.primary,
                            tileColor: Colors.white,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.initialSelected),
          child: const Text('CANCELAR'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_tempSelected),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
