import 'package:tcc/data/repositories/verificar_repository.dart';

class VerificarService {

  final VerificarRepository _verificarRepository = VerificarRepository();

  Future<Map<String, dynamic>> verificar(String value, String endpoint) async{
    return _verificarRepository.verificar(value, endpoint);
  }
}