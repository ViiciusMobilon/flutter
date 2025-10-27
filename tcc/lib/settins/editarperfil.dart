import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/Categoria.dart';
import 'package:tcc/data/repositories/categoria_repository.dart';
import 'package:tcc/data/http/dio_client.dart' as apiHttp;


final maskFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp(r'[0-9]')},
);

final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

class Editar_Perfil extends StatefulWidget {
  final AuthController authController;
  
  Editar_Perfil({super.key, required this.authController});

  @override
  State<Editar_Perfil> createState() => _Editar_PerfilState();
}

class _Editar_PerfilState extends State<Editar_Perfil> {
  final telefoneController = TextEditingController();
  final descricaoController = TextEditingController();
  int? id_categoria;
  int? id_ramo;
  @override
  Widget build(BuildContext context) {
  final user = widget.authController.usuario;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Center(child: Perfil(authController: widget.authController)),
            // SizedBox(height: 30),
            // Nome(),
            
            SizedBox(height: 20),
            Descricao(authController: widget.authController, controller: descricaoController,),
            
            if(user!.tipo == 'empresa') ...
            [
              SizedBox(height: 20), 
              Categoria(authController: widget.authController, onCategoriaSelecionado: (item){
                if(item != null){
                setState(() {
                  id_categoria = item.id;
                });
                }
              },),
            ],
            if(user!.tipo == 'prestador') ...
            [
              SizedBox(height: 20), 
              Area(),
            ],
           
            SizedBox(height: 50),
            Center(child: Text("Contatos", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.08, fontWeight:FontWeight.bold),)), 
            
            SizedBox(height: 30),
            Telefone(authController: widget.authController, controller: telefoneController,),

             SizedBox(height: 30),
            Whatsapp(),

             SizedBox(height: 30),
            Insta(), 

            SizedBox(height: 30),
            site(),
            
            SizedBox(height: 50),
            Center(child: botao()),

          ],
        ),
      ),
    );
  }
}

class Descricao extends StatefulWidget {
  final AuthController authController;
  late TextEditingController controller;
  Descricao({super.key, required this.authController, required this.controller});

  @override
  State<Descricao> createState() => _DescricaoState();
}

class _DescricaoState extends State<Descricao> {
  @override
  void initState(){
    super.initState();
    widget.controller = TextEditingController(text: widget.authController.usuario?.descricao);
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 6,
      maxLength: 255,
      decoration: InputDecoration(
        hintText: "Escreva uma breve descrição...",
        labelText: "Informações de descrição",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class Perfil extends StatefulWidget {
  final AuthController authController;
   Perfil({super.key, required this.authController});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String? foto;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState(){
    super.initState();
    loadFoto();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  void loadFoto() async{
    final imagem = await widget.authController.getFoto(); // seu AuthService
    setState(() {
      foto = imagem;
    });

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
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: ClipOval(
        child: _image != null
            ? Image.file(
                _image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : (foto != null && foto!.isNotEmpty) ?
            Image.network(foto!, width: 150, height: 150, fit: BoxFit.cover)
            : Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.white70,
                ),
              ),
      ),
    );
  }
}

class Telefone extends StatefulWidget {
  late TextEditingController controller;
  final AuthController authController;
  Telefone({super.key, required this.authController, required this.controller});

  @override
  State<Telefone> createState() => _TelefoneState();
}

class _TelefoneState extends State<Telefone> {

  @override
  void initState(){
    super.initState();

    widget.controller = TextEditingController(text: widget.authController.usuario?.telefone);
  }
  @override
  Widget build(BuildContext context) {
    final user = widget.authController.usuario;
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "Telefone",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class Whatsapp extends StatelessWidget {
  const Whatsapp({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Whatsapp",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
class site extends StatelessWidget {
  const site({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "site",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class Insta extends StatelessWidget {
  const Insta({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Insta",
        labelStyle: const TextStyle(color: Colors.black, fontFamily: "Poppins"),
        hintText: "Fulano de Tal",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

class botao extends StatelessWidget {
  const botao({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Salvar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  final dropValue = ValueNotifier('');
  final dropOpcoes = ["3", "2", "1"];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dropValue,
      builder: (BuildContext context, String value, _) {
        return DropdownSearch<String>(
          items: dropOpcoes,
          selectedItem: value.isEmpty ? null : value,
          onChanged: (String? newValue) {
            dropValue.value = newValue ?? '';
          },
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Pesquisar área...",
                 labelStyle: const TextStyle(
              color: Colors.black, fontFamily: "Poppins"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Área de atuação",
              labelStyle: const TextStyle(
              color: Colors.black, fontFamily: "Poppins"),
              hintText: "Escolha a área de atuação",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(121, 180, 217, 1),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}

///Se for empresa


class Categoria extends StatefulWidget {
  final AuthController authController;
  final void Function(CategoriaModel?) onCategoriaSelecionado;

  Categoria({super.key, required this.authController, required this.onCategoriaSelecionado});

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  String? categoria;
  List<CategoriaModel> categorias = [];
  CategoriaModel? categoriaSelecionada;


  late final CategoriaRepository categoriaRepository;

  @override
  // TODO: implement context
  void initState(){
    
    categoriaRepository = CategoriaRepository(client: apiHttp.DioClient.dio);
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    categorias = await categoriaRepository.getCategoria();

    try {
      categoriaSelecionada = categorias.firstWhere(
      (c) => c.nome == widget.authController.usuario!.categoriaNome,
      );
    } catch (e) {
      categoriaSelecionada = null; // não encontrou → null permitido
    }
    // Define a categoria selecionada de acordo com o usuário
    

    setState(() {}); // atualiza a UI após carregar categorias
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<CategoriaModel>(
      selectedItem: categoriaSelecionada,
      asyncItems: (String? filtro) => categoriaRepository.getCategoria(),
          itemAsString:(CategoriaModel? Categoria) => Categoria?.nome ?? "",
          onChanged: (CategoriaModel? Categoria){
            setState(() {
              categoriaSelecionada = Categoria;
            });
            widget.onCategoriaSelecionado(Categoria);
          },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: "Pesquisar área...",
             labelStyle: const TextStyle(
          color: Colors.black, fontFamily: "Poppins"),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        fit: FlexFit.loose,
        constraints: const BoxConstraints(maxHeight: 250),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Área de atuação",
          labelStyle: const TextStyle(
          color: Colors.black, fontFamily: "Poppins"),
          hintText: "Escolha a área de atuação",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(121, 180, 217, 1),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
