import 'package:flutter/material.dart';
// Importando telas de cadastro específicas
import 'package:tcc/cadastro/Contratante.dart';
import 'package:tcc/cadastro/Empresa.dart';
import 'package:tcc/cadastro/Prestador.dart';
import 'package:tcc/cadastro/cadastro1.dart';

// Tela de escolha do tipo de cadastro
class Escolha extends StatelessWidget {
  const Escolha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de DEBUG no canto
      home: Scaffold(
        // Estrutura básica da tela com AppBar e corpo
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Cor branca
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), // Ícone de voltar
            onPressed: () {
              Navigator.of(context).pushReplacement(
                // Ao clicar, volta para a tela de cadastro inicial
                MaterialPageRoute(builder: (context) => Cadastro()),
              );
            },
          ),
          title: Text(
            "Faça sua escolha",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true, // Centraliza o título
        ),
        body: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255), // Fundo branco
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                // Botão para Empresa
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: button_empresa(),
                  ),
                ),
                // Botão para Prestador
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: button_prestador(),
                  ),
                ),
                // Botão para Contratante
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _button_contratante(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Botão Empresa
class button_empresa extends StatefulWidget {
  const button_empresa({super.key});

  @override
  State<button_empresa> createState() => _button_empresaState();
}

class _button_empresaState extends State<button_empresa> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Empresa())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8, // Altura do botão
        width: MediaQuery.of(context).size.width * 0.5, // Largura do botão
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)), // Borda arredondada
          color: Color.fromRGBO(255, 255, 255, 1), // Cor do botão
          boxShadow: <BoxShadow>[
            // Sombra do botão
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.domain, size: MediaQuery.of(context).size.width * 0.4),
            Center(
              child: Text(
                "Empresa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botão Prestador
class button_prestador extends StatefulWidget {
  const button_prestador({super.key});

  @override
  State<button_prestador> createState() => _button_prestadorState();
}

class _button_prestadorState extends State<button_prestador> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Prestador())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(250, 252, 255, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.badge, size: MediaQuery.of(context).size.width * 0.4),
            Center(
              child: Text(
                "Prestador",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "Poppins",
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botão Contratante
class _button_contratante extends StatefulWidget {
  const _button_contratante({super.key});

  @override
  State<_button_contratante> createState() => __button_contratanState();
}

class __button_contratanState extends State<_button_contratante> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Contratante())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.how_to_reg,
              size: MediaQuery.of(context).size.width * 0.4,
            ),
            Center(
              child: Text(
                "Contratante",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: "Poppins",
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
