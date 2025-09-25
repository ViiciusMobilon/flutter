import 'dart:convert';
import 'dart:io';

import 'package:projeto_principal/data/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final AuthRepository _authRepository;
  final _storage = const FlutterSecureStorage();
  Map<String, dynamic>? logado;
  Map<String, dynamic>? user;
  Map<String, double>? avaliacao;
  Map<String, dynamic>? ramo;
  String? foto;
  AuthService(this._authRepository);
  Future<bool> cadastro(String email,
      String senha,
      String senha_confirmation,
      String tipo,
      String? nome,
      String? razao_social,
      String tel,
      String? cpf,
      String? cnpj,
      int? id_ramo,
      File foto,
      String cep,
      String rua,
      String cidade,
      String estado,
      String uf,
      String numero,
      String info
      ) async {
        final data = await _authRepository.register(email, senha, senha_confirmation,tipo, nome,razao_social, tel, cpf,cnpj,id_ramo, foto, cep,rua, cidade, estado,uf, numero, info);

       if (data.containsKey("access_token")) {
        await _storage.write(key: "token", value: data['access_token']);
        await _storage.write(key: 'logado', value: jsonEncode(data['logado']));
        await _storage.write(key: 'foto', value: data['foto']);
        user = data['logado'];
        return true;
      } else {
        return false;
      }

  }
  Future<bool> login(String email, String password) async{
    final result = await _authRepository.login(email, password);

    if(result != null && result['access_token'] != null){
      await _storage.write(key: 'token', value: result['access_token']);
      await _storage.write(key: 'logado', value: jsonEncode(result['logado']));
      await _storage.write(key: 'foto', value: result['foto']);
      await _storage.write(key: 'avaliacao', value: jsonEncode(result['avaliacao']));
      await _storage.write(key: 'ramo', value: jsonEncode(result['ramo']));
      await _storage.write(key: 'user', value: jsonEncode(result['user']));
      user = result['user'];
      logado = result['logado'];
      return true;
    }
    return false;
  }

  Future<String?> getToken()async {
    return await _storage.read(key: 'token');
  }

  Future<Map<String, dynamic>?> getUser() async {
    if (user != null) return user;

    final userStr = await _storage.read(key: 'user');
    if (userStr != null) {
      user = jsonDecode(userStr);
      return user;
    }
    return null;
  }
  Future<Map<String, dynamic>?> getLogado() async {
    if (logado != null) return logado;

    final logadoStr = await _storage.read(key: 'logado');
    if (logadoStr != null) {
      user = jsonDecode(logadoStr);
      return logado;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRamo() async {
    final ramoStr = await _storage.read(key: 'ramo');
    if (ramoStr != null) {
      ramo = jsonDecode(ramoStr);
      print("RAMO: ${ramo}");
      return ramo;
    }
    return null;
  }
  Future<Map<String, double>?> getAvaliacao() async{
    final avaliacaoStr = await _storage.read(key: 'avaliacao');
    if(avaliacaoStr != null){
      final Map<String, dynamic> json = jsonDecode(avaliacaoStr);

      avaliacao = {
        'media': double.parse(json['media'].toString()),
        'total': double.parse(json['total'].toString()),
    };
    return avaliacao;
    }
    return null;
}

   Future<String?> getFoto() async {
    if (foto != null) return foto;

    final fotoStr = await _storage.read(key: 'foto');
    if (fotoStr != null && fotoStr.isNotEmpty) {
      foto = fotoStr;
      print("FOTO:${foto}");
      return foto;
    }
    return null;
  }

  Future<void> logout() async{
    return await _storage.delete(key: 'token');
  }

}