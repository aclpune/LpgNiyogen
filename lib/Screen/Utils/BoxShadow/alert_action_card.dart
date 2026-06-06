import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/app_colors.dart';
import 'app_typography.dart';
import 'dashboard_models.dart';


/// ─────────────────────────────────────────────
/// ALERT ACTION CARD
/// High-visibility alert with severity left border,
/// icon, title, subtitle, value, and chevron.
/// Animates in with a staggered slide+fade.
/// Min tap height: 64px — senior-friendly.
/// ─────────────────────────────────────────────
class AlertActionCard extends StatefulWidget {
  const AlertActionCard({
    super.key,
    required this.item,
    required this.animationDelay,
  });

  final AlertItem item;
  final Duration animationDelay;

  @override
  State<AlertActionCard> createState() => _AlertActionCardState();
}

class _AlertActionCardState extends State<AlertActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    final colors = _severityColors(widget.item.severity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.item.onTap?.call();
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: colors.splash,
          child: Container(
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: colors.borderColor, width: 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.borderColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: colors.iconBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: colors.borderColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 13),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: AppTypography.alertTitle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.subtitle,
                          style: AppTypography.cardSubtitle,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.item.value,
                          style: AppTypography.alertValue.copyWith(
                            color: colors.borderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AlertColors _severityColors(AlertSeverity s) => switch (s) {
    AlertSeverity.danger  => _AlertColors(
        borderColor: AppColors.red,
        cardBg:      const Color(0xFFFFFBFB),
        iconBg:      AppColors.redXL,
        splash:      AppColors.redXXL,
      ),
    AlertSeverity.warning => _AlertColors(
        borderColor: AppColors.orange,
        cardBg:      const Color(0xFFFFFDF8),
        iconBg:      AppColors.orangeXL,
        splash:      AppColors.orangeXXL,
      ),
    AlertSeverity.info    => _AlertColors(
        borderColor: AppColors.blueLight,
        cardBg:      const Color(0xFFFAFBFF),
        iconBg:      AppColors.blueXL,
        splash:      AppColors.blueXXL,
      ),
  };
}

class _AlertColors {
  const _AlertColors({
    required this.borderColor,
    required this.cardBg,
    required this.iconBg,
    required this.splash,
  });
  final Color borderColor;
  final Color cardBg;
  final Color iconBg;
  final Color splash;
}
