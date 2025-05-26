import 'package:flutter/material.dart';

void main() => runApp(Cadastro());
class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        
        body: ListView(
children: [
     Padding(padding: EdgeInsets.only(top:100, left: 100,right: 100),
     child: email(),),
     Padding(padding: EdgeInsets.only())
],

        )

          
        )
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

