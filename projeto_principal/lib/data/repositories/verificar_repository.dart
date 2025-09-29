import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_principal/data/config.dart';


class VerificarRepository {

  Future<Map<String, dynamic>> verificar(String value, String endpoint) async{
    try {
      var url = Uri.parse("${URLAPI}/$endpoint").replace(queryParameters: {"valor": value});
      print('URL check:${url}');
      final response = await http.get(url);


      if(response.statusCode == 200 || response.statusCode == 422){
        final data = jsonDecode(response.body);

        final campo = data['message'].keys.first;
        final listamsg = data['message'][campo] as List<dynamic>? ?? [];
        final msg = listamsg.isNotEmpty ? listamsg[0].toString() : '';
        final existe = msg.toString().toLowerCase();


        return {
        'existe': existe,
        'msg': msg,
          };


      }else{
        throw Exception('error no servidor ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}