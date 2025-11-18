// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:tcc/cadastro/dropdownCategoria.dart';
import 'package:tcc/data/controllers/verificar_controller.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:tcc/cadastro/Prestador.dart';
// import 'package:tcc/cadastro/dropdow.dart';

// Máscaras
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

final cnpjMaskFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##',
  filter: {"#": RegExp(r'[0-9]')},
);

void main() => runApp(Empresa(usuario: Userform()));

class Empresa extends StatefulWidget {
  final Userform usuario;
  Empresa({super.key, required this.usuario});

  @override
  State<Empresa> createState() => _EmpresaState();
}

class _EmpresaState extends State<Empresa> {
  File? foto;
  bool semImagem = false;
  int? id_categoria;

  final rsController = TextEditingController();
  final telefoneController = TextEditingController();
  final cnpjController = TextEditingController();

  String? erroCategoria;
  String? erroCNPJ;
  String? erroTelefone;
  String? erroNome;

  void limparErro() {
    if (erroCNPJ != null) setState(() => erroCNPJ = null);
    if (erroTelefone != null) setState(() => erroTelefone = null);
    if (erroCategoria != null) setState(() => erroCategoria = null);
    if (erroNome != null) setState(() => erroNome = null);
  }

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
                MaterialPageRoute(
                  builder: (context) =>
                      Escolha(usuario: widget.usuario), // MANTIDO DO HEAD ✔
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
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Perfil(
                image: foto,
                semImagem: semImagem,
                OnImageSelected: (file) {
                  setState(() => foto = file);
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Nome(
                controller: rsController,
                erroNome: erroNome,
                onClearerror: limparErro,
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
                erroTel: erroTelefone,
                onClearerror: limparErro,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Cnpj(
                controller: cnpjController,
                erroCNPJ: erroCNPJ,
                onClearerror: limparErro,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Categoria(
                usuario: widget.usuario,
                erro: erroCategoria,
                onClearerror: limparErro,
                onCategoriaSelecionado: (item) {
                  if (item != null) {
                    setState(() => id_categoria = item.id);
                  }
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
              ),
              child: Center(
                child: Botao(
                  usuario: widget.usuario,
                  idcategoria: id_categoria,
                  foto: foto,
                  semImagem: semImagem,
                  rsController: rsController,
                  telefoneController: telefoneController,
                  cnpjController: cnpjController,
                  erroNome: (msg) => setState(() => erroNome = msg),
                  erroCNPJ: (msg) => setState(() => erroCNPJ = msg),
                  erroCategoria: (msg) => setState(() => erroCategoria = msg),
                  erroTelefone: (msg) => setState(() => erroTelefone = msg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Perfil extends StatefulWidget {
  final File? image;
  bool semImagem;
  final void Function(File?) OnImageSelected;

  Perfil({
    super.key,
    required this.image,
    this.semImagem = false,
    required this.OnImageSelected,
  });

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      widget.OnImageSelected(File(picked.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selecione uma imagem"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar uma Foto'),
                onTap: () {
                  Navigator.pop(context);
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
      onTap: _showDialog,
      child: Container(
        padding: EdgeInsets.all(4),
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
                  width: 150,
                  height: 150,
                  color: Colors.grey,
                  child: Icon(Icons.camera_alt, size: 50, color: Colors.white70),
                ),
        ),
      ),
    );
  }
}

class Nome extends StatelessWidget {
  final TextEditingController controller;
  final String? erroNome;
  final VoidCallback onClearerror;

  Nome({
    super.key,
    required this.controller,
    required this.erroNome,
    required this.onClearerror,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Nome",
        hintText: "Fulano de Tal",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        errorText: erroNome,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(121, 180, 217, 1), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onChanged: (_) => onClearerror(),
    );
  }
}

class Telefone extends StatelessWidget {
  final TextEditingController controller;
  final String? erroTel;
  final VoidCallback onClearerror;

  Telefone({
    super.key,
    required this.controller,
    required this.erroTel,
    required this.onClearerror,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [maskFormatter],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telefone",
        hintText: "(14)999999999",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        errorText: erroTel,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(121, 180, 217, 1), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onChanged: (_) => onClearerror(),
    );
  }
}

class Cnpj extends StatelessWidget {
  final TextEditingController controller;
  final String? erroCNPJ;
  final VoidCallback onClearerror;

  const Cnpj({
    super.key,
    required this.controller,
    required this.erroCNPJ,
    required this.onClearerror,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [cnpjMaskFormatter],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "CNPJ",
        hintText: "00.000.000/0000-00",
        errorText: erroCNPJ,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Color.fromRGBO(121, 180, 217, 1), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onChanged: (_) => onClearerror(),
    );
  }
}

class Botao extends StatefulWidget {
  final Userform usuario;
  final int? idcategoria;
  final File? foto;
  bool semImagem;

  final TextEditingController rsController;
  final TextEditingController telefoneController;
  final TextEditingController cnpjController;

  final void Function(String?) erroTelefone;
  final void Function(String?) erroCNPJ;
  final void Function(String?) erroCategoria;
  final void Function(String?) erroNome;

  Botao({
    super.key,
    required this.usuario,
    required this.idcategoria,
    required this.foto,
    required this.semImagem,
    required this.rsController,
    required this.telefoneController,
    required this.cnpjController,
    required this.erroCNPJ,
    required this.erroCategoria,
    required this.erroTelefone,
    required this.erroNome,
  });

  @override
  State<Botao> createState() => _BotaoState();
}

class _BotaoState extends State<Botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.usuario.foto = widget.foto;
        widget.usuario.razao_social = widget.rsController.text;
        widget.usuario.telefone = widget.telefoneController.text;
        widget.usuario.cnpj = widget.cnpjController.text;
        widget.usuario.categoria = widget.idcategoria;

        if (widget.foto == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Selecione uma imagem"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          setState(() => widget.semImagem = true);
          return;
        }

        if (widget.rsController.text.isEmpty) {
          widget.erroNome('Digite um nome');
          return;
        }

        if (widget.telefoneController.text.isEmpty) {
          widget.erroTelefone('Digite um telefone');
          return;
        }

        if (widget.cnpjController.text.isEmpty) {
          widget.erroCNPJ('Digite um CNPJ');
          return;
        }

        if (widget.idcategoria == null) {
          widget.erroCategoria("Selecione uma categoria");
          return;
        }

        final verificarController = VerificarController();
        final vTel = await verificarController.verificar(
            widget.telefoneController.text, 'numero');
        final vCNPJ =
            await verificarController.verificar(widget.cnpjController.text, 'cnpj');
        final vNome =
            await verificarController.verificar(widget.rsController.text, 'razaosocial');

        if ((vTel['msg'] as String).isNotEmpty) {
          widget.erroTelefone(vTel['msg']);
          return;
        }

        if (vTel['existe'] == true) {
          widget.erroTelefone(vTel['msg']);
          return;
        }

        if ((vCNPJ['msg'] as String).isNotEmpty) {
          widget.erroCNPJ(vCNPJ['msg']);
          return;
        }

        if (vCNPJ['existe'] == true) {
          widget.erroCNPJ(vCNPJ['msg']);
          return;
        }

        if ((vNome['msg'] as String).isNotEmpty) {
          widget.erroNome(vNome['msg']);
          return;
        }

        if (vNome['existe'] == true) {
          widget.erroNome(vNome['msg']);
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
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
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
