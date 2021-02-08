import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imes/models/hospital.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
abstract class City with _$City {
  factory City({String name, List<Hospital> items}) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  // Map<String, dynamic> toJson() => _$CityToJson(this);
}