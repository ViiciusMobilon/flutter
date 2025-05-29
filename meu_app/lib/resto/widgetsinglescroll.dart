
import 'package:flutter/material.dart';
import 'package:meu_app/resto/clip.dart';

void main() => runApp(Funcaosingle());

class Funcaosingle extends StatelessWidget {
  const Funcaosingle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: singlescrollwidget(),
      ),
    );
  }
}
class singlescrollwidget extends StatelessWidget {
  const singlescrollwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Clipwidget() )),
                child: Container(height: 200, width: 300, color: Colors.deepPurple,))),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 200, width: 300, color: Colors.deepPurple,)),
              
          ],
        ),
      ),
    );
  }
}