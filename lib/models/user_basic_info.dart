import 'package:imes/models/cover_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_basic_info.g.dart';

@JsonSerializable()
class UserBasicInfo {
  final CoverImage avatar;

  UserBasicInfo({
    this.avatar,
  });

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) => _$UserBasicInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserBasicInfoToJson(this);
}
