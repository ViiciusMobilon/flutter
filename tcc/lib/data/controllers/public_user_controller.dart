import 'package:flutter/material.dart';
import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/data/services/public_user_service.dart';

class UserPublicController extends ChangeNotifier {
  final PublicUserService _service;

  UserPublicController(this._service);

  UsuarioPublic? user;
  String? error;
  bool loading = false;

  Future<void> loadUser({required int id}) async {
    loading = true;
    error = null;

    try {
      final result = await _service.getUserPublic(id);
      user = result;
    } catch (e) {
      error = "Erro ao carregar usuário";
    } finally {
      loading = false;
      notifyListeners();

    }
  }
}
