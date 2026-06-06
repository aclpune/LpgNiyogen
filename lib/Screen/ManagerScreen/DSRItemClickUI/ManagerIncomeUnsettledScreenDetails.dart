import 'dart:convert';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetUnsettledAmountListModel.dart';
import 'ManagerIncomeUnsettledScreenDetailUI.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerIncomeUnsettledScreenDetails extends StatefulWidget {
  static const screenName = '/managerIncomeUnsettledScreenDetails';
  ManagerIncomeUnsettledScreenDetails({super.key});

  @override
  _ManagerIncomeUnsettledScreenDetails createState() => _ManagerIncomeUnsettledScreenDetails();
}

class _ManagerIncomeUnsettledScreenDetails extends State<ManagerIncomeUnsettledScreenDetails> {
  late List<GetUnsettledAmountListModel> unsettledModelList = [];
  bool isLoading = true;
  var argValue;
  int? flag;
  DateTime? date;
  int? itemIds;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue["FlagCheck"] ?? '';
        date = argValue["Date"] ?? '';
        itemIds = argValue["itemId"] ?? '';
        debugPrint("flag :- ${flag.toString()}");
        debugPrint("date :- ${date.toString()}");
        debugPrint("itemIds :- ${itemIds.toString()}");
        fetchUnsettledData(flag!, itemIds!);
      });
    });
  }

  Future<void> fetchUnsettledData(int flag, int itemId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) { showFlushBar(context, Constants.connectionMessage); isLoading = false; return; }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
      debugPrint("formattedDate :- ${formattedDate.toString()}");
      if (bearerToken == null) { isLoading = false; throw Exception('Bearer token is missing'); }
      Map<String, dynamic> requestBody = { "DistributorId": distributorId, "Date": formattedDate, "ItemId": itemId, "Flag": flag };
      final response = await http.post(Uri.parse('${AppUrl.GetUnsettledAmountList_Mob}'),
          headers: { 'Authorization': 'Bearer $bearerToken', 'Content-Type': 'application/json' },
          body: json.encode(requestBody));
      debugPrint("Response body GetUnsettledAmountList_Mob: ${response.body}");
      debugPrint("Request body GetUnsettledAmountList_Mob: ${response.request}${requestBody}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() { unsettledModelList = data.map((j) => GetUnsettledAmountListModel.fromJson(j)).toList(); isLoading = false; });
      } else { isLoading = false; throw Exception('Failed to load sales data'); }
    } catch (error) { isLoading = false; debugPrint("Error: $error"); }
  }

  double getTotalCash() {
    double totalAmount = 0.0;
    for (var item in unsettledModelList) {
      num? amount = item.amount;
      if (amount! > 0) totalAmount += amount; else totalAmount += amount;
    }
    return totalAmount;
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) formattedAmount = '0' + formattedAmount;
    return formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    var sale = unsettledModelList;
    String? titleText = sale.isNotEmpty ? sale[0].itemName : 'No Items';
    final accentColor = flag == 1 ? AppColors.amber : AppColors.green;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.gradHero)),
        title: Row(
          children: [
            Icon(flag == 1 ? Icons.pending_actions_rounded : Icons.check_circle_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Sale Against: $titleText', style: AppTypography.heroTitle, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : Column(
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accentColor.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text('Sr.', style: AppTypography.labelMD.copyWith(color: accentColor))),
                      Expanded(flex: 3, child: Text('Staff Name', style: AppTypography.labelMD.copyWith(color: accentColor))),
                      Expanded(flex: 1, child: Text('Qty', style: AppTypography.labelMD.copyWith(color: accentColor))),
                      Expanded(flex: 2, child: Text('Amount', style: AppTypography.labelMD.copyWith(color: accentColor), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: unsettledModelList.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: unsettledModelList.length,
                          itemBuilder: (context, index) {
                            debugPrint("Rendering Expense Item: ${unsettledModelList[index]}");
                            return ManagerIncomeUnsettledScreenDetailUI(unsettledModelList[index], index + 1);
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
                // Footer
                Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: flag == 1 ? AppColors.gradWarn : AppColors.gradGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                      Text('₹ ${formatCurrency(getTotalCash())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

