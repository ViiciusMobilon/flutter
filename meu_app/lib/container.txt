import 'package:flutter/material.dart';

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
          body: HomeWidget(),
        ),
    );
    
  }
}
 class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //container tem tudo dentro dele
      child: Container(
        width: 300,
        height: 300,
        color: Colors.blue,
        child: Container(
          width: 50,// filhos erdão o tamanho dos pais
          height: 50,
          color: Colors.red,
        ),
      ),
    );
  }
}