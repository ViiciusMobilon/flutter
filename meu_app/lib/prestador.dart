import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:meu_app/escolha_registro.dart';

void main() => runApp( Prestador());

class Prestador extends StatelessWidget {
  
  Prestador({super.key});
final Color cor =  Color.fromRGBO(15, 40, 89, 1.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(  
      appBar: AppBar(backgroundColor:cor ,
      title: Text("Prestador", style: TextStyle(color: Colors.white),),
      centerTitle: true,)
      ,
        
         body: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Escolha_registro(),)),
                child: Icon(Icons.arrow_back_ios_rounded)),
            ),
        
        ListView(
          children: <Widget>[
          //perfil
              Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0.01,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: Perfil(),),
            //fim perfil

            //nome
            Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.01,
     right:MediaQuery.of(context).size.width*0.1  ),
     child: nome(),),
             // fim nome
             Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.01, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.1,
     right:MediaQuery.of(context).size.width*0.1  ),
     child: _telefone(),),

           Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.01, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.01,
     right:MediaQuery.of(context).size.width*0.1  ),
     child:Column(
      children: [
        Pais()
      ], ), ),
        Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.01, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.01,
     right:MediaQuery.of(context).size.width*0.1  ),
     child:Column(
      children: [
        Estado()
      ], ), ),

         Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.01, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.01,
     right:MediaQuery.of(context).size.width*0.1  ),
     child:Column(
      children: [
       Cidade()
      ], ), ),
      Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.08, 
     left: MediaQuery.of(context).size.width*0.1, 
     bottom:MediaQuery.of(context).size.width*0.1,
     right:MediaQuery.of(context).size.width*0.1  ),
     child: button(),)
         ]
         
         ),],),)); 
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
                  width:MediaQuery.of(context).size.width*0.3,
                  height: MediaQuery.of(context).size.width*0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey
                  ),
                ),
        ),
      ),
    );
  }
}
class nome extends StatefulWidget {
  const nome({super.key});

  @override
  State<nome> createState() => _nomeState();
}

class _nomeState extends State<nome> {
  @override
  Widget build(BuildContext context) {
    return TextField(
     decoration: InputDecoration(
        labelText:"Nome" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,)  ,
            hintText: "fulano de tau",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: MediaQuery.of(context).size.width * 0.006,)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: MediaQuery.of(context).size.width * 0.006,)
        )
      ),
    );
  }
}

class _telefone extends StatefulWidget {
  const _telefone({super.key});

  @override
  State<_telefone> createState() => __telefoneState();
}

class __telefoneState extends State<_telefone> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 11,
      decoration: InputDecoration(
        labelText:"Telefone" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,)  ,
            hintText: "(14)999999999",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: MediaQuery.of(context).size.width * 0.006,)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1),width: MediaQuery.of(context).size.width * 0.006,)
        )
      ),

    );
}}

class Pais extends StatefulWidget {
  const Pais({super.key});

  @override
  _PaisState createState() => _PaisState();
}

class _PaisState extends State<Pais> {
  final List<String> _paises = ['Brasil', 'Argentina', 'Chile', 'Uruguai', 'Paraguai'];
  String? _selecionado = 'Brasil';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha um país:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selecionado,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
              onChanged: (String? novoValor) {
                setState(() {
                  _selecionado = novoValor;
                });
              },
              items: _paises.map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
            ),
          ),
        ),
       
      ],
    );
  }
}
class Estado extends StatefulWidget {
  const Estado({super.key});

  @override
  _EstadoState createState() => _EstadoState();
}

class _EstadoState extends State<Estado> {
  final List<String> _estados = ['Brasil', 'Argentina', 'Chile', 'Uruguai', 'Paraguai'];
  String? _selecionado = 'Brasil';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha um Estado:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selecionado,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
              onChanged: (String? novoValor) {
                setState(() {
                  _selecionado = novoValor;
                });
              },
              items: _estados.map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
            ),
          ),
        ),
       
      ],
    );
  }
}

class Cidade extends StatefulWidget {
  const Cidade({super.key});

  @override
  _CidadeState createState() => _CidadeState();
}

class _CidadeState extends State<Cidade> {
  final List<String> _cidades = ['Brasil', 'Argentina', 'Chile', 'Uruguai', 'Paraguai'];
  String? _selecionado = 'Brasil';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha uma Cidade:',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selecionado,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
              onChanged: (String? novoValor) {
                setState(() {
                  _selecionado = novoValor;
                });
              },
              items: _cidades.map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
            ),
          ),
        ),
       
      ],
    );
  }
}
class button extends StatelessWidget {
  const button({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    //  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Telaprincipal(),)),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 40, 89, 1.0),
          borderRadius:  BorderRadius.circular(40.0),
        ),
        
        alignment: Alignment.center,
        height:  MediaQuery.of(context).size.height * 0.08,
        width:  MediaQuery.of(context).size.width * 0.08,
        child: Text("Continuar", style: TextStyle(color:  Color.fromRGBO(242, 242, 242, 1), fontSize: MediaQuery.of(context).size.width *0.07),),
      ),
    );
  }
}

