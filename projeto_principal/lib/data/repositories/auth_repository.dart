import 'dart:io';
import 'package:dio/dio.dart';
import 'package:projeto_principal/data/http/dio_client.dart';
import 'package:projeto_principal/data/models/user.dart';

class AuthRepository {
  AuthRepository();
  final Dio _dio = DioClient.dio;

  Future<UsuarioGeral> register(
    {required String email,
    required String senha,
    required String senha_confirmation,
    required String tipo,
    String? nome,
    String? razao_social,
    required String tel,
    String? cpf,
    String? cnpj,
    int? id_ramo,
    required foto,
    required String cep,
    required String rua,
    required String cidade,
    required String estado,
    required String uf,
    required String numero,
    String? info,}
  ) async {
     try {
      FormData formData = FormData.fromMap({
        "email": email,
        "password": senha,
        "password_confirmation": senha_confirmation,
        "type": tipo,
        if (nome != null) "nome": nome,
        if (tipo == 'empresa') ...{
          "cnpj": cnpj ?? '',
          "razao_social": razao_social ?? '',
          "id_ramo": id_ramo?.toString(),
        },
        "telefone": tel,
        if (cpf != null) "cpf": cpf,
        "cep": cep,
        "rua": rua,
        "localidade": cidade,
        "estado": estado,
        "uf": uf,
        "numero": numero,
        if (info != null) "infoadd": info,
        "foto": await MultipartFile.fromFile(foto.path, filename: foto.path.split('/').last),
      });

      final response = await _dio.post('/usuario/cadastro', data: formData);

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

    if (response.statusCode == 200) {
      final data = response.data;
      print('Login response: $data'); // depuração

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
