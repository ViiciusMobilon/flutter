import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/FeedPerfil/system_star.dart';

class PerfilPrincipal extends StatefulWidget {
  const PerfilPrincipal({super.key});

  @override
  State<PerfilPrincipal> createState() => _PerfilPrincipalState();
}

class _PerfilPrincipalState extends State<PerfilPrincipal> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.height * 0.04,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                       top: MediaQuery.of(context).size.height*0.03
                      ),
                      child: Text(
                        "Vinicius Mobilon",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Poppins",
                        ),
                        overflow: TextOverflow.ellipsis, // evita quebrar feio
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: MediaQuery.of(context).size.height*0.01
                      ),
                      child: Text("profissão", style: TextStyle(
                         fontSize: MediaQuery.of(context).size.width * 0.027,
                          color: const Color.fromARGB(255, 151, 151, 151),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Poppins",
                      ),),
                    ),

                    EstrelaRating(),
                        
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
