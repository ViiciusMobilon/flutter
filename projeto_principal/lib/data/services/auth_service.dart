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
      String nome,
      String tel,
      String cpf,
      File foto,
      String cep,
      String rua,
      String cidade,
      String estado,
      String uf,
      String num,
      String info) async {
        final data = await _authRepository.registerContratante(email, senha, senha_confirmation, nome, tel, cpf, foto, cep,rua, cidade, estado,uf, num, info);

       if (data.containsKey("token")) {
        await _storage.write(key: "jwt", value: data['token']);
        return true;
      } else {
        return false;
      }

  }
}