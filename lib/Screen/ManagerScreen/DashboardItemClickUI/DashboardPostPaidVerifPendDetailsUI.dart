import 'package:flutter/material.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import 'DashboardPostPaidVerifPendDetails.dart';

// ─────────────────────────────────────────────────────────────────────────────
// POSTPAID VERIFICATION PENDING — DETAIL ROW ITEM
// Renders one postpaid transaction as a themed info card.
// Used inside the ListView.builder in DashboardPostPaidVerifPendDetails.
// ─────────────────────────────────────────────────────────────────────────────

class DashboardPostPaidVeriPendDetailsUI extends StatelessWidget {
  const DashboardPostPaidVeriPendDetailsUI(
      this.postpaidverifipending, {
        super.key,
      });

  final GetDashboardPostpaidVarifiPendCntLstForMobListModel postpaidverifipending;

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
    final sale = postpaidverifipending;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header: Trans Code + Amount ──────────
          _CardHeader(
            transCode: _nullToDash(sale.transCode),
            amount: _nullToDash(
              formatCurrency((sale.amount ?? 0.0).toDouble()),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          // ── Info rows ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
              children: [
                _InfoRow(
                  label: 'Trans Date',
                  value: _nullToDash(sale.transDate),
                  icon: Icons.calendar_today_rounded,
                ),
                _InfoRow(
                  label: 'Trans Time',
                  value: _nullToDash(sale.transTime),
                  icon: Icons.access_time_rounded,
                ),
                _InfoRow(
                  label: 'Trans For',
                  value: _nullToDash(sale.transFor),
                  icon: Icons.swap_horiz_rounded,
                ),
                _InfoRow(
                  label: 'Staff Name',
                  value: _nullToDash(sale.staffName),
                  icon: Icons.person_outline_rounded,
                ),
              ],
            ),
          ),

          // ── Remark ────────────────────────────────────
          if ((sale.remark ?? '').isNotEmpty)
            _RemarkRow(remark: sale.remark!),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

/// Card top bar: Trans Code badge on the left, Amount on the right.
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.transCode, required this.amount});

  final String transCode;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Trans Code pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryXXLight, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.tag_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  transCode,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Amount badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.tealXLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '₹ $amount',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.teal,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single label + value info row with a leading icon.
/// Consistent with the data-row pattern used throughout the dashboard.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.background2,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 15, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 10),

          // Label
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: AppTypography.labelMD.copyWith(fontSize: 12),
            ),
          ),

          // Value
          Expanded(
            child: Text(
              value,
              style: AppTypography.dataRowValue.copyWith(fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Remark section — shown only when remark is non-empty.
class _RemarkRow extends StatelessWidget {
  const _RemarkRow({required this.remark});

  final String remark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.warningBorder.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REMARK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.warningText,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              remark,
              style: AppTypography.cardSubtitle.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}