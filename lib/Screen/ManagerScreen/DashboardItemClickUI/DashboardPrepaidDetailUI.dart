import 'package:flutter/material.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PREPAID DETAIL ROW ITEM
// Renders one settlement record as a themed card row.
// Matches the table-header layout defined in DashboardPrepaidDetails.dart.
//
// Design tokens: AppColors · AppSpacing · AppTypography
// Reuses: _ConsumerNoBadge · _TableCell · _CellDivider
// ─────────────────────────────────────────────────────────────────────────────

class DashboardPrepaidDetailUI extends StatelessWidget {
  const DashboardPrepaidDetailUI(
      this.prepaidModel,
      this.serialNumber, {
        super.key,
      });

  final GetDashboardSettlementCtnListModel prepaidModel;
  final int serialNumber;

  // Converts null / the string "null" / empty string to a dash placeholder.
  static String _nullToDash(String? value) {
    if (value == null ||
        value.toLowerCase() == 'null' ||
        value.trim().isEmpty) {
      return '–';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final sale = prepaidModel;
    final isEven = serialNumber.isEven;

    return Container(
      // Alternate row tinting — background2 vs surface, matching existing pattern.
      color: isEven ? AppColors.background2 : AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.tableRowPadding, // horizontal:12, vertical:10
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Consumer No. ─────────────────────────────
                _ConsumerNoBadge(text: _nullToDash(sale.consumerNo)),
                const _CellDivider(),

                // ── Consumer Name ────────────────────────────
                _TableCell(
                  text: _nullToDash(sale.consumerName),
                  flex: 3,
                  style: AppTypography.cardSubtitle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const _CellDivider(),

                // ── Order Date ───────────────────────────────
                _TableCell(
                  text: _nullToDash(sale.orderDate),
                  flex: 2,
                  style: _dateStyle,
                ),
                const _CellDivider(),

                // ── Delivery Date ────────────────────────────
                _TableCell(
                  text: _nullToDash(sale.deliveryDate),
                  flex: 2,
                  style: _dateStyle,
                ),
                const _CellDivider(),

                // ── Settlement Date ──────────────────────────
                _TableCell(
                  text: _nullToDash(sale.settlementDate),
                  flex: 2,
                  style: _dateStyle,
                ),
              ],
            ),
          ),

          // Row divider — reuses divider token identical to Divider widget + AlertActionCard
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED STYLE
// Defined once so _dateStyle is DRY across every date column.
// ─────────────────────────────────────────────────────────────────────────────

const TextStyle _dateStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: AppColors.textMuted,
  height: 1.3,
  letterSpacing: 0.1,
);

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE CELL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Consumer No. — primary-blue pill badge.
/// Uses AppColors.primaryXLight / primaryXXLight + AppTypography token sizing,
/// consistent with the badge style used across the dashboard.
class _ConsumerNoBadge extends StatelessWidget {
  const _ConsumerNoBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm - 1, // 7px — fine-tuned for badge
            vertical: AppSpacing.xs,       // 4px
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryXLight,
            borderRadius: BorderRadius.circular(AppSpacing.sm - 2), // 6px
            border: Border.all(
              color: AppColors.primaryXXLight,
              width: 1,
            ),
            // Consistent with AppShadows.card — very subtle primary shadow
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowCard,
                blurRadius: AppSpacing.sm,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            text,
            style: AppTypography.badgeText.copyWith(
              fontSize: 11,
              color: AppColors.primary,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}

/// Generic table cell — replaces the separate _NameCell and _DateCell widgets.
/// Accepts any TextStyle so callers control appearance via design tokens.
///
/// [backgroundColor] is optional — pass `AppColors.primary` (or any token)
/// for header rows; leave null for data rows (transparent).
/// [verticalPadding] lets header rows add extra breathing room without
/// affecting data-row density.
class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.style,
    this.flex = 1,
    this.backgroundColor,
    this.verticalPadding = 0,
  });

  final String text;
  final TextStyle style;
  final int flex;
  final Color? backgroundColor;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    Widget cell = Text(
      text,
      style: style,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    if (backgroundColor != null || verticalPadding > 0) {
      cell = Container(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: cell,
      );
    }

    return Expanded(flex: flex, child: cell);
  }
}

/// Thin vertical separator between cells.
/// Uses AppColors.divider — same token as horizontal Divider + AlertActionCard separators.
class _CellDivider extends StatelessWidget {
  const _CellDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs + 1), // 5px
      color: AppColors.divider,
    );
  }
}