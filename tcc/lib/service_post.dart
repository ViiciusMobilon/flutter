class ServicePostFeed {
  final String id;
  final String providerName;
  final String providerCompany;
  final String providerAvatar;
  final String location;
  final String description;
  final String fullDescription;
  final List<String> images;
  int likes;
  bool isLiked;

  ServicePostFeed({
    required this.id,
    required this.providerName,
    required this.providerCompany,
    required this.providerAvatar,
    required this.location,
    required this.description,
    required this.fullDescription,
    required this.images,
    required this.likes,
    required this.isLiked,
  });

  /// 🔹 Converte o objeto do Feed para o modelo usado em VerMaisPage
  ServicePost toDetail() {
    return ServicePost(
      id: id,
      providerName: providerName,
      providerCompany: providerCompany,
      providerPhotoUrl: providerAvatar,
      providerCity: location,
      mediaUrls: images,
      likeCount: likes,
      isLiked: isLiked,
      description: description,
    );
  }
}

class ServicePost {
  final String? id;
  final String? serviceName;
  final String? description;
  final List<String>? mediaUrls;
  final String? providerName;
  final String? providerCompany;
  final String? providerPhotoUrl;
  final double? providerRating;
  final String? providerCity;
  final bool? isLiked;
  final int? likeCount;

  ServicePost({
    this.id,
    this.serviceName,
    this.description,
    this.mediaUrls,
    this.providerName,
    this.providerCompany,
    this.providerPhotoUrl,
    this.providerRating,
    this.providerCity,
    this.isLiked,
    this.likeCount,
  });

  ServicePost copyWith({
    String? serviceName,
    String? description,
    String? providerName,
    String? providerCompany,
    List<String>? mediaUrls,
    String? providerPhotoUrl,
  }) {
    return ServicePost(
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      providerName: providerName ?? this.providerName,
      providerCompany: providerCompany ?? this.providerCompany,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      providerPhotoUrl: providerPhotoUrl ?? this.providerPhotoUrl,
    );
  }

  /// 🔹 Atualiza os campos do post com outro ServicePost
  ServicePost updateFrom(ServicePost other) {
    return ServicePost(
      id: other.id ?? this.id,
      serviceName: other.serviceName ?? this.serviceName,
      description: other.description ?? this.description,
      mediaUrls: other.mediaUrls ?? this.mediaUrls,
      providerName: other.providerName ?? this.providerName,
      providerCompany: other.providerCompany ?? this.providerCompany,
      providerPhotoUrl: other.providerPhotoUrl ?? this.providerPhotoUrl,
      providerRating: other.providerRating ?? this.providerRating,
      providerCity: other.providerCity ?? this.providerCity,
      isLiked: other.isLiked ?? this.isLiked,
      likeCount: other.likeCount ?? this.likeCount,
    );
  }
}
