import 'package:flutter/material.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/data/services/public_user.dart';

class UserPublicController extends ChangeNotifier {
  final PublicUserService _service;

  UserPublicController(this._service);

  UsuarioPublic? _user;
  UsuarioPublic? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  /// Carrega o usuário público da rota /user/{id}
  Future<void> loadUser(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getUserPublic(id);
      _user = result;
    } catch (e) {
      _error = "Erro ao carregar usuário";
      print("UserPublicController error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Caso queira recarregar manualmente (pull-to-refresh)
  Future<void> refresh(int id) async {
    return loadUser(id);
  }
}
