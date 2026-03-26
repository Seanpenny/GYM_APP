import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Safely loads Google Fonts without throwing exceptions
/// Falls back to system fonts if loading fails
class SafeFonts {
  /// Safely get Inter Tight font, falls back to system font if loading fails
  static TextStyle interTight({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    try {
      return GoogleFonts.interTight(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    } catch (e) {
      // Fallback to system font if Google Fonts fails
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontFamily: 'Roboto',
      );
    }
  }
}












