import 'package:json_annotation/json_annotation.dart';

import 'read_blog_block_data.dart';

part 'read_blog_block_response.g.dart';

@JsonSerializable()
class ReadBlogBlockResponse {
  final int statusCode;
  final String message;
  final ReadBlogBlockData data;

  ReadBlogBlockResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$ReadBlogBlockResponseFromJson;

  factory ReadBlogBlockResponse.fromJson(Map<String, dynamic> json) =>
      _$ReadBlogBlockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadBlogBlockResponseToJson(this);
}
