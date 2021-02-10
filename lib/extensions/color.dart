import 'dart:math';

import 'package:flutter/material.dart';

double _clamp01(double val) {
  return min(1.0, max(0.0, val));
}

extension ColorUtils on Color {
  Color darken([int amount = 10]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(_clamp01(hsl.lightness - amount / 100.0)).toColor();
  }

  Color lighten([int amount = 10]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(_clamp01(hsl.lightness + amount / 100.0)).toColor();
  }
}
