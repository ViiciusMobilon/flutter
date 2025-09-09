import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:projeto_principal/data/services/auth_service.dart';

class AuthController extends ChangeNotifier{
  final AuthService _authService;

  bool isLoading = false;
  String? errors;

  AuthController(this._authService);
/**contratante */
  Future<void> cadastroContratante(String email,
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
        try {
          isLoading = true;
          errors = null;
          notifyListeners();

          final sucess = await _authService.cadastro_Contratante(email, senha, senha_confirmation, nome, tel, cpf, foto, cep,rua, cidade, estado,uf, numero, info);

          if(!sucess){
            errors = "erro cadastro";
          }
        } catch (e) {
          errors = e.toString();
        } finally{
          isLoading = false;
          notifyListeners();
        }
  }
  /**prestador */
  Future<void> cadastroPrestador(String email,
      String senha,
      String senha_confirmation,
      String nome,
      String tel,
      String cpf,
      String? zap,
      File foto,
      int id_ramo,
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

          final sucess = await _authService.cadastro_Prestador(email, senha, senha_confirmation, nome, tel,zap, cpf, foto,id_ramo, cep,rua, cidade, estado,uf, numero, info);

          if(!sucess){
            errors = "erro cadastro";
          }
        } catch (e) {
          errors = e.toString();
        } finally{
          isLoading = false;
          notifyListeners();
        }
  }



  /**empresa */

  Future<void> cadastroEmpresa(String email,
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
        try {
          isLoading = true;
          errors = null;
          notifyListeners();

          final sucess = await _authService.cadastro_Empresa(email, senha, senha_confirmation, nome, tel,zap, cnpj, foto,id_ramo, cep,rua, cidade, estado,uf, numero, info);

          if(!sucess){
            errors = "erro cadastro";
          }
        } catch (e) {
          errors = e.toString();
        } finally{
          isLoading = false;
          notifyListeners();
        }
  }
}