import 'package:imes/models/notification_text.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  final num id;
  @JsonKey(name: 'user_id')
  final num userId;
  final String type;
  final String action;
  final String image; 
  final NotificationText text;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime deletedAt;

  Notification({
    this.id,
    this.userId,
    this.type,
    this.action,
    this.image,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
