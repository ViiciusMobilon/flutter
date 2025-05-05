import 'package:flutter/material.dart';
import 'package:meu_app/row.dart';

void main () => runApp(Homepage());

class Homepage extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FLUTTER DEMO',
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        home:Scaffold(
         body: Container(
           
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/image/fundo1.jpeg"),//fundo da imagem
            fit: BoxFit.cover
            ) 
          ),
          
          child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
            Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/fundo1.jpeg"),
               fit: BoxFit.cover)
              
              ),
            ),
           
             Container(
 width: MediaQuery.of(context).size.width * 0.7, // 70% da largura da tela
  height: MediaQuery.of(context).size.height * 0.3, // 30% da altura da tela
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/image/LOGO.png"),
      fit: BoxFit.contain
    )
  ),
  
), 
Container(
            child: Text("ola mundo" , style: TextStyle(color: Colors.white),),
           ),
             SizedBox(height: 20,),
             textbutton(),
              
           ]
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
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp() )),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,// se tiver decoration coloque a cor aqui
              borderRadius:  BorderRadius.circular(10.0),
              
             
            ),
               width: 150,
               height: 50,
             
              alignment: Alignment.center,
              child: Text("Ola mundo" ,style: TextStyle(color: Colors.white
                ),
              ),
            ),
        ),
      );
    
  }
}
