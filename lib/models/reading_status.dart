import 'package:json_annotation/json_annotation.dart';

part 'reading_status.g.dart';

@JsonSerializable()
class ReadingStatus {
  final int pointsEarned;

  ReadingStatus({this.pointsEarned});

  factory ReadingStatus.fromJson(Map<String, dynamic> json) =>
      _$ReadingStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingStatusToJson(this);
}
