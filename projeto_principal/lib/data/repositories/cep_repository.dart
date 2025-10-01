import 'package:dio/dio.dart';
import '../models/cep.dart';

abstract class ICepRepository {
  Future<CepModel> getCep(String cep);
}

class CepRepository implements ICepRepository {
  final Dio client;

  CepRepository({required this.client});

  @override
  Future<CepModel> getCep(String cep) async {
    try {
      final response = await client.get('https://viacep.com.br/ws/$cep/json/');

      return CepModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro na API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
}
