import 'package:freezed_annotation/freezed_annotation.dart';

part 'hospital.freezed.dart';
part 'hospital.g.dart';

@freezed
abstract class Hospital with _$Hospital {
  factory Hospital({String name}) = _Hospital;

  factory Hospital.fromJson(Map<String, dynamic> json) => _$HospitalFromJson(json);

  // Map<String, dynamic> toJson() => _$HospitalToJson(this);
}