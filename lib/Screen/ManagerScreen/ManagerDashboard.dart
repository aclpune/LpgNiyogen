import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../ConstantScreen/widgets.dart';
import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
import '../DashboardModel/TodaysOpeningStockDataModel.dart';
import '../GodownKeeper/DelBoyStockReturn/StockTransferToGodownScreen.dart';
import '../GodownKeeper/DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeDrawer.dart';
import '../Utils/Styling.dart';
import '../Utils/UpdateService.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';

import 'package:http/http.dart' as http;

import 'ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import 'ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
import 'ClickModelClass/GetDashboardTVStockPendCtnListForMob.dart';
import 'DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetails.dart';
import 'DashboardItemClickUI/DashboardSVDetails.dart';
import 'DashboardItemClickUI/DashboardTVDetails.dart';
import 'ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'ManagerModelClass/GetManagerDashboarDetailModel.dart';
import 'ManagerSingleItemUI/CDCMSStockItemUI.dart';
import 'ManagerSingleItemUI/EmptyInwardStockItemUI.dart';
import 'ManagerSingleItemUI/FilledInwardStockItemUI.dart';
import 'ManagerSingleItemUI/ImbalanceStockItemUI.dart';

class ManagerDashboardScreen extends StatefulWidget {
  static const screenName = '/managerDashboardScreen';

  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPrepaidSettlementStatusListViewVisible = false;
  bool isPrepaidPunchingStatusListViewVisible = false;
  bool isPostpaidVerificationStatusListViewVisible = false;
  bool isStockPendingStatusListViewVisible = false;
  bool isTodaysCashSummaryListViewVisible = false;
  bool isCDCMSStockDifferenceListViewVisible = false;
  bool isImbalanceStockListViewVisible = false;
  bool isInwardStockListViewVisible = false;
  bool isInwardStockFilledListViewVisible = false;
  bool isInwardStockEmptyListViewVisible = false;
  bool isInwardStockDefectiveListViewVisible = false;
  bool isOutwardStockListViewVisible = false;
  bool isOutwardStockRefillSaleListViewVisible = false;
  bool isOutwardStockEmptyListViewVisible = false;
  bool isOutwardStockImbalanceListViewVisible = false;
  bool isOpeningStockListViewVisible = false;
  bool isCurrentStockListViewVisible = false;
  List<GetManagerDashboarDetailModel> getManagerDashboarDetail = [];
  List<GetCurrentStockDetailManagerModel> getCurrentStockDetailManager = [];

