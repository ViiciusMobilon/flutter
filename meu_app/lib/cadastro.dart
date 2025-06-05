import 'package:flutter/material.dart';
import 'package:meu_app/escolha_registro.dart';

void main(){  runApp(Cadastro());}
class Cadastro extends StatelessWidget {
   Cadastro({super.key});

final Color cor =  Color(0xFF0F2859);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      
      home: Scaffold(
        appBar: AppBar(
          title:Text("Cadastro",
        style: TextStyle( color: const Color.fromARGB(252, 255, 254, 254)),
        textAlign: TextAlign.center,
          ),
          centerTitle: true,
                    backgroundColor: cor,
        ),
        body: ListView(
children: [
 //imagem
    Padding(padding: EdgeInsets.only(top: 20)),
    Container(
    width: MediaQuery.of(context).size.width * 0.7, // 70% da largura da tela
    height: MediaQuery.of(context).size.height * 0.2, // 30% da altura da tela
    decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/image/LOGO.png"),
      fit: BoxFit.contain))),
//fim da imagem


//email
     Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0.1,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: email(),),
     //fim email
     //senha
     Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.0, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: senha(),),
 //fim senha
     Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.0, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: verificarsenha(),),
     //texto clique aqui
      Padding(padding: EdgeInsets.only(bottom:10,
      left:MediaQuery.of(context).size.width*0.2 ,
      right: MediaQuery.of(context).size.width*0.1,
      top: 10)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
       children: [
       
        Text("ja tem uma conta? clique ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),),
        
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Cadastro() )),
          child: Text("Aqui", style: TextStyle(color: const Color.fromRGBO(68, 138, 255, 1) ,fontSize: MediaQuery.of(context).size.width * 0.05,),),
        )
       ],
      ),
//fim do texto clique aqui

       Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: SizedBox(
     height: MediaQuery.of(context).size.height*0.1,
      width: MediaQuery.of(context).size.width*0.5,
      child: button(),
     )),
     

     Padding(
       padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1,
       left: MediaQuery.of(context).size.width*0.21
       ),
       child: texto(),
     )
     

],

        )

          
        ),
        debugShowCheckedModeBanner: false,
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
        labelText:"email" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,)  ,
            hintText: "blabla@gmail.com",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5)
        )
      ),

    );
  }
}

class senha extends StatefulWidget {
  const senha({super.key});

  @override
  _senhaState createState() =>_senhaState();
}

class _senhaState extends State<senha> {
  @override
  bool senha = true;

  void mudarvisao(){
    setState(() {
      senha=! senha;
    });
  }
  Widget build(BuildContext context) {
    return 
          TextField(
                   
                   maxLength: 5,  
                   autofocus: false,
                   obscureText: senha,
             decoration: InputDecoration(
            labelText:"senha" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,)  ,
            hintText: "123456",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
            border: UnderlineInputBorder(
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
              
            ),
            disabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
            ),
            suffixIcon: IconButton( icon:Icon(senha ? Icons.visibility_off :Icons.visibility ), onPressed: mudarvisao )
             ),
               
        
         );
  }
}
 
 class verificarsenha extends StatefulWidget {
  const verificarsenha({super.key});

  @override
  _verificarsenhaState createState() =>_verificarsenhaState();
}

class _verificarsenhaState extends State<verificarsenha> {
  @override
  bool senha = true;

  void mudarvisao(){
    setState(() {
      senha=! senha;
    });
  }
  Widget build(BuildContext context) {
    return 
          TextField(
                   
                   maxLength: 5,  
                   autofocus: false,
                   obscureText: senha,
             decoration: InputDecoration(
            labelText:"confirmar senha" ,labelStyle: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width * 0.05,)  ,
            hintText: "123456",hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
            border: UnderlineInputBorder(
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
              
            ),
            disabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromRGBO(121, 180, 217, 1), width: 1.5),
            ),
            suffixIcon: IconButton( icon:Icon(senha ? Icons.visibility_off :Icons.visibility ), onPressed: mudarvisao )
             ),
               
        
         );
  }
}

class button extends StatefulWidget {
  button({super.key});
final Color cor =  Color.fromRGBO(15, 40, 89, 1.0);
  @override
  State<button> createState() => _buttonState();
}

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => Escolha_registro(), )),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 40, 89, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height*0.009,
        
        width: MediaQuery.of(context).size.width*0.01,
       child: Text("Continuar", textAlign: TextAlign.center, style: TextStyle(color: Colors.white ,fontSize: MediaQuery.of(context).size.width * 0.06,),),
      ),
    );
  }
}
class texto extends StatelessWidget {
  const texto({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
        children: <Widget>[
          Text("Ao clicar no botão eu concordo com os ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02)),
          Text("Termos ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02,color: Colors.blueAccent)),
          Text("e ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02)),
          Text("Publicação", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02, color: Colors.blueAccent),)
        ],
       );
  }
}