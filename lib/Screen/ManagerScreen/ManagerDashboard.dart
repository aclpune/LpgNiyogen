import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../IOSVersionUpdateService.dart';
import '../PushNotification/NotificationApiHelper.dart';
import '../PushNotification/NotificationService.dart';
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
import 'ClickModelClass/HeadWiseExpenseLstModel.dart';
import 'DashboardItemClickUI/ARBProfitDetailScreenUi.dart';
import 'DashboardItemClickUI/CreditSaleCountDetailListUI.dart';
import 'DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
import 'DashboardItemClickUI/DashboardPrepaidDetails.dart';
import 'DashboardItemClickUI/DashboardSVDetails.dart';
import 'DashboardItemClickUI/DashboardTVDetails.dart';
import 'DashboardItemClickUI/ImbalanceCountClickUI.dart';
import 'DashboardItemClickUI/PrepaidBookingAndSettlementGraphScreen.dart';
import 'DashboardItemClickUI/RefillProfitDetailScreenUi.dart';
import 'DashboardItemClickUI/SVProfitdetailScreenUi.dart';
import 'DashboardItemClickUI/TodaysCashSummaryOnAccountList.dart';
import 'DashboardItemClickUI/UnsettledSaleDetailList.dart';
import 'DashboardItemClickUI/VendorPaymentDetailListUI.dart';
import 'ExpensesScreen/ExpensesScreenUI.dart';
import 'ExpensesScreen/SalesComparisonScreen.dart';
import 'GetDashPunchSummaryCntModel.dart';
import 'ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'ManagerModelClass/GetDashSummaryAllCountForMgrModel.dart';
import 'ManagerModelClass/GetDashSummaryItemWiseForMgrModel.dart';
import 'ManagerModelClass/GetDashSummarySettAllCountForMgrModel.dart';
import 'ManagerModelClass/GetManagerDashboarDetailModel.dart';

