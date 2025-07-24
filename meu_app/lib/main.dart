import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meu_app/cadastro.dart';
import 'package:meu_app/resto/row.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Somente retrato normal
    // Você pode adicionar outras se quiser permitir
  ]).then((_) {
    runApp(Homepage());
  });
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTTER DEMO',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/fundo1.jpeg"), //fundo da imagem
              fit: BoxFit.cover,
            ),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                 
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 60 , top: 100),
                child: Container(
                  width:
                      MediaQuery.of(context).size.width *
                      0.7, // 70% da largura da tela
                  height:
                      MediaQuery.of(context).size.height *
                      0.3, // 30% da altura da tela
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/LOGO.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Container(
                  //inicio do texto
                  child: Text(
                    "ola mundo",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 84, 0, 194),
                      fontSize:25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              //fim de texto
              SizedBox(height: MediaQuery.of(context).size.height * 0.22, ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: escolhas(),
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class textbutton extends StatefulWidget {
  const textbutton({super.key});

  @override
  State<textbutton> createState() => _textbuttonState();
}

class _textbuttonState extends State<textbutton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => Cadastro())),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue, // se tiver decoration coloque a cor aqui
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width * 0.47,
          height: MediaQuery.of(context).size.height * 0.09,

          alignment: Alignment.center,
          child: Text(
            "Ola mundo",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
        ),
      ),
    );
  }
}

class escolhas extends StatefulWidget {
  const escolhas({super.key});

  @override
  State<escolhas> createState() => _escolhasState();
}

class _escolhasState extends State<escolhas> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Container( 
        height: MediaQuery.of(context).size.height*0.08,
        width:MediaQuery.of(context).size.width*0.49 ,
       decoration: BoxDecoration( color: const Color(0xFF5E5CE6) ,
       borderRadius: BorderRadius.only(topRight: Radius.circular(40))),
       child:Center(
        child: Text("login", style: TextStyle(color: Colors.white),),
       ) ,
      ),
      
      Container( 
        height: MediaQuery.of(context).size.height*0.08,
        width:MediaQuery.of(context).size.width*0.49 ,
       decoration: BoxDecoration( color: const Color(0xFF7A70FF) ,
       borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
       child:Center(
        child: Text("cadastro", style: TextStyle(color: Colors.white),),
        )
       ) ,
    ],);
  }
}
