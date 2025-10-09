

class ServicePostFeed {
  final String? id;
  final String? providerName;
  final String? providerCompany;
  final String? providerAvatar;
  final String? location;
  final String? description;
  final String? fullDescription;
  final List<String>? images;
  final List<String>? videoUrl;
  int? likes;
  bool? isLiked;

  ServicePostFeed({
    this.id,
    this.providerName,
    this.providerCompany,
    this.providerAvatar,
    this.location,
    this.description,
    this.fullDescription,
    this.images,
    this.videoUrl,
    this.likes,
    this.isLiked,
  });

  ServicePost toDetail() {
    return ServicePost(
      id: id ?? '',
      serviceName: description ?? '',
      providerName: providerName ?? '',
      providerCompany: providerCompany ?? '',
      providerPhotoUrl: providerAvatar ?? '',
      providerCity: location ?? '',
      mediaUrls: [...?videoUrl, ...?images],
      isLiked: isLiked ?? false,
      likeCount: likes ?? 0,
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
  ServicePost copyWith({ String? serviceName, String? description, String? providerName, String? providerCompany, List<String>? mediaUrls, String? providerPhotoUrl, }) {
     return ServicePost( serviceName: serviceName ?? this.serviceName, description: description ?? this.description, providerName: providerName ?? this.providerName, providerCompany: providerCompany ?? this.providerCompany, mediaUrls: mediaUrls ?? this.mediaUrls, providerPhotoUrl: providerPhotoUrl ?? this.providerPhotoUrl, ); }
    
     ServicePost updateFrom(ServicePost other) { return ServicePost( id: other.id ?? this.id, serviceName: other.serviceName ?? this.serviceName, description: other.description ?? this.description, mediaUrls: other.mediaUrls ?? this.mediaUrls, providerName: other.providerName ?? this.providerName, providerCompany: other.providerCompany ?? this.providerCompany, providerPhotoUrl: other.providerPhotoUrl ?? this.providerPhotoUrl, providerRating: other.providerRating ?? this.providerRating, providerCity: other.providerCity ?? this.providerCity, isLiked: other.isLiked ?? this.isLiked, likeCount: other.likeCount ?? this.likeCount, ); }
}
