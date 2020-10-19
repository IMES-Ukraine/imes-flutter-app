import 'package:json_annotation/json_annotation.dart';

part 'blog_content.g.dart';

@JsonSerializable()
class BlogContent {
  final String content;
  final String title;
  final String type;

  BlogContent({
    this.content,
    this.title,
    this.type,
  });

  factory BlogContent.fromJson(Map<String, dynamic> json) => _$BlogContentFromJson(json);
  Map<String, dynamic> toJson() => _$BlogContentToJson(this);
}
