import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// ─────────────────────────────────────────────
/// DASHBOARD SKELETON LOADER
/// Shimmer placeholders matching the real layout.
/// Shows while API data is loading.
/// Pure Flutter — no external shimmer library.
/// ─────────────────────────────────────────────
class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Column(
          children: [
            // Hero placeholder
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: AppColors.gradHero,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _shimmerBlock(height: 80),
                    const SizedBox(height: 10),
                    _shimmerBlock(height: 80),
                    const SizedBox(height: 20),
                    _shimmerBlock(height: 90),
                    const SizedBox(height: 10),
                    _shimmerBlock(height: 90),
                    const SizedBox(height: 20),
                    _shimmerBlock(height: 140),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _shimmerBlock({required double height}) {
    final base = Color.lerp(
      const Color(0xFFE8EEF8),
      const Color(0xFFF4F7FF),
      _shimmer.value,
    )!;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
