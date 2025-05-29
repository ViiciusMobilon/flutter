import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meu_app/resto/widgetsinglescroll.dart';

void main() => runApp(scrollviewwidget());

class scrollviewwidget extends StatelessWidget {
  const scrollviewwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(appBar: AppBar(), body: //MyWidget(),
      MyWidget()
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        children: <Widget>[
          
          ListTile(
            leading: Icon(Icons.abc_outlined),
            title: Text("data"),),
         Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Funcaosingle())),
              child: Container(height: 200, width: 200, color: Colors.blue)),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 200, width: 200, color: Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 200, width: 200, color: Colors.blue),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 200, width: 200, color: Colors.blue),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 200, width: 200, color: Colors.blue),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(height: 200, width: 200, color: Colors.blue),
          ),
       ],
      ),
    );
  }
}
  
