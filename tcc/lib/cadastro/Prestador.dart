import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/CEP.dart';
import 'package:tcc/cadastro/Escolha.dart';
// ignore: unused_import
import 'package:dropdown_search/dropdown_search.dart';
import 'package:tcc/data/controllers/verificar_controller.dart';
import 'package:tcc/cadastro/dropdown.dart';
import 'package:tcc/data/models/userForm.dart';

final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: { "#": RegExp(r'[0-9]') },
);
final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: { "#": RegExp(r'[0-9]') },
);


// void main() => runApp(Prestador(usuario: UsuarioGeral(),));

class Prestador extends StatefulWidget {
  final Userform usuario;
  Prestador({super.key, required this.usuario});

  @override
  State<Prestador> createState() => _PrestadorState();
}

class _PrestadorState extends State<Prestador> {
  File? foto;
  int? id_ramo;
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();
  String? erroCPF;
  String? erroTelefone;
  String? erroRamo;
  void limparCPF(){
    if(erroCPF != null){
      setState(() => erroCPF = null);
    }
  }
  void limparTel(){
    if(erroTelefone != null){
      setState(() => erroTelefone = null);
    }
  }
  void limparRamo(){
    if(erroRamo != null){
      setState(() => erroRamo = null);
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
              child: Perfilimagem(image: foto,
              OnImageSelected: (file){
                setState(() {
                  foto = file;
                });
              },),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Nome(controller: nomeController,),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
               
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Telefone(controller: telefoneController, erroTel: erroTelefone, onClearerror: limparTel),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cpf(controller: cpfController, erroCPF: erroCPF, onClearerror: limparCPF),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Area(usuario: widget.usuario,
              erro: erroRamo,
              onClearerror: limparRamo,
              onRamoSelecionado: (item){
                if(item != null){
                  setState(() {
                    id_ramo = item.id;
                  });
                }
              },
              ),
            ),
         
           Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: Center(child: botao(usuario: widget.usuario,
                  erroRamo: (msg) => setState(() => erroRamo = msg),
                  idramo: id_ramo,
                  cpfController: cpfController,
                  nomeController: nomeController,
                  telefoneController: telefoneController,
                  foto: foto,
                  erroCPF: (msg) => setState(() => erroCPF = msg),
                  erroTelefone: (msg) => setState(() => erroTelefone = msg)
                  )),
                ),
          ],
        ),
      ),
    );
  }
}

class Perfilimagem extends StatefulWidget {
  final File? image;
  final void Function(File?) OnImageSelected;
  Perfilimagem({super.key, required this.image, required this.OnImageSelected});

  @override
  State<Perfilimagem> createState() => _PerfilimagemState();
}

class _PerfilimagemState extends State<Perfilimagem> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      widget.OnImageSelected(file);
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
    );
  }
}

class Nome extends StatefulWidget {
  final TextEditingController controller; 
  Nome({super.key, required this.controller});

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
      ),
    );
  }
}

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
        errorText: widget.erroTel,
      ),
      onChanged:  (value){
        widget.onClearerror();
      },
    );
    
  }
}

class cpf extends StatefulWidget {
  final TextEditingController controller;
  final String? erroCPF;
  final VoidCallback onClearerror;
  cpf({super.key, required this.controller, required this.erroCPF, required this.onClearerror});

  @override
  State<cpf> createState() => _cpfState();
}

class _cpfState extends State<cpf> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
        errorText: widget.erroCPF
      ),
      onChanged:  (value){
        widget.onClearerror();
      },
    );
  }
}

class botao extends StatefulWidget {
  final Userform usuario;
  final int? idramo;
  final File? foto;
  final TextEditingController nomeController;
  final TextEditingController telefoneController;
  final TextEditingController cpfController;
  final void Function (String?) erroTelefone;
  final void Function (String?) erroCPF;
  final void Function (String?) erroRamo;
  botao({super.key, required this.usuario,
    required this.idramo,
    required this.foto,
    required this.nomeController,
    required this.telefoneController,
    required this.cpfController,
    required this.erroCPF,
    required this.erroRamo,
    required this.erroTelefone});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap:
          () async{
            widget.usuario.ramo = widget.idramo;
            widget.usuario.foto = widget.foto;
            widget.usuario.nome = widget.nomeController.text;
            widget.usuario.telefone = widget.telefoneController.text;
            widget.usuario.cpf = widget.cpfController.text;

            if(widget.telefoneController.text.isEmpty){
                widget.erroTelefone('Digite um telefone');
                print('digite um telefone');
                return;
              }
            if(widget.cpfController.text.isEmpty){
                widget.erroCPF('Digite um cpf');
                widget.erroCPF('Digite um cpf');
                print('digite um cpf');
                return;
              }
            
            if(widget.idramo == null){
              widget.erroRamo("Selecione um ramo");
              return;
            }
            
            
            final verificarController = VerificarController();
              final vTel = await verificarController.verificar(widget.telefoneController.text, 'check-numero');
              final vCPF = await verificarController.verificar(widget.cpfController.text, 'check-cpf');

            if((vTel['msg'] as String).isNotEmpty){
                widget.erroTelefone(vTel['msg']);
                print('digite um telefone valido');
                return;
              }
            
            
            if(vTel['existe'] == true){
                widget.erroTelefone(vTel['msg']);
                return;
              }
            if((vCPF['msg'] as String).isNotEmpty){
                widget.erroCPF(vCPF['msg']);
                print('digite um cpf valido');
                return;
              }
            
            
            if(vCPF['existe'] == true){
                widget.erroCPF(vCPF['msg']);
                return;
              }else{
                Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => CEP(usuario: widget.usuario,)));
              }
            
            print("email:${widget.usuario.email}");
            print("senha:${widget.usuario.password}");
            print("senhacon:${widget.usuario.confirmation_password}");
            print("tipo:${widget.usuario.tipo}");
            print("foto:${widget.usuario.foto}");
            print("nome:${widget.usuario.nome}");
            print("tel:${widget.usuario.telefone}");
            print("cpf:${widget.usuario.cpf}");
            print("ramo:${widget.usuario.ramo}");
      ;},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: <BoxShadow>[
            //para todas as caracteristicas do boxshadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4), //posição
              blurRadius: 8, //fumaça
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

