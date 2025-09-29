
import 'package:projeto_principal/data/services/verificar_service.dart';

class VerificarController {
  final VerificarService _service = VerificarService();

  Future<Map<String, dynamic>> verificar(String value, String endpoint) async{
   try {
    print("telefone: ${value}");
      final result = await _service.verificar(value, endpoint);
      print("Mensagem: ${result['msg']}");
      return {
        'existe': result['existe'] ?? false,
        'msg': result['msg'] ?? ''
      };

   } catch (e) {
     throw Exception(e);
   }
  }
}