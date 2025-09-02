import 'dart:convert';

import 'package:projeto_principal/data/http/http_client.dart';
import 'package:projeto_principal/data/models/cep.dart';

abstract class ICepRepository{
  Future<CepModel> getCep(String cep);
}

class CepRepository implements ICepRepository{
  final IHttpClient client;

  CepRepository({required this.client});

  @override
  Future<CepModel> getCep(String cep) async {
    final response = await client.get(url: 'https://viacep.com.br/ws/$cep/json/');

    if (response.statusCode == 200) {
      // final List<CepModel> ceps = [];

      final body = jsonDecode(response.body);

      return CepModel.fromJson(body);
    }else{
      throw Exception('Erro ao buscra cep');
    }
  }

}