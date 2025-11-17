import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  @override
  Widget build(BuildContext context) {
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
            const Center(child: Perfil()),
            const Disponivel(),
            const SizedBox(height: 20),
            const Descricao(),
            const SizedBox(height: 20),
            const Area(),
            const SizedBox(height: 30),
            const Nome(),
            const SizedBox(height: 50),
            Center(
              child: Text(
                "Contatos",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Whatsapp(),
            const SizedBox(height: 30),
            const Insta(),
            const SizedBox(height: 30),
            const Site(),
            const SizedBox(height: 50),
            Center(
              child: Text(
                "Especialidades",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
             CustomDropdownMultiSelect(  
              items: [
                'Desenvolvimento Web',
                'Design Gráfico',
                'Marketing Digital',
                'Consultoria de TI',
                'Suporte Técnico',
                'Redes e Infraestrutura',
                'Segurança da Informação',
                'Desenvolvimento Mobile',
                'Análise de Dados',
                'Inteligência Artificial',
              ],
              initialSelected: [],
              hintText: 'Selecione suas especialidades',
              onSelectionChanged:(value) {
                
              }, // Será implementado conforme a necessidade
            ),
            const SizedBox(height: 50),
            const Center(child: Botao()),
          ],
        ),
      ),
    );
  }
}

class Descricao extends StatefulWidget {
  const Descricao({super.key});

  @override
  State<Descricao> createState() => _DescricaoState();
}

class _DescricaoState extends State<Descricao> {
  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
            : Container(
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
              ),
      ),
    );
  }
}

class Disponivel extends StatefulWidget {
  const Disponivel({super.key});

  @override
  State<Disponivel> createState() => _DisponivelState();
}

class _DisponivelState extends State<Disponivel> {
  bool _isAvailable = true;

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
  const Nome({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const Whatsapp({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const Site({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const Insta({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
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

class Botao extends StatelessWidget {
  const Botao({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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
        child: const Center(
          child: Text(
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

class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  final ValueNotifier<String> dropValue = ValueNotifier('');
  final List<String> dropOpcoes = ['Tecnologia', 'Saúde', 'Educação'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: dropValue,
      builder: (context, value, _) {
        return DropdownSearch<String>(
          items: (filter, infiniteScrollProps) => dropOpcoes,
          selectedItem: value.isEmpty ? null : value,
          onChanged: (newValue) {
            dropValue.value = newValue ?? '';
          },

          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
            menuProps: MenuProps(
              backgroundColor: Colors.white, // fundo branco no menu
            ),

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Pesquisar área...',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white, // fundo branco no campo de busca
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(121, 180, 217, 1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Área de atuação',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              hintText: 'Escolha a área de atuação',

              filled: true,
              fillColor: Colors.white, // fundo branco no dropdown

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
          ),
        );
      },
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