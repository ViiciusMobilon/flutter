import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tcc/cadastro/dropdownCategoria.dart';
import 'package:tcc/cadastro/dropdownRamo.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/Categoria.dart';
import 'package:tcc/data/models/Skill.dart';
import 'package:tcc/data/models/ramo.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/repositories/categoria_repository.dart';
import 'package:tcc/data/http/dio_client.dart' as apiHttp;
import 'package:tcc/data/repositories/ramo_repository.dart';
import 'package:tcc/data/repositories/skill_repository.dart';


final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  bool loading = true;
  RamoModel? ramoSelecionado;
  CategoriaModel? categoriaselecionado;
  List<String> skillsItems = [];
  List<SkillModel> skillsModelList = [];

  File? fotoSelecionada;



  String? erro;

  // Controllers dos campos
  final descricaoController = TextEditingController();
  final nomeController = TextEditingController();
  final whatsappController = TextEditingController();
  final instagramController = TextEditingController();
  final siteController = TextEditingController();

  // Quando escolhe o ramo
  void onRamoSelecionado(RamoModel? ramo) {
    setState(() {
      ramoSelecionado = ramo;
    });
  }

  void onCategoriaSelecionado(CategoriaModel? categoria) {
    setState(() {
      categoriaselecionado = categoria;
    });
  }

  void onClearerror() {
    setState(() {
      erro = null;
    });
  }

  Future<void> carregarRamoInicial() async {
    final usuario = context.read<AuthController>().usuario;

    if (usuario?.ramoNome == null) return;

    final nomeRamoUser = usuario!.ramoNome;

    final repository =
        RamoRepository(client: apiHttp.DioClient.dio);
    final listaRamos = await repository.getRamo();

    final encontrado = listaRamos.firstWhere(
      (r) => r.nome.toLowerCase() == nomeRamoUser!.toLowerCase(),
      orElse: () => RamoModel(id: 0, nome: nomeRamoUser!),
    );

    setState(() {
      ramoSelecionado = encontrado;
    });
  }

  Future<void> carregarCategoriaInicial() async {
    final usuario = context.read<AuthController>().usuario;

    if (usuario?.categoriaNome == null) return;

    final nomeCatUser = usuario!.categoriaNome;

    final repository =
        CategoriaRepository(client: apiHttp.DioClient.dio);
    final listaCat = await repository.getCategoria();

    final encontrado = listaCat.firstWhere(
      (r) => r.nome.toLowerCase() == nomeCatUser!.toLowerCase(),
      orElse: () => CategoriaModel(id: 0, nome: nomeCatUser!),
    );

    setState(() {
      categoriaselecionado = encontrado;
    });
  }

  Future<void> loadSkills() async {
    try {
      final usuario = context.read<AuthController>().usuario;
      final repo = SkillRepository(client: Dio());
      final skillModels = await repo.getSkill(id: usuario!.ramo!);

      setState(() {
        skillsItems = skillModels.map((e) => e.nome).toList();
        skillsModelList = skillModels;
        loading = false;
      });
    } catch (e) {
      print("Erro ao carregar skills: $e");
      setState(() => loading = false);
    }
  }


  @override
  void initState() {
    super.initState();

    final usuario = context.read<AuthController>().usuario;

    // Preencher Controllers
    descricaoController.text = usuario?.descricao ?? '';
    nomeController.text = usuario?.nome ?? usuario?.razao_social ?? '';
    whatsappController.text = usuario?.telefone ?? '';
    instagramController.text = usuario?.instagram ?? '';
    siteController.text = usuario?.site ?? '';

    carregarRamoInicial();
    carregarCategoriaInicial();
    loadSkills();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.read<AuthController>().usuario;
    usuario!.skills?.forEach((skill) {
      print('skills: ${skill.nome}');
    });


    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Center(child: Perfil(fotoInicialUrl: usuario.fotoURL, onFotoSelecionada: (File? novaFoto) {
    setState(() {
      fotoSelecionada = novaFoto;
    });
  },
)),
            Disponivel(inicial: usuario!.status!,),
            SizedBox(height: 20),

            // DESCRIÇÃO — AGORA PREENCHIDA
            TextField(
              controller: descricaoController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 6,
              maxLength: 255,
              decoration: InputDecoration(
                hintText: "Escreva uma breve descrição...",
                labelText: "Informações de descrição",
                labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(121, 180, 217, 1),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),

            if (usuario!.tipo == 'prestador')
              Area(
                onRamoSelecionado: onRamoSelecionado,
                erro: erro,
                onClearerror: onClearerror,
                ramoInicial: ramoSelecionado,
              ),

            if (usuario.tipo == 'empresa')
              Categoria(
                onCategoriaSelecionado: onCategoriaSelecionado,
                erro: erro,
                onClearerror: onClearerror,
                catInicial: categoriaselecionado,
              ),

            SizedBox(height: 30),

            // NOME — PRÉ-PREENCHIDO
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                hintText: "Fulano de Tal",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 50),

            Center(
              child: Text(
                "Contatos",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 30),

            // WHATSAPP — PRÉ-PREENCHIDO
            TextField(
              controller: whatsappController,
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(
                labelText: "WhatsApp",
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                hintText: "(00) 00000-0000",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 30),

            // INSTAGRAM — PRÉ-PREENCHIDO
            TextField(
              controller: instagramController,
              decoration: InputDecoration(
                labelText: "Instagram",
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                hintText: "@seuusuario",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 30),

            // SITE — PRÉ-PREENCHIDO
            TextField(
              controller: siteController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: "Site",
                labelStyle: TextStyle(color: Colors.black, fontFamily: "Poppins"),
                hintText: "www.seusite.com.br",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 30),
             CustomDropdownMultiSelect(  
              items:skillsItems,
              initialSelected: usuario.skills!.map((e) => e.nome).toList(),
              hintText: 'Selecione suas especialidades',
              onSelectionChanged:(value) {
                setState(() {
                  skillsItems = value; // ✅ agora pega corretamente
                });

              }, // Será implementado conforme a necessidade
            ),
            const SizedBox(height: 50),

            Center(child: Botao(
              onPressed: () async {
      final controller = context.read<AuthController>();
      final usuario = controller.usuario;
      final selectedSkillIds = skillsModelList
        .where((s) => skillsItems.contains(s.nome))
        .map((s) => s.id)
        .toList();
      // Preenche o formulário com os controllers e os valores do usuário
      final formulario = Userform(
        nome: nomeController.text,
        descricao: descricaoController.text,
        telefone: whatsappController.text,
        instagram: instagramController.text,
        site: siteController.text,
        foto: fotoSelecionada, // pegar a imagem atual do widget Perfil
        ramo: ramoSelecionado?.id,
        categoria: categoriaselecionado?.id,
        tipo: usuario?.tipo,
        skills: selectedSkillIds);

      try {
        await controller.update(formulario);

        // Mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "Dados atualizados com sucesso!",
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Erro ao atualizar: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

            )),
          ],
        ),
      ),
    );
  }
}


