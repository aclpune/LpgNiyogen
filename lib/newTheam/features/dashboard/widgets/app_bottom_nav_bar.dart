import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// ─────────────────────────────────────────────
/// APP BOTTOM NAV BAR
/// 5-tab persistent nav. Active tab has a
/// pill indicator above the icon.
/// 60px height — senior-friendly tap targets.
/// ─────────────────────────────────────────────
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(label: 'Dashboard', icon: Icons.home_rounded,       activeIcon: Icons.home_rounded),
    _NavItem(label: 'Bookings',  icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2_rounded),
    _NavItem(label: 'Stock',     icon: Icons.propane_tank_outlined, activeIcon: Icons.propane_tank_rounded),
    _NavItem(label: 'Payments',  icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded),
    _NavItem(label: 'More',      icon: Icons.more_horiz_rounded,  activeIcon: Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x141E3A8A),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: _items.asMap().entries.map((e) {
              return _NavTab(
                item: e.value,
                isActive: e.key == currentIndex,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(e.key);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Active indicator pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                width: isActive ? 24 : 0,
                height: 3,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: isActive ? AppColors.blueLight : AppColors.textMuted,
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: AppTypography.navLabel.copyWith(
                  color: isActive ? AppColors.blueLight : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
