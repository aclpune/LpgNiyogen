// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// /// Centralized typography system.
// ///
// /// Naming convention:
// ///   AppTextStyles.<role><Size?><Variant?>
// ///
// /// Roles:  heading, body, label, caption, button, badge, hero
// /// Sizes:  sm, md, lg, xl  (omit when obvious from the role)
// /// Variants: bold, muted, link, success, error, warning
// class AppTextStyles {
//   AppTextStyles._();
//
//   // ── Base font families ────────────────────────────────────
//   static const String _fontInter    = 'Inter';
//   static const String _fontOpenSans = 'OpenSans';
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  HERO (full-screen gradient header)              ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle heroTitle = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     fontFamily: _fontInter,
//     letterSpacing: -0.5,
//     height: 1.2,
//   );
//
//   static const TextStyle heroSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: Colors.white70,
//     fontFamily: _fontOpenSans,
//   );
//     static const TextStyle heroScreenLabel = TextStyle(
//     color: Colors.white70,
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.8,
//     fontFamily: _fontInter,
//   );
//
//     static const TextStyle heroBadge = TextStyle(
//     color: Colors.white,
//     fontSize: 13,
//     fontWeight: FontWeight.w700,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle heroKpiValue = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.6,
//     height: 1.0,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  SECTION HEADER                                  ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// All-caps section label used above form/info cards (e.g. "ADD CYLINDER ENTRY").
//   static const TextStyle sectionHeader = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textSecondary,
//     letterSpacing: 0.8,
//     fontFamily: _fontInter,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  CARD CONTENT                                    ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle cardTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     fontFamily: _fontInter,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle cardSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//     height: 1.4,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  KPI / METRIC VALUES                             ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle kpiValue = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: AppColors.textPrimary,
//     fontFamily: _fontInter,
//     letterSpacing: -0.6,
//     height: 1.1,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  DATA / TABLE                                    ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle dataLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textSecondary,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle dataValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     color: AppColors.textPrimary,
//     fontFamily: _fontInter,
//   );
//
//   /// Table header cell — white bold text used inside primary-colored header rows.
//   static const TextStyle tableHeaderCell = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//     letterSpacing: 0.3,
//     fontFamily: _fontInter,
//   );
//
//     static const TextStyle tableHeader = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textSecondary,
//     fontFamily: _fontInter,
//     letterSpacing: 0.1,
//   );
//
//   /// Table data cell — secondary-color, centered.
//   static const TextStyle tableDataCell = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textSecondary,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Table row item name (first column, larger and primary color).
//   static const TextStyle tableRowItem = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  LABEL (compact inline tag / chip label)         ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle labelMd = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle labelSm = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//     letterSpacing: 0.1,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  FORM                                            ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// Label above each form field (e.g. "Item", "Total Sale").
//   static const TextStyle formFieldLabel = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textSecondary,
//     letterSpacing: 0.2,
//     fontFamily: _fontInter,
//   );
//
//   /// Input text inside text fields and dropdowns.
//   static const TextStyle formFieldInput = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Dropdown item text (item name in dropdown menus).
//   static const TextStyle dropdownItem = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Hint text shown inside text fields.
//   static const TextStyle formHint = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textDisabled,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Hint text for dropdown "Select …" placeholder.
//   static const TextStyle dropdownHint = TextStyle(
//     fontSize: 14,
//     color: AppColors.textDisabled,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  INFO CARD ROW                                   ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// Muted uppercase-ish label in info rows (e.g. "Delivery Date").
//   static const TextStyle infoRowLabel = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     letterSpacing: 0.3,
//     fontFamily: _fontInter,
//   );
//
//   /// Primary value text in info rows.
//   static const TextStyle infoRowValue = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  BOTTOM SHEET / MODAL                            ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// Title of modal bottom sheets (e.g. "Update Customer Details").
//   static const TextStyle sheetTitle = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//     fontFamily: _fontInter,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  BADGE / STATUS PILL                             ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle badge = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.1,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  BUTTON                                          ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle button = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     fontFamily: _fontOpenSans,
//     color: Colors.white,
//   );
//
//   /// Submit / primary large button text (slightly bigger).
//   static const TextStyle submitButton = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle buttonSm = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  BODY / GENERAL TEXT                             ║
//   // ╚══════════════════════════════════════════════════╝
//   static const TextStyle bodyLg = TextStyle(
//     fontSize: 16,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//     height: 1.5,
//   );
//
//   static const TextStyle bodyMd = TextStyle(
//     fontSize: 14,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//     height: 1.5,
//   );
//
//   static const TextStyle bodySm = TextStyle(
//     fontSize: 12,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//     height: 1.5,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  DELIVERY SCREEN — card & list typography        ║
//   // ╚══════════════════════════════════════════════════╝
//
//   static const TextStyle deliveryCardName = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     fontFamily: _fontInter,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle deliveryAvatarInitial = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     color: AppColors.primaryLight,
//     fontFamily: _fontInter,
//   );
//
//   static const TextStyle deliveryCardSaleLabel = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle deliveryCardSaleValue = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w800,
//     color: AppColors.primaryLight,
//     fontFamily: _fontInter,
//   );
//
//   static const TextStyle searchInput = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textPrimary,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle searchHint = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//   );
//
//   static const TextStyle emptyStateTitle = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     fontFamily: _fontInter,
//   );
//
//   static const TextStyle emptyStateSubtitle = TextStyle(
//     fontSize: 13,
//     color: AppColors.textMuted,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  CHECKBOX CHIP                                   ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// Label text inside a selected checkbox chip.
//   static const TextStyle checkboxChipSelected = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//     color: AppColors.primary,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Label text inside an unselected checkbox chip.
//   static const TextStyle checkboxChipUnselected = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textSecondary,
//     fontFamily: _fontOpenSans,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  WARNING / IMBALANCE PANEL                       ║
//   // ╚══════════════════════════════════════════════════╝
//
//   /// Body text inside amber warning / imbalance panels.
//   static const TextStyle warningBody = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.warningText,
//     fontFamily: _fontOpenSans,
//   );
//
//   /// Bold label inside warning panels.
//   static const TextStyle warningLabel = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     color: AppColors.warningText,
//     fontFamily: _fontOpenSans,
//   );
//     static const TextStyle heroScreenTitle = TextStyle(
//     color: Colors.white,
//     fontSize: 20,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.4,
//     fontFamily: _fontInter,
//   );
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  SEMANTIC VARIANTS (link, success, error …)      ║
//   // ╚══════════════════════════════════════════════════╝
//   static final TextStyle link = bodyMd.copyWith(
//     color: AppColors.legacyBlue,
//     decoration: TextDecoration.underline,
//     decorationColor: AppColors.legacyBlue,
//   );
//
//   static final TextStyle linkDisabled = link.copyWith(color: AppColors.textDisabled);
//
//   static final TextStyle success = bodyMd.copyWith(color: AppColors.success);
//   static final TextStyle error   = bodyMd.copyWith(color: AppColors.error);
//   static final TextStyle warning = bodyMd.copyWith(color: AppColors.warning);
//
//   // ╔══════════════════════════════════════════════════╗
//   // ║  LEGACY ALIASES (map to old Styling.dart names)  ║
//   // ╚══════════════════════════════════════════════════╝
//   ///
//   /// Use these ONLY inside legacy screens that haven't been migrated yet.
//   /// Prefer the semantic names above for all new code.
//   ///
//   static TextStyle get legacyBodyTitle       => bodyLg;
//   static TextStyle get legacyBodyTitleBig    => bodyLg;
//   static TextStyle get legacyTextFormText    => bodyMd;
//   static TextStyle get legacyItemTitle       => bodyMd.copyWith(color: AppColors.legacyBlue);
//   static TextStyle get legacyBlueClrText     => bodyMd.copyWith(color: AppColors.legacyBlue);
// }


