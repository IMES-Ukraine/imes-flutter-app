import 'package:json_annotation/json_annotation.dart';

import 'analytics_page.dart';

part 'analytics_response.g.dart';

@JsonSerializable()
class AnalyticsResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final AnalyticsPage data;

  AnalyticsResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$AnalyticsResponseFromJson;

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsResponseToJson(this);
}
