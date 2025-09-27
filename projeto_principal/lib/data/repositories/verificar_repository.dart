import 'dart:convert';
import 'dart:io';
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
        final msg = data['message'][campo][0];

        return {
          'existe': !(data['success'] ?? false),
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