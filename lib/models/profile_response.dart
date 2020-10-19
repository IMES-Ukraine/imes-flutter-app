import 'package:json_annotation/json_annotation.dart';

import 'profile_data.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final ProfileData data;

  ProfileResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$ProfileResponseFromJson;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
