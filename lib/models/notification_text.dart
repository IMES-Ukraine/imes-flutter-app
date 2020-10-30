import 'package:json_annotation/json_annotation.dart';

part 'notification_text.g.dart';

@JsonSerializable()
class NotificationText {
  final String title;
  final String content;

  NotificationText({
    this.title,
    this.content,
  });

  factory NotificationText.fromJson(Map<String, dynamic> json) => _$NotificationTextFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTextToJson(this);
}
