import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DSRItemClickUI/ManagerDSRExpenseUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreenItemUI.dart';
import '../../GodownKeeper/DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/DSRReportExpenseModel.dart';
import '../ClickModelClass/DSRReportScreenDetailModel.dart';
import 'ManagerDSRReportScreenItemUI.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerDSRReportScreenDetails extends StatefulWidget {
  static const screenName = '/managerDSRReportScreenDetails';
  ManagerDSRReportScreenDetails({super.key});

  @override
  _ManagerDSRReportScreenDetailsState createState() => _ManagerDSRReportScreenDetailsState();
}

class _ManagerDSRReportScreenDetailsState extends State<ManagerDSRReportScreenDetails> {
  List<DsrReportScreenDetailModel> getDSRReportScreenDetailmodel = [];
  List<DsrReportExpenseModel> getDSRReportExpensemodel = [];
  bool isLoading = true;
  var argValue;
  String? screenMode;
  DateTime? date;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        screenMode = argValue["ScreenMode"];
        date = argValue["Date"];
        debugPrint("customerHoldingData :- ${screenMode.toString()}");
        debugPrint("customerHoldingData :- ${date.toString()}");
        fetchDSRData(screenMode!);
        fetchExpenseData(screenMode!);
      });
    });
  }

  // Method to calculate total cash
  getTotalCash() {
    double totalCash = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.cashAmt != null) {
        totalCash += item.cashAmt!;
      }
    }
    return totalCash;
  }

  // Method to calculate total bank amount
  getTotalBank() {
    double totalBank = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.merchantQR != null) {
        totalBank += item.merchantQR!;
      }
    }
    return totalBank;
  }

  // Method to calculate total credit amount
  getTotalCredit() {
    double totalCredit = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.creditAmt != null) {
        totalCredit += item.creditAmt!;
      }
    }
    return totalCredit;
  }

  getTotalPrepaidOnline() {
    double totalPrepaidOnline = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.prepaidAmt != null) {
        totalPrepaidOnline += item.prepaidAmt!;
      }
    }
    return totalPrepaidOnline;
  }

  getExpenseCashAmount() {
    double totalCredit = 0.0;
    for (var item in getDSRReportExpensemodel) {
      if (item.cash != null) {
        totalCredit += item.cash!;
      }
    }
    return totalCredit;
  }

  getExpenseBankAmount() {
    double totalCredit = 0.0;
    for (var item in getDSRReportExpensemodel) {
      if (item.bank != null) {
        totalCredit += item.bank!;
      }
    }
    return totalCredit;
  }

  Future<void> fetchExpenseData(String flag) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        // DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        debugPrint("formattedDate :- ${formattedDate.toString()}");
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,
          "Flag": flag
          // Example: you can replace this with `distributorId` if needed

        };
        final response = await http.post(
          Uri.parse('${AppUrl.GetexpensepopupList_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetexpensepopupList_Mob: ${response.body}");
        debugPrint("Request body GetexpensepopupList_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDSRReportExpensemodel = data.map((jsonItem) =>
                DsrReportExpenseModel.fromJson(jsonItem)).toList();
            // filteredSales = dailySales;
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  // Method to fetch data from the API
  Future<void> fetchDSRData(String flag) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        debugPrint("formattedDate :- ${formattedDate.toString()}");
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,
          "Flag": flag
          // Example: you can replace this with `distributorId` if needed

        };
        final response = await http.post(
          Uri.parse('${AppUrl.GetCashflowpopupList_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetCashflowpopupList_Mob: ${response.body}");
        debugPrint("Request body GetCashflowpopupList_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDSRReportScreenDetailmodel = data.map((jsonItem) =>
                DsrReportScreenDetailModel.fromJson(jsonItem)).toList();
            // filteredSales = dailySales;
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }
  //To show screen mode title in lower case
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) formattedAmount = '0' + formattedAmount;
    return formattedAmount;
  }

  // Mode-based accent color
  Color get _modeColor {
    switch (screenMode) {
      case 'Cash': return AppColors.green;
      case 'MERCHANT': return AppColors.teal;
      case 'Credit': return AppColors.amber;
      case 'PREPAID': return AppColors.orange;
      case 'Expenses': return AppColors.red;
      default: return AppColors.blue;
    }
  }

  IconData get _modeIcon {
    switch (screenMode) {
      case 'Cash': return Icons.payments_rounded;
      case 'MERCHANT': return Icons.qr_code_rounded;
      case 'Credit': return Icons.credit_card_rounded;
      case 'PREPAID': return Icons.online_prediction_rounded;
      case 'Expenses': return Icons.receipt_long_rounded;
      default: return Icons.bar_chart_rounded;
    }
  }

  Widget _buildHeaderRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _modeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _modeColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('Sr.', style: AppTypography.labelMD.copyWith(color: _modeColor))),
          Expanded(
            flex: 3,
            child: Text(
              screenMode == 'Expenses' ? 'Expense Head' : 'Item Name',
              style: AppTypography.labelMD.copyWith(color: _modeColor),
            ),
          ),
          if (screenMode == 'Credit') ...[
            Expanded(flex: 2, child: Text('Qty.', style: AppTypography.labelMD.copyWith(color: _modeColor))),
            Expanded(flex: 3, child: Text('Customer', style: AppTypography.labelMD.copyWith(color: _modeColor))),
          ],
          Expanded(
            flex: 2,
            child: Text(
              screenMode == 'Expenses' ? 'Cash / Bank' : 'Amount',
              style: AppTypography.labelMD.copyWith(color: _modeColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalFooter() {
    String label;
    double value;
    if (screenMode == 'Cash') {
      label = 'Total Cash'; value = getTotalCash().toDouble();
    } else if (screenMode == 'MERCHANT') {
      label = 'Total Merchant QR'; value = getTotalBank().toDouble();
    } else if (screenMode == 'Credit') {
      label = 'Total Credit'; value = getTotalCredit().toDouble();
    } else if (screenMode == 'PREPAID') {
      label = 'Total Prepaid'; value = getTotalPrepaidOnline().toDouble();
    } else {
      // Expenses - two values
      return Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(gradient: AppColors.gradWarn, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Column(children: [
                Text('Cash Total', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                Text('₹ ${formatCurrency(getExpenseCashAmount().toDouble())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
              ]),
            ),
            Container(width: 1, height: 36, color: Colors.white30),
            Expanded(
              child: Column(children: [
                Text('Bank Total', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                Text('₹ ${formatCurrency(getExpenseBankAmount().toDouble())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
              ]),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: screenMode == 'Cash' ? AppColors.gradGreen
            : screenMode == 'MERCHANT' ? const LinearGradient(colors: [AppColors.teal, AppColors.tealLight])
            : screenMode == 'Credit' ? AppColors.gradWarn
            : AppColors.gradWarn,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelMD.copyWith(color: Colors.white70)),
          Text('₹ ${formatCurrency(value)}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.gradHero)),
        title: Row(
          children: [
            Icon(_modeIcon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              screenMode != null ? '${_capitalize(screenMode!.toLowerCase())} Details' : 'Details',
              style: AppTypography.heroTitle,
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : Column(
              children: [
                _buildHeaderRow(),
                Expanded(
                  child: screenMode == "Expenses"
                      ? (getDSRReportExpensemodel.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: getDSRReportExpensemodel.length,
                              itemBuilder: (context, index) {
                                debugPrint("Rendering Expense Item: ${getDSRReportExpensemodel[index]}");
                                return ManagerDSRExpenseUI(getDSRReportExpensemodel[index], screenMode!, index + 1);
                              },
                            )
                          : _emptyState())
                      : (getDSRReportScreenDetailmodel.isNotEmpty &&
                              getDSRReportScreenDetailmodel.any((item) =>
                                  screenMode == "Credit" ? item.creditAmt! > 0 :
                                  screenMode == "Cash" ? item.cashAmt! > 0 :
                                  screenMode == "PREPAID" ? item.prepaidAmt! > 0 :
                                  screenMode == "MERCHANT" ? item.merchantQR! > 0 : false)
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: screenMode == "Cash"
                                  ? getDSRReportScreenDetailmodel.where((i) => i.cashAmt! > 0).length
                                  : screenMode == "MERCHANT"
                                      ? getDSRReportScreenDetailmodel.where((i) => i.merchantQR != null && i.merchantQR! > 0).length
                                      : screenMode == "Credit"
                                          ? getDSRReportScreenDetailmodel.where((i) => i.creditAmt! > 0).length
                                          : screenMode == "PREPAID"
                                              ? getDSRReportScreenDetailmodel.where((i) => i.prepaidAmt! > 0).length
                                              : getDSRReportScreenDetailmodel.length,
                              itemBuilder: (context, index) {
                                final filteredList = screenMode == "Cash"
                                    ? getDSRReportScreenDetailmodel.where((i) => i.cashAmt != null && i.cashAmt! > 0).toList()
                                    : screenMode == "MERCHANT"
                                        ? getDSRReportScreenDetailmodel.where((i) => i.merchantQR != null && i.merchantQR! > 0).toList()
                                        : screenMode == "Credit"
                                            ? getDSRReportScreenDetailmodel.where((i) => i.creditAmt != null && i.creditAmt! > 0).toList()
                                            : screenMode == "PREPAID"
                                                ? getDSRReportScreenDetailmodel.where((i) => i.prepaidAmt != null && i.prepaidAmt! > 0).toList()
                                                : getDSRReportScreenDetailmodel;
                                return ManagerDSRReportScreenItemUI(filteredList[index], screenMode!, index + 1);
                              },
                            )
                          : _emptyState()),
                ),
                _buildTotalFooter(),
              ],
            ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_rounded, size: 48, color: AppColors.border2),
        const SizedBox(height: 8),
        Text('No Records Found', style: AppTypography.cardSubtitle),
      ],
    ),
  );
}

