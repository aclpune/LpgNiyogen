import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_format.dart';
import '../models/dashboard_models.dart';

/// ─────────────────────────────────────────────
/// HERO STRIP
/// Gradient header with abstract flow vectors,
/// greeting, business name, date, and 2 hero KPIs.
/// Uses CustomPainter for flow lines — zero asset cost.
/// ─────────────────────────────────────────────
class DashboardHeroStrip extends StatelessWidget {
  const DashboardHeroStrip({super.key, required this.data});
  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.gradHero,
      ),
      child: Stack(
        children: [
          // Abstract flow vectors (CustomPainter — lightweight)
          Positioned.fill(
            child: CustomPaint(painter: _FlowVectorPainter()),
          ),
          // Soft circle accent top-right
          Positioned(
            top: -50, right: -70,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Teal glow bottom-left
          Positioned(
            bottom: -40, left: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tealLight.withOpacity(0.12),
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopRow(context),
                  const SizedBox(height: 18),
                  _buildKpiRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_greeting()}, ${data.ownerName} 👋',
                style: AppTypography.heroSubtitle,
              ),
              const SizedBox(height: 4),
              Text(data.businessName, style: AppTypography.heroTitle),
              const SizedBox(height: 5),
              Text(
                AppFormat.heroDate(data.date),
                style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Avatar
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            data.ownerInitials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiRow() {
    final stockOk = data.stockSummary.filled > 0;
    return Row(
      children: [
        Expanded(
          child: _HeroKpiChip(
            label: "Today's Revenue",
            value: data.revenueToday == 0
                ? '₹0'
                : AppFormat.currencyCompact(data.revenueToday),
            sub: data.revenueToday == 0
                ? 'No bookings yet'
                : 'Gross revenue',
            badgeLabel: data.revenueToday == 0 ? '▼ No data' : '▲ Live',
            badgeIsGood: data.revenueToday > 0,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HeroKpiChip(
            label: 'Cylinders Filled',
            value: AppFormat.count(data.stockSummary.filled),
            sub: '${data.stockSummary.empty} empty · ${data.stockSummary.defective} defective',
            badgeLabel: stockOk ? '✓ Good stock' : 'Low stock',
            badgeIsGood: stockOk,
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}

// ── Hero KPI Chip ──
class _HeroKpiChip extends StatelessWidget {
  const _HeroKpiChip({
    required this.label,
    required this.value,
    required this.sub,
    required this.badgeLabel,
    required this.badgeIsGood,
  });

  final String label;
  final String value;
  final String sub;
  final String badgeLabel;
  final bool badgeIsGood;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 5),
          Text(value, style: AppTypography.heroKpiValue),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeIsGood
                  ? AppColors.green.withOpacity(0.25)
                  : AppColors.orange.withOpacity(0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeIsGood
                    ? const Color(0xFF86EFAC)
                    : const Color(0xFFFDBA74),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Flow Vector Painter ──
/// Draws 3 subtle curved paths simulating data flow.
/// Pure canvas — no assets, no SVG libraries.
class _FlowVectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = AppColors.tealLight.withOpacity(0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final paint3 = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Path 1
    final p1 = Path()
      ..moveTo(-10, h * 0.75)
      ..cubicTo(w * 0.2, h * 0.25, w * 0.5, h * 0.6, w + 10, h * 0.38);
    canvas.drawPath(p1, paint1);

    // Path 2
    final p2 = Path()
      ..moveTo(-10, h * 0.56)
      ..cubicTo(w * 0.24, h * 0.12, w * 0.5, h * 0.44, w + 10, h * 0.19);
    canvas.drawPath(p2, paint2);

    // Path 3
    final p3 = Path()
      ..moveTo(w * 0.05, h)
      ..cubicTo(w * 0.3, h * 0.5, w * 0.6, h * 0.69, w + 10, h * 0.5);
    canvas.drawPath(p3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
