import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../UndocumentedSVDash/DashboardUndocumentedDetails.dart';
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

import 'CashHandoverScreen.dart';
import 'DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetails.dart';
import 'DashboardItemClickUI/DashboardSVDetails.dart';
import 'DashboardItemClickUI/DashboardTVDetails.dart';
import 'DashboardItemClickUI/ImbalanceCountClickUI.dart';
import 'DashboardItemClickUI/TodaysCashSummaryOnAccountList.dart';
import 'DashboardItemClickUI/UnsettledSaleDetailList.dart';
import 'ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'ManagerModelClass/GetManagerDashboarDetailModel.dart';

import 'ManagerSingleItemUI/ImbalanceStockItemUI.dart';
import 'PaymentReceiptScreen/PaymentReceiptScreen.dart';
import 'SVSaleReportScreen.dart';
import 'TVSaleScreen/TVSalesScreen.dart';

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
  String? mobileNo, cDCMDPendSince, settlementPendSince,totalPendingSettSince;
  int? deliveryMenCount,todaysPunchingInNiyojanC,pendingInNiyojanC,pendingInCdcmsC,todaysIncorrectPunchingC,settlPayReceiveDelPendC,settlDelPayPendC,oldBkgPendNewBkgRecv,delDonNiyoJanPunPend,niyoJanPunDelPend, postPaidVerifPend,
      sVPendingStk, tVPendingStk,paymtDoneBtDelPendAmt,delDoneBtPaymtPendAmt,totalPendingSettCnt,totalPendingSettAmt,postPaidVerifPendAmt,UndocumentedSV;
  double? totalAmount,
      totalIncome,
      totalExpense,
      onAccountToday,
      onAccountAsOfDate;

  int? asOfDateImbQtyShow = 0;
  int? todaysImbQtyShow = 0;
  int? cdcmsFilledDiffShow = 0;
  int? cdcmsEmptyDiffShow = 0;
  int? cdcmsDefectiveDiffShow = 0;
  double? filledPercent = 0;
  double? emptyPercent = 0;
  double? defectivePercent = 0;
  int? total = 0;

  int? totalOpeningStockFilled = 0;
  int? totalOpeningStockEmpty = 0;
  int? totalOpeningStockDefective = 0;
  int? totalCurrentStockFilled = 0;
  int? totalCurrentStockEmpty = 0;
  int? totalCurrentStockDefective = 0;



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
    fetchSavedData();

  }
  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    fetchCurrentStock();
    fetchDashboarDetail(); // Fetch the data again
  }

  final List<String> months = ['Apr', 'May', 'Jun', 'Jul', 'Aug'];
  final List<double> income = [190000, 155000, 60000, 15000, 20000];
  final List<double> expenses = [20000, 120000, 10000, 8000, 10000];
  String? formattedDatecdcms;
  String? formattedDate;
  String? totalPendingSettSinceDate;

  @override
  Widget build(BuildContext context) {
    formattedDate = settlementPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(settlementPendSince!))
        : 'No Date'; // You can change 'No Date' to anything if it's null
    formattedDatecdcms = cDCMDPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(cDCMDPendSince!))
        : 'No Date';
    totalPendingSettSinceDate = totalPendingSettSince != null
        ? DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(totalPendingSettSince!))
        : 'No Date';
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures the content is scrollable
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        color: Color(0xFFEFFFFfff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5, bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Card(
                                        color: Color(0xFFEFF2FB),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0,
                                              right: 15,
                                              top: 30,
                                              bottom: 30),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Unsettled Count",
                                                  style: Styling.itemTitleDash,
                                                  textAlign: TextAlign.left,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                Text(
                                                  "(DM Wise)",
                                                  style: Styling.itemBlackTest,
                                                  textAlign: TextAlign.start,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        UnsettledSaleDetailList
                                                            .screenName);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        (deliveryMenCount ?? 0)
                                                            .toString(),
                                                        style: Styling
                                                            .bodyTitleBigBoldDash,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        size: 24,
                                                        // Bigger icon for a more clickable feel
                                                        color: Colors.black54,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Unsettled Amount",
                                                  style: Styling.itemTitleDash,
                                                  textAlign: TextAlign.start,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                // Text("",
                                                //     style: Styling.itemBlackTest,
                                                //     textAlign: TextAlign.start,
                                                //   textScaler: TextScaler.noScaling,),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        UnsettledSaleDetailList
                                                            .screenName);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        formatCurrency(
                                                            totalAmount ?? 0),
                                                        style: Styling
                                                            .bodyTitleBigBoldDash,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        size: 24,
                                                        // Bigger icon for a more clickable feel
                                                        color: Colors.black54,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        Card(
                                            color: Color(0xFFfbe9e9),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showCardWithImbalanceStock(
                                                            context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            todaysImbQtyShow
                                                                .toString(),
                                                            style: Styling
                                                                .bodyTitleBigBoldDash,
                                                            textScaler:
                                                            TextScaler
                                                                .noScaling,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_right_sharp,
                                                            size: 24,
                                                            // Bigger icon for a more clickable feel
                                                            color:
                                                            Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      "Today's Imbalance",
                                                      style:
                                                      Styling.itemTitleDash,
                                                      textAlign: TextAlign.left,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                    ),
                                                  ]),
                                            )),
                                        Card(
                                            color: Color(0xFFfcf2f1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showCardWithImbalanceStock(
                                                            context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            asOfDateImbQtyShow
                                                                .toString(),
                                                            style: Styling
                                                                .bodyTitleBigBoldDash,
                                                            textScaler:
                                                            TextScaler
                                                                .noScaling,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_right_sharp,
                                                            size: 24,
                                                            // Bigger icon for a more clickable feel
                                                            color:
                                                            Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      "Total Imbalance",
                                                      style:
                                                      Styling.itemTitleDash,
                                                      textAlign: TextAlign.left,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                    ),
                                                  ]),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Quick Create",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15),
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              SVSaleReportScreen.screenName);
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(10.0),
                                                child: Icon(
                                                  Icons.discount_outlined,
                                                  size: 26,
                                                  // Bigger icon for a more clickable feel
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "SV Sale",
                                                style: Styling
                                                    .bodyTitleBigBoldDashQuick,
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              TVSalesScreen.screenName);
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(10.0),
                                                child: Icon(
                                                  Icons.receipt_long_outlined,
                                                  size: 26,
                                                  // Bigger icon for a more clickable feel
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "TV Receipt",
                                                style: Styling
                                                    .bodyTitleBigBoldDashQuick,
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              PaymentReceiptScreen.screenName);
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(10.0),
                                                child: Icon(
                                                  Icons.payment,
                                                  size: 26,
                                                  // Bigger icon for a more clickable feel
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "Payment",
                                                style: Styling
                                                    .bodyTitleBigBoldDashQuick,
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              CashHandoverScreen.screenName);
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(10.0),
                                                child: Icon(
                                                  Icons.payments,
                                                  size: 26,
                                                  // Bigger icon for a more clickable feel
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "Cash",
                                                style: Styling
                                                    .bodyTitleBigBoldDashQuick,
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        margin: EdgeInsets.zero,
                        color: Color(0xFFEFFFFfff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5, bottom: 20, top: 15),
                          child: Column(children: [
                            Row(children: [
                              Icon(
                                Icons.bolt_outlined,
                                size: 26,
                                // Bigger icon for a more clickable feel
                                color: Colors.black54,
                              ),
                              Text(
                                "CDCMS Stock Difference",
                                style: Styling.bodyTitleBigBoldDashGrey,
                                textScaler: TextScaler.noScaling,
                              )
                            ]),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfcf2f1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 4)
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showCardWithCDCMSStockDifference(
                                                  context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cdcmsFilledDiffShow
                                                      .toString(),
                                                  // Replace this with your dynamic data
                                                  style: Styling
                                                      .bodyTitleBigBoldDashGrey
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    // Make the text blue like a link
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                    decorationColor:
                                                    Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Filled',
                                                  style: Styling.bodyTitleBig,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfcf2f1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 4)
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showCardWithCDCMSStockDifference(
                                                  context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cdcmsEmptyDiffShow.toString(),
                                                  // Replace this with your dynamic data
                                                  style: Styling
                                                      .bodyTitleBigBoldDashGrey
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    // Make the text blue like a link
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                    decorationColor:
                                                    Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Empty',
                                                  style: Styling.bodyTitleBig,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfcf2f1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 4)
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showCardWithCDCMSStockDifference(
                                                  context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cdcmsDefectiveDiffShow
                                                      .toString(),
                                                  // Replace this with your dynamic data
                                                  style: Styling
                                                      .bodyTitleBigBoldDashGrey
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    // Make the text blue like a link
                                                    decoration: TextDecoration
                                                        .underline,
                                                    // Underline the text
                                                    decorationColor:
                                                    Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Defective',
                                                  style: Styling.bodyTitleBig,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(children: [
                              Icon(
                                Icons.cameraswitch_sharp,
                                size: 20,
                                // Bigger icon for a more clickable feel
                                color: Colors.black54,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Today's Cash Summary",
                                style: Styling.bodyTitleBigBoldDashGrey,
                                textScaler: TextScaler.noScaling,
                              )
                            ]),
                            // SizedBox(height: 30),
                            // SizedBox(
                            //   height: 200,
                            //   child: Container(
                            //     child: AspectRatio(
                            //       aspectRatio: 1.5,
                            //       child: BarChart(
                            //         BarChartData(
                            //           barGroups: _buildBarGroups(),
                            //           titlesData: FlTitlesData(
                            //             leftTitles: AxisTitles(
                            //               sideTitles: SideTitles(
                            //                   showTitles: true,
                            //                   reservedSize: 40),
                            //             ),
                            //             bottomTitles: AxisTitles(
                            //               sideTitles: SideTitles(
                            //                 showTitles: true,
                            //                 getTitlesWidget: (value, meta) {
                            //                   final index = value.toInt();
                            //                   if (index >= 0 &&
                            //                       index < months.length) {
                            //                     return Text(months[index]);
                            //                   } else {
                            //                     return Text('');
                            //                   }
                            //                 },
                            //               ),
                            //             ),
                            //             topTitles: AxisTitles(
                            //                 sideTitles:
                            //                 SideTitles(showTitles: false)),
                            //             rightTitles: AxisTitles(
                            //                 sideTitles:
                            //                 SideTitles(showTitles: false)),
                            //           ),
                            //           borderData: FlBorderData(show: false),
                            //           gridData: FlGridData(show: false),
                            //           barTouchData: BarTouchData(enabled: true),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 20),
                            Container(
                              height: 140,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Today's Income",
                                                style: Styling
                                                    .bodyTitleWithBlueHightDash,
                                                textAlign: TextAlign.left,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .currency_rupee_outlined,
                                                    size: 17,
                                                    // Bigger icon for a more clickable feel
                                                    color: Colors.black54,
                                                  ),
                                                  Text(
                                                    totalIncome != null
                                                        ? formatCurrency(
                                                        totalIncome!)
                                                        : '0',
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  )
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Today's Expenses",
                                                style: Styling
                                                    .bodyTitleWithBlueHightDashOrange,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .currency_rupee_outlined,
                                                    size: 17,
                                                    // Bigger icon for a more clickable feel
                                                    color: Colors.black54,
                                                  ),
                                                  Text(
                                                    totalExpense != null
                                                        ? formatCurrency(
                                                        totalExpense!)
                                                        : '0',
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 140,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      UnsettledSaleDetailList
                                                          .screenName);
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Today's On Account",
                                                        style: Styling
                                                            .bodyTitleWithBlueHightDash,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      // Bigger icon for a more clickable feel
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .currency_rupee_outlined,
                                                    size: 17,
                                                    // Bigger icon for a more clickable feel
                                                    color: Colors.black54,
                                                  ),
                                                  Text(
                                                    onAccountToday != null
                                                        ? formatCurrency(
                                                        onAccountToday!)
                                                        : '0',
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap:
                                                    () {
                                                  Navigator
                                                      .pushNamed(
                                                    context,
                                                    TodaysCashSummaryOnAccountList.screenName,
                                                    arguments: {
                                                      "onAccount": onAccountAsOfDate
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Total On Account",
                                                        style: Styling
                                                            .bodyTitleWithBlueHightDashOrange,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      // Bigger icon for a more clickable feel
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .currency_rupee_outlined,
                                                    size: 17,
                                                    // Bigger icon for a more clickable feel
                                                    color: Colors.black54,
                                                  ),
                                                  Text(
                                                    onAccountAsOfDate != null
                                                        ? formatCurrency(
                                                        onAccountAsOfDate!)
                                                        : '0',
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(children: [
                              Icon(
                                Icons.ac_unit,
                                size: 20,
                                // Bigger icon for a more clickable feel
                                color: Colors.black54,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Punching & Settlement Status",
                                style: Styling.bodyTitleBigBoldDashGrey,
                                textScaler: TextScaler.noScaling,
                              )
                            ]),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  // First Card
                                  child: GestureDetector(
                                    onTap: () {
                                      showBottomSheet(context);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      color: Color(0xFFfbe9e9),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.punch_clock,
                                                  color: Colors.blue, size: 20),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "Prepaid Punching Status",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios,
                                                color: Colors.black38,
                                                size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8), // spacing between the cards
                                Expanded(
                                  // Second Card
                                  child: GestureDetector(
                                    onTap: () {
                                      showBottomSheetPrepaidSettlementStatus(
                                          context);
                                      // showHalfHeightSheetLeftToRight(context);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      color: Color(0xFFfcf2f1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.punch_clock,
                                                  color: Colors.blue, size: 20),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "Prepaid Settlement Status",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios,
                                                color: Colors.black38,
                                                size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        margin: EdgeInsets.zero,
                        color: Color(0xFFEFFFFfff),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5, bottom: 20, top: 15),
                          child: Column(
                            children: [
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Postpaid Verification Status",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.blue, width: 10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 4)
                                  ],
                                ),
                                padding: EdgeInsets.all(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Color(0xFFEFF2FB),
                                        child: const Icon(Icons.pending_actions,
                                            color: Colors.black, size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: (postPaidVerifPend ?? 0) > 0
                                                ? () {
                                              Navigator.pushNamed(
                                                  context,
                                                  DashboardPostPaidVerifPendDetails
                                                      .screenName,
                                                  arguments: {
                                                    "flag": "All",
                                                  });
                                            }
                                                : null,
                                            behavior: HitTestBehavior.opaque,
                                            child: Row(
                                              children: [
                                                Text(
                                                  postPaidVerifPend.toString(),
                                                  // Replace this with your dynamic data
                                                  style: Styling
                                                      .bodyTitleBigBoldDashGrey
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    // Make the text blue like a link
                                                    decoration: TextDecoration
                                                        .underline,
                                                    // Underline the text
                                                    decorationColor:
                                                    Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5.0, right: 5),
                                                  child:
                                                  verticalDividerSmallestRed(),
                                                ),
                                                Text(
                                                  '${postPaidVerifPendAmt?.toStringAsFixed(2)}',
                                                  // Use 'N/A' if cDCMDPendSince is null
                                                  style: Styling
                                                      .bodyTitleBigBoldDashGrey
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    // Make the text blue like a link
                                                    decoration: TextDecoration
                                                        .underline, // Make the text blue like a link
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Postpaid Verification Pending',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Stock Pending Status",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      DashboardSVDetails
                                                          .screenName,
                                                      arguments: {
                                                        "flag": 0,
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "SV",
                                                        style: Styling
                                                            .bodyTitleWithBlueHightDash,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      // Bigger icon for a more clickable feel
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                sVPendingStk.toString(),
                                                style: Styling
                                                    .bodyTitleBigBoldDashGrey,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      DashboardTVDetails
                                                          .screenName,
                                                      arguments: {
                                                        "flag": 0,
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "TV",
                                                        style: Styling
                                                            .bodyTitleWithBlueHightDashOrange,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      // Bigger icon for a more clickable feel
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                tVPendingStk.toString(),
                                                style: Styling
                                                    .bodyTitleBigBoldDashGrey,
                                                textScaler:
                                                TextScaler.noScaling,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Undocumented SV",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 1, color: Color(0xFFfbe9e9)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Color(0xFFfbe9e9),
                                        child: const Icon(Icons.pending_actions,
                                            color: Colors.black, size: 24),
                                      ),
                                      const SizedBox(width: 25),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: (UndocumentedSV ?? 0)! > 0
                                                ? () {
                                              Navigator.pushNamed(context, DashboardUndocumentedDetails.screenName, arguments: {
                                                "flag": 0,
                                              });
                                            }
                                                : null,
                                            behavior: HitTestBehavior.opaque,
                                            child: Text(
                                              UndocumentedSV.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                color: Colors.blue,
                                                // Make the text blue like a link
                                                decoration:
                                                TextDecoration.underline,
                                                // Underline the text
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Pending',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 20, top: 15),
                            child: Column(children: [
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Opening Stock Status",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfbe9e8),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithOpeningStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalOpeningStockFilled
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Filled',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfcf2f1),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithOpeningStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalOpeningStockEmpty
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Empty',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfbe9e8),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithOpeningStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalOpeningStockDefective
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Defective',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Current Stock Status",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfbe9e8),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithCurrentStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalCurrentStockFilled
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Filled',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfcf2f1),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithCurrentStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalCurrentStockEmpty
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Empty',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFFfbe9e8),
                                                width: 10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 4)
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showCardWithCurrentStock(
                                                    context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    totalCurrentStockDefective
                                                        .toString(),
                                                    // Replace this with your dynamic data
                                                    style: Styling
                                                        .bodyTitleBigBoldDashGrey
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      // Make the text blue like a link
                                                      decoration: TextDecoration
                                                          .underline,
                                                      // Underline the text
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Defective',
                                                    style: Styling.bodyTitle,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Inward Stock",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(
                                  children : [
                                    Expanded(
                                      child: InkWell(
                                        onTap : () {
                                          getCurrentStockDetailManager.any((item) =>
                                          item.totalInvoiceCnt! > 0 ||
                                              item.filledEMRCnt! > 0)?
                                          showCardInwardStockFilled(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Filled",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap : (){
                                          getCurrentStockDetailManager
                                              .any((item) => item.emptyTVCnt! > 0)?
                                          showCardInwardStockEmpty(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Empty",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap : () {
                                          getCurrentStockDetailManager
                                              .any((item) => item.defectivCnt! > 0)?
                                          showCardInwardStockDefective(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Defective",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                              SizedBox(height: 30),
                              Row(children: [
                                Icon(
                                  Icons.bolt_outlined,
                                  size: 26,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Outward Stock",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              SizedBox(height: 10),
                              Row(
                                  children : [
                                    Expanded(
                                      child: InkWell(
                                        onTap : () {
                                          getCurrentStockDetailManager.any((item) =>
                                          item.emptyCRDCnt! > 0 ||
                                              item.emptyDefectivCnt! > 0)?
                                          showCardOutwardStockEmpty(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Empty",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap : (){
                                          getCurrentStockDetailManager.any((item) =>
                                          item.sVQty! > 0 ||
                                              item.refillSaleCnt! > 0)?
                                          showCardOutwardStockRefillSale(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Refill Sale",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap : () {
                                          getCurrentStockDetailManager
                                              .any((item) => item.imbalanceCnt! > 0)?
                                          showCardOutwardStockImbalance(context):
                                          showFlushBar(context, Constants.nodataFound);
                                        },
                                        child: Card(
                                          color : Color(0xFFEFF2FB),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:15.0,bottom:15),
                                            child: Text("Imbalance",style: Styling.itemTitleDash,
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                              getCurrentStockDetailManager.any((item) =>
                              item.emptyCRDCnt! > 0 ||
                                  item.emptyDefectivCnt! > 0)
                                  ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 4)
                                  ],
                                ),
                                padding: EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text(
                                        "Empty",
                                        style: Styling
                                            .bodyTitleWithBlueHightDash,
                                        textScaler: TextScaler.noScaling,
                                      )
                                    ]),
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
                                            color: Color(0xFFfbe9e9),
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
                                                    textScaler: TextScaler
                                                        .noScaling,
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
                                                    textScaler: TextScaler
                                                        .noScaling,
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
                                                    textScaler: TextScaler
                                                        .noScaling,
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

                                            final items =
                                            getCurrentStockDetailManager
                                                .where((item) =>
                                            item.emptyCRDCnt! >
                                                0 ||
                                                item.emptyDefectivCnt! >
                                                    0)
                                                .toList()[index];

                                            Color backgroundColor =
                                            (index % 2 == 0)
                                                ? Colors.grey[
                                            300]! // Color for even index (first, third, fifth...)
                                                : Colors
                                                .white70!;
                                            return Container(
                                              color:
                                              backgroundColor,
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
                                                            textScaler:
                                                            TextScaler.noScaling,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                          Text(
                                                            items
                                                                .emptyCRDCnt
                                                                .toString(),
                                                            style: Styling
                                                                .textFormText,
                                                            textAlign:
                                                            TextAlign.center,
                                                            textScaler:
                                                            TextScaler.noScaling,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                          Text(
                                                            items
                                                                .emptyDefectivCnt
                                                                .toString(),
                                                            style: Styling
                                                                .textFormText,
                                                            textAlign:
                                                            TextAlign.center,
                                                            textScaler:
                                                            TextScaler.noScaling,
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
                                    SizedBox(height: 10),
                                  ],
                                ),
                              )
                                  : Container(),
                              getCurrentStockDetailManager.any((item) =>
                              item.sVQty! > 0 ||
                                  item.refillSaleCnt! > 0)
                                  ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 4)
                                  ],
                                ),
                                padding: EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text(
                                        "Refill Sale",
                                        style: Styling
                                            .bodyTitleWithBlueHightDash,
                                        textScaler: TextScaler.noScaling,
                                      )
                                    ]),
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
                                            color: Color(0xFFfbe9e9),
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
                                                    textScaler: TextScaler
                                                        .noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'SV',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign:
                                                    TextAlign.center,
                                                    textScaler: TextScaler
                                                        .noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Refill Sale',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign:
                                                    TextAlign.center,
                                                    textScaler: TextScaler
                                                        .noScaling,
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
                                                  0)
                                              .length,
                                          itemBuilder:
                                              (context, index) {
                                            final items =
                                            getCurrentStockDetailManager
                                                .where((item) =>
                                            item.sVQty! >
                                                0 ||
                                                item.refillSaleCnt! >
                                                    0)
                                                .toList()[index];
                                            // final items =
                                            //     getCurrentStockDetailManager[
                                            //         index];
                                            Color backgroundColor =
                                            (index % 2 == 0)
                                                ? Colors.grey[
                                            300]! // Color for even index (first, third, fifth...)
                                                : Colors
                                                .white70!;
                                            return Container(
                                              color:
                                              backgroundColor,
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
                                                            textScaler:
                                                            TextScaler.noScaling,
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
                                                            textScaler:
                                                            TextScaler.noScaling,
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
                                                            textScaler:
                                                            TextScaler.noScaling,
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
                                    SizedBox(height: 10),
                                  ],
                                ),
                              )
                                  : Container(),
                              getCurrentStockDetailManager
                                  .any((item) => item.imbalanceCnt! > 0)
                                  ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 4)
                                  ],
                                ),
                                padding: EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Text(
                                        "Imbalance",
                                        style: Styling
                                            .bodyTitleWithBlueHightDash,
                                        textScaler: TextScaler.noScaling,
                                      )
                                    ]),
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
                                            color: Color(0xFFfbe9e9),
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
                                                    textScaler: TextScaler
                                                        .noScaling,
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
                                                    textScaler: TextScaler
                                                        .noScaling,
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
                                            final items =
                                            getCurrentStockDetailManager
                                                .where((item) =>
                                            item.imbalanceCnt! >
                                                0)
                                                .toList()[index];
                                            // final items =
                                            //     getCurrentStockDetailManager[
                                            //         index];
                                            Color backgroundColor =
                                            (index % 2 == 0)
                                                ? Colors.grey[
                                            300]! // Color for even index (first, third, fifth...)
                                                : Colors
                                                .white70!;
                                            return Container(
                                              color:
                                              backgroundColor,
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
                                                            textScaler:
                                                            TextScaler.noScaling,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                          Text(
                                                            items
                                                                .imbalanceCnt
                                                                .toString(),
                                                            style: Styling
                                                                .textFormText,
                                                            textAlign:
                                                            TextAlign.center,
                                                            textScaler:
                                                            TextScaler.noScaling,
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
                                  ],
                                ),
                              )
                                  : Container(),
                            ]),
                          )),
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
      String formattedDate = DateFormat('yyyy-MM-dd')
          .format(now); // You can change the format as needed

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
            int asOfDateImbQtys = 0;
            int todayImbCount = 0;
            int cdcmsFilledDiff = 0;
            int cdcmsEmptyDiff = 0;
            int cdcmsDefectiveDiff = 0;

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
              asOfDateImbQtys += (receipt.asOfDateImbQty ?? 0).toInt();
              todayImbCount += (receipt.todayImbQty ?? 0).toInt();
              cdcmsFilledDiff += (receipt.filledDiff ?? 0).toInt();
              cdcmsEmptyDiff += (receipt.emptyDiff ?? 0).toInt();
              cdcmsDefectiveDiff += (receipt.defectiveDiff ?? 0).toInt();
            }
            asOfDateImbQtyShow = asOfDateImbQtys;
            todaysImbQtyShow = todayImbCount;
            cdcmsFilledDiffShow = cdcmsFilledDiff;
            cdcmsEmptyDiffShow = cdcmsEmptyDiff;
            cdcmsDefectiveDiffShow = cdcmsDefectiveDiff;
            total = cdcmsFilledDiff + cdcmsEmptyDiff + cdcmsDefectiveDiff;
            filledPercent = cdcmsFilledDiff / total! * 100;
            emptyPercent = cdcmsEmptyDiff / total! * 100;
            defectivePercent = cdcmsDefectiveDiff / total! * 100;

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
              onAccountToday =
                  getManagerDashboarDetail[0].staffOnAccToday?.toDouble();
              onAccountAsOfDate =
                  getManagerDashboarDetail[0].staffOnAccAsOf?.toDouble();

              todaysPunchingInNiyojanC =
                  getManagerDashboarDetail[0].niyojanPun?.toInt() ?? 0;
              pendingInNiyojanC =
                  getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
              pendingInCdcmsC =
                  getManagerDashboarDetail[0].cDCMSPunPend?.toInt() ?? 0;
              todaysIncorrectPunchingC =
                  getManagerDashboarDetail[0].niyojanDuplicate?.toInt() ?? 0;
              settlPayReceiveDelPendC =
                  getManagerDashboarDetail[0].paymtDoneBtDelPend?.toInt() ?? 0;
              settlDelPayPendC =
                  getManagerDashboarDetail[0].delDoneBtPaymtPend?.toInt() ?? 0;
              oldBkgPendNewBkgRecv =
                  getManagerDashboarDetail[0].oldBkgPendNewBkgRecv?.toInt() ??
                      0;
              delDonNiyoJanPunPend =
                  getManagerDashboarDetail[0].delDonNiyoJanPunPend?.toInt() ??
                      0;
              niyoJanPunDelPend =
                  getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
              postPaidVerifPend =
                  getManagerDashboarDetail[0].postPaidVerifPend?.toInt() ?? 0;
              sVPendingStk =
                  getManagerDashboarDetail[0].sVPendingStk?.toInt() ?? 0;
              tVPendingStk =
                  getManagerDashboarDetail[0].tVPendingStk?.toInt() ?? 0;
              cDCMDPendSince =
                  getManagerDashboarDetail[0].cDCMDPendSince?.toString();
              settlementPendSince =
                  getManagerDashboarDetail[0].settlementPendSince?.toString();
              totalPendingSettSince =
                  getManagerDashboarDetail[0].totalPendingSettSince?.toString();
              paymtDoneBtDelPendAmt =
                  getManagerDashboarDetail[0].paymtDoneBtDelPendAmt?.toInt() ??
                      0;
              delDoneBtPaymtPendAmt =
                  getManagerDashboarDetail[0].delDoneBtPaymtPendAmt?.toInt() ??
                      0;
              totalPendingSettCnt =
                  getManagerDashboarDetail[0].totalPendingSettCnt?.toInt() ?? 0;
              totalPendingSettAmt =
                  getManagerDashboarDetail[0].totalPendingSettAmt?.toInt() ?? 0;
              postPaidVerifPendAmt = getManagerDashboarDetail[0].postPaidVerifPendAmt?.toInt() ?? 0;
              UndocumentedSV = getManagerDashboarDetail[0].UndocumentedSV?.toInt() ?? 0;

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
        if (mounted) {
          // Check if the widget is still mounted
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
    print("Request URL InventoryCurrentStockDtlsForMobDash:");
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
      print("StaffId $addedBy'}");
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

            int totalOpeningStockFilledShow = 0;
            int totalOpeningStockEmptyShow = 0;
            int totalOpeningStockDefectiveShow = 0;
            int totalCurrentStockFilledShow = 0;
            int totalCurrentStockEmptyShow = 0;
            int totalCurrentStockDefectiveShow = 0;

            // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            for (var receipt in getCurrentStockDetailManager) {
              totalOpeningStockFilledShow += (receipt.filledOpeningStk ?? 0)
                  .toInt(); // Corrected summing of imbQty
              totalOpeningStockEmptyShow += (receipt.emptyOpeningStk ?? 0)
                  .toInt(); // Corrected summing of imbQty
              totalOpeningStockDefectiveShow +=
                  (receipt.deffOpeningStk ?? 0).toInt();
              totalCurrentStockFilledShow +=
                  (receipt.filledCurrentStk ?? 0).toInt();
              totalCurrentStockEmptyShow +=
                  (receipt.emptyCurrentStk ?? 0).toInt();
              totalCurrentStockDefectiveShow +=
                  (receipt.deffCurrentStk ?? 0).toInt();
            }
            totalOpeningStockFilled = totalOpeningStockFilledShow;
            totalOpeningStockEmpty = totalOpeningStockEmptyShow;
            totalOpeningStockDefective = totalOpeningStockDefectiveShow;
            totalCurrentStockFilled = totalCurrentStockFilledShow;
            totalCurrentStockEmpty = totalCurrentStockEmptyShow;
            totalCurrentStockDefective = totalCurrentStockDefectiveShow;

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
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String isAlreadyLogin =
      preferences.getString("IsAlreadyLogin").toString();
      debugPrint("isAlreadyLogin$isAlreadyLogin");
      if (isAlreadyLogin == "0" ||
          isAlreadyLogin == null ||
          isAlreadyLogin == "null" ||
          isAlreadyLogin.isEmpty) {
        _showLogoutDialog(context);
      } else {}
    } catch (error) {
      rethrow;
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
          } else {
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text(" Please log in to the application again."),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for confirming logout
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call logout function here
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Helper function to ensure data is valid
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(months.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: income[index] / 1000,
            color: Colors.blue,
            width: 8,
            borderRadius: BorderRadius.circular(0),
          ),
          BarChartRodData(
            toY: expenses[index] / 1000,
            color: Colors.orange,
            width: 8,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: 4,
      );
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Prepaid Punching Status",
                    style: Styling.bodyTitleWithBlueHightDashOrange,
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: _buildCard(
                          todaysPunchingInNiyojanC.toString(),
                          "Today's Niyojan Punched",
                          const Color(0xFFFFFFFF),
                          onTap: () {
                            todaysPunchingInNiyojanC! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "Punching"},
                            ):
                            null;
                            debugPrint("Rejected Entries tapped");
                          },
                        )
                    ),
                    Expanded(
                        child: _buildCard(
                          todaysIncorrectPunchingC.toString(),
                          "Today's incorrect",
                          const Color(0xFFEFF2FB),
                          onTap: () {
                            todaysIncorrectPunchingC! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "Incorrect"},
                            ):null;
                            debugPrint("Rejected Entries tapperyryd");
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                        child: _buildCard(
                          pendingInCdcmsC.toString(),
                          "Since ($formattedDatecdcms) Pending in cDCMS",
                          const Color(0xFFEFF2FB),
                          onTap: () {
                            debugPrint("Rejected Entries yryry");
                            pendingInCdcmsC! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "cDCMS"},
                            ):null;
                          },
                        )),
                    Expanded(
                        child: _buildCard(
                          oldBkgPendNewBkgRecv.toString(),
                          "Old punching pending in Niyojan but new booking is received",
                          const Color(0xFFFFFFFF),
                          onTap: () {
                            debugPrint("Rejected Entries tryapped");
                            oldBkgPendNewBkgRecv! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "OldBkgPendNewBkgRecv"},
                            ):null;
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                        child: _buildCard(
                          delDonNiyoJanPunPend.toString(),
                          "Punched in cDCMS, pending in Niyojan",
                          const Color(0xFFFFFFFF),
                          onTap: () {
                            debugPrint("Rejected Entries yryrytapped");
                            delDonNiyoJanPunPend! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "DelDonNiyoJanPunPend"},
                            ):null;
                          },
                        )),
                    Expanded(
                        child: _buildCard(
                          niyoJanPunDelPend.toString(),
                          "Punched in Niyojan, pending in cDCMS",
                          const Color(0xFFEFF2FB),
                          onTap: () {
                            debugPrint("Rejected Entrigrretes tapped");
                            niyoJanPunDelPend! > 0?
                            Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "NiyoJanPunDelPend"},
                            ):null;
                          },
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheetPrepaidSettlementStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Prepaid Settlement Status (Data ref. cDCMS)",
                    style: Styling.bodyTitleWithBlueHightDashOrange,
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: settlPayReceiveDelPendC! > 0
                                      ? () {
                                    Navigator.pushNamed(
                                        context,
                                        DashboardPrepaidDetails
                                            .screenName,
                                        arguments: {
                                          "flag": "Settled",
                                        });
                                  }
                                      : null,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        settlPayReceiveDelPendC.toString(),
                                        // Replace this with your dynamic data
                                        style: Styling.countNumber.copyWith(
                                          color: Colors.blue,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        paymtDoneBtDelPendAmt!
                                            .toStringAsFixed(2),
                                        // Replace this with your dynamic data
                                        style: Styling.countNumber.copyWith(
                                          color: Colors
                                              .black, // Make the text blue like a link
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Payment done, delivery pending",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: settlDelPayPendC! > 0
                                      ? () {
                                    Navigator.pushNamed(
                                        context,
                                        DashboardPrepaidDetails
                                            .screenName,
                                        arguments: {
                                          "flag": "Delivered",
                                        });
                                  }
                                      : null,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${settlDelPayPendC.toString()}',
                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          color: Colors.blue,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor:
                                          Colors.blue, // Underline color
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        '${delDoneBtPaymtPendAmt?.toStringAsFixed(2)}',
                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          color: Colors
                                              .black, // Make the text blue like a link
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  //print('cDCMDPendSince value: $cDCMDPendSince');
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Since ($formattedDate) Delivered, payment pending",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: totalPendingSettCnt! > 0
                                      ? () {
                                    Navigator.pushNamed(
                                        context,
                                        DashboardPrepaidDetails
                                            .screenName,
                                        arguments: {
                                          "flag": "TotalOutstanding",
                                        });
                                  }
                                      : null,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${totalPendingSettCnt.toString()}',
                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          color: Colors.blue,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor:
                                          Colors.blue, // Underline color
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        '${totalPendingSettAmt?.toStringAsFixed(2)}',
                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          color: Colors
                                              .black, // Make the text blue like a link
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Since ($totalPendingSettSinceDate)Total Outstanding Pending",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String count, String title, Color bgColor,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          color: bgColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text(
                  count,
                  style: Styling.bodyTitleWithBlueHightDash.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCardWithCDCMSStockDifference(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Item Wise CDCMS Stock Difference',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Display dynamic data or No Data Available message
                    getManagerDashboarDetail.isNotEmpty
                        ? Column(
                      children: [
                        // Table Header with modern styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFfbe9e9)!,
                                Color(0xFFfbe9e9)!
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              buildTableHeader('Item Name'),
                              buildTableHeader('Filled'),
                              buildTableHeader('Empty'),
                              buildTableHeader('Defective'),
                            ],
                          ),
                        ),

                        // List of Items with dynamic rows
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: getManagerDashboarDetail
                              .where((item) =>
                          item.filledDiff! > 0 ||
                              item.emptyDiff! > 0 ||
                              item.defectiveDiff! > 0)
                              .length,
                          itemBuilder: (context, index) {
                            final items = getManagerDashboarDetail
                                .where((item) =>
                            item.filledDiff! > 0 ||
                                item.emptyDiff! > 0 ||
                                item.defectiveDiff! > 0)
                                .toList()[index];

                            // Alternate row color logic
                            Color backgroundColor = index % 2 == 0
                                ? Color(0xFFEFF2FB)!
                                : Colors.white;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0),
                              child: MouseRegion(
                                onEnter: (_) {},
                                onExit: (_) {},
                                child: Container(
                                  color: backgroundColor,
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      buildTableCell(
                                          items.itemName ?? 'Unknown'),
                                      buildTableCell(
                                          items.filledDiff.toString()),
                                      buildTableCell(
                                          items.emptyDiff.toString()),
                                      buildTableCell(
                                          items.defectiveDiff.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                        : Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
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
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget buildTableCell(String content) {
    return Expanded(
      child: Text(
        content,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableHeader(String title) {
    return Expanded(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void showCardWithImbalanceStock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // 70% of screen height
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_outlined, // Icon for warning
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Imbalance Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Display dynamic data or No Data Available message
                    getManagerDashboarDetail.isNotEmpty
                        ? Column(
                      children: [
                        // Table Header with gradient and modern styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[200]!,
                                Colors.blue[50]!
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              buildTableHeader('Item Name'),
                              buildTableHeader('Today\'s Imb Qty'),
                              buildTableHeader('As Of Imb Qty'),
                            ],
                          ),
                        ),

                        // Use ListView to make the content scrollable
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: getManagerDashboarDetail
                              .where((item) =>
                          item.todayImbQty! > 0 ||
                              item.asOfDateImbQty! > 0)
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            var item = getManagerDashboarDetail
                                .where((item) =>
                            item.todayImbQty! > 0 ||
                                item.asOfDateImbQty! > 0)
                                .toList()[index];

                            // Alternate row color logic
                            Color backgroundColor = index % 2 == 0
                                ? Color(0xFFEFF2FB)
                                : Colors.white;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0),
                              child: Container(
                                color: backgroundColor,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    // Non-clickable itemName
                                    Expanded(
                                      child: Text(
                                        item.itemName ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    // Today Imbalance Quantity - styled with blue color and underline
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          print(
                                              'Tapped on today imbalance qty: ${item.todayImbQty}');
                                          // Navigate to ImbalanceCountClickUI, passing ItemId and imbQtyType
                                          Navigator.pushNamed(
                                            context,
                                            ImbalanceCountClickUI
                                                .screenName,
                                            arguments: {
                                              "ItemId": item.itemId,
                                              "imbQtyType": 'today'
                                            },
                                          );
                                        },
                                        child: Text(
                                          item.todayImbQty.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            // Blue text color
                                            decoration:
                                            TextDecoration.underline,
                                            // Underline the text
                                            decorationColor: Colors
                                                .blue, // Set underline color to blue
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),

                                    // As of Date Imbalance Quantity - styled with blue color and underline
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          print(
                                              'Tapped on as of date imbalance qty: ${item.asOfDateImbQty}');
                                          // Navigate to ImbalanceCountClickUI, passing ItemId and imbQtyType
                                          Navigator.pushNamed(
                                            context,
                                            ImbalanceCountClickUI
                                                .screenName,
                                            arguments: {
                                              "ItemId": item.itemId,
                                              "imbQtyType": 'asOfDate'
                                            },
                                          );
                                        },
                                        child: Text(
                                          item.asOfDateImbQty.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            // Blue text color
                                            decoration:
                                            TextDecoration.underline,
                                            // Underline the text
                                            decorationColor: Colors
                                                .blue, // Set underline color to blue
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                        : Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
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
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1), // Start from the bottom of the screen
          end: Offset.zero, // Move to original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardWithOpeningStock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.business_center, // Icon for warning
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Opening Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Display dynamic data or No Data Available message
                    getCurrentStockDetailManager.isNotEmpty
                        ? Column(
                      children: [
                        // Table Header with gradient and modern styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink[200]!,
                                Colors.pink[50]!
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              buildTableHeader('Item Name'),
                              buildTableHeader('Filled'),
                              buildTableHeader('Empty'),
                              buildTableHeader('Defective'),
                            ],
                          ),
                        ),

                        // Use ListView to make the content scrollable
                        ListView.builder(
                          shrinkWrap: true,
                          // Prevents the ListView from taking infinite space
                          physics: NeverScrollableScrollPhysics(),
                          // Disables internal scrolling
                          itemCount: getCurrentStockDetailManager
                              .where((item) =>
                          item.filledOpeningStk! > 0 ||
                              item.emptyOpeningStk! > 0 ||
                              item.deffOpeningStk! > 0)
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            var item = getCurrentStockDetailManager
                                .where((item) =>
                            item.filledOpeningStk! > 0 ||
                                item.emptyOpeningStk! > 0 ||
                                item.deffOpeningStk! > 0)
                                .toList()[index];

                            // Alternate row color logic
                            Color backgroundColor = index % 2 == 0
                                ? Color(0xFFfcf2f1)
                                : Colors.white;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0),
                              child: Container(
                                color: backgroundColor,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    buildTableCell(
                                        item.itemName ?? 'Unknown'),
                                    buildTableCell(
                                        item.filledOpeningStk.toString()),
                                    buildTableCell(
                                        item.emptyOpeningStk.toString()),
                                    buildTableCell(
                                        item.deffOpeningStk.toString()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                        : Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
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
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1), // Start from the bottom of the screen
          end: Offset.zero, // Move to the original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardWithCurrentStock(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // 70% of screen height
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.store, // Icon for warning
                            size: 20,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Current Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Display dynamic data or No Data Available message
                    getCurrentStockDetailManager.isNotEmpty
                        ? Column(
                      children: [
                        // Table Header with gradient and modern styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue[200]!,
                                Colors.blue[50]!
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              buildTableHeader('Item Name'),
                              buildTableHeader('Filled'),
                              buildTableHeader('Empty'),
                              buildTableHeader('Defective'),
                            ],
                          ),
                        ),

                        // Use ListView to make the content scrollable
                        ListView.builder(
                          shrinkWrap: true,
                          // Prevents the ListView from taking infinite space
                          physics: NeverScrollableScrollPhysics(),
                          // Disables internal scrolling
                          itemCount: getCurrentStockDetailManager
                              .where((item) =>
                          item.filledCurrentStk! > 0 ||
                              item.emptyCurrentStk! > 0 ||
                              item.deffCurrentStk! > 0)
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            var item = getCurrentStockDetailManager
                                .where((item) =>
                            item.filledCurrentStk! > 0 ||
                                item.emptyCurrentStk! > 0 ||
                                item.deffCurrentStk! > 0)
                                .toList()[index];

                            // Alternate row color logic
                            Color backgroundColor = index % 2 == 0
                                ? Color(0xFFEFF2FB)
                                : Colors.white;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0),
                              child: Container(
                                color: backgroundColor,
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    buildTableCell(
                                        item.itemName ?? 'Unknown'),
                                    buildTableCell(
                                        item.filledCurrentStk.toString()),
                                    buildTableCell(
                                        item.emptyCurrentStk.toString()),
                                    buildTableCell(
                                        item.deffCurrentStk.toString()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                        : Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 10),
                            Text(
                              'No Data Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
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
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1), // Start from the bottom of the screen
          end: Offset.zero, // Move to the original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardInwardStockFilled(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Filled Inward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    getCurrentStockDetailManager.any((item) =>
                    item.totalInvoiceCnt! > 0 ||
                        item.filledEMRCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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

                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.totalInvoiceCnt! >
                                  0 ||
                                  item.filledEMRCnt! >
                                      0)
                                  .toList()[index];

                              Color backgroundColor =
                              (index % 2 == 0)
                                  ? Color(
                                  0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .totalInvoiceCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .filledEMRCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardInwardStockEmpty(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Empty Inward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    getCurrentStockDetailManager
                        .any((item) => item.emptyTVCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
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
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'TV',
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      textAlign:
                                      TextAlign.center,
                                      textScaler: TextScaler
                                          .noScaling,
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

                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.emptyTVCnt! >
                                  0)
                                  .toList()[index];

                              Color backgroundColor =
                              (index % 2 == 1)
                                  ? Color(
                                  0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
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
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardInwardStockDefective(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Defective Inward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    getCurrentStockDetailManager
                        .any((item) => item.defectivCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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

                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.defectivCnt! >
                                  0)
                                  .toList()[index];

                              Color backgroundColor =
                              (index % 2 == 1)
                                  ? Color(
                                  0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .defectivCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(items.defectivFromDate.toString() ??
                                                  '')),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardOutwardStockEmpty(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Empty Outward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    getCurrentStockDetailManager.any((item) =>
                    item.emptyCRDCnt! > 0 ||
                        item.emptyDefectivCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
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
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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

                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.emptyCRDCnt! >
                                  0 ||
                                  item.emptyDefectivCnt! >
                                      0)
                                  .toList()[index];

                              Color backgroundColor =
                              (index % 2 == 0)
                                  ? Colors.grey[
                              300]! // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .emptyCRDCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .emptyDefectivCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardOutwardStockRefillSale(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and a subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Refill Sale Outward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    getCurrentStockDetailManager.any((item) =>
                    item.sVQty! > 0 ||
                        item.refillSaleCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
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
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'SV',
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      textAlign:
                                      TextAlign.center,
                                      textScaler: TextScaler
                                          .noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Refill Sale',
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      textAlign:
                                      TextAlign.center,
                                      textScaler: TextScaler
                                          .noScaling,
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
                                    0)
                                .length,
                            itemBuilder:
                                (context, index) {
                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.sVQty! >
                                  0 ||
                                  item.refillSaleCnt! >
                                      0)
                                  .toList()[index];
                              // final items =
                              //     getCurrentStockDetailManager[
                              //         index];
                              Color backgroundColor =
                              (index % 2 == 0)
                                  ? Colors.grey[
                              300]! // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
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
                                              textScaler:
                                              TextScaler.noScaling,
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
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void showCardOutwardStockImbalance(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 300) {
                Navigator.pop(context); // Close if swipe velocity is high
              }
            },
            child: Container(
              height:
              MediaQuery.of(context).size.height * 0.7, // Half-height sheet
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            'Imbalance Outward Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    getCurrentStockDetailManager
                        .any((item) => item.imbalanceCnt! > 0)
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4)
                        ],
                      ),
                      padding: EdgeInsets.all(4),
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
                              color: Color(0xFFfbe9e9),
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                                      textScaler: TextScaler
                                          .noScaling,
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
                              final items =
                              getCurrentStockDetailManager
                                  .where((item) =>
                              item.imbalanceCnt! >
                                  0)
                                  .toList()[index];
                              // final items =
                              //     getCurrentStockDetailManager[
                              //         index];
                              Color backgroundColor =
                              (index % 2 == 0)
                                  ? Colors.grey[
                              300]! // Color for even index (first, third, fifth...)
                                  : Colors
                                  .white70!;
                              return Container(
                                color:
                                backgroundColor,
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
                                              textScaler:
                                              TextScaler.noScaling,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child:
                                            Text(
                                              items
                                                  .imbalanceCnt
                                                  .toString(),
                                              style: Styling
                                                  .textFormText,
                                              textAlign:
                                              TextAlign.center,
                                              textScaler:
                                              TextScaler.noScaling,
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
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // From left side
          end: Offset.zero, // To original position
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
