import 'package:flutter/material.dart';
import 'package:projeto_principal/data/controllers/auth_controller.dart';

class FeedPrincipal extends StatefulWidget {
  final AuthController authController;

  FeedPrincipal({super.key, required this.authController});

  @override
  State<FeedPrincipal> createState() => _FeedPrincipalState();
}

class _FeedPrincipalState extends State<FeedPrincipal> {
  String? foto;
  Map<String, dynamic>? ramos;

  @override
  void initState() {
    super.initState();
    loadFoto(); // carrega a foto do storage
    loadRamo();
  }
  // void loadUser() async {
  //   final user = await widget.authController.getUser();
  //   setState(() {
  //     usuario = user;
  //   });
  // }
  void loadFoto() async {
    final imagem = await widget.authController.getFoto(); // seu AuthService
    setState(() {
      foto = imagem;
    });
  }
  void loadRamo() async{
    final ramo = await widget.authController.getRamo();
    setState(() {
      ramos = ramo;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    final conectado = widget.authController.conectado;
    final user = widget.authController.usuario;
    final foto = widget.authController.foto;
    final ramo = widget.authController.ramo;
    print("Ramo cards: ${ramo}");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigoAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            "Seu Perfil",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Gerencie suas informações pessoais aqui.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              color: Colors.grey[600],
            ),
          ),
          Text(
            "Email: ${user?.email ?? 'não existo'}"
          ),
          Text("nome: ${user?.nome ?? 'nao existo'}"),
          Text("Localização: ${user?.cidade ?? 'nao existo'} ${user?.estado ?? 'nao existo'}"),
          Text("uf: ${user?.estado ?? 'nao existo'}"),
          Text(
            "Você é: ${user?.tipo ?? 'desempregado'}"
          ),
          Text("foto: ${user?.fotoURL ?? 'não existo'}"),
          Text("ramo: ${user?.ramoNome ?? 'não existo'}"),
        ],
      ),
    );
  }
}
