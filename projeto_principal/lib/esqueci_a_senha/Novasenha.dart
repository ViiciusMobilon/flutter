
import 'package:flutter/material.dart';
import 'package:projeto_principal/main.dart';

class NovaSenhaPage extends StatefulWidget {
  final String codigo;
  const NovaSenhaPage({super.key, required this.codigo});

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  final senhaController = TextEditingController();
  final confirmar_senhaController = TextEditingController();

  void salvarSenha() {
    if (senhaController.text != confirmar_senhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    // Aqui você chamaria sua API passando widget.codigo + nova Novasenha
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Senha redefinida com sucesso!")),
    );

    Navigator.pop(context); // volta para tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                ),
                child: imagem(),
              ),

              // Título
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Text(
                  "Nova Senha",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              // Campo Novasenha
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.04,
                ),
                child: Novasenha()
              ),

              // Confirmar_senha Novasenha
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: confirmar_senha(),
              ),

              // Botão salvar
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: GestureDetector(
                  onTap: ()=> Navigator.of(context).push((MaterialPageRoute(builder: (context) => Main()))),
                  child: botao(),
                ),
              ),
            ],
          ),
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/LOGO.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class botao extends StatelessWidget {
  const botao({super.key, });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Salvar",
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

class Novasenha extends StatefulWidget {
  const Novasenha({super.key});

  @override
  _senhaState createState() => _senhaState();
}

class _senhaState extends State<Novasenha> {
  @override
  bool Novasenha = true;

  void mudarvisao() {
    setState(() {
      Novasenha = !Novasenha;
    });
  }

  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      obscureText: Novasenha,
      decoration: InputDecoration(
        labelText: "Digite a nova senha",
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
          icon: Icon(Novasenha ? Icons.visibility_off : Icons.visibility),
          onPressed: mudarvisao,
        ),
      ),
    );
  }
}

class confirmar_senha extends StatefulWidget {
  const confirmar_senha({super.key});

  @override
  State<confirmar_senha> createState() => _confirmar_senhaState();
}

class _confirmar_senhaState extends State<confirmar_senha> {
  @override
  bool confirmar = true;

  void mudarvisao() {
    setState(() {
      confirmar = !confirmar;
    });
  }

  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      obscureText: confirmar,
      decoration: InputDecoration(
        labelText: "Confirme a nova senha",
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
          icon: Icon(confirmar ? Icons.visibility_off : Icons.visibility),
          onPressed: mudarvisao,
        ),
      ),
    );
  }
}