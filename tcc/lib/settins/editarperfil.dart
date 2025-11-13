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

class Editar_Perfil extends StatefulWidget {
  const Editar_Perfil({super.key});

  @override
  State<Editar_Perfil> createState() => _Editar_PerfilState();
}

class _Editar_PerfilState extends State<Editar_Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children:  [
            Center(child: Perfil()),
        
            
            SizedBox(height: 20),
            Descricao(),
            SizedBox(height: 20),
            Area(),
            SizedBox(height: 30),
            nome(),

            SizedBox(height: 50),
            Center(child: Text("Contatos", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.08, fontWeight:FontWeight.bold),)), 
            
           
             SizedBox(height: 30),
            Whatsapp(),

             SizedBox(height: 30),
            Insta(), 

            SizedBox(height: 30),
            site(),

            SizedBox(height: 50),
            Center(child: Text("Especialidades", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.08, fontWeight:FontWeight.bold),)), 
            SizedBox(height: 30),
            AreaMultiSelect(),

            SizedBox(height: 50),
            Center(child: botao()),

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

class nome extends StatelessWidget {
  const nome({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "nome",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
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
        labelText: "Whatsapp",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
class site extends StatelessWidget {
  const site({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "site",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
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
        labelText: "Insta",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class botao extends StatelessWidget {
  const botao({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
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
  final dropValue = ValueNotifier('');
  final dropOpcoes = ["3", "2", "1"];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dropValue,
      builder: (BuildContext context, String value, _) {
        return DropdownSearch<String>(
          items: dropOpcoes,
          selectedItem: value.isEmpty ? null : value,
          onChanged: (String? newValue) {
            dropValue.value = newValue ?? '';
          },
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Pesquisar área...",
                 labelStyle: const TextStyle(
              color: Colors.black, fontFamily: "Poppins"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Área de atuação",
              labelStyle: const TextStyle(
              color: Colors.black, fontFamily: "Poppins"),
              hintText: "Escolha a área de atuação",
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

class AreaMultiSelect extends StatefulWidget {
  const AreaMultiSelect({super.key});

  @override
  State<AreaMultiSelect> createState() => _AreaMultiSelectState();
}

class _AreaMultiSelectState extends State<AreaMultiSelect> {
  // Lista de opções disponíveis
  final dropOpcoes = [
    "Agricultura",
    "Tecnologia",
    "Educação",
    "Saúde",
    "Engenharia",
    "Comércio",
  ];

  // Lista das opções selecionadas
  final ValueNotifier<List<String>> selecionadas = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<List<String>>(
        
        valueListenable: selecionadas,
        builder: (context, value, _) {
          return SizedBox(
          
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<String>.multiSelection(
              items: dropOpcoes,
              selectedItems: value,
              onChanged: (List<String> selecionadasNovas) {
                selecionadas.value = selecionadasNovas;
              },
              popupProps: PopupPropsMultiSelection.menu(
                 menuProps: MenuProps(
                  backgroundColor: Color(0xFFE3F2FD), // 🌈 muda aqui (fundo do menu)
                ),
                showSearchBox: true,
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    labelText: "Pesquisar área...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Áreas de atuação",
                  hintText: "Escolha uma ou mais áreas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(121, 180, 217, 1),
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
              dropdownBuilder: (context, selecionadasAtuais) {
                if (selecionadasAtuais.isEmpty) {
                  return Text(
                    "Escolha uma ou mais áreas",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontFamily: "Poppins",
                      color: Colors.grey[700],
                    ),
                  );
                }
                return Wrap(
                  spacing: 6,
                  runSpacing: -8,
                  children: selecionadasAtuais.map((area) {
                    return Chip(
                      label: Text(area),
                      backgroundColor: const Color.fromRGBO(121, 180, 217, 0.2),
                      labelStyle: const TextStyle(color: Color.fromRGBO(50, 100, 140, 1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}