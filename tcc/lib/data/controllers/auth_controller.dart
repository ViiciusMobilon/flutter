

// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:tcc/data/models/user.dart';
import 'package:tcc/data/models/userForm.dart';
import 'package:tcc/data/services/auth_service.dart';

class AuthController extends ChangeNotifier{
  final AuthService _authService;

  
  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  UsuarioGeral? _usuario;
  UsuarioGeral? get usuario => _usuario;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  void setUsuario(UsuarioGeral user) {
    _usuario = user;
    notifyListeners();
  }

  AuthController(this._authService);

  Future<UsuarioGeral> cadastro(Userform form) async {
    try {
      print("Cadastro controller: $form");
      final usuario = await _authService.register(form);
      setUsuario(usuario);  // salva no controller
      return usuario;   
    } catch (e) {
      print('erro cadastro controller');
      rethrow;
    }      // retorna para a tela
  }

  Future<UsuarioGeral> update(Userform form) async {

    try {
      print("update controller: $form");
      final usuario = await _authService.update(form);
      setUsuario(usuario);  // salva no controller
      return usuario;
    } catch (e) {
      print("Erro no update controller: $e e o user:${form}");
      rethrow;
    }      // retorna para a tela
  }


  Future<UsuarioGeral?> login(String email, String password) async {
    try {
      final usuario = await _authService.login(email, password);
      print("Usuario Login controller:${usuario}");
      _usuario = usuario; // salva no Controller
      return usuario;     // retorna para a tela
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  Future<void> logout() async{
    await _authService.logout();
    // ignore: null_check_always_fails
    setUsuario(null!);
  }

  Future<bool> logado() async{
    final token = await _authService.getToken();
    return token != null;
  }
  Future<Map<String, dynamic>?> getUser() async {
    return await _authService.getUser();
  }
  Future<Map<String, dynamic>?> getLogado() async {
    return await _authService.getLogado();
  }
  Future<String?> getFoto() async {
    return await _authService.getFoto();
  }
  Future<Map<String, double>?> getAvaliacao() async{
    return await _authService.getAvaliacao();
  }
  Future<Map<String, dynamic>?> getRamo() async{
    return await _authService.getRamo();
  }

  Future<Map<String, double>?> get avaliacao => _authService.getAvaliacao();
  Map<String, dynamic>? get user => _authService.user;
  Map<String, dynamic>? get conectado => _authService.logado;
  Map<String, dynamic>? get ramo => _authService.ramo;
  String? get foto => _authService.foto;

}