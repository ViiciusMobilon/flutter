import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main()=> runApp(Empresa());

class Empresa extends StatefulWidget {
  const Empresa({super.key});

  @override
  State<Empresa> createState() => _EmpresaState();
}

class _EmpresaState extends State<Empresa> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      
      home: Scaffold(
        appBar: AppBar(
  backgroundColor: const Color(0xFFFEF7FD),
  title: Text("Prestador", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_rounded, color: const Color.fromARGB(255, 0, 0, 0)),
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Empresa(),
      ));
    },
  ),
),
        body: ListView(
                 

        ),
      ),
    );
  }
}