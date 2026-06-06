import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/shared_preference.dart';
import '../Utils/styles/app_colors.dart';
import '../Utils/styles/app_spacing.dart';
import '../Utils/styles/app_text_styles.dart';
import 'BottomNavigationForGodownKeeper.dart';
import 'ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'ItemReceipt/ItemReturn/ItenRetun.dart';
import 'ItemReceipt/ItemReturnXMI/screen/AddReturnItemXMIScreen.dart';
import 'ItemReceipt/ItemReturnXMI/screen/ItemReturnXMIListScreen.dart';
import 'MarkDefective/MarkDefectiveItemScreen.dart';

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────
class MoreOptionScreenGodownKeeper extends StatefulWidget {
  static const screenName = '/moreOptionScreenGodownKeeper';

  const MoreOptionScreenGodownKeeper({super.key});

  @override
  State<MoreOptionScreenGodownKeeper> createState() =>
      _MoreOptionScreenGodownKeeperState();
}

class _MoreOptionScreenGodownKeeperState
    extends State<MoreOptionScreenGodownKeeper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ── Navigation helper (preserves original routes) ──
  void _go(String route) =>
      Navigator.pushReplacementNamed(context, route);

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          _go('/bottomNavigationForGodownKeeper');
          return false;
        } else {
          _go('/bottomNavigationForGodownKeeper');
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background2,       // was: _C.bg = Color(0xFFF1F5FE)
        // appBar: CustomAppBar(
        //   title: 'More Options',
        // ),
        body: Column(
          children: [
            // ── Hero header ──
            _HeroHeader(),
            // AppGradientHeader(
            //   title: 'More Options',
            //   subtitle: 'Godown Keeper',
            //   icon: Icons.menu_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),

            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.moreOptionsPagePadding,  // was: EdgeInsets.fromLTRB(16, 20, 16, 32)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Item Receipt / Return ──
                    _SectionLabel(
                      title: 'Item Receipt / Return',
                      dotColor: AppColors.primaryLight,    // was: _C.blueLight = Color(0xFF2D52C5)
                    ),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.receipt_rounded,
                          label: 'Item Receipt',
                          subtitle: 'Record incoming stock items',
                          iconBg: AppColors.primaryXLight,  // was: _C.blueXL = Color(0xFFEFF6FF)
                          iconColor: AppColors.primary,     // was: _C.blue = Color(0xFF1E3A8A)
                          onTap: () => _go(ItemReceiptScreen.screenName),
                        ),
                        _MenuItem(
                          icon: Icons.assignment_return_outlined,
                          label: 'Item Return',
                          subtitle: 'Process returned items',
                          iconBg: AppColors.tealXLight,     // was: _C.tealXL = Color(0xFFF0FDFA)
                          iconColor: AppColors.teal,        // was: _C.teal = Color(0xFF0F766E)
                          onTap: () => _go(ItemReturnScreen.screenName),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.menuSectionGap),  // was: 6

                    // ── EXMI / Rev-EMR ──
                    _SectionLabel(
                      title: 'EXMI / Rev-EMR',
                      dotColor: AppColors.teal,             // was: _C.teal = Color(0xFF0F766E)
                    ),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.assignment_return_outlined,
                          label: 'Return EXMI / Rev-EMR',
                          subtitle: 'Return EXMI or Rev-EMR items',
                          iconBg: AppColors.orange2XLight,  // was: _C.orangeXL = Color(0xFFFFF7ED)
                          iconColor: AppColors.orange2,     // was: _C.orange = Color(0xFFF97316)
                          onTap: () =>
                              _go(AddReturnItemXMIScreen.screenName),
                        ),
                        _MenuItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Receipt EXMI',
                          subtitle: 'View EXMI receipts list',
                          iconBg: AppColors.primaryXLight,  // was: _C.blueXL = Color(0xFFEFF6FF)
                          iconColor: AppColors.primaryLight, // was: _C.blueLight = Color(0xFF2D52C5)
                          onTap: () =>
                              _go(ItemReturnXMIListScreen.screenName),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.menuSectionGap),  // was: 6

                    // ── Mark Defective ──
                    _SectionLabel(
                      title: 'Mark Defective',
                      dotColor: AppColors.orange2,          // was: _C.orange = Color(0xFFF97316)
                    ),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.report_problem_rounded,
                          label: 'Mark Defective',
                          subtitle: 'Flag items as defective',
                          iconBg: AppColors.orange2XLight,  // was: _C.orangeXL = Color(0xFFFFF7ED)
                          iconColor: AppColors.orange2,     // was: _C.orange = Color(0xFFF97316)
                          onTap: () =>
                              _go(MarkDefectiveItemScreen.screenName),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.menuSectionGap),  // was: 6

                    // ── Logout ──
                    _SectionLabel(
                      title: 'Account',
                      dotColor: AppColors.red,              // was: _C.red = Color(0xFFEF4444)
                    ),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          subtitle: 'Sign out of your account',
                          iconBg: AppColors.redXLight,      // was: _C.redXL = Color(0xFFFEF2F2)
                          iconColor: AppColors.red,         // was: _C.red = Color(0xFFEF4444)
                          onTap: () => _showLogoutDialog(context),
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PRESERVED: Logout logic ────────────────────────────────────────────
  Future<void> logoutUser(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      sendPostRequest(0);
      SharedPref().removeUser();
      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);
      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

  // ── PRESERVED: API call ────────────────────────────────────────────────
  Future<void> sendPostRequest(int flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    String? roleId = prefs.getString('roleId');
    String? mobileNoStr = prefs.getString('MobileNo');
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionNo = packageInfo.version;

    debugPrint('versionNo: $versionNo');
    debugPrint('distributorId: $distributorId');
    debugPrint('staffId: $staffId');
    debugPrint('activatedOn: $formattedDate');
    debugPrint('mobileNo: $mobileNoStr');

    int distributorIdd = int.tryParse(distributorId ?? '') ?? 0;
    int staffIdd = int.tryParse(staffId ?? '') ?? 0;
    int mobileNo = int.tryParse(mobileNoStr ?? '') ?? 0;

    final Map<String, dynamic> requestBody = {
      "VersionNo": versionNo,
      "DistributorId": distributorIdd,
      "StaffId": staffIdd,
      "ActivatedOn": formattedDate,
      "IsActive": flag,
      "RoleId": roleId,
      "MobileNo": mobileNo
    };

    print("MobileStaffwiseVersionAdd: $requestBody");
    requestBody.forEach((key, value) => print('$key: $value'));

    final response = await http.post(
      Uri.parse('${AppUrl.MobileStaffwiseVersionAdd}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );

    print(
        "requestBody MobileStaffwiseVersionAdd: ${response.statusCode} - ${response.request}$requestBody");
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      if (response.body == '0') {
        EasyLoading.showToast("Something went wrong. Please try again.",
            duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        print("Response MobileStaffwiseVersionAdd: ${response.body}");
        EasyLoading.dismiss();
      }
    } else {
      print(
          "Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.",
          duration: const Duration(milliseconds: 3000));
    }
  }

  // ── PRESERVED: Logout dialog ───────────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: AppRadius.moreOptionsDialog),   // was: BorderRadius.circular(20)
          backgroundColor: AppColors.surface,               // was: _C.white = Color(0xFFFFFFFF)
          title: Row(
            children: [
              Container(
                width: AppSizes.moreOptionsDialogIconBox,   // was: 36
                height: AppSizes.moreOptionsDialogIconBox,  // was: 36
                decoration: BoxDecoration(
                  color: AppColors.redXLight,               // was: _C.redXL = Color(0xFFFEF2F2)
                  borderRadius: AppRadius.moreOptionsDialogIcon, // was: BorderRadius.circular(10)
                ),
                child: Icon(Icons.logout_rounded,
                    color: AppColors.red, size: AppSizes.moreOptionsDialogIconPx), // was: 18
              ),
              const SizedBox(width: AppSpacing.md),         // was: 12
              Text(
                'Confirm Logout',
                style: AppTextStyles.moreOptionsDialogTitle, // was: inline TextStyle(fontSize:16, w700, _C.text)
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTextStyles.moreOptionsDialogContent,  // was: inline TextStyle(fontSize:14, _C.textMid)
          ),
          actionsPadding: AppSpacing.moreOptionsDialogActions, // was: EdgeInsets.symmetric(horizontal:16, vertical:12)
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textMuted,        // was: _C.textMuted = Color(0xFF6B7280)
                side: const BorderSide(color: AppColors.border), // was: _C.border = Color(0xFFE2E8F0)
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.moreOptionsDialogBtn), // was: BorderRadius.circular(10)
                padding: AppSpacing.moreOptionsDialogBtnPadding,   // was: EdgeInsets.symmetric(h:20, v:10)
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                logoutUser(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,              // was: _C.red = Color(0xFFEF4444)
                foregroundColor: AppColors.surface,          // was: _C.white = Color(0xFFFFFFFF)
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.moreOptionsDialogBtn), // was: BorderRadius.circular(10)
                padding: AppSpacing.moreOptionsDialogBtnPadding,   // was: EdgeInsets.symmetric(h:20, v:10)
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// HERO HEADER (stateless, no logic)
// ─────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero), // was: _C.gradHero
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.moreOptionsHeroHeaderPadding, // was: EdgeInsets.fromLTRB(20,16,20,22)
          child: Row(
            children: [
              Container(
                width: AppSizes.moreOptionsHeroIconBox,     // was: 42
                height: AppSizes.moreOptionsHeroIconBox,    // was: 42
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: AppRadius.heroIconContainer, // was: BorderRadius.circular(12)
                  border: Border.all(
                      color: Colors.white.withOpacity(0.25), width: 1.5),
                ),
                // child: Icon(Icons.menu_rounded,
                //     color: Colors.white, size: AppSizes.moreOptionsHeroIconPx), // was: 22
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/playstore.png',
                    width: AppSizes.moreOptionsHeroIconPx,
                    height: AppSizes.moreOptionsHeroIconPx,
                    fit: BoxFit.cover,
                  ),
                ),




              ),
              SizedBox(width: AppSpacing.moreOptionsHeroIconGap), // was: 14
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More Options',
                      style: AppTextStyles.moreOptionsHeroTitle, // was: inline TextStyle(fontSize:20, w800, white, ls:-0.4)
                    ),
                    const SizedBox(height: AppSpacing.xxs),       // was: 3
                    Text(
                      'Godown Keeper',
                      style: AppTextStyles.moreOptionsHeroSubtitle, // was: inline TextStyle(fontSize:12, w500, white70)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION LABEL  (color dot + uppercase title)
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.dotColor});

  final String title;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.moreOptionsSectionLabelPadding, // was: EdgeInsets.only(bottom:10, top:4)
      child: Row(
        children: [
          Container(
            width: AppSizes.sectionDotSize,               // was: 8
            height: AppSizes.sectionDotSize,              // was: 8
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: AppRadius.sectionDot,          // was: BorderRadius.circular(2)
            ),
          ),
          const SizedBox(width: AppSpacing.sm),           // was: 8
          Text(
            title.toUpperCase(),
            style: AppTextStyles.moreOptionsSectionLabel,  // was: inline TextStyle(fontSize:11, w700, _C.textMid, ls:0.8)
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MENU CARD  (rounded card wrapping list items)
// ─────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.moreOptionsMenuCardMargin,       // was: EdgeInsets.only(bottom:10)
      decoration: BoxDecoration(
        color: AppColors.surface,                          // was: _C.white = Color(0xFFFFFFFF)
        borderRadius: AppRadius.moreOptionsMenuCard,       // was: BorderRadius.circular(18)
        boxShadow: AppShadows.moreOptionsMenuCard,         // was: inline BoxShadow(Color(0x0D1E3A8A), blur:12, offset:Offset(0,2))
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return _MenuTile(item: e.value, showDivider: !isLast);
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MENU ITEM  (data model)
// ─────────────────────────────────────────────
class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isDestructive;
}

// ─────────────────────────────────────────────
// MENU TILE  (one row inside a MenuCard)
// ─────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item, required this.showDivider});

  final _MenuItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final borderRadius = AppRadius.moreOptionsMenuCard;   // was: BorderRadius.circular(18)
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          item.onTap();
        },
        borderRadius: borderRadius,
        splashColor: item.iconBg,
        child: Container(
          decoration: showDivider
              ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 1), // was: Color(0xFFF1F5F9)
            ),
          )
              : null,
          padding: AppSpacing.moreOptionsMenuTilePadding, // was: EdgeInsets.symmetric(horizontal:16, vertical:14)
          child: Row(
            children: [
              // Icon block
              Container(
                width: AppSizes.moreOptionsIconBox,       // was: 44
                height: AppSizes.moreOptionsIconBox,      // was: 44
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: AppRadius.moreOptionsIconBox, // was: BorderRadius.circular(13)
                ),
                child: Icon(item.icon, color: item.iconColor,
                    size: AppSizes.moreOptionsIconPx),    // was: 22
              ),
              SizedBox(width: AppSpacing.moreOptionsIconTextGap), // was: 14
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: item.isDestructive
                          ? AppTextStyles.moreOptionsMenuLabelDestructive // was: inline w/ _C.red
                          : AppTextStyles.moreOptionsMenuLabel,           // was: inline TextStyle(15, w700, _C.text, ls:-0.1)
                    ),
                    const SizedBox(height: AppSpacing.xxs),// was: 2
                    Text(
                      item.subtitle,
                      style: AppTextStyles.moreOptionsMenuSubtitle, // was: inline TextStyle(12, w500, _C.textMuted)
                    ),
                  ],
                ),
              ),
              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: item.isDestructive ? AppColors.red : AppColors.textMuted,
                // was: item.isDestructive ? _C.red : _C.textMuted
                size: AppSizes.moreOptionsChevron,         // was: 22
              ),
            ],
          ),
        ),
      ),
    );
  }
}