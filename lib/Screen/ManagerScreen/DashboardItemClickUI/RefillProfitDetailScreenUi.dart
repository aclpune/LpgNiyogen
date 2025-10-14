import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/RefillProfitDetailDataGetModel.dart';

class RefillProfitDetailScreenUi extends StatefulWidget {
  static const screenName = '/refillProfitDetailScreenUi';
  const RefillProfitDetailScreenUi({super.key});

  @override
  State<RefillProfitDetailScreenUi> createState() => _RefillProfitDetailScreenUiState();
}

class _RefillProfitDetailScreenUiState extends State<RefillProfitDetailScreenUi> {
  late List<RefillProfitDetailDataGetModel> refillProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;
  double?  grossRevenueAmts = 0;
  double?  grossProfitAmts = 0;
  int saleQtys = 0;
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
      fetchRefillDetailList(profitFors!,dayFlags);
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
                          "Refill ${profitFors == "GrossRevenue"?"Gross Revenue":profitFors == "GrossProfit"?"Gross Profit":""} -",
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
                          "Sale Qty",
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Gross Revenue",
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
                          "Gross Profit ",
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
                    refillProfitDetailDataGetModel.isNotEmpty?
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: refillProfitDetailDataGetModel.length,
                      itemBuilder: (context, index) {
                        RefillProfitDetailDataGetModel? refill = refillProfitDetailDataGetModel[index];
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
                                        refill.itemName.toString(),
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    verticalDividerVerySmallWidth(),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        refill.saleQty!.toString(),
                                        style: Styling.buttonTextBlack,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    verticalDividerVerySmallWidth(),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        refill.grossRevenue != null
                                            ? formatCurrency(
                                            refill.grossRevenue!.toDouble())
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
                                        refill.grossProfit != null
                                            ? formatCurrency(
                                            refill.grossProfit!.toDouble())
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
                          saleQtys != null
                              ? saleQtys.toString()
                              : '0',
                          style: Styling.itemBlackTestSmallReportBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmallWidth(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          grossRevenueAmts != null
                              ? formatCurrency(
                              grossRevenueAmts!.toDouble())
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

  Future<void> fetchRefillDetailList(String profitFor , String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    try{
      final response = await http.get(
        Uri.parse('${AppUrl.GetDashboardProductListForMob}/$distributorId/$profitFor/$flag'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetDashboardProductListForMob request" + '${AppUrl.GetDashboardProductListForMob}/$distributorId/$profitFor/$flag');
      debugPrint("GetDashboardProductListForMob resposnse" + '${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint("GetDashboardProductListForMob" + '$data');
        setState(() {
          refillProfitDetailDataGetModel = data
              .map((json) => RefillProfitDetailDataGetModel.fromJson(json))
              .toList();

          double grossRevenueAmt = 0;
          double grossProfitAmt = 0;
          int saleQty = 0;

          for (var refillProfit in refillProfitDetailDataGetModel) {
            grossRevenueAmt += (refillProfit.grossRevenue ?? 0).toDouble();
            grossProfitAmt += (refillProfit.grossProfit ?? 0).toDouble();
            saleQty += (refillProfit.saleQty ?? 0).toInt();
          }
          grossRevenueAmts = grossRevenueAmt;
          grossProfitAmts = grossProfitAmt;
          saleQtys = saleQty;

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
