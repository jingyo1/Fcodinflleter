class PaginatedResponse<T> {
  final List<T> content;
  final int number;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;

  PaginatedResponse({
    required this.content,
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      content: (json['content'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      number: json['number'] as int,
      size: json['size'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      first: json['first'] as bool,
      last: json['last'] as bool,
    );
  }
}

class PostResponse {
  final int id;
  final String authorName;
  final String topImageUrl;
  final String bottomImageUrl;
  final String shoesImageUrl;
  final String? jacketImageUrl;
  final int likeCount;

  PostResponse({
    required this.id,
    required this.authorName,
    required this.topImageUrl,
    required this.bottomImageUrl,
    required this.shoesImageUrl,
    this.jacketImageUrl,
    required this.likeCount,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'] as int,
      authorName: json['author_name'] as String,
      topImageUrl: json['top_image_url'] as String,
      bottomImageUrl: json['bottom_image_url'] as String,
      shoesImageUrl: json['shoes_image_url'] as String,
      jacketImageUrl: json['jacket_image_url'] as String?,
      likeCount: json['like_count'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_name': authorName,
      'top_image_url': topImageUrl,
      'bottom_image_url': bottomImageUrl,
      'shoes_image_url': shoesImageUrl,
      'jacket_image_url': jacketImageUrl,
      'like_count': likeCount,
    };
  }
}
