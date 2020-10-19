import 'package:json_annotation/json_annotation.dart';

part 'test_button.g.dart';

@JsonSerializable()
class TestButton {
  final String title;
  final String variant;

  TestButton({this.title, this.variant});

  factory TestButton.fromJson(Map<String, dynamic> json) => _$TestButtonFromJson(json);
  Map<String, dynamic> toJson() => _$TestButtonToJson(this);
}
