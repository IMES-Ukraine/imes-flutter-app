import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'profile_data.g.dart';

@JsonSerializable()
class ProfileData {
  final User user;

  ProfileData({this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
