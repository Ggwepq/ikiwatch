import 'package:flutter/material.dart';

/// Ikigai-inspired color palette from DESIGN.md
/// Earthy, botanical spectrum — sage greens, muted indigo, warm grays
abstract final class AppColors {
  // Primary — Sage Green
  static const primary = Color(0xFF334537);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF4A5D4E);
  static const onPrimaryContainer = Color(0xFFC0D5C2);
  static const inversePrimary = Color(0xFFB7CCB9);
  static const primaryFixed = Color(0xFFD3E8D5);
  static const primaryFixedDim = Color(0xFFB7CCB9);
  static const onPrimaryFixed = Color(0xFF0E1F13);
  static const onPrimaryFixedVariant = Color(0xFF394B3D);

  // Secondary — Muted Indigo
  static const secondary = Color(0xFF5A5C79);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDCDDFF);
  static const onSecondaryContainer = Color(0xFF5E617D);
  static const secondaryFixed = Color(0xFFDFE0FF);
  static const secondaryFixedDim = Color(0xFFC2C4E5);
  static const onSecondaryFixed = Color(0xFF161A32);
  static const onSecondaryFixedVariant = Color(0xFF424560);

  // Tertiary — Earthy Green
  static const tertiary = Color(0xFF394610);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF505E26);
  static const onTertiaryContainer = Color(0xFFC6D792);
  static const tertiaryFixed = Color(0xFFD9EAA3);
  static const tertiaryFixedDim = Color(0xFFBDCE89);
  static const onTertiaryFixed = Color(0xFF161F00);
  static const onTertiaryFixedVariant = Color(0xFF3E4C16);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Surfaces — Warm Grays / Parchment
  static const surface = Color(0xFFF9F9F7);
  static const surfaceDim = Color(0xFFDADAD8);
  static const surfaceBright = Color(0xFFF9F9F7);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF4F4F2);
  static const surfaceContainer = Color(0xFFEEEEEC);
  static const surfaceContainerHigh = Color(0xFFE8E8E6);
  static const surfaceContainerHighest = Color(0xFFE2E3E1);
  static const onSurface = Color(0xFF1A1C1B);
  static const onSurfaceVariant = Color(0xFF434843);
  static const inverseSurface = Color(0xFF2F3130);
  static const inverseOnSurface = Color(0xFFF1F1EF);
  static const surfaceTint = Color(0xFF506354);
  static const surfaceVariant = Color(0xFFE2E3E1);

  // Outline
  static const outline = Color(0xFF737872);
  static const outlineVariant = Color(0xFFC3C8C1);

  // Background (same as surface in M3)
  static const background = Color(0xFFF9F9F7);
  static const onBackground = Color(0xFF1A1C1B);

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        inversePrimary: inversePrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        surfaceTint: surfaceTint,
        outline: outline,
        outlineVariant: outlineVariant,
      );
}
