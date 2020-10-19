import 'package:json_annotation/json_annotation.dart';

part 'featured_image.g.dart';

@JsonSerializable()
class FeaturedImage {
  final num id;
  @JsonKey(name: 'disk_name')
  final String diskName;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_size')
  final num fileSize;
  @JsonKey(name: 'content_type')
  final String contentType;
  final String title;
  final String description;
  final String field;
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String path;
  final String extension;

  FeaturedImage({
    this.id,
    this.diskName,
    this.fileName,
    this.fileSize,
    this.contentType,
    this.title,
    this.description,
    this.field,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.path,
    this.extension,
  });

  factory FeaturedImage.fromJson(Map<String, dynamic> json) => _$FeaturedImageFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedImageToJson(this);
}
