import 'package:json_annotation/json_annotation.dart';

import 'blog.dart';

part 'blog_response.g.dart';

@JsonSerializable()
class BlogResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final List<Blog> data;

  BlogResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$BlogResponseFromJson;

  factory BlogResponse.fromJson(Map<String, dynamic> json) => _$BlogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogResponseToJson(this);
}
