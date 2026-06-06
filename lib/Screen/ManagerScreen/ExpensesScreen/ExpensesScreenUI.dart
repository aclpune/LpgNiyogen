// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../ClickModelClass/GetDashboardFYGrossProfitDtlsModel.dart';
// import 'GetDashboardFYGrossExpenseDtlsModel.dart';
// import 'HeadWiseExpenseLstModel.dart';
//
// class ExpensesScreenUI extends StatefulWidget{
//   static const screenName = '/expensesScreenUI';
//
//   @override
//   State<ExpensesScreenUI> createState() => _ExpensesScreenUIState();
//
// }
//
// class _ExpensesScreenUIState extends  State<ExpensesScreenUI>{
//   bool isLoading = true;
//   List<String> regulatorReceived = ["Today's", "This Month","Financial Year"];
//   String? selectedRegulatorReceived;
//   final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
//   List<String> regReceived = ["Prev Year", "This Year"];
//   String? selectedRegReceived;
//   double value = 50;
//   List<HeadWiseExpenseLstModel> expenseReportModel = [];
//   double? expAmtPerYear;
//   double? expAmtTodays;
//   double? expAmtPerMonth;
//   double totalExpense = 0.0;
//   double? percentage;
//   final List<Color> expenseColors = [
//     const Color(0xFF248BFA),
//     const Color(0xFF67d1fb),
//     const Color(0xFFfed06a),
//     const Color(0xFF6e69e2),
//     const Color(0xFF873e23),
//   ];
//   List<double> segmentPercentages = [];
//   List<Color> segmentColors = [];
//   bool isOn = false;
//   List<GetDashboardFyGrossExpenseDtlsModel> grossExpenseModel = [];
//   List<GetDashboardFyGrossProfitDtlsModel> grossProfitModel = [];
//   GetDashboardFyGrossExpenseDtlsModel? selectedExpenseModel;
//   List<MonthProfitData> profitDataForChart = [];
//   List<MonthProfitData> expenseDataForChart = [];
//   TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
//   // late TooltipBehavior _tooltipBehavior;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     getHeadWiseExpenseLstModel("THISMONTH");
//     getDashboardData("FINYEAR");
//     _tooltipBehavior = TooltipBehavior(
//       enable: true,
//       format: 'point.x : point.y',
//       header: '',
//       canShowMarker: true,
//       // 👇 Add number format
//       textStyle: TextStyle(
//         fontSize: 12,
//         color: Colors.white,
//       ),
//       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//         final value = (data as MonthProfitData).profit;
//         return Container(
//           padding: EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             color: Colors.black87,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Text(
//             '${data.month}: ₹${value?.toStringAsFixed(2)}', // ✅ Format to 2 decimal points
//             style: TextStyle(color: Colors.white),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute
//         .of(context)
//         ?.settings
//         .arguments;
//
//
//     Map<String, double> groupedExpenses = {};
//     for (var item in expenseReportModel!) {
//       String groupName = item.parentExpHeadName ?? '';
//       double groupExpense = item.totExpAmt?.toDouble() ?? 0.0;
//
//       if (groupedExpenses.containsKey(groupName)) {
//         groupedExpenses[groupName] = groupedExpenses[groupName]! + groupExpense;
//       } else {
//         groupedExpenses[groupName] = groupExpense;
//       }
//     }
//
//     final double barWidth = 50;
//     final double barSpacing = 8;
//     final int itemCount = 22;
//     final double chartWidth = (barWidth + barSpacing) * itemCount;
//
//
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//           return false;
//         }
//       },
//
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           surfaceTintColor: Color(0xFFECEFFF),
//           backgroundColor: Color(0xFFECEFFF),
//           flexibleSpace: SafeArea(
//             child:
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(
//                                 Icons.arrow_back, color: Colors.black),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           Text(
//                             isOn?"Revenue Vs Expense":"Top Expenses",
//                             style: TextStyle(fontSize: 18, color: Colors.black),
//                           ),
//                         // SizedBox(width: 170,),
//                         //   Row(
//                         //     mainAxisAlignment: MainAxisAlignment.end,
//                         //     children: [
//                         //       Transform.scale(
//                         //         scale: 0.9, // Adjust the scale value as needed
//                         //         child: Column(
//                         //           children: [
//                         //             Switch(
//                         //               value: isOn,
//                         //               onChanged: (bool value) {
//                         //                 setState(() {
//                         //                   isOn = value;
//                         //                 });
//                         //               },
//                         //             ),
//                         //           ],
//                         //         ),
//                         //       ),
//                         //     ],
//                         //   ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//           child: SingleChildScrollView(
//             child:
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 6.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       isOn?
//                       SizedBox(
//                         width: 140,  // Control the width of the dropdown
//                         child: DropdownButton<String>(
//                           value: selectedRegReceived ?? "This Year",
//                           items: regReceived.map((transMode) {
//                             return DropdownMenuItem<String>(
//                               value: transMode,
//                               child: Text(
//                                 transMode,
//                                 style: Styling.itemBlackTestOne,
//                                 textScaler: TextScaler.noScaling,
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedRegReceived = value;
//                               grossExpenseModel.clear();
//                               grossProfitModel.clear();
//                             });
//                             if (selectedRegReceived == "This Year") {
//                               getDashboardData("FINYEAR");
//                             } else if (selectedRegReceived == "Prev Year") {
//                               getDashboardData("PREFINYEAR");
//                             }
//                           },
//                           isExpanded: true,
//                         ),
//                       ):
//                       SizedBox(
//                         width: 140,
//                         child:
//                         DropdownButton<String>(
//                           value: selectedRegulatorReceived ?? "This Month",
//                           items: (regulatorReceived ?? []).map((transMode) {
//                             return DropdownMenuItem<String>(
//                               value: transMode,
//                               child: Text(
//                                 transMode,
//                                 style: Styling.itemBlackTestOne,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedRegulatorReceived = value;
//                               expenseReportModel = [];
//                               segmentPercentages.clear();
//                               segmentColors.clear();
//                             });
//                             if (selectedRegulatorReceived == "Today's") {
//                               getHeadWiseExpenseLstModel("TODAYS");
//                             } else if (selectedRegulatorReceived ==
//                                 "This Month") {
//                               getHeadWiseExpenseLstModel("THISMONTH");
//                             } else if (selectedRegulatorReceived ==
//                                 "Financial Year") {
//                               getHeadWiseExpenseLstModel("FINYEAR");
//                             }
//                           },
//                           isExpanded: true,
//                         ),
//                       ),
//                       Transform.scale(
//                         scale: 0.7, // Adjust the scale value as needed
//                         child: Column(
//                           children: [
//                             Switch(
//                               value: isOn,
//                               onChanged: (bool value) {
//                                 setState(() {
//                                   isOn = value;
//                                 });
//                               },
//
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                SizedBox(height: 8,),
//                 if(!isOn)...[
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Row(
//                 //       children: [
//                 //         Icon(
//                 //           Icons.currency_exchange,
//                 //           size: 22,
//                 //           color: Colors.black54,
//                 //         ),
//                 //         SizedBox(width: 8),
//                 //         Text(
//                 //           "Top Expenses",
//                 //           style: Styling.bodyTitleBigBoldExp,
//                 //           textScaler: TextScaler.noScaling,
//                 //         ),
//                 //       ],
//                 //     ),
//                 //     SizedBox(width: 10),
//                 //     SizedBox(
//                 //       width: 140,
//                 //       child:
//                 //       DropdownButton<String>(
//                 //         value: selectedRegulatorReceived ?? "This Month",
//                 //         items: (regulatorReceived ?? []).map((transMode) {
//                 //           return DropdownMenuItem<String>(
//                 //             value: transMode,
//                 //             child: Text(
//                 //               transMode,
//                 //               style: Styling.itemBlackTestOne,
//                 //               textScaler:
//                 //               TextScaler.noScaling,
//                 //             ),
//                 //           );
//                 //         }).toList(),
//                 //         onChanged: (value) {
//                 //           setState(() {
//                 //             selectedRegulatorReceived = value;
//                 //             expenseReportModel = [];
//                 //             segmentPercentages.clear();
//                 //             segmentColors.clear();
//                 //           });
//                 //           if (selectedRegulatorReceived == "Today's") {
//                 //             getHeadWiseExpenseLstModel("TODAYS");
//                 //           } else if (selectedRegulatorReceived ==
//                 //               "This Month") {
//                 //             getHeadWiseExpenseLstModel("THISMONTH");
//                 //           } else if (selectedRegulatorReceived ==
//                 //               "Financial Year") {
//                 //             getHeadWiseExpenseLstModel("FINYEAR");
//                 //           }
//                 //         },
//                 //         isExpanded: true,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // SizedBox(height: 8),
//                 Card(
//                   color: Color(0xFFF8FBFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Total Expenses",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             //color: Color(0xFFFFC512),
//                             color: Colors.blue,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.currency_rupee,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                             Text(
//                               formatCurrency(totalExpense ?? 0.0),
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       children: List.generate(
//                           segmentPercentages.length, (index) {
//                         return Expanded(
//                           flex: segmentPercentages[index].round(),
//                           child: Container(
//                             height: 10,
//                             decoration: BoxDecoration(
//                               color: segmentColors[index],
//                               borderRadius: BorderRadius.only(
//                                 topLeft: index == 0
//                                     ? Radius.circular(10)
//                                     : Radius.zero,
//                                 bottomLeft: index == 0
//                                     ? Radius.circular(10)
//                                     : Radius.zero,
//                                 topRight: index == segmentPercentages.length - 1
//                                     ? Radius.circular(10)
//                                     : Radius.zero,
//                                 bottomRight: index ==
//                                     segmentPercentages.length - 1 ? Radius
//                                     .circular(10) : Radius.zero,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: expenseReportModel?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     HeadWiseExpenseLstModel expense = expenseReportModel![index];
//                     String parentExpHeadName = expense.parentExpHeadName ?? '';
//                     double expenseAmount = expense.totExpAmt?.toDouble() ?? 0.0;
//
//                     Color iconColor = expenseColors[index %
//                         expenseColors.length];
//
//                     double totalForCategory = groupedExpenses[parentExpHeadName] ??
//                         0.0;
//
//                     if (totalForCategory > 0) {
//                       percentage = (expenseAmount / totalExpense) * 100;
//                     }
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.square_rounded,
//                                 color: iconColor,
//                                 size: 22,
//                               ),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   expense.parentExpHeadName ?? '',
//                                   style: Styling
//                                       .bodyTitleBigBoldDashBlack, // Your existing styling
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4), // Space between lines
//                           Padding(
//                             padding: EdgeInsets.only(left: 28.0),
//                             // Adjust this value as needed
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.currency_rupee,
//                                   color: Colors.black,
//                                   size: 16,
//                                 ),
//                                 Text(
//                                   formatCurrency(
//                                       expense.totExpAmt?.toDouble() ?? 0.0),
//                                   style: Styling.bodyTitleBigBoldForPrice,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 30.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   '${percentage?.toStringAsFixed(2)}%',
//
//                                   style: Styling
//                                       .bodyTitleBigBoldDashGrey,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//                 if (isOn) ...[
//                  Container(
//                    child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.start,  // Align items to the left
//                           //   children: [
//                           //     Icon(
//                           //       Icons.auto_graph,
//                           //       size: 22,
//                           //       color: Colors.black54,
//                           //     ),
//                           //     SizedBox(width: 8),  // Add space between icon and text
//                           //     Text(
//                           //       "Revenue Vs Expense",
//                           //       style: Styling.bodyTitleBigBoldExp,
//                           //       textScaler: TextScaler.noScaling,
//                           //     ),
//                           //     Spacer(),  // Push the dropdown to the far right
//                           //     SizedBox(
//                           //       width: 140,  // Control the width of the dropdown
//                           //       child: DropdownButton<String>(
//                           //         value: selectedRegReceived ?? "This Year",
//                           //         items: regReceived.map((transMode) {
//                           //           return DropdownMenuItem<String>(
//                           //             value: transMode,
//                           //             child: Text(
//                           //               transMode,
//                           //               style: Styling.itemBlackTestOne,
//                           //               textScaler: TextScaler.noScaling,
//                           //             ),
//                           //           );
//                           //         }).toList(),
//                           //         onChanged: (value) {
//                           //           setState(() {
//                           //             selectedRegReceived = value;
//                           //             grossExpenseModel.clear();
//                           //             grossProfitModel.clear();
//                           //           });
//                           //           if (selectedRegReceived == "This Year") {
//                           //             getDashboardData("FINYEAR");
//                           //           } else if (selectedRegReceived == "Prev Year") {
//                           //             getDashboardData("PREFINYEAR");
//                           //           }
//                           //         },
//                           //         isExpanded: true,
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           //  SizedBox(height: 20,),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                                 child: RotatedBox(
//                                   quarterTurns: 3,
//                                   child: Text(
//                                     'Revenue & Expense Count',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20,),
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Container(
//                                     width: chartWidth,
//                                     child: SfCartesianChart(
//                                       tooltipBehavior: _tooltipBehavior,  // Add tooltip behavior here
//                                       primaryXAxis: CategoryAxis(
//                                         labelRotation: 45,
//                                         interval: 1,
//                                         majorGridLines: MajorGridLines(width: 0),
//                                       ),
//                                       primaryYAxis: NumericAxis(
//                                         axisLine: AxisLine(width: 1),
//                                         majorTickLines: MajorTickLines(size: 0),
//                                         axisLabelFormatter: (AxisLabelRenderDetails details) {
//                                           return ChartAxisLabel('', TextStyle(fontSize: 0));
//                                         },
//                                       ),
//                                       series: <CartesianSeries<dynamic, dynamic>>[
//                                         ColumnSeries<MonthProfitData, String>(
//                                           name: 'Expense',
//                                           dataSource: expenseDataForChart,
//                                           xValueMapper: (MonthProfitData data, _) => data.month,
//                                           yValueMapper: (MonthProfitData data, _) => data.profit,
//                                           color: Colors.blue,
//                                           width: 0.5,
//                                           dataLabelSettings: DataLabelSettings(
//                                             isVisible: false,  // Hide data label on the bars
//                                           ),
//                                         ),
//
//                                         ColumnSeries<MonthProfitData, String>(
//                                           name: 'Profit',
//                                           dataSource: profitDataForChart,
//                                           xValueMapper: (MonthProfitData data, _) => data.month,
//                                           yValueMapper: (MonthProfitData data, _) => data.profit,
//                                           color: Colors.orange,
//                                           width: 0.5,
//                                           dataLabelSettings: DataLabelSettings(
//                                             isVisible: false,  // Hide data label on the bars
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text('Expense', style: TextStyle(fontSize: 14)),
//                                         SizedBox(width: 8),
//                                         Container(
//                                           width: 12,
//                                           height: 12,
//                                           color: Colors.blue,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Text('Revenue', style: TextStyle(fontSize: 14)),
//                                         SizedBox(width: 8),
//                                         Container(
//                                           width: 12,
//                                           height: 12,
//                                           color: Colors.orange,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                  ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> getHeadWiseExpenseLstModel(String flag) async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetHeadWiseExpense}/$distributorId/$flag'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//       },
//     );
//
//     debugPrint("GetHeadWiseExpense : ${AppUrl.GetHeadWiseExpense}/$distributorId/$flag");
//     debugPrint("GetHeadWiseExpense : ${response.body}");
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       // Parse response into model
//       List<HeadWiseExpenseLstModel> parsedData = data.map((json) {
//         return HeadWiseExpenseLstModel.fromJson(json);
//       }).toList();
//
//       // Calculate total expense
//       double calculatedTotal = parsedData.fold(0.0, (sum, item) {
//         return sum + (item.totExpAmt ?? 0.0);
//       });
//
//       // Sort parsedData by totExpAmt descending
//       parsedData.sort((a, b) {
//         double amtA = a.totExpAmt?.toDouble() ?? 0.0;
//         double amtB = b.totExpAmt?.toDouble() ?? 0.0;
//         return amtB.compareTo(amtA);  // descending order
//       });
//
//       // Prepare segment data
//       List<double> newSegmentPercentages = [];
//       List<Color> newSegmentColors = [];
//
//       for (int i = 0; i < parsedData.length; i++) {
//         double amount = parsedData[i].totExpAmt?.toDouble() ?? 0.0;
//         double percentage = calculatedTotal > 0 ? (amount / calculatedTotal) * 100 : 0.0;
//
//         newSegmentPercentages.add(percentage);
//         newSegmentColors.add(expenseColors[i % expenseColors.length]);
//       }
//
//       setState(() {
//         expenseReportModel = parsedData;
//         totalExpense = calculatedTotal;
//         segmentPercentages = newSegmentPercentages;
//         segmentColors = newSegmentColors;
//
//
//         if (flag == "FINYEAR") {
//           expAmtPerYear = calculatedTotal;
//           debugPrint("This Financial Year's Expense: $expAmtPerYear");
//         } else if (flag == "THISMONTH") {
//           expAmtPerMonth = calculatedTotal;
//           debugPrint("This Month's Expense: $expAmtPerMonth");
//         } else if (flag == "TODAYS") {
//           expAmtPerYear = calculatedTotal;
//           debugPrint("Today's Expense: $expAmtPerYear");
//         }
//         EasyLoading.dismiss();
//       });
//     }
//     else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   // Future<void> getDashboardFYGrossExpenseDtls_Mob(String flag) async {
//   //   EasyLoading.show();
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? itemSubType = prefs.getString('ItemSubType');
//   //   String? bearerToken = prefs.getString('token');
//   //
//   //   if (bearerToken == null) {
//   //     throw Exception('Bearer token is missing');
//   //   }
//   //
//   //   Map<String, dynamic> requestBody = {
//   //     "DistributorId": distributorId,
//   //     "ItemSubType": itemSubType,
//   //     "Flag": flag,
//   //   };
//   //
//   //   final response = await http.get(
//   //     Uri.parse('${AppUrl.GetDashboardFYGrossExpenseDtls_Mob}/$distributorId/$flag'),
//   //     headers: {
//   //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//   //     },
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final List<dynamic> data = json.decode(response.body);
//   //
//   //     setState(() {
//   //       grossExpenseModel = data.map((json) {
//   //         return GetDashboardFyGrossExpenseDtlsModel.fromJson(json);
//   //       }).toList();
//   //
//   //       EasyLoading.dismiss();
//   //     });
//   //   } else {
//   //     EasyLoading.dismiss();
//   //     throw Exception('Failed to load items');
//   //   }
//   // }
//   //
//   // Future<void> getDashboardFYGrossProfitDtls_Mob(String flag) async {
//   //   EasyLoading.show();
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? itemSubType = prefs.getString('ItemSubType');
//   //   String? bearerToken = prefs.getString('token');
//   //
//   //   if (bearerToken == null) {
//   //     throw Exception('Bearer token is missing');
//   //   }
//   //
//   //   Map<String, dynamic> requestBody = {
//   //     "DistributorId": distributorId,
//   //     "ItemSubType": itemSubType,
//   //     "Flag": flag,
//   //   };
//   //
//   //   final response = await http.get(
//   //     Uri.parse('${AppUrl.GetDashboardFYGrossProfitDtls_Mob}/$distributorId/$flag'),
//   //     headers: {
//   //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//   //     },
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final List<dynamic> data = json.decode(response.body);
//   //
//   //     setState(() {
//   //       grossProfitModel = data.map((json) {
//   //         return GetDashboardFyGrossProfitDtlsModel.fromJson(json);
//   //       }).toList();
//   //
//   //       EasyLoading.dismiss();
//   //     });
//   //   } else {
//   //     EasyLoading.dismiss();
//   //     throw Exception('Failed to load items');
//   //   }
//   // }
//
//   Future<void> getDashboardData(String flag) async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? itemSubType = prefs.getString('ItemSubType');
//     String? bearerToken = prefs.getString('token');
//
//     if (bearerToken == null) {
//       EasyLoading.dismiss();
//       throw Exception('Bearer token is missing');
//     }
//
//     // API request parameters
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//       "ItemSubType": itemSubType,
//       "Flag": flag,
//     };
//
//     try {
//       // Perform both API requests concurrently
//       var responses = await Future.wait([
//         http.get(
//           Uri.parse('${AppUrl.GetDashboardFYGrossExpenseDtls_Mob}/$distributorId/$flag'),
//           headers: {'Authorization': 'Bearer $bearerToken'},
//         ),
//         http.get(
//           Uri.parse('${AppUrl.GetDashboardFYGrossProfitDtls_Mob}/$distributorId/$flag'),
//           headers: {'Authorization': 'Bearer $bearerToken'},
//         ),
//       ]);
//
//       // Handling the responses for expense and profit
//       final expenseResponse = responses[0];
//       final profitResponse = responses[1];
//
//       if (expenseResponse.statusCode == 200 && profitResponse.statusCode == 200) {
//         // Parse the JSON responses as dynamic lists
//         final List<dynamic> expenseData = json.decode(expenseResponse.body);
//         final List<dynamic> profitData = json.decode(profitResponse.body);
//
//         setState(() {
//           // Map expense data to the model (assuming GetDashboardFyGrossExpenseDtlsModel is correct)
//           grossExpenseModel = expenseData.map((json) {
//             return GetDashboardFyGrossExpenseDtlsModel.fromJson(json);
//           }).toList();
//
//           // Map the profit data to GetDashboardFyGrossProfitDtlsModel (assuming this is correct)
//           grossProfitModel = profitData.map((json) {
//             return GetDashboardFyGrossProfitDtlsModel.fromJson(json);
//           }).toList();
//
//           // Convert grossProfitModel and grossExpenseModel to List<MonthProfitData>
//           profitDataForChart = grossProfitModel.expand((model) => MonthProfitData.fromGrossProfitModel(model)).toList();
//           expenseDataForChart = grossExpenseModel.expand((model) => MonthProfitData.fromGrossExpenseModel(model)).toList();
//
//           EasyLoading.dismiss();
//         });
//       } else {
//         EasyLoading.dismiss();
//         throw Exception('Failed to load expense or profit data');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       throw Exception('Error fetching data: $error');
//     }
//   }
//
//
//   String formatCurrency(double amount) {
//     if (amount == 0) {
//       return '0.00'; // Return "0.00" if the amount is zero
//     }
//     final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator
//
//     // Ensure the result always shows a leading zero before the decimal point
//     String formattedAmount = format.format(amount);
//
//     // If there's no integer part, it ensures that a leading zero is added before decimal
//     if (amount < 1 && formattedAmount.startsWith('.')) {
//       formattedAmount = '0' + formattedAmount;
//     }
//     return formattedAmount;
//   }
//
// }
// class MonthProfitData {
//   final String month;
//   final num? profit;
//
//   MonthProfitData(this.month, this.profit);
//
//   // Method to convert GetDashboardFyGrossProfitDtlsModel to a list of MonthProfitData
//   static List<MonthProfitData> fromGrossProfitModel(GetDashboardFyGrossProfitDtlsModel model) {
//     return [
//       MonthProfitData("April", model.april),
//       MonthProfitData("May", model.may),
//       MonthProfitData("June", model.june),
//       MonthProfitData("July", model.july),
//       MonthProfitData("August", model.august),
//       MonthProfitData("September", model.september),
//       MonthProfitData("October", model.october),
//       MonthProfitData("November", model.november),
//       MonthProfitData("December", model.december),
//       MonthProfitData("January", model.january),
//       MonthProfitData("February", model.february),
//       MonthProfitData("March", model.march),
//     ];
//   }
//
//   // Method to convert GetDashboardFyGrossExpenseDtlsModel to a list of MonthProfitData
//   static List<MonthProfitData> fromGrossExpenseModel(GetDashboardFyGrossExpenseDtlsModel model) {
//     return [
//       MonthProfitData("April", model.april),
//       MonthProfitData("May", model.may),
//       MonthProfitData("June", model.june),
//       MonthProfitData("July", model.july),
//       MonthProfitData("August", model.august),
//       MonthProfitData("September", model.september),
//       MonthProfitData("October", model.october),
//       MonthProfitData("November", model.november),
//       MonthProfitData("December", model.december),
//       MonthProfitData("January", model.january),
//       MonthProfitData("February", model.february),
//       MonthProfitData("March", model.march),
//     ];
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/BoxShadow/section_header.dart';
import '../../Utils/Styling.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/GetDashboardFYGrossProfitDtlsModel.dart';
import 'GetDashboardFYGrossExpenseDtlsModel.dart';
import 'HeadWiseExpenseLstModel.dart';


// =============================================================================
// ExpensesScreenUI
// Refactored to match the dashboard design system:
//   • Hero gradient AppBar with total KPI badge
//   • Themed segmented period filter (pill tabs)
//   • Stacked segmented progress bar with legend
//   • Dashboard-style expense item cards (left-border accent)
//   • Revenue vs Expense chart section with themed shell
//   • Reuses AppColors, AppTypography, AppSpacing, SectionHeader
// =============================================================================

class ExpensesScreenUI extends StatefulWidget {
  static const screenName = '/expensesScreenUI';

  @override
  State<ExpensesScreenUI> createState() => _ExpensesScreenUIState();
}

class _ExpensesScreenUIState extends State<ExpensesScreenUI> {
  // ── State ──────────────────────────────────────────────────────────────────
  bool isLoading = true;

  // Period filter – Top Expenses view
  final List<String> regulatorReceived = ["Today's", "This Month", "Financial Year"];
  String? selectedRegulatorReceived;

  // Period filter – Revenue vs Expense view
  final List<String> regReceived = ["Prev Year", "This Year"];
  String? selectedRegReceived;

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  List<HeadWiseExpenseLstModel> expenseReportModel = [];
  double? expAmtPerYear;
  double? expAmtTodays;
  double? expAmtPerMonth;
  double totalExpense = 0.0;
  double? percentage;

  // Dashboard-aligned palette for expense segments
  final List<Color> expenseColors = [
    AppColors.primary,       // deep blue
    AppColors.teal,          // teal
    AppColors.orange,        // amber
    AppColors.red,           // red
    const Color(0xFF6e69e2), // violet (kept from original)
  ];

  List<double> segmentPercentages = [];
  List<Color> segmentColors = [];

  bool isOn = false; // toggle: Top Expenses vs Revenue vs Expense

  List<GetDashboardFyGrossExpenseDtlsModel> grossExpenseModel = [];
  List<GetDashboardFyGrossProfitDtlsModel> grossProfitModel = [];
  List<MonthProfitData> profitDataForChart = [];
  List<MonthProfitData> expenseDataForChart = [];
  late TooltipBehavior _tooltipBehavior;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    getHeadWiseExpenseLstModel("TODAYS");
    getDashboardData("FINYEAR");
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
      header: '',
      canShowMarker: true,
      textStyle: const TextStyle(fontSize: 12, color: Colors.white),
      builder: (dynamic data, dynamic point, dynamic series,
          int pointIndex, int seriesIndex) {
        final value = (data as MonthProfitData).profit;
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${data.month}: ₹${value?.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    // Group expenses by parent head (same logic as original)
    Map<String, double> groupedExpenses = {};
    for (var item in expenseReportModel) {
      final groupName = item.parentExpHeadName ?? '';
      final groupExpense = item.totExpAmt?.toDouble() ?? 0.0;
      groupedExpenses[groupName] =
          (groupedExpenses[groupName] ?? 0.0) + groupExpense;
    }

    // Chart width constants (unchanged)
    const double barWidth = 50;
    const double barSpacing = 8;
    const int itemCount = 22;
    const double chartWidth = (barWidth + barSpacing) * itemCount;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── View-mode toggle + period filter ──────────────────
              _buildFilterBar(),
              const SizedBox(height: 16),

              // ── Top Expenses view ─────────────────────────────────
              if (!isOn) ...[
                _buildTotalKpiCard(),
                const SizedBox(height: 16),
                SectionHeader(
                  title: 'Expense Breakdown',
                  dotColor: AppColors.orange,
                ),
                _buildSegmentedBar(),
                const SizedBox(height: 8),
                _buildExpenseList(groupedExpenses),
              ],

              // ── Revenue vs Expense chart view ─────────────────────
              if (isOn) ...[
                SectionHeader(
                  title: 'Revenue vs Expense',
                  dotColor: AppColors.primary,
                ),
                _buildChartCard(chartWidth),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradPrimary,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOn
                            ? 'Revenue vs Exp.'
                            : 'Top Expenses',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        isOn
                            ? selectedRegReceived ?? 'This Year'
                            : selectedRegulatorReceived ?? 'This Month',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                _TogglePill(
                  isOn: isOn,
                  onChanged: (v) => setState(() => isOn = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter bar (period selector) ───────────────────────────────────────────
  Widget _buildFilterBar() {
    if (isOn) {
      // Revenue vs Expense: year toggle
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _PillSelector(
          options: regReceived,
          selected: selectedRegReceived ?? 'This Year',
          onSelected: (value) {
            setState(() {
              selectedRegReceived = value;
              grossExpenseModel.clear();
              grossProfitModel.clear();
            });
            if (value == 'This Year') {
              getDashboardData("FINYEAR");
            } else {
              getDashboardData("PREFINYEAR");
            }
          },
        ),
      );
    }

    // Top Expenses: period tabs
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _PillSelector(
        options: regulatorReceived,
        selected: selectedRegulatorReceived ?? "Today's",
        onSelected: (value) {
          setState(() {
            selectedRegulatorReceived = value;
            expenseReportModel = [];
            segmentPercentages.clear();
            segmentColors.clear();
          });
          if (value == "Today's") {
            getHeadWiseExpenseLstModel("TODAYS");
          } else if (value == 'This Month') {
            getHeadWiseExpenseLstModel("THISMONTH");
          } else {
            getHeadWiseExpenseLstModel("FINYEAR");
          }
        },
      ),
    );
  }

  // ── Total KPI hero card ────────────────────────────────────────────────────
  Widget _buildTotalKpiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: Colors.white.withOpacity(0.28), width: 1.2),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: AppTypography.heroSubtitle,
                  textScaler: TextScaler.noScaling,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${formatCurrency(totalExpense)}',
                  style: AppTypography.heroKpiValue,
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
          // Expense count badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${expenseReportModel.length} items',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
              textScaler: TextScaler.noScaling,
            ),
          ),
        ],
      ),
    );
  }

  // ── Segmented progress bar ─────────────────────────────────────────────────
  Widget _buildSegmentedBar() {
    if (segmentPercentages.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: List.generate(segmentPercentages.length, (index) {
            return Expanded(
              flex: segmentPercentages[index].round().clamp(1, 100),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: segmentColors[index],
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0
                        ? const Radius.circular(12)
                        : Radius.zero,
                    bottomLeft: index == 0
                        ? const Radius.circular(12)
                        : Radius.zero,
                    topRight: index == segmentPercentages.length - 1
                        ? const Radius.circular(12)
                        : Radius.zero,
                    bottomRight: index == segmentPercentages.length - 1
                        ? const Radius.circular(12)
                        : Radius.zero,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Expense list ───────────────────────────────────────────────────────────
  Widget _buildExpenseList(Map<String, double> groupedExpenses) {
    if (expenseReportModel.isEmpty) {
      return _EmptyState(
        icon: Icons.receipt_long_rounded,
        message: 'No expense data for the selected period.',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenseReportModel.length,
      itemBuilder: (context, index) {
        final expense = expenseReportModel[index];
        final expenseAmount = expense.totExpAmt?.toDouble() ?? 0.0;
        final accentColor = expenseColors[index % expenseColors.length];
        final accentBg = accentColor.withOpacity(0.10);
        final totalForCategory =
            groupedExpenses[expense.parentExpHeadName ?? ''] ?? 0.0;
        final pct = totalExpense > 0
            ? (expenseAmount / totalExpense) * 100
            : 0.0;

        return _ExpenseItemCard(
          index: index,
          expense: expense,
          expenseAmount: expenseAmount,
          percentage: pct,
          accentColor: accentColor,
          accentBg: accentBg,
          formattedAmount: formatCurrency(expenseAmount),
        );
      },
    );
  }

  // ── Revenue vs Expense chart ───────────────────────────────────────────────
  Widget _buildChartCard(double chartWidth) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_graph_rounded,
                      color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Revenue vs Expense',
                          style: AppTypography.cardTitle,
                          textScaler: TextScaler.noScaling),
                      Text(
                        'Monthly comparison — Financial Year',
                        style: AppTypography.labelMD,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                // Legend
                _ChartLegend(
                  items: const [
                    _LegendItem(label: 'Expense', color: AppColors.primary),
                    _LegendItem(label: 'Revenue', color: AppColors.orange),
                  ],
                ),
              ],
            ),
          ),
          // Y-axis label + scrollable chart
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rotated Y-axis label
                RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Revenue & Expense (₹)',
                      style: AppTypography.labelSM,
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: SfCartesianChart(
                          tooltipBehavior: _tooltipBehavior,
                          plotAreaBackgroundColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(
                            labelRotation: 45,
                            interval: 1,
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine:
                            const AxisLine(color: AppColors.border),
                            labelStyle: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          primaryYAxis: NumericAxis(
                            axisLine: const AxisLine(width: 1),
                            majorTickLines:
                            const MajorTickLines(size: 0),
                            axisLabelFormatter:
                                (AxisLabelRenderDetails details) {
                              return ChartAxisLabel(
                                  '', const TextStyle(fontSize: 0));
                            },
                          ),
                          series: <CartesianSeries<dynamic, dynamic>>[
                            ColumnSeries<MonthProfitData, String>(
                              name: 'Expense',
                              dataSource: expenseDataForChart,
                              xValueMapper: (MonthProfitData d, _) =>
                              d.month,
                              yValueMapper: (MonthProfitData d, _) =>
                              d.profit,
                              color: AppColors.primary,
                              width: 0.5,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                              dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                            ),
                            ColumnSeries<MonthProfitData, String>(
                              name: 'Profit',
                              dataSource: profitDataForChart,
                              xValueMapper: (MonthProfitData d, _) =>
                              d.month,
                              yValueMapper: (MonthProfitData d, _) =>
                              d.profit,
                              color: AppColors.orange,
                              width: 0.5,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                              dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Currency formatter (unchanged) ────────────────────────────────────────
  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0$formattedAmount';
    }
    return formattedAmount;
  }

  String _shortAmount(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  // ── API: Head-wise expense list (unchanged) ────────────────────────────────
  Future<void> getHeadWiseExpenseLstModel(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetHeadWiseExpense}/$distributorId/$flag'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    debugPrint("GetHeadWiseExpense : ${AppUrl.GetHeadWiseExpense}/$distributorId/$flag");
    debugPrint("GetHeadWiseExpense : ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<HeadWiseExpenseLstModel> parsedData =
      data.map((json) => HeadWiseExpenseLstModel.fromJson(json)).toList();

      double calculatedTotal =
      parsedData.fold(0.0, (sum, item) => sum + (item.totExpAmt ?? 0.0));

      parsedData.sort((a, b) {
        double amtA = a.totExpAmt?.toDouble() ?? 0.0;
        double amtB = b.totExpAmt?.toDouble() ?? 0.0;
        return amtB.compareTo(amtA);
      });

      List<double> newSegmentPercentages = [];
      List<Color> newSegmentColors = [];

      for (int i = 0; i < parsedData.length; i++) {
        double amount = parsedData[i].totExpAmt?.toDouble() ?? 0.0;
        double pct =
        calculatedTotal > 0 ? (amount / calculatedTotal) * 100 : 0.0;
        newSegmentPercentages.add(pct);
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
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // ── API: Dashboard gross profit + expense (unchanged) ─────────────────────
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

    try {
      var responses = await Future.wait([
        http.get(
          Uri.parse(
              '${AppUrl.GetDashboardFYGrossExpenseDtls_Mob}/$distributorId/$flag'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        ),
        http.get(
          Uri.parse(
              '${AppUrl.GetDashboardFYGrossProfitDtls_Mob}/$distributorId/$flag'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        ),
      ]);

      final expenseResponse = responses[0];
      final profitResponse = responses[1];

      if (expenseResponse.statusCode == 200 &&
          profitResponse.statusCode == 200) {
        final List<dynamic> expenseData = json.decode(expenseResponse.body);
        final List<dynamic> profitData = json.decode(profitResponse.body);

        setState(() {
          grossExpenseModel = expenseData
              .map((json) => GetDashboardFyGrossExpenseDtlsModel.fromJson(json))
              .toList();
          grossProfitModel = profitData
              .map((json) => GetDashboardFyGrossProfitDtlsModel.fromJson(json))
              .toList();
          profitDataForChart = grossProfitModel
              .expand((m) => MonthProfitData.fromGrossProfitModel(m))
              .toList();
          expenseDataForChart = grossExpenseModel
              .expand((m) => MonthProfitData.fromGrossExpenseModel(m))
              .toList();
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
}

// =============================================================================
// MonthProfitData (unchanged — data model)
// =============================================================================
class MonthProfitData {
  final String month;
  final num? profit;

  MonthProfitData(this.month, this.profit);

  static List<MonthProfitData> fromGrossProfitModel(
      GetDashboardFyGrossProfitDtlsModel model) {
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

  static List<MonthProfitData> fromGrossExpenseModel(
      GetDashboardFyGrossExpenseDtlsModel model) {
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

// =============================================================================
// _PillSelector
// Dashboard-style horizontal pill tab bar for period / year selection.
// Replaces raw DropdownButton with a more touch-friendly, themed component.
// =============================================================================
class _PillSelector extends StatelessWidget {
  const _PillSelector({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: options.map((option) {
          final isActive = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelected(option);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : AppColors.textMuted,
                    letterSpacing: 0.1,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// =============================================================================
// _TogglePill
// Two-sided segmented toggle button in the AppBar.
// Both "Expenses" and "Chart" labels are always visible so the user instantly
// understands this is a switchable button — the active side is highlighted.
// =============================================================================
class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.isOn, required this.onChanged});

  final bool isOn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Left side: Expenses ──
          _ToggleSide(
            // icon: Icons.receipt_long_rounded,
            label: 'Expenses',
            isActive: !isOn,
            onTap: () {
              if (isOn) {
                HapticFeedback.selectionClick();
                onChanged(false);
              }
            },
          ),
          const SizedBox(width: 2),
          // ── Right side: Chart ──
          _ToggleSide(
            // icon: Icons.bar_chart_rounded,
            label: 'Chart',
            isActive: isOn,
            onTap: () {
              if (!isOn) {
                HapticFeedback.selectionClick();
                onChanged(true);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// One half of the segmented toggle. Active side gets a solid white fill
/// with dark text; inactive side stays transparent with white text.
class _ToggleSide extends StatelessWidget {
  const _ToggleSide({
    // required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  // final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   icon,
            //   size: 13,
            //   color: isActive ? AppColors.primary : Colors.white70,
            // ),
            // const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.primary : Colors.white70,
                letterSpacing: 0.1,
              ),
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// _KpiBadge
// Frosted-glass KPI pill in the AppBar (total expense amount).
// =============================================================================
class _KpiBadge extends StatelessWidget {
  const _KpiBadge({required this.icon, required this.label});

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
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _ExpenseItemCard
// Dashboard-style card for each expense head:
//   • Left border accent (matches segment bar color)
//   • Icon badge, name, amount, percentage bar
//   • Staggered slide+fade animation (same pattern as AlertActionCard)
// =============================================================================
class _ExpenseItemCard extends StatefulWidget {
  const _ExpenseItemCard({
    required this.index,
    required this.expense,
    required this.expenseAmount,
    required this.percentage,
    required this.accentColor,
    required this.accentBg,
    required this.formattedAmount,
  });

  final int index;
  final HeadWiseExpenseLstModel expense;
  final double expenseAmount;
  final double percentage;
  final Color accentColor;
  final Color accentBg;
  final String formattedAmount;

  @override
  State<_ExpenseItemCard> createState() => _ExpenseItemCardState();
}

class _ExpenseItemCardState extends State<_ExpenseItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 55 * widget.index), () {
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
    final pct = widget.percentage;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
              left: BorderSide(color: widget.accentColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Icon badge
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: widget.accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.category_rounded,
                        color: widget.accentColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  // Expense head name
                  Expanded(
                    child: Text(
                      widget.expense.parentExpHeadName ?? '—',
                      style: AppTypography.cardTitle,
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${widget.formattedAmount}',
                        style: AppTypography.alertValue
                            .copyWith(color: widget.accentColor),
                        textScaler: TextScaler.noScaling,
                      ),
                      Text(
                        '${pct.toStringAsFixed(1)}% of total',
                        style: AppTypography.labelSM,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Mini progress bar showing this item's share
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (pct / 100).clamp(0.0, 1.0),
                  backgroundColor: widget.accentBg,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(widget.accentColor),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _ChartLegend + _LegendItem
// Compact legend for the Revenue vs Expense chart.
// =============================================================================
class _LegendItem {
  const _LegendItem({required this.label, required this.color});
  final String label;
  final Color color;
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.items});
  final List<_LegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.label,
                  style: AppTypography.labelMD,
                  textScaler: TextScaler.noScaling),
              const SizedBox(width: 6),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// =============================================================================
// _EmptyState
// Shown when no expense records are returned for the selected period.
// =============================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
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
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text('No Data Found',
                style: AppTypography.cardTitle,
                textScaler: TextScaler.noScaling),
            const SizedBox(height: 6),
            Text(
              message,
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