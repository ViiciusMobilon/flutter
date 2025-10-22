import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // Pacote usado para criar campos de PIN (código)
import 'package:tcc/esqueci_a_senha/Novasenha.dart'; // Import da próxima tela

// --------------------------- TELA PRINCIPAL ---------------------------
class CodigoPage extends StatefulWidget {
  const CodigoPage({super.key});

  @override
  State<CodigoPage> createState() => _CodigoPageState();
}

class _CodigoPageState extends State<CodigoPage> {
  String codigo = ""; // Armazena o código digitado pelo usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white), // Fundo branco
        child: SingleChildScrollView( // Permite rolagem caso o conteúdo ultrapasse a tela
          child: Column(
            children: [
              // --------------------------- LOGO ---------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                ),
                child: imagem(), // Chama o widget de imagem do logo
              ),

              // --------------------------- TÍTULO ---------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Text(
                  "Digite o código",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              // --------------------------- SUBTÍTULO ---------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Text(
                  "Insira o código de verificação recebido",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: Colors.black87,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              // --------------------------- CAMPO DE CÓDIGO ---------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06,
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Pinput(
                  length: 6, // Define que o código terá 6 dígitos
                  onCompleted: (value) => codigo = value, // Salva o código quando completo
                  defaultPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.width * 0.12,
                    textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // --------------------------- BOTÃO "PRÓXIMO" ---------------------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: GestureDetector(
                  onTap: () {
                    // Verifica se o código possui 6 dígitos antes de continuar
                    if (codigo.length == 6) {
                      // Vai para a próxima página (NovaSenhaPage)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NovaSenhaPage(codigo: codigo),
                        ),
                      );
                    } else {
                      // Mostra uma mensagem de erro se o código estiver incompleto
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Digite o código completo"),
                        ),
                      );
                    }
                  },
                  child: botao(texto: "Próximo"), // Chama o widget de botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------- WIDGET IMAGEM ---------------------------
class imagem extends StatelessWidget {
  const imagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/logo.png"), // Caminho da imagem
          fit: BoxFit.fill, // Preenche o espaço completamente
        ),
      ),
    );
  }
}

// --------------------------- WIDGET BOTÃO ---------------------------
class botao extends StatelessWidget {
  final String texto; // Texto que aparece dentro do botão
  const botao({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.indigoAccent], // Gradiente azul
        ),
        borderRadius: const BorderRadius.all(Radius.circular(40)), // Bordas arredondadas
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: const Offset(0, 4), // Sombra projetada para baixo
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            texto, // Exibe o texto recebido no construtor
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
