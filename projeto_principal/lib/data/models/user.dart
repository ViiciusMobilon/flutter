import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum TipoUsuario { prestador, contratante, empresa }

class UsuarioGeral {
  String? nome;
  String? razao_social;
  String? email;
  String? password;
  String? confirmation_password;
  String? cpf;
  String? cnpj;
  String? telefone;
  File? foto;
  // XFile? foto;
  String? cep;
  String? cidade;
  String? uf;
  String? estado;
  String? rua;
  String? numero;
  String? infoadd;
  int? ramo;
  String? tipo;

  UsuarioGeral({this.nome, this.email, this.password, 
    this.confirmation_password, this.cpf, this.cnpj,
    this.telefone, 
    this.foto, this.cep, this.cidade, this.estado,this.uf, this.rua, this.numero, this.infoadd,
    this.ramo, this.tipo
  });

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "razao_social": razao_social ?? "",
      "email": email,
      "password": password,
      "confirmation_password": confirmation_password,
      "cpf": cpf ?? "",
      "cnpj": cnpj ?? "",
      "telefone": telefone ?? "",
      "foto": foto ?? "",
      "cep": cep ?? "",
      "cidade": cidade ?? "",
      "estado": estado ?? "",
      "uf": uf ?? "",
      "rua": rua ?? "",
      "numero": numero ?? "",
      "infoadd": infoadd ?? "",
      "ramo": ramo ?? "",
      "tipo": tipo ?? "", // "prestador" ou "contratante"
    };
  }
}
