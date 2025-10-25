import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tcc/data/controllers/auth_controller.dart';
import 'package:tcc/esqueci_a_senha/Novasenha.dart';
import 'package:tcc/settins/pgsettins.dart';

class CodigoPageEmail extends StatefulWidget {
  final AuthController controller;

  CodigoPageEmail({super.key, required this.controller});

  @override
  State<CodigoPageEmail> createState() => _CodigoPageState();
}

class _CodigoPageState extends State<CodigoPageEmail> {
  String codigo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        
        centerTitle: true,
      ),
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
                  "Digite o código",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Poppins",
                  ),
                ),
              ),

              // Subtítulo
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

              // Campo código
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06,
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                ),
                child: Pinput(
                  length: 6,
                  onCompleted: (value) => codigo = value,
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

              // Botão próximo
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (codigo.length == 6) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettinsPage(authController: widget.controller,),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Digite o código completo"),
                        ),
                      );
                    }
                  },
                  child: botao(texto: "Salvar"),
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
          image: AssetImage("assets/imagens/logo.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class botao extends StatelessWidget {
  final String texto;
  const botao({super.key, required this.texto});

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
            texto,
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
