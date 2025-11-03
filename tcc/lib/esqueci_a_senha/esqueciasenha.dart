import 'package:flutter/material.dart';
import 'package:tcc/esqueci_a_senha/CodigoSenha.dart';

// Função principal que inicia o app
void main() => runApp(Esqueciasenha());

// ------------------ CLASSE PRINCIPAL ------------------
class Esqueciasenha extends StatefulWidget {
  const Esqueciasenha({super.key});

  @override
  State<Esqueciasenha> createState() => _EsqueciasenhaState();
}

class _EsqueciasenhaState extends State<Esqueciasenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Ocupa toda a tela
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        // Cor de fundo branca
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),

        // Permite rolar a tela caso o teclado apareça
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- LOGO ----------------
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07,
                  ),
                  child: const imagem(), // Usa o widget personalizado da logo
                ),
              ),

              // ---------------- TÍTULO ----------------
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: Text(
                    "Esqueceu a senha ?",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),

              // ---------------- SUBTÍTULO ----------------
              Center(
                child: Text(
                  "Redefina-a em duas etapas simples",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              // ---------------- CAMPO DE EMAIL ----------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                ),
                child: const emailesqueci(), // Campo de texto para o e-mail
              ),

              // ---------------- BOTÃO ----------------
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: const Center(child: botao()), // Botão "Próximo"
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ CAMPO DE EMAIL ------------------
class emailesqueci extends StatefulWidget {
  const emailesqueci({super.key});

  @override
  State<emailesqueci> createState() => _emailesqueciState();
}

class _emailesqueciState extends State<emailesqueci> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        // Texto de dica dentro do campo
        hintText: "xxxxx@gmail.com",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.045,
          fontFamily: "Poppins",
        ),

        // Rótulo acima do campo
        labelText: "Email cadastrado",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.045,
          fontFamily: "Poppins",
        ),

        // Borda quando o campo está em foco
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),

        // Borda quando o campo não está em foco
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ------------------ BOTÃO "PRÓXIMO" ------------------
class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ação ao clicar no botão
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CodigoPage()),
        );
      },

      // Estilo visual do botão
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          // Degradê azul
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            // Sombra suave no botão
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),

        // Conteúdo do botão: texto e ícone
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Text(
                "Próximo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ------------------ LOGO ------------------
class imagem extends StatelessWidget {
  const imagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Define o tamanho proporcional da logo
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.25,

      // Define a imagem e o ajuste de exibição
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/logo.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
