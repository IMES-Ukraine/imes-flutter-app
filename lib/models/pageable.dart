import 'package:json_annotation/json_annotation.dart';

part 'pageable.g.dart';

@JsonSerializable()
class Pageable {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final int from;
  final int to;
  final int total;
  @JsonKey(name: 'last_page')
  final int lastPage;
//  @JsonKey(name: 'per_page')
//  final int perPage;

  Pageable({
    this.currentPage,
    this.from,
    this.to,
    this.total,
    this.lastPage,
//    this.perPage,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);

  Map<String, dynamic> toJson() => _$PageableToJson(this);
}
