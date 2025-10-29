import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/cadastro/Escolha.dart';
import 'package:tcc/paginas_principais/pagina_principal.dart';

// Máscara para o campo de CEP (ex: 12.345-678)
final cpfMaskFormatter = MaskTextInputFormatter(
  mask: '##.###-###',
  filter: {"#": RegExp(r'[0-9]')},
);

// Máscara para o campo de número (somente números, até 5 dígitos)
final numeromaskFormatter = MaskTextInputFormatter(
  mask: '#####',
  filter: {"#": RegExp(r'[0-9]')},
);

// Tela principal da página de endereço (CEP)
class CEP extends StatefulWidget {
  const CEP({super.key});

  @override
  State<CEP> createState() => _CEPState();
}

class _CEPState extends State<CEP> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        backgroundColor: Colors.white,

        // AppBar no topo da tela
        appBar: AppBar(
           surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            // Botão de voltar para a tela de escolha
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Escolha()),
              );
            },
          ),
          title: Text(
            "Endereço",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
            ),
          ),
          centerTitle: true,
        ),

        // Corpo da tela (rolável)
        body: ListView(
          children: <Widget>[
            // Campo de CEP
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                bottom: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: const cep(),
            ),

            // Linha com Cidade e Estado lado a lado
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 4, child: cidade()),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                  Expanded(flex: 3, child: estado()),
                ],
              ),
            ),

            // Campo de rua / avenida
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: const Rua(),
            ),

            // Campo de número
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: numero(),
            ),

            // Campo de cidade repetido (aparentemente sobrou, pode remover se quiser)
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Center(child: cidade()),
            ),

            // Botão "Próximo"
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.22,
              ),
              child: Center(child: botao()),
            ),
          ],
        ),
      ),
    );
  }
}

// Campo de texto para CEP
class cep extends StatefulWidget {
  const cep({super.key});

  @override
  State<cep> createState() => _cepState();
}

class _cepState extends State<cep> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      inputFormatters: [cpfMaskFormatter],
      decoration: InputDecoration(
        labelText: "CEP",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "99999-999",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

// Campo de texto para Rua / Avenida
class Rua extends StatefulWidget {
  const Rua({super.key});

  @override
  State<Rua> createState() => _RuaState();
}

class _RuaState extends State<Rua> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Rua / Avenida",
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        hintText: "Avenida sei la",
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}

// Campo de texto para número da residência
class numero extends StatefulWidget {
  const numero({super.key});

  @override
  State<numero> createState() => _numeroState();
}

class _numeroState extends State<numero> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [numeromaskFormatter],
      maxLength: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "1234",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "Número",
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

// Botão "Próximo" com gradiente
class botao extends StatefulWidget {
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navega para a tela principal
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TelaPrincipal())),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: Offset(0, 4),
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
                "Próximo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Campo de texto para Cidade
class cidade extends StatefulWidget {
  const cidade({super.key});

  @override
  State<cidade> createState() => _adicionaisState();
}

class _adicionaisState extends State<cidade> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 128,
      decoration: InputDecoration(
        hintText: "Cidade",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "Cidade",
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

// Campo de texto para Estado
class estado extends StatefulWidget {
  const estado({super.key});

  @override
  State<estado> createState() => _estadoState();
}

class _estadoState extends State<estado> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 128,
      decoration: InputDecoration(
        hintText: "Estado",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontFamily: "Poppins",
        ),
        labelText: "Estado",
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
