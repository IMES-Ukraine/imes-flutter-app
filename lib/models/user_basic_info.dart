import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imes/models/cover_image.dart';

part 'user_basic_info.freezed.dart';
part 'user_basic_info.g.dart';

@freezed
abstract class UserBasicInfo with _$UserBasicInfo {
  factory UserBasicInfo({
    String phone,
    String name,
    String email,
    CoverImage avatar,
  }) = _UserBasicInfo;

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) => _$UserBasicInfoFromJson(json);
}
