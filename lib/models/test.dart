import 'package:imes/models/cover_image.dart';
import 'package:imes/models/featured_image.dart';
import 'package:imes/models/test_options.dart';
import 'package:imes/models/test_variants.dart';
import 'package:json_annotation/json_annotation.dart';

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
  final List agreementAccepted;
  final String agreement;
  @JsonKey(name: 'isOpened')
  final bool isOpened;
  @JsonKey(name: 'isAgreementAccepted')
  final bool isAgreementAccepted;
  final num researchId;

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
    this.agreementAccepted,
    this.agreement,
    this.isOpened,
    this.isAgreementAccepted,
    this.researchId,
  });

  bool get hasToLearn =>
      options.indexWhere((element) => element.type == 'to_learn') != -1;
  bool get hasDescription =>
      options.indexWhere((element) => element.type == 'description') != -1;
  bool get hasVideo =>
      options.indexWhere((element) => element.type == 'video') != -1;

  TestOptions get toLearn =>
      options.singleWhere((element) => element.type == 'to_learn');
  TestOptions get description =>
      options.singleWhere((element) => element.type == 'description');
  TestOptions get video =>
      options.singleWhere((element) => element.type == 'video');

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
  Map<String, dynamic> toJson() => _$TestToJson(this);
}
