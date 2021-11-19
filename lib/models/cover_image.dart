import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cover_image.freezed.dart';
part 'cover_image.g.dart';

@freezed
abstract class CoverImage with _$CoverImage {
  @HiveType(typeId: 1)
  factory CoverImage({
    @HiveField(0) String path,
    @HiveField(1) String fileName,
  }) = _CoverImage;

  factory CoverImage.fromJson(Map<String, dynamic> json) =>
      _$CoverImageFromJson(json);
  // Map<String, dynamic> toJson() => _$CoverImageToJson(this);
}
