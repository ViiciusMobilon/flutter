import 'package:flutter/foundation.dart';

class EstadoModel {
  final int id;
  final String sigla;

  EstadoModel({required this.id, required this.sigla,});

  factory EstadoModel.fromJson(Map<String, dynamic> json){
    return EstadoModel(
      id: json['id'] ?? '',
      sigla: json['sigla']?? '',);
  }
}