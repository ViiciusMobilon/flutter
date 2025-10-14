// Importações principais do Flutter
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

// Importação da tela "Escolha", para navegação após o cadastro
import 'package:tcc/cadastro/Escolha.dart';

// -----------------------------
// Tela principal de Cadastro
// -----------------------------
class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      home: Scaffold(
        body: Container(
          // Define o tamanho total da tela
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,

          // Fundo branco
          decoration: const BoxDecoration(color: Colors.white),

          // Permite rolar o conteúdo caso o teclado apareça
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
              children: [
                // ---------- LOGO ----------
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07,
                    ),
                    child: const imagem(), // Chama o widget da imagem
                  ),
                ),

                // ---------- TÍTULO "Cadastro" ----------
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Text(
                      "Cadastro",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),

                // ---------- CAMPO EMAIL ----------
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: const email(), // Chama o widget do campo de e-mail
                ),

                // ---------- CAMPO SENHA ----------
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: const senha(), // Campo de senha
                ),

                // ---------- CAMPO CONFIRMAR SENHA ----------
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: const confirmar(),
                ),

                // ---------- BOTÃO CONTINUAR ----------
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: const Center(child: botao()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------
// CAMPO DE EMAIL
// -----------------------------
class email extends StatefulWidget {
  const email({super.key});

  @override
  State<email> createState() => _emailState();
}

class _emailState extends State<email> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "xxxxx@gmail.com", // Texto de exemplo
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "Email",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        // Bordas do campo quando está em foco
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        // Bordas padrão
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// -----------------------------
// CAMPO DE SENHA
// -----------------------------
class senha extends StatefulWidget {
  const senha({super.key});

  @override
  _senhaState createState() => _senhaState();
}

class _senhaState extends State<senha> {
  bool senhaVisivel = true; // Controla se a senha está oculta ou não

  void mudarVisao() {
    setState(() {
      senhaVisivel = !senhaVisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: senhaVisivel, // Oculta ou mostra o texto
      decoration: InputDecoration(
        labelText: "Senha",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "123456",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        // Bordas e estilo
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        // Ícone de mostrar/ocultar senha
        suffixIcon: IconButton(
          icon: Icon(
              senhaVisivel ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
          ),
          onPressed: mudarVisao,
        ),
      ),
    );
  }
}

// -----------------------------
// CAMPO CONFIRMAR SENHA
// -----------------------------
class confirmar extends StatefulWidget {
  const confirmar({super.key});

  @override
  State<confirmar> createState() => _confirmarState();
}

class _confirmarState extends State<confirmar> {
  bool senha2 = true; // Controla se a senha está oculta

  void mudarvisao() {
    setState(() {
      senha2 = !senha2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: senha2,
      decoration: InputDecoration(
        labelText: "Confirmar Senha",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "123456",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        // Ícone de alternar visibilidade
        suffixIcon: IconButton(
          icon: Icon(senha2 ? Icons.visibility_off : Icons.visibility),
          onPressed: mudarvisao,
        ),
      ),
    );
  }
}

// -----------------------------
// BOTÃO "CONTINUAR"
// -----------------------------
class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ao clicar, navega para a tela Escolha
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Escolha()),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,

        // Botão com gradiente e sombra
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),

        // Conteúdo do botão (texto + ícone)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Text(
                "Continuar",
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

// -----------------------------
// LOGO / IMAGEM SUPERIOR
// -----------------------------
class imagem extends StatelessWidget {
  const imagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/logo.png"),
          fit: BoxFit.fill, // Preenche o espaço sem distorcer
        ),
      ),
    );
  }
}
