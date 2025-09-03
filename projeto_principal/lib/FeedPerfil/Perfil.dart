import 'package:flutter/material.dart';
import 'package:projeto_principal/FeedPerfil/system_star.dart'; // seu widget EstrelaRating

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
      return Mais(
        voltar: () {
          setState(() {
            mostrarMais = false;
          });
        },
      );
    }

    // Texto de descrição de exemplo
    String descricao =
        "Este é um exemplo que será exibida no perfil. "
        "Ela pode ter até 255 caracteres e vai sumindo gradualmente antes de chegar no botão Mais...";

    return ListView(
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
              // Linha com avatar + nome + profissão + avaliação
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            fontSize:
                                MediaQuery.of(context).size.width * 0.027,
                            color: const Color.fromARGB(255, 151, 151, 151),
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
              const SizedBox(height: 8),

              // Linha com descrição + botão "Mais"
              Row(
                children: [
                  // Texto com gradiente e reticências
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        stops: const [0.85, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: Text(
                        descricao,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Botão "Mais" alinhado com o texto
                  TextButton(
                    onPressed: () {
                      setState(() {
                        mostrarMais = true;
                      });
                    },
                    child: const Text("Mais"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Tela Mais detalhada
class Mais extends StatelessWidget {
  final VoidCallback voltar;
  const Mais({super.key, required this.voltar});

  @override
  Widget build(BuildContext context) {
    // Texto de descrição completo
    String descricao =
        "Este é um exemplo de descrição que será exibida no perfil. "
        "Ela pode ter até 255 caracteres e o container vai se adaptar ao tamanho do texto. "
        "Você pode colocar informações adicionais aqui para testar o comportamento do container. "
        "Lembre-se de não ultrapassar o limite máximo para manter o layout consistente.";
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

              // Texto da descrição completo
              Text(
                descricao,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Botão "Fechar" para voltar
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: voltar,
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
