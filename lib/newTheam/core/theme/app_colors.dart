import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────
/// NIYOJAN BRAND COLOR TOKENS
/// Mirrors CSS design-system in niyojan_v4_final_1.html
/// ─────────────────────────────────────────────
abstract final class AppColors {
  // ── Primary palette ──
  static const Color blue        = Color(0xFF1E3A8A);
  static const Color blueLight   = Color(0xFF2D52C5);
  static const Color blueDark    = Color(0xFF162D70);
  static const Color blueXL      = Color(0xFFEFF6FF);
  static const Color blueXXL     = Color(0xFFDBEAFE);

  static const Color teal        = Color(0xFF0F766E);
  static const Color tealLight   = Color(0xFF14B8A8);
  static const Color tealXL      = Color(0xFFF0FDFA);
  static const Color tealXXL     = Color(0xFFCCFBF1);

  static const Color orange      = Color(0xFFF97316);
  static const Color orangeLight = Color(0xFFFB923C);
  static const Color orangeXL    = Color(0xFFFFF7ED);
  static const Color orangeXXL   = Color(0xFFFFEDD5);

  static const Color red         = Color(0xFFEF4444);
  static const Color redXL       = Color(0xFFFEF2F2);
  static const Color redXXL      = Color(0xFFFECACA);

  static const Color green       = Color(0xFF16A34A);
  static const Color greenXL     = Color(0xFFF0FDF4);
  static const Color greenXXL    = Color(0xFFDCFCE7);

  static const Color amber       = Color(0xFFD97706);
  static const Color amberXL     = Color(0xFFFFFBEB);

  // ── Neutral ──
  static const Color bg          = Color(0xFFF8FAFC);
  static const Color bg2         = Color(0xFFF1F5FE);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color text        = Color(0xFF111827);
  static const Color textMid     = Color(0xFF374151);
  static const Color textMuted   = Color(0xFF6B7280);
  static const Color border      = Color(0xFFE2E8F0);
  static const Color border2     = Color(0xFFCBD5E1);
  static const Color shadowCard     = Color(0x0D1E3A8A);
  static const Color divider        = Color(0xFFF1F5F9);

  // ── Gradients ──
  static const LinearGradient gradPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF1E3A8A), Color(0xFF1D6B7A), Color(0xFF0F766E)],
  );

  static const LinearGradient gradHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.6, 1.0],
    colors: [Color(0xFF1E3A8A), Color(0xFF1D5A72), Color(0xFF0F766E)],
  );

  static const LinearGradient gradAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D52C5), Color(0xFF0EA5A0)],
  );

  static const LinearGradient gradGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF059669)],
  );

  static const LinearGradient gradWarn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC2410C), Color(0xFFD97706)],
  );

  static const LinearGradient gradRed = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB91C1C), Color(0xFFDC2626)],
  );

  static const LinearGradient gradPageBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.52, 1.0],
    colors: [Color(0xFFEBF0FF), Color(0xFFF8FAFC), Color(0xFFE8FBF9)],
  );
}
