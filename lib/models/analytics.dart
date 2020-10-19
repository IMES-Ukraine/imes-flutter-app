import 'package:json_annotation/json_annotation.dart';

part 'analytics.g.dart';

@JsonSerializable()
class Analytics {
  final num id;
  final String label;
  @JsonKey(name: 'user_id')
  final num userId;
  final String city;
  final int status;
  @JsonKey(name: 'photo_id')
  final String photoId;
  final int grams;
  final int count;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime deletedAt;

  Analytics({
    this.id,
    this.label,
    this.userId,
    this.city,
    this.status,
    this.photoId,
    this.grams,
    this.count,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsToJson(this);
}
