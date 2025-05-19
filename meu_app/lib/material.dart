import 'package:flutter/material.dart';

main() => runApp(Materialwidget());

class Materialwidget extends StatelessWidget {
  void _onFabPressed() {
    print("FAB pressionado!");
  }
  const Materialwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home:Scaffold
      ( appBar: AppBar(
        title: Text('Exemplo FAB'),
      ),
      body: Center(
        child: Text('Conteúdo da tela'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed ,
        tooltip: 'Adicionar',
        child: Text("ola mundo")
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label:"home"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "abc")
      ],)
      ,
         ), 
    );
  }
}