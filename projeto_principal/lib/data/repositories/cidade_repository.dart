import 'dart:convert';

import 'package:projeto_principal/data/http/http_client.dart';
import 'package:projeto_principal/data/models/cidade.dart';

abstract class ICidadeRepository{
  Future<List<CidadeModel>> getcidade();
}

class CidadeRepository implements ICidadeRepository{

  final IHttpClient client;

  CidadeRepository({required this.client});

  @override
  Future<List<CidadeModel>> getcidade() async{
    final response = await client.get(url: 'http://172.26.144.1:8000/api/cidade');


    if(response.statusCode == 200){
      final List body = jsonDecode(response.body);

      return body.map((e) => CidadeModel.fromJson(e)).toList();
    }else{
      throw Exception('deu errado cidade');
    }
  }
}