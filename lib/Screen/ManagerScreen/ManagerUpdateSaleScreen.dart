import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'BootomNavigatinBarManager.dart';
import 'ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import 'package:http/http.dart' as http;

import 'ManagerModelClass/GetExpenceHeadAmountListModel.dart';
import 'ManagerModelClass/GetExpenseDetailListModel.dart';
import 'ManagerModelClass/RSPAmountOFItemListModel.dart';
import 'ManagerSingleItemUI/ManagerUpdateSaleListItem.dart';

class ManagerUpdateSaleScreen extends StatefulWidget {
  static const screenName = '/managerUpdateSaleScreen';
  const ManagerUpdateSaleScreen({super.key});

  @override
  State<ManagerUpdateSaleScreen> createState() => _ManagerUpdateSaleScreenState();
}

class _ManagerUpdateSaleScreenState extends State<ManagerUpdateSaleScreen> {
  TextEditingController searchController = TextEditingController();
  List<DilySaleSummaryDeliveryBoyWiseListModel> dailySales = [];
  List<GetExpenseDetailListModel> getExpenseDetailListModel = [];
  bool isLoading = true;

  /// Set to true while the "Submit All Sales" API chain is running so the FAB
  /// shows a progress indicator and cannot be double-tapped.
  bool isSubmitting = false;

