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

      // print('print map cadastro: ${map['id_categoria']}');

      final response = await _dio.post('/usuario/cadastro', data: formData);
      if(response.statusCode != 200){
        print('Deu errado status code: ${response.statusCode}');
      }
      print('Cadastro response.data: ${response.data} e statuscode: ${response.statusCode}, o formdata ${formData}');
      return UsuarioGeral.fromJson(response.data);

    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro no cadastro.');
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

        // Cria o mapa do form removendo campos nulos ou vazios
        final map = form.toMap()
          ..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

        // Converte skills em formato skills[0], skills[1], ... apenas com IDs inteiros
        if (form.skills != null && form.skills!.isNotEmpty) {
          for (var i = 0; i < form.skills!.length; i++) {
            map['skills[$i]'] = form.skills![i]; // int
          }
        }

        // Constrói FormData incluindo a foto se existir
        FormData formData = FormData.fromMap({
          ...map,
          if (form.foto != null)
            "foto": await MultipartFile.fromFile(
              form.foto!.path,
              filename: form.foto!.path.split('/').last,
            ),
        });

        print('FormData enviado para update: ${formData.fields}');

        final response = await _dio.post(
          '/usuario/update',
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        print('update response.statusCode: ${response.statusCode}');
        print('update response.data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Constrói UsuarioGeral tratando skills corretamente como SkillModelA
          final dataUser = response.data['user'] ?? {};
          final skillsJson = dataUser['skills'] as List<dynamic>? ?? [];

          return UsuarioGeral.fromJson({
            ...response.data,
            'user': {
              ...dataUser,
              'skills': skillsJson,
            },
          });
        } else {
          throw Exception('Erro ao atualizar usuário: ${response.statusCode}');
        }

        } on DioException catch (e) {
        if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Erro no update');
        } else {
        throw Exception('Erro de conexão');
        }
      }
}

  Future<int?> curtirPerfil(int perfilId) async {
  try {
    final token = await _storage.read(key: 'token');
    final response = await _dio.post('/curtidas//curtir/$perfilId', options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      // Retorna o total de perfis curtidos que o usuário logado deu
      return response.data['total de perfis curtidos'] as int?;
    } else {
      print('Erro ao curtir: ${response.data}');
      return null;
    }
  } on DioError catch (e) {
    if (e.response != null) {
      print('Erro da API: ${e.response?.data}');
    } else {
      print('Erro de conexão: $e');
    }
    return null;
  }
  }
  Future<int?> descurtirPerfil(int perfilId) async {
  try {
    final token = await _storage.read(key: 'token');
    final response = await _dio.delete('/usuarios/curtir/$perfilId', options: Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      return response.data['total de perfis curtidos'] as int?;
    }
    return null;
  } on DioError catch (e) {
    print(e.response?.data ?? e);
    return null;
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
