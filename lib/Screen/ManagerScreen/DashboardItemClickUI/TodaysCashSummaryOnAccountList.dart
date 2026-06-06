import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/OnAccountPopupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../newTheam/core/theme/app_typography.dart';
import '../../../newTheam/features/dashboard/widgets/section_header.dart';
import '../../ConstantScreen/widgets.dart';

import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import '../ClickModelClass/TodaysCashSummaryOnAccountListModel.dart';
import '../ManagerDashboard.dart';
import '../ManagerModelClass/GetStaffLedgerReportModelList.dart';
import '../SVSaleModel/GetStaffDetailsListModel.dart';



// =============================================================================
// Enum – unchanged
// =============================================================================
enum BalanceType { totalBalance, advance, onAccount }

// =============================================================================
// TodaysCashSummaryOnAccountList
// Refactored to match dashboard design system:
//   • Hero gradient AppBar with count + balance KPI badges
//   • Themed staff filter dropdown
//   • Themed balance-type selector (pill cards instead of raw Radio rows)
//   • Dashboard-style ledger cards with left-border accent + checkboxes
//   • Branded Payment action button
//   • SectionHeader reused from design system
// =============================================================================
class TodaysCashSummaryOnAccountList extends StatefulWidget {
  static const screenName = '/todaysCashSummaryOnAccountList';
  const TodaysCashSummaryOnAccountList({super.key});

  @override
  State<TodaysCashSummaryOnAccountList> createState() =>
      _TodaysCashSummaryOnAccountListState();
}

