import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp( Empresa());

class Empresa extends StatelessWidget {
  
  Empresa({super.key});
final Color cor =  Color.fromRGBO(15, 40, 89, 1.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(  
      appBar: AppBar(backgroundColor:cor ,),
        body:ListView(
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
     child: nome(),),
          ],
        ),
      )
    
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
      decoration: InputDecoration(
        labelText:"Telefone" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.03,)  ,
            hintText: "(14)999999999",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5)
        )
      ),

    );
}}