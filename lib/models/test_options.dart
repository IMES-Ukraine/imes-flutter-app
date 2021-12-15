import 'package:json_annotation/json_annotation.dart';

part 'test_options.g.dart';

@JsonSerializable()
class TestOptions {
  final String type;
  final dynamic data;

  TestOptions({this.type, this.data});

  factory TestOptions.fromJson(Map<String, dynamic> json) =>
      _$TestOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$TestOptionsToJson(this);
}
