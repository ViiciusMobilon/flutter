import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projeto_principal/data/config.dart';

class AuthRepository {
  AuthRepository();
/*contratante*/
  Future registerContratante(
    String email,
    String senha,
    String senha_confirmation,
    String nome,
    String tel,
    String cpf,
    File foto,
    String cep,
    String rua,
    String cidade,
    String estado,
    String uf,
    String numero,
    String info
  ) async {
    var uri = Uri.parse("${URLAPI}/contratante/cadastro");

    // Cria requisição multipart
    var request = http.MultipartRequest('POST', uri);

    // Campos do formulário
    request.fields['email'] = email;
    request.fields['password'] = senha;
    request.fields['password_confirmation'] = senha_confirmation;
    request.fields['nome'] = nome;
    request.fields['telefone'] = tel;
    request.fields['cpf'] = cpf;
    request.fields['cep'] = cep;
    request.fields['rua'] = rua;
    request.fields['localidade'] = cidade;
    request.fields['estado'] = estado;
    request.fields['uf'] = uf;
    request.fields['numero'] = numero;
    request.fields['infoadd'] = info;

    // Arquivo da foto
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

    // Envia a requisição
    var streamedResponse = await request.send();

    // Converte para Response para ler o body
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body) as Map<String, dynamic>;;
  }



  /**prestador */
  Future registerPrestador(
    String email,
    String senha,
    String senha_confirmation,
    String nome,
    String tel,
    String? zap,
    String cpf,
    File foto,
    int id_ramo,
    String cep,
    String rua,
    String cidade,
    String estado,
    String uf,
    String numero,
    String info
  ) async {
    var uri = Uri.parse("${URLAPI}/prestador/cadastro");

    // Cria requisição multipart
    var request = http.MultipartRequest('POST', uri);

    // Campos do formulário
    request.fields['email'] = email;
    request.fields['password'] = senha;
    request.fields['password_confirmation'] = senha_confirmation;
    request.fields['nome'] = nome;
    request.fields['fixo'] = tel;
    request.fields['whatsapp'] = zap!;
    request.fields['cpf'] = cpf;
    request.fields['id_ramo'] = id_ramo.toString();
    request.fields['cep'] = cep;
    request.fields['rua'] = rua;
    request.fields['localidade'] = cidade;
    request.fields['estado'] = estado;
    request.fields['uf'] = uf;
    request.fields['numero'] = numero;
    request.fields['infoadd'] = info;

    // Arquivo da foto
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

    // Envia a requisição
    var streamedResponse = await request.send();

    // Converte para Response para ler o body
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }


  /**empresa */

  Future registerEmpresa(
    String email,
    String senha,
    String senha_confirmation,
    String nome,
    String tel,
    String? zap,
    String cnpj,
    File foto,
    int id_ramo,
    String cep,
    String rua,
    String cidade,
    String estado,
    String uf,
    String numero,
    String info
  ) async {
    var uri = Uri.parse("${URLAPI}/empresa/cadastro");

    // Cria requisição multipart
    var request = http.MultipartRequest('POST', uri);

    // Campos do formulário
    request.fields['email'] = email;
    request.fields['password'] = senha;
    request.fields['password_confirmation'] = senha_confirmation;
    request.fields['nome'] = nome;
    request.fields['fixo'] = tel;
    request.fields['whatsapp'] = zap!;
    request.fields['cnpj'] = cnpj;
    request.fields['id_ramo'] = id_ramo.toString();
    request.fields['cep'] = cep;
    request.fields['rua'] = rua;
    request.fields['localidade'] = cidade;
    request.fields['estado'] = estado;
    request.fields['uf'] = uf;
    request.fields['numero'] = numero;
    request.fields['infoadd'] = info;

    // Arquivo da foto
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

    // Envia a requisição
    var streamedResponse = await request.send();

    // Converte para Response para ler o body
    var response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
