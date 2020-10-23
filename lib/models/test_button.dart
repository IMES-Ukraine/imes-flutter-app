import 'package:imes/models/cover_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_button.g.dart';

@JsonSerializable()
class TestButton {
  final String title;
  final String variant;
  final String description;
  final CoverImage file;

  TestButton({
    this.title,
    this.variant,
    this.description,
    this.file,
  });

  factory TestButton.fromJson(Map<String, dynamic> json) => _$TestButtonFromJson(json);
  Map<String, dynamic> toJson() => _$TestButtonToJson(this);
}
