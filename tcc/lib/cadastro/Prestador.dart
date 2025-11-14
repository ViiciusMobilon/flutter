import 'package:flutter/material.dart';
import 'dart:io'; // Para manipulação de arquivos (imagem)
import 'package:image_picker/image_picker.dart'; // Para escolher imagens da galeria ou câmera
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Para máscaras de input
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Dropdown com busca

// Máscaras para telefone e CPF
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);
final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

// Tela principal de cadastro do prestador
class Prestador extends StatelessWidget {
  const Prestador({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove faixa de DEBUG
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Branco
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Volta para a tela de escolha
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Escolha()),
              );
            },
          ),
          title: Text(
            "Cadastro",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              // Imagem de perfil
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.2,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.2,
                ),
                child: const Perfilimagem(),
              ),
              // Campo de nome
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Nome(),
              ),
              // Campo de telefone
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Telefone(),
              ),
              // Campo de CPF
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: cpf(),
              ),
              // Dropdown de área de atuação
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Area(),
              ),
              // Botão de próximo
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: Center(child: botao()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para escolher e mostrar a imagem de perfil
class Perfilimagem extends StatefulWidget {
  const Perfilimagem({super.key});

  @override
  State<Perfilimagem> createState() => _PerfilimagemState();
}

class _PerfilimagemState extends State<Perfilimagem> {
  File? _image; // Armazena a imagem escolhida
  final ImagePicker _picker = ImagePicker(); // Picker de imagens

  // Função para escolher imagem
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Mostra opções de Galeria ou Câmera
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
    return Center(
      child: GestureDetector(
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
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.white70,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// Campo de Nome
class Nome extends StatefulWidget {
  const Nome({super.key});

  @override
  State<Nome> createState() => _NomeState();
}

class _NomeState extends State<Nome> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Nome",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "Fulano de Tal",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

// Campo de Telefone com máscara
class Telefone extends StatefulWidget {
  const Telefone({super.key});

  @override
  State<Telefone> createState() => _TelefoneState();
}

class _TelefoneState extends State<Telefone> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [maskFormatter],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telefone",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "(14)999999999",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

// Campo de CPF com máscara
class cpf extends StatefulWidget {
  const cpf({super.key});

  @override
  State<cpf> createState() => _cpfState();
}

class _cpfState extends State<cpf> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [cpfMaskFormatter],
      decoration: InputDecoration(
        hintText: "000.000.000.00",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "CPF",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// Dropdown de Área de Atuação


class Area extends StatelessWidget {
  final dropValue = ValueNotifier('');

  final dropOpcoes = [
    'Pedreiro','Pintor','Eletricista','Encanador','Marceneiro','Jardineiro',
    'Gesseiro','Serralheiro','Vidraceiro','Alvenaria','Telhadista',
    'Azulejista','Instalador de drywall','Servente de obras','Outros',
  ];

  Area({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<String>(
              // ✔ VERSÃO CORRETA NA 6.0.1 → função com (filter, compare)
              items: (filter, _) => dropOpcoes,

              selectedItem: value.isEmpty ? null : value,

              onChanged: (String? newValue) {
                dropValue.value = newValue ?? '';
              },

              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    labelText: "Pesquisar área...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 250),
              ),

              // ✔ NOME ATUAL NA 6.0.1 → decoratorProps:
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Área de atuação",
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

              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? "Escolha a área de atuação",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontFamily: "Poppins",
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


// Botão "Próximo"
class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CEP())),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Text(
                "Proximo",
                style: TextStyle(
                  color: const Color.from(
                    alpha: 1,
                    red: 0.988,
                    green: 0.984,
                    blue: 0.984,
                  ),
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