  var argValue;
  String? delBoyNameName, receiptDate, receiptNoText, vehicleNos;
  int? delBoyId, salesGKId, vehicleIDs, expenseAmtTotal;
  String? formattedDate;
  double expenseTotalAmount = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        delBoyNameName = argValue["delBoyName"];
        receiptDate = argValue["receiptDate"];
        delBoyId = argValue["delBoyId"];
        salesGKId = argValue["saledgkID"];
        vehicleNos = argValue["vehicleNo"];
        vehicleIDs = argValue["vehicleID"];
        DateTime dateTime = DateTime.parse(receiptDate!);
        formattedDate =
            "${dateTime.year.toString().padLeft(4, '0')}-${(dateTime.month).toString().padLeft(2, '0')}-${(dateTime.day).toString().padLeft(2, '0')}";
        debugPrint("customerHoldingData :- ${delBoyNameName.toString()}");
        debugPrint("roleValue :- $receiptDate");
        debugPrint("roleValue :- $delBoyId");
        debugPrint("roleValue :- $salesGKId");
        fetchDailySales(delBoyId!, formattedDate!, salesGKId!);
        fetchAndInitialize();
        fetchExpenseDetailList();
      });
    });
  }

  // ---------------------------------------------------------------------------
  // SUBMIT ALL SALES — validation helpers
  // ---------------------------------------------------------------------------

  /// Returns the list of sale items that still need to be settled:
  /// items where all payment qtys/amounts are zero but actualSaleQty is not zero.
  List<DilySaleSummaryDeliveryBoyWiseListModel> get _unsettledItems =>
      dailySales.where((sale) =>
          (sale.cashQty == 0 &&
              sale.prepaidQty == 0 &&
              sale.postQty == 0 &&
              sale.creditQty == 0 &&
              sale.cashAmt == 0 &&
              sale.postAmt == 0 &&
              sale.actualSaleQty != 0)).toList();

  /// Returns true when there is at least one item whose payment details have
  /// already been entered (i.e. it was "Updated" but not yet settled via
  /// statusChangeApi).  Those items must be explicitly settled per-item by
  /// the existing Update/Edit flow.
  bool get _hasPendingEdits => dailySales.any((sale) =>
      (sale.cashQty != 0 ||
          sale.prepaidQty != 0 ||
          sale.postQty != 0 ||
          sale.creditQty != 0 ||
          sale.cashAmt != 0 ||
          sale.postAmt != 0) &&
      sale.actualSaleQty != 0 &&
      sale.dailySaleStatus != 13);

  /// Validate preconditions before initiating bulk submit.
  /// Returns an error message string, or null if everything is fine.
  String? _validateBeforeSubmit() {
    if (dailySales.isEmpty) {
      return 'No sale items loaded. Please wait for data to load.';
    }
    if (_hasPendingEdits) {
      return 'Some items have payment details entered but are not yet settled.\n'
          'Please tap "Edit" on each item and save before submitting all.';
    }
    if (_unsettledItems.isEmpty) {
      return 'All sale items are already settled. Nothing to submit.';
    }
    return null; // validation passed
  }

  // ---------------------------------------------------------------------------
  // SUBMIT ALL SALES — main flow
  // ---------------------------------------------------------------------------

  /// Shows a confirmation dialog.  On "Yes", submits all unsettled items in
  /// sequence via [DailySaleByGK_StatusUpdate] with flag=13 (Accepted).
  void _onSubmitAllSalesTapped() {
    final error = _validateBeforeSubmit();
    if (error != null) {
      showFlushBar(context, error);
      return;
    }

    _showSubmitConfirmationDialog();
  }

  void _showSubmitConfirmationDialog() {
    final unsettledCount = _unsettledItems.length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.check_circle_outline_rounded,
                    size: 32, color: AppColors.blue),
              ),
              const SizedBox(height: 16),
              Text(
                'Submit All Sales',
                style: AppTypography.cardTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'You are about to settle $unsettledCount item${unsettledCount == 1 ? '' : 's'} '
                'for ${delBoyNameName ?? 'this delivery man'}.\n\n'
                'This will mark them as "No Cash / SV-only" sales (flag = 13).\n'
                'This action cannot be undone.',
                style: AppTypography.cardSubtitle.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        _submitAllSales();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text('Yes, Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Iterates over all unsettled items and calls the status-update API
  /// (flag = 13 = Accepted / No-Cash settle) for each one in sequence.
  Future<void> _submitAllSales() async {
    // Network check
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? distributorId = prefs.getString('DistributorId');
    final String? bearerToken = prefs.getString('token');

    // Token guard
    if (bearerToken == null || bearerToken.isEmpty) {
      showFlushBar(context, 'Session expired. Please login again.');
      return;
    }

    if (!mounted) return;
    setState(() => isSubmitting = true);
    EasyLoading.show(status: 'Submitting sales…');

    debugPrint('[SubmitAllSales] Starting for distributorId=$distributorId, '
        'delBoyId=$delBoyId, items=${_unsettledItems.length}');

    int successCount = 0;
    int failCount = 0;

    for (final sale in _unsettledItems) {
      final int saleGk = sale.saleGKId?.toInt() ?? 0;
      final int saleGkItemId = sale.saleGKItemId?.toInt() ?? 0;
      const int flagUpdate = 13; // Accepted / No-cash settle

      try {
        final uri = Uri.parse(
          '${AppUrl.DailySaleByGK_StatusUpdate}'
          '/$distributorId/$saleGk/$saleGkItemId/$flagUpdate',
        );

        debugPrint('[SubmitAllSales] POST → $uri');

        final response = await http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
        );

        debugPrint('[SubmitAllSales] Response ${response.statusCode}: '
            '${response.body}');

        if (response.statusCode == 200) {
          successCount++;
          debugPrint('[SubmitAllSales] ✓ Settled saleGKItemId=$saleGkItemId');
        } else {
          failCount++;
          debugPrint('[SubmitAllSales] ✗ Failed saleGKItemId=$saleGkItemId '
              '(HTTP ${response.statusCode})');
        }
      } catch (e) {
        failCount++;
        debugPrint('[SubmitAllSales] ✗ Exception for saleGKItemId=$saleGkItemId: $e');
      }
    }

    EasyLoading.dismiss();

    if (!mounted) return;
    setState(() => isSubmitting = false);

    debugPrint('[SubmitAllSales] Done. success=$successCount, fail=$failCount');

    if (failCount == 0) {
      // All items settled successfully
      EasyLoading.showToast(
        'All $successCount item${successCount == 1 ? '' : 's'} submitted successfully!',
        duration: const Duration(milliseconds: 3000),
      );
      // Navigate back to bottom nav (index 2 = Delivery tab)
      if (mounted) {
        Navigator.pushNamed(context, BottomNavBarExample.screenName,
            arguments: 2);
      }
    } else if (successCount > 0) {
      // Partial success
      showFlushBar(
        context,
        '$successCount item${successCount == 1 ? '' : 's'} submitted. '
        '$failCount item${failCount == 1 ? '' : 's'} failed. Please retry.',
      );
      // Refresh the list so settled items are no longer shown as "Update"
      if (mounted) {
        fetchDailySales(delBoyId!, formattedDate!, salesGKId!);
      }
    } else {
      // All failed
      showFlushBar(
        context,
        'Submission failed for all items. Please check your connection and try again.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg2,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.gradHero),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
            Text('Update Sales Summary',
                style: AppTypography.heroTitle.copyWith(fontSize: 17)),
          ],
        ),
      ),
      // ── FAB: Submit All Sales ───────────────────────────────────────────────
      floatingActionButton: _buildSubmitFAB(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _infoRow(Icons.receipt_long_rounded, 'Receipt No',
                    receiptNoText ?? '—'),
                _divider(),
                _infoRow(Icons.calendar_today_rounded, 'Receipt Date',
                    formattedDate ?? '—'),
                _divider(),
                _infoRow(
                    Icons.person_rounded, 'Delivery Man', delBoyNameName ?? '—'),
                _divider(),
                _infoRow(
                    Icons.directions_car_rounded, 'Vehicle No.', vehicleNos ?? '—'),
                _divider(),
                _infoRow(
                  Icons.account_balance_wallet_rounded,
                  'Expense Amt.',
                  '₹ ${expenseTotalAmount.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 80), // extra bottom for FAB
              itemCount: dailySales.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ManagerUpdateSaleListItem(
                      dailySales[index], vehicleIDs, vehicleNos, receiptNoText),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "Submit All Sales" Floating Action Button.
  /// Shows a loading spinner while [isSubmitting] is true.
  /// Is disabled (greyed out) when [dailySales] is empty or all items are settled.
  Widget _buildSubmitFAB() {
    final bool hasUnsettled = _unsettledItems.isNotEmpty;
    final bool enabled = !isSubmitting && hasUnsettled;

    return FloatingActionButton.extended(
      key: const Key('submitAllSalesFAB'),
      heroTag: 'submitAllSalesFAB',
      onPressed: enabled ? _onSubmitAllSalesTapped : null,
      backgroundColor: enabled ? AppColors.blue : Colors.grey.shade400,
      elevation: enabled ? 4 : 0,
      icon: isSubmitting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : const Icon(Icons.check_circle_outline_rounded,
              color: Colors.white, size: 20),
      label: Text(
        isSubmitting
            ? 'Submitting…'
            : hasUnsettled
                ? 'Submit All (${_unsettledItems.length})'
                : 'All Settled',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXISTING HELPERS (unchanged)
  // ---------------------------------------------------------------------------

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.blue),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.cardSubtitle),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.cardTitle.copyWith(fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(color: AppColors.border, height: 1, thickness: 0.5);

  Future<void> fetchDailySales(
      int staffId, String delDate, int salesGKId) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      EasyLoading.dismiss();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Bearer token is missing');
        }

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "StaffId": staffId,
          "DelDate": delDate,
          "SaleGKId": salesGKId,
        };

        final response = await http.post(
          Uri.parse(AppUrl.GetDailySaleDetailsByStaffIdForMob),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        debugPrint(
            "Response body GetDailySaleDetailsByStaffIdForMob: ${response.body}");
        debugPrint(
            "Request body GetDailySaleDetailsByStaffIdForMob: ${response.request}$requestBody");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (mounted) {
            setState(() {
              dailySales = data
                  .map((jsonItem) =>
                      DilySaleSummaryDeliveryBoyWiseListModel.fromJson(jsonItem))
                  .toList();
              isLoading = false;
              EasyLoading.dismiss();
            });
          }
        } else {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        EasyLoading.dismiss();
        debugPrint("Error: $error");
      }
    }
  }

  Future<void> fetchAndInitialize() async {
    EasyLoading.show();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetDailySaleCollReceiptNo}/$distributorId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        String receiptNo = response.body.trim();
        receiptNo = receiptNo.replaceAll('"', '');
        if (mounted) {
          setState(() {
            receiptNoText = receiptNo;
            EasyLoading.dismiss();
          });
        }
      } else {
        EasyLoading.dismiss();
        debugPrint('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error: $e');
    }
  }

  Future<void> fetchExpenseDetailList() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      EasyLoading.dismiss();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetExpenseDetailsListByStaffId}/$distributorId/$delBoyId/1/0'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        debugPrint(
            "Response body GetExpenseDetailsListByStaffId: ${response.body}");
        debugPrint(
            "request body GetExpenseDetailsListByStaffId: ${response.request}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (mounted) {
            setState(() {
              getExpenseDetailListModel = data
                  .map((jsonItem) =>
                      GetExpenseDetailListModel.fromJson(jsonItem))
                  .toList();
              isLoading = false;
              EasyLoading.dismiss();
            });
          }
          double expenseDetailList = 0;
          for (var i = 0; i < getExpenseDetailListModel.length; i++) {
            double? amt =
                getExpenseDetailListModel[i].expAmount?.toDouble();
            expenseDetailList += amt ?? 0;
          }
          debugPrint("Response body expenseDetailList: $expenseDetailList");
          if (mounted) setState(() => expenseTotalAmount = expenseDetailList);
        } else {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        EasyLoading.dismiss();
        debugPrint("Error: $error");
      }
    }
  }
}

