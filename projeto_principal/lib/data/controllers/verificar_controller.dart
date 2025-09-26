
import 'package:projeto_principal/data/services/verificar_service.dart';

class VerificarController {
  final VerificarService _service = VerificarService();

  Future<String> verificar(String value, String endpoint) async{
   try {

      final result = await _service.verificar(value, endpoint);
      return result['message'];

   } catch (e) {
     throw Exception(e);
   }
  }


  Future<bool> existe(String value,  String endpoint) async {
    try {
      final resultado = await _service.verificar(value, endpoint);
      return resultado['existe'];
    } catch (e) {
      throw true;
    }
  }
}