import 'package:flutter/material.dart';

void main() => runApp(Decorationwidget());   

class Decorationwidget extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
         theme:ThemeData(
         ),
         home: Scaffold(
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
    return Stack(// sobrepondo widget
      children:   <Widget>[
        Container(height: 400, color: Colors.red),
        Container(height: 300, color: Colors.amber,),
        
      ],
    );
    }
    }