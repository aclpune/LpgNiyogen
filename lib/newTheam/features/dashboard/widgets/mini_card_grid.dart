import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// ─────────────────────────────────────────────
/// MINI CARD GRID
/// 2-column compact metric pair.
/// Used for Imbalance, Quick Punch, etc.
/// ─────────────────────────────────────────────
class MiniCardGrid extends StatelessWidget {
  const MiniCardGrid({super.key, required this.left, required this.right});
  final MiniCardData left;
  final MiniCardData right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _MiniCard(data: left)),
          const SizedBox(width: 10),
          Expanded(child: _MiniCard(data: right)),
        ],
      ),
    );
  }
}

class MiniCardData {
  const MiniCardData({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.sub,
    this.gradient,
    this.onTap,
    this.isActionCard = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String sub;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool isActionCard;
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.data});
  final MiniCardData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: data.onTap != null
            ? () {
                HapticFeedback.lightImpact();
                data.onTap!();
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: data.gradient == null ? AppColors.white : null,
            gradient: data.gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0D1E3A8A),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.label.toUpperCase(),
                style: AppTypography.miniLabel,
              ),
              if (data.isActionCard)
                Text(
                  data.value,
                  style: AppTypography.cardTitle.copyWith(
                    color: data.valueColor,
                    fontSize: 16,
                  ),
                )
              else
                Text(
                  data.value,
                  style: AppTypography.miniValue.copyWith(
                    color: data.valueColor,
                  ),
                ),
              Text(data.sub, style: AppTypography.miniLabel),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
/// DATA LIST CARD
/// Rounded card with rows of label / value data.
/// Each row is 52px+ for easy tapping.
/// ─────────────────────────────────────────────
class DataListCard extends StatelessWidget {
  const DataListCard({super.key, required this.rows});
  final List<DataRowItem> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1E3A8A),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return _DataRow(item: e.value, showDivider: !isLast);
        }).toList(),
      ),
    );
  }
}

class DataRowItem {
  const DataRowItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.dotColor,
    required this.badgeLabel,
    required this.badgeBg,
    required this.badgeFg,
    this.onTap,
  });

  final String label;
  final String subtitle;
  final String value;
  final Color dotColor;
  final String badgeLabel;
  final Color badgeBg;
  final Color badgeFg;
  final VoidCallback? onTap;
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.item, required this.showDivider});
  final DataRowItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap != null
          ? () {
              HapticFeedback.selectionClick();
              item.onTap!();
            }
          : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: item.dotColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: AppTypography.dataRowLabel),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: AppTypography.cardSubtitle),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(item.value, style: AppTypography.dataRowValue),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: item.badgeBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.badgeLabel,
                style: AppTypography.badgeText.copyWith(color: item.badgeFg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
