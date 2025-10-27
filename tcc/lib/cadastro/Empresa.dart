
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:tcc/cadastro/dropdownCategoria.dart';
import 'package:tcc/data/controllers/verificar_controller.dart';
import 'package:tcc/cadastro/dropdownRamo.dart';
import 'package:tcc/data/models/userForm.dart';

// Máscaras de formatação
final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: { "#": RegExp(r'[0-9]') },
);
final cnpjMaskFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##',
  filter: { "#": RegExp(r'[0-9]') },
);

void main() => runApp(Empresa(usuario: Userform(),));

class Empresa extends StatefulWidget {
  final Userform usuario;
  Empresa({super.key, required  this.usuario});

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
  void limparErro(){
    if(erroCNPJ != null){
      setState(() => erroCNPJ = null);
    }
    
    if(erroTelefone != null){
      setState(() => erroTelefone = null);
    }
    
    if(erroCategoria != null){
      setState(() => erroCategoria = null);
    }
    
    if(erroNome != null){
      setState(() => erroNome = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7FD),
           leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.black),
  onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Escolha(usuario: widget.usuario,)),
    );
  },
),
          title:  Text(
            "Cadastro",
            style: TextStyle(color: Colors.black,
            fontSize: MediaQuery.of(context).size.width*0.07,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",),
             
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.2,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.2,
              ),
              child: Perfil(image: foto,
              OnImageSelected: (file){
                setState(() {
                  foto = file;
                });
              },
              semImagem: semImagem,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Nome(controller: rsController, erroNome: erroNome, onClearerror: limparErro,),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
               
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Telefone(controller: telefoneController, erroTel: erroTelefone, onClearerror: limparErro,),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cnpj(controller: cnpjController, erroCNPJ: erroCNPJ, onClearerror: limparErro,),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Categoria(usuario: widget.usuario,
              erro: erroCategoria,
              onClearerror: limparErro,
              onCategoriaSelecionado: (item){
                if(item != null){
                setState(() {
                  id_categoria = item.id;
                });
                }
              },),
            ),
         
           Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: Center(
                    child: botao(
                      usuario: widget.usuario,
                      erroNome: (msg) => setState(() => erroNome = msg),
                      erroCNPJ: (msg) => setState(() => erroCNPJ = msg),
                      erroCategoria: (msg) => setState(() => erroCategoria = msg),
                      erroTelefone: (msg) => setState(() => erroTelefone = msg),
                      idcategoria: id_categoria,
                      cnpjController: cnpjController,
                      rsController: rsController,
                      telefoneController: telefoneController,
                      foto: foto,
                      semImagem: semImagem,)
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// Componente de foto do perfil
class Perfil extends StatefulWidget {
  final File? image;
  bool semImagem;
  final void Function(File?) OnImageSelected;
  Perfil({super.key, required this.image,this.semImagem = false, required this.OnImageSelected});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        final file = File(pickedFile.path);
        widget.OnImageSelected(file);
      });
    } else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Selecione uma imagem"),
          backgroundColor:Colors.red,
          duration: Duration(seconds: 2),
        )
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
              width: 1
            )
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
      ),
    );
  }
}

// Campo de texto: Nome
class Nome extends StatefulWidget {
  final TextEditingController controller;
  final String? erroNome;
  final VoidCallback onClearerror;
  Nome({super.key, required this.controller, required this.erroNome, required this.onClearerror});

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
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        hintText: "Fulano de Tal",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        focusedBorder:OutlineInputBorder(
           borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        errorText: widget.erroNome
      ),
      onChanged: (value) {
        widget.onClearerror();
      },
    );
  }
}

// Campo de texto: Telefone
class Telefone extends StatefulWidget {
  final TextEditingController controller;
  final String? erroTel;
  final VoidCallback onClearerror;
  Telefone({super.key, required this.controller, required this.erroTel, required this.onClearerror});

  @override
  State<Telefone> createState() => _TelefoneState();
}

