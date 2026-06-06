import 'package:flutter/material.dart';
// The style files live in:  lib/utils/styles/
// So every import goes UP one level (..) then INTO styles/
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// Wire every design token into Flutter's ThemeData so that
/// Material widgets (ElevatedButton, TextButton, Card, etc.) all
/// automatically pick up the correct style — no manual styling needed
/// on each widget call site.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'OpenSans',

    // ── Color scheme ─────────────────────────────────
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.teal,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),

    // ── Scaffold ─────────────────────────────────────
    scaffoldBackgroundColor: AppColors.background2,

    // ── AppBar ───────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.heroTitle,
    ),

    // ── Card ─────────────────────────────────────────
    // Flutter ≥ 3.19: CardTheme → CardThemeData
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      margin: EdgeInsets.zero,
    ),

    // ── ElevatedButton ───────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 0,
      ),
    ),

    // ── TextButton ───────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
      ),
    ),

    // ── OutlinedButton ───────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: const StadiumBorder(),
      ),
    ),

    // ── FAB ──────────────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryXLight,
      foregroundColor: AppColors.primary,
      shape: CircleBorder(),
      elevation: 2,
    ),

    // ── Divider ──────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // ── Input ────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryXLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primaryXXLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primaryXXLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textDisabled),
      labelStyle: AppTextStyles.labelMd,
    ),

    // ── Dialog ───────────────────────────────────────
    // Flutter ≥ 3.19: DialogTheme → DialogThemeData
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      backgroundColor: AppColors.surface,
      titleTextStyle: AppTextStyles.cardTitle,
      contentTextStyle: AppTextStyles.bodyMd,
    ),

    // ── Tooltip ──────────────────────────────────────
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: AppColors.primary),
      textStyle: TextStyle(color: Colors.white, fontSize: 12),
    ),

    // ── Bottom Sheet ─────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
    ),
  );
}