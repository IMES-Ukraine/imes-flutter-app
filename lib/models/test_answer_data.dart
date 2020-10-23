import 'package:json_annotation/json_annotation.dart';
import 'package:imes/models/test_answer.dart';

part 'test_answer_data.g.dart';

@JsonSerializable()
class TestAnswerData {
  final List<TestAnswer> data;
  @JsonKey(name: 'duration_seconds')
  final int seconds;

  TestAnswerData({this.data, this.seconds});

  factory TestAnswerData.fromJson(Map<String, dynamic> json) => _$TestAnswerDataFromJson(json);
  Map<String, dynamic> toJson() => _$TestAnswerDataToJson(this);
}
