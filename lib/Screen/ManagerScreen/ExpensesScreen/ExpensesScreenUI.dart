import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetDashboardFYGrossProfitDtlsModel.dart';
import 'GetDashboardFYGrossExpenseDtlsModel.dart';
import 'HeadWiseExpenseLstModel.dart';

class ExpensesScreenUI extends StatefulWidget{
  static const screenName = '/expensesScreenUI';

  @override
  State<ExpensesScreenUI> createState() => _ExpensesScreenUIState();

}

class _ExpensesScreenUIState extends  State<ExpensesScreenUI>{
  bool isLoading = true;
  List<String> regulatorReceived = ["Today's", "This Month","Financial Year"];
  String? selectedRegulatorReceived;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  List<String> regReceived = ["Prev Year", "This Year"];
  String? selectedRegReceived;
  double value = 50;
  List<HeadWiseExpenseLstModel> expenseReportModel = [];
  double? expAmtPerYear;
  double? expAmtTodays;
  double? expAmtPerMonth;
  double totalExpense = 0.0;
  double? percentage;
  final List<Color> expenseColors = [
    const Color(0xFF248BFA),
    const Color(0xFF67d1fb),
    const Color(0xFFfed06a),
    const Color(0xFF6e69e2),
    const Color(0xFF873e23),
  ];
  List<double> segmentPercentages = [];
  List<Color> segmentColors = [];
  bool isOn = false;
  List<GetDashboardFyGrossExpenseDtlsModel> grossExpenseModel = [];
  List<GetDashboardFyGrossProfitDtlsModel> grossProfitModel = [];
  GetDashboardFyGrossExpenseDtlsModel? selectedExpenseModel;
  List<MonthProfitData> profitDataForChart = [];
  List<MonthProfitData> expenseDataForChart = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  // late TooltipBehavior _tooltipBehavior;



