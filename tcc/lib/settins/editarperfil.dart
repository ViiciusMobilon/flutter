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
            const AreaMultiSelect(),
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
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Pesquisar área...',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Área de atuação',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              hintText: 'Escolha a área de atuação',
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

class DropdownFixPage extends StatefulWidget {
  const DropdownFixPage({super.key});

  @override
  State<DropdownFixPage> createState() => _DropdownFixPageState();
}

class _DropdownFixPageState extends State<DropdownFixPage> {
  final List<String> opcoes = [
    'Agricultura',
    'Tecnologia',
    'Educação',
    'Saúde',
    'Engenharia',
    'Comércio',
  ];



  List<String> selecionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dropdown Search v6.0.2")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: DropdownSearch<String>.multiSelection(
          // ESTE É O CONSTRUTOR CORRETO
          items: ,
          // items: opcoes.toList(),
          selectedItems: selecionados,

          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: "Selecione áreas",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          popupProps: PopupPropsMultiSelection.menu(
            showSearchBox: true,

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Pesquisar...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            menuProps: const MenuProps(
              backgroundColor: Colors.white,
            ),

            itemBuilder: (context, item, isDisabled, isSelected) {
              return ListTile(
                title: Text(item),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: null,
                  activeColor: Color(0xFF1976D2),
                ),
              );
            },
          ),

          onChanged: (value) {
            setState(() => selecionados = value);
          },
        ),
      ),
    );
  }
}