import 'package:json_annotation/json_annotation.dart';
import 'package:imes/models/blog.dart';

part 'blog_recommended.g.dart';

@JsonSerializable()
class BlogRecommended {
  @JsonKey(name: 'parent_id')
  final num parentId;
  @JsonKey(name: 'recommended_id')
  final num recommendedId;
  final Blog post;

  BlogRecommended({
    this.parentId,
    this.recommendedId,
    this.post,
  });

  factory BlogRecommended.fromJson(Map<String, dynamic> json) => _$BlogRecommendedFromJson(json);
  Map<String, dynamic> toJson() => _$BlogRecommendedToJson(this);
}