  @override
  void initState() {
    super.initState();
    getHeadWiseExpenseLstModel("THISMONTH");
    getDashboardData("FINYEAR");
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      header: '',
      canShowMarker: true,
      // 👇 Add number format
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        final value = (data as MonthProfitData).profit;
        return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '${data.month}: ₹${value?.toStringAsFixed(2)}', // ✅ Format to 2 decimal points
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute
        .of(context)
        ?.settings
        .arguments;


    Map<String, double> groupedExpenses = {};
    for (var item in expenseReportModel!) {
      String groupName = item.parentExpHeadName ?? '';
      double groupExpense = item.totExpAmt?.toDouble() ?? 0.0;

      if (groupedExpenses.containsKey(groupName)) {
        groupedExpenses[groupName] = groupedExpenses[groupName]! + groupExpense;
      } else {
        groupedExpenses[groupName] = groupExpense;
      }
    }

    final double barWidth = 50;
    final double barSpacing = 8;
    final int itemCount = 22;
    final double chartWidth = (barWidth + barSpacing) * itemCount;



    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        }
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Color(0xFFECEFFF),
          backgroundColor: Color(0xFFECEFFF),
          flexibleSpace: SafeArea(
            child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            isOn?"Revenue Vs Expense":"Top Expenses",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        // SizedBox(width: 170,),
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Transform.scale(
                        //         scale: 0.9, // Adjust the scale value as needed
                        //         child: Column(
                        //           children: [
                        //             Switch(
                        //               value: isOn,
                        //               onChanged: (bool value) {
                        //                 setState(() {
                        //                   isOn = value;
                        //                 });
                        //               },
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SingleChildScrollView(
            child:
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isOn?
                      SizedBox(
                        width: 140,  // Control the width of the dropdown
                        child: DropdownButton<String>(
                          value: selectedRegReceived ?? "This Year",
                          items: regReceived.map((transMode) {
                            return DropdownMenuItem<String>(
                              value: transMode,
                              child: Text(
                                transMode,
                                style: Styling.itemBlackTestOne,
                                textScaler: TextScaler.noScaling,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegReceived = value;
                              grossExpenseModel.clear();
                              grossProfitModel.clear();
                            });
                            if (selectedRegReceived == "This Year") {
                              getDashboardData("FINYEAR");
                            } else if (selectedRegReceived == "Prev Year") {
                              getDashboardData("PREFINYEAR");
                            }
                          },
                          isExpanded: true,
                        ),
                      ):
                      SizedBox(
                        width: 140,
                        child:
                        DropdownButton<String>(
                          value: selectedRegulatorReceived ?? "This Month",
                          items: (regulatorReceived ?? []).map((transMode) {
                            return DropdownMenuItem<String>(
                              value: transMode,
                              child: Text(
                                transMode,
                                style: Styling.itemBlackTestOne,
                                textScaler:
                                TextScaler.noScaling,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegulatorReceived = value;
                              expenseReportModel = [];
                              segmentPercentages.clear();
                              segmentColors.clear();
                            });
                            if (selectedRegulatorReceived == "Today's") {
                              getHeadWiseExpenseLstModel("TODAYS");
                            } else if (selectedRegulatorReceived ==
                                "This Month") {
                              getHeadWiseExpenseLstModel("THISMONTH");
                            } else if (selectedRegulatorReceived ==
                                "Financial Year") {
                              getHeadWiseExpenseLstModel("FINYEAR");
                            }
                          },
                          isExpanded: true,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.7, // Adjust the scale value as needed
                        child: Column(
                          children: [
                            Switch(
                              value: isOn,
                              onChanged: (bool value) {
                                setState(() {
                                  isOn = value;
                                });
                              },

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
               SizedBox(height: 8,),
                if(!isOn)...[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Icon(
                //           Icons.currency_exchange,
                //           size: 22,
                //           color: Colors.black54,
                //         ),
                //         SizedBox(width: 8),
                //         Text(
                //           "Top Expenses",
                //           style: Styling.bodyTitleBigBoldExp,
                //           textScaler: TextScaler.noScaling,
                //         ),
                //       ],
                //     ),
                //     SizedBox(width: 10),
                //     SizedBox(
                //       width: 140,
                //       child:
                //       DropdownButton<String>(
                //         value: selectedRegulatorReceived ?? "This Month",
                //         items: (regulatorReceived ?? []).map((transMode) {
                //           return DropdownMenuItem<String>(
                //             value: transMode,
                //             child: Text(
                //               transMode,
                //               style: Styling.itemBlackTestOne,
                //               textScaler:
                //               TextScaler.noScaling,
                //             ),
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           setState(() {
                //             selectedRegulatorReceived = value;
                //             expenseReportModel = [];
                //             segmentPercentages.clear();
                //             segmentColors.clear();
                //           });
                //           if (selectedRegulatorReceived == "Today's") {
                //             getHeadWiseExpenseLstModel("TODAYS");
                //           } else if (selectedRegulatorReceived ==
                //               "This Month") {
                //             getHeadWiseExpenseLstModel("THISMONTH");
                //           } else if (selectedRegulatorReceived ==
                //               "Financial Year") {
                //             getHeadWiseExpenseLstModel("FINYEAR");
                //           }
                //         },
                //         isExpanded: true,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 8),
                Card(
                  color: Color(0xFFF8FBFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Expenses",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            //color: Color(0xFFFFC512),
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(
                              formatCurrency(totalExpense ?? 0.0),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: List.generate(
                          segmentPercentages.length, (index) {
                        return Expanded(
                          flex: segmentPercentages[index].round(),
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: segmentColors[index],
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomLeft: index == 0
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                topRight: index == segmentPercentages.length - 1
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: index ==
                                    segmentPercentages.length - 1 ? Radius
                                    .circular(10) : Radius.zero,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: expenseReportModel?.length ?? 0,
                  itemBuilder: (context, index) {
                    HeadWiseExpenseLstModel expense = expenseReportModel![index];
                    String parentExpHeadName = expense.parentExpHeadName ?? '';
                    double expenseAmount = expense.totExpAmt?.toDouble() ?? 0.0;

                    Color iconColor = expenseColors[index %
                        expenseColors.length];

                    double totalForCategory = groupedExpenses[parentExpHeadName] ??
                        0.0;

                    if (totalForCategory > 0) {
                      percentage = (expenseAmount / totalExpense) * 100;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.square_rounded,
                                color: iconColor,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  expense.parentExpHeadName ?? '',
                                  style: Styling
                                      .bodyTitleBigBoldDashBlack, // Your existing styling
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4), // Space between lines
                          Padding(
                            padding: EdgeInsets.only(left: 28.0),
                            // Adjust this value as needed
                            child: Row(
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Text(
                                  formatCurrency(
                                      expense.totExpAmt?.toDouble() ?? 0.0),
                                  style: Styling.bodyTitleBigBoldForPrice,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Row(
                              children: [
                                Text(
                                  '${percentage?.toStringAsFixed(2)}%',

                                  style: Styling
                                      .bodyTitleBigBoldDashGrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
                if (isOn) ...[
                 Container(
                   child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,  // Align items to the left
                          //   children: [
                          //     Icon(
                          //       Icons.auto_graph,
                          //       size: 22,
                          //       color: Colors.black54,
                          //     ),
                          //     SizedBox(width: 8),  // Add space between icon and text
                          //     Text(
                          //       "Revenue Vs Expense",
                          //       style: Styling.bodyTitleBigBoldExp,
                          //       textScaler: TextScaler.noScaling,
                          //     ),
                          //     Spacer(),  // Push the dropdown to the far right
                          //     SizedBox(
                          //       width: 140,  // Control the width of the dropdown
                          //       child: DropdownButton<String>(
                          //         value: selectedRegReceived ?? "This Year",
                          //         items: regReceived.map((transMode) {
                          //           return DropdownMenuItem<String>(
                          //             value: transMode,
                          //             child: Text(
                          //               transMode,
                          //               style: Styling.itemBlackTestOne,
                          //               textScaler: TextScaler.noScaling,
                          //             ),
                          //           );
                          //         }).toList(),
                          //         onChanged: (value) {
                          //           setState(() {
                          //             selectedRegReceived = value;
                          //             grossExpenseModel.clear();
                          //             grossProfitModel.clear();
                          //           });
                          //           if (selectedRegReceived == "This Year") {
                          //             getDashboardData("FINYEAR");
                          //           } else if (selectedRegReceived == "Prev Year") {
                          //             getDashboardData("PREFINYEAR");
                          //           }
                          //         },
                          //         isExpanded: true,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //  SizedBox(height: 20,),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    'Revenue & Expense Count',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    width: chartWidth,
                                    child: SfCartesianChart(
                                      tooltipBehavior: _tooltipBehavior,  // Add tooltip behavior here
                                      primaryXAxis: CategoryAxis(
                                        labelRotation: 45,
                                        interval: 1,
                                        majorGridLines: MajorGridLines(width: 0),
                                      ),
                                      primaryYAxis: NumericAxis(
                                        axisLine: AxisLine(width: 1),
                                        majorTickLines: MajorTickLines(size: 0),
                                        axisLabelFormatter: (AxisLabelRenderDetails details) {
                                          return ChartAxisLabel('', TextStyle(fontSize: 0));
                                        },
                                      ),
                                      series: <CartesianSeries<dynamic, dynamic>>[
                                        ColumnSeries<MonthProfitData, String>(
                                          name: 'Expense',
                                          dataSource: expenseDataForChart,
                                          xValueMapper: (MonthProfitData data, _) => data.month,
                                          yValueMapper: (MonthProfitData data, _) => data.profit,
                                          color: Colors.blue,
                                          width: 0.5,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: false,  // Hide data label on the bars
                                          ),
                                        ),

                                        ColumnSeries<MonthProfitData, String>(
                                          name: 'Profit',
                                          dataSource: profitDataForChart,
                                          xValueMapper: (MonthProfitData data, _) => data.month,
                                          yValueMapper: (MonthProfitData data, _) => data.profit,
                                          color: Colors.orange,
                                          width: 0.5,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: false,  // Hide data label on the bars
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Expense', style: TextStyle(fontSize: 14)),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text('Revenue', style: TextStyle(fontSize: 14)),
                                        SizedBox(width: 8),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                 ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getHeadWiseExpenseLstModel(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetHeadWiseExpense}/$distributorId/$flag'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    debugPrint("GetHeadWiseExpense : ${AppUrl.GetHeadWiseExpense}/$distributorId/$flag");
    debugPrint("GetHeadWiseExpense : ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Parse response into model
      List<HeadWiseExpenseLstModel> parsedData = data.map((json) {
        return HeadWiseExpenseLstModel.fromJson(json);
      }).toList();

      // Calculate total expense
      double calculatedTotal = parsedData.fold(0.0, (sum, item) {
        return sum + (item.totExpAmt ?? 0.0);
      });

      // Sort parsedData by totExpAmt descending
      parsedData.sort((a, b) {
        double amtA = a.totExpAmt?.toDouble() ?? 0.0;
        double amtB = b.totExpAmt?.toDouble() ?? 0.0;
        return amtB.compareTo(amtA);  // descending order
      });

      // Prepare segment data
      List<double> newSegmentPercentages = [];
      List<Color> newSegmentColors = [];

      for (int i = 0; i < parsedData.length; i++) {
        double amount = parsedData[i].totExpAmt?.toDouble() ?? 0.0;
        double percentage = calculatedTotal > 0 ? (amount / calculatedTotal) * 100 : 0.0;

        newSegmentPercentages.add(percentage);
        newSegmentColors.add(expenseColors[i % expenseColors.length]);
      }

      setState(() {
        expenseReportModel = parsedData;
        totalExpense = calculatedTotal;
        segmentPercentages = newSegmentPercentages;
        segmentColors = newSegmentColors;


        if (flag == "FINYEAR") {
          expAmtPerYear = calculatedTotal;
          debugPrint("This Financial Year's Expense: $expAmtPerYear");
        } else if (flag == "THISMONTH") {
          expAmtPerMonth = calculatedTotal;
          debugPrint("This Month's Expense: $expAmtPerMonth");
        } else if (flag == "TODAYS") {
          expAmtPerYear = calculatedTotal;
          debugPrint("Today's Expense: $expAmtPerYear");
        }
        EasyLoading.dismiss();
      });
    }
    else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // Future<void> getDashboardFYGrossExpenseDtls_Mob(String flag) async {
  //   EasyLoading.show();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? itemSubType = prefs.getString('ItemSubType');
  //   String? bearerToken = prefs.getString('token');
  //
  //   if (bearerToken == null) {
  //     throw Exception('Bearer token is missing');
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "DistributorId": distributorId,
  //     "ItemSubType": itemSubType,
  //     "Flag": flag,
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse('${AppUrl.GetDashboardFYGrossExpenseDtls_Mob}/$distributorId/$flag'),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //
  //     setState(() {
  //       grossExpenseModel = data.map((json) {
  //         return GetDashboardFyGrossExpenseDtlsModel.fromJson(json);
  //       }).toList();
  //
  //       EasyLoading.dismiss();
  //     });
  //   } else {
  //     EasyLoading.dismiss();
  //     throw Exception('Failed to load items');
  //   }
  // }
  //
  // Future<void> getDashboardFYGrossProfitDtls_Mob(String flag) async {
  //   EasyLoading.show();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? itemSubType = prefs.getString('ItemSubType');
  //   String? bearerToken = prefs.getString('token');
  //
  //   if (bearerToken == null) {
  //     throw Exception('Bearer token is missing');
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "DistributorId": distributorId,
  //     "ItemSubType": itemSubType,
  //     "Flag": flag,
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse('${AppUrl.GetDashboardFYGrossProfitDtls_Mob}/$distributorId/$flag'),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //
  //     setState(() {
  //       grossProfitModel = data.map((json) {
  //         return GetDashboardFyGrossProfitDtlsModel.fromJson(json);
  //       }).toList();
  //
  //       EasyLoading.dismiss();
  //     });
  //   } else {
  //     EasyLoading.dismiss();
  //     throw Exception('Failed to load items');
  //   }
  // }

  Future<void> getDashboardData(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? itemSubType = prefs.getString('ItemSubType');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      EasyLoading.dismiss();
      throw Exception('Bearer token is missing');
    }

    // API request parameters
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "ItemSubType": itemSubType,
      "Flag": flag,
    };

    try {
      // Perform both API requests concurrently
      var responses = await Future.wait([
        http.get(
          Uri.parse('${AppUrl.GetDashboardFYGrossExpenseDtls_Mob}/$distributorId/$flag'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        ),
        http.get(
          Uri.parse('${AppUrl.GetDashboardFYGrossProfitDtls_Mob}/$distributorId/$flag'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        ),
      ]);

      // Handling the responses for expense and profit
      final expenseResponse = responses[0];
      final profitResponse = responses[1];

      if (expenseResponse.statusCode == 200 && profitResponse.statusCode == 200) {
        // Parse the JSON responses as dynamic lists
        final List<dynamic> expenseData = json.decode(expenseResponse.body);
        final List<dynamic> profitData = json.decode(profitResponse.body);

        setState(() {
          // Map expense data to the model (assuming GetDashboardFyGrossExpenseDtlsModel is correct)
          grossExpenseModel = expenseData.map((json) {
            return GetDashboardFyGrossExpenseDtlsModel.fromJson(json);
          }).toList();

          // Map the profit data to GetDashboardFyGrossProfitDtlsModel (assuming this is correct)
          grossProfitModel = profitData.map((json) {
            return GetDashboardFyGrossProfitDtlsModel.fromJson(json);
          }).toList();

          // Convert grossProfitModel and grossExpenseModel to List<MonthProfitData>
          profitDataForChart = grossProfitModel.expand((model) => MonthProfitData.fromGrossProfitModel(model)).toList();
          expenseDataForChart = grossExpenseModel.expand((model) => MonthProfitData.fromGrossExpenseModel(model)).toList();

          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load expense or profit data');
      }
    } catch (error) {
      EasyLoading.dismiss();
      throw Exception('Error fetching data: $error');
    }
  }


  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator

    // Ensure the result always shows a leading zero before the decimal point
    String formattedAmount = format.format(amount);

    // If there's no integer part, it ensures that a leading zero is added before decimal
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

}
class MonthProfitData {
  final String month;
  final num? profit;

  MonthProfitData(this.month, this.profit);

  // Method to convert GetDashboardFyGrossProfitDtlsModel to a list of MonthProfitData
  static List<MonthProfitData> fromGrossProfitModel(GetDashboardFyGrossProfitDtlsModel model) {
    return [
      MonthProfitData("April", model.april),
      MonthProfitData("May", model.may),
      MonthProfitData("June", model.june),
      MonthProfitData("July", model.july),
      MonthProfitData("August", model.august),
      MonthProfitData("September", model.september),
      MonthProfitData("October", model.october),
      MonthProfitData("November", model.november),
      MonthProfitData("December", model.december),
      MonthProfitData("January", model.january),
      MonthProfitData("February", model.february),
      MonthProfitData("March", model.march),
    ];
  }

  // Method to convert GetDashboardFyGrossExpenseDtlsModel to a list of MonthProfitData
  static List<MonthProfitData> fromGrossExpenseModel(GetDashboardFyGrossExpenseDtlsModel model) {
    return [
      MonthProfitData("April", model.april),
      MonthProfitData("May", model.may),
      MonthProfitData("June", model.june),
      MonthProfitData("July", model.july),
      MonthProfitData("August", model.august),
      MonthProfitData("September", model.september),
      MonthProfitData("October", model.october),
      MonthProfitData("November", model.november),
      MonthProfitData("December", model.december),
      MonthProfitData("January", model.january),
      MonthProfitData("February", model.february),
      MonthProfitData("March", model.march),
    ];
  }
}
