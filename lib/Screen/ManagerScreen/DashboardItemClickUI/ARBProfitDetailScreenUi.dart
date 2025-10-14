import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/ARBProfitDetailDataGetModel.dart';

class ARBProfitDetailScreenUi extends StatefulWidget {
  static const screenName = '/aRBProfitDetailScreenUi';
  const ARBProfitDetailScreenUi({super.key});

  @override
  State<ARBProfitDetailScreenUi> createState() => _ARBProfitDetailScreenUiState();
}

class _ARBProfitDetailScreenUiState extends State<ARBProfitDetailScreenUi> {
  late List<ArbProfitDetailDataGetModel> arbProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;
  double?  grossSaleAmts = 0;
  double? grossProfitAmts = 0;
  double? purchaseAmts = 0;
  int purchaseQtys = 0;
  String? profitFors;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      final String dayFlags = argValue?["DAYFLAG"] ?? '';
       profitFors = argValue?["PROFITFOR"] ?? '';
      flags = dayFlags;
      debugPrint("flags $flags");
      fetchARBDetailList(profitFors!,dayFlags);
    });
  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            surfaceTintColor: Color(0xFFECEFFF),
            backgroundColor: Color(0xFFECEFFF),
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "ARB ${profitFors == "GrossRevenue"?"Gross Revenue":profitFors == "GrossProfit"?"Gross Profit":""} -",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          flags == "TODAYS"?"Today's":flags == "THISMONTH"?"This Month":flags == "FINYEAR"?"Financial Year":"",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(height: 0.5,color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Item Name',
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Qty",
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Gross Sale Amt.",
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      profitFors == "GrossProfit"?
                      verticalDividerVerySmallWidth():Container(),

                      profitFors == "GrossProfit"?
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Purchase Amt.",
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ):Container(),
                      profitFors == "GrossProfit"?
                      verticalDividerVerySmallWidth():Container(),
                      profitFors == "GrossProfit"?
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Gross Profit Amt.",
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ):Container(),
                    ],
                  ),
                  Container(height: 0.5,color: Colors.grey,),
                ],
              ),

            ),
            // Scrollable ListView for content
            Expanded(
              child:
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    arbProfitDetailDataGetModel.isNotEmpty?
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: arbProfitDetailDataGetModel.length,
                      itemBuilder: (context, index) {
                        ArbProfitDetailDataGetModel? arb = arbProfitDetailDataGetModel[index];
                        return
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        arb.itemName.toString(),
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    verticalDividerVerySmallWidth(),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        arb.itemQty!.toString(),
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    verticalDividerVerySmallWidth(),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        arb.grossSaleAmt != null
                                            ? formatCurrency(
                                            arb.grossSaleAmt!.toDouble())
                                            : '0',
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    profitFors == "GrossProfit"?
                                    verticalDividerVerySmallWidth():Container(),
                                    profitFors == "GrossProfit"?
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        arb.purchesAmt != null
                                            ? formatCurrency(
                                            arb.purchesAmt!.toDouble())
                                            : '0',
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    ):Container(),
                                    profitFors == "GrossProfit"?
                                    verticalDividerVerySmallWidth():Container(),
                                    profitFors == "GrossProfit"?
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        arb.grossProfitAmt != null
                                            ? formatCurrency(
                                            arb.grossProfitAmt!.toDouble())
                                            : '0',
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    ):Container(),
                                  ],
                                ),
                                Container(height: 0.5,color: Colors.grey,),
                              ],
                            ),
                          );
                      },
                    )
                        : const Text('No Records Found'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
              child: Column(
                children: [
                  Container(height: 0.5,color: Colors.grey,),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Total',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          purchaseQtys != null
                              ? purchaseQtys.toString()
                              : '0',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          grossSaleAmts != null
                              ? formatCurrency(
                              grossSaleAmts!.toDouble())
                              : '0',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      profitFors == "GrossProfit"?
                      verticalDividerVerySmallWidth():Container(),
                      profitFors == "GrossProfit"?
                      Expanded(
                        flex: 2,
                        child: Text(
                          purchaseAmts != null
                              ? formatCurrency(
                              purchaseAmts!.toDouble())
                              : '0',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.center,
                        ),
                      ):Container(),
                      profitFors == "GrossProfit"?
                      verticalDividerVerySmallWidth():Container(),
                      profitFors == "GrossProfit"?
                      Expanded(
                        flex: 2,
                        child: Text(
                          grossProfitAmts != null
                              ? formatCurrency(
                              grossProfitAmts!.toDouble())
                              : '0',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.center,
                        ),
                      ):Container(),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchARBDetailList(String profitFor , String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    try{
      final response = await http.get(
        Uri.parse('${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$profitFor/$flag'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetDashboardARBProfitDtls_Mob request" + '${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$profitFor/$flag');
      debugPrint("GetDashboardARBProfitDtls_Mob resposnse" + '${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint("GetDashboardARBProfitDtls_Mob" + '$data');
        setState(() {
          arbProfitDetailDataGetModel = data
              .map((json) => ArbProfitDetailDataGetModel.fromJson(json))
              .toList();

          double grossSaleAmt = 0;
          double grossProfitAmt = 0;
          double purchaseAmt = 0;
          int purchaseQty = 0;

          for (var arbProfit in arbProfitDetailDataGetModel) {
            grossSaleAmt += (arbProfit.grossSaleAmt ?? 0).toDouble();
            grossProfitAmt += (arbProfit.grossProfitAmt ?? 0).toDouble();
            purchaseAmt += (arbProfit.purchesAmt ?? 0).toDouble();
            purchaseQty += (arbProfit.itemQty ?? 0).toInt();
          }
          grossSaleAmts = grossSaleAmt;
          grossProfitAmts = grossProfitAmt;
          purchaseAmts = purchaseAmt;
          purchaseQtys = purchaseQty;

          isLoading = false;
          EasyLoading.dismiss();
        });

      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load items');
      }
    }catch(e){
      EasyLoading.dismiss();
      debugPrint("Exceptin $e");
    }

  }
  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format =
    NumberFormat('#,##,###.00', 'en_IN'); // Indian locale without symbol

    return format.format(amount);
  }
}
