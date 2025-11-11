
import 'package:tcc/data/services/verificar_service.dart';

class VerificarController {
  final VerificarService _service = VerificarService();

  Future<Map<String, dynamic>> verificar(String value, String endpoint) async{
   try {
    print("Valor: ${value}");
      final result = await _service.verificar(value, 'check/$endpoint');
      print("Mensagem: ${result['msg']}");
      print("existe: ${result['existe']}");
      return {
        'existe': result['existe'] ?? false,
        'msg': result['msg'] ?? ''
      };

   } catch (e) {
     throw Exception(e);
   }
  }
}