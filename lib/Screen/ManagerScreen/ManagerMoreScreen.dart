import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_typography.dart';
import 'package:lpgsalesandinventory/newTheam/features/manager_more/bloc/more_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/BlinkingText.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';
import 'ARBReturnScreen/ArbReturnScreen.dart';
import 'ARBSaleScreen/ArbSaleScreen.dart';
import 'ARBScreen/ArbScreen.dart';
import 'CashDepositToBankScreen.dart';
import 'CashHandoverScreen.dart';
import 'ConfigurationScreen.dart';
import 'PaymentReceiptScreen/PaymentReceiptScreen.dart';
import 'ReceiptRegulatorScreen/ReceiptRegulatorScreen.dart';
import 'SVSaleReportScreen.dart';
import 'SalaryPaymentScreen/SalaryPaymentScreen.dart';
import 'TVSaleScreen/TVSalesScreen.dart';
import 'UpdatePaymentsScreen/UpdatePaymentScreen.dart';
class ManagerMoreScree extends StatefulWidget {
  static const screenName = '/managerMoreScree';
  const ManagerMoreScree({super.key});

  @override
  State<ManagerMoreScree> createState() => _ManagerMoreScreeState();
}

class _ManagerMoreScreeState extends State<ManagerMoreScree> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? roleId, isUserActive, userActivet;
  String staffName = '';
  String distributorName = '';

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  // void getUserDetail() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     staffName = preferences.getString('StaffName') ?? '';
  //     distributorName = preferences.getString('DistributorName') ?? '';
  //     roleId = preferences.getString('RoleId');
  //     isUserActive = preferences.getString('IsUserActive');
  //     userActivet = preferences.getString('userActivet');
  //   });
  // }

  void getUserDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      staffName = preferences.getString('StaffName') ?? '';
      distributorName = preferences.getString('DistributorName') ?? '';
      roleId = preferences.getString('roleId');
      isUserActive = preferences.getString('IsUserActive');
      userActivet = preferences.getString('userActive');
      debugPrint("roleId $roleId");
      debugPrint(userActivet);
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildHeroStrip() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: Stack(
        children: [
          Positioned(
            top: -50, right: -70,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
            ),
          ),
          Positioned(
            bottom: -40, left: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tealLight.withOpacity(0.12)),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}, ${staffName.isNotEmpty ? staffName : 'Manager'} 👋',
                              style: AppTypography.heroSubtitle,
                            ),
                            const SizedBox(height: 4),
                            Text('More Options', style: AppTypography.heroTitle),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                              style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          () {
                            final parts = staffName.trim().split(RegExp(r'\s+'));
                            if (parts.length >= 2) {
                              return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                            } else if (parts.isNotEmpty && parts[0].length >= 2) {
                              return parts[0].substring(0, 2).toUpperCase();
                            }
                            return 'M';
                          }(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  BoxDecoration _cardDec() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: AppColors.border),
    boxShadow: const [BoxShadow(color: Color(0x0B1E3A8A), blurRadius: 8, offset: Offset(0, 2))],
  );

  Widget _menuItem({required IconData icon, required String label, required VoidCallback onTap, bool isDanger = false, Widget? badge}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: isDanger ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: isDanger ? const Color(0xFFDC2626) : AppColors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDanger ? const Color(0xFFDC2626) : AppColors.text,
                ),
              ),
            ),
            if (badge != null) ...[badge, const SizedBox(width: 6)],
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDanger ? const Color(0xFFDC2626) : AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.blue),
          const SizedBox(width: 6),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B7280),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()..loadMore(),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.bg2,
          body: RefreshIndicator(
            color: AppColors.blue,
            backgroundColor: AppColors.white,
            onRefresh: () async {
              // Refresh action if needed
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(child: _buildHeroStrip()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Admin Settings (Owner only)
                      Visibility(
                        visible: roleId == Constants.roleIdOwner,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle("Admin Settings", Icons.admin_panel_settings_outlined),
                            Container(
                              decoration: _cardDec(),
                              child: _menuItem(
                                icon: Icons.settings_applications_rounded,
                                label: "Configuration",
                                badge: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: BlinkingText(
                                    text: "New",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFDC2626),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.pushReplacementNamed(context, Configurationscreen.screenName),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      // Daily Transaction
                      _sectionTitle("Daily Transaction", Icons.receipt_long_outlined),
                      Container(
                        decoration: _cardDec(),
                        child: Column(
                          children: [
                            _menuItem(
                              icon: Icons.sell_outlined,
                              label: "SV Sale",
                              onTap: () => Navigator.pushNamed(context, SVSaleReportScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.receipt_outlined,
                              label: "TV Receipt",
                              onTap: () => Navigator.pushReplacementNamed(context, TVSalesScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.payment_outlined,
                              label: "Payments Receipt",
                              onTap: () => Navigator.pushReplacementNamed(context, PaymentReceiptScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.update_rounded,
                              label: "Update Payments",
                              onTap: () => Navigator.pushReplacementNamed(context, UpdatePaymentScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.payments_outlined,
                              label: "Salary Payments",
                              onTap: () => Navigator.pushReplacementNamed(context, SalaryPaymentScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.comment_bank_outlined,
                              label: "Cash Handover-Bank Deposit",
                              onTap: () => Navigator.pushReplacementNamed(context, CashHandoverScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.broken_image_outlined,
                              label: "Receipt Defective Regulator",
                              onTap: () => Navigator.pushReplacementNamed(context, ReceiptRegulatorScreen.screenName),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ARB
                      _sectionTitle("ARB", Icons.storefront_outlined),
                      Container(
                        decoration: _cardDec(),
                        child: Column(
                          children: [
                            _menuItem(
                              icon: Icons.shopping_cart_outlined,
                              label: "ARB Purchase",
                              onTap: () => Navigator.pushNamed(context, ArbScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.assignment_return_outlined,
                              label: "ARB Purchase Return",
                              onTap: () => Navigator.pushReplacementNamed(context, ArbReturnScreen.screenName),
                            ),
                            Divider(height: 1, color: AppColors.border),
                            _menuItem(
                              icon: Icons.sell_outlined,
                              label: "ARB Sale",
                              onTap: () => Navigator.pushReplacementNamed(context, ArbSaleScreen.screenName),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Logout
                      _sectionTitle("Account", Icons.person_outline_rounded),
                      Container(
                        decoration: _cardDec(),
                        child: _menuItem(
                          icon: Icons.logout_rounded,
                          label: "Logout",
                          isDanger: true,
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {

    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {

      // await getDeactiveUserForNotiMob("N");
      await getDeactiveUserForNotiMobD("N");

      await sendPostRequest(0);

      SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

      EasyLoading.dismiss();

      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);

      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

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


    // Fetch app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionNo = packageInfo.version; // Get app version number


    // Debug output
    debugPrint('versionNo: $versionNo');
    debugPrint('distributorId: $distributorId');
    debugPrint('staffId: $staffId');
    debugPrint('activatedOn: $formattedDate');
    debugPrint('mobileNo: $mobileNoStr');

    int distributorIdd = int.tryParse(distributorId ?? '') ?? 0;
    int staffIdd = int.tryParse(staffId ?? '') ?? 0;
    int mobileNo = int.tryParse(mobileNoStr ?? '') ?? 0;



    final Map<String, dynamic> requestBody =
    {
      "VersionNo":versionNo,
      "DistributorId":distributorIdd,
      "StaffId":staffIdd,
      "ActivatedOn":formattedDate,
      "IsActive":flag,
      "RoleId":roleId,
      "MobileNo":mobileNo

    };
    print("MobileStaffwiseVersionAdd: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.MobileStaffwiseVersionAdd}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody MobileStaffwiseVersionAdd: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        print("Response MobileStaffwiseVersionAdd: ${response.body}");

        EasyLoading.dismiss();
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }


  Future<void> getDeactiveUserForNotiMob(String flag) async {
    try {
      EasyLoading.show();

      final prefs = await SharedPreferences.getInstance();
      final String? distributorId = prefs.getString('DistributorId');
      final String? userId = prefs.getString('UserId');
      final String? bearerToken = prefs.getString('token');
      final deviceId = await getDeviceId();
      debugPrint("dhghkggeedsd $deviceId");

      // // Safety checks
      // if (distributorId == null || userId == null || bearerToken == null) {
      //   debugPrint('Logout API skipped: missing user data');
      //   return;
      // }

      final uri = Uri.parse(
        '${AppUrl.DeactiveUserForNotiMob}/$distributorId/$userId/$flag/$deviceId',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Deactivate API URL: $uri');
      debugPrint('Deactivate API Response: ${response.body}');

      if (response.statusCode != 204) {
        debugPrint('Deactivate API failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Deactivate API error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getDeactiveUserForNotiMobD(String flag) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? userId = prefs.getString("UserId");
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final deviceId = await getDeviceId();
    debugPrint("dhghkggeedsd $deviceId");

    final Map<String, dynamic> requestBody =
    {
      "MobDeviceId":deviceId,
      "DistributorId":distributorId,
      "UserId":userId,
      "ActiveStatus":flag,


    };
    print("DeactiveUserForNotiMob: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.DeactiveUserForNotiMob}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody DeactiveUserForNotiMob: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        print("Response DeactiveUserForNotiMob: ${response.body}");

        EasyLoading.dismiss();
      }
    } else {
      print("Error DeactiveUserForNotiMob: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierColor: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
      builder: (BuildContext dialogcontext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withValues(alpha: 0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Gradient header strip ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E3A8A), Color(0xFF1D6B7A), Color(0xFF0F766E)],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.logout_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Confirm Logout",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                // ── Body ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFEDD5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Color(0xFFF97316), size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Are you sure you want to logout? You will need to sign in again to continue.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                  height: 1.4,
                                ),
                                textScaler: TextScaler.noScaling,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // No / Cancel button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(dialogcontext).pop(); // Close the dialog
                              },
                              icon: const Icon(Icons.close_rounded, size: 16),
                              label: const Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF374151),
                                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Yes / Logout button
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFC2410C), Color(0xFFEF4444)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  Navigator.of(dialogcontext).pop(); // Close the dialog
                                  await logoutUser(parentContext); // Call logout function here
                                },
                                icon: const Icon(Icons.logout_rounded, size: 16),
                                label: const Text(
                                  "Logout",
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  static Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Device ID error: $e");
    }

    return null;
  }
}


