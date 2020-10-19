import 'package:json_annotation/json_annotation.dart';

part 'basic_response.g.dart';

@JsonSerializable()
class BasicResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;

  BasicResponse({this.statusCode, this.message,});

  static const fromJsonFactory = _$BasicResponseFromJson;

  factory BasicResponse.fromJson(Map<String, dynamic> json) =>
      _$BasicResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BasicResponseToJson(this);
}