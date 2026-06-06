import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ─────────────────────────────────────────────
/// NIYOJAN TYPOGRAPHY SYSTEM
/// Senior-friendly: min 14px, KPI values large & bold
/// Font: Plus Jakarta Sans (via google_fonts)
/// ─────────────────────────────────────────────
abstract final class AppTypography {

  // ── Display / Hero ──
  static const TextStyle heroTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    letterSpacing: 0.1,
  );

  // ── KPI Numbers (large, bold, prominent) ──
  static const TextStyle kpiValueXL = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle kpiValueLG = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.6,
    height: 1.1,
  );

  static const TextStyle kpiValueMD = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.4,
    height: 1.1,
  );

  static const TextStyle heroKpiValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.6,
    height: 1.0,
  );

  // ── Labels & Body ──
  static const TextStyle labelSM = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.6,
  );

  static const TextStyle labelMD = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.1,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.1,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle alertTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.1,
  );

  static const TextStyle alertValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textMid,
    letterSpacing: 0.8,
  );

  static const TextStyle seeAll = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.blueLight,
  );

  static const TextStyle progressLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle progressValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.0,
  );

  static const TextStyle miniLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static const TextStyle miniValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const TextStyle dataRowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle dataRowValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const TextStyle profitRowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle profitRowValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const TextStyle profitHighlightValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.green,
    letterSpacing: -0.5,
  );
}
