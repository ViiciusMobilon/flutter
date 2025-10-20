class Portfolio {
  final int? id;
  final String? descricao;
  final String? nome;
  final String? avatar;
  final String? ramo;
  final String? cidade;
  final String? estado;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Foto> fotos;
  final List<Video> videos;

  Portfolio({
    this.id,
    this.descricao,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.nome,
    this.avatar,
    this.ramo,
    this.cidade,
    this.estado,
    required this.fotos,
    required this.videos,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as int?,
      descricao: json['descricao'] as String?,
      userId: json['user_id'] as int?,
      nome: json['nome'] as String?,
      avatar: json['avatar'] as String?,
      ramo: json['ramo'] as String?,
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
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
