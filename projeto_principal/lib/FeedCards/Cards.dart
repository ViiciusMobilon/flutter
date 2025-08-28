import 'package:flutter/material.dart';

class FeedPrincipal extends StatelessWidget {
  const FeedPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
