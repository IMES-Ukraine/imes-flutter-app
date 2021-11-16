import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String token;
  final User user;

  LoginResponse({this.token, this.user});

  static const fromJsonFactory = _$LoginResponseFromJson;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
