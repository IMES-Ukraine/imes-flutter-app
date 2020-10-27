import 'package:imes/models/cover_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_special_info.g.dart';

@JsonSerializable()
class UserSpecializedInfo {
  final String specification;
  final String qualification;
  final String workplace;
  final String schedule;
  final String position;
  final String licenseNumber;
  final String studyPeriod;
  final String additionalQualification;
  final CoverImage educationDocument;

  UserSpecializedInfo({
    this.specification,
    this.qualification,
    this.workplace,
    this.schedule,
    this.position,
    this.licenseNumber,
    this.studyPeriod,
    this.additionalQualification,
    this.educationDocument,
  });

  factory UserSpecializedInfo.fromJson(Map<String, dynamic> json) => _$UserSpecializedInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserSpecializedInfoToJson(this);
}
