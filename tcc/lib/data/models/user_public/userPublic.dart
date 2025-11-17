import 'package:tcc/data/models/user_public/dados_user.dart';
import 'contato.dart';
import 'package:tcc/data/models/user_public/post_user.dart';

class UsuarioPublic {
  final int id;
  final String email;
  final String type;
  final int curtidasQueRecebi;
  final DadosUsuario dados;
  final List<PortfolioUser> portfolios;
  final Contato? contato;

  UsuarioPublic({
    required this.id,
    required this.email,
    required this.type,
    required this.curtidasQueRecebi,
    required this.dados,
    required this.portfolios,
    this.contato,
  });

  factory UsuarioPublic.fromJson(Map<String, dynamic> json) {
    return UsuarioPublic(
      id: json['id'],
      email: json['email'],
      type: json['type'],
      curtidasQueRecebi: json['curtidas_que_recebi_count'] ?? 0,
      dados: DadosUsuario.fromJson(json['dados']),
      portfolios: (json['portfolios'] as List)
          .map((p) => PortfolioUser.fromJson(p))
          .toList(),
      contato: json['contato'] != null
          ? Contato.fromJson(json['contato'])
          : null,
    );
  }


  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'email':email,
      'type':type,
      'curtidasQueRecebi':curtidasQueRecebi,
      'dados':dados,
      'portfolios':portfolios,
      'contato':contato
    };
  }
}
