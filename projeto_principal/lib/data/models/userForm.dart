import 'dart:io';

class Userform {
  String? nome;
  String? razao_social;
  String? email;
  String? password;
  String? confirmation_password;
  String? cpf;
  String? cnpj;
  String? telefone;
  File? foto;
  String? cep;
  String? cidade;
  String? uf;
  String? estado;
  String? rua;
  String? numero;
  String? infoadd;
  int? ramo;
  String? tipo;

  Userform({
    this.nome,
    this.razao_social,
    this.email,
    this.password,
    this.confirmation_password,
    this.cpf,
    this.cnpj,
    this.telefone,
    this.foto,
    this.cep,
    this.cidade,
    this.estado,
    this.uf,
    this.rua,
    this.numero,
    this.infoadd,
    this.ramo,
    this.tipo,
  });

  /// Para debug legível
  @override
  String toString() {
    return 'Userform(nome: $nome, email: $email, cpf: $cpf, cnpj: $cnpj, telefone: $telefone, cidade: $cidade, estado: $estado, uf: $uf, tipo: $tipo, ramo: $ramo)';
  }

  /// Para serialização em Map
  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "razao_social": razao_social,
      "email": email,
      "password": password,
      "password_confirmation": confirmation_password ?? password,
      "cpf": cpf,
      "cnpj": cnpj,
      "telefone": telefone,
      "cep": cep,
      "localidade": cidade,
      "estado": estado,
      "uf": uf,
      "rua": rua,
      "numero": numero,
      "infoadd": infoadd,
      "id_ramo": ramo,
      "type": tipo,
    };
  }
}
