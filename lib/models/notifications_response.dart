import 'package:json_annotation/json_annotation.dart';

import 'notifications_page.dart';

part 'notifications_response.g.dart';

@JsonSerializable()
class NotificationsResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final NotificationsPage data;

  NotificationsResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$NotificationsResponseFromJson;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}
