// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:tcc/data/controllers/verificar_controller.dart';
import 'package:tcc/data/models/userForm.dart';

// Máscara para telefone
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

// Máscara para CPF
final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

void main() => runApp(Contratante(usuario: Userform()));

class Contratante extends StatefulWidget {
  final Userform usuario;
  Contratante({super.key, required this.usuario});

  @override
  State<Contratante> createState() => _ContratanteState();
}

class _ContratanteState extends State<Contratante> {
  File? foto;
  bool semImagem = false;
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();

  String? erroNome;
  String? erroCPF;
  String? erroTelefone;

  void limaparErro() {
    if (erroCPF != null) setState(() => erroCPF = null);
    if (erroTelefone != null) setState(() => erroTelefone = null);
    if (erroNome != null) setState(() => erroNome = null);
  }

  @override
  Widget build(BuildContext context) {
    print("Email: ${widget.usuario.email}");
    print("senha: ${widget.usuario.password}");
    print("senha-confirmation: ${widget.usuario.confirmation_password}");
    print("Tipo: ${widget.usuario.tipo}");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Escolha(usuario: widget.usuario),
                ),
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

        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.2,
                right: MediaQuery.of(context).size.width * 0.2,
                bottom: MediaQuery.of(context).size.width * 0.01,
              ),
              child: Perfil(
                semImagem: semImagem,
                image: foto,
                OnImageSelected: (file) {
                  setState(() => foto = file);
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Nome(
                controller: nomeController,
                erroNome: erroNome,
                onClearerror: limaparErro,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Telefone(
                controller: telefoneController,
                erroTelefone: erroTelefone,
                onClearerror: limaparErro,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cpf(
                controller: cpfController,
                erroCPF: erroCPF,
                onClearerror: limaparErro,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.25,
              ),
              child: Center(
                child: botao(
                  usuario: widget.usuario,
                  foto: foto,
                  semImagem: semImagem,
                  nomeController: nomeController,
                  telefoneController: telefoneController,
                  cpfController: cpfController,
                  erroCPF: (msg) => setState(() => erroCPF = msg),
                  erroTelefone: (msg) => setState(() => erroTelefone = msg),
                  erroNome: (msg) => setState(() => erroNome = msg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------
// FOTO DE PERFIL
// ---------------------------
class Perfil extends StatefulWidget {
  final bool semImagem;
  final File? image;
  final void Function(File?) OnImageSelected;
  Perfil({
    super.key,
    required this.image,
    required this.OnImageSelected,
    this.semImagem = false,
  });

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      widget.OnImageSelected(File(pickedFile.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione uma imagem"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
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
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.semImagem ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: widget.image != null
                ? Image.file(
                    widget.image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
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

// ---------------------------
// CAMPO NOME
// ---------------------------
class Nome extends StatefulWidget {
  final TextEditingController controller;
  String? erroNome;
  final VoidCallback onClearerror;

  Nome({
    super.key,
    required this.controller,
    this.erroNome,
    required this.onClearerror,
  });

  @override
  State<Nome> createState() => _NomeState();
}

class _NomeState extends State<Nome> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorText: widget.erroNome,
      ),
      onChanged: (_) => widget.onClearerror(),
    );
  }
}

// ---------------------------
// CAMPO TELEFONE
// ---------------------------
class Telefone extends StatefulWidget {
  final TextEditingController controller;
  final String? erroTelefone;
  final VoidCallback onClearerror;

  Telefone({
    super.key,
    required this.controller,
    required this.erroTelefone,
    required this.onClearerror,
  });

  @override
  State<Telefone> createState() => _TelefoneState();
}

class _TelefoneState extends State<Telefone> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [maskFormatter],
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telefone",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "(14)99999-9999",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorText: widget.erroTelefone,
      ),
      onChanged: (_) => widget.onClearerror(),
    );
  }
}

// ---------------------------
// CAMPO CPF
// ---------------------------
class cpf extends StatefulWidget {
  final TextEditingController controller;
  final String? erroCPF;
  final VoidCallback onClearerror;

  cpf({
    super.key,
    required this.controller,
    required this.erroCPF,
    required this.onClearerror,
  });

  @override
  State<cpf> createState() => _cpfState();
}

class _cpfState extends State<cpf> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [cpfMaskFormatter],
      controller: widget.controller,
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
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorText: widget.erroCPF,
      ),
      onChanged: (_) => widget.onClearerror(),
    );
  }
}

// ---------------------------
// BOTÃO "PRÓXIMO"
// ---------------------------
class botao extends StatefulWidget {
  final Userform usuario;
  final File? foto;
  bool semImagem;

  final TextEditingController nomeController;
  final TextEditingController telefoneController;
  final TextEditingController cpfController;

  final void Function(String?) erroNome;
  final void Function(String?) erroTelefone;
  final void Function(String?) erroCPF;

  botao({
    super.key,
    required this.usuario,
    required this.foto,
    required this.nomeController,
    required this.telefoneController,
    required this.cpfController,
    required this.erroNome,
    required this.erroCPF,
    required this.erroTelefone,
    required this.semImagem,
  });

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.usuario.nome = widget.nomeController.text;
        widget.usuario.telefone = widget.telefoneController.text;
        widget.usuario.cpf = widget.cpfController.text;
        widget.usuario.foto = widget.foto;

        // Verificações
        if (widget.foto == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selecione uma imagem"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          setState(() => widget.semImagem = true);
          return;
        }

        if (widget.nomeController.text.isEmpty) {
          widget.erroNome('Digite um nome');
          return;
        }

        if (widget.telefoneController.text.isEmpty) {
          widget.erroTelefone('Digite um telefone');
          return;
        }

        if (widget.cpfController.text.isEmpty) {
          widget.erroCPF('Digite um cpf');
          return;
        }

        final verificarController = VerificarController();
        final vTel = await verificarController.verificar(
          widget.telefoneController.text,
          'numero',
        );
        final vCPF = await verificarController.verificar(
          widget.cpfController.text,
          'cpf',
        );

        if ((vTel['msg'] as String).isNotEmpty) {
          widget.erroTelefone(vTel['msg']);
          return;
        }

        if (vTel['existe'] == true) {
          widget.erroTelefone(vTel['msg']);
          return;
        }

        if ((vCPF['msg'] as String).isNotEmpty) {
          widget.erroCPF(vCPF['msg']);
          return;
        }

        if (vCPF['existe'] == true) {
          widget.erroCPF(vCPF['msg']);
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CEP(usuario: widget.usuario),
          ),
        );
      },

      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
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
            const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
