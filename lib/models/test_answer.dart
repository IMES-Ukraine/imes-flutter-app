import 'package:json_annotation/json_annotation.dart';

part 'test_answer.g.dart';

@JsonSerializable()
class TestAnswer {
  @JsonKey(name: 'test_id')
  final int id;
  final List<String> variant;

  TestAnswer({this.id, this.variant});

  factory TestAnswer.fromJson(Map<String, dynamic> json) => _$TestAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$TestAnswerToJson(this);
}