class Descricao extends StatefulWidget {
  final String? descricaoInicial;

  const Descricao({super.key, this.descricaoInicial});

  @override
  State<Descricao> createState() => _DescricaoState();
}

class _DescricaoState extends State<Descricao> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.descricaoInicial ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
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


class Perfil extends StatefulWidget {
  final String? fotoInicialUrl; // Foto vinda do servidor (URL)
  final ValueChanged<File?>? onFotoSelecionada;

  Perfil({super.key, this.fotoInicialUrl, required this.onFotoSelecionada});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializa com URL ou mantém File nulo
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      if (widget.onFotoSelecionada != null) {
        widget.onFotoSelecionada!(_image); // Passa foto para o form
      }
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
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: ClipOval(
        child: _image != null
            ? Image.file(
                _image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : (widget.fotoInicialUrl != null
                ? Image.network(
                    widget.fotoInicialUrl!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _placeholder();
                    },
                  )
                : _placeholder()),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.camera_alt,
        size: 50,
        color: Colors.white70,
      ),
    );
  }
}


class Disponivel extends StatefulWidget {
  final bool inicial;

  const Disponivel({super.key, required this.inicial});

  @override
  State<Disponivel> createState() => _DisponivelState();
}

class _DisponivelState extends State<Disponivel> {
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _isAvailable = !_isAvailable;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAvailable ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_isAvailable ? Icons.check_circle : Icons.cancel),
              const SizedBox(width: 8),
              Text(
                _isAvailable ? 'Disponível' : 'Indisponível',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Nome extends StatelessWidget {
  final String? nomeInicial;

  const Nome({super.key, this.nomeInicial});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: nomeInicial ?? "");

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Nome",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
class Whatsapp extends StatelessWidget {
  final String? inicial;

  const Whatsapp({super.key, this.inicial});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: inicial ?? "");

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [maskFormatter],
      decoration: InputDecoration(
        labelText: "WhatsApp",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "(00) 00000-0000",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class Site extends StatelessWidget {
  final String? inicial;

  const Site({super.key, this.inicial});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: inicial ?? "");

    return TextField(
      controller: controller,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: "Site",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "www.seusite.com.br",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}


class Insta extends StatelessWidget {
  final String? inicial;

  const Insta({super.key, this.inicial});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: inicial ?? "");

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Instagram",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "@seuusuario",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}


class Botao extends StatefulWidget {
  final Future<void> Function()? onPressed;

  const Botao({super.key, this.onPressed});

  @override
  State<Botao> createState() => _BotaoState();
}

class _BotaoState extends State<Botao> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading
          ? null
          : () async {
              if (widget.onPressed != null) {
                setState(() => loading = true);
                await widget.onPressed!();
                setState(() => loading = false);

                // 🌟 Mensagem de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Dados atualizados com sucesso!",
                      style: TextStyle(fontSize: 16),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}


/// Widget reutilizável: dropdown multi-select com pesquisa.
class CustomDropdownMultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelected;
  final ValueChanged<List<String>> onSelectionChanged;
  final String hintText;

  CustomDropdownMultiSelect({
    super.key,
    required this.items,
    required this.initialSelected,
    required this.onSelectionChanged,
    this.hintText = '',
  });

  @override
  State<CustomDropdownMultiSelect> createState() =>
      _CustomDropdownMultiSelectState();
}

class _CustomDropdownMultiSelectState extends State<CustomDropdownMultiSelect> {
  late List<String> _selected;
  late List<String> _filteredItems;
  final Color checkboxColor = const Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _filteredItems = List.from(widget.items);
  }

  void _openSelectDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return _MultiSelectDialog(
          items: widget.items,
          initialSelected: _selected,
          checkboxColor: checkboxColor,
          hintText: widget.hintText,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selected = result;
      });
      widget.onSelectionChanged(_selected);
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropdownMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      _selected = List.from(widget.initialSelected);
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = _selected.isEmpty ? widget.hintText : _selected.join(', ');
    return GestureDetector(
      onTap: _openSelectDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white, // fundo branco
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                display,
                style: TextStyle(
                  color: _selected.isEmpty ? Colors.grey.shade600 : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

/// Dialog com pesquisa e checkboxes (fundo branco)
class _MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelected;
  final Color checkboxColor;
  final String hintText;

  const _MultiSelectDialog({
    required this.items,
    required this.initialSelected,
    required this.checkboxColor,
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
        _filtered = widget.items
            .where((e) => e.toLowerCase().contains(q))
            .toList(growable: false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // fundo branco do dialog
      title: Text(widget.hintText.isEmpty ? 'Selecione' : widget.hintText),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            // Search field com fundo branco
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
              focusColor: Colors.grey,
                hintText: 'Pesquisar...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey
                  ),
                
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              
              
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
        
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Nenhum item encontrado'))
                  : Scrollbar(
                      child: ListView.builder(
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final item = _filtered[index];
                          final checked = _tempSelected.contains(item);
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: widget.checkboxColor,
                            checkColor: Colors.white,
                            title: Text(item),
                            value: checked,
                            onChanged: (v) => _onItemToggle(item, v ?? false),
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
          child:  Text('CANCELAR', style: TextStyle(color: widget.checkboxColor),),

        ),
        FilledButton(
          // Using FilledButton for Material 3; if older SDK use ElevatedButton
          onPressed: () => Navigator.of(context).pop(_tempSelected),
          style: FilledButton.styleFrom(
            backgroundColor: widget.checkboxColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}