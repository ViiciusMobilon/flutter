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
  });

  /// Para debug legível
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
    ].toString();
  }

  /// Para serialização em Map
  Map<String, dynamic> toMap() {
    final data = {
      "nome": nome,
      "razao_social": razao_social,
      "email": email,
      "password": password,
      "password_confirmation": confirmation_password ?? password,
      "cpf": cpf,
      "cnpj": cnpj,
      "telefone": telefone,
      "whatsapp": whatsapp,
      "instagram": instagram,
      "site": site,
      "descricao": descricao,
      "cep": cep,
      "localidade": cidade,
      "estado": estado,
      "uf": uf,
      "rua": rua,
      "numero": numero,
      "infoadd": infoadd,
      "id_ramo": ramo,
      "id_categoria": categoria,
      "type": tipo,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}
