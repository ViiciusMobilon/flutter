import 'package:flutter/material.dart';

void main() => runApp(Cadastro());
class Cadastro extends StatelessWidget {
   Cadastro({super.key});

final Color cor =  Color.fromRGBO(15, 40, 89, 1.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      
      home: Scaffold(
        appBar: AppBar(
          title:Text("Cadastro",
        style: TextStyle( color: Colors.white),
        textAlign: TextAlign.center,
          ),
          centerTitle: true,
                    backgroundColor: cor,
        ),
        body: ListView(
children: [

    Padding(padding: EdgeInsets.only()),
    Container(
    width: MediaQuery.of(context).size.width * 0.4, // 70% da largura da tela
    height: MediaQuery.of(context).size.height * 0.2, // 30% da altura da tela
    decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/image/LOGO.png"),
      fit: BoxFit.contain))),

      Padding(padding: EdgeInsets.only(bottom:10,left:MediaQuery.of(context).size.width*0.2 ,right: MediaQuery.of(context).size.width*0.1,top: 40)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
       children: [
       
        Text("ja tem uma conta? clique "),
        
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Cadastro() )),
          child: Text("Aqui", style: TextStyle(color: Colors.blueAccent),),
        )
       ],
      ),

     Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0.1,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: email(),),

     Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.1, 
     left: MediaQuery.of(context).size.width*0.2, 
     bottom:MediaQuery.of(context).size.width*0.2,
     right:MediaQuery.of(context).size.width*0.2  ),
     child: senha(),),


     


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
        labelText:"email" ,labelStyle: TextStyle(color: Colors.black)  ,
            hintText: "blabla@gmail.com",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
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
            labelText:"senha" ,labelStyle: TextStyle(color: Colors.black)  ,
            hintText: "123456",
            border: UnderlineInputBorder(
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 255, 0, 0), width: 1.5),
              
            ),
            disabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            suffixIcon: IconButton( icon:Icon(senha ? Icons.visibility_off :Icons.visibility ), onPressed: mudarvisao )
             ),
               
        
         );
  }
}
 
 class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(

      decoration: InputDecoration(
        labelText:"email" ,labelStyle: TextStyle(color: Colors.black)  ,
            hintText: "blabla@gmail.com",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        )
      ),
    );
  }
}

