import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetexpensepopupListModel.dart';
import 'ManagerExpenseTabScreenUI.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerExpenseTabScreenDetails extends StatefulWidget {
  static const screenName = '/managerExpenseTabScreenDetails';
  @override
  State<StatefulWidget> createState() => _ManagerExpenseTabScreenDetailsState();
}

class _ManagerExpenseTabScreenDetailsState extends State<ManagerExpenseTabScreenDetails> {
  late List<GetexpensepopupListModel> getExpenseModel = [];
  bool isLoading = true;
  var argValue;
  String? flag;
  DateTime? date;
  int? expenseHeadId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue["FlagCheck"] ?? '';
        date = argValue["Date"] ?? '';
        expenseHeadId = argValue["expenseHeadId"] ?? '';
        debugPrint("flag :- ${flag.toString()}");
        debugPrint("date :- ${date.toString()}");
        debugPrint("expenseHeadId :- ${expenseHeadId.toString()}");
        fetchExpenseData(flag!, expenseHeadId!);
      });
    });
  }

  Future<void> fetchExpenseData(String flag, int expenseHeadId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) { showFlushBar(context, Constants.connectionMessage); isLoading = false; return; }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
      debugPrint("formattedDate :- ${formattedDate.toString()}");
      if (bearerToken == null) { isLoading = false; throw Exception('Bearer token is missing'); }
      Map<String, dynamic> requestBody = { "DistributorId": distributorId, "Date": formattedDate, "ExpHeadId": expenseHeadId, "Flag": flag };
      final response = await http.post(Uri.parse('${AppUrl.GetexpensepopupListOnAccount_Mob}'),
          headers: { 'Authorization': 'Bearer $bearerToken', 'Content-Type': 'application/json' },
          body: json.encode(requestBody));
      debugPrint("Response body GetexpensepopupListOnAccount_Mob: ${response.body}");
      debugPrint("Request body GetexpensepopupListOnAccount_Mob: ${response.request}${requestBody}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() { getExpenseModel = data.map((j) => GetexpensepopupListModel.fromJson(j)).toList(); isLoading = false; });
      } else { isLoading = false; throw Exception('Failed to load sales data'); }
    } catch (error) { isLoading = false; debugPrint("Error: $error"); }
  }

  getCashTotal() { double t = 0.0; for (var i in getExpenseModel) { num? a = i.cash; if (a! > 0) t += a; else t += a; } return t; }
  getBankTotal() { double t = 0.0; for (var i in getExpenseModel) { num? a = i.bank; if (a! > 0) t += a; else t += a; } return t; }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) formattedAmount = '0' + formattedAmount;
    return formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    var sale = getExpenseModel;
    String? titleText = sale.isNotEmpty ? sale[0].expensehead : 'No Items';
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.gradHero)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Expense: $titleText',
                style: AppTypography.heroTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red))
          : Column(
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.redXL,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.redXXL),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text('Sr.', style: AppTypography.labelMD.copyWith(color: AppColors.red), textAlign: TextAlign.center)),
                      Expanded(flex: 4, child: Text('Staff Name', style: AppTypography.labelMD.copyWith(color: AppColors.red))),
                      Expanded(flex: 2, child: Text('Qty', style: AppTypography.labelMD.copyWith(color: AppColors.red))),
                      Expanded(flex: 3, child: Text('Cash', style: AppTypography.labelMD.copyWith(color: AppColors.red), textAlign: TextAlign.right)),
                      Expanded(flex: 3, child: Text('Bank', style: AppTypography.labelMD.copyWith(color: AppColors.red), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: getExpenseModel.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: getExpenseModel.length,
                          itemBuilder: (context, index) {
                            debugPrint("Rendering Expense Item: ${getExpenseModel[index]}");
                            return ManagerExpenseTabScreenUI(getExpenseModel[index], index + 1, flag!);
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_rounded, size: 48, color: AppColors.border2),
                              const SizedBox(height: 8),
                              Text('No Records Found', style: AppTypography.cardSubtitle),
                            ],
                          ),
                        ),
                ),
                // Footer totals
                Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(gradient: AppColors.gradRed, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Text('Total Cash', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                          Text('₹ ${formatCurrency(getCashTotal().toDouble())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
                        ]),
                      ),
                      Container(width: 1, height: 36, color: Colors.white30),
                      Expanded(
                        child: Column(children: [
                          Text('Total Bank', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                          Text('₹ ${formatCurrency(getBankTotal().toDouble())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

