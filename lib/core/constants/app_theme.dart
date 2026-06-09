// lib/core/constants/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Palette ──────────────────────────────────────────────
  static const Color background   = Color(0xFF0D0D1A);
  static const Color surface      = Color(0xFF16162A);
  static const Color surfaceAlt   = Color(0xFF1E1E36);
  static const Color accent       = Color(0xFF7B61FF);
  static const Color accentGlow   = Color(0x557B61FF);
  static const Color gold         = Color(0xFFFFD166);
  static const Color textPrimary  = Color(0xFFF0F0FF);
  static const Color textSecondary= Color(0xFF8888AA);
  static const Color divider      = Color(0xFF2A2A4A);
  static const Color error        = Color(0xFFFF6B6B);
  static const Color shimmerBase  = Color(0xFF1E1E36);
  static const Color shimmerHigh  = Color(0xFF2C2C50);

  // ── Text styles ───────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.orbitron(
    fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary,
    letterSpacing: 1.2,
  );

  static TextStyle get titleLarge => GoogleFonts.orbitron(
    fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14, color: textSecondary, height: 1.5,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: textSecondary, letterSpacing: 0.8,
  );

  static TextStyle get statValue => GoogleFonts.orbitron(
    fontSize: 20, fontWeight: FontWeight.w700, color: gold,
  );

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      background: background,
      surface: surface,
      primary: accent,
      secondary: gold,
      error: error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: displayLarge.copyWith(fontSize: 20),
      iconTheme: const IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
  );
}
