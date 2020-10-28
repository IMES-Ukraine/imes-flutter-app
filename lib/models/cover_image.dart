import 'package:json_annotation/json_annotation.dart';

part 'cover_image.g.dart';

@JsonSerializable()
class CoverImage {
  @JsonKey(name: 'file_name')
  final String fileName;
  final String path;

  CoverImage({this.path, this.fileName});

  factory CoverImage.fromJson(Map<String, dynamic> json) => _$CoverImageFromJson(json);
  Map<String, dynamic> toJson() => _$CoverImageToJson(this);
}
