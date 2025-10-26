// Importações principais do Flutter
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Importação da tela "Escolha", para navegação após o cadastro
import 'package:tcc/cadastro/Escolha.dart';
import 'package:tcc/data/controllers/verificar_controller.dart';
import 'package:tcc/data/models/userForm.dart';


final maskFormatter = MaskTextInputFormatter(
  mask: '##.###-###',
  filter: { "#": RegExp(r'[a-zA-Z0-9]') },
);


// void main()=>runApp(Cadastro());
class Cadastro extends StatefulWidget{
   Cadastro({super.key});
  @override
  State<Cadastro> createState() => _CadastroState();
} 
class _CadastroState extends State<Cadastro> {
  // ← Aqui você cria os controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmation_passwordController = TextEditingController();
  String? erroEmail;
  String? erroPassword;
  String? erroPasswordConfirmation;

  @override
  void dispose() {
    // Limpar controllers quando a tela for destruída
    // nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmation_passwordController.dispose();
    super.dispose();
  }
  void limpar(){
    if(erroEmail != null){
      setState(() => erroEmail = null);
    }
    if(erroPassword != null){
      setState(() => erroPassword = null);
    }
    if(erroPasswordConfirmation != null){
      setState(() => erroPasswordConfirmation = null);
    }
  }
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
                  child: email(controller: emailController, erroEmail: erroEmail,onClearerror: limpar,),
                ),
                
                //fim email
                //textfield senha
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: senha(controller: passwordController, erroPassword: erroPassword, onClearerror: limpar 
                ),
                ),

                // ---------- CAMPO CONFIRMAR SENHA ----------
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.08,
                    right: MediaQuery.of(context).size.width * 0.08,
                    top: MediaQuery.of(context).size.height * 0.04,
                  ),
                  child: confirmar(controller: confirmation_passwordController,
                        erroPasswordConfirmation: erroPasswordConfirmation,
                        onClearerror: limpar),
                ),

                // ---------- BOTÃO CONTINUAR ----------
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                  ),
                  child: Center(
                    child: 
                    botao(erroEmail: (msg) => setState(() => erroEmail = msg),
                        erroPassword: (msg) => setState(() => erroPassword = msg),
                        erroPasswordConfirmation: (msg) => setState(() => erroPasswordConfirmation = msg),
                        emailController: emailController,
                        passwordController: passwordController,
                        passwordConfirmationController: confirmation_passwordController,)
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

// -----------------------------
// CAMPO DE EMAIL
// -----------------------------
class email extends StatefulWidget {
  final TextEditingController? controller;
  final String? erroEmail;
  final VoidCallback onClearerror;
  email({super.key, required this.controller, required this.erroEmail, required this.onClearerror});

  @override
  State<email> createState() => _emailState();
}

class _emailState extends State<email> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
        errorText: widget.erroEmail
      ),
       onChanged: (value){
        widget.onClearerror();
      },
    );
  }
}

// -----------------------------
// CAMPO DE SENHA
// -----------------------------
class senha extends StatefulWidget {
  final TextEditingController? controller;
  String? erroPassword;
  final VoidCallback onClearerror;

  senha({super.key, required this.controller, this.erroPassword,required this.onClearerror});

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
      inputFormatters: [LengthLimitingTextInputFormatter(8)],

      obscureText: senhaVisivel, // oculta ou mostra
      controller: widget.controller,
      autofocus: false,
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
          errorText: widget.erroPassword
      ),
       onChanged: (value){
        widget.onClearerror();
      },
    );
  }
}

// -----------------------------
// CAMPO CONFIRMAR SENHA
// -----------------------------
class confirmar extends StatefulWidget {
  final TextEditingController? controller;
  String? erroPasswordConfirmation;
  final VoidCallback onClearerror;
  confirmar({super.key, required this.controller, this.erroPasswordConfirmation, required this.onClearerror});

  @override
  State<confirmar> createState() => _confirmarState();
}

class _confirmarState extends State<confirmar> {
  bool senha2 = true;

  void mudarvisao() {
    setState(() {
      senha2 = !senha2;
    });
  }

  @override
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
            errorText: widget.erroPasswordConfirmation
      ),
       onChanged: (value){
        widget.onClearerror();
      },
    );
  }
}

// -----------------------------
// BOTÃO "CONTINUAR"
// -----------------------------
class botao extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final void Function (String?) erroEmail;
  final void Function (String?) erroPassword;
  final void Function (String?) erroPasswordConfirmation;
   botao({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.erroEmail,
    required this.erroPassword,
    required this.erroPasswordConfirmation,
  });

  @override
  State<botao> createState() => _botaoState();
}

class _botaoState extends State<botao> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() async{
        final usuario = Userform(
          email: widget.emailController.text,
          password: widget.passwordController.text,
          confirmation_password: widget.passwordConfirmationController.text,
        );
        if(widget.emailController.text.isEmpty){
          widget.erroEmail("digite um email");
          return;
        }
        if(widget.passwordController.text.isEmpty){
          widget.erroPassword("digite uma senha");
          return;
        }
        if(widget.passwordConfirmationController.text.isEmpty){
          widget.erroPasswordConfirmation("digite a confirmação");
          return;
        }
        if (widget.passwordController.text != widget.passwordConfirmationController.text) {
          widget.erroPasswordConfirmation("As senhas não se coincidem!");
          return; 
        }
        
        final verificarController = VerificarController();
        final vemail = await verificarController.verificar(widget.emailController.text, 'check-email');
        print('msg email: ${vemail['msg']}');


        if((vemail['msg'] as String).isNotEmpty){
          widget.erroEmail(vemail['msg']);
          print('digite um email valido');
          return;
        }
        
        
        if(vemail['existe'] == true){
          widget.erroEmail(vemail['msg']);
          print("Existe email: ${vemail['msg']}");
          return;
        }
        else{
          print('não existe');
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>Escolha(usuario: usuario,),
          ),
        );
        }
      },
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
