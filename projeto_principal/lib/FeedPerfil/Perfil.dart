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

class Mais extends StatefulWidget {
  const Mais({super.key});

  @override
  State<Mais> createState() => _MaisState();
}

class _MaisState extends State<Mais> {
  bool mostrarFechar = false;

  @override
  Widget build(BuildContext context) {
    if (mostrarFechar) {
      return const PerfilPrincipal(); // volta para o perfil principal
    }

    // Exemplo de descrição com limite de 255 caracteres
    String descricao =
        "Este é um exemplo de descrição que será exibida no perfil. "
        "Ela pode ter até 255 caracteres e o container vai se adaptar ao tamanho do texto. "
        "Você pode colocar informações adicionais aqui para testar o comportamento do container. "
        "Lembre-se de não ultrapassar o limite máximo para manter o layout consistente.";
    // corta para 255 caracteres caso ultrapasse
    if (descricao.length > 255) {
      descricao = descricao.substring(0, 255);
    }

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: 16,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Vinicius Mobilon",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Text(
                          "profissão",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 151, 151, 151),
                            fontWeight: FontWeight.w800,
                            fontFamily: "Poppins",
                          ),
                        ),
                        EstrelaRating(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Texto da descrição adaptável
              Text(
                descricao,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Botão "Fechar"
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      mostrarFechar = true;
                    });
                  },
                  child: const Text("Fechar"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}