import 'dart:io';

import 'package:projeto_principal/data/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final AuthRepository _authRepository;
  final _storage = const FlutterSecureStorage();
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
      String info) async {
        final data = await _authRepository.register(email, senha, senha_confirmation,tipo, nome,razao_social, tel, cpf,cnpj,id_ramo, foto, cep,rua, cidade, estado,uf, numero, info);

       if (data.containsKey("token")) {
        await _storage.write(key: "jwt", value: data['token']);
        return true;
      } else {
        return false;
      }

  }
  Future<bool> login(String email, String password) async{
    final result = await _authRepository.login(email, password);

    if(result != null && result['access_token'] != null){
      await _storage.write(key: 'token', value: result['access_token']);
      return true;
    }
    return false;
  }

  Future<String?> getToken()async {
    return await _storage.read(key: 'token');
  }

  Future<void> logout() async{
    return await _storage.delete(key: 'token');
  }

}