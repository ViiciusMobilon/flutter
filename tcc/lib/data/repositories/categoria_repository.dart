import 'package:dio/dio.dart';
import '../config.dart';
import '../models/Categoria.dart';

abstract class ICategoriaRepository {
  Future<List<CategoriaModel>> getCategoria();
}

class CategoriaRepository implements ICategoriaRepository {
  final Dio client;

  CategoriaRepository({required this.client});

  @override
  Future<List<CategoriaModel>> getCategoria() async {
    try {
      final response = await client.get('$URLAPI/categoria');

      // Dio já retorna List/Map em response.data
      final List body = response.data;

      return body.map((e) => CategoriaModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro na API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
}