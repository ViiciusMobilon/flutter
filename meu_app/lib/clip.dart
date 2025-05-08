import 'package:flutter/material.dart';
import 'package:meu_app/main.dart';

void main() => runApp(Clipwidget());

class Clipwidget extends StatelessWidget {
  const Clipwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: Container(
      child: widgetglip()
               
            
            
          
        )
      ),
    );
  }
}
class widgetglip extends StatefulWidget {
  const widgetglip({super.key});

  @override
  State<widgetglip> createState() => _widgetglipState();
}

class _widgetglipState extends State<widgetglip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: <Widget>[
     GestureDetector(
      onDoubleTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Homepage() )),
       child: Container(
            
            alignment: Alignment.center,
            child: ClipOval( //corta a borda ovalmente
              child: Image.network("https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png",
          
                fit: BoxFit.cover,
              )
            ),
          ),
     ),
        reacwidget(),
        reacwidget(),
        reacwidget(),
        reacwidget(),
        reacwidget(),

        
      ]),

    );
  }
}
class reacwidget extends StatelessWidget {
  const reacwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Container(
       
        alignment: Alignment.center,
        child:ClipRRect( //serve para diser o nivel do corte da borda
        borderRadius: BorderRadius.circular(40),
          child: Image.network("https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png",

            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }
}