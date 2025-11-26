import 'package:tcc/data/models/user_public/userPublic.dart';

class UserResponse {
  final UsuarioPublic user;

  UserResponse({required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: UsuarioPublic.fromJson(json['user']),
    );
  }
}
