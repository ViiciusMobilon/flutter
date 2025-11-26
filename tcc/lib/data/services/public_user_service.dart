import 'package:tcc/data/models/user_public/userPublic.dart';
import 'package:tcc/data/repositories/public_user_repository.dart';

class PublicUserService {
  final PublicUserRepository _repository = PublicUserRepository();

  Future<UsuarioPublic> getUserPublic(int id) {
    try {
      print("userpublic service: ${_repository.getUserPublic(id).toString()}");
      return _repository.getUserPublic(id);
      
    } catch (e) {
      print("erro service public user: $e");
      rethrow;
    }    
  }
}