import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:imes/models/city.dart';

part 'images.dart';

///
/// JSON res providers
/// 
final jsonDoctorsProvider = FutureProvider<dynamic>((ref) async {
  final data = await rootBundle.loadString('assets/res/doctors.json');
  return jsonDecode(data);
});

final doctorsProvider = FutureProvider<List<String>>((ref) async {
  final json = await ref.watch(jsonDoctorsProvider.future);
  return (json as List).map((d) => d['name'] as String).toList();
});

final jsonCitiesAndHospitalsProvider = FutureProvider<dynamic>((ref) async {
  final data = await rootBundle.loadString('assets/res/city+hospitals.json');
  return jsonDecode(data);
});

final citiesAndHospitalsProvider = FutureProvider<List<City>>((ref) async {
  final json = await ref.watch(jsonCitiesAndHospitalsProvider.future);
  return (json as List).map((e) => e == null ? null : City.fromJson(e as Map<String, dynamic>))?.toList();
});
///