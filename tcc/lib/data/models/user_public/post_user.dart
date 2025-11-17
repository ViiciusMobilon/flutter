class PortfolioUser {
  final int? id;
  final String? descricao;
  final String? user_nome;
  final String? user_foto;
  final String? user_ramo;
  final String? user_cidade;
  final String? user_estado;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Foto>? fotos;
  final List<Video>? videos;

  PortfolioUser({
    this.id,
    this.descricao,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user_nome,
    this.user_foto,
    this.user_ramo,
    this.user_cidade,
    this.user_estado,
    this.fotos,
    this.videos,
  });

  factory PortfolioUser.fromJson(Map<String, dynamic> json) {
    return PortfolioUser(
      id: json['id'] as int?,
      descricao: json['descricao'] as String?,
      userId: json['user_id'] as int?,
      user_nome: json['user_nome'] as String?,
      user_foto: json['user_foto'] as String?,
      user_ramo: json['user_ramo'] as String?,
      user_cidade: json['user_cidade'] as String?,
      user_estado: json['user_estado'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      fotos: (json['fotos'] as List<dynamic>?)
              ?.map((e) => Foto.fromJson(e))
              .toList() ??
          [],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => Video.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "id": id,
      "descricao": descricao,
      "fotos": fotos,
      "Videos": videos
    };
  }
}

class Foto {
  final int? id;
  final String? foto;
  final int? portfolioId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? url;

  Foto({
    this.id,
    this.foto,
    this.portfolioId,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'] as int?,
      foto: json['foto'] as String?,
      portfolioId: json['portfolio_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      url: json['url'] as String?,
    );
  }
}

class Video {
  final int? id;
  final String? video;
  final int? portfolioId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? url;

  Video({
    this.id,
    this.video,
    this.portfolioId,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int?,
      video: json['video'] as String?,
      portfolioId: json['portfolio_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      url: json['url'] as String?,
    );
  }
}