class _TelefoneState extends State<Telefone> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      inputFormatters: [maskFormatter],
      
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Telefone",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        hintText: "(14)999999999",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
           
          ),
        ),
        errorText: widget.erroTel
      ),
      onChanged: (value){
        widget.onClearerror();
      },
    );
  }
}

class cnpj extends StatefulWidget {
  final TextEditingController controller;
  final String? erroCNPJ;
  final VoidCallback onClearerror;
  const cnpj({super.key, required this.controller, required this.erroCNPJ, required this.onClearerror});

  @override
  State<cnpj> createState() => _cnpjState();
}

class _cnpjState extends State<cnpj> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
        errorText: widget.erroCNPJ,
      ),
      onChanged: (value){
        widget.onClearerror();
      },
    );
  }
}


class botao extends StatefulWidget {
  final Userform usuario;
  final int? idcategoria;
  final File? foto;
  bool semImagem;
  final TextEditingController rsController;
  final TextEditingController telefoneController;
  final TextEditingController cnpjController;
   final void Function (String?) erroTelefone;
  final void Function (String?) erroCNPJ;
  final void Function (String?) erroCategoria;
  final void Function (String?) erroNome;
  botao({super.key, required this.usuario,
    required this.idcategoria,
    required this.foto,
    required this.semImagem,
    required this.rsController,
    required this.telefoneController,
    required this.cnpjController,
    required this.erroCNPJ,
    required this.erroCategoria,
    required this.erroTelefone,
    required this.erroNome});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap:
          ()async{
            widget.usuario.foto = widget.foto;
            widget.usuario.razao_social = widget.rsController.text;
            widget.usuario.telefone = widget.telefoneController.text;
            widget.usuario.cnpj = widget.cnpjController.text;
            widget.usuario.categoria = widget.idcategoria;

            if(widget.foto == null ){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Selecione uma imagem"),
                    backgroundColor:Colors.red,
                    duration: Duration(seconds: 2),
                  )
                );
                setState(() => widget.semImagem = true);
                return;
              }

            if(widget.rsController.text.isEmpty){
                widget.erroNome('Digite um nome');
                print('digite um cnpj');
                return;
              }

            if(widget.telefoneController.text.isEmpty){
                widget.erroTelefone('Digite um telefone');
                print('digite um telefone');
                return;
              }

            if(widget.cnpjController.text.isEmpty){
                widget.erroCNPJ('Digite um cnpj');
                print('digite um cnpj');
                return;
              }
            
            
            if(widget.idcategoria == null){
              widget.erroCategoria("Selecione uma categoria");
              return;
            }

            final verificarController = VerificarController();
              final vTel = await verificarController.verificar(widget.telefoneController.text, 'check-numero');
              final vCNPJ = await verificarController.verificar(widget.cnpjController.text, 'check-cnpj');
              final vNome = await verificarController.verificar(widget.rsController.text, 'check-razaosocial');

            if((vTel['msg'] as String).isNotEmpty){
                widget.erroTelefone(vTel['msg']);
                print('digite um telefone valido');
                return;
              }
            
            
            if(vTel['existe'] == true){
                widget.erroTelefone(vTel['msg']);
                return;
              }

            if((vCNPJ['msg'] as String).isNotEmpty){
                widget.erroCNPJ(vCNPJ['msg']);
                print('digite um cnpj valido');
                return;
              }
            
            if(vCNPJ['existe'] == true){
                widget.erroCNPJ(vCNPJ['msg']);
                return;
              }

            if((vNome['msg'] as String).isNotEmpty){
                widget.erroNome(vNome['msg']);
                print('digite um nome valido');
                return;
              }


            if(vNome['existe'] == true){
                widget.erroNome(vNome['msg']);

                print(' ja usado');

                print('NOME EXISTE: ${vNome['existe']}');
                return;
              }


              else{
                Navigator.of(
            context,
           ).push(MaterialPageRoute(builder: (context) => CEP(usuario: widget.usuario,)));
              }

          },
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

