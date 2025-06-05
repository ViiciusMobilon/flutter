import 'package:flutter/material.dart';
import 'package:meu_app/cadastro.dart';
import 'package:meu_app/contratante.dart';
import 'package:meu_app/empresa.dart';
import 'package:meu_app/prestador.dart';

void main()=> runApp(Escolha_registro());
class Escolha_registro extends StatelessWidget {
 Escolha_registro({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        //  title: Text("Quem é você?",textAlign: TextAlign.center, style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),),
          backgroundColor: const Color(0xFFFEF7FD) ,
        ),
        body: 
           Center(
            child: Column(

              children: <Widget>[
                  //imagem
                  
   
        Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.001,)),
    Container(
    width: MediaQuery.of(context).size.width * 0.7, // 70% da largura da tela
    height: MediaQuery.of(context).size.height * 0.3, // 30% da altura da tela
    decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/image/LOGO.png"),
      fit: BoxFit.contain))),
 
    Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.009, 
     left: MediaQuery.of(context).size.width*0.21, 
     bottom:MediaQuery.of(context).size.width*0.009,
     right:MediaQuery.of(context).size.width*0.21  ),
     child: Text("Quem é você?", style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.05 ),),),
//fim da imagem
//empresa
      Padding(padding: EdgeInsets.only(
        top:MediaQuery.of(context).size.width*0.1),
        child: SizedBox(
          height:MediaQuery.of(context).size.height*0.15 ,
          width: MediaQuery.of(context).size.width*0.8,
          child: button_empresa(),
        ) 
        ),          
         //fim button_empresa               
             Padding(padding: EdgeInsets.only(
        top:MediaQuery.of(context).size.width*0.01),
        child: SizedBox(
          height:MediaQuery.of(context).size.height*0.15 ,
          width: MediaQuery.of(context).size.width*0.8,
          child: button_prestador(),
        ),
        ),      

        Padding(padding: EdgeInsets.only(
        top:MediaQuery.of(context).size.width*0.01),
        child: SizedBox(
           height:MediaQuery.of(context).size.height*0.15 ,
          width: MediaQuery.of(context).size.width*0.8,
          child: _button_contratante(),
        ),
        ),      
              ],
            ),
          ),
       ),
      );
  
}
}
class button_empresa extends StatefulWidget {
  const button_empresa({super.key});

  @override
  State<button_empresa> createState() => _button_empresaState();
}

class _button_empresaState extends State<button_empresa> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Empresa(),)),
      child: Container(
        
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color.fromRGBO(15, 40, 89, 1.0),
        ),
        child: Center(
          child: Text("Empresa", textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width * 0.06,),
          ),
        ),
      ),
    );
  }
}
class button_prestador extends StatefulWidget {
  const button_prestador({super.key});

  @override
  State<button_prestador> createState() => _button_prestadorState();
}

class _button_prestadorState extends State<button_prestador> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Prestador(),)),
      child: Container(
        
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.5,
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 40, 89, 1.0),
        ),
        child: Center(
          child: Text("Prestador", textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width * 0.06,),),
        ),
      ),
    );
  }
}
class _button_contratante extends StatefulWidget {
  const _button_contratante({super.key});

  @override
  State<_button_contratante> createState() => __button_contratanState();
}

class __button_contratanState extends State<_button_contratante> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Contratante(),)),
      child: Container(
        
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.5,
        decoration: BoxDecoration(
          color: Color.fromRGBO(15, 40, 89, 1.0),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        child: Center(
          child: Text("Contrante", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.06,),),
        ),
      ),
    );
  }
}