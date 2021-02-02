import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imes/models/cover_image.dart';
import 'package:imes/models/user_schedule.dart';

part 'user_special_info.freezed.dart';
part 'user_special_info.g.dart';

@freezed
abstract class UserSpecializedInfo with _$UserSpecializedInfo {
  factory UserSpecializedInfo({
    String city,
    String specification,
    String qualification,
    String workplace,
    List<UserSchedule> schedule,
    String position,
    String licenseNumber,
    String studyPeriod,
    String additionalQualification,
    CoverImage educationDocument,
    CoverImage passport,
    String micId,
  }) = _UserSpecializedInfo;

  factory UserSpecializedInfo.fromJson(Map<String, dynamic> json) => _$UserSpecializedInfoFromJson(json);
  // Map<String, dynamic> toJson() => _$UserSpecializedInfoToJson(this);
}
