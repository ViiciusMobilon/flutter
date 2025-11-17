import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc/data/http/dio_client.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';

class PublicUserRepository{
  PublicUserRepository();
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();


  Future<UsuarioPublic> getUserPublic(int id) async {

    final token = await _storage.read(key: 'token');
    final response = await _dio.get('/usuario/$id/posts', options: Options(
        headers: {
        'Authorization': 'Bearer $token',
        },),);

    if (response.statusCode == 200) {
      print("response.data userpublicrepo: ${response.data['user']}");
      return UsuarioPublic.fromJson(response.data['user']);
    } else {
      throw Exception('Erro ao carregar usuário público');
    }
  }

}