import 'ManagerModelClass/GetSVARBManagerDashboardCountModel.dart';
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
  // List<GetManagerDashboarDetailModel> getManagerDashboarDetail = [];
  List<GetDashSummaryItemWiseForMgrModel> getManagerDashboarDetailItemWise = [];
  List<GetDashSummaryAllCountForMgrModel> getManagerDashboarDetailAllCount = [];
  List<GetDashSummarySettAllCountForMgrModel> getManagerDashboarDetailSettCount = [];
  List<GetCurrentStockDetailManagerModel> getCurrentStockDetailManager = [];
  List<GetDashPunchSummaryCntModel> getDashPunchSummaryCntModel = [];
  List<String> getTransMode = ["Today's", "This Month","Financial Year"];
  String? selectedTransMode = "This Month";
  String? dayFlag = "THISMONTH";
  bool isLoading = true;
  String? mobileNo, cDCMDPendSince, settlementPendSince, totalPendingSettSince;
  int? deliveryMenCount,
      todaysPunchingInNiyojanC,
      pendingInNiyojanC,
      pendingInCdcmsC,
      todaysIncorrectPunchingC,
      settlPayReceiveDelPendC,
      settlDelPayPendC,
      oldBkgPendNewBkgRecv,
      delDonNiyoJanPunPend,
      niyoJanPunDelPend,
      postPaidVerifPend,
      sVPendingStk,
      tVPendingStk,
      paymtDoneBtDelPendAmt,
      delDoneBtPaymtPendAmt,
      totalPendingSettCnt,
      totalPendingSettAmt,
      postPaidVerifPendAmt,
      UndocumentedSV,
      TotalCrdtOutstd,
      TotalVendorDueAmt;
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
  int? selectedItemId;
  int? selectedItemIdCDCMS;
  List<GetSvarbManagerDashboardCountModel> svarbManagerDashboardCountModel = [];
  List<HeadWiseExpenseLstModel> expenseReportModel = [];
  double? svGrossRevenueCount = 0;
  double? arbGrossRevenueCount = 0;
  double? arbGrossProfitCount = 0;
  double? refillGrossRevenueCount = 0;
  double? refillGrossProfitCount = 0;
  double? totalGrossProfit = 0;
  double? totalExpenseForProfit = 0;
  double? incomeProfit = 0;
  bool isOn = true;
  bool isOnBook = true;

  String formatIndianCurrency(num value) {
    if (value >= 10000000) {
      return '${(value / 10000000).floor()}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).floor()}L';
    } else if (value >= 1000) {
      return '${(value / 1000).floor()}k';
    } else {
      return value.floor().toString();
    }
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    getUserDetail();
    NotificationService.init();


    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    listenForegroundMessages();

    setupNotifications(); // ✅ async flow
    if (Platform.isAndroid) {
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    } else {
      IosVersionUpdateCheck().checkForUpdate(context);

    }
    debugPrint("ManagerDashboardScreen: initState called");
    // fetchDashboarDetail();
    fetchDashboarDetailForSettItem();
    fetchDashboarDetailItemWise();
    fetchDashboarDetailForAllCount();
    fetchCurrentStock();
    fetchSavedData();
    fetchSVARBFilterCountList("THISMONTH");
    getDashPunchSummaryCntModeldata();
  }

  Future<void> _onRefresh() async {
    fetchCurrentStock();
    // fetchDashboarDetail();
    fetchDashboarDetailItemWise();
    fetchDashboarDetailForAllCount();
    fetchDashboarDetailForSettItem();
    if(selectedTransMode == "Today's"){
      dayFlag = "TODAYS";
      debugPrint("dayFlag $dayFlag");
      fetchSVARBFilterCountList(dayFlag!);
    }else if(selectedTransMode == "This Month"){
      dayFlag = "THISMONTH";
      debugPrint("dayFlag $dayFlag");
      fetchSVARBFilterCountList(dayFlag!);
    }else if(selectedTransMode == "Financial Year"){
      dayFlag = "FINYEAR";
      debugPrint("dayFlag $dayFlag");
      fetchSVARBFilterCountList(dayFlag!);
    }else{
      dayFlag = "";
    }

  }

  final List<String> months = ['Apr', 'May', 'Jun', 'Jul', 'Aug'];
  final List<double> income = [190000, 155000, 60000, 15000, 20000];
  final List<double> expenses = [20000, 120000, 10000, 8000, 10000];
  String? formattedDatecdcms;
  String? formattedDate;
  String? totalPendingSettSinceDate;
  String? roleId, isUserActive,userActivet;
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
    final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
    return
      Scaffold(
        key: _scaffoldKey,
        body:
        RefreshIndicator(
          onRefresh: _onRefresh,
          child:
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                left: 5.0, right: 5,  top: 10),
                            child: Column(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: MediaQuery.of(context).size.width > 600
                                        ? 7
                                        : 12,
                                    child: Container(
                                      height: 260,
                                      child: Card(
                                        color: Color(0xFFEFF2FB),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: MediaQuery.of(context)
                                              .size
                                              .width >
                                              600
                                              ? const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 5,
                                              bottom: 30)
                                              : const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 15), // Adjust padding
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              // Main heading
                                              Text(
                                                "Prepaid Status",
                                                style: Styling.itemTitleDash,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 15),
                                              // Punching row
                                              InkWell(
                                                onTap: () {
                                                  showBottomSheet(context);
                                                },
                                                child: Text(
                                                  "Today's Punched",
                                                  style:
                                                  Styling.itemBlackTestTwoo,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showBottomSheet(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (todaysPunchingInNiyojanC ??
                                                          0)
                                                          .toString(),
                                                      style: Styling
                                                          .bodyTitleBigBoldDashtwo,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              // Settled row
                                              InkWell(
                                                onTap: () {
                                                  showBottomSheetPrepaidSettlementStatus(
                                                      context);
                                                },
                                                child: Text(
                                                  "Outstanding\nSettlement",
                                                  style:
                                                  Styling.itemBlackTestTwoo,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showBottomSheetPrepaidSettlementStatus(
                                                      context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        formatCurrency(
                                                            totalPendAmount),
                                                        style: Styling
                                                            .bodyTitleBigBoldDashtwo,
                                                        textScaler:
                                                        TextScaler.noScaling,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: MediaQuery.of(context).size.width > 600
                                        ? 5
                                        : 8,
                                    child: Column(
                                      children: [
                                        // SV Card
                                        Container(
                                          height: 130,
                                          child: Card(
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
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          totalIncome != null
                                                              ? formatIndianCurrency(
                                                              totalIncome!)
                                                              : '0',
                                                          style: Styling
                                                              .bodyTitleBigBoldDashGrey,
                                                          textScaler: TextScaler
                                                              .noScaling,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "Today's Revenue",
                                                    style:
                                                    Styling.countNumberReds,
                                                    textAlign: TextAlign.left,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // TV Card
                                        Container(
                                          height: 130,
                                          child: Card(
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
                                              child: InkWell(
                                                  onTap: () {
                                                    roleId == Constants.roleIdOwner?
                                                      Navigator.pushNamed(context, ExpensesScreenUI.screenName):null;
                                                },
                                                child:
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            totalExpense != null
                                                                ? formatIndianCurrency(
                                                                totalExpense!)
                                                                : '0',
                                                            style: Styling
                                                                .bodyTitleBigBoldDashGrey,
                                                            textScaler: TextScaler
                                                                .noScaling,
                                                          ),
                                                          roleId == Constants.roleIdOwner?
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_right_sharp,
                                                            size: 24,
                                                            color: Colors.black54,
                                                          ):Container(),
                                                        ],
                                                      ),
                                                    InkWell(
                                                        onTap: () {
                                                          roleId == Constants.roleIdOwner?
                                                          Navigator.pushNamed(context, ExpensesScreenUI.screenName):null;                                                      },
                                                      child: Text(
                                                        "Today's Expenses",
                                                        style:
                                                        Styling.countNumberReds,
                                                        textAlign: TextAlign.left,
                                                        textScaler:
                                                        TextScaler.noScaling,
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
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(children: [
                                    Icon(
                                      Icons.bolt_outlined,
                                      size: 26,
                                      // Bigger icon for a more clickable feel
                                      color: Colors.black54,
                                    ),
                                    Text(
                                      "Credit Sale",
                                      style: Styling.bodyTitleBigBoldDashGrey,
                                      textScaler: TextScaler.noScaling,
                                    )
                                  ]),
                                  SizedBox(height: 5),
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
                                            child: const Icon(
                                                Icons.pending_actions,
                                                color: Colors.black,
                                                size: 24),
                                          ),
                                          const SizedBox(width: 25),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (TotalCrdtOutstd ?? 0)! > 0
                                                    ? () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      CreditSaleCountDetailListUI
                                                          .screenName);
                                                }
                                                    : null,
                                                behavior: HitTestBehavior.opaque,
                                                child: Text(
                                                  formatCurrency(TotalCrdtOutstd
                                                      ?.toDouble() ??
                                                      0.0),
                                                  style: Styling.itemGreyTextBig
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    decoration:
                                                    TextDecoration.underline,
                                                    decorationColor: Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Pending Amt.',
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
                                  SizedBox(height: 5),
                                  Row(children: [
                                    Icon(
                                      Icons.bolt_outlined,
                                      size: 26,
                                      // Bigger icon for a more clickable feel
                                      color: Colors.black54,
                                    ),
                                    Text(
                                      "Vendor Payment",
                                      style: Styling.bodyTitleBigBoldDashGrey,
                                      textScaler: TextScaler.noScaling,
                                    )
                                  ]),
                                  SizedBox(height: 5),
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
                                            child: const Icon(
                                                Icons.pending_actions,
                                                color: Colors.black,
                                                size: 24),
                                          ),
                                          const SizedBox(width: 25),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: (TotalCrdtOutstd ?? 0)! > 0
                                                    ? () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      VendorPaymentDetailListUI
                                                          .screenName);
                                                }
                                                    : null,
                                                behavior: HitTestBehavior.opaque,
                                                child: Text(
                                                  formatCurrency(TotalVendorDueAmt
                                                      ?.toDouble() ??
                                                      0.0),
                                                  style: Styling.itemGreyTextBig
                                                      .copyWith(
                                                    color: Colors.blue,
                                                    decoration:
                                                    TextDecoration.underline,
                                                    decorationColor: Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Vendor Due Amt.',
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
                                  SizedBox(height: 5),
                                  Row(children: [
                                    Icon(
                                      Icons.bolt_outlined,
                                      size: 26,
                                      // Bigger icon for a more clickable feel
                                      color: Colors.black54,
                                    ),
                                    Text(
                                      "Imbalance Stock",
                                      style: Styling.bodyTitleBigBoldDashGrey,
                                      textScaler: TextScaler.noScaling,
                                    )
                                  ]),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      // First Container
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          height: 100,
                                          child: Card(
                                            color: Color(0xFFEFF2FB),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                              .bodyTitleBigBold
                                                              .copyWith(
                                                              fontSize: 18),
                                                          textScaler: TextScaler
                                                              .noScaling,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_right_sharp,
                                                          size: 26,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Today's Imbalance",
                                                    style: Styling.itemTitleDash
                                                        .copyWith(fontSize: 16),
                                                    textAlign: TextAlign.left,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Second Container
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          height: 100,
                                          child: Card(
                                            color: Color(0xFFEFF2FB),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                              .bodyTitleBigBold
                                                              .copyWith(
                                                              fontSize: 18),
                                                          textScaler: TextScaler
                                                              .noScaling,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_right_sharp,
                                                          size: 26,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Total Imbalance",
                                                    style: Styling.itemTitleDash
                                                        .copyWith(fontSize: 16),
                                                    textAlign: TextAlign.left,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bolt_outlined,
                                          size: 26,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          "Stock Difference",
                                          style: Styling.bodyTitleBigBoldDashGrey,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    DropdownButton<num>(
                                      value: selectedItemIdCDCMS,
                                      items: getManagerDashboarDetailItemWise.map((item) {
                                        return DropdownMenuItem<num>(
                                          value: item.itemId,
                                          child: Text(item.itemName ?? 'Unknown',
                                              style:
                                              Styling.itemBlackTestSmallReport),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedItemIdCDCMS = value!.toInt();
                                          final selectedItem =
                                          getManagerDashboarDetailItemWise.firstWhere(
                                                (item) =>
                                            item.itemId ==
                                                selectedItemIdCDCMS,
                                            orElse: () =>
                                                GetDashSummaryItemWiseForMgrModel(),
                                          );
                                          cdcmsFilledDiffShow =
                                              selectedItem.filledDiff!.toInt();
                                          cdcmsEmptyDiffShow =
                                              selectedItem.emptyDiff!.toInt();
                                          cdcmsDefectiveDiffShow =
                                              selectedItem.defectiveDiff!.toInt();
                                        });
                                      },
                                    ),
                                  ]),
                              SizedBox(height: 5),
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cdcmsFilledDiffShow.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Filled',
                                              style: Styling.bodyTitleBig,
                                              textScaler: TextScaler.noScaling,
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cdcmsEmptyDiffShow.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Empty',
                                              style: Styling.bodyTitleBig,
                                              textScaler: TextScaler.noScaling,
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cdcmsDefectiveDiffShow.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                decorationColor: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Defective',
                                              style: Styling.bodyTitleBig,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:5),
                              Row(children: [
                                Icon(
                                  Icons.cameraswitch_sharp,
                                  size: 20,
                                  // Bigger icon for a more clickable feel
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "On Account",
                                  style: Styling.bodyTitleBigBoldDashGrey,
                                  textScaler: TextScaler.noScaling,
                                )
                              ]),
                              Container(
                                height: 145,
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
                                                      TodaysCashSummaryOnAccountList
                                                          .screenName,
                                                      arguments: {
                                                        "onAccount":
                                                        onAccountAsOfDate
                                                      },
                                                    );
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
                                                          .bodyTitleBigBoldDashGreyOne,
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
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      TodaysCashSummaryOnAccountList
                                                          .screenName,
                                                      arguments: {
                                                        "onAccount":
                                                        onAccountAsOfDate
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
                                                          .bodyTitleBigBoldDashGreyOne,
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
                            ]),
                          ),
                        ),
                        SizedBox(height: 15),
                        Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0, right: 5,),
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
                                    "Stock Pending Status",
                                    style: Styling.bodyTitleBigBoldDashGrey,
                                    textScaler: TextScaler.noScaling,
                                  )
                                ]),
                                SizedBox(height: 5),
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
                                                    sVPendingStk != null? sVPendingStk.toString():'0' ,
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
                                                    tVPendingStk != null? tVPendingStk.toString() :'0',
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
                                SizedBox(height: 5),

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
                                SizedBox(height: 5),
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
                                                Navigator.pushNamed(
                                                    context,
                                                    DashboardUndocumentedDetails
                                                        .screenName,
                                                    arguments: {
                                                      "flag": 0,
                                                    });
                                              }
                                                  : null,
                                              behavior: HitTestBehavior.opaque,
                                              child: Text(
                                                  UndocumentedSV != null? UndocumentedSV.toString():'0',
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
                                SizedBox(height: 5),
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
                                SizedBox(height: 5),
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
                                                  postPaidVerifPend != null? postPaidVerifPend.toString():'0',

                                                    // Replace this with your dynamic data
                                                    style: Styling.itemGreyTextBig
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                      Colors.blue,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0, right: 5),
                                                    child:
                                                    verticalDividerSmallestRed(),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    formatCurrency(
                                                        postPaidVerifPendAmt
                                                            ?.toDouble() ??
                                                            0.0),
                                                    style: Styling.itemGreyTextBig
                                                        .copyWith(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                      Colors.blue,
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
                                SizedBox(height: 5),
                                //SizedBox(height: 20),
                                Row(children: [
                                  Icon(
                                    Icons.bolt_outlined,
                                    size: 26,
                                    // Bigger icon for a more clickable feel
                                    color: Colors.black54,
                                  ),
                                  Text(
                                    "Unsettled Sale",
                                    style: Styling.bodyTitleBigBoldDashGrey,
                                    textScaler: TextScaler.noScaling,
                                  )
                                ]),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        height: 100,
                                        width: 110,
                                        child: Card(
                                          color: Colors.white,
                                          child: Padding(
                                            // padding: const EdgeInsets.all(14.0),
                                            padding: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 5,
                                                bottom: 14),
                                            // Adjusted top padding
                                            child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    // onTap: () {
                                                    //   Navigator.pushNamed(
                                                    //       context,
                                                    //       UnsettledSaleDetailList
                                                    //           .screenName);
                                                    // },
                                                    onTap:
                                                    deliveryMenCount !=
                                                        null &&
                                                        deliveryMenCount! > 0
                                                        ? () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          UnsettledSaleDetailList
                                                              .screenName);
                                                    }
                                                        : null,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                child: Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      0, -5),
                                                                  // Moves the text upwards (adjust the -5 to your preference)
                                                                  child: Text(
                                                                    "Count",
                                                                    style: Styling
                                                                        .bodyTitleBigBoldDashQuick,
                                                                    textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                    textScaler:
                                                                    TextScaler
                                                                        .noScaling,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width: 8),
                                                              // small spacing between the texts
                                                              Expanded(
                                                                child: Text(
                                                                  "(DM Wise)",
                                                                  style: Styling
                                                                      .buttonTextBlack,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .start,
                                                                  textScaler:
                                                                  TextScaler
                                                                      .noScaling,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down_sharp,
                                                          size: 24,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    (deliveryMenCount ?? 0)
                                                        .toString(),
                                                    style: Styling
                                                        .bodyTitleBigBoldDashtwo,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        height: 100,
                                        width: 110,
                                        child: Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                top: 0,
                                                bottom: 14),
                                            // Adjusted top padding
                                            child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    // onTap: () {
                                                    //   Navigator.pushNamed(
                                                    //       context,
                                                    //       UnsettledSaleDetailList
                                                    //           .screenName);
                                                    // },
                                                    onTap: deliveryMenCount !=
                                                        null &&
                                                        deliveryMenCount! > 0
                                                        ? () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          UnsettledSaleDetailList
                                                              .screenName);
                                                    }
                                                        : null,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Amount",
                                                            style: Styling
                                                                .bodyTitleBigBoldDashQuick,
                                                            textAlign:
                                                            TextAlign.start,
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
                                                    formatCurrency(
                                                        totalAmount ?? 0),
                                                    style: Styling
                                                        .bodyTitleBigBoldDashtwo,
                                                    textScaler:
                                                    TextScaler.noScaling,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                // ================= Booking/Punching Row =================
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bolt_outlined,
                                          size: 26,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Refill Booking & Punching Status",
                                          style: Styling.bodyTitleBigBoldDashGrey,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        // Booking Card
                                        Expanded(
                                          child: Card(
                                            //color: Colors.white,
                                            color: Color(0xFFfcf2f1),
                                            child: InkWell(
                                              onTap: () {
                                                // showModalBottomSheet(
                                                //   context: context,
                                                //   isScrollControlled: true,
                                                //   backgroundColor: Colors.transparent,
                                                //   builder: (context) {
                                                //     // Wrap bottom sheet in StatefulBuilder
                                                //     return StatefulBuilder(
                                                //       builder: (context, setModalState) {
                                                //         // Pass setModalState to your sheet
                                                //         return showCardWithBooking(context, setModalState);
                                                //       },
                                                //     );
                                                //   },
                                                // );
                                                showModalBottomSheet(
                                                  context: context,
                                                  useRootNavigator: true, // 👈 VERY IMPORTANT
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  barrierColor: Colors.black54, // blocks background taps
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder: (context, setModalState) {
                                                        return GestureDetector(
                                                          onTap: () {}, // 👈 absorbs taps
                                                          child: showCardWithBooking(context, setModalState),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );

                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Refill \nBooking",
                                                      style: Styling.bodyTitleBigBoldDashQuick,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),


                                        const SizedBox(width: 10),

                                        // Punching Card
                                        // Expanded(
                                        //   child: Card(
                                        //     color: Colors.white,
                                        //     child: InkWell(
                                        //       // onTap: () => showCardWithPunching(context),
                                        //       onTap: () {
                                        //         showModalBottomSheet(
                                        //           context: context,
                                        //           isScrollControlled: true,
                                        //           backgroundColor: Colors.transparent,
                                        //           builder: (context) {
                                        //             return showCardWithPunching1(context);
                                        //           },
                                        //         );
                                        //       },
                                        //       child: Padding(
                                        //         padding:
                                        //         const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        //         child: Row(
                                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //           children: [
                                        //             Text(
                                        //               "Punching",
                                        //               style: Styling.bodyTitleBigBoldDashQuick,
                                        //             ),
                                        //             Icon(
                                        //               Icons.keyboard_arrow_down_sharp,
                                        //               size: 24,
                                        //               color: Colors.black54,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child:
                                          // Container(
                                          //   height: 100,
                                          //   child:
                                          Card(
                                            //color: Colors.white,
                                            color: Color(0xFFfcf2f1),
                                            child: InkWell(
                                              onTap: () {
                                                // showModalBottomSheet(
                                                //   context: context,
                                                //   isScrollControlled: true,
                                                //   backgroundColor: Colors.transparent,
                                                //   builder: (context) {
                                                //     // Wrap bottom sheet in StatefulBuilder
                                                //     return StatefulBuilder(
                                                //       builder: (context, setModalState) {
                                                //         // Pass setModalState to your sheet
                                                //         return showCardWithPunching(context, setModalState);
                                                //       },
                                                //     );
                                                //   },
                                                // );
                                                showModalBottomSheet(
                                                  context: context,
                                                  useRootNavigator: true, // 👈 VERY IMPORTANT
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  barrierColor: Colors.black54, // blocks background taps
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder: (context, setModalState) {
                                                        return GestureDetector(
                                                          onTap: () {}, // 👈 absorbs taps
                                                          child: showCardWithPunching(context, setModalState),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );

                                              },
                                              // child: Padding(
                                              //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                              //   child: Row(
                                              //     children: [
                                              //       Expanded(
                                              //         child: Text(
                                              //           "Cashmemo \n Punching",
                                              //           style: Styling.bodyTitleBigBoldDashQuick,
                                              //           maxLines: 1,
                                              //           overflow: TextOverflow.ellipsis,
                                              //         ),
                                              //       ),
                                              //
                                              //       // Expanded(
                                              //       //   child: Column(
                                              //       //     crossAxisAlignment: CrossAxisAlignment.start,
                                              //       //     mainAxisAlignment: MainAxisAlignment.center,
                                              //       //     children: [
                                              //       //       Text(
                                              //       //         "Cashmemo",
                                              //       //         style: Styling.bodyTitleBigBoldDashQuick,
                                              //       //         maxLines: 1,
                                              //       //         overflow: TextOverflow.ellipsis,
                                              //       //       ),
                                              //       //       Text(
                                              //       //         "Punching",
                                              //       //         style: Styling.bodyTitleBigBoldDashQuick,
                                              //       //         maxLines: 1,
                                              //       //         overflow: TextOverflow.ellipsis,
                                              //       //       ),
                                              //       //     ],
                                              //       //   ),
                                              //       // ),
                                              //
                                              //       const SizedBox(width: 6),
                                              //       const Icon(
                                              //         Icons.keyboard_arrow_down_sharp,
                                              //         size: 24,
                                              //         color: Colors.black54,
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Cashmemo \nPunching",
                                                      style: Styling.bodyTitleBigBoldDashQuick,
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down_sharp,
                                                      size: 24,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          //   ),
                                        ),


                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:roleId == Constants.roleIdOwner ? 15:0),
                        Visibility(
                        visible:roleId == Constants.roleIdOwner,
                          child:
                          Card(
                              margin: EdgeInsets.zero,
                              color: Color(0xFFEFFFFfff),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bar_chart,
                                              size: 20,
                                              // Bigger icon for a more clickable feel
                                              color: Colors.black54,
                                            ),
                                            SizedBox(width:4),
                                            Text(
                                              "Profit",
                                              style:
                                              Styling.bodyTitleBigBoldDashGrey,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        DropdownButton<String>(
                                          value: selectedTransMode,  // Assuming you have this variable declared
                                          items: getTransMode.map((transMode) {
                                            return DropdownMenuItem<String>(
                                              value: transMode,
                                              child: Text(
                                                transMode,
                                                style: Styling.itemBlackTestBigs,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedTransMode = value!;
                                              debugPrint("selectedTransMode $selectedTransMode");

                                              if(selectedTransMode == "Today's"){
                                                dayFlag = "TODAYS";
                                                debugPrint("dayFlag $dayFlag");
                                              }else if(selectedTransMode == "This Month"){
                                                dayFlag = "THISMONTH";
                                                debugPrint("dayFlag $dayFlag");
                                              }else if(selectedTransMode == "Financial Year"){
                                                dayFlag = "FINYEAR";
                                                debugPrint("dayFlag $dayFlag");
                                              }else{
                                                dayFlag = "";
                                              }
                                              fetchSVARBFilterCountList(dayFlag!);
                                            });
                                          },
                                        ),
                                      ]),
                                  Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                    ),
                                    child:
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Color(0xFFfcf2f1),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom:10.0,top:10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Gross Revenue',
                                                    style: Styling.bodyTitleWithBlueHightDashboard,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Gross Profit',
                                                    style: Styling.bodyTitleWithBlueHightDashboard,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Color(0xFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 7.0,bottom: 7),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'NC',
                                                    style: Styling.bodyTitleWithBlueHightDashboard,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        SVProfitDetailScreenUI
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossRevenue",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      svGrossRevenueCount != null
                                                          ? formatCurrency(
                                                          svGrossRevenueCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        SVProfitDetailScreenUI
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossRevenue",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      svGrossRevenueCount != null
                                                          ? formatCurrency(
                                                          svGrossRevenueCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),

                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(color: Color(0xFFfcf2f1),),
                                        Container(
                                          color: Color(0xFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:7.0,bottom:7),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'ARB',
                                                    style: Styling.bodyTitleWithBlueHightDashboard,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.pushNamed(
                                                        context,
                                                        ARBProfitDetailScreenUi
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossRevenue",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      arbGrossRevenueCount != null
                                                          ? formatCurrency(
                                                          arbGrossRevenueCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.pushNamed(
                                                        context,
                                                        ARBProfitDetailScreenUi
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossProfit",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      arbGrossProfitCount != null
                                                          ? formatCurrency(
                                                          arbGrossProfitCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(color: Color(0xFFfcf2f1),),
                                        Container(
                                          color: Color(0xFFFF),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:7.0,bottom:7),
                                            child:
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Refill',
                                                    style: Styling.bodyTitleWithBlueHightDashboard,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.pushNamed(
                                                        context,
                                                        RefillProfitDetailScreenUi
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossRevenue",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      refillGrossRevenueCount != null
                                                          ? formatCurrency(
                                                          refillGrossRevenueCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child:InkWell(
                                                    onTap: (){
                                                      Navigator.pushNamed(
                                                        context,
                                                        RefillProfitDetailScreenUi
                                                            .screenName,
                                                        arguments: {
                                                          "DAYFLAG": dayFlag,
                                                          "PROFITFOR":"GrossProfit",
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      refillGrossProfitCount != null
                                                          ? formatCurrency(
                                                          refillGrossProfitCount!)
                                                          : '0',
                                                      style: Styling
                                                          .blueClrTextWithUnderline,
                                                      textScaler:
                                                      TextScaler.noScaling,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(color: Color(0xFFfcf2f1),),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Gross Profit =',
                                                style: Styling
                                                    .itemBlackTestBold,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child:Text(
                                                totalGrossProfit != null
                                                    ? formatCurrency(
                                                    totalGrossProfit!)
                                                    : '0',
                                                style: Styling
                                                    .blueClrText,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:4),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Expenses =',
                                                style: Styling
                                                    .itemBlackTestBold,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child:Text(
                                                totalExpenseForProfit != null
                                                    ? formatCurrency(
                                                    totalExpenseForProfit!)
                                                    : '0',
                                                style: Styling
                                                    .blueClrText,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:4),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Profit =',
                                                style: Styling
                                                    .itemBlackTestBold,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child:Text(
                                                incomeProfit != null
                                                    ? formatCurrency(
                                                    incomeProfit!)
                                                    : '0',
                                                style: Styling
                                                    .blueClrText,
                                                textScaler:
                                                TextScaler.noScaling,
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:4),
                                      ],
                                    ),

                                  ),
                                ]),
                              )),
                        ),
                        SizedBox(height: 15),
                        Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0, right: 5,),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // First Container
                                    Flexible(
                                      flex: 1,
                                      // Distribute the space equally, you can adjust this if needed
                                      child:
                                      Container(
                                        height: 70,
                                        child: GestureDetector(
                                          onTap: (){
                                            showStockStatus(context);
                                          },
                                          child: Card(
                                            color: Color(0xFFFFFFFF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            elevation: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Stock Status",
                                                        style: Styling
                                                            .actionsShowMoreText,
                                                        textScaler: TextScaler
                                                            .noScaling,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right_sharp,
                                                        size: 26,
                                                        color: Colors.black54,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:roleId == Constants.roleIdOwner,
                                      child: Flexible(
                                        flex: 1,
                                        // Distribute the space equally, you can adjust this if needed
                                        child:
                                        Container(
                                          height: 70,
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamed(
                                                context,
                                                SalesComparisonScreen
                                                    .screenName,
                                              );
                                            },
                                            child: Card(
                                              color: Color(0xFFFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              elevation: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Sales Comparison",
                                                          style: Styling
                                                              .actionsShowMoreText,
                                                          textScaler: TextScaler
                                                              .noScaling,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_right_sharp,
                                                          size: 26,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
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
                      child: Text(
                        "No",
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        setState(() {
                          _onRefresh();
                        });
                      },
                      child: Text(
                        "Yes",
                        textScaler: TextScaler.noScaling,
                      ),
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

  // Future<void> fetchDashboarDetail() async {
  //   EasyLoading.show();
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token'); // This is your bearer token
  //
  //     DateTime now = DateTime.now();
  //     String formattedDate = DateFormat('yyyy-MM-dd')
  //         .format(now); // You can change the format as needed
  //
  //     try {
  //       final response = await http.get(
  //         Uri.parse('${AppUrl.GetMobDashboardSummaryForMgr}/$distributorId'),
  //         headers: {
  //           'Authorization': 'Bearer $token', // Add the Bearer token here
  //           'cDCMDPendSince': formattedDate,
  //           'SettlementPendSince': formattedDate,
  //           // Any other headers you need can go here
  //         },
  //       );
  //
  //       // Print the URL and the headers (including the Bearer token)
  //       print("Request URL GetMobDashboardSummaryForMgr: ${response.request}");
  //       print("Request Headers: {'Authorization': 'Bearer $token'}");
  //       // Print the raw response for debugging
  //       print(
  //           "API Response Status GetMobDashboardSummaryForMgr: ${response.statusCode}");
  //       print("API Response GetMobDashboardSummaryForMgr: ${response.body}");
  //       if (response.statusCode == 200) {
  //         final List<dynamic> data = json.decode(response.body);
  //         setState(() {
  //           getManagerDashboarDetail = data
  //               .map((json) => GetManagerDashboarDetailModel.fromJson(json))
  //               .toList();
  //           isLoading = false;
  //           EasyLoading.dismiss();
  //
  //           // Initialize totalImbQty
  //           num dMCounts = 0;
  //           double totalAmounts = 0;
  //           double totalIncomes = 0;
  //           double totalExpenses = 0;
  //           double onAccountTodays = 0;
  //           double onAccountAsOfDates = 0;
  //           int asOfDateImbQtys = 0;
  //           int todayImbCount = 0;
  //           // int cdcmsFilledDiff = 0;
  //           // int cdcmsEmptyDiff = 0;
  //           // int cdcmsDefectiveDiff = 0;
  //
  //           // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
  //           for (var receipt in getManagerDashboarDetail) {
  //             // Add imbQty to totalImbQty, treating null as 0
  //             dMCounts += receipt.dMCount ?? 0;
  //             totalAmounts +=
  //                 receipt.totalAmount ?? 0; // Corrected summing of imbQty
  //             totalIncomes +=
  //                 receipt.totalIncome ?? 0; // Corrected summing of imbQty
  //             totalExpenses +=
  //                 receipt.totalExp ?? 0; // Corrected summing of imbQty
  //             onAccountTodays +=
  //                 receipt.staffOnAccToday ?? 0; // Corrected summing of imbQty
  //             onAccountAsOfDates +=
  //                 receipt.staffOnAccAsOf ?? 0; // Corrected summing of imbQty
  //             asOfDateImbQtys += (receipt.asOfDateImbQty ?? 0).toInt();
  //             todayImbCount += (receipt.todayImbQty ?? 0).toInt();
  //             // cdcmsFilledDiff += (receipt.filledDiff ?? 0).toInt();
  //             // cdcmsEmptyDiff += (receipt.emptyDiff ?? 0).toInt();
  //             // cdcmsDefectiveDiff += (receipt.defectiveDiff ?? 0).toInt();
  //           }
  //           asOfDateImbQtyShow = asOfDateImbQtys;
  //           todaysImbQtyShow = todayImbCount;
  //           // cdcmsFilledDiffShow = cdcmsFilledDiff;
  //           // cdcmsEmptyDiffShow = cdcmsEmptyDiff;
  //           // cdcmsDefectiveDiffShow = cdcmsDefectiveDiff;
  //           // total = cdcmsFilledDiff + cdcmsEmptyDiff + cdcmsDefectiveDiff;
  //           // filledPercent = cdcmsFilledDiff / total! * 100;
  //           // emptyPercent = cdcmsEmptyDiff / total! * 100;
  //           // defectivePercent = cdcmsDefectiveDiff / total! * 100;
  //
  //           // deliveryMenCount = dMCounts.toInt();
  //           // totalAmount = totalAmounts.toDouble();
  //           // totalIncome = totalIncomes.toDouble();
  //           // totalExpense = totalExpenses.toDouble();
  //           // onAccountToday = onAccountTodays.toDouble();
  //           // onAccountAsOfDate = onAccountAsOfDates.toDouble();
  //
  //           // Print the totalAmount of the first item (if exists)
  //
  //           String _normalize(String? value) {
  //             return value
  //                 ?.toLowerCase()
  //                 .replaceAll(RegExp(r'\s+'), '')
  //                 .trim() ??
  //                 '';
  //           }
  //
  //           final defaultItem = getManagerDashboarDetail.firstWhere(
  //                 (item) => _normalize(item.itemName) == '14.2kg',
  //             orElse: () => GetManagerDashboarDetailModel(),
  //           );
  //
  //           if (defaultItem.itemId != null) {
  //             selectedItemIdCDCMS = defaultItem.itemId!.toInt();
  //             // Set opening stock values
  //             cdcmsFilledDiffShow = defaultItem.filledDiff?.toInt() ?? 0;
  //             cdcmsEmptyDiffShow = defaultItem.emptyDiff?.toInt() ?? 0;
  //             cdcmsDefectiveDiffShow = defaultItem.defectiveDiff!.toInt();
  //           }
  //           if (getManagerDashboarDetail.isNotEmpty) {
  //             print(
  //                 'Total Amount of the first item: ${getManagerDashboarDetail[0].totalAmount}');
  //             deliveryMenCount = getManagerDashboarDetail[0].dMCount?.toInt();
  //             totalAmount = getManagerDashboarDetail[0].totalAmount?.toDouble();
  //             totalIncome = getManagerDashboarDetail[0].totalIncome?.toDouble();
  //             totalExpense = getManagerDashboarDetail[0].totalExp?.toDouble();
  //             onAccountToday =
  //                 getManagerDashboarDetail[0].staffOnAccToday?.toDouble();
  //             onAccountAsOfDate =
  //                 getManagerDashboarDetail[0].staffOnAccAsOf?.toDouble();
  //
  //             todaysPunchingInNiyojanC =
  //                 getManagerDashboarDetail[0].niyojanPun?.toInt() ?? 0;
  //             pendingInNiyojanC =
  //                 getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
  //             pendingInCdcmsC =
  //                 getManagerDashboarDetail[0].cDCMSPunPend?.toInt() ?? 0;
  //             todaysIncorrectPunchingC =
  //                 getManagerDashboarDetail[0].niyojanDuplicate?.toInt() ?? 0;
  //             settlPayReceiveDelPendC =
  //                 getManagerDashboarDetail[0].paymtDoneBtDelPend?.toInt() ?? 0;
  //             settlDelPayPendC =
  //                 getManagerDashboarDetail[0].delDoneBtPaymtPend?.toInt() ?? 0;
  //             oldBkgPendNewBkgRecv =
  //                 getManagerDashboarDetail[0].oldBkgPendNewBkgRecv?.toInt() ??
  //                     0;
  //             delDonNiyoJanPunPend =
  //                 getManagerDashboarDetail[0].delDonNiyoJanPunPend?.toInt() ??
  //                     0;
  //             niyoJanPunDelPend =
  //                 getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
  //             postPaidVerifPend =
  //                 getManagerDashboarDetail[0].postPaidVerifPend?.toInt() ?? 0;
  //             sVPendingStk =
  //                 getManagerDashboarDetail[0].sVPendingStk?.toInt() ?? 0;
  //             tVPendingStk =
  //                 getManagerDashboarDetail[0].tVPendingStk?.toInt() ?? 0;
  //             cDCMDPendSince =
  //                 getManagerDashboarDetail[0].cDCMDPendSince?.toString();
  //             settlementPendSince =
  //                 getManagerDashboarDetail[0].settlementPendSince?.toString();
  //             totalPendingSettSince =
  //                 getManagerDashboarDetail[0].totalPendingSettSince?.toString();
  //             paymtDoneBtDelPendAmt =
  //                 getManagerDashboarDetail[0].paymtDoneBtDelPendAmt?.toInt() ??
  //                     0;
  //             delDoneBtPaymtPendAmt =
  //                 getManagerDashboarDetail[0].delDoneBtPaymtPendAmt?.toInt() ??
  //                     0;
  //             totalPendingSettCnt =
  //                 getManagerDashboarDetail[0].totalPendingSettCnt?.toInt() ?? 0;
  //             totalPendingSettAmt =
  //                 getManagerDashboarDetail[0].totalPendingSettAmt?.toInt() ?? 0;
  //             postPaidVerifPendAmt =
  //                 getManagerDashboarDetail[0].postPaidVerifPendAmt?.toInt() ??
  //                     0;
  //             UndocumentedSV =
  //                 getManagerDashboarDetail[0].UndocumentedSV?.toInt() ?? 0;
  //             TotalCrdtOutstd =
  //                 getManagerDashboarDetail[0].TotalCrdtOutstd?.toInt() ?? 0;
  //           }
  //         });
  //       } else {
  //         // Handle non-200 responses
  //         setState(() {
  //           refreshTokens();
  //           isLoading = false;
  //           EasyLoading.dismiss();
  //         });
  //         // refreshTokens();
  //         // showFlushBar(context, Constants.listGettingFail);
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         // Check if the widget is still mounted
  //         setState(() {
  //           refreshTokens();
  //           EasyLoading.dismiss();
  //           isLoading = false;
  //         });
  //       }
  //       // refreshTokens();
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Error: $e')),
  //       // );
  //       // showFlushBar(context, Constants.listGettingFail);
  //     }
  //   } else {
  //     EasyLoading.dismiss();
  //     showFlushBar(context, Constants.connectionMessage);
  //   }
  // }

  Future<void> fetchDashboarDetailItemWise() async {
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
          Uri.parse('${AppUrl.GetDashSummaryItemWiseForMgr}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            'cDCMDPendSince': formattedDate,
            'SettlementPendSince': formattedDate,
            // Any other headers you need can go here
          },
        );

        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetDashSummaryItemWiseForMgr: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetDashSummaryItemWiseForMgr: ${response.statusCode}");
        print("API Response GetDashSummaryItemWiseForMgr: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getManagerDashboarDetailItemWise = data
                .map((json) => GetDashSummaryItemWiseForMgrModel.fromJson(json))
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

            String _normalize(String? value) {
              return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ?? '';
            }
            final defaultItem = getManagerDashboarDetailItemWise.firstWhere(
                  (item) => _normalize(item.itemName) == '14.2kg',
              orElse: () => GetDashSummaryItemWiseForMgrModel(),
            );

            if (defaultItem.itemId != null) {
              selectedItemIdCDCMS = defaultItem.itemId!.toInt();
              // Set opening stock values

              cdcmsFilledDiffShow = defaultItem.filledDiff?.toInt() ?? 0;
              cdcmsEmptyDiffShow = defaultItem.emptyDiff?.toInt() ?? 0;
              cdcmsDefectiveDiffShow = defaultItem.defectiveDiff!.toInt();
            }
            for (var receipt in getManagerDashboarDetailItemWise) {
              asOfDateImbQtys += (receipt.asOfDateImbQty ?? 0).toInt();
              todayImbCount += (receipt.todayImbQty ?? 0).toInt();
            }
            asOfDateImbQtyShow = asOfDateImbQtys;
            todaysImbQtyShow = todayImbCount;
          });
        } else {
          // Handle non-200 responses
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
          });
        }
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchDashboarDetailForAllCount() async {
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
          Uri.parse('${AppUrl.GetDashSummaryAllCountForMgr}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            'cDCMDPendSince': formattedDate,
            'SettlementPendSince': formattedDate,
            // Any other headers you need can go here
          },
        );

        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetDashSummaryAllCountForMgr: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetDashSummaryAllCountForMgr: ${response.statusCode}");
        print("API Response GetDashSummaryAllCountForMgr: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getManagerDashboarDetailAllCount = data
                .map((json) => GetDashSummaryAllCountForMgrModel.fromJson(json))
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
            // int cdcmsFilledDiff = 0;
            // int cdcmsEmptyDiff = 0;
            // int cdcmsDefectiveDiff = 0;

            // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            for (var receipt in getManagerDashboarDetailAllCount) {
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

              if (getManagerDashboarDetailAllCount.isNotEmpty) {
                print(
                    'Total Amount of the first item: ${getManagerDashboarDetailAllCount[0]
                        .totalAmount}');
                deliveryMenCount =
                    getManagerDashboarDetailAllCount[0].dMCount?.toInt();
                totalAmount =
                    getManagerDashboarDetailAllCount[0].totalAmount?.toDouble();
                totalIncome =
                    getManagerDashboarDetailAllCount[0].totalIncome?.toDouble();
                totalExpense =
                    getManagerDashboarDetailAllCount[0].totalExp?.toDouble();
                onAccountToday =
                    getManagerDashboarDetailAllCount[0].staffOnAccToday
                        ?.toDouble();
                onAccountAsOfDate =
                    getManagerDashboarDetailAllCount[0].staffOnAccAsOf
                        ?.toDouble();
                postPaidVerifPend =
                    getManagerDashboarDetailAllCount[0].postPaidVerifPend
                        ?.toInt() ?? 0;
                sVPendingStk =
                    getManagerDashboarDetailAllCount[0].sVPendingStk?.toInt() ??
                        0;
                tVPendingStk =
                    getManagerDashboarDetailAllCount[0].tVPendingStk?.toInt() ??
                        0;
                postPaidVerifPendAmt =
                    getManagerDashboarDetailAllCount[0].postPaidVerifPendAmt
                        ?.toInt() ?? 0;
                TotalCrdtOutstd = getManagerDashboarDetailAllCount[0].totalCrdtOutstd?.toInt() ?? 0;

                UndocumentedSV = getManagerDashboarDetailAllCount[0].undocumentedSV?.toInt() ?? 0;

                TotalVendorDueAmt = getManagerDashboarDetailAllCount[0].totalVendorDueAmt?.toInt() ?? 0;
              }
            }
          });
        } else {
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
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
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchDashboarDetailForSettItem() async {
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
          Uri.parse('${AppUrl.GetDashSummarySettAllCountForMgr}/$distributorId'),
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
            getManagerDashboarDetailSettCount = data
                .map((json) => GetDashSummarySettAllCountForMgrModel.fromJson(json))
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

            // asOfDateImbQtyShow = asOfDateImbQtys;
            // todaysImbQtyShow = todayImbCount;


            String _normalize(String? value) {
              return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ?? '';
            }

            if (getManagerDashboarDetailSettCount.isNotEmpty) {
              print(
                  'niyojan Amount of the first item: ${getManagerDashboarDetailSettCount[0]
                      .niyojanPun}');
              todaysPunchingInNiyojanC =
                  getManagerDashboarDetailSettCount[0].niyojanPun?.toInt() ?? 0;
              pendingInNiyojanC =
                  getManagerDashboarDetailSettCount[0].niyoJanPunDelPend?.toInt() ?? 0;
              pendingInCdcmsC =
                  getManagerDashboarDetailSettCount[0].cDCMSPunPend?.toInt() ?? 0;
              todaysIncorrectPunchingC =
                  getManagerDashboarDetailSettCount[0].niyojanDuplicate?.toInt() ?? 0;
              settlPayReceiveDelPendC =
                  getManagerDashboarDetailSettCount[0].paymtDoneBtDelPend?.toInt() ?? 0;
              settlDelPayPendC =
                  getManagerDashboarDetailSettCount[0].delDoneBtPaymtPend?.toInt() ?? 0;
              oldBkgPendNewBkgRecv =
                  getManagerDashboarDetailSettCount[0].oldBkgPendNewBkgRecv?.toInt() ??
                      0;
              delDonNiyoJanPunPend =
                  getManagerDashboarDetailSettCount[0].delDonNiyoJanPunPend?.toInt() ??
                      0;
              niyoJanPunDelPend =
                  getManagerDashboarDetailSettCount[0].niyoJanPunDelPend?.toInt() ?? 0;
              cDCMDPendSince =
                  getManagerDashboarDetailSettCount[0].cDCMDPendSince?.toString();
              settlementPendSince =
                  getManagerDashboarDetailSettCount[0].settlementPendSince?.toString();
              totalPendingSettSince =
                  getManagerDashboarDetailSettCount[0].totalPendingSettSince?.toString();
              paymtDoneBtDelPendAmt =
                  getManagerDashboarDetailSettCount[0].paymtDoneBtDelPendAmt?.toInt() ??
                      0;
              delDoneBtPaymtPendAmt =
                  getManagerDashboarDetailSettCount[0].delDoneBtPaymtPendAmt?.toInt() ??
                      0;
              totalPendingSettCnt =
                  getManagerDashboarDetailSettCount[0].totalPendingSettCnt?.toInt() ?? 0;
              totalPendingSettAmt =
                  getManagerDashboarDetailSettCount[0].totalPendingSettAmt?.toInt() ?? 0;
            }
          });
        } else {
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
          });
        }
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

            // // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            // for (var receipt in getCurrentStockDetailManager) {
            //   totalOpeningStockFilledShow += (receipt.filledOpeningStk ?? 0)
            //       .toInt(); // Corrected summing of imbQty
            //   totalOpeningStockEmptyShow += (receipt.emptyOpeningStk ?? 0)
            //       .toInt(); // Corrected summing of imbQty
            //   totalOpeningStockDefectiveShow +=
            //       (receipt.deffOpeningStk ?? 0).toInt();
            //   totalCurrentStockFilledShow +=
            //       (receipt.filledCurrentStk ?? 0).toInt();
            //   totalCurrentStockEmptyShow +=
            //       (receipt.emptyCurrentStk ?? 0).toInt();
            //   totalCurrentStockDefectiveShow +=
            //       (receipt.deffCurrentStk ?? 0).toInt();
            // }
            // totalOpeningStockFilled = totalOpeningStockFilledShow;
            // totalOpeningStockEmpty = totalOpeningStockEmptyShow;
            // totalOpeningStockDefective = totalOpeningStockDefectiveShow;
            // totalCurrentStockFilled = totalCurrentStockFilledShow;
            // totalCurrentStockEmpty = totalCurrentStockEmptyShow;
            // totalCurrentStockDefective = totalCurrentStockDefectiveShow;

            // Assuming getCurrentStockDetailManager is already populated
            String _normalize(String? value) {
              return value
                  ?.toLowerCase()
                  .replaceAll(RegExp(r'\s+'), '')
                  .trim() ??
                  '';
            }

            final defaultItem = getCurrentStockDetailManager.firstWhere(
                  (item) => _normalize(item.itemName) == '14.2kg',
              orElse: () => GetCurrentStockDetailManagerModel(),
            );

            if (defaultItem.itemId != null) {
              selectedItemId = defaultItem.itemId!.toInt();

              // Set opening stock values
              totalOpeningStockFilled =
                  defaultItem.filledOpeningStk?.toInt() ?? 0;
              totalOpeningStockEmpty =
                  defaultItem.emptyOpeningStk?.toInt() ?? 0;
              totalOpeningStockDefective =
                  defaultItem.deffOpeningStk?.toInt() ?? 0;
              totalCurrentStockFilled = defaultItem.filledCurrentStk!.toInt();
              totalCurrentStockEmpty = defaultItem.emptyCurrentStk!.toInt();
              totalCurrentStockDefective = defaultItem.deffCurrentStk!.toInt();
            }
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
            // fetchDashboarDetail();
            fetchDashboarDetailForSettItem();
            fetchSVARBFilterCountList("THISMONTH");
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
              textScaler: TextScaler.noScaling,
            ),
            content: Text(
              message,
              style: Styling.bodyTitle,
              textScaler: TextScaler.noScaling,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: Styling.blueClrText,
                  textScaler: TextScaler.noScaling,
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
                  padding: const EdgeInsets.all(10.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Prepaid Punching Status",
                        style: Styling.bodyTitleWithBlueHightDashboard,
                        textAlign: TextAlign.start,
                        textScaler: TextScaler.noScaling,
                      ),
                      Visibility(
                        visible: roleId == Constants.roleIdOwner,
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(
                                context,
                                PrepaidBookingAndSettlementGraphScreen
                                    .screenName);
                          },
                          child: Row(
                            children: [
                              Text(
                                "View Graph",
                                style: Styling.bodyTitleWithBlueHightSmall,
                                textAlign: TextAlign.start,
                                textScaler: TextScaler.noScaling,
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_sharp, size: 16, color: Colors.blue),  // your prefix icon

                            ],
                          ),
                        ),
                      ),
                    ],
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
                            todaysPunchingInNiyojanC! > 0
                                ? Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "Punching"},
                            )
                                : null;
                            debugPrint("Rejected Entries tapped");
                          },
                        )),
                    Expanded(
                      child: _buildCard(
                        todaysIncorrectPunchingC.toString(),
                        "Today's incorrect",
                        const Color(0xFFEFF2FB),
                        onTap: () {
                          todaysIncorrectPunchingC! > 0
                              ? Navigator.pushNamed(
                            context,
                            DashboardPrepaidDetails.screenName,
                            arguments: {"flag": "Incorrect"},
                          )
                              : null;
                          debugPrint("Rejected Entries tapperyryd");
                        },
                      ),
                    ),
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
                            debugPrint("Rejected Entries cDCMS");
                            pendingInCdcmsC! > 0
                                ? Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "cDCMS"},
                            )
                                : null;
                          },
                        )),
                    Expanded(
                        child: _buildCard(
                          oldBkgPendNewBkgRecv.toString(),
                          "Old punching pending in Niyojan but new booking is received",
                          const Color(0xFFFFFFFF),
                          onTap: () {
                            debugPrint("Rejected Entries tryapped");
                            oldBkgPendNewBkgRecv! > 0
                                ? Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "OldBkgPendNewBkgRecv"},
                            )
                                : null;
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
                            delDonNiyoJanPunPend! > 0
                                ? Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "DelDonNiyoJanPunPend"},
                            )
                                : null;
                          },
                        )),
                    Expanded(
                        child: _buildCard(
                          niyoJanPunDelPend.toString(),
                          "Punched in Niyojan, pending in cDCMS",
                          const Color(0xFFEFF2FB),
                          onTap: () {
                            debugPrint("Rejected Entrigrretes tapped");
                            niyoJanPunDelPend! > 0
                                ? Navigator.pushNamed(
                              context,
                              DashboardPrepaidDetails.screenName,
                              arguments: {"flag": "NiyoJanPunDelPend"},
                            )
                                : null;
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
    final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
    final totalDoneBtDelPend = paymtDoneBtDelPendAmt?.toDouble() ?? 0.0;
    final totaldelDoneBtPaymtPend = delDoneBtPaymtPendAmt?.toDouble() ?? 0.0;
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
                    "Prepaid Settlement Status \n(Data ref. cDCMS)",
                    style: Styling.bodyTitleWithBlueHightDashboard,
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.noScaling,
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
                                  // onTap: settlPayReceiveDelPendC! > 0
                            onTap: settlPayReceiveDelPendC != null && settlPayReceiveDelPendC! > 0
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
                                          fontSize: 18,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        // paymtDoneBtDelPendAmt!
                                        //     .toStringAsFixed(2),
                                        formatCurrency(totalDoneBtDelPend),
                                        // Replace this with your dynamic data
                                        style: Styling.countNumber.copyWith(
                                          color: Colors.black,
                                          // Make the text blue like a link
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
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
                                  onTap: settlDelPayPendC != null && settlDelPayPendC! > 0
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
                                          fontSize: 18,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor:
                                          Colors.blue, // Underline color
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        //'${delDoneBtPaymtPendAmt?.toStringAsFixed(2)}',
                                        formatCurrency(totaldelDoneBtPaymtPend),

                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          fontSize: 18,
                                          color: Colors
                                              .black, // Make the text blue like a link
                                        ),

                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
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
                                  textScaler: TextScaler.noScaling,
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
                                  onTap: totalPendingSettCnt != null && totalPendingSettCnt! > 0
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
                                          fontSize: 18,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor:
                                          Colors.blue, // Underline color
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: verticalDividerSmallestRed(),
                                      ),
                                      Text(
                                        //'${totalPendingSettAmt?.toStringAsFixed(2)}',
                                        formatCurrency(totalPendAmount),
                                        // Use 'N/A' if cDCMDPendSince is null
                                        style: Styling.countNumber.copyWith(
                                          color: Colors.black,
                                          // Make the text blue like a link
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
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
                                  textScaler: TextScaler.noScaling,
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
                  textScaler: TextScaler.noScaling,
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
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
        ),
      ),
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
        textScaler: TextScaler.noScaling,
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
        textScaler: TextScaler.noScaling,
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with larger font and subtle shadow
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Imbalance Stock',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Display dynamic data or No Data Available message
                    getManagerDashboarDetailItemWise.isNotEmpty
                        ? Column(
                      children: [
                        // Table Header with gradient and modern styling
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFF2FB),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
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
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: getManagerDashboarDetailItemWise
                              .where((item) =>
                          item.todayImbQty! > 0 ||
                              item.asOfDateImbQty! > 0)
                              .toList()
                              .length,
                          itemBuilder: (context, index) {
                            var item = getManagerDashboarDetailItemWise
                                .where((item) =>
                            item.todayImbQty! > 0 ||
                                item.asOfDateImbQty! > 0)
                                .toList()[index];

                            // Alternate row color logic
                            Color backgroundColor = index % 2 == 1
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
                                        style: Styling.textFormText,
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
                                          style: Styling
                                              .textFormTextWithUnderline,
                                          textAlign: TextAlign.center,
                                          textScaler:
                                          TextScaler.noScaling,
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
                                          style: Styling
                                              .textFormTextWithUnderline,
                                          textAlign: TextAlign.center,
                                          textScaler:
                                          TextScaler.noScaling,
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
                              textScaler: TextScaler.noScaling,
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

  // void showCardWithBooking(BuildContext context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     transitionDuration: const Duration(milliseconds: 400),
  //     pageBuilder: (context, animation1, animation2) {
  //       return Align(
  //         alignment: Alignment.bottomCenter,
  //         child: GestureDetector(
  //           onHorizontalDragEnd: (details) {
  //             if (details.primaryVelocity != null &&
  //                 details.primaryVelocity!.abs() > 300) {
  //               Navigator.pop(context); // Close if swipe velocity is high
  //             }
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height *
  //                 0.7, // 70% of screen height
  //             width: double.infinity,
  //             color: Colors.white,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Title with larger font and subtle shadow
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Booking',
  //                           style: TextStyle(
  //                             fontSize: 19,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black,
  //                           ),
  //                           textScaler: TextScaler.noScaling,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   // Display dynamic data or No Data Available message
  //                   getManagerDashboarDetailItemWise.isNotEmpty
  //                       ? Column(
  //                     children: [
  //                       // Table Header with gradient and modern styling
  //                       Container(
  //                         decoration: BoxDecoration(
  //                           color: Color(0xFFEFF2FB),
  //                         ),
  //                         padding: EdgeInsets.only(top: 10, bottom: 10),
  //                         child: Row(
  //                           mainAxisAlignment:
  //                           MainAxisAlignment.spaceAround,
  //                           children: [
  //                             buildTableHeader(' '),
  //                             buildTableHeader('Today'),
  //                             buildTableHeader('As Of Date'),
  //                           ],
  //                         ),
  //                       ),
  //
  //                       // Use ListView to make the content scrollable
  //                       ListView.builder(
  //                         shrinkWrap: true,
  //                         padding: EdgeInsets.zero,
  //                         physics: NeverScrollableScrollPhysics(),
  //                         itemCount: getManagerDashboarDetailItemWise
  //                             .where((item) =>
  //                         item.todayImbQty! > 0 ||
  //                             item.asOfDateImbQty! > 0)
  //                             .toList()
  //                             .length,
  //                         itemBuilder: (context, index) {
  //                           var item = getManagerDashboarDetailItemWise
  //                               .where((item) =>
  //                           item.todayImbQty! > 0 ||
  //                               item.asOfDateImbQty! > 0)
  //                               .toList()[index];
  //
  //                           // Alternate row color logic
  //                           Color backgroundColor = index % 2 == 1
  //                               ? Color(0xFFEFF2FB)
  //                               : Colors.white;
  //
  //                           return Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 vertical: 5.0),
  //                             child: Container(
  //                               color: backgroundColor,
  //                               padding: EdgeInsets.all(12),
  //                               child: Row(
  //                                 mainAxisAlignment:
  //                                 MainAxisAlignment.spaceAround,
  //                                 children: [
  //                                   // Non-clickable itemName
  //                                   Expanded(
  //                                     child: Text(
  //                                       item.itemName ?? '',
  //                                       style: Styling.textFormText,
  //                                     ),
  //                                   ),
  //                                   // Today Imbalance Quantity - styled with blue color and underline
  //                                   Expanded(
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         print(
  //                                             'Tapped on today imbalance qty: ${item.todayImbQty}');
  //                                         // Navigate to ImbalanceCountClickUI, passing ItemId and imbQtyType
  //                                         Navigator.pushNamed(
  //                                           context,
  //                                           ImbalanceCountClickUI
  //                                               .screenName,
  //                                           arguments: {
  //                                             "ItemId": item.itemId,
  //                                             "imbQtyType": 'today'
  //                                           },
  //                                         );
  //                                       },
  //                                       child: Text(
  //                                         item.todayImbQty.toString(),
  //                                         style: Styling
  //                                             .textFormTextWithUnderline,
  //                                         textAlign: TextAlign.center,
  //                                         textScaler:
  //                                         TextScaler.noScaling,
  //                                       ),
  //                                     ),
  //                                   ),
  //
  //                                   // As of Date Imbalance Quantity - styled with blue color and underline
  //                                   Expanded(
  //                                     child: GestureDetector(
  //                                       onTap: () {
  //                                         print(
  //                                             'Tapped on as of date imbalance qty: ${item.asOfDateImbQty}');
  //                                         // Navigate to ImbalanceCountClickUI, passing ItemId and imbQtyType
  //                                         Navigator.pushNamed(
  //                                           context,
  //                                           ImbalanceCountClickUI
  //                                               .screenName,
  //                                           arguments: {
  //                                             "ItemId": item.itemId,
  //                                             "imbQtyType": 'asOfDate'
  //                                           },
  //                                         );
  //                                       },
  //                                       child: Text(
  //                                         item.asOfDateImbQty.toString(),
  //                                         style: Styling
  //                                             .textFormTextWithUnderline,
  //                                         textAlign: TextAlign.center,
  //                                         textScaler:
  //                                         TextScaler.noScaling,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   )
  //                       : Center(
  //                     child: Container(
  //                       padding: EdgeInsets.all(20),
  //                       decoration: BoxDecoration(
  //                         color: Colors.blueGrey[50],
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(Icons.warning, color: Colors.orange),
  //                           SizedBox(width: 10),
  //                           Text(
  //                             'No Data Available',
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w500,
  //                               color: Colors.blueGrey,
  //                             ),
  //                             textScaler: TextScaler.noScaling,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation1, animation2, child) {
  //       final offsetAnimation = Tween<Offset>(
  //         begin: const Offset(0, 1), // Start from the bottom of the screen
  //         end: Offset.zero, // Move to original position
  //       ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));
  //
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }
  //
  // void showCardWithBooking1(BuildContext context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     transitionDuration: const Duration(milliseconds: 400),
  //     pageBuilder: (context, animation1, animation2) {
  //       return Align(
  //         alignment: Alignment.bottomCenter,
  //         child: GestureDetector(
  //           onHorizontalDragEnd: (details) {
  //             if (details.primaryVelocity != null &&
  //                 details.primaryVelocity!.abs() > 300) {
  //               Navigator.pop(context);
  //             }
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height * 0.7,
  //             width: double.infinity,
  //             color: Colors.white,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Title
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                     child: Text(
  //                       'Booking',
  //                       style: TextStyle(
  //                         fontSize: 19,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                       textScaler: TextScaler.noScaling,
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 5),
  //
  //                   getManagerDashboarDetailItemWise.isNotEmpty
  //                       ? Column(
  //                     children: [
  //                       // TABLE HEADER
  //                       Container(
  //                         decoration: const BoxDecoration(
  //                           color: Color(0xFFEFF2FB),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(vertical: 10),
  //                         child: Row(
  //                           children: [
  //                             Expanded(
  //                               flex: 2,
  //                               child: buildTableHeader(' '),
  //                             ),
  //                             Expanded(
  //                               child: buildTableHeader('Today'),
  //                             ),
  //                             Expanded(
  //                               child: buildTableHeader('As Of Date'),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       // TABLE BODY
  //                       Container(
  //                         padding: const EdgeInsets.all(12),
  //                         child: Column(
  //                           children: [
  //                             // MANUAL ROW
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   flex: 2,
  //                                   child: Text(
  //                                     'Manual',
  //                                     style: Styling.textFormText,
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(
  //                                     '0',
  //                                     textAlign: TextAlign.center,
  //                                     style: Styling.textFormText,
  //                                     textScaler: TextScaler.noScaling,
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(
  //                                     '0',
  //                                     textAlign: TextAlign.center,
  //                                     style: Styling.textFormText,
  //                                     textScaler: TextScaler.noScaling,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //
  //                             const SizedBox(height: 10),
  //
  //                             // ONLINE ROW
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   flex: 2,
  //                                   child: Text(
  //                                     'Online',
  //                                     style: Styling.textFormText,
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(
  //                                     '0',
  //                                     textAlign: TextAlign.center,
  //                                     style: Styling.textFormText,
  //                                     textScaler: TextScaler.noScaling,
  //                                   ),
  //                                 ),
  //                                 Expanded(
  //                                   child: Text(
  //                                     '165',
  //                                     textAlign: TextAlign.center,
  //                                     style: Styling.textFormText,
  //                                     textScaler: TextScaler.noScaling,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   )
  //                       : Center(
  //                     child: Container(
  //                       padding: const EdgeInsets.all(20),
  //                       decoration: BoxDecoration(
  //                         color: Colors.blueGrey[50],
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: const [
  //                           Icon(Icons.warning,
  //                               color: Colors.orange),
  //                           SizedBox(width: 10),
  //                           Text(
  //                             'No Data Available',
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w500,
  //                               color: Colors.blueGrey,
  //                             ),
  //                             textScaler: TextScaler.noScaling,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation1, animation2, child) {
  //       final offsetAnimation = Tween<Offset>(
  //         begin: const Offset(0, 1),
  //         end: Offset.zero,
  //       ).animate(
  //         CurvedAnimation(parent: animation1, curve: Curves.easeInOut),
  //       );
  //
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }
  //
  //
  // Widget profitCard(BuildContext context) {
  //   return Card(
  //     margin: EdgeInsets.zero,
  //     color: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //
  //           /// TITLE
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 10),
  //             child: Text(
  //               'Booking',
  //               style: const TextStyle(
  //                 fontSize: 19,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //               textScaler: TextScaler.noScaling,
  //             ),
  //           ),
  //
  //           const SizedBox(height: 5),
  //
  //           /// DATA / EMPTY STATE
  //           getManagerDashboarDetailItemWise.isNotEmpty
  //               ? Column(
  //             children: [
  //
  //               /// TABLE HEADER
  //               Container(
  //                 color: const Color(0xFFEFF2FB),
  //                 padding:
  //                 const EdgeInsets.symmetric(vertical: 10),
  //                 child: Row(
  //                   mainAxisAlignment:
  //                   MainAxisAlignment.spaceAround,
  //                   children: [
  //                     buildTableHeader(' '),
  //                     buildTableHeader('Today'),
  //                     buildTableHeader('As Of Date'),
  //                   ],
  //                 ),
  //               ),
  //
  //               /// LIST
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 physics:
  //                 const NeverScrollableScrollPhysics(),
  //                 itemCount:
  //                 getManagerDashboarDetailItemWise
  //                     .where((item) =>
  //                 item.todayImbQty! > 0 ||
  //                     item.asOfDateImbQty! > 0)
  //                     .length,
  //                 itemBuilder: (context, index) {
  //                   final filteredList =
  //                   getManagerDashboarDetailItemWise
  //                       .where((item) =>
  //                   item.todayImbQty! > 0 ||
  //                       item.asOfDateImbQty! > 0)
  //                       .toList();
  //
  //                   final item = filteredList[index];
  //
  //                   final backgroundColor =
  //                   index.isOdd
  //                       ? const Color(0xFFEFF2FB)
  //                       : Colors.white;
  //
  //                   return Container(
  //                     color: backgroundColor,
  //                     padding: const EdgeInsets.all(12),
  //                     child: Row(
  //                       children: [
  //
  //                         /// ITEM NAME
  //                         Expanded(
  //                           child: Text(
  //                             item.itemName ?? '',
  //                             style:
  //                             Styling.textFormText,
  //                           ),
  //                         ),
  //
  //                         /// TODAY
  //                         Expanded(
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               Navigator.pushNamed(
  //                                 context,
  //                                 ImbalanceCountClickUI
  //                                     .screenName,
  //                                 arguments: {
  //                                   "ItemId":
  //                                   item.itemId,
  //                                   "imbQtyType":
  //                                   'today',
  //                                 },
  //                               );
  //                             },
  //                             child: Text(
  //                               item.todayImbQty
  //                                   .toString(),
  //                               style: Styling
  //                                   .textFormTextWithUnderline,
  //                               textAlign:
  //                               TextAlign.center,
  //                               textScaler:
  //                               TextScaler
  //                                   .noScaling,
  //                             ),
  //                           ),
  //                         ),
  //
  //                         /// AS OF DATE
  //                         Expanded(
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               Navigator.pushNamed(
  //                                 context,
  //                                 ImbalanceCountClickUI
  //                                     .screenName,
  //                                 arguments: {
  //                                   "ItemId":
  //                                   item.itemId,
  //                                   "imbQtyType":
  //                                   'asOfDate',
  //                                 },
  //                               );
  //                             },
  //                             child: Text(
  //                               item.asOfDateImbQty
  //                                   .toString(),
  //                               style: Styling
  //                                   .textFormTextWithUnderline,
  //                               textAlign:
  //                               TextAlign.center,
  //                               textScaler:
  //                               TextScaler
  //                                   .noScaling,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           )
  //               : Center(
  //             child: Container(
  //               padding: const EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: Colors.blueGrey[50],
  //                 borderRadius:
  //                 BorderRadius.circular(10),
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: const [
  //                   Icon(Icons.warning,
  //                       color: Colors.orange),
  //                   SizedBox(width: 10),
  //                   Text(
  //                     'No Data Available',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight:
  //                       FontWeight.w500,
  //                       color:
  //                       Colors.blueGrey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _dashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: const Color(0xff1280b3),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Styling.bodyTitleBigBoldDashQuick,
                textScaler: TextScaler.noScaling,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showStockStatus(BuildContext context) {
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
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return
                    Container(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height * 0.9, // Half-height sheet
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
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
                                      icon: Icon(
                                          Icons.arrow_back, color: Colors.black),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    SizedBox(width: 10),
                                    // Space between icon and text
                                    Text(
                                      'Stock Status',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Opening Stock Status",
                                          style: Styling.bodyTitleBigBoldDashGrey,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    DropdownButton<num>(
                                      value: selectedItemId,
                                      items: getCurrentStockDetailManager.map((
                                          item) {
                                        return DropdownMenuItem<num>(
                                          value: item.itemId,
                                          child: Text(item.itemName ?? 'Unknown',
                                              style: Styling.dropdownVerySmallText),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setModalState(() {
                                          selectedItemId = value!.toInt();
                                          final selectedItem =
                                          getCurrentStockDetailManager.firstWhere(
                                                (item) =>
                                            item.itemId == selectedItemId,
                                            orElse: () =>
                                                GetCurrentStockDetailManagerModel(),
                                          );
                                          totalOpeningStockFilled =
                                              selectedItem.filledOpeningStk!
                                                  .toInt();
                                          totalOpeningStockEmpty =
                                              selectedItem.emptyOpeningStk!.toInt();
                                          totalOpeningStockDefective =
                                              selectedItem.deffOpeningStk!.toInt();
                                          totalCurrentStockFilled =
                                              selectedItem.filledCurrentStk!
                                                  .toInt();
                                          totalCurrentStockEmpty =
                                              selectedItem.emptyCurrentStk!.toInt();
                                          totalCurrentStockDefective =
                                              selectedItem.deffCurrentStk!.toInt();
                                        });
                                      },
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              totalOpeningStockFilled.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                // Underline the text
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Filled',
                                              style: Styling.bodyTitle,
                                              textScaler: TextScaler.noScaling,
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalOpeningStockEmpty.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling
                                                    .bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Empty',
                                                style: Styling.bodyTitle,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          )),
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              totalOpeningStockDefective.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Defective',
                                              style: Styling.bodyTitle,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(children: [
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalCurrentStockFilled.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling
                                                    .bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Filled',
                                                style: Styling.bodyTitle,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          )),
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              totalCurrentStockEmpty.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Empty',
                                              style: Styling.bodyTitle,
                                              textScaler: TextScaler.noScaling,
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              totalCurrentStockDefective.toString(),
                                              // Replace this with your dynamic data
                                              style: Styling
                                                  .bodyTitleBigBoldDashGrey
                                                  .copyWith(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                decorationColor: Colors.blue,
                                              ),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Defective',
                                              style: Styling.bodyTitle,
                                              textScaler: TextScaler.noScaling,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inward Stock',
                                      style: Styling.bodyTitleBigBoldDashGrey,
                                      textScaler: TextScaler.noScaling,
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
                                    Text(
                                      'Filled',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Invoice',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'EMR',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
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
                                      itemBuilder: (context, index) {
                                        // final items =
                                        // getCurrentStockDetailManager[
                                        // index];

                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.totalInvoiceCnt! >
                                            0 ||
                                            item.filledEMRCnt! > 0)
                                            .toList()[index];

                                        Color backgroundColor = (index %
                                            2 ==
                                            0)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.filledEMRCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                              )
                                  : Container(),
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
                                    Text(
                                      'Empty',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'TV',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      // itemCount: getCurrentStockDetailManager.length,
                                      itemCount:
                                      getCurrentStockDetailManager
                                          .where((item) =>
                                      item.emptyTVCnt! >
                                          0) // Filter items with defectivCnt > 0
                                          .length,
                                      itemBuilder: (context, index) {
                                        // final items =
                                        // getCurrentStockDetailManager[
                                        // index];

                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.emptyTVCnt! > 0)
                                            .toList()[index];

                                        Color backgroundColor = (index %
                                            2 ==
                                            1)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.emptyTVCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                              )
                                  : Container(),

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
                                    Text(
                                      'Defective',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Defective',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            // Expanded(
                                            //   flex: 1,
                                            //   child: Text(
                                            //     'Since',
                                            //     style: TextStyle(
                                            //       fontWeight:
                                            //       FontWeight.bold,
                                            //       color: Colors.black,
                                            //       fontSize: 14,
                                            //     ),
                                            //     textAlign:
                                            //     TextAlign.center,
                                            //     textScaler: TextScaler
                                            //         .noScaling,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      // itemCount: getCurrentStockDetailManager.length,
                                      itemCount:
                                      getCurrentStockDetailManager
                                          .where((item) =>
                                      item.defectivCnt! >
                                          0) // Filter items with defectivCnt > 0
                                          .length,
                                      itemBuilder: (context, index) {
                                        // final items =
                                        // getCurrentStockDetailManager[
                                        // index];

                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.defectivCnt! > 0)
                                            .toList()[index];

                                        Color backgroundColor = (index %
                                            2 ==
                                            1)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.defectivCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    // Expanded(
                                                    //   flex: 1,
                                                    //   child:
                                                    //   Text(
                                                    //     DateFormat('dd-MM-yyyy').format(DateTime.parse(items.defectivFromDate.toString() ??
                                                    //         '')),
                                                    //     style: Styling
                                                    //         .textFormText,
                                                    //     textAlign:
                                                    //     TextAlign.center,
                                                    //     textScaler:
                                                    //     TextScaler.noScaling,
                                                    //   ),
                                                    // ),
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
                              )
                                  : Container(),
                              // Title with larger font and a subtle shadow
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Space between icon and text
                                    Text(
                                      'Outward Stock',
                                      style: Styling.bodyTitleBigBoldDashGrey,
                                      textScaler: TextScaler.noScaling,
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
                                    Text(
                                      'Empty',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'CRD',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Defective',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      // itemCount: getCurrentStockDetailManager.length,
                                      itemCount:
                                      getCurrentStockDetailManager
                                          .where((item) =>
                                      item.emptyCRDCnt! > 0 ||
                                          item.emptyDefectivCnt! >
                                              0) // Filter items with defectivCnt > 0
                                          .length,
                                      itemBuilder: (context, index) {
                                        // final items =
                                        //     getCurrentStockDetailManager[
                                        //         index];

                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.emptyCRDCnt! > 0 ||
                                            item.emptyDefectivCnt! >
                                                0)
                                            .toList()[index];

                                        Color backgroundColor = (index %
                                            2 ==
                                            1)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.emptyCRDCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                              )
                                  : Container(),
                              // Title with larger font and a subtle shadow

                              getCurrentStockDetailManager.any((item) =>
                              item.sVQty! > 0 || item.refillSaleCnt! > 0)
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
                                    Text(
                                      'Refill Sale',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'SV',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Refill Sale',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      // itemCount: getCurrentStockDetailManager.length,
                                      itemCount:
                                      getCurrentStockDetailManager
                                          .where((item) =>
                                      item.sVQty! > 0 ||
                                          item.refillSaleCnt! > 0)
                                          .length,
                                      itemBuilder: (context, index) {
                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.sVQty! > 0 ||
                                            item.refillSaleCnt! > 0)
                                            .toList()[index];
                                        // final items =
                                        //     getCurrentStockDetailManager[
                                        //         index];
                                        Color backgroundColor = (index %
                                            2 ==
                                            1)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.sVQty
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.refillSaleCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                                    Text(
                                      'Imbalance',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        color: Color(0xFFfbe9e9),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Imbalance',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getCurrentStockDetailManager.isNotEmpty
                                        ? ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      NeverScrollableScrollPhysics(),
                                      // itemCount: getCurrentStockDetailManager.length,
                                      itemCount:
                                      getCurrentStockDetailManager
                                          .where((item) =>
                                      item.imbalanceCnt! >
                                          0) // Filter items with defectivCnt > 0
                                          .length,
                                      itemBuilder: (context, index) {
                                        final items =
                                        getCurrentStockDetailManager
                                            .where((item) =>
                                        item.imbalanceCnt! > 0)
                                            .toList()[index];
                                        // final items =
                                        //     getCurrentStockDetailManager[
                                        //         index];
                                        Color backgroundColor = (index %
                                            2 ==
                                            1)
                                            ? Color(
                                            0xFFfcf2f1) // Color for even index (first, third, fifth...)
                                            : Colors.white70!;
                                        return Container(
                                          color: backgroundColor,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.itemName
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        items.imbalanceCnt
                                                            .toString(),
                                                        style: Styling
                                                            .textFormText,
                                                        textAlign: TextAlign
                                                            .center,
                                                        textScaler:
                                                        TextScaler
                                                            .noScaling,
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
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    );
                }
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

  Future<void> fetchSVARBFilterCountList(String flag) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetDashboardProfitCount_Mob}/$distributorId/$flag'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("Request URL GetDashboardSVARBProfit_Mob: ${response.request}");
        print(
            "API Response Status GetDashboardSVARBProfit_Mob: ${response.statusCode}");
        print("API Response GetDashboardSVARBProfit_Mob: ${response.body}");
        if (response.statusCode == 200) {
          // final List<dynamic> data = json.decode(response.body);
          setState(() {

            try{
              final Map<String, dynamic> data = json.decode(response.body);
              svarbManagerDashboardCountModel = [
                GetSvarbManagerDashboardCountModel.fromJson(data)
              ];

              arbGrossRevenueCount = svarbManagerDashboardCountModel[0].aRBGrossRevenue?.toDouble();
              arbGrossProfitCount = svarbManagerDashboardCountModel[0].aRBGrossProfit?.toDouble();
              svGrossRevenueCount = svarbManagerDashboardCountModel[0].sVGrossRevenue?.toDouble();
              refillGrossRevenueCount = svarbManagerDashboardCountModel[0].refillGrossRevenue?.toDouble();
              refillGrossProfitCount = svarbManagerDashboardCountModel[0].refillGrossProfit?.toDouble();

              totalGrossProfit = svGrossRevenueCount! + arbGrossProfitCount! + refillGrossProfitCount!;
              debugPrint("totalGrossProfit $totalGrossProfit");
              getHeadWiseExpenseLstModel(flag);
              isLoading = false;
              EasyLoading.dismiss();
            }catch(e){
              debugPrint("exc $e");
            }

          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
          });
          // refreshTokens();
          // showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        if (mounted) {
          // Check if the widget is still mounted
          debugPrint("exxxe $e");
          setState(() {
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

  Future<void> getHeadWiseExpenseLstModel(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "FlagFor": flag,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetHeadWiseExpense}/$distributorId/$flag'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetHeadWiseExpense : " +
        '${AppUrl.GetHeadWiseExpense}/$distributorId/$flag');
    debugPrint("GetHeadWiseExpense : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        expenseReportModel = data.map((json) {
          return HeadWiseExpenseLstModel.fromJson(json);
        }).toList();

        totalExpenseForProfit = expenseReportModel.fold(0.0, (sum, item) {
          return sum! + (item.totExpAmt ?? 0.0);
        });
        incomeProfit = totalGrossProfit! - totalExpenseForProfit!;
        debugPrint("totalGrossProfit $totalGrossProfit");
        debugPrint("totalExpenseForProfit $totalExpenseForProfit");
        debugPrint("incomeProfit $incomeProfit");
        debugPrint("Total Expense: $totalExpenseForProfit");
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getUserDetail() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      roleId = preferences.getString('roleId');
      userActivet = preferences.getString('userActive');
      debugPrint("roleId $roleId");
      debugPrint(userActivet);

    } catch (error) {
      rethrow;
    }
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getFcmToken() async {
    String? token = await messaging.getToken();
    print("Firebase not initialize Token: $token");

    // Send token to backend API
  }

  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Check if the message contains a notification
      if (message.notification != null) {
        NotificationService.showNotification(
          message.notification!.title ?? 'Notification',
          message.notification!.body ?? '',
        );
      }

      // Optional: handle data messages as well
      if (message.data.isNotEmpty) {
        debugPrint('Foreground data message: ${message.data}');
      }
    });
  }

  Future<void> setupNotifications() async {
    final messaging = FirebaseMessaging.instance;

    // 1️⃣ Request permission (iOS + Android safe)
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2️⃣ iOS: wait until APNS token is ready
    if (Platform.isIOS) {
      String? apnsToken;
      int retry = 0;

      while (apnsToken == null && retry < 5) {
        apnsToken = await messaging.getAPNSToken();
        retry++;
        await Future.delayed(const Duration(seconds: 1));
      }

      if (apnsToken == null) {
        debugPrint("❌ APNS token not available");
        return;
      }

      debugPrint("✅ APNS token ready");
    }

    // 3️⃣ Now it's safe to get FCM token
    final fcmToken = await messaging.getToken();
    debugPrint("✅ FCM Token: $fcmToken");

    if (fcmToken != null) {
      await NotificationApiHelper.sendTokenToBackend();
    }

    // 4️⃣ Optional: listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      NotificationApiHelper.sendTokenToBackend();
    });
  }

  Widget showCardWithPunching(
      BuildContext context,
      void Function(void Function()) setModalState,
      ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cashmemo Punching',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8, // Adjust the scale value as needed
                    child: Row(
                      children: [
                        Switch(
                          value: isOn,
                          onChanged: (value) {
                            setModalState(() {
                              isOn = value; // Updates immediately in bottom sheet
                            });
                          },
                        ),
                        const SizedBox(width: 4), // Small spacing between switch and text
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _punchTableHeader(),

              const SizedBox(height: 8),

              getDashPunchSummaryCntModel.isNotEmpty
                  ? Column(
                children: getDashPunchSummaryCntModel.map((item) {
                  return Column(
                    children: [
                      _buildPunchRow1(
                        title: 'Manual',
                        today: !isOn
                            ? item.punchManToday
                            : item.punchManTodayPct,
                        month: !isOn
                            ? item.punchManAsOf
                            : item.punchManAsOfPct,
                        isPercentage: isOn,
                      ),
                      Divider(color: Colors.grey.shade300),
                      _buildPunchRow1(
                        title: 'OTP / DAC',
                        today: !isOn
                            ? item.punchDACToday
                            : item.punchDACTodayPct,
                        month: !isOn
                            ? item.punchDACAsOf
                            : item.punchDACAsOfPct,
                        isPercentage: isOn,
                      ),
                      Divider(color: const Color(0xFFfcf2f1)),
                    ],
                  );
                }).toList(),
              )
                  : _noDataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showCardWithBooking(
      BuildContext context,
      void Function(void Function()) setModalState,
      ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header Row with Switch
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Refill Booking',
              //       style: TextStyle(
              //         fontSize: 19,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     // Switch(
              //     //   value: isOn,
              //     //   onChanged: (value) {
              //     //     setModalState(() {
              //     //       isOn = value; // Use setModalState instead of setState
              //     //     });
              //     //   },
              //     // ),
              //     Transform.scale(
              //       scale: 0.8, // Adjust the scale value as needed
              //       child: Column(
              //         children: [
              //           Switch(
              //             value: isOn,
              //             onChanged: (value) {
              //               setModalState(() {
              //                 isOn = value; // Use setModalState instead of setState
              //               });
              //             },
              //           ),
              //          // const SizedBox(width: 2), // Small spacing between switch and text
              //           const Text(
              //             '%',
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Refill Booking',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8, // Adjust the scale value as needed
                    child: Row(
                      children: [
                        Switch(
                          value: isOnBook,
                          onChanged: (value) {
                            setModalState(() {
                              isOnBook = value; // Updates immediately in bottom sheet
                            });
                          },
                        ),
                        const SizedBox(width: 4), // Small spacing between switch and text
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _punchTableHeader(),

              const SizedBox(height: 8),

              getDashPunchSummaryCntModel.isNotEmpty
                  ? Column(
                children: getDashPunchSummaryCntModel.map((item) {
                  return Column(
                    children: [
                      _buildPunchRow1(
                        title: 'Manual',
                        today: !isOnBook
                            ? item.bkgManToday
                            : item.bkgManTodayPct,
                        month: !isOnBook
                            ? item.bkgManAsOf
                            : item.bkgManAsOfPct,
                        isPercentage: isOnBook,
                      ),
                      Divider(color: Colors.grey.shade300),
                      _buildPunchRow1(
                        title: 'Online',
                        today: !isOnBook
                            ? item.bkgOnlineToday
                            : item.bkgOnlineTodayPct,
                        month: !isOnBook
                            ? item.bkgOnlineAsOf
                            : item.bkgOnlineAsOfPct,
                        isPercentage: isOnBook,
                      ),
                      Divider(color: const Color(0xFFfcf2f1)),
                    ],
                  );
                }).toList(),
              )
                  : _noDataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _punchTableHeader() {
    return Container(
      color: const Color(0xFFEFF2FB),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '',
              style: Styling.bodyTitleWithBlueHightDashboard,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Today',
              textAlign: TextAlign.center,
              style: Styling.bodyTitleWithBlueHightDashboard,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'This Month',
              textAlign: TextAlign.center,
              style: Styling.bodyTitleWithBlueHightDashboard,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchRow1({
    required String title,
    required dynamic today,
    required dynamic month,
    required bool isPercentage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          /// Title
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: Styling.bodyTitleWithBlueHightDashboard,
              textScaler: TextScaler.noScaling,
            ),
          ),

          /// Today
          Expanded(
            flex: 3,
            child: Text(
              _formatValue(today, isPercentage),
              textAlign: TextAlign.center,
              style: Styling.blueClrText,
              textScaler: TextScaler.noScaling,
            ),
          ),

          /// This Month
          Expanded(
            flex: 3,
            child: Text(
              _formatValue(month, isPercentage),
              textAlign: TextAlign.center,
              style: Styling.blueClrText,
              textScaler: TextScaler.noScaling,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
    );
  }

  String _formatValue(dynamic value, bool isPercentage) {
    if (value == null) return '0';

    if (isPercentage && value is num) {
      if (value % 1 == 0) {
        return value.toInt().toString(); // remove .0
      }
      return value.toString(); // keep decimal as-is
    }

    return value.toString();
  }

  Future<void> getDashPunchSummaryCntModeldata() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetDashPunchSummaryCnt}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDashPunchSummaryCnt : " +
        '${AppUrl.GetDashPunchSummaryCnt}/$distributorId');
    debugPrint("GetDashPunchSummaryCnt : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        getDashPunchSummaryCntModel = data.map((json) {
          return GetDashPunchSummaryCntModel.fromJson(json);
        }).toList();

        // totalExpenseForProfit = expenseReportModel.fold(0.0, (sum, item) {
        //   return sum! + (item.totExpAmt ?? 0.0);
        // });
        // incomeProfit = totalGrossProfit! - totalExpenseForProfit!;
        // debugPrint("totalGrossProfit $totalGrossProfit");
        // debugPrint("totalExpenseForProfit $totalExpenseForProfit");
        // debugPrint("incomeProfit $incomeProfit");
        // debugPrint("Total Expense: $totalExpenseForProfit");
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }


}


