import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_principal/cadastro/CEP.dart';
import 'package:projeto_principal/cadastro/Escolha.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: { "#": RegExp(r'[0-9]') },
);
final cnpjMaskFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##',
  filter: { "#": RegExp(r'[0-9]') },
);

void main() => runApp(const Empresa());

class Empresa extends StatelessWidget {
  const Empresa({super.key});

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
      MaterialPageRoute(builder: (context) => Escolha()),
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
              child: const Perfil(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: const Nome(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
               
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: const Telefone(),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: cpf(),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Area(),
            ),
         
           Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: Center(child: botao()),
                ),
          ],
        ),
      ),
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
      ),
    );
  }
}

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
 class Area extends StatefulWidget {
  @override
  _AreaState createState() => _AreaState();
 }
 class _AreaState extends State<Area> {
  List<String> ramo = [];
  ValueNotifier<String> dropValue = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    carregarRamos();
 }
 void carregarRamos() async {
    try{
      String url = 'http://192.168.1.5:8000/api/ramo';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          ramo = List<String>.from(json.decode(response.body).map((item) => item['nome'].toString()));
        });
      } else {
        
      }
    }catch (e) {
      print('Erro ao carregar ramos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (BuildContext context, String value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownSearch<String>(
              items: ramo,
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
                constraints: BoxConstraints(
                  maxHeight: 250,
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Área de atuação",
                  hintText: "Escolha a área de atuação",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(121, 180, 217, 1),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
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
          ).push(MaterialPageRoute(builder: (context) => CEP())),
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

