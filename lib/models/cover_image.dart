import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover_image.freezed.dart';
part 'cover_image.g.dart';

@freezed
abstract class CoverImage with _$CoverImage {
  factory CoverImage({String path, String fileName}) = _CoverImage;

  factory CoverImage.fromJson(Map<String, dynamic> json) => _$CoverImageFromJson(json);
  // Map<String, dynamic> toJson() => _$CoverImageToJson(this);
}
