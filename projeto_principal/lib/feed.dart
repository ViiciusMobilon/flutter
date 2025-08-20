import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_principal/ifeed.dart';
import 'package:intl/intl.dart';
// ignore: camel_case_types
class Feed implements Ifeed {
  
  final String text;
  final DateTime date;
  
  Feed({required this.text}) : date = DateTime.now()

  @override
  Widget reader() {
   
    return Card(
      semanticContainer: true,
      clipBehavior:  Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      child: renderContent(),
    );
  }

  @override
  Widget renderBotton() {
   return Column(
    children: [
      SizedBox(height:5 ,),
      Text('Enviado em ${DateFormat('dd/MM/yyyy').format(date)}')
    ],
   )
  }

  @override
  Widget renderContent() {
    return Column(
      children: [
        Text(text),

        renderBotton()
      ],
    );
  }
}
