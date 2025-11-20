import 'dart:io';
import 'package:tcc/data/models/skill.dart';

enum TipoUsuario { prestador, contratante, empresa }

class UsuarioGeral {
  int? id;            // ID do user no servidor
  int? id_user;       // logado.id
  String? nome;
  String? razao_social;
  String? descricao;
  String? email;
  String? password;
  String? confirmation_password;
  String? cpf;
  String? cnpj;
  String? telefone;
  String? whatsapp;
  String? instagram;
  String? site;
  File? foto;         
  String? fotoURL;    
  String? cep;
  String? cidade;
  String? uf;
  String? estado;
  String? rua;
  String? numero;
  String? infoadd;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? ramo;
  String? ramoNome;
  int? categoria;
  String? categoriaNome;
  String? tipo;
  int? logadoId;
  String? logadoEmail;
  String? logadoType;
  String? token;
  double? avaliacaoMedia;
  double? avaliacaoTotal;
  bool? status;
  List<SkillModelA> skills;

  UsuarioGeral({
    this.id,
    this.id_user,
    this.nome,
    this.razao_social,
    this.descricao,
    this.email,
    this.password,
    this.confirmation_password,
    this.cpf,
    this.cnpj,
    this.telefone,
    this.whatsapp,
    this.site,
    this.instagram,
    this.foto,
    this.fotoURL,
    this.cep,
    this.cidade,
    this.uf,
    this.estado,
    this.rua,
    this.numero,
    this.infoadd,
    this.createdAt,
    this.updatedAt,
    this.ramo,
    this.ramoNome,
    this.categoria,
    this.categoriaNome,
    this.tipo,
    this.logadoId,
    this.logadoEmail,
    this.logadoType,
    this.token,
    this.avaliacaoMedia,
    this.avaliacaoTotal,
    this.status,
    List<SkillModelA>? skills,
  }) : skills = skills ?? [];

  factory UsuarioGeral.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    final logadoJson = json['logado'] ?? {};
    final logadoDadosJson = logadoJson['dados'] ?? {};

    List<SkillModelA> skillsList = [];
    if (logadoDadosJson['skills'] != null && logadoDadosJson['skills'] is List) {
      skillsList = (logadoDadosJson['skills'] as List)
          .map((s) => SkillModelA.fromJson(s))
          .toList();
    } else if (userJson['skills'] != null && userJson['skills'] is List) {
      skillsList = (userJson['skills'] as List)
          .map((s) => SkillModelA.fromJson(s))
          .toList();
    }

    return UsuarioGeral(
      id: userJson['id'],
      id_user: logadoJson['id'],
      email: logadoJson['email'],
      tipo: logadoJson['type'],
      nome: userJson['nome'],
      cpf: userJson['cpf'],
      cnpj: userJson['cnpj'],
      razao_social: userJson['razao_social'],
      descricao: userJson['descricao'],
      status: (userJson['disponivel'] as int?) == 1,
      fotoURL: json['foto'],
      cidade: userJson['localidade'],
      uf: userJson['uf'],
      estado: userJson['estado'],
      cep: userJson['cep'],
      rua: userJson['rua'],
      numero: userJson['numero'],
      infoadd: userJson['infoadd'],
        createdAt: userJson['created_at'] != null
          ? DateTime.tryParse(userJson['created_at'])
          : null,
        updatedAt: userJson['updated_at'] != null
          ? DateTime.tryParse(userJson['updated_at'])
          : null,
        ramo: userJson['id_ramo'] ?? (json['ramo']?['id']),
        ramoNome: json['ramo']?['nome'],
        categoria: userJson['id_categoria'] ?? (json['categoria']?['id']),
        categoriaNome: json['categoria']?['nome'],
      token: json['access_token'],
      logadoId: logadoJson['id'],
      logadoEmail: logadoJson['email'],
      logadoType: logadoJson['type'],
      avaliacaoMedia: json['avaliacao']?['media'] != null
          ? double.tryParse(json['avaliacao']['media'].toString())
          : null,
      avaliacaoTotal: json['avaliacao']?['total'] != null
          ? double.tryParse(json['avaliacao']['total'].toString())
          : 0,
      telefone: json['contatos']?['telefone']?.toString(),
      whatsapp: json['contatos']?['whatsapp']?.toString(),
      instagram: json['contatos']?['instagram']?.toString(),
      site: json['contatos']?['site']?.toString(),
      skills: skillsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_user": id_user,
      "email": email,
      "type": tipo,
      "nome": nome,
      "razao_social": razao_social,
      "cpf": cpf,
      "cnpj": cnpj,
      "telefone": telefone,
      "fotoURL": fotoURL,
      "localidade": cidade,
      "uf": uf,
      "estado": estado,
      "cep": cep,
      "rua": rua,
      "numero": numero,
      "infoadd": infoadd,
      "ramo": ramo,
      "categoria": categoria,
      "token": token,
      "logadoId": logadoId,
      "logadoEmail": logadoEmail,
      "logadoType": logadoType,
      "skills": skills.map((s) => s.toJson()).toList(),
    };
  }

  TipoUsuario? get tipoUsuario {
    switch (tipo) {
      case 'prestador':
        return TipoUsuario.prestador;
      case 'contratante':
        return TipoUsuario.contratante;
      case 'empresa':
        return TipoUsuario.empresa;
      default:
        return null;
    }
  }
}

class SkillModelA {
  final int id;
  final String nome;
  final int id_ramo;

  SkillModelA({required this.id, required this.nome, required this.id_ramo});

  factory SkillModelA.fromJson(Map<String, dynamic> json) {
    return SkillModelA(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      nome: json['nome'] ?? '',
      id_ramo: json['id_ramo'] != null ? int.parse(json['id_ramo'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'id_ramo': id_ramo,
    };
  }
}
