import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:tcc/cadastro/Prestador.dart';
import 'package:tcc/cadastro/dropdow.dart';

// Máscaras de formatação
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####', // Telefone
  filter: {"#": RegExp(r'[0-9]')},
);
final cnpjMaskFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##', // CNPJ
  filter: {"#": RegExp(r'[0-9]')},
);

// Tela principal de cadastro da empresa
class Empresa extends StatelessWidget {
  const Empresa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Escolha()), // Volta para a tela de escolha
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
              // Foto do perfil
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.2,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.2,
                ),
                child: const Perfil(),
              ),

              // Nome da empresa
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Nome(),
              ),

              // Telefone
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Telefone(),
              ),

              // CNPJ
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: cnpj(),
              ),

              // Área de atuação (Dropdown)
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Area(),
              ),

              // Botão próximo
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

// Componente de foto do perfil
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

// Campo de texto: Nome
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

// Campo de texto: Telefone
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

// Campo de texto: CNPJ
class cnpj extends StatefulWidget {
  const cnpj({super.key});

  @override
  State<cnpj> createState() => _cnpjState();
}

class _cnpjState extends State<cnpj> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [cnpjMaskFormatter],
      decoration: InputDecoration(
        hintText: "00.000.000/0000-00",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "CNPJ",
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

// Botão próximo
class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CEP()), // Vai para a tela de CEP
      ),
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
