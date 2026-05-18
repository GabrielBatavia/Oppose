import 'package:flutter/material.dart';

import 'oppose_colors.dart';
import 'oppose_radius.dart';
import 'oppose_typography.dart';

class OpposeTheme {
  const OpposeTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: OpposeColors.maroon,
      brightness: Brightness.light,
      primary: OpposeColors.maroon,
      secondary: OpposeColors.mint,
      surface: OpposeColors.paper,
      error: OpposeColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: OpposeColors.cream,
      textTheme: OpposeTypography.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: OpposeColors.cream,
        foregroundColor: OpposeColors.softInk,
        elevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: OpposeColors.maroon,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OpposeRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OpposeColors.maroon,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: OpposeColors.maroon, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OpposeRadius.lg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OpposeColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpposeRadius.md),
          borderSide: const BorderSide(color: OpposeColors.warmBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpposeRadius.md),
          borderSide: const BorderSide(color: OpposeColors.warmBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OpposeRadius.md),
          borderSide: const BorderSide(color: OpposeColors.maroon, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: OpposeColors.paper,
        indicatorColor: OpposeColors.mint.withValues(alpha: 0.32),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? OpposeColors.maroon
                : OpposeColors.mutedGray,
          ),
        ),
      ),
    );
  }
}
