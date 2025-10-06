import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_principal/data/config.dart';
import 'package:projeto_principal/data/http/dio_client.dart';
import 'package:projeto_principal/data/models/post.dart';

class PortfolioRepository {
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();


  Future<Portfolio?> getPortfolioUser() async {
    try {
      final token = await _storage.read(key: 'token');
      
      final response = await _dio.post(
        '/portfolio/user',
        options: Options(
          headers: {
          'Authorization': 'Bearer $token',
        },),
      );

      print('Portfolio:: ${response.data}');

      return Portfolio.fromJson(response.data);

    }    catch (e) {
      print('Error fetching portfolio: $e');
      rethrow;
    }
  
  }
}