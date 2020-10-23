import 'package:imes/models/test.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_response.g.dart';

@JsonSerializable()
class TestResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final List<Test> data;

  TestResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$TestResponseFromJson;

  factory TestResponse.fromJson(Map<String, dynamic> json) => _$TestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TestResponseToJson(this);
}
