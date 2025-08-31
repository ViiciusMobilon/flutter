import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:projeto_principal/cadastro/Escolha.dart';
import 'package:projeto_principal/models/user.dart';

void main()=>runApp(Cadastro());
class Cadastro extends StatefulWidget{
  const Cadastro({super.key});
  @override
  State<Cadastro> createState() => _CadastroState();
} 
class _CadastroState extends State<Cadastro> {
  // ← Aqui você cria os controllers
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmation_passwordController = TextEditingController();

  @override
  void dispose() {
    // Limpar controllers quando a tela for destruída
    nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmation_passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        body: Container(

          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Center(
                  child: Padding(
                    padding:  EdgeInsets.only(  top: MediaQuery.of(context).size.height * 0.07,),
                    child: imagem(),
                  ),
                ),
                //texto sign
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Text(
                      "Cadastro",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        color: const Color.fromARGB(255, 8, 8, 8),
                        fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
                //fim sign
              
                //textfield de email
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                  ),
                  child: email(controller: emailController),
                ),
                //fim email
                //textfield senha
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: senha(controller: passwordController,),
                ),

                // fim senha
               Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: confirmar(controller: confirmation_passwordController,),
                ),
                //botao
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: Center(child: botao()),
                ),
                //fim botao
                //escrita para o cadastro
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
  final TextEditingController? controller;
  const email({super.key, required this.controller});

  @override
  State<email> createState() => _emailState();
}

class _emailState extends State<email> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
  final TextEditingController? controller;
  const senha({super.key, required this.controller});

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
      controller: widget.controller,
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
class confirmar extends StatefulWidget {
  final TextEditingController? controller;
  const confirmar({super.key, required this.controller});

  @override
  State<confirmar> createState() => _confirmarState();
}

class _confirmarState extends State<confirmar> {
  @override
  bool senha2 = true;

  void mudarvisao() {
    setState(() {
      senha2 = !senha2;
    });
  }

  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: false,
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
          icon: Icon(senha2 ? Icons.visibility_off : Icons.visibility),
          onPressed: mudarvisao,
        ),
      ),
    );
  }
}

class botao extends StatefulWidget {
  final Text
  const botao({super.key});

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Escolha()), ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
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
        
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Padding(
          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.09, ),
          child: Text("continuar", style: TextStyle(
             color: const Color.from(alpha: 1, red: 0.988, green: 0.984, blue: 0.984),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
          ),),
        ), Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,)
      ],),
      ),
    );
  }
}

class imagem extends StatelessWidget {
  const imagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       width:MediaQuery.of(context).size.width *0.4,
       height:MediaQuery.of(context).size.height *0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/LOGO.png"), //fundo da imagem
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
