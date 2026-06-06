import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../ClickModelClass/GetDashboardTVStockPendCtnListForMob.dart';


/// ─────────────────────────────────────────────
/// TV DETAIL CARD
/// Displays a single TV stock entry in a themed
/// card consistent with the dashboard design system.
/// ─────────────────────────────────────────────
class DashboardTVDetailUI extends StatelessWidget {
  const DashboardTVDetailUI(this.tvmodel, {super.key});

  final GetDashboardTvStockPendCtnListForMob tvmodel;

  static String _nullToDash(String? value) {
    if (value == null || value.toLowerCase() == 'null') return '–';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final sale = tvmodel;
    final formattedDate = sale.tVDate != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.tVDate!))
        : '–';

    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card Header ──────────────────────────────
            _CardHeader(itemName: sale.itemName ?? '–', date: formattedDate),

            const Divider(height: 1, thickness: 1, color: AppColors.divider),

            // ── Detail Grid ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _DetailRow(
                    left: _DetailCell(
                      label: 'Cons No',
                      value: _nullToDash(sale.consumerNo),
                    ),
                    right: _DetailCell(
                      label: 'Cyl Qty.',
                      value: _nullToDash(sale.clyHoldQty?.toString()),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    left: _DetailCell(
                      label: 'Reg. Rec',
                      value: _nullToDash(sale.isRegulator),
                      valueColor: sale.isRegulator == 'Yes'
                          ? AppColors.green
                          : null,
                    ),
                    right: _DetailCell(
                      label: 'Paid Amount',
                      value: _nullToDash(
                        formatCurrency((sale.paidAmt ?? 0.0).toDouble()),
                      ),
                      valueColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _DetailRow(
                    left: _DetailCell(
                      label: 'Stock Status',
                      value: _nullToDash(sale.stockStatus),
                    ),
                    right: const _DetailCell(
                      label: 'Rec Date',
                      value: '–',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _FullWidthDetailCell(
                    label: 'Cons. Name',
                    value: sale.consumerName ?? '–',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const _FullWidthDetailCell(label: 'Godown No.', value: '–'),
                  const SizedBox(height: AppSpacing.sm),
                  const _FullWidthDetailCell(label: 'Del Men', value: '–'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card Header ───────────────────────────────────────────────────────────────
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.itemName, required this.date});

  final String itemName;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item name with icon
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.local_gas_station_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(itemName, style: AppTypography.cardTitle),
            ],
          ),
          // Date badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              style: AppTypography.labelMD.copyWith(
                color: AppColors.primary,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row (two cells side-by-side) ──────────────────────────────────────
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: right),
      ],
    );
  }
}

// ── Single detail cell ────────────────────────────────────────────────────────
class _DetailCell extends StatelessWidget {
  const _DetailCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSM),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.dataRowValue.copyWith(
              fontSize: 13,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Full width detail cell ─────────────────────────────────────────────────────
class _FullWidthDetailCell extends StatelessWidget {
  const _FullWidthDetailCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTypography.labelSM,
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.dataRowValue.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared currency formatter (kept in same file as original) ─────────────────
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formattedAmount = format.format(amount);
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0$formattedAmount';
  }
  return formattedAmount;
}