import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_format.dart';
import '../models/dashboard_models.dart';

/// ─────────────────────────────────────────────
/// PROFIT SUMMARY CARD
/// Monthly performance table with a green
/// highlight row for net profit.
/// ─────────────────────────────────────────────
class ProfitSummaryCard extends StatelessWidget {
  const ProfitSummaryCard({
    super.key,
    required this.rows,
    required this.totalExpenses,
    required this.netProfit,
  });

  final List<ProfitRow> rows;
  final double totalExpenses;
  final double netProfit;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Category',
                    style: AppTypography.labelMD.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _headerCell('Gross Revenue'),
                const SizedBox(width: 16),
                _headerCell('Gross Profit'),
              ],
            ),
          ),
          const Divider(height: 1),
          // Data rows
          ...rows.map((r) => _buildRow(r)),
          const Divider(height: 1, thickness: 1),
          // Expenses row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Expenses',
                    style: AppTypography.profitRowLabel,
                  ),
                ),
                Text(
                  AppFormat.currency(totalExpenses),
                  style: AppTypography.profitRowValue.copyWith(
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
          ),
          // Net Profit highlight
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Text(
                  'Net Profit This Month',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF166534),
                  ),
                ),
                const Spacer(),
                Text(
                  AppFormat.currency(netProfit),
                  style: AppTypography.profitHighlightValue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(ProfitRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Text(row.label, style: AppTypography.profitRowLabel),
          ),
          _valueCell(AppFormat.currency(row.grossRevenue)),
          const SizedBox(width: 16),
          _valueCell(AppFormat.currency(row.grossProfit)),
        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return SizedBox(
      width: 90,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: AppTypography.labelSM,
      ),
    );
  }

  Widget _valueCell(String text) {
    return SizedBox(
      width: 90,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: AppTypography.profitRowValue,
      ),
    );
  }
}
