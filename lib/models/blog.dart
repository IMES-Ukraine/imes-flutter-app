import 'package:json_annotation/json_annotation.dart';
import 'package:pharmatracker/models/cover_image.dart';
import 'blog_content.dart';
import 'blog_recommended.dart';
import 'featured_image.dart';

part 'blog.g.dart';

@JsonSerializable()
class Blog {
  final num id;
  // @JsonKey(name: 'user_id')
  // final num userId;
  final String title;
  final String slug;
  final String excerpt;
  final List<BlogContent> content;
  // @JsonKey(name: 'content_html')
  // final String contentHtml;
  final List<BlogRecommended> recommended;
  @JsonKey(name: 'published_at')
  final DateTime publishedAt;
  final int published;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String action;
  final String summary;
  @JsonKey(name: 'has_summary')
  final bool hasSummary;
  @JsonKey(name: 'featured_images')
  List<FeaturedImage> featuredImages;
  @JsonKey(name: 'learning_bonus')
  final int learningBonus;
  @JsonKey(name: 'cover_image')
  final List<CoverImage> coverImages;

  Blog({
    this.id,
    // this.userId,
    this.title,
    this.slug,
    this.excerpt,
    this.content,
    // this.contentHtml,
    this.recommended,
    this.publishedAt,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.action,
    this.summary,
    this.hasSummary,
    this.featuredImages,
    this.learningBonus,
    this.coverImages,
  });

  @override
  bool operator ==(other) => other is Blog && other.id == this.id;

  @override
  int get hashCode => this.id.hashCode;

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  Map<String, dynamic> toJson() => _$BlogToJson(this);
}
