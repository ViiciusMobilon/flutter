import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_principal/ifeed.dart';
import 'package:intl/intl.dart';
import 'package:projeto_principal/main.dart';

// ignore: camel_case_types
class Feed implements Ifeed {
  final String text;
  final DateTime date;

  Feed({required this.text}) : date = DateTime.now();

  @override
  Widget reader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
     
     
      child: renderContent(),
    );
  }

  @override
  Widget renderBotton() {
    return Column(
    
      children: [
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end ,
          children: [
            
            Text('Enviado em ${DateFormat('dd/MM/yyyy').format(date)}', style: TextStyle(color: Colors.grey),),
          ],
        ),
      ],
    );
  }

  @override
  Widget renderContent() {
    return Column(children:
    
    
     [ Row(
       children: [
        CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage("https://picsum.photos/200"),
),
        SizedBox(width:10,),
        Text("mobilon", style: TextStyle(color: Colors.black,
            fontSize:30,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",
        ),)
       ],
     ),
      
      Row(
         mainAxisAlignment: MainAxisAlignment.start ,
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,maxLines: 3, // máximo de linhas
              overflow: TextOverflow.ellipsis,),
          )),
        
        ],
      ), renderBotton()]);
  }
}
