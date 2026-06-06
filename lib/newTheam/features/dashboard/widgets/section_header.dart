import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

/// ─────────────────────────────────────────────
/// SECTION HEADER
/// Color-coded dot + uppercase title + optional
/// "See All" link. Min 44px tap height.
/// ─────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.dotColor,
    this.seeAllLabel,
    this.onSeeAll,
  });

  final String title;
  final Color dotColor;
  final String? seeAllLabel;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        children: [
          // Color dot
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: AppTypography.sectionHeader,
          ),
          const Spacer(),
          if (seeAllLabel != null)
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(seeAllLabel!, style: AppTypography.seeAll),
              ),
            ),
        ],
      ),
    );
  }
}
