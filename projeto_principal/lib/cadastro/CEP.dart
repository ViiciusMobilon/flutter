import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_principal/cadastro/CEP.dart';
import 'package:projeto_principal/cadastro/Escolha.dart';
import 'package:projeto_principal/data/models/cep.dart';
import 'package:projeto_principal/data/models/user.dart';
import 'package:projeto_principal/data/repositories/cep_repository.dart';
import 'package:projeto_principal/paginas%20principais/pagina_principal.dart';
import 'package:projeto_principal/cadastro/dropdow.dart';
import 'package:projeto_principal/cadastro/Contratante.dart';
import 'package:projeto_principal/data/http/http_client.dart' as apiHttp;



final cepMaskFormatter = MaskTextInputFormatter(
  mask: '#####-###',
  filter: { "#": RegExp(r'[0-9]') },
);

// void main() => runApp(const CEP());

class CEP extends StatefulWidget {
  final UsuarioGeral usuario;
  const CEP({super.key, required this.usuario});

  @override
  State<CEP> createState() => _CEPState();
}

class _CEPState extends State<CEP> {
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final infoaddController = TextEditingController();

  void preencherCampos(CepModel endereco){
    setState(() {
        cepController.text = endereco.cep;
        cidadeController.text = endereco.localidade;
        estadoController.text = endereco.uf;
        ruaController.text = endereco.logradouro;
      });
  }

  @override
  Widget build(BuildContext context) {
    print( "Email: ${widget.usuario.email}");
    print( "senha: ${widget.usuario.password}");
    print( "senhaconfirmation: ${widget.usuario.confirmation_password}");
    print( "Tipo: ${widget.usuario.tipo}");
    print( "nome: ${widget.usuario.nome}");
    print( "tel: ${widget.usuario.telefone}");
    print( "cpf: ${widget.usuario.cpf}");
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
      MaterialPageRoute(builder: (context) => Escolha(usuario: UsuarioGeral(),)),
    );
  },
),
          title:  Text(
            "Endereço",
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
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cepWidget(controller: cepController, onCepBuscado: preencherCampos),
            ),
                 
                  Padding(
                  padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                  ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 4, child: cidade(controller: cidadeController, onCepBuscado: preencherCampos)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                   // 3 partes da largura
                  Expanded(flex: 3, child:estado(controller: estadoController, onCepBuscado: preencherCampos) ), // 4 partes da largura
                  
                ],
                
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
               
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: RuaWidget(controller: ruaController,),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: numero(),
            ),Padding(
                  padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Center(child: adicionais()),
                ),
           Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.22,
                  ),
                  child: Center(child: botao()),
                ),
          
                 
          ],
        ),
      ),
    );
  }
}
  

Widget cepField({
 required TextEditingController controller,
  required void Function(CepModel) onCepBuscado,
}) {
  return cepWidget(controller: controller, onCepBuscado: onCepBuscado);
}

class cepWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(CepModel) onCepBuscado;
  const cepWidget({super.key, required this.controller, required this.onCepBuscado});

  @override
  State<cepWidget> createState() => _cepState();
}

class _cepState extends State<cepWidget> {
  late final CepRepository cepRepository;
  @override
  void initState() {
    
    super.initState();
    cepRepository = CepRepository(client: apiHttp.HttpClient());
  }
  Future<void> buscarCep(String cep) async{
    if(cep.isEmpty) return;
    try {
      final endereco = await cepRepository.getCep(cep);
      widget.onCepBuscado(endereco);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar CEP: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: buscarCep,
      maxLength:10 ,
       keyboardType: TextInputType.number,
          inputFormatters: [cepMaskFormatter],
      
      decoration: InputDecoration(
      
        labelText: "CEP",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        
        hintText: "99999-999",
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

Widget ruaField(
  {required TextEditingController controller}

){
  return RuaWidget(controller: controller);
}

class RuaWidget extends StatefulWidget {
  final TextEditingController controller;
  const RuaWidget({super.key, required this.controller});

  @override
  State<RuaWidget> createState() => _RuaState();
}

class _RuaState extends State<RuaWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "Rua / Avenida",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05, fontFamily: "Poppins",
        ),
        hintText: "Avenida sei la",
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
      ),
    );
  }
}

class numero extends StatefulWidget {
  const numero({super.key});

  @override
  State<numero> createState() => _numeroState();
}

class _numeroState extends State<numero> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "1234",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "numero",
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


class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => TelaPrincipal())),
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
                "Entrar",
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

class adicionais extends StatefulWidget {
  const adicionais({super.key});

  @override
  State<adicionais> createState() => _adicionaisState();
}

class _adicionaisState extends State<adicionais> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 128,
      decoration: InputDecoration(
        hintText: "não sei o que não sei oque la",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "informações adicionais(opcional)",
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
