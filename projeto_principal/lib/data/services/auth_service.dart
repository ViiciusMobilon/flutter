import 'dart:io';

import 'package:projeto_principal/data/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final AuthRepository _authRepository;
  final _storage = const FlutterSecureStorage();
  AuthService(this._authRepository);
  /*cadastro contratante*/
  Future<bool> cadastro_Contratante(String email,
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
      String numero,
      String info) async {
        final data = await _authRepository.registerContratante(email, senha, senha_confirmation, nome, tel, cpf, foto, cep,rua, cidade, estado,uf, numero, info);

       if (data.containsKey("token")) {
        await _storage.write(key: "jwt", value: data['token']);
        return true;
      } else {
        return false;
      }

  }
  /*cadastro prestador*/
  Future<bool> cadastro_Prestador(String email,
      String senha,
      String senha_confirmation,
      String nome,
      String tel,
      String? zap,
      String cpf,
      File foto,
      int id_ramo,
      String cep,
      String rua,
      String cidade,
      String estado,
      String uf,
      String numero,
      String info) async {
        final data = await _authRepository.registerPrestador(email, senha, senha_confirmation, nome, tel,zap, cpf, foto,id_ramo, cep,rua, cidade, estado,uf, numero, info);

       if (data.containsKey("token")) {
        await _storage.write(key: "jwt", value: data['token']);
        return true;
      } else {
        return false;
      }

  }
  /*cadastro empresa*/


  Future<bool> cadastro_Empresa(String email,
      String senha,
      String senha_confirmation,
      String nome,
      String tel,
      String? zap,
      String cnpj,
      File foto,
      int id_ramo,
      String cep,
      String rua,
      String cidade,
      String estado,
      String uf,
      String numero,
      String info) async {
        final data = await _authRepository.registerEmpresa(email, senha, senha_confirmation, nome, tel,zap, cnpj, foto,id_ramo, cep,rua, cidade, estado,uf, numero, info);

       if (data.containsKey("token")) {
        await _storage.write(key: "jwt", value: data['token']);
        return true;
      } else {
        return false;
      }

  }
}