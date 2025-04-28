import 'package:flutter/material.dart';

void main() => runApp(Decorationwidget());   

class Decorationwidget extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
         theme:ThemeData(
         ),
         home: Scaffold(
          body: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/fundog.jpg"),
            fit: BoxFit.fill        )),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
                 children: <Widget> [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buttonwidget()
                    ],
                  ),
                  
                 ],
            ),
          ),
         ),
         debugShowCheckedModeBanner: false,
    );
  }
}
class buttonwidget extends StatefulWidget {
  const buttonwidget({super.key});

  @override
  State<buttonwidget> createState() => _buttonwidgetState();
}

class _buttonwidgetState extends State<buttonwidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: 50),
    child: Container(
      decoration: BoxDecoration(
       color: Colors.blue
      ),
      child: Text("mexendo com decoraiton", style: TextStyle(color:Colors.white),textAlign: TextAlign.center,),
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
    ),
    
    );
  }
}