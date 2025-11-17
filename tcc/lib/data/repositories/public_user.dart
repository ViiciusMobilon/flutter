import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc/data/http/dio_client.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';

class PublicUserRepository{
  PublicUserRepository();
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();


  Future<UsuarioPublic> getUserPublic(int id) async {
    final response = await _dio.get('/user/$id/posts');

    if (response.statusCode == 200) {
      return UsuarioPublic.fromJson(response.data['user']);
    } else {
      throw Exception('Erro ao carregar usuário público');
    }
  }

}