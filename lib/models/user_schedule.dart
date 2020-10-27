import 'package:json_annotation/json_annotation.dart';

part 'user_schedule.g.dart';

@JsonSerializable()
class UserSchedule {
  final String time;
  final List<int> days;

  UserSchedule({this.time, this.days});

  factory UserSchedule.fromJson(Map<String, dynamic> json) => _$UserScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$UserScheduleToJson(this);
}
