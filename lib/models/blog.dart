import 'package:hive/hive.dart';
import 'package:imes/models/cover_image.dart';
import 'package:json_annotation/json_annotation.dart';

import 'blog_content.dart';
import 'blog_recommended.dart';
import 'featured_image.dart';

part 'blog.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Blog extends HiveObject {
  @HiveField(0)
  final num id;
  @HiveField(1)
  final String title;
  final String slug;
  final String excerpt;
  final List<BlogContent> content;
  final List<BlogRecommended> recommended;
  @HiveField(2)
  final DateTime publishedAt;
  final int published;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String action;
  final String summary;
  final bool hasSummary;
  List<FeaturedImage> featuredImages;
  @HiveField(3)
  final int learningBonus;
  @HiveField(4)
  final CoverImage coverImage;
  @JsonKey(name: 'isOpened')
  final bool isOpened;
  @JsonKey(name: 'isAgreementAccepted')
  final bool isAgreementAccepted;
  @JsonKey(name: 'isCommercial')
  final bool isCommercial;
  final num researchId;
  final num testId;

  Blog({
    this.id,
    this.title,
    this.slug,
    this.excerpt,
    this.content,
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
    this.coverImage,
    this.isOpened,
    this.isAgreementAccepted,
    this.isCommercial,
    this.researchId,
    this.testId,
  });

  @override
  bool operator ==(other) => other is Blog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  Map<String, dynamic> toJson() => _$BlogToJson(this);
}
