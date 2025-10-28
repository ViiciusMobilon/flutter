import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/data/models/Categoria.dart';
import 'package:tcc/data/models/userForm.dart';
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
  File? foto;
  final telefoneController = TextEditingController();
  final whatsappController= TextEditingController();
  final siteController = TextEditingController();
  final instaController = TextEditingController();
  final descricaoController = TextEditingController();
  int? id_categoria;
  int? id_ramo;
  @override
  void initState(){
    super.initState();
    final user = widget.authController.usuario!;
    descricaoController.text = user.descricao ?? '';
    telefoneController.text = user.telefone ?? '';
    whatsappController.text = user.whatsapp ?? '';
    instaController.text = user.instagram ?? '';
    siteController.text = user.site ?? '';
  }
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
            Center(child: Perfil(authController: widget.authController, image: foto,
            OnImageSelected: (file){
              setState(() {
                foto = file;
              });
            },),),
            // SizedBox(height: 30),
            // Nome(),
            
            SizedBox(height: 20),
            Descricao(controller: descricaoController,),
            
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
            Telefone(controller: telefoneController,),

             SizedBox(height: 30),
            Whatsapp(controller: whatsappController,),

             SizedBox(height: 30),
            Insta(controller: instaController,), 

            SizedBox(height: 30),
            site(controller: siteController,),
            
            SizedBox(height: 50),
            Center(child: botao(
              foto: foto,
              WhatsappController: whatsappController,descricaoController: descricaoController,
              authController: widget.authController,
              telefoneController: telefoneController,
              instaController: instaController,
              siteController: siteController,
            ),),

          ],
        ),
      ),
    );
  }
}

class Descricao extends StatelessWidget {
  late TextEditingController controller;
  Descricao({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:controller,
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
  late File? image;
  final void Function(File?) OnImageSelected;
  Perfil({super.key, required this.authController, required this.image, required this.OnImageSelected});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ImagePicker _picker = ImagePicker();
  String? fotoUrl;
  // File? imagem;
  @override
  void initState(){
    super.initState();
    loadFoto();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        final file = File(pickedFile.path);
        widget.OnImageSelected(file);
      });
    }
  }
  void loadFoto() async{
    final imagem = await widget.authController.getFoto(); // seu AuthService
    setState(() {
      fotoUrl = imagem;
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
        child: widget.image != null
            ? Image.file(
                widget.image!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : (fotoUrl != null && fotoUrl!.isNotEmpty) ?
            Image.network(fotoUrl!, width: 150, height: 150, fit: BoxFit.cover)
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

class Telefone extends StatelessWidget {
  late TextEditingController controller;

  Telefone({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
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
  late TextEditingController controller;
  Whatsapp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
  late TextEditingController controller;
  site({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
  late TextEditingController controller;
  Insta({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
  final AuthController authController;
  final File? foto;
  final TextEditingController telefoneController;
  final TextEditingController WhatsappController;
  final TextEditingController instaController;
  final TextEditingController siteController;
  final TextEditingController descricaoController;
  botao({super.key,
    required this.authController,
    required this.foto,
    required this.telefoneController,
    required this.WhatsappController,
    required this.instaController,
    required this.siteController,
    required this.descricaoController,
  });

  @override
  Widget build(BuildContext context) {
    final userForm = Userform();
    return GestureDetector(
      onTap: () async {
        userForm.foto = foto;
        userForm.telefone = telefoneController.text;
        userForm.whatsapp = WhatsappController.text;
        userForm.instagram = instaController.text;
        userForm.site = siteController.text;
        userForm.descricao = descricaoController.text;
        try {
          final userEdit = await authController.update(userForm);
          print("Usuário atualizado: $userEdit");
          print('dados: ${userForm.categoria}, ${userForm.descricao}, ${userForm.instagram}, ${userForm.site}, ${userForm.whatsapp}, ${userForm.telefone}}');

          if(userEdit != null){
            context.read<AuthController>().setUsuario(userEdit);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Perfil atualizado com sucesso!"), backgroundColor: Colors.green, duration: Duration(seconds: 1),),
            );
          }
        } catch (e) {
          print("Erro ao atualizar perfil: $e");
        }
      },
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
