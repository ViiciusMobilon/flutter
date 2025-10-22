import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/cadastro/cadastro1.dart';
import 'package:tcc/esqueci_a_senha/esqueciasenha.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(), // Tela principal do app
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloqueia completamente o botão voltar
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07,
                    ),
                    child: const imagem(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Text(
                      "Acessar!",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.04,
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: const email(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: const senha(),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08,
                      top: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: const esqueci(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: const Center(child: botao()),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: const Center(child: texcadastro()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Suas outras classes (nome, email, senha, botao, imagem, etc.) ficam IGUAIS
// Não precisa alterar nada nelas.


class nome extends StatefulWidget {
  const nome({super.key});

  @override
  State<nome> createState() => _nomeState();
}

class _nomeState extends State<nome> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "fulano",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "Nome de Usuario",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

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
        hintText: "xxxxx@gmail.com",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "email",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class senha extends StatefulWidget {
  const senha({super.key});

  @override
  _senhaState createState() => _senhaState();
}

class _senhaState extends State<senha> {
  @override
  bool senha = true;

  void mudarvisao() {
    setState(() {
      senha = !senha;
    });
  }

  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      obscureText: senha,
      decoration: InputDecoration(
        labelText: "senha",
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
        border: UnderlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromRGBO(121, 180, 217, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: IconButton(
          icon: Icon(senha ? Icons.visibility_off : Icons.visibility),
          onPressed: mudarvisao,
        ),
      ),
    );
  }
}

class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => TelaPrincipal())),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.indigoAccent],
          ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Text(
                "Entrar",
                style: TextStyle(
                  color: const Color.fromARGB(255, 252, 251, 251),
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

class imagem extends StatelessWidget {
  const imagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/logo.png"), //fundo da imagem
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class texcadastro extends StatelessWidget {
  const texcadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Cadastro())),

      child: Text(
        "Não tenho conta",
        style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.03,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}

class esqueci extends StatefulWidget {
  const esqueci({super.key});

  @override
  State<esqueci> createState() => _esqueciState();
}

class _esqueciState extends State<esqueci> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Esqueciasenha())),
      child: Text(
        "Esqueci a senha",
        style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.03,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
