import 'package:dio/dio.dart';
import '../config.dart';
import '../models/ramo.dart';

abstract class IRamoRepository {
  Future<List<RamoModel>> getRamo();
}

class RamoRepository implements IRamoRepository {
  final Dio client;

  RamoRepository({required this.client});

  @override
  Future<List<RamoModel>> getRamo() async {
    try {
      final response = await client.get('$URLAPI/ramo');

      // Dio já retorna List/Map em response.data
      final List body = response.data;

      return body.map((e) => RamoModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro na API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
}
