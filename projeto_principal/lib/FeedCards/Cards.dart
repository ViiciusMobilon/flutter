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

  @override
  void initState() {
    super.initState();
    loadFoto(); // carrega a foto do storage
  }

  void loadFoto() async {
    final imagem = await widget.authController.getFoto(); // seu AuthService
    setState(() {
      foto = imagem;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    final usuario = widget.authController.user;
    final foto = widget.authController.foto;

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
            "Ola: ${usuario?['email'] ?? 'usuario'}"
          ),
          Text(
            "Você é: ${usuario?['type'] ?? 'desempregado'}"
          ),
          Text("foto: ${foto ?? 'não existo'}"),
        ],
      ),
    );
  }
}
