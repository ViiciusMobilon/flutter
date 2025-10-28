import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tcc/data/http/dio_client.dart';
import 'package:tcc/data/models/user.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository();
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();


  Future<UsuarioGeral> register(Userform form) async {
    try {
      final map = form.toMap();

      FormData formData = FormData.fromMap({
        ...map,
        if (form.foto != null)
          "foto": await MultipartFile.fromFile(
            form.foto!.path,
            filename: form.foto!.path.split('/').last,
          ),
      });

      print('print map cadastro: ${map['id_categoria']}');

      final response = await _dio.post('/usuario/cadastro', data: formData);
      print('Cadastro response.data: ${response.data}');
      return UsuarioGeral.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro no cadastro');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
  Future<UsuarioGeral> login(String email, String senha) async {
  try {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': senha,
    });
    print('responde repo login: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = response.data;
      print('Login response: ${data}'); // depuração

      // ⚡ Passe o JSON completo
      return UsuarioGeral.fromJson(data);
    } else {
      throw Exception('Erro ao fazer login: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      throw Exception(e.response?.data['message'] ?? 'Erro no login');
    } else {
      throw Exception('Erro de conexão');
    }
  }
}
  

  Future<UsuarioGeral> update(Userform form) async {
    try {
      final token = await _storage.read(key: 'token');
      final map = form.toMap()..removeWhere((key, value) => value == null ||(value is String && value.isEmpty));

      FormData formData = FormData.fromMap({
        ...map,
        if (form.foto != null)
          "foto": await MultipartFile.fromFile(
            form.foto!.path,
            filename: form.foto!.path.split('/').last,
          ),
      });

      print('print map cadastro: ${map['descricao']}');
      print('print formData cadastro: ${formData.fields}');

      final response = await _dio.post('/usuario/update', data: formData, options: Options(
          headers: {
          'Authorization': 'Bearer $token',
        },),);

      
      print('update response.statusCode: ${response.statusCode}');
      print('update response.data: ${response.data}');

      if(response.statusCode ==200 || response.statusCode ==201){
        return UsuarioGeral.fromJson(response.data);
      } else {
        throw Exception('Erro ao atualizar usuário: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro no cadastro');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }
  
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro ao fazer logout');
      } else {
        throw Exception('Erro de conexão');
      }
    }
  }

}