  bool isLoading = true;
  String? mobileNo, cDCMDPendSince, settlementPendSince;
  int? deliveryMenCount,todaysPunchingInNiyojanC,pendingInNiyojanC,pendingInCdcmsC,todaysIncorrectPunchingC,settlPayReceiveDelPendC,settlDelPayPendC,oldBkgPendNewBkgRecv,delDonNiyoJanPunPend,niyoJanPunDelPend, postPaidVerifPend, sVPendingStk, tVPendingStk;
  double? totalAmount,
      totalIncome,
      totalExpense,
      onAccountToday,
      onAccountAsOfDate;


  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    } else {
      debugPrint("Firebase not initialize");
    }
    debugPrint("ManagerDashboardScreen: initState called");
    fetchCurrentStock();
    fetchDashboarDetail();

  }
  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    fetchCurrentStock();
    fetchDashboarDetail(); // Fetch the data again
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = settlementPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(settlementPendSince!))
        : 'No Date';  // You can change 'No Date' to anything if it's null
    String formattedDatecdcms = cDCMDPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(cDCMDPendSince!))
        : 'No Date';
    return
      Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  // Ensures the content is scrollable
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right:7.0, bottom: 5.0, top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Need Attention",
                                style: Styling.bodyTitleWithBlueHight,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isImbalanceStockListViewVisible =
                              !isImbalanceStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title for Cylinder Categories Table
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: [
                                      itemSubLineWithDDss("Imbalance Stock",isImbalanceStockListViewVisible),
                                      Visibility(
                                        visible:
                                        isImbalanceStockListViewVisible,
                                        child: Column(
                                          children: [
                                            getManagerDashboarDetail.isNotEmpty
                                                ? Column(
                                              children: [
                                                getManagerDashboarDetail.any((sale) =>
                                                sale.todayImbQty! > 0 || sale.asOfDateImbQty! > 0)
                                                    ? Wrap(
                                                  spacing: 7, // Space between items
                                                  runSpacing: 2, // Space between rows
                                                  children: List.generate(
                                                    getManagerDashboarDetail
                                                        .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
                                                        .toList()
                                                        .length, // Use the filtered length here
                                                        (index) {
                                                      // Filter the list first
                                                      var filteredSales = getManagerDashboarDetail
                                                          .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
                                                          .toList();

                                                      var sale = filteredSales[index]; // Access the filtered list

                                                      return Container(
                                                        width: 110,
                                                        child: ImbalanceStockItemUI(
                                                            sale, isLastItem: index == filteredSales.length - 1),
                                                      );
                                                    },
                                                  ),
                                                )
                                                    : Center(child: Text("No data available")),
                                              ],
                                            )

                                                : Container(
                                              child: Text("No Data Available"),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCDCMSStockDifferenceListViewVisible =
                              !isCDCMSStockDifferenceListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title for Cylinder Categories Table
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: [
                                      itemSubLineWithDDss("CDCMS Stock Difference",isCDCMSStockDifferenceListViewVisible),
                                      Visibility(
                                        visible:isCDCMSStockDifferenceListViewVisible,
                                        child:
                                        Column(
                                          children: [
                                            getManagerDashboarDetail.isNotEmpty
                                                ? Column(
                                              children: [
                                                Container(
                                                  child:
                                                  Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                Radius.circular(12),
                                                                topRight:
                                                                Radius.circular(12),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      '',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14,
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      'Filled',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14,
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      'Empty',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14,
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      'Defective',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: 14,
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          getManagerDashboarDetail
                                                              .isNotEmpty
                                                              ?
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                            NeverScrollableScrollPhysics(),
                                                            // itemCount: getCurrentStockDetailManager.length,
                                                            itemCount: getManagerDashboarDetail
                                                                .where((item) =>
                                                            item.filledDiff! > 0 || item.emptyDiff! > 0 || item.defectiveDiff! > 0)
                                                                .length,
                                                            itemBuilder: (context, index) {
                                                              // Filtered items
                                                              final items = getManagerDashboarDetail
                                                                  .where((item) =>
                                                              item.filledDiff! > 0 || item.emptyDiff! > 0 || item.defectiveDiff! > 0)
                                                                  .toList()[index];

                                                              Color backgroundColor = (index % 2 == 0)
                                                                  ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                  : Colors.white70!;
                                                              return Container(
                                                                color: backgroundColor,
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                        children: [
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              items
                                                                                  .itemName
                                                                                  .toString(),
                                                                              style: Styling
                                                                                  .textFormText,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .left,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              items
                                                                                  .filledDiff
                                                                                  .toString(),
                                                                              style: Styling
                                                                                  .textFormText,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              items
                                                                                  .emptyDiff
                                                                                  .toString(),
                                                                              style: Styling
                                                                                  .textFormText,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            flex: 1,
                                                                            child: Text(
                                                                              items
                                                                                  .defectiveDiff
                                                                                  .toString(),
                                                                              style: Styling
                                                                                  .textFormText,
                                                                              textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                              : Container(
                                                            child: Text(
                                                                "No Data Available"),
                                                          ),
                                                        ],
                                                      ),

                                                      // ),
                                                    ],
                                                  ),
                                                )
                                                // Show a message when no items meet the condition
                                              ],
                                            )
                                                : Container(
                                              child: Text("No Data Available"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Unsettled Sale ",
                                            style: Styling.bodyTitleBig,
                                          ),
                                          Text(
                                            "(Pending) : ",
                                            style: Styling.textFormText,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:5.0,right:5),
                                            child: Text(
                                              deliveryMenCount
                                                  .toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .countNumber,
                                              textAlign:
                                              TextAlign
                                                  .center,
                                            ),
                                          ),
                                          verticalDividerSmallest(),
                                          Padding(
                                            padding: const EdgeInsets.only(left:5.0,right:5),
                                            child: Text(
                                              formatCurrency(
                                                  totalAmount ?? 0),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .countNumber,
                                              textAlign:
                                              TextAlign
                                                  .center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isTodaysCashSummaryListViewVisible =
                              !isTodaysCashSummaryListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title for Cylinder Categories Table
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: [
                                      itemSubLineWithDDss("Today's Cash Summary",isTodaysCashSummaryListViewVisible),
                                      Visibility(
                                        visible: isTodaysCashSummaryListViewVisible,
                                        child: Column(
                                          children: [
                                            getManagerDashboarDetail.isNotEmpty
                                                ? Column(
                                              children: [
                                                Container(
                                                  child:
                                                  Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    formatCurrency(
                                                                        totalIncome!),
                                                                    // Replace this with your dynamic data
                                                                    style: Styling
                                                                        .countNumber,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                      7),
                                                                  // Space between count and label
                                                                  Text(
                                                                    'Income',
                                                                    // Label for filledDiff
                                                                    style: Styling
                                                                        .textFormTextSmall,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    formatCurrency(
                                                                        totalExpense!),
                                                                    // Replace this with your dynamic data
                                                                    style: Styling
                                                                        .countNumber,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                      7),
                                                                  // Space between count and label
                                                                  Text(
                                                                    'Expense',
                                                                    // Label for emptyDiff
                                                                    style: Styling
                                                                        .textFormTextSmall,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                            8.0),
                                                                        child:
                                                                        Text(
                                                                          formatCurrency(
                                                                              onAccountToday!),
                                                                          // Replace this with your dynamic data
                                                                          style:
                                                                          Styling.countNumber,
                                                                          textAlign:
                                                                          TextAlign.center,
                                                                        ),
                                                                      ),
                                                                      verticalDividerSmallest(),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                            8.0),
                                                                        child:
                                                                        Text(
                                                                          formatCurrency(
                                                                              onAccountAsOfDate!),
                                                                          // Replace this with your dynamic data
                                                                          style:
                                                                          Styling.countNumber,
                                                                          textAlign:
                                                                          TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                      7),
                                                                  // Space between count and label
                                                                  Text(
                                                                    'On Account',
                                                                    // Label for defectiveDiff
                                                                    style: Styling
                                                                        .textFormTextSmall,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  // ),
                                                ),
                                                // Show a message when no items meet the condition
                                              ],
                                            )
                                                : Container(
                                              child: Text("No Data Available"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPrepaidPunchingStatusListViewVisible =
                                            !isPrepaidPunchingStatusListViewVisible; // Toggle ListView visibility
                                          });
                                        },
                                        child: itemSubLineWithDDss("Prepaid Punching Status", isPrepaidPunchingStatusListViewVisible)),
                                    Visibility(
                                      visible: isPrepaidPunchingStatusListViewVisible,
                                      child: Column(
                                        children: [
                                          getManagerDashboarDetail.isNotEmpty
                                              ? Column(
                                            children: [
                                              Container(
                                                child: Column( // This column contains two rows
                                                  children: [
                                                    // First row (items 1 and 2)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        // First item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                todaysPunchingInNiyojanC! > 0
                                                                    ?
                                                                    () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "Punching"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque, // Ensures the area is tappable if onTap is set
                                                                child: Text(
                                                                  todaysPunchingInNiyojanC.toString(),
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 5),
                                                              Text(
                                                                "Today's Niyojan\nPunched",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 2), // Space between the two items
                                                        // Second item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: todaysIncorrectPunchingC! > 0
                                                                    ? () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "Incorrect"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque,
                                                                child: Text(
                                                                  todaysIncorrectPunchingC.toString(),
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 3),
                                                              Text(
                                                                "Today's incorrect\n",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Second row (items 3 and 4)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        // Third item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: pendingInCdcmsC! > 0
                                                                    ? () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "cDCMS"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque,
                                                                child: Text(
                                                                  //pendingInCdcmsC.toString(),
                                                                  '${pendingInCdcmsC.toString()} ($formattedDatecdcms)', // Use 'N/A' if cDCMDPendSince is null
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 4),
                                                              Text(
                                                                "Pending in cDCMS",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 5), // Space between the two items
                                                        // Fourth item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:  oldBkgPendNewBkgRecv! > 0
                                                                    ? () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "OldBkgPendNewBkgRecv"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque,
                                                                child: Text(
                                                                  oldBkgPendNewBkgRecv.toString(),
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 8),
                                                              Text(
                                                                "Old punching pending\n in Niyojan but new\n booking is received\n",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        // Third item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap:  delDonNiyoJanPunPend! > 0
                                                                    ? () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "DelDonNiyoJanPunPend"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque,
                                                                child: Text(
                                                                  delDonNiyoJanPunPend.toString(),
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 4),
                                                              Text(
                                                                "Punched in cDCMS,\npending in Niyojan",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // SizedBox(width: 5), // Space between the two items
                                                        // Fourth item
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: niyoJanPunDelPend! > 0
                                                                    ? () {
                                                                  Navigator.pushNamed(
                                                                    context,
                                                                    DashboardPrepaidDetails.screenName,
                                                                    arguments: {"flag": "NiyoJanPunDelPend"},
                                                                  );
                                                                }
                                                                    : null, // No action when count is 0 or less
                                                                behavior: HitTestBehavior.opaque,
                                                                child: Text(
                                                                  niyoJanPunDelPend.toString(),
                                                                  style: Styling.countNumber.copyWith(
                                                                    color: Colors.blue,
                                                                    decoration: TextDecoration.underline,
                                                                    decorationColor: Colors.blue,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              SizedBox(height: 4),
                                                              Text(
                                                                "Punched in Niyojan,\npending in cDCMS",
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPrepaidSettlementStatusListViewVisible =
                                            !isPrepaidSettlementStatusListViewVisible; // Toggle ListView visibility
                                          });
                                        },
                                        child: itemSubLineWithDDsss("Prepaid Settlement Status","(Data ref by cDCMS)",isPrepaidSettlementStatusListViewVisible)),
                                    Visibility(
                                      visible:isPrepaidSettlementStatusListViewVisible ,
                                      child: Column(
                                        children: [
                                          getManagerDashboarDetail.isNotEmpty
                                              ? Column(
                                            children: [
                                              Container(
                                                child:
                                                Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: settlPayReceiveDelPendC! > 0
                                                                          ? (){
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            DashboardPrepaidDetails
                                                                                .screenName,
                                                                            arguments: {
                                                                              "flag":"Settled",
                                                                            }
                                                                        );
                                                                      } :null,
                                                                      behavior: HitTestBehavior.opaque,
                                                                      child: Text(
                                                                        settlPayReceiveDelPendC.toString(),
                                                                        // Replace this with your dynamic data
                                                                        style: Styling
                                                                            .countNumber.copyWith(
                                                                          color: Colors.blue, // Make the text blue like a link
                                                                          decoration: TextDecoration.underline,// Underline the text
                                                                          decorationColor: Colors.blue,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                        4),
                                                                    // Space between count and label
                                                                    Text(
                                                                      'Payment done,\ndelivery pending.',
                                                                      // Label for filledDiff
                                                                      style: Styling
                                                                          .textFormText,
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: settlDelPayPendC! > 0
                                                                          ? (){
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            DashboardPrepaidDetails
                                                                                .screenName,
                                                                            arguments: {
                                                                              "flag":"Delivered",
                                                                            }
                                                                        );
                                                                      } : null,
                                                                      behavior: HitTestBehavior.opaque,
                                                                      child:
                                                                      // Text(
                                                                      //   settlDelPayPendC.toString(),
                                                                      //   // Replace this with your dynamic data
                                                                      //   style: Styling
                                                                      //       .countNumber.copyWith(
                                                                      //     color: Colors.blue, // Make the text blue like a link
                                                                      //     decoration: TextDecoration.underline,// Underline the text
                                                                      //     decorationColor: Colors.blue,
                                                                      //   ),
                                                                      //   textAlign:
                                                                      //   TextAlign.center,
                                                                      // ),
                                                                      Text(
                                                                        //settlDelPayPendC.toString(),
                                                                        //'${settlDelPayPendC.toString()} ($cDCMDPendSince)',
                                                                        '${settlDelPayPendC.toString()} ($formattedDate)', // Use 'N/A' if cDCMDPendSince is null

                                                                        // settlDelPayPendC.toString(),
                                                                        // Combine the count and formatted date
                                                                        style: Styling.countNumber.copyWith(
                                                                          color: Colors.blue,  // Make the text blue like a link
                                                                          decoration: TextDecoration.underline, // Underline the text
                                                                          decorationColor: Colors.blue,  // Underline color
                                                                        ),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      //print('cDCMDPendSince value: $cDCMDPendSince');
                                                                    ),
                                                                    SizedBox(
                                                                        height: 4),
                                                                    // Space between count and label
                                                                    Text(
                                                                      'Delivered,\npayment pending',
                                                                      // Label for emptyDiff
                                                                      style: Styling
                                                                          .textFormText,
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                // ),
                                              ),
                                              // Show a message when no items meet the condition
                                            ],
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPostpaidVerificationStatusListViewVisible =
                                            !isPostpaidVerificationStatusListViewVisible; // Toggle ListView visibility
                                          });
                                        },
                                        child: itemSubLineWithDDss("Postpaid Verification Status",isPostpaidVerificationStatusListViewVisible)),
                                    Visibility(
                                      visible:isPostpaidVerificationStatusListViewVisible ,
                                      child: Column(
                                        children: [
                                          getManagerDashboarDetail.isNotEmpty
                                              ? Column(
                                            children: [
                                              Container(
                                                child:
                                                Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:postPaidVerifPend! > 0
                                                                          ? (){
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            DashboardPostPaidVerifPendDetails
                                                                                .screenName,
                                                                            arguments: {
                                                                              "flag":"All",
                                                                            }
                                                                        );
                                                                      } :null,
                                                                      behavior: HitTestBehavior.opaque,
                                                                      child: Text(
                                                                        postPaidVerifPend.toString(),
                                                                        // Replace this with your dynamic data
                                                                        style: Styling
                                                                            .countNumber.copyWith(
                                                                          color: Colors.blue, // Make the text blue like a link
                                                                          decoration: TextDecoration.underline,// Underline the text
                                                                          decorationColor: Colors.blue,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                        4),
                                                                    // Space between count and label
                                                                    Text(
                                                                      'Postpaid verification pending',
                                                                      // Label for filledDiff
                                                                      style: Styling
                                                                          .textFormText,
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                // ),
                                              ),
                                              // Show a message when no items meet the condition
                                            ],
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isStockPendingStatusListViewVisible =
                                            !isStockPendingStatusListViewVisible; // Toggle ListView visibility
                                          });
                                        },
                                        child: itemSubLineWithDDss("Stock Pending Status",isStockPendingStatusListViewVisible)),
                                    Visibility(
                                      visible:isStockPendingStatusListViewVisible ,
                                      child: Column(
                                        children: [
                                          getManagerDashboarDetail.isNotEmpty
                                              ? Column(
                                            children: [
                                              Container(
                                                child:
                                                Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: sVPendingStk! > 0
                                                                          ? (){
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            DashboardSVDetails
                                                                                .screenName,
                                                                            arguments: {
                                                                              "flag":0,
                                                                            }
                                                                        );
                                                                      }: null,
                                                                      behavior: HitTestBehavior.opaque,
                                                                      child: Text(
                                                                        sVPendingStk.toString(),
                                                                        // Replace this with your dynamic data
                                                                        style: Styling
                                                                            .countNumber.copyWith(
                                                                          color: Colors.blue, // Make the text blue like a link
                                                                          decoration: TextDecoration.underline,// Underline the text
                                                                          decorationColor: Colors.blue,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                        4),
                                                                    // Space between count and label
                                                                    Text(
                                                                      'SV',
                                                                      // Label for filledDiff
                                                                      style: Styling
                                                                          .textFormText,
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:tVPendingStk! > 0
                                                                          ? (){
                                                                        Navigator.pushNamed(
                                                                            context,
                                                                            DashboardTVDetails
                                                                                .screenName,
                                                                            arguments: {
                                                                              "flag":0,
                                                                            }
                                                                        );
                                                                      }:null,
                                                                      behavior: HitTestBehavior.opaque,
                                                                      child: Text(
                                                                        tVPendingStk.toString(),
                                                                        // Replace this with your dynamic data
                                                                        style: Styling
                                                                            .countNumber.copyWith(
                                                                          color: Colors.blue, // Make the text blue like a link
                                                                          decoration: TextDecoration.underline,// Underline the text
                                                                          decorationColor: Colors.blue,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: 4),
                                                                    // Space between count and label
                                                                    Text(
                                                                      'TV',
                                                                      // Label for emptyDiff
                                                                      style: Styling
                                                                          .textFormText,
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                // ),
                                              ),
                                              // Show a message when no items meet the condition
                                            ],
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOpeningStockListViewVisible =
                              !isOpeningStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child:
                            Column(
                              children: [
                                itemSubLineWithDDs("Opening Stock",isOpeningStockListViewVisible),

                                Visibility(
                                  visible: isOpeningStockListViewVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for Cylinder Categories Table
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: getCurrentStockDetailManager
                                                  .any((item) => item.filledOpeningStk! > 0 || item.emptyOpeningStk! >0 || item.deffOpeningStk! >0),
                                              // Condition to check visibility
                                              child:
                                              Container(
                                                child:
                                                Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                              Radius.circular(12),
                                                              topRight:
                                                              Radius.circular(12),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Filled',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Empty',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Defective',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        getCurrentStockDetailManager
                                                            .isNotEmpty
                                                            ?
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                          NeverScrollableScrollPhysics(),
                                                          // itemCount: getCurrentStockDetailManager.length,
                                                          itemCount:
                                                          getCurrentStockDetailManager
                                                              .where((item) =>
                                                          item.filledOpeningStk! > 0 || item.emptyOpeningStk! >0 || item.deffOpeningStk! >0) // Filter items with defectivCnt > 0
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            // final items =
                                                            // getCurrentStockDetailManager[
                                                            // index];

                                                            final items = getCurrentStockDetailManager
                                                                .where((item) =>
                                                            item.filledOpeningStk! > 0 || item.emptyOpeningStk! >0 || item.deffOpeningStk! >0)
                                                                .toList()[index];
                                                            // Determine the background color based on the index (alternating colors)
                                                            Color backgroundColor = (index % 2 == 0)
                                                                ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                : Colors.white70!;
                                                            return Container(
                                                              color: backgroundColor,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child:
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .itemName
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .filledOpeningStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .emptyOpeningStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .deffOpeningStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                            : Container(
                                                          child: Text("No Data Available"),
                                                        ),
                                                      ],
                                                    ),

                                                    // ),
                                                  ],
                                                ),
                                              ),


                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isInwardStockListViewVisible =
                              !isInwardStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child:
                            Column(
                              children: [
                                itemSubLineWithDDs("Inward Stock",isInwardStockListViewVisible),

                                Visibility(
                                  visible: isInwardStockListViewVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for Cylinder Categories Table
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: getCurrentStockDetailManager.any(
                                                      (item) =>
                                                  item.totalInvoiceCnt! > 0 ||
                                                      item.filledEMRCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isInwardStockFilledListViewVisible =
                                                    !isInwardStockFilledListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      itemSubLineSubMenu("Filled",isInwardStockFilledListViewVisible),
                                                      Visibility(
                                                        visible: isInwardStockFilledListViewVisible,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(12),
                                                                  topRight: Radius.circular(12),
                                                                ),
                                                              ),
                                                              child:
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Invoice',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'EMR',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            getCurrentStockDetailManager
                                                                .isNotEmpty
                                                                ? ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              // itemCount: getCurrentStockDetailManager.length,
                                                              itemCount:
                                                              getCurrentStockDetailManager
                                                                  .where((item) =>
                                                              item.totalInvoiceCnt! >
                                                                  0 ||
                                                                  item.filledEMRCnt! >
                                                                      0) // Filter items with defectivCnt > 0
                                                                  .length,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                // final items =
                                                                // getCurrentStockDetailManager[
                                                                // index];

                                                                final items = getCurrentStockDetailManager
                                                                    .where((item) =>
                                                                item.totalInvoiceCnt! > 0 || item.filledEMRCnt! > 0)
                                                                    .toList()[index];

                                                                Color backgroundColor = (index % 2 == 0)
                                                                    ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                    : Colors.white70!;
                                                                return Container(
                                                                  color: backgroundColor,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .itemName
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .totalInvoiceCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .filledEMRCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                                : Container(
                                                              child: Text(
                                                                  "No Data Available"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 15,),
                                            Visibility(
                                              visible: getCurrentStockDetailManager
                                                  .any((item) => item.emptyTVCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isInwardStockEmptyListViewVisible =
                                                    !isInwardStockEmptyListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          itemSubLineSubMenu("Empty (TV)",isInwardStockEmptyListViewVisible),
                                                          Visibility(
                                                            visible: isInwardStockEmptyListViewVisible,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.only(
                                                                      topLeft:
                                                                      Radius.circular(12),
                                                                      topRight:
                                                                      Radius.circular(12),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '',
                                                                            style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'TV',
                                                                            style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                getCurrentStockDetailManager
                                                                    .isNotEmpty
                                                                    ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics:
                                                                  NeverScrollableScrollPhysics(),
                                                                  // itemCount: getCurrentStockDetailManager.length,
                                                                  itemCount:
                                                                  getCurrentStockDetailManager
                                                                      .where((item) =>
                                                                  item.emptyTVCnt! >
                                                                      0) // Filter items with defectivCnt > 0
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context, index) {
                                                                    // final items =
                                                                    // getCurrentStockDetailManager[
                                                                    // index];

                                                                    final items = getCurrentStockDetailManager
                                                                        .where((item) =>
                                                                    item.emptyTVCnt! > 0)
                                                                        .toList()[index];

                                                                    Color backgroundColor = (index % 2 == 0)
                                                                        ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                        : Colors.white70!;
                                                                    return Container(
                                                                      color: backgroundColor,
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(8.0),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .center,
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child:
                                                                                  Text(
                                                                                    items
                                                                                        .itemName
                                                                                        .toString(),
                                                                                    style: Styling
                                                                                        .textFormText,
                                                                                    textAlign:
                                                                                    TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child:
                                                                                  Text(
                                                                                    items
                                                                                        .emptyTVCnt
                                                                                        .toString(),
                                                                                    style: Styling
                                                                                        .textFormText,
                                                                                    textAlign:
                                                                                    TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                                    : Container(
                                                                  child: Text(
                                                                      "No Data Available"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 15,),
                                            // Check if any item has a non-null, non-zero defectivCnt

                                            Visibility(
                                              visible: getCurrentStockDetailManager
                                                  .any((item) => item.defectivCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isInwardStockDefectiveListViewVisible =
                                                    !isInwardStockDefectiveListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      itemSubLineSubMenu("Defective",isInwardStockDefectiveListViewVisible),
                                                      Visibility(
                                                        visible: isInwardStockDefectiveListViewVisible,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.only(
                                                                  topLeft:
                                                                  Radius.circular(12),
                                                                  topRight:
                                                                  Radius.circular(12),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Defective',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Since',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            getCurrentStockDetailManager
                                                                .isNotEmpty
                                                                ? ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              // itemCount: getCurrentStockDetailManager.length,
                                                              itemCount:
                                                              getCurrentStockDetailManager
                                                                  .where((item) =>
                                                              item.defectivCnt! >
                                                                  0) // Filter items with defectivCnt > 0
                                                                  .length,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                // final items =
                                                                // getCurrentStockDetailManager[
                                                                // index];

                                                                final items = getCurrentStockDetailManager
                                                                    .where((item) =>
                                                                item.defectivCnt! > 0)
                                                                    .toList()[index];

                                                                Color backgroundColor = (index % 2 == 0)
                                                                    ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                    : Colors.white70!;
                                                                return Container(
                                                                  color: backgroundColor,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .itemName
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .defectivCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                DateFormat(
                                                                                    'dd-MM-yyyy')
                                                                                    .format(DateTime.parse(items.defectivFromDate.toString() ??
                                                                                    '')),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                                : Container(
                                                              child: Text(
                                                                  "No Data Available"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOutwardStockListViewVisible =
                              !isOutwardStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child: Column(
                              children: [

                                itemSubLineWithDDs("Outward Stock",isOutwardStockListViewVisible),

                                Visibility(
                                  visible: isOutwardStockListViewVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for Cylinder Categories Table
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [

                                            Visibility(
                                              visible: getCurrentStockDetailManager.any(
                                                      (item) =>
                                                  item.emptyCRDCnt! > 0 ||
                                                      item.emptyDefectivCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isOutwardStockEmptyListViewVisible =
                                                    !isOutwardStockEmptyListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      itemSubLineSubMenu("Empty",isOutwardStockEmptyListViewVisible),

                                                      Visibility(
                                                        visible: isOutwardStockEmptyListViewVisible,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(12),
                                                                  topRight: Radius.circular(12),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'CRD',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Defective',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            getCurrentStockDetailManager
                                                                .isNotEmpty
                                                                ? ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              // itemCount: getCurrentStockDetailManager.length,
                                                              itemCount:
                                                              getCurrentStockDetailManager
                                                                  .where((item) =>
                                                              item.emptyCRDCnt! >
                                                                  0 ||
                                                                  item.emptyDefectivCnt! >
                                                                      0) // Filter items with defectivCnt > 0
                                                                  .length,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                // final items =
                                                                //     getCurrentStockDetailManager[
                                                                //         index];

                                                                final items = getCurrentStockDetailManager
                                                                    .where((item) =>
                                                                item.emptyCRDCnt! > 0 || item.emptyDefectivCnt! >0)
                                                                    .toList()[index];

                                                                Color backgroundColor = (index % 2 == 0)
                                                                    ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                    : Colors.white70!;
                                                                return Container(
                                                                  color: backgroundColor,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .itemName
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .emptyCRDCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .emptyDefectivCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                                : Container(
                                                              child: Text(
                                                                  "No Data Available"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 15,),
                                            Visibility(
                                              visible: getCurrentStockDetailManager.any(
                                                      (item) =>
                                                  item.sVQty! > 0 ||
                                                      item.refillSaleCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isOutwardStockRefillSaleListViewVisible =
                                                    !isOutwardStockRefillSaleListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          itemSubLineSubMenu("Refill Sale",isOutwardStockRefillSaleListViewVisible),

                                                          Visibility(
                                                            visible: isOutwardStockRefillSaleListViewVisible,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.only(
                                                                      topLeft:
                                                                      Radius.circular(12),
                                                                      topRight:
                                                                      Radius.circular(12),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            '',
                                                                            style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'SV',
                                                                            style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            'Refill Sale',
                                                                            style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color:
                                                                              Colors.black,
                                                                              fontSize: 14,
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                getCurrentStockDetailManager
                                                                    .isNotEmpty
                                                                    ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics:
                                                                  NeverScrollableScrollPhysics(),
                                                                  // itemCount: getCurrentStockDetailManager.length,
                                                                  itemCount:
                                                                  getCurrentStockDetailManager
                                                                      .where((item) =>
                                                                  item.sVQty! >
                                                                      0 ||
                                                                      item.refillSaleCnt! >
                                                                          0) .length,
                                                                  itemBuilder:
                                                                      (context, index) {
                                                                    final items = getCurrentStockDetailManager
                                                                        .where((item) =>
                                                                    item.sVQty! > 0 || item.refillSaleCnt! > 0)
                                                                        .toList()[index];
                                                                    // final items =
                                                                    //     getCurrentStockDetailManager[
                                                                    //         index];
                                                                    Color backgroundColor = (index % 2 == 0)
                                                                        ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                        : Colors.white70!;
                                                                    return Container(
                                                                      color: backgroundColor,
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(8.0),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .center,
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child:
                                                                                  Text(
                                                                                    items
                                                                                        .itemName
                                                                                        .toString(),
                                                                                    style: Styling
                                                                                        .textFormText,
                                                                                    textAlign:
                                                                                    TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child:
                                                                                  Text(
                                                                                    items
                                                                                        .sVQty
                                                                                        .toString(),
                                                                                    style: Styling
                                                                                        .textFormText,
                                                                                    textAlign:
                                                                                    TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child:
                                                                                  Text(
                                                                                    items
                                                                                        .refillSaleCnt
                                                                                        .toString(),
                                                                                    style: Styling
                                                                                        .textFormText,
                                                                                    textAlign:
                                                                                    TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                                    : Container(
                                                                  child: Text(
                                                                      "No Data Available"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 15,),
                                            Visibility(
                                              visible: getCurrentStockDetailManager
                                                  .any((item) => item.imbalanceCnt! > 0),
                                              // Condition to check visibility
                                              child:
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isOutwardStockImbalanceListViewVisible =
                                                    !isOutwardStockImbalanceListViewVisible; // Toggle ListView visibility
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      itemSubLineSubMenu("Imbalance",isOutwardStockImbalanceListViewVisible),

                                                      Visibility(
                                                        visible: isOutwardStockImbalanceListViewVisible,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(12),
                                                                  topRight: Radius.circular(12),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        'Imbalance',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                        textAlign:
                                                                        TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            getCurrentStockDetailManager
                                                                .isNotEmpty
                                                                ? ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                              NeverScrollableScrollPhysics(),
                                                              // itemCount: getCurrentStockDetailManager.length,
                                                              itemCount:
                                                              getCurrentStockDetailManager
                                                                  .where((item) =>
                                                              item.imbalanceCnt! >
                                                                  0) // Filter items with defectivCnt > 0
                                                                  .length,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                final items = getCurrentStockDetailManager
                                                                    .where((item) =>
                                                                item.imbalanceCnt! > 0)
                                                                    .toList()[index];
                                                                // final items =
                                                                //     getCurrentStockDetailManager[
                                                                //         index];
                                                                Color backgroundColor = (index % 2 == 0)
                                                                    ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                    : Colors.white70!;
                                                                return Container(
                                                                  color: backgroundColor,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .itemName
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                items
                                                                                    .imbalanceCnt
                                                                                    .toString(),
                                                                                style: Styling
                                                                                    .textFormText,
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                                : Container(
                                                              child: Text(
                                                                  "No Data Available"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCurrentStockListViewVisible =
                              !isCurrentStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 1,
                            child:
                            Column(
                              children: [
                                itemSubLineWithDDs("Current Stock",isCurrentStockListViewVisible),

                                Visibility(
                                  visible: isCurrentStockListViewVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title for Cylinder Categories Table
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: getCurrentStockDetailManager
                                                  .any((item) => item.filledCurrentStk! > 0 || item.emptyCurrentStk! >0 || item.deffCurrentStk! >0),
                                              // Condition to check visibility

                                              child:
                                              Container(
                                                child:
                                                Column(

                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                              Radius.circular(12),
                                                              topRight:
                                                              Radius.circular(12),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Filled',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Empty',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    'Defective',
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                      fontSize: 14,
                                                                    ),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        getCurrentStockDetailManager
                                                            .isNotEmpty
                                                            ?
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                          NeverScrollableScrollPhysics(),
                                                          // itemCount: getCurrentStockDetailManager.length,
                                                          itemCount:
                                                          getCurrentStockDetailManager
                                                              .where((item) =>
                                                          item.filledCurrentStk! > 0 || item.emptyCurrentStk! >0 || item.deffCurrentStk! >0) // Filter items with defectivCnt > 0
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            // final items =
                                                            // getCurrentStockDetailManager[
                                                            // index];

                                                            final items = getCurrentStockDetailManager
                                                                .where((item) =>
                                                            item.filledCurrentStk! > 0 || item.emptyCurrentStk! >0 || item.deffCurrentStk! >0)
                                                                .toList()[index];

                                                            Color backgroundColor = (index % 2 == 0)
                                                                ? Colors.grey[300]!  // Color for even index (first, third, fifth...)
                                                                : Colors.white70!;
                                                            return Container(
                                                              color: backgroundColor,
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .itemName
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .filledCurrentStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .emptyCurrentStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 1,
                                                                          child: Text(
                                                                            items
                                                                                .deffCurrentStk
                                                                                .toString(),
                                                                            style: Styling
                                                                                .textFormText,
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                            : Container(
                                                          child: Text(
                                                              "No Data Available"),
                                                        ),
                                                      ],
                                                    ),

                                                    // ),
                                                  ],
                                                ),
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(50), // Adjust the radius as needed
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Refresh"),
                  content: Text("Do You Want To Refresh Data?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close the dialog without action
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        setState(() {

                          _onRefresh();
                        });
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.refresh, color: Colors.white),
        ),
      );
  }

  Future<void> fetchDashboarDetail() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token



      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now); // You can change the format as needed


      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetMobDashboardSummaryForMgr}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            'cDCMDPendSince': formattedDate,
            'SettlementPendSince': formattedDate,
            // Any other headers you need can go here
          },
        );

        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetMobDashboardSummaryForMgr: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetMobDashboardSummaryForMgr: ${response.statusCode}");
        print("API Response GetMobDashboardSummaryForMgr: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getManagerDashboarDetail = data
                .map((json) => GetManagerDashboarDetailModel.fromJson(json))
                .toList();
            isLoading = false;
            EasyLoading.dismiss();

            // Initialize totalImbQty
            num dMCounts = 0;
            double totalAmounts = 0;
            double totalIncomes = 0;
            double totalExpenses = 0;
            double onAccountTodays = 0;
            double onAccountAsOfDates = 0;

            // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            for (var receipt in getManagerDashboarDetail) {
              // Add imbQty to totalImbQty, treating null as 0
              dMCounts += receipt.dMCount ?? 0;
              totalAmounts +=
                  receipt.totalAmount ?? 0; // Corrected summing of imbQty
              totalIncomes +=
                  receipt.totalIncome ?? 0; // Corrected summing of imbQty
              totalExpenses +=
                  receipt.totalExp ?? 0; // Corrected summing of imbQty
              onAccountTodays +=
                  receipt.staffOnAccToday ?? 0; // Corrected summing of imbQty
              onAccountAsOfDates +=
                  receipt.staffOnAccAsOf ?? 0; // Corrected summing of imbQty
            }
            // deliveryMenCount = dMCounts.toInt();
            // totalAmount = totalAmounts.toDouble();
            // totalIncome = totalIncomes.toDouble();
            // totalExpense = totalExpenses.toDouble();
            // onAccountToday = onAccountTodays.toDouble();
            // onAccountAsOfDate = onAccountAsOfDates.toDouble();

            // Print the totalAmount of the first item (if exists)
            if (getManagerDashboarDetail.isNotEmpty) {
              print(
                  'Total Amount of the first item: ${getManagerDashboarDetail[0].totalAmount}');
              deliveryMenCount = getManagerDashboarDetail[0].dMCount?.toInt();
              totalAmount = getManagerDashboarDetail[0].totalAmount?.toDouble();
              totalIncome = getManagerDashboarDetail[0].totalIncome?.toDouble();
              totalExpense = getManagerDashboarDetail[0].totalExp?.toDouble();
              onAccountToday = getManagerDashboarDetail[0].staffOnAccToday?.toDouble();
              onAccountAsOfDate = getManagerDashboarDetail[0].staffOnAccAsOf?.toDouble();

              todaysPunchingInNiyojanC = getManagerDashboarDetail[0].niyojanPun?.toInt()??0;
              pendingInNiyojanC = getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt()??0;
              pendingInCdcmsC = getManagerDashboarDetail[0].cDCMSPunPend?.toInt()??0;
              todaysIncorrectPunchingC = getManagerDashboarDetail[0].niyojanDuplicate?.toInt()??0;
              settlPayReceiveDelPendC = getManagerDashboarDetail[0].paymtDoneBtDelPend?.toInt()??0;
              settlDelPayPendC = getManagerDashboarDetail[0].delDoneBtPaymtPend?.toInt()??0;
              oldBkgPendNewBkgRecv = getManagerDashboarDetail[0].oldBkgPendNewBkgRecv?.toInt()??0;
              delDonNiyoJanPunPend = getManagerDashboarDetail[0].delDonNiyoJanPunPend?.toInt()??0;
              niyoJanPunDelPend = getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt()??0;
              postPaidVerifPend = getManagerDashboarDetail[0].postPaidVerifPend?.toInt()??0;
              sVPendingStk = getManagerDashboarDetail[0].sVPendingStk?.toInt()??0;
              tVPendingStk = getManagerDashboarDetail[0].tVPendingStk?.toInt()??0;
              cDCMDPendSince = getManagerDashboarDetail[0].cDCMDPendSince?.toString();
              settlementPendSince = getManagerDashboarDetail[0].settlementPendSince?.toString();

            }
          });
        } else {
          // Handle non-200 responses
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
          // refreshTokens();
          // showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        if (mounted) {  // Check if the widget is still mounted
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
          });
        }
        // refreshTokens();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        // showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchCurrentStock() async {
    print(
        "Request URL InventoryCurrentStockDtlsForMobDash:");
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.InventoryCurrentStockDtlsForMobDash}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print(
            "Request URL InventoryCurrentStockDtlsForMobDash: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status InventoryCurrentStockDtlsForMobDash: ${response.statusCode}");
        print(
            "API Response InventoryCurrentStockDtlsForMobDash: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStockDetailManager = data
                .map((json) => GetCurrentStockDetailManagerModel.fromJson(json))
                .toList();
            isLoading = false;
            EasyLoading.dismiss();
          });
        } else {
          // Handle non-200 responses
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
          // refreshTokens();
          // showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        if (mounted) {  // Check if the widget is still mounted
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
          });
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        refreshTokens();
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();

      final Future<Map<String, dynamic>> respose =
          auth.refreshToken(mobileNo!, context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchCurrentStock();
            fetchDashboarDetail();
          } else if (response['message'] == "Token Expired") {
            debugPrint('RefreshTokenExc401 - true');
            showDialogToExpireSession(context);
          } else{
            debugPrint('RefreshTokenStatus - false');
          }
        }).catchError((error) {
          EasyLoading.dismiss();
          debugPrint('RefreshTokenError1: $error');
        });
      } on HttpException catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenHttpExc: $error');
      } catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenError2: $error');
      }
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint('RefreshTokenError3: $error');
    }
  }

  showDialogToExpireSession(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Expired";
        String message = "Your session is expire. Click ok to login again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
                onWillPop: () async {
                  SystemNavigator.pop();
                  return true;
                },
                child: CupertinoAlertDialog(
                  title: Text(
                    title,
                    style: Styling.bodyTitle,
                  ),
                  content: Text(
                    message,
                    style: Styling.bodyTitle,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        btnLabel,
                        style: Styling.blueClrText,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            : WillPopScope(
                child: AlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: Text(btnLabel),
                      onPressed: () => logoutUser(context),
                    ),
                  ],
                ),
                onWillPop: () async {
                  SystemNavigator.pop();
                  return true;
                },
              );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {
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

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format =
        NumberFormat('#,##,###.00', 'en_IN'); // Indian locale without symbol

    return format.format(amount);
  }
}
