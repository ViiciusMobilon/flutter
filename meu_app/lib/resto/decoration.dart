import 'package:flutter/material.dart';
import 'package:meu_app/resto/scrollview.dart';

void main() => runApp(Decorationwidget());   

class Decorationwidget extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
         theme:ThemeData(
         ),
         home: Scaffold(
          appBar: AppBar(),
          body: stackwidget(),
            
          
          
         ),
         debugShowCheckedModeBanner: false,
    );
  }
}

class stackwidget extends StatelessWidget {
  const stackwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>scrollviewwidget() )),
          child: Material(
            elevation: 7,//sombra
            borderRadius: BorderRadius.circular(40),
            child: Container(height: 50,
            width: 50,
            color: Colors.blue,),
          ),
        ),
        Stack(// sobrepondo widget
          children:   <Widget>[
           
           Container(height: 400, color: Colors.red),
            Container(height: 300, color: Colors.amber,),
             
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                         child: Text("vm"),),
                   
                 ],
               )
               
                           
             
          ],
        ),
      ],
    );
    }
    }
    