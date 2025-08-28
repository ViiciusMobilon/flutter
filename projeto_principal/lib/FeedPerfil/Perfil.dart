import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/FeedPerfil/system_star.dart';

class PerfilPrincipal extends StatefulWidget {
  const PerfilPrincipal({super.key});

  @override
  State<PerfilPrincipal> createState() => _PerfilPrincipalState();
}

class _PerfilPrincipalState extends State<PerfilPrincipal> {
  bool mostrarMais = false;

  @override
  Widget build(BuildContext context) {
    if (mostrarMais) {
      return const Mais(); // mostra as especificações do Mais
    }

    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: const BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.12,
                    backgroundImage: const NetworkImage(
                      "https://link-da-foto.com/foto.jpg",
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vinicius Mobilon",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Text(
                          "profissão",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.027,
                            color: Color.fromARGB(255, 151, 151, 151),
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const EstrelaRating(),
                      ],
                    ),
                  ),
                ],
              ),

              // Botão "Mais" posicionado no canto inferior direito do container
              Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      mostrarMais = true;
                    });
                  },
                  child: const Text("Mais"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Mais extends StatelessWidget {
  const Mais({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.width * 0.08,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.12,
                backgroundImage: const NetworkImage(
                  "https://link-da-foto.com/foto.jpg",
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),

              // Nome do perfil
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Text(
                        "Vinicius Mobilon",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Poppins",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Text(
                        "profissão",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.027,
                          color: const Color.fromARGB(255, 151, 151, 151),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),

                    // Sistema de estrelas
                    const EstrelaRating(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
