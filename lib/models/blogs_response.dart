import 'package:json_annotation/json_annotation.dart';

import 'blog_page.dart';

part 'blogs_response.g.dart';

@JsonSerializable()
class BlogsResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final BlogPage data;

  BlogsResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$BlogsResponseFromJson;

  factory BlogsResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogsResponseToJson(this);
}
