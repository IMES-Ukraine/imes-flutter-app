import 'package:json_annotation/json_annotation.dart';

part 'banner_card.g.dart';

@JsonSerializable()
class BannerCardResponse {
  const BannerCardResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  final int statusCode;
  final String message;
  final BannerCard data;

  static const fromJsonFactory = _$BannerCardResponseFromJson;

  factory BannerCardResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BannerCardResponseToJson(this);
}

@JsonSerializable()
class BannerCard {
  const BannerCard({
    this.id,
    this.type,
    this.url,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String type;
  final String image;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get bannerUrl =>
      url?.isNotEmpty == true && image?.isNotEmpty == true ? url + image : '';

  factory BannerCard.empty() => BannerCard();

  factory BannerCard.fromJson(Map<String, dynamic> json) =>
      _$BannerCardFromJson(json);

  Map<String, dynamic> toJson() => _$BannerCardToJson(this);
}
