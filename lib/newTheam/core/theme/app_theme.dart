import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// ─────────────────────────────────────────────
/// NIYOJAN APP THEME
/// Material 3 + brand token override
/// ─────────────────────────────────────────────
final class AppTheme {

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary:           AppColors.blue,
      onPrimary:         Colors.white,
      primaryContainer:  AppColors.blueXXL,
      onPrimaryContainer: AppColors.blueDark,
      secondary:         AppColors.teal,
      onSecondary:       Colors.white,
      secondaryContainer: AppColors.tealXXL,
      onSecondaryContainer: AppColors.teal,
      tertiary:          AppColors.orange,
      onTertiary:        Colors.white,
      error:             AppColors.red,
      onError:           Colors.white,
      surface:           AppColors.white,
      onSurface:         AppColors.text,
      surfaceContainerHighest: AppColors.bg2,
      outline:           AppColors.border,
      outlineVariant:    AppColors.border2,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bg2,

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.blue,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: EdgeInsets.zero,
        shadowColor: const Color(0x141E3A8A),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blueLight,
        unselectedItemColor: AppColors.textMuted,
        elevation: 0,
      ),

      // ── Icon ──
      iconTheme: const IconThemeData(
        color: AppColors.textMid,
        size: 22,
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.blueXL,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.blue,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide.none,
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF1F5F9),
        thickness: 1,
        space: 0,
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // ── Splash / Ripple ──
      splashColor: AppColors.blueXXL,
      highlightColor: Colors.transparent,

      // ── Page Transitions ──
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
