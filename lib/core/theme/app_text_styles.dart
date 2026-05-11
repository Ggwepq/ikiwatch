import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system: Source Serif 4 for headlines, Manrope for body/UI
abstract final class AppTextStyles {
  // Display
  static TextStyle displayLarge = GoogleFonts.sourceSerif4(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: -0.96,
  );

  static TextStyle displayLargeMobile = GoogleFonts.sourceSerif4(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.36,
  );

  // Headlines
  static TextStyle headlineMedium = GoogleFonts.sourceSerif4(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.sourceSerif4(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  // Labels
  static TextStyle labelMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.42,
  );

  static TextStyle labelSmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.6,
  );

  // App brand title
  static TextStyle brandTitle = GoogleFonts.sourceSerif4(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.5,
  );
}
