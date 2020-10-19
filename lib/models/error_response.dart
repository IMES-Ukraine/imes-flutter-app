import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  final String error;

  ErrorResponse({this.error});


  @override
  String toString() {
    return this.error;
  }

  static const fromJsonFactory = _$ErrorResponseFromJson;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
