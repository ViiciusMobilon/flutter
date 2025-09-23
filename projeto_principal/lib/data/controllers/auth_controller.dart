import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:projeto_principal/data/services/auth_service.dart';

class AuthController extends ChangeNotifier{
  final AuthService _authService;

  bool isLoading = false;
  String? errors;

  AuthController(this._authService);
/**contratante */
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
        try {
          isLoading = true;
          errors = null;
          notifyListeners();

          final sucess = await _authService.cadastro(email, senha, senha_confirmation,tipo, nome,razao_social, tel, cpf,cnpj,id_ramo, foto, cep,rua, cidade, estado,uf, numero, info);

          if(!sucess){
            errors = "erro cadastro";
          }
          return sucess;
        } catch (e) {
          errors = e.toString();
          return false;
        } finally{
          isLoading = false;
          notifyListeners();
        }
  }

  Future<bool> login(String email, String password) async{
    print('email:${email}');
    print('senha:${password}');
    
    final user = await _authService.login(email, password);


    if (user) {
      print("Login bem-sucedido: ${user}");
      return true;
    } else {
      print("Login inválido");
      return false;
    }

  }

  Future<void> logout() async{
    return await _authService.logout();
  }

  Future<bool> logado() async{
    final token = await _authService.getToken();
    return token != null;
  }
  Future<Map<String, dynamic>?> getUser() async {
    return await _authService.getUser();
  }
  Future<String?> getFoto() async {
    return await _authService.getFoto();
  }
  Future<Map<String, double>?> getAvaliacao() async{
    return await _authService.getAvaliacao();
  }

  Future<Map<String, double>?> get avaliacao => _authService.getAvaliacao();
  Map<String, dynamic>? get user => _authService.user;
  String? get foto => _authService.foto;

}