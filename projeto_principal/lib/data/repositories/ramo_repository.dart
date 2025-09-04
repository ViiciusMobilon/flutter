import 'dart:convert';

import 'package:projeto_principal/data/models/ramo.dart';
import 'package:projeto_principal/data/http/http_client.dart';

abstract class IRamoRepository{
  Future<List<RamoModel>> getRamo();
}

class RamoRepository implements IRamoRepository{

  final IHttpClient client;

  RamoRepository({required this.client});

  @override
  Future<List<RamoModel>> getRamo() async {

    final response = await client.get(url: 'http://192.168.1.8:8000/api/ramo');

    if(response.statusCode == 200){
        final List body = jsonDecode(response.body);

        return body.map((e)=> RamoModel.fromJson(e)).toList();
      }else{
        throw Exception('erro ramo');
        }
  }
}