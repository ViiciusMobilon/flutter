import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum TipoUsuario { prestador, contratante, empresa }

class UsuarioGeral {
  String? nome;
  String? email;
  String? password;
  String? confirmation_password;
  String? cpf;
  String? cnpj;
  String? telefone;
  String? whatsapp;
  File? foto;
  // XFile? foto;
  String? cep;
  int? cidade;
  String? rua;
  String? numero;
  String? infoadd;
  String? ramo;
  TipoUsuario? tipo;

  UsuarioGeral({this.nome, this.email, this.password, 
    this.confirmation_password, this.cpf, this.cnpj,
    this.telefone, this.whatsapp, 
    this.foto, this.cep, this.cidade, 
    this.ramo, this.tipo
  });

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "email": email,
      "password": password,
      "confirmation_password": confirmation_password,
      "cpf": cpf ?? "",
      "cnpj": cnpj ?? "",
      "telefone": telefone ?? "",
      "whatsapp": whatsapp ?? "",
      "foto": foto ?? "",
      "cep": cep ?? "",
      "cidade": cidade ?? "",
      "rua": rua ?? "",
      "numero": numero ?? "",
      "infoadd": infoadd ?? "",
      "ramo": ramo ?? "",
      "tipo": tipo.toString().split('.').last, // "prestador" ou "contratante"
    };
  }
}
