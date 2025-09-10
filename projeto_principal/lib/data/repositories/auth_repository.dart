import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projeto_principal/data/config.dart';

class AuthRepository {
  AuthRepository();

  Future register(
    String email,
    String senha,
    String senha_confirmation,
    String tipo,
    String? nome,
    String? razao_social,
    String tel,
    String? cpf,
    String? cnpj,
    int? id_ramo,
    File foto,
    String cep,
    String rua,
    String cidade,
    String estado,
    String uf,
    String numero,
    String? info,
  ) async {
    var uri = Uri.parse("${URLAPI}/usuario/cadastro");

    // Cria requisição multipart
    var request = http.MultipartRequest('POST', uri);

    // Campos do formulário
    request.fields['email'] = email!;
    request.fields['password'] = senha;
    request.fields['password_confirmation'] = senha_confirmation;
    request.fields['type'] = tipo;
    if(nome != null){
    request.fields['nome'] = nome;
    }
    if (tipo == 'empresa') {
    request.fields['cnpj'] = cnpj ?? '';
    request.fields['razao_social'] = razao_social ?? '';
    request.fields['id_ramo'] = id_ramo.toString();
  }
    request.fields['telefone'] = tel;
    request.fields['whatsapp'] = tel;
    request.fields['fixo'] = tel;
    if(cpf != null){
      request.fields['cpf'] = cpf;
    }
    request.fields['cep'] = cep;
    request.fields['rua'] = rua;
    request.fields['localidade'] = cidade;
    request.fields['estado'] = estado;
    request.fields['uf'] = uf;
    request.fields['numero'] = numero;
    if(info != null){
      request.fields['infoadd'] = info;
    }
    if (tipo != 'contratante' && id_ramo != null) {
      request.fields['id_ramo'] = id_ramo.toString();
    }

    if (cnpj != null) {
    request.fields['cnpj'] = cnpj;
    }

    // Arquivo da foto
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

    // Envia a requisição
    var streamedResponse = await request.send();

    // Converte para Response para ler o body
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body) as Map<String, dynamic>;;
  }
  Future<Map<String, dynamic>?> login(String email,String password) async{
    var url = Uri.parse("${URLAPI}/login");

    final response = await http.post(
      url,
      headers:  {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if(response.statusCode == 200){
      print(response.body);
      return jsonDecode(response.body);
    }else{
      return null;
    }
    
  }

}
