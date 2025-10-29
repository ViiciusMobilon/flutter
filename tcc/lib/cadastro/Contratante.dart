import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';

// Máscara para telefone (ex: (14) 99999-9999)
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

// Máscara para CPF (ex: 000.000.000-00)
final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

// Tela principal do cadastro do Contratante
class Contratante extends StatelessWidget {
  const Contratante({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        // AppBar branca com título e botão de voltar
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            // Volta para a tela de escolha
            onPressed: () {
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

        // Corpo da tela
        body: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListView(
            children: <Widget>[
              // Campo de perfil com foto
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.2,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.2,
                ),
                child: const Perfil(),
              ),

              // Campo de Nome
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Nome(),
              ),

              // Campo de Telefone
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

              // Botão "Próximo"
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.25,
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

// Widget para foto de perfil
class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Função para escolher a imagem da câmera ou galeria
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Mostra diálogo para escolher fonte da imagem
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

  // Construção do widget
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

// Campo de Telefone
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

// Campo de CPF
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
        hintText: "000.000.000-00",
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

// Botão "Próximo" para avançar à tela de CEP
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
                "Próximo",
                style: TextStyle(
                  color: Colors.white,
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
