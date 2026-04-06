import 'dart:math';

import 'package:flutter/material.dart';

/// Dark avatar fills derived from [patientId] via a seeded PRNG (stable per row).
abstract final class PatientAvatarPalette {
  PatientAvatarPalette._();

  static Color backgroundForPatientId(int patientId) {
    if (patientId < 0) {
      return const Color(0xFF4B5563);
    }
    final Random rng = Random(patientId ^ 0x6A09E667);
    final double hue = rng.nextDouble() * 360;
    final double saturation = 0.42 + rng.nextDouble() * 0.38;
    final double value = 0.22 + rng.nextDouble() * 0.28;
    return HSVColor.fromAHSV(1, hue, saturation, value).toColor();
  }
}
