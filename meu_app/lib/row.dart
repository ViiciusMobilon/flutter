import 'package:flutter/material.dart';
import 'package:meu_app/decoration.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget{
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
            color: Colors.amber,

          ),
          
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
            textbutton(),
             
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, //linhas
              children: <Widget>[
                
              Container(width: 50,height:50 , color: Colors.deepPurple),
              Container(width: 50,height: 50, color: Colors.green,)
              ],
             )
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
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Decorationwidget() )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,// se tiver decoration coloque a cor aqui
            borderRadius:  BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[//para todas as caracteristicas do boxshadow
             BoxShadow(
              color: Colors.black,
              offset: Offset(10, 5),//posição 
              blurRadius: 5 //fumaça
             )
            ]
          ),
             width: double.infinity,
             height: 50,
           
            alignment: Alignment.center,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [ 
                Expanded(
                 // flex: 1,
                  child:  Icon(Icons.add, color: Colors.black,),
             ),
            Expanded(
              //flex: 1,// divide em colunas no numero das somas do flex do objeto
              child: Text('ola mundo',textAlign: TextAlign.center, style: TextStyle(color: Colors.amber),) ) // expanded serve para ocupar todo o espaço da row ou collunm
            ]
            ) ,
              ),
      ),
    
        );
    
    
  }
}