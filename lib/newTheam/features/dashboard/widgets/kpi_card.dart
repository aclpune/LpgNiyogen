import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/dashboard_models.dart';

/// ─────────────────────────────────────────────
/// KPI CARD WIDGET
/// Full-width card: icon block + label + large
/// value + subtitle + badge + chevron.
/// Reusable for all financial KPIs.
/// ─────────────────────────────────────────────
class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.kpi});
  final FinancialKpi kpi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            kpi.onTap?.call();
          },
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.blueXXL,
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: kpi.iconBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(kpi.icon, color: AppColors.blue, size: 24),
                  ),
                  const SizedBox(width: 14),
                  // Body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kpi.label, style: AppTypography.labelMD),
                        const SizedBox(height: 3),
                        Text(kpi.value, style: AppTypography.kpiValueLG),
                        const SizedBox(height: 4),
                        Text(
                          kpi.subtitle,
                          style: AppTypography.cardSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Right: badge + chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: kpi.badgeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          kpi.badgeLabel,
                          style: AppTypography.badgeText.copyWith(
                            color: kpi.badgeFg,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
