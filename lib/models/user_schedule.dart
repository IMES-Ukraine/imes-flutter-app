import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_schedule.freezed.dart';
part 'user_schedule.g.dart';

@freezed
abstract class UserSchedule with _$UserSchedule {
  factory UserSchedule({String time, List<int> days}) = _UserSchedule;

  factory UserSchedule.fromJson(Map<String, dynamic> json) => _$UserScheduleFromJson(json);
  // Map<String, dynamic> toJson() => _$UserScheduleToJson(this);
}
