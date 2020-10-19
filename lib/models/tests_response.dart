import 'package:json_annotation/json_annotation.dart';
import 'package:pharmatracker/models/test_page.dart';

part 'tests_response.g.dart';

@JsonSerializable()
class TestsResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final TestPage data;

  TestsResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$TestsResponseFromJson;

  factory TestsResponse.fromJson(Map<String, dynamic> json) => _$TestsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TestsResponseToJson(this);
}
