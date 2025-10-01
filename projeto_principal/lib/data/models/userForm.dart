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
  this.email,
  this.password,
  this.confirmation_password,
  this.cpf,
  this.cnpj,
  this.telefone,
  this.foto, this.cep,
  this.cidade,
  this.estado,
  this.uf,
  this.rua,
  this.numero,
  this.infoadd,
  this.ramo,
  this.tipo});
}