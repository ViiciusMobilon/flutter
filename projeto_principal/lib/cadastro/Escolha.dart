import 'package:flutter/material.dart';
import 'package:projeto_principal/cadastro/Contratante.dart';
import 'package:projeto_principal/cadastro/Empresa.dart';
import 'package:projeto_principal/cadastro/Prestador.dart';
import 'package:projeto_principal/cadastro/cadastro1.dart';

void main() => runApp(Escolha());

class Escolha extends StatelessWidget {
  const Escolha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.black),
  onPressed: () {
    Navigator.of(context).pushReplacement(
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
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                //fim da imagem
                //empresa
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
                //fim button_empresa
                //prestador
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
                //fim prestador
                //contratante
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
                //fim contratante
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Empresa())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: <BoxShadow>[
            //para todas as caracteristicas do boxshadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4), //posição
              blurRadius: 8, //fumaça
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
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Prestador())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(250, 252, 255, 1),
          boxShadow: <BoxShadow>[
            //para todas as caracteristicas do boxshadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4), //posição
              blurRadius: 8, //fumaça
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
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Contratante())),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            //para todas as caracteristicas do boxshadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4), //posição
              blurRadius: 8, //fumaça
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