import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography system.
///
/// Naming convention:
///   AppTextStyles.<role><Size?><Variant?>
///
/// Roles:  heading, body, label, caption, button, badge, hero
/// Sizes:  sm, md, lg, xl  (omit when obvious from the role)
/// Variants: bold, muted, link, success, error, warning
class AppTextStyles {
  AppTextStyles._();

  // ── Base font families ────────────────────────────────────
  static const String _fontInter    = 'Inter';
  static const String _fontOpenSans = 'OpenSans';

  // ╔══════════════════════════════════════════════════╗
  // ║  HERO (full-screen gradient header)              ║
  // ╚══════════════════════════════════════════════════╝

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
  static const TextStyle heroTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    fontFamily: _fontInter,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static const TextStyle kpiValueLG = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.6,
    height: 1.1,
  );
  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );
  static const TextStyle seeAll = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.blueLight,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle heroScreenLabel = TextStyle(
    color: Colors.white70,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    fontFamily: _fontInter,
  );

  static const TextStyle heroBadge = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle heroKpiValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.6,
    height: 1.0,
  );

  static const TextStyle heroScreenTitle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    fontFamily: _fontInter,
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
  // ╔══════════════════════════════════════════════════╗
  // ║  SECTION HEADER                                  ║
  // ╚══════════════════════════════════════════════════╝

  /// All-caps section label used above form/info cards (e.g. "ADD CYLINDER ENTRY").
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
    fontFamily: _fontInter,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  CARD CONTENT                                    ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: _fontInter,
    letterSpacing: -0.1,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
    height: 1.4,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  KPI / METRIC VALUES                             ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle kpiValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    fontFamily: _fontInter,
    letterSpacing: -0.6,
    height: 1.1,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  DATA / TABLE                                    ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle dataLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle dataValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    fontFamily: _fontInter,
  );

  /// Table header cell — white bold text used inside primary-colored header rows.
  static const TextStyle tableHeaderCell = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.3,
    fontFamily: _fontInter,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    fontFamily: _fontInter,
    letterSpacing: 0.1,
  );

  /// Table data cell — secondary-color, centered.
  static const TextStyle tableDataCell = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFamily: _fontOpenSans,
  );

  /// Table row item name (first column, larger and primary color).
  static const TextStyle tableRowItem = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  LABEL (compact inline tag / chip label)         ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle labelMd = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
    letterSpacing: 0.1,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  FORM                                            ║
  // ╚══════════════════════════════════════════════════╝

  /// Label above each form field (e.g. "Item", "Total Sale").
  static const TextStyle formFieldLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    fontFamily: _fontInter,
  );

  /// Input text inside text fields and dropdowns.
  static const TextStyle formFieldInput = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
  );

  /// Dropdown item text (item name in dropdown menus).
  static const TextStyle dropdownItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: _fontOpenSans,
  );

  /// Hint text shown inside text fields.
  static const TextStyle formHint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
    fontFamily: _fontOpenSans,
  );

  /// Hint text for dropdown "Select …" placeholder.
  static const TextStyle dropdownHint = TextStyle(
    fontSize: 14,
    color: AppColors.textDisabled,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  INFO CARD ROW                                   ║
  // ╚══════════════════════════════════════════════════╝

  /// Muted uppercase-ish label in info rows (e.g. "Delivery Date").
  static const TextStyle infoRowLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
    fontFamily: _fontInter,
  );

  /// Primary value text in info rows.
  static const TextStyle infoRowValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  BOTTOM SHEET / MODAL                            ║
  // ╚══════════════════════════════════════════════════╝

  /// Title of modal bottom sheets (e.g. "Update Customer Details").
  static const TextStyle sheetTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: _fontInter,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  BADGE / STATUS PILL                             ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  BUTTON                                          ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: _fontOpenSans,
    color: Colors.white,
  );

  /// Submit / primary large button text (slightly bigger).
  static const TextStyle submitButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle buttonSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  BODY / GENERAL TEXT                             ║
  // ╚══════════════════════════════════════════════════╝
  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
    height: 1.5,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
    height: 1.5,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
    height: 1.5,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  DELIVERY SCREEN — card & list typography        ║
  // ╚══════════════════════════════════════════════════╝

  static const TextStyle deliveryCardName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: _fontInter,
    letterSpacing: -0.1,
  );

  static const TextStyle deliveryAvatarInitial = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryLight,
    fontFamily: _fontInter,
  );

  static const TextStyle deliveryCardSaleLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle deliveryCardSaleValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryLight,
    fontFamily: _fontInter,
  );

  static const TextStyle searchInput = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
  );

  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: _fontInter,
  );

  static const TextStyle emptyStateSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  CHECKBOX CHIP                                   ║
  // ╚══════════════════════════════════════════════════╝

  /// Label text inside a selected checkbox chip.
  static const TextStyle checkboxChipSelected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFamily: _fontOpenSans,
  );

  /// Label text inside an unselected checkbox chip.
  static const TextStyle checkboxChipUnselected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  WARNING / IMBALANCE PANEL                       ║
  // ╚══════════════════════════════════════════════════╝

  /// Body text inside amber warning / imbalance panels.
  static const TextStyle warningBody = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.warningText,
    fontFamily: _fontOpenSans,
  );

  /// Bold label inside warning panels.
  static const TextStyle warningLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.warningText,
    fontFamily: _fontOpenSans,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  STOCK SUBMIT TO MANAGER                         ║
  // ╚══════════════════════════════════════════════════╝

  /// Delivery-man name in card header (15/w700/textPrimary/-0.1).
  /// Reuses AppTextStyles.cardTitle — kept as alias for clarity at call sites.
  static const TextStyle deliveryManName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  /// Vehicle number / sub-label under delivery-man name.
  static const TextStyle deliveryManVehicle = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
    fontWeight: FontWeight.w500,
  );

  /// Avatar initial character inside delivery-man avatar badge.
  /// Color applied dynamically (= status color).
  static const TextStyle deliveryManAvatarInitial = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    // color applied dynamically via copyWith(color: _statusColor)
  );

  /// Status pill label text (11/w700). Color applied dynamically.
  static const TextStyle statusPillLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    // color applied dynamically via copyWith(color: _statusColor)
  );

  /// Section label (TOTAL SALE / DELIVERY MEN WISE SALE).
  static const TextStyle submitSectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  /// Stock table column header text. Color applied dynamically.
  static const TextStyle stockTableHeader = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    // color applied dynamically via copyWith(color: textColor)
  );

  /// Stock table data cell text.
  static const TextStyle stockTableRow = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// "No pending data" / section placeholder message.
  static const TextStyle sectionPlaceholder = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
    fontWeight: FontWeight.w500,
  );

  /// Error body sub-label ("Could not load data").
  static const TextStyle errorTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Error detail message text.
  static const TextStyle errorDetail = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );

  /// Empty / no-data heading ("No Data Found").
  static const TextStyle emptyTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Empty / no-data subtitle ("Pull down to refresh").
  static const TextStyle emptySubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );

  /// Search bar input text.
  static const TextStyle searchBarInput = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  /// Search bar hint text.
  static const TextStyle searchBarHint = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
    fontWeight: FontWeight.w400,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  SEMANTIC VARIANTS (link, success, error …)      ║
  // ╚══════════════════════════════════════════════════╝
  static final TextStyle link = bodyMd.copyWith(
    color: AppColors.legacyBlue,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.legacyBlue,
  );

  /// Muted label above vehicle number. Was: fontSize:10, w600, letterSpacing:0.3
  static const TextStyle itemReturnVehicleLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  /// Vehicle number value (card header & SQC list). Was: fontSize:15, w800, letterSpacing:-0.2
  static const TextStyle itemReturnVehicleNo = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  /// Status badge ("Out" / "Pending"). Was: fontSize:10, w700
  static const TextStyle itemReturnStatusBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  /// Receipt date text. Was: fontSize:11, w500
  static const TextStyle itemReturnDateText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  /// Item name inside expanded row. Was: fontSize:13, w700
  static const TextStyle itemReturnItemName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  /// Stock chip label (e.g. "Stk: 12"). Was: fontSize:10, w700
  static const TextStyle itemReturnStockChipText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  /// Qty row label (Filled Qty / EMR Qty etc.). Was: fontSize:10, w600, letterSpacing:0.2
  static const TextStyle itemReturnQtyLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  /// Qty row value. Was: fontSize:16, w800, letterSpacing:-0.3
  static const TextStyle itemReturnQtyValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  /// "View More" / "View Less" toggle. Was: fontSize:12, w600
  static const TextStyle itemReturnViewToggle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  /// "Out" ElevatedButton label. Was: fontSize:14, w700
  static const TextStyle itemReturnOutBtnLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Dialog title. Was: fontSize:16, w700
  static const TextStyle itemReturnDialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Item name inside dialog item header chip. Was: fontSize:14, w700
  static const TextStyle itemReturnDialogItemName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// "Close" TextButton in dialog. Was: fontSize:14, w700
  static const TextStyle itemReturnDialogClose = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  // ── SQC bottom sheet typography ───────────────────

  /// "SQC VEHICLES" all-caps sheet title. Was: fontSize:12, w700, letterSpacing:0.8
  static const TextStyle sqcSheetTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  /// "N pending" counter on the right of sheet header. Was: fontSize:12, w600
  static const TextStyle sqcPendingCount = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // ── FAB label ─────────────────────────────────────
  /// SQC FAB label. Was: TextStyle(fontWeight:w700, letterSpacing:0.5)
  static const TextStyle itemReturnFabLabel = TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static final TextStyle linkDisabled = link.copyWith(color: AppColors.textDisabled);

  static final TextStyle success = bodyMd.copyWith(color: AppColors.success);
  static final TextStyle error   = bodyMd.copyWith(color: AppColors.error);
  static final TextStyle warning = bodyMd.copyWith(color: AppColors.warning);

  // ╔══════════════════════════════════════════════════╗
  // ║  LEGACY ALIASES (map to old Styling.dart names)  ║
  // ╚══════════════════════════════════════════════════╝
  ///
  /// Use these ONLY inside legacy screens that haven't been migrated yet.
  /// Prefer the semantic names above for all new code.
  ///
  static TextStyle get legacyBodyTitle       => bodyLg;
  static TextStyle get legacyBodyTitleBig    => bodyLg;
  static TextStyle get legacyTextFormText    => bodyMd;
  static TextStyle get legacyItemTitle       => bodyMd.copyWith(color: AppColors.legacyBlue);
  static TextStyle get legacyBlueClrText     => bodyMd.copyWith(color: AppColors.legacyBlue);

  // ╔══════════════════════════════════════════════════╗
  // ║  ADD RETURN ITEM XMI SCREEN                      ║
  // ╚══════════════════════════════════════════════════╝

  /// Screen header title (18/w800/white/ls:-0.3) — _ScreenHeader widget.
  static const TextStyle screenHeaderTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.3,
  );

  /// Screen header subtitle (12/w500/white70) — _ScreenHeader widget.
  static const TextStyle screenHeaderSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  /// Small all-caps hero badge label (10/w700/white/ls:0.5) — _ScreenHeader mode badge.
  static const TextStyle heroBadgeLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  /// Above-field label (11/w700/textMuted/ls:0.4) — _FieldLabel widget.
  static const TextStyle fieldLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.4,
  );

  /// Required-field asterisk (12/w800/red) — _FieldLabel & _StyledField widgets.
  static const TextStyle requiredStar = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.red,
  );

  /// Input text inside styled text fields (14/w600/textPrimary) — _StyledTextField.
  static const TextStyle fieldInputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Hint text inside styled text fields (13/textMuted) — _StyledTextField.
  static const TextStyle fieldHintText = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );

  /// Dropdown selected/item text (13/w600/textPrimary) — _StyledDropdown.
  static const TextStyle dropdownInputText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Submit button label (15/w700/white/ls:0.2) — _SubmitButton widget.
  static const TextStyle submitBtnLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  ITEM RETURN XMI LIST SCREENS (NEW)              ║
  // ╚══════════════════════════════════════════════════╝

  /// Card header: vehicle number title line. Was: fontSize:15, w700, color:textPrimary, ls:-0.1
  static const TextStyle xmiVehicleNo = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  /// Card header: return date sub-line. Was: fontSize:13, w500, color:textMuted
  static const TextStyle xmiReturnDate = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  /// Status badge label (Received / Pending). Was: fontSize:11, w700; color dynamic
  static const TextStyle xmiStatusBadge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  /// Table column header (ITEM / STOCK / QTY labels). Was: fontSize:11, w700, color:textMuted, ls:0.5
  static const TextStyle xmiTableColHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  /// Item name in table row. Was: fontSize:13, w600, color:textSecondary
  static const TextStyle xmiItemName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Quantity cell value — primary-colored stock column. Was: fontSize:14, w700; color dynamic
  static const TextStyle xmiQtyValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Expand toggle label ("View More" / "View Less"). Was: fontSize:13, w600, color:primaryLight
  static const TextStyle xmiExpandToggle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryLight,
  );

  /// Action button label (In / Edit). Was: fontSize:14, w700
  static const TextStyle xmiActionBtnLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Dialog title. Was: fontSize:16, w700, color:textPrimary
  static const TextStyle xmiDialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Dialog item name label. Was: fontSize:14, w600, color:textSecondary
  static const TextStyle xmiDialogItemName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Loading state sub-label. Was: fontSize:14, w500, color:textMuted
  static const TextStyle xmiLoadingLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  SQC REGISTER SCREEN                             ║
  // ╚══════════════════════════════════════════════════╝

  /// Hero strip title (20/w800/white/ls:-0.4) — _SqcHeroStrip.
  /// Replaces _T.heroTitle hardcoded TextStyle in SQCRegisterScreen.
  static const TextStyle sqcHeroTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.4,
  );

  /// Hero strip subtitle (12/w500/white70) — _SqcHeroStrip.
  /// Replaces _T.heroSub hardcoded TextStyle.
  static const TextStyle sqcHeroSub = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  /// Field label above inputs (13/w600/textSecondary) — _ReadOnlyField, _WeightField, _InlineField, _DropdownField.
  /// Replaces _T.fieldLabel hardcoded TextStyle.
  static const TextStyle sqcFieldLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Section header all-caps text (11/w700/textSecondary/ls:0.8) — _SectionHeader.
  /// Replaces _T.sectionHdr hardcoded TextStyle.
  static const TextStyle sqcSectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  /// Input field text style (14/w600) — _WeightField, DPT Date TextFormField.
  /// Replaces inline TextStyle(fontSize:14, fontWeight:w600).
  static const TextStyle sqcInputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Weight field bold value (14/w700) — _WeightField style.
  static const TextStyle sqcWeightValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Upload button primary label (14/w700/red) — defect upload card.
  static const TextStyle sqcUploadLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.red,
  );

  /// Upload button sub-label (12/textMuted) — "Image, Video, or ZIP • Max 5MB".
  static const TextStyle sqcUploadSubLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  /// ZIP chip filename (13/w600/textSecondary) — zip indicator row.
  static const TextStyle sqcZipFilename = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Required asterisk inside label Text.rich (*) — _DropdownField, _WeightField, _InlineField.
  static const TextStyle sqcRequiredStar = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
  );

  /// Hint text inside input fields (13/textMuted) — _inputDecoration, _WeightField.
  static const TextStyle sqcHintText = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
  );

  /// Dropdown hint "Select..." text (13/textMuted) — _DropdownField.
  static const TextStyle sqcDropdownHint = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
  );

  /// Dropdown value/option text (14/w600/textPrimary) — _DropdownField.
  static const TextStyle sqcDropdownValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Queue table column header (11/w700/primary/ls:0.4) — _QueuedItemsCard header row.
  static const TextStyle sqcQueueColHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.4,
  );

  /// Queue item serial number (13/w700/textPrimary) — _QueuedItemsCard row.
  static const TextStyle sqcQueueSerial = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Queue item DPT date (13/w600/textSecondary) — _QueuedItemsCard row.
  static const TextStyle sqcQueueDptDate = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Queue leaky badge label (10/w700/red) — _QueuedItemsCard leaky chip.
  static const TextStyle sqcLeakyBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.red,
  );

  /// Queue item sub-info (11/textMuted) — item id line.
  static const TextStyle sqcQueueItemInfo = TextStyle(
    fontSize: 11,
    color: AppColors.textMuted,
  );

  /// No-pending-items placeholder (13/textMuted) — empty queue / empty receipt.
  static const TextStyle sqcEmptyPlaceholder = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
  );

  /// Receipt card serial title (14/w700/textPrimary) — _ReceiptListCard.
  static const TextStyle sqcReceiptSerial = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Receipt card item name sub-line (12/textMuted) — _ReceiptListCard.
  static const TextStyle sqcReceiptItemName = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  /// Receipt edit button label (12/w700) — color is dynamic (saveFlag).
  static const TextStyle sqcReceiptEditBtn = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  /// Metric pill value (13/w800/textPrimary) — _MetricPill.
  static const TextStyle sqcMetricValue = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Metric pill label (10/w600/textMuted) — _MetricPill.
  static const TextStyle sqcMetricLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );

  /// AlertDialog "Remove Item" title (16/w700) — delete-item dialog.
  static const TextStyle sqcDialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Cancel button label (14/w700) — OutlinedButton.
  static const TextStyle sqcCancelBtnLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Save/Update button label (15/w700) — ElevatedButton.
  static const TextStyle sqcSaveBtnLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Add-to-Queue button label (14/w700) — ElevatedButton.icon.
  static const TextStyle sqcAddBtnLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Hero vehicle badge text (12/w700/white) — _SqcHeroStrip vehicle pill.
  static const TextStyle sqcHeroVehicleText = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  /// Hero icon letter (SQC / E) (11/w800/white/ls:0.3) — _SqcHeroStrip.
  static const TextStyle sqcHeroIconLabel = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
  );

  /// Bottom-sheet media option title (14/w600) — showCameraOptions ListTile.
  static const TextStyle sqcMediaOptionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// "No records found" empty receipt label (13/w500/textMuted) — _ReceiptListCard.
  static const TextStyle sqcNoRecordsLabel = TextStyle(
    color: AppColors.textMuted,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Loading-video placeholder label (12/textMuted) — _LoadingVideoBox.
  static const TextStyle sqcLoadingVideoLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  /// Read-only field value text — empty state uses textMuted, filled uses textPrimary.
  /// Used with .copyWith(color: ...) dynamically. Base: 14/w700.
  static const TextStyle sqcReadOnlyValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// "textWidgetBlueColorWithoutStar" text (16/primaryLight) — legacy helper retained.
  static const TextStyle sqcLegacyBlueLabel = TextStyle(
    color: AppColors.primaryLight,
    fontSize: 16,
  );

  // ╔══════════════════════════════════════════════════╗
  // ║  MORE OPTION SCREEN (GodownKeeper)               ║
  // ╚══════════════════════════════════════════════════╝

  /// All-caps section label above each menu group (11/w700/textSecondary/ls:0.8).
  /// Was: inline TextStyle in _SectionLabel.
  static const TextStyle moreOptionsSectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  /// Menu tile primary label — normal state (15/w700/textPrimary/ls:-0.1).
  /// Was: inline TextStyle in _MenuTile.
  static const TextStyle moreOptionsMenuLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  /// Menu tile primary label — destructive/logout state (15/w700/red/ls:-0.1).
  /// Was: inline TextStyle in _MenuTile with color: _C.red.
  static const TextStyle moreOptionsMenuLabelDestructive = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.red,
    letterSpacing: -0.1,
  );

  /// Menu tile subtitle line (12/w500/textMuted).
  /// Was: inline TextStyle in _MenuTile.
  static const TextStyle moreOptionsMenuSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  /// Logout dialog title text (16/w700/textPrimary).
  /// Was: inline TextStyle inside _showLogoutDialog AlertDialog title Row.
  static const TextStyle moreOptionsDialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Logout dialog content body (14/textSecondary).
  /// Was: inline TextStyle inside _showLogoutDialog AlertDialog content.
  static const TextStyle moreOptionsDialogContent = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  /// Hero header screen title (20/w800/white/ls:-0.4) — _HeroHeader.
  /// Was: inline TextStyle inside _HeroHeader Column.
  static const TextStyle moreOptionsHeroTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.4,
  );

  /// Hero header role subtitle (12/w500/white70) — _HeroHeader.
  /// Was: inline TextStyle inside _HeroHeader Column.
  static const TextStyle moreOptionsHeroSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );


  // ╔══════════════════════════════════════════════════╗
  // ║  IMBALANCE SHEET / SHOW UI                       ║
  // ╚══════════════════════════════════════════════════╝

  /// Sheet header title "Update Imbalance Stock" (17/w800/textPrimary/ls:-0.3).
  /// Was hardcoded in ImbalanceSheet _buildSheetHeader.
  static const TextStyle imbalanceSheetTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  /// History button label in ImbalanceSheet header (13/w700/primaryLight).
  /// Was hardcoded in ImbalanceSheet _buildSheetHeader.
  static const TextStyle imbalanceHistoryBtn = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryLight,
  );

  /// All-caps field section label above each form field (12/w700/textMuted/ls:0.6).
  /// Used by _SectionLabel in ImbalanceSheet.
  /// Was hardcoded inline as TextStyle(fontSize:12, fontWeight:w700, color:_C.textMuted, letterSpacing:0.6).
  static const TextStyle imbalanceSectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.6,
  );

  /// Input text inside _FieldCard TextFields (15/w700/textPrimary).
  /// Was hardcoded inline in ImbalanceSheet Total Sale / DM Imbalance fields.
  static const TextStyle imbalanceFieldInput = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Disabled/read-only field value (15/w700/textSecondary).
  /// Was hardcoded inline for the DM Total Imbalance read-only field.
  static const TextStyle imbalanceFieldInputMuted = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  /// Dropdown item/hint text (14/textMuted) in ImbalanceSheet dropdowns.
  /// Was hardcoded inline as TextStyle(color: _C.textMuted, fontSize: 14).
  static const TextStyle imbalanceDropdownHint = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  /// Dropdown item text (14) in ImbalanceSheet dropdowns.
  static const TextStyle imbalanceDropdownItem = TextStyle(
    fontSize: 14,
  );

  /// Table section label "CUSTOMER / DELIVERY MEN WISE LIST" (11/w700/textSecondary/ls:0.6).
  /// Was hardcoded in ImbalanceSheet _buildListSection.
  static const TextStyle imbalanceListSectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.6,
  );

  /// Table column header text (11/w700/primary/ls:0.4) — _TableHeader / _ColHead.
  /// Was hardcoded in ImbalanceSheet _TableHeader.
  static const TextStyle imbalanceColHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.4,
  );

  /// Table row item name (13/w600/textSecondary) — _TableRow in ImbalanceSheet.
  /// Was hardcoded inline in ImbalanceSheet _TableRow.
  static const TextStyle imbalanceTableItemName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Table row person name (13/textSecondary) — _TableRow in ImbalanceSheet.
  static const TextStyle imbalanceTablePersonName = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// Imbalance quantity value (14/w800) — _TableRow & _ImbalanceRow.
  /// Color applied dynamically (red for > 0, green otherwise).
  static const TextStyle imbalanceQtyValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  /// Empty-state "No data available" text (14/textMuted) in ImbalanceSheet list.
  static const TextStyle imbalanceEmptyText = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
  );

  // ── ImblanceShowUi specific ───────────────────────
  /// Item name in _ImbalanceRow (14/w600/textSecondary).
  /// Was hardcoded in ImblanceShowUi _ImbalanceRow.
  static const TextStyle imbalanceRowItemName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Person name in _ImbalanceRow (12/textMuted).
  static const TextStyle imbalanceRowPersonName = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  /// Type badge text "DM" / "CUST" in _ImbalanceRow (10/w700).
  /// Color applied dynamically.
  static const TextStyle imbalanceTypeBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  /// Card header column label in ImblanceShowUi (11/w700/primary/ls:0.4).
  static const TextStyle imbalanceCardColHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.4,
  );

  /// _EmptyPlaceholder "No data found" title (15/w700/textSecondary).
  static const TextStyle imbalancePlaceholderTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  /// _EmptyPlaceholder subtitle (12/textMuted).
  static const TextStyle imbalancePlaceholderSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  /// _TypeTab selected/unselected label (13/w700). Color applied dynamically.
  static const TextStyle imbalanceTypeTabLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );
}
