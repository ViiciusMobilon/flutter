import 'dart:io';

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
  File? foto;         // arquivo local (para upload)
  String? fotoURL;    // URL do servidor
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
  });

  /// Construtor a partir do JSON da API (login)
  factory UsuarioGeral.fromJson(Map<String, dynamic> json) {
    print("DEBUG UsuarioGeral.fromJson - chaves recebidas: ${json.keys}");
    return UsuarioGeral(
      id: json['user']['id'],
      id_user: json['logado']['id'],
      email: json['logado']['email'],
      tipo: json['logado']['type'],
      nome: json['user']['nome'],
      cpf: json['user']['cpf'],
      cnpj: json['user']?['cnpj'],
      razao_social: json['user']['razao_social'],
      descricao: json['user']['descricao'],
      fotoURL: json['foto'],
      cidade: json['user']['localidade'],
      uf: json['user']['uf'],
      estado: json['user']['estado'],
      cep: json['user']['cep'],
      rua: json['user']['rua'],
      numero: json['user']['numero'],
      infoadd: json['user']['infoadd'],
      createdAt: json['user']?['created_at'] != null
        ? DateTime.tryParse(json['user']['created_at'])
        : null,
      updatedAt: json['user']?['updated_at'] != null
          ? DateTime.tryParse(json['user']['updated_at'])
          : null,

      ramo: json['user']['id_ramo'] ?? (json['ramo']?['id']),
      ramoNome: json['ramo']?['nome'],
      categoria: json['user']?['id_categoria'] ?? (json['categoria']?['id']),
      categoriaNome: json['categoria']?['nome'],
      token: json['access_token'],
      logadoId: json['logado']['id'],
      logadoEmail: json['logado']['email'],
      logadoType: json['logado']['type'],
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

    );
}

  /// Converter para JSON (para storage ou envio simples)
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
      // "createdAt": DateTime.parse(createdAt.toString()),
      // "updatedAt":DateTime.parse(updatedAt.toString()),
      "ramo": ramo,
      "categoria": categoria,
      "token": token,
      "logadoId": logadoId,
      "logadoEmail": logadoEmail,
      "logadoType": logadoType,
    };
  }

  /// Converter tipo string para enum
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
