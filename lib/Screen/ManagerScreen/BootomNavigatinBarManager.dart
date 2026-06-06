import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreen.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DeliveryBoyWiseListShow.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerDSRReportScreen.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerDashboard.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerUpdateSaleScreen.dart';

import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import '../Utils/CustomeAppBarManagerDashboard.dart';
import '../Utils/CutomeAppBarManagerBottomNavigationBar.dart';
import '../Utils/constants.dart';
import 'ManagerMoreScreen.dart';

class BottomNavBarExample extends StatefulWidget {
  static const screenName = '/bottomNavBarExample';
  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  // The selected index for the bottom navigation bar
  int _selectedIndex = 0;
  bool _initialArgHandled = false;

  // List of pages for each option in the navigation bar
  final List<Widget> _pages = [
    ManagerDashboardScreen(),
    ManagerDSRReportScreen(),
    DeliveryBoyWiseListShow(),
    ManagerMoreScree(),
  ];

  // Method to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialArgHandled) return;  // line 2 - early exit guard

    // Check if arguments are passed to set the initial index
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      _initialArgHandled = true; // ← mark before setState
      setState(() {
        _selectedIndex = args; // Set the passed index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomeAppBarmanagerDashboard(),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: _ManagerBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ── Custom nav bar styled to match AppBottomNavBar ──────────────────────────

class _ManagerBottomNavBar extends StatelessWidget {
  const _ManagerBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _MgrNavItem(
      label: 'Dashboard',
      assetIcon: 'assets/home_outline.png',
      activeAssetIcon: 'assets/home_outline.png',
    ),
    _MgrNavItem(
      label: 'DSR',
      assetIcon: 'assets/booking.png',
      activeAssetIcon: 'assets/booking.png',
    ),
    // _MgrNavItem(
    //   label: 'Stock',
    //   assetIcon: 'assets/stock.png',
    //   activeAssetIcon: 'assets/stock.png',
    // ),
    _MgrNavItem(
      label: 'Cash Collection',
      assetIcon: 'assets/payment.png',
      activeAssetIcon: 'assets/payment.png',
    ),
    _MgrNavItem(
      label: 'More',
      assetIcon: 'assets/more.png',
      activeAssetIcon: 'assets/more.png',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141E3A8A),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: _items.asMap().entries.map((e) {
              return _MgrNavTab(
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

class _MgrNavItem {
  const _MgrNavItem({
    required this.label,
    this.assetIcon,
    this.activeAssetIcon,
  });

  final String label;

  // // Material icons (optional)
  // final IconData? icon;
  // final IconData? activeIcon;

  // Custom image icons (optional)
  final String? assetIcon;
  final String? activeAssetIcon;
}


class _MgrNavTab extends StatelessWidget {
  const _MgrNavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _MgrNavItem item;
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
              Image.asset(
                isActive
                    ? (item.activeAssetIcon ?? item.assetIcon!)
                    : item.assetIcon!,
                height: 22,
                width: 22,
              ),

              const SizedBox(height: 3),
              Text(
                item.label,
                style: AppTypography.navLabel.copyWith(
                  color: isActive ? AppColors.blueLight : AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
