import 'package:json_annotation/json_annotation.dart';
import 'package:pharmatracker/models/test_button.dart';

part 'test_variants.g.dart';

@JsonSerializable()
class TestVariants {
  @JsonKey(name: 'correct_answer')
  final String correctAnswer;
  final List<TestButton> buttons;

  TestVariants({this.correctAnswer, this.buttons});

  factory TestVariants.fromJson(Map<String, dynamic> json) => _$TestVariantsFromJson(json);
  Map<String, dynamic> toJson() => _$TestVariantsToJson(this);
}
