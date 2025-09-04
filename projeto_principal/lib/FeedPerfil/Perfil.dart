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
        "Este é um exemplo que será exibida no perfil. Ela pode ter até 255 caracteres e vai sumindo gradualmente antes de chegar no botão Mais..."
        ;

    return ListView(
      children: [
        
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: 16,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          // quadrado branco

          child: 
          //foto + estrelas
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha com avatar + nome + profissão + avaliação
              Row(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.12,
                    backgroundImage: const NetworkImage(
                      "https://link-da-foto.com/foto.jpg",
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  const EstrelaRating(),
                ],
              ),
              // fim d foto + estrelas
               SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
               ),
              // Coluna com nome + profissão + empresa
             Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Empresa:",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        color: const Color.fromARGB(255, 99, 99, 99),
        fontWeight: FontWeight.w800,
        fontFamily: "Poppins",
      ),
    ),
    Text(
      "Engenheiro de Planejamento e Controle de Produção na  Indústria de Transformação de Plásticos",
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.027,
        color: const Color.fromARGB(255, 151, 151, 151),
        fontWeight: FontWeight.w800,
        fontFamily: "Poppins",
      ),
    ),
  ],
),

              // Linha com descrição + botão "Mais"
              Row(
                children: [
          
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
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width * 0.04,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800
                      ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      
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
    // Texto de descrição completo (SEM LIMITAR)
    String descricao =
        "Este é um exemplo de descrição que será   ccccccccccccccccccashkjasdhfkjashkjshfkajsdhfdascccccccccccccccccccccccccccccccccccccccccccccccccccccccccexibida no perfil. "
        "Ela pode ter até 255 caracteres ou até mais, e o container vai se "
        "adaptar automaticamente ao tamanho do texto sem cortar nada.";

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
              // Linha com avatar + estrelas
              Row(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.12,
                    backgroundImage: const NetworkImage(
                      "https://link-da-foto.com/foto.jpg",
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  const EstrelaRating(),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Nome + profissão + empresa
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Empresa:",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: const Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w800,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    "Engenheiro de Planejamento e Controle de Produção na Indústria de Transformação de Plásticos",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.027,
                      color: const Color.fromARGB(255, 151, 151, 151),
                      fontWeight: FontWeight.w800,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),

              // Descrição + botão Fechar
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text.rich(
                  TextSpan(
                    text: descricao + " ", // texto normal
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: voltar, // mesma ação do botão
                          child: Text(
                            "Fechar",
                            style: TextStyle(
                              color: Colors.blue, // cor de link
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
