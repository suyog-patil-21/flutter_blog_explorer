import 'dart:convert';

class BlogModel {
  final String id;
  final String imageUrl;
  final String title;
  final bool isFavorite;
  BlogModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.isFavorite = false,
  });

  BlogModel copyWith({
    String? id,
    String? imageUrl,
    String? title,
    bool? isFavorite,
  }) {
    return BlogModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'isFavorite': isFavorite,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      imageUrl: map['image_url'] as String,
      title: map['title'] as String,
      isFavorite: map['isFavorite'] == null ? false : map['isFavorite'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) =>
      BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlogModel(id: $id, image_url: $imageUrl, title: $title, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(covariant BlogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        title.hashCode ^
        isFavorite.hashCode;
  }
}