class _TodaysCashSummaryOnAccountListState
    extends State<TodaysCashSummaryOnAccountList> {
  // ── State (all unchanged) ──────────────────────────────────────────────────
  late List<TodaysCashSummaryOnAccountListModel> onAccountList = [];
  bool isLoading = true;
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  List<GetStaffLedgerReportModelList> lederReportModel = [];
  GetStaffDetailsListModel? selectedStaff;
  int? selectedReferredID;
  String? selectedReferredName;
  bool isPaymentButtonEnabled = false;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  var argValue;
  double? onAccountAmount;
  bool saveFlag = false;
  bool isChecked = false;
  List<bool> isCheckedList = [];
  double onAccountAsOfDate = 0.00;
  double totalAmt = 0.0;
  double totalBalance = 0.0;
  int cashsummary = 0;
  BalanceType? _selectedBalanceType = BalanceType.onAccount;
  String? modes;

  // ── Lifecycle (unchanged) ──────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    getStaffDetailsList();
    getStaffLedgerReportList(0);
    _updateTotalBalance();
    isCheckedList =
    List<bool>.filled(lederReportModel.length, false, growable: true);

    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      final String staffId = argValue?["staffId"] ?? '';
      final String staffNameEdit = argValue?["staffName"] ?? '';

      debugPrint(
          "Updated staffId: $staffId, updated staffName: $staffNameEdit");

      if (staffId.isNotEmpty && staffNameEdit.isNotEmpty) {
        await getStaffDetailsList();
        await getStaffDetailsList();

        setState(() {
          selectedStaff = staffdetailsmodel.firstWhere(
                (item) => item.staffName == staffNameEdit,
            orElse: () => GetStaffDetailsListModel(staffName: ''),
          );
          selectedReferredID = int.tryParse(staffId) ?? 0;
          selectedReferredName = staffNameEdit;
          getStaffLedgerReportList(selectedReferredID!);
        });
        _updateTotalBalance();
        debugPrint("selected staff: $selectedReferredID");
        debugPrint(
            "Updated referredByNameEdit: $staffId, selectedReferredName: $staffNameEdit");
      }
    });
  }

  // ── Business logic (unchanged) ─────────────────────────────────────────────
  void _updateTotalBalance() {
    var filteredReports = selectedStaff == null
        ? lederReportModel
        : lederReportModel
        .where((report) => report.staffId == selectedStaff?.staffId)
        .toList();

    totalBalance = filteredReports.fold(
        0.0, (sum, report) => sum + (report.balance ?? 0.0));
    print("Total Balance: $totalBalance");
  }

  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") return "-";
    return value;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Count computation (unchanged)
    if (lederReportModel.isNotEmpty) {
      cashsummary = selectedReferredID == null
          ? lederReportModel.length
          : lederReportModel
          .where((report) => report.staffId == selectedReferredID)
          .length;
    } else {
      cashsummary = 0;
    }

    final filteredReports = selectedStaff == null
        ? lederReportModel
        : lederReportModel
        .where((report) => report.staffId == selectedStaff?.staffId)
        .toList();

    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        // appBar: _buildAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppGradientHeader(
              title:  'Staff Ledger',
              subtitle: selectedReferredName ?? 'All Staff',
              icon: Icons.receipt_long_rounded,
              // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
              onBack: () => Navigator.pop(context)
          ),
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Staff filter ─────────────────────────────────────
            _buildStaffFilterBar(),

            // ── Balance summary chips ────────────────────────────
            _buildBalanceTypeSelector(),

            // ── Section header ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                title: 'Ledger Entries',
                dotColor: AppColors.primary,
                seeAllLabel: null,
              ),
            ),

            // ── Ledger list ──────────────────────────────────────
            Expanded(
              child: _buildLedgerList(filteredReports),
            ),

            // ── Payment button ───────────────────────────────────
            _buildPaymentFooter(filteredReports),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradPrimary),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () =>
                      Navigator.pushNamed(context, BottomNavBarExample.screenName),
                ),
                // Expanded(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Staff Ledger',
                //         style: AppTypography.heroTitle,
                //         textScaler: TextScaler.noScaling,
                //       ),
                //       Text(
                //         selectedReferredName != null
                //             ? selectedReferredName!
                //             : 'All Staff',
                //         style: AppTypography.heroSubtitle,
                //         textScaler: TextScaler.noScaling,
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Staff Ledger',
                            style: AppTypography.heroTitle,
                            textScaler: TextScaler.noScaling,
                          ),
                          Text(
                            selectedReferredName ?? 'All Staff',
                            style: AppTypography.heroSubtitle,
                            textScaler: TextScaler.noScaling,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Record count badge
                _AppBarBadge(
                  icon: Icons.format_list_bulleted_rounded,
                  label: '$cashsummary records',
                ),
                const SizedBox(width: 8),
                // On-account balance badge
                _AppBarBadge(
                  icon: Icons.account_balance_wallet_rounded,
                  label: '₹${_shortAmount(totalBalance)}',
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Staff filter bar ───────────────────────────────────────────────────────
  Widget _buildStaffFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text('Staff', style: AppTypography.labelMD),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<GetStaffDetailsListModel>(
              key: formKey1,
              value: staffdetailsmodel.contains(selectedStaff)
                  ? selectedStaff
                  : null,
              isExpanded: true,
              hint: const Text('All'),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryXLight,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.primaryXXLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.primaryXXLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary, size: 22),
              items: [
                const DropdownMenuItem<GetStaffDetailsListModel>(
                  value: null,
                  child: Text('All'),
                ),
                ...staffdetailsmodel.map((staff) =>
                    DropdownMenuItem<GetStaffDetailsListModel>(
                      value: staff,
                      child: Text(staff.staffName ?? ''),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStaff = value;
                  if (value == null) {
                    getStaffLedgerReportList(0);
                    selectedReferredID = null;
                    selectedReferredName = null;
                  } else {
                    selectedReferredID = value.staffId?.toInt();
                    selectedReferredName = value.staffName;
                    getStaffLedgerReportList(selectedReferredID!);
                  }
                  isCheckedList.clear();
                  final filtered = selectedStaff == null
                      ? lederReportModel
                      : lederReportModel
                      .where((r) => r.staffId == selectedStaff?.staffId)
                      .toList();
                  isCheckedList =
                  List<bool>.generate(filtered.length, (_) => false);
                  _updateTotalBalance();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Balance type selector (replaces raw Radio rows) ────────────────────────
  Widget _buildBalanceTypeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _BalanceChip(
            label: 'Total Balance',
            value: '0.00',
            type: BalanceType.totalBalance,
            selected: _selectedBalanceType,
            enabled: false,
            onTap: null,
          ),
          const SizedBox(width: 8),
          _BalanceChip(
            label: 'Advance',
            value: '0.00',
            type: BalanceType.advance,
            selected: _selectedBalanceType,
            enabled: false,
            onTap: null,
          ),
          const SizedBox(width: 8),
          _BalanceChip(
            label: 'On Account',
            value: formatCurrency(totalBalance),
            type: BalanceType.onAccount,
            selected: _selectedBalanceType,
            enabled: true,
            onTap: (v) => setState(() => _selectedBalanceType = v),
          ),
        ],
      ),
    );
  }

  // ── Ledger list ────────────────────────────────────────────────────────────
  Widget _buildLedgerList(
      List<GetStaffLedgerReportModelList> filteredReports) {
    if (filteredReports.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final payList = filteredReports[index];

        // Ensure checkbox list is big enough
        if (isCheckedList.length <= index) isCheckedList.add(false);

        return _LedgerCard(
          index: index,
          payList: payList,
          isChecked: isCheckedList[index],
          formatCurrency: formatCurrency,
          onCheckChanged: (value) {
            if (selectedReferredID == null) {
              EasyLoading.showToast(
                Constants.OnAccErr,
                duration: const Duration(milliseconds: 3000),
              );
              return;
            }
            setState(() {
              isCheckedList[index] = value ?? false;
              isPaymentButtonEnabled = isCheckedList.contains(true);
            });
          },
        );
      },
    );
  }

  // ── Payment footer ─────────────────────────────────────────────────────────
  Widget _buildPaymentFooter(
      List<GetStaffLedgerReportModelList> filteredReports) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection summary
          if (isPaymentButtonEnabled)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${isCheckedList.where((c) => c).length} selected',
                    style: AppTypography.labelMD,
                    textScaler: TextScaler.noScaling,
                  ),
                  Text(
                    '₹${formatCurrency(_selectedTotal(filteredReports))}',
                    style: AppTypography.alertValue
                        .copyWith(color: AppColors.primary),
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            )
          else
            const Expanded(child: SizedBox()),
          // Payment button
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: isPaymentButtonEnabled
                  ? () {
                var selectedLedgerIds = <String>[];
                totalAmt = 0.0;

                for (int i = 0; i < filteredReports.length; i++) {
                  if (isCheckedList[i]) {
                    selectedLedgerIds.add(
                        filteredReports[i].ledgerId.toString());
                    totalAmt += filteredReports[i].balance ?? 0.0;
                  }
                }

                print('Total Selected Amount: $totalAmt');
                print('Selected Ledger IDs: $selectedLedgerIds');

                setState(() {
                  final firstSelectedReport = filteredReports
                      .firstWhere((report) => isCheckedList[
                  filteredReports.indexOf(report)]);

                  Navigator.pushNamed(
                    context,
                    OnAccountPopupScreen.screenName,
                    arguments: {
                      'ledgerIds': selectedLedgerIds,
                      'receiptDate':
                      firstSelectedReport.transDate.toString(),
                      'category':
                      firstSelectedReport.description.toString(),
                      'staffId':
                      firstSelectedReport.staffId.toString(),
                      'staffName':
                      firstSelectedReport.staffName.toString(),
                      'balance':
                      firstSelectedReport.balance.toString(),
                      'totalBalance': totalAmt.toString(),
                    },
                  );
                  print('Add Payment Clicked $selectedLedgerIds');
                });
              }
                  : null,
              icon: const Icon(Icons.payment_rounded, size: 18),
              label: const Text(
                'Payment',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                textScaler: TextScaler.noScaling,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaymentButtonEnabled
                    ? AppColors.primary
                    : AppColors.textDisabled,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.textDisabled,
                disabledForegroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                elevation: isPaymentButtonEnabled ? 2 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  double _selectedTotal(List<GetStaffLedgerReportModelList> reports) {
    double sum = 0.0;
    for (int i = 0; i < reports.length; i++) {
      if (i < isCheckedList.length && isCheckedList[i]) {
        sum += reports[i].balance ?? 0.0;
      }
    }
    return sum;
  }

  String _shortAmount(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0$formattedAmount';
    }
    return formattedAmount;
  }

  // ── API calls (all unchanged) ──────────────────────────────────────────────
  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? staffStatus = prefs.getString('StaffStatus');
    String? designation = prefs.getString('Designation');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        "GetStaffDetailsList : ${AppUrl.GetStaffDetailsList}/$distributorId/1/0");
    debugPrint("GetStaffDetailsList : ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        staffdetailsmodel =
            data.map((json) => GetStaffDetailsListModel.fromJson(json)).toList();
        staffdetailsmodel.sort((a, b) {
          final nameA = a.staffName ?? '';
          final nameB = b.staffName ?? '';
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getStaffLedgerReportList(int staffId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? userId = prefs.getString("UserId");
        String? addedBy = prefs.getString('StaffId');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "StaffId": staffId,
          "Flag": "OnAccount",
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetStaffLedgerReportMob_V1}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        debugPrint(
            "Response body GetCashHandOverDtls: ${response.body}");
        debugPrint(
            "Request body GetCashHandOverDtls: ${response.request}$requestBody");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            lederReportModel = data
                .map((jsonItem) =>
                GetStaffLedgerReportModelList.fromJson(jsonItem))
                .toList();
            _updateTotalBalance();
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
      }
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint(
          "Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint(
          "requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            print("Data is valid, proceeding to save.");
          } else {
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}

// =============================================================================
// _AppBarBadge
// Frosted-glass KPI pill used in the gradient AppBar.
// =============================================================================
class _AppBarBadge extends StatelessWidget {
  const _AppBarBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border:
        Border.all(color: Colors.white.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.1,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _BalanceChip
// Replaces the raw Radio + Column balance rows with themed pill cards.
// Shows label, value, and a selection ring when active.
// =============================================================================
class _BalanceChip extends StatelessWidget {
  const _BalanceChip({
    required this.label,
    required this.value,
    required this.type,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String value;
  final BalanceType type;
  final BalanceType? selected;
  final bool enabled;
  final ValueChanged<BalanceType?>? onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selected == type;
    final accentColor = enabled ? AppColors.primary : AppColors.textDisabled;
    final bgColor = isActive ? AppColors.primaryXLight : AppColors.surface;

    return Expanded(
      child: GestureDetector(
        onTap: enabled && onTap != null
            ? () {
          HapticFeedback.selectionClick();
          onTap!(type);
        }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? accentColor : AppColors.border,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                  enabled ? AppColors.textMuted : AppColors.textDisabled,
                  letterSpacing: 0.2,
                ),
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(height: 4),
              Text(
                '₹$value',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isActive ? accentColor : AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _LedgerCard
// Dashboard-style card for each ledger entry:
//   • Left-border accent (blue for credit, orange for debit)
//   • Description + staff name header
//   • Date / Debit / Credit / Balance data rows
//   • Integrated checkbox (themed pink → primary)
//   • Staggered slide+fade animation (mirrors AlertActionCard)
// =============================================================================
class _LedgerCard extends StatefulWidget {
  const _LedgerCard({
    required this.index,
    required this.payList,
    required this.isChecked,
    required this.formatCurrency,
    required this.onCheckChanged,
  });

  final int index;
  final GetStaffLedgerReportModelList payList;
  final bool isChecked;
  final String Function(double) formatCurrency;
  final ValueChanged<bool?> onCheckChanged;

  @override
  State<_LedgerCard> createState() => _LedgerCardState();
}

class _LedgerCardState extends State<_LedgerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
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
      child: SlideTransition(position: _slide, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    final payList = widget.payList;
    final debit = payList.debitAmt?.toDouble() ?? 0.0;
    final credit = payList.creditAmt?.toDouble() ?? 0.0;
    final balance = payList.balance?.toDouble() ?? 0.0;

    // Accent: primary for credit-heavy, orange for debit-heavy
    final hasDebit = debit > 0;
    final accentColor = hasDebit ? AppColors.orange : AppColors.primary;
    final accentBg =
    hasDebit ? AppColors.orangeXLight : AppColors.primaryXLight;

    String formattedDate = '';
    try {
      if (payList.transDate != null) {
        formattedDate = DateFormat('dd MMM yyyy')
            .format(DateTime.parse(payList.transDate!));
      }
    } catch (_) {
      formattedDate = payList.transDate ?? '';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isChecked
              ? AppColors.primaryXLight
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: widget.isChecked ? AppColors.primary : accentColor,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isChecked
                  ? AppColors.primary.withOpacity(0.10)
                  : AppColors.shadowCard,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: description + staff + checkbox ────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasDebit
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: accentColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payList.description ?? '—',
                          style: AppTypography.cardTitle,
                          textScaler: TextScaler.noScaling,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payList.staffName ?? '—',
                          style: AppTypography.labelMD,
                          textScaler: TextScaler.noScaling,
                        ),
                      ],
                    ),
                  ),
                  // Themed checkbox
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: widget.isChecked,
                      onChanged: widget.onCheckChanged,
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: widget.isChecked
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ── Divider ──────────────────────────────────────────
              Container(height: 1, color: AppColors.divider),
              const SizedBox(height: 10),
              // ── Data grid: date / debit / credit / balance ────────
              Row(
                children: [
                  Expanded(
                    child: _DataCell(
                      label: 'Date',
                      value: formattedDate,
                      valueColor: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: _DataCell(
                      label: 'Debit',
                      value: '₹${widget.formatCurrency(debit)}',
                      valueColor:
                      debit > 0 ? AppColors.orange : AppColors.textMuted,
                    ),
                  ),
                  Expanded(
                    child: _DataCell(
                      label: 'Credit',
                      value: '₹${widget.formatCurrency(credit)}',
                      valueColor:
                      credit > 0 ? AppColors.green : AppColors.textMuted,
                    ),
                  ),
                  Expanded(
                    child: _DataCell(
                      label: 'Balance',
                      value: '₹${widget.formatCurrency(balance)}',
                      valueColor: balance > 0
                          ? AppColors.primary
                          : AppColors.textMuted,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _DataCell
// Reusable label + value column used inside _LedgerCard data grid.
// =============================================================================
class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSM,
          textScaler: TextScaler.noScaling,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 13 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
            letterSpacing: -0.1,
          ),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// =============================================================================
// _EmptyState
// Shown when no ledger records are found.
// =============================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No Records Found',
              style: AppTypography.cardTitle,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 6),
            Text(
              'No ledger entries for the selected staff member.',
              style: AppTypography.cardSubtitle,
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}