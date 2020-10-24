import 'package:flutter/material.dart';
import 'package:imes/helpers/utils.dart';

extension ColorUtils on Color {
  Color darken([int amount = 10]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(Utils.clamp01(hsl.lightness - amount / 100.0)).toColor();
  }

  Color lighten([int amount = 10]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(Utils.clamp01(hsl.lightness + amount / 100.0)).toColor();
  }
}
