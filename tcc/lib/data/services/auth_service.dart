import 'dart:convert';
import 'dart:io';

import 'package:tcc/data/models/user.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();

  final _storage = const FlutterSecureStorage();

  Map<String, dynamic>? logado;
  Map<String, dynamic>? user;
  Map<String, double>? avaliacao;
  Map<String, dynamic>? ramo;
  String? foto;
  Future<UsuarioGeral> register(Userform form) async {
    try {
      final user = await _repository.register(form);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
      // salvar foto separada
      if (user.fotoURL != null && user.fotoURL!.isNotEmpty) {
        await _storage.write(key: 'foto', value: user.fotoURL);
      }
      print("Usuario cadastrado service: ${user.toJson()}");
      return user;
    } catch (e) {
      print("Erro no cadastro service: $e e o user:${form}");
      rethrow;
    }
  }

  Future<UsuarioGeral> login(String email, String senha) async {
    try {
      UsuarioGeral user = await _repository.login(email, senha);
      // salvar o token localmente
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
      // salvar foto separada
      if (user.fotoURL != null && user.fotoURL!.isNotEmpty) {
      await _storage.write(key: 'foto', value: user.fotoURL);
    }
      print("Usuario Login service:${user}");
      return user;
    } catch (e) {
      rethrow;
    }
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
      print("RAMO getramo: ${ramo}");
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