import 'package:imes/models/submit_test_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'submit_test_response.g.dart';

@JsonSerializable()
class SubmitTestResponse {
  final String message;
  @JsonKey(name: 'status_code')
  final int statusCode;
  final SubmitTestData data;

  SubmitTestResponse({
    this.data,
    this.message,
    this.statusCode,
  });

  static const fromJsonFactory = _$SubmitTestResponseFromJson;

  factory SubmitTestResponse.fromJson(Map<String, dynamic> json) => _$SubmitTestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SubmitTestResponseToJson(this);
}
