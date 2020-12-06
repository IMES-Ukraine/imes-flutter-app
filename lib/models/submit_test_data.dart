import 'package:imes/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'submit_test_data.g.dart';

@JsonSerializable()
class SubmitTestData {
  final User user;
  final int points;
  final String status;

  SubmitTestData({this.user, this.points, this.status});

  factory SubmitTestData.fromJson(Map<String, dynamic> json) => _$SubmitTestDataFromJson(json);
  Map<String, dynamic> toJson() => _$SubmitTestDataToJson(this);
}
