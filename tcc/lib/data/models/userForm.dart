import 'dart:io';

import 'package:tcc/data/models/user.dart';

class Userform {
  String? nome;
  String? razao_social;
  String? email;
  String? password;
  String? confirmation_password;
  String? cpf;
  String? cnpj;
  String? telefone;
  String? whatsapp;
  String? instagram;
  String? site;
  String? descricao;
  File? foto;
  String? cep;
  String? cidade;
  String? uf;
  String? estado;
  String? rua;
  String? numero;
  String? infoadd;
  int? ramo;
  int? categoria;
  String? tipo;
  List<int>? skills;

  Userform({
    this.nome,
    this.razao_social,
    this.email,
    this.password,
    this.confirmation_password,
    this.cpf,
    this.cnpj,
    this.telefone,
    this.whatsapp,
    this.instagram,
    this.site,
    this.descricao,
    this.foto,
    this.cep,
    this.cidade,
    this.estado,
    this.uf,
    this.rua,
    this.numero,
    this.infoadd,
    this.ramo,
    this.categoria,
    this.tipo,
    this.skills,
  });

  @override
  String toString() {
    return [
      'nome: $nome',
      'razao_social: $razao_social',
      'email: $email',
      'password: $password',
      'confirmation_password: $confirmation_password',
      'cpf: $cpf',
      'cnpj: $cnpj',
      'telefone: $telefone',
      'whatsapp: $whatsapp',
      'instagram: $instagram',
      'site: $site',
      'descricao: $descricao',
      'foto: ${foto != null ? foto!.path : 'null'}',
      'cep: $cep',
      'cidade: $cidade',
      'estado: $estado',
      'uf: $uf',
      'rua: $rua',
      'numero: $numero',
      'infoadd: $infoadd',
      'ramo: $ramo',
      'categoria: $categoria',
      'tipo: $tipo',
      'skills: $skills',
    ].toString();
  }

  // Construtor para popular a partir do JSON da API
  factory Userform.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    List<int> parseSkills(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) {
          if (e is int) return e;
          if (e is Map && e['id'] != null) return e['id'] as int;
          return int.parse(e.toString());
        }).toList();
      }
      return [];
    }

    return Userform(
      nome: json['nome']?.toString(),
      razao_social: json['razao_social']?.toString(),
      email: json['email']?.toString(),
      password: null,
      confirmation_password: null,
      cpf: json['cpf']?.toString(),
      cnpj: json['cnpj']?.toString(),
      telefone: json['telefone']?.toString(),
      whatsapp: json['whatsapp']?.toString(),
      instagram: json['instagram']?.toString(),
      site: json['site']?.toString(),
      descricao: json['descricao']?.toString(),
      cep: json['cep']?.toString(),
      cidade: json['localidade']?.toString(),
      estado: json['estado']?.toString(),
      uf: json['uf']?.toString(),
      rua: json['rua']?.toString(),
      numero: json['numero']?.toString(),
      infoadd: json['infoadd']?.toString(),
      ramo: parseInt(json['id_ramo']),
      categoria: parseInt(json['id_categoria']),
      tipo: json['type']?.toString(),
      skills: parseSkills(json['skills']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome ?? "",
      "razao_social": razao_social ?? "",
      "email": email ?? "",
      "password": password ?? "",
      "password_confirmation": confirmation_password ?? password ?? "",
      "cpf": cpf ?? "",
      "cnpj": cnpj ?? "",
      "telefone": telefone ?? "",
      "whatsapp": whatsapp ?? "",
      "instagram": instagram ?? "",
      "site": site ?? "",
      "descricao": descricao ?? "",
      "cep": cep ?? "",
      "localidade": cidade ?? "",
      "estado": estado ?? "",
      "uf": uf ?? "",
      "rua": rua ?? "",
      "numero": numero ?? "",
      "infoadd": infoadd ?? "",
      "id_ramo": ramo,
      "id_categoria": categoria,
      "type": tipo ?? "",
      "skills": skills?.toList() ?? [],
    };
  }
}
