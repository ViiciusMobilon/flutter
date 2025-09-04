import 'dart:convert';

import 'package:projeto_principal/data/http/http_client.dart';
import 'package:projeto_principal/data/models/estado.dart';

abstract class IEstadoRepository{
  Future<List<EstadoModel>> getestado();
}

class EstadoRepository implements IEstadoRepository{
  final HttpClient client;

  EstadoRepository({required this.client});

  @override
  Future<List<EstadoModel>> getestado() async {
    final response = await client.get(url: 'http://172.26.144.1:8000/api/estado');

    if (response.statusCode == 200){
      final List body = jsonDecode(response.body);

      return body.map((e) => EstadoModel.fromJson(e)).toList();
    }else{
      throw Exception('erro estado');
    }
  }
}