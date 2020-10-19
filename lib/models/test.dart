import 'package:json_annotation/json_annotation.dart';
import 'package:pharmatracker/models/cover_image.dart';
import 'package:pharmatracker/models/featured_image.dart';
import 'package:pharmatracker/models/test_options.dart';
import 'package:pharmatracker/models/test_variants.dart';

part 'test.g.dart';

@JsonSerializable()
class Test {
  final num id;
  final String title;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'featured_images')
  final List<FeaturedImage> featuredImages;
  @JsonKey(name: 'cover_image')
  final CoverImage coverImage;
  final List<TestOptions> options;
  final TestVariants variants;
  @JsonKey(name: 'test_type')
  final String testType;
  @JsonKey(name: 'answer_type')
  final String answerType;
  @JsonKey(name: 'passing_bonus')
  final int bonus;
  @JsonKey(name: 'duration_seconds')
  final int duration;
  final List<Test> complex;
  final String question;

  Test({
    this.id,
    this.title,
    this.createdAt,
    this.featuredImages,
    this.coverImage,
    this.options,
    this.variants,
    this.testType,
    this.answerType,
    this.bonus,
    this.duration,
    this.complex,
    this.question,
  });

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
  Map<String, dynamic> toJson() => _$TestToJson(this);
}
