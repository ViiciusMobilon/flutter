class Contato {
  final int id;
  final String? whatsapp;
  final String? telefone;
  final String? site;
  final String? instagram;
  final int userId;

  Contato({
    required this.id,
    this.whatsapp,
    this.telefone,
    this.site,
    this.instagram,
    required this.userId,
  });

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      id: json['id'],
      whatsapp: json['whatsapp'],
      telefone: json['telefone'],
      site: json['site'],
      instagram: json['instagram'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id':id,
      'whatsapp':whatsapp,
      'telefone':telefone,
      'site':site,
      'instagram':instagram,
      'userId':userId
    };
  }
}
