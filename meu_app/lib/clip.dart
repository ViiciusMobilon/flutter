import 'package:flutter/material.dart';
import 'package:meu_app/main.dart';
import 'package:meu_app/material.dart';

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
    return ClipPath(
   clipper: ClipHome(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: ListView(
          children: <Widget>[
       GestureDetector(
        onDoubleTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Materialwidget() )),
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
      
      ),
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
class ClipHome  extends CustomClipper<Path>{

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return oldClipper != this;
  }
  
  @override
  Path getClip(Size size) {
    // TODO: implement getClip


     var path =   Path();
     path.lineTo(0.0, 0.0);
     path.lineTo(0.0, size.height);
     path.lineTo(size.width, 0.0);
     path.lineTo(0.0, 0.0);



    return path;
  }

}