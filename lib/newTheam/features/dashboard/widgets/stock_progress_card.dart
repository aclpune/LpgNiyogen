import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_format.dart';
import '../models/dashboard_models.dart';

/// ─────────────────────────────────────────────
/// STOCK PROGRESS CARD
/// Animated progress bars for cylinder status.
/// Filled / Empty / Defective with live counts.
/// ─────────────────────────────────────────────
class StockProgressCard extends StatefulWidget {
  const StockProgressCard({super.key, required this.stock});
  final StockSummary stock;

  @override
  State<StockProgressCard> createState() => _StockProgressCardState();
}

class _StockProgressCardState extends State<StockProgressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
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
          // Header
          Row(
            children: [
              const Text(
                'Cylinder Stock Status',
                style: AppTypography.cardTitle,
              ),
              const Spacer(),
              Text(
                '${AppFormat.count(widget.stock.total)} Total · '
                '${widget.stock.weightKg} KG',
                style: AppTypography.cardSubtitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bars
          _ProgressRow(
            label: 'Filled',
            count: widget.stock.filled,
            fraction: widget.stock.filledPct,
            color: AppColors.green,
            animation: _ctrl,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: 'Empty',
            count: widget.stock.empty,
            fraction: widget.stock.emptyPct,
            color: AppColors.orange,
            animation: _ctrl,
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: 'Defective',
            count: widget.stock.defective,
            fraction: widget.stock.defectPct,
            color: AppColors.red,
            animation: _ctrl,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.count,
    required this.fraction,
    required this.color,
    required this.animation,
  });

  final String label;
  final int count;
  final double fraction;
  final Color color;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(label, style: AppTypography.progressLabel),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 10,
              child: AnimatedBuilder(
                animation: animation,
                builder: (_, __) {
                  return LinearProgressIndicator(
                    value: fraction * CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ).value,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 10,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 36,
          child: Text(
            count.toString(),
            textAlign: TextAlign.right,
            style: AppTypography.progressValue.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
