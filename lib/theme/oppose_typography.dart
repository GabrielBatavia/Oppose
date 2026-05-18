import 'package:flutter/material.dart';

import 'oppose_colors.dart';

class OpposeTypography {
  const OpposeTypography._();

  static TextTheme get textTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      color: OpposeColors.softInk,
      height: 1.05,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: OpposeColors.softInk,
      height: 1.12,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: OpposeColors.softInk,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: OpposeColors.softInk,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: OpposeColors.softInk,
      height: 1.45,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: OpposeColors.mutedGray,
      height: 1.4,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.1,
    ),
  );
}
