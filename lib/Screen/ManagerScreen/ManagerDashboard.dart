import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import '../../newTheam/features/dashboard/models/dashboard_models.dart';
import '../../newTheam/features/dashboard/widgets/alert_action_card.dart';
import '../../newTheam/features/dashboard/widgets/kpi_card.dart';
import '../../newTheam/features/dashboard/widgets/mini_card_grid.dart';
import '../../newTheam/features/dashboard/widgets/profit_summary_card.dart';
import '../../newTheam/features/dashboard/widgets/section_header.dart';
import '../../newTheam/features/dashboard/widgets/stock_progress_card.dart';
import '../ConstantScreen/widgets.dart';
import '../IOSVersionUpdateService.dart';
import '../PushNotification/NotificationApiHelper.dart';
import '../PushNotification/NotificationService.dart';
import '../UndocumentedSVDash/DashboardUndocumentedDetails.dart';
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
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
import 'GetDashPuchSummaryCntModel.dart';
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


// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  int? totalCurrentStockFilledTotal = 0;
  int? totalCurrentStockEmptyTotal = 0;
  int? totalCurrentStockDefectiveTotal = 0;
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
  bool _bottomSheetOpened = false;
  bool _sheetOpened = false;
  bool _cashmemoSheetOpened = false;
  bool _refillBookingSheetOpened = false;
  bool _prepaidSheetOpened = false;
  bool _SettlementSheetOpened = false;
  int? punchManAsOf;
  int? punchManToday;
  double? punchManTodayPct;
  double? punchManAsOfPct;
  int? punchDACToday;
  int? punchDACAsOf;
  double? punchDACTodayPct;
  double? punchDACAsOfPct;
  int? bkgManToday;
  int? bkgManAsOf;
  double? bkgManTodayPct;
  double? bkgManAsOfPct;
  int? bkgOnlineToday;
  int? bkgOnlineAsOf;
  double? bkgOnlineTodayPct;
  double? bkgOnlineAsOfPct;
  // final GlobalKey _financialOverviewKey = GlobalKey();
  // final GlobalKey _inventorySectionKey = GlobalKey();
  // final ScrollController _scrollController = ScrollController();


  // void _scrollToInventorySection() {
  //   final context = _inventorySectionKey.currentContext;
  //
  //   if (context != null) {
  //     Scrollable.ensureVisible(
  //       context,
  //       duration: const Duration(milliseconds: 600),
  //       curve: Curves.easeInOut,
  //       alignment: 0.1,
  //     );
  //   }
  // }

  // void _scrollToInventorySection() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final context = _inventorySectionKey.currentContext;
  //     if (context == null) return;
  //
  //     final box = context.findRenderObject() as RenderBox;
  //     final position = box.localToGlobal(Offset.zero);
  //
  //     final offset = _scrollController.offset +
  //         position.dy -
  //         MediaQuery.of(context).padding.top -
  //         120; // adjust header height
  //
  //     _scrollController.animateTo(
  //       offset.clamp(0.0, _scrollController.position.maxScrollExtent),
  //       duration: const Duration(milliseconds: 600),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  // void _scrollToInventorySection() {
  //   final ctx = _inventorySectionKey.currentContext;
  //   if (ctx == null) return;
  //
  //   Scrollable.ensureVisible(
  //     ctx,
  //     duration: const Duration(milliseconds: 600),
  //     curve: Curves.easeInOut,
  //     alignment: 0.0, // align to top of viewport
  //   );
  // }


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
    getDashPunchSummaryCntModeldata();
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
  String staffName = '';
  String distributorName = '';
  // ─── NEW-THEME BUILD METHOD ─────────────────────────────────────────────────
  // All business logic, variables, API calls unchanged.
  // Only UI/UX styling matches NewTheme design system.
  // ────────────────────────────────────────────────────────────────────────────

  /// Returns section-header widget matching newTheme SectionHeader pattern.
  Widget _sectionHeader(String title, Color dotColor, {String? actionLabel, VoidCallback? onAction}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: AppTypography.sectionHeader,
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(actionLabel, style: AppTypography.seeAll),
              ),
            ),
        ],
      ),
    );
  }

  /// Returns a themed KPI card matching newTheme KpiCard pattern.
  Widget _kpiCard({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
    required String subtitle,
    required String badgeLabel,
    required Color badgeBg,
    required Color badgeFg,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.blueXXL,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D1E3A8A),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: AppColors.blue, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: AppTypography.labelMD),
                        const SizedBox(height: 3),
                        Text(value, style: AppTypography.kpiValueLG),
                        const SizedBox(height: 4),
                        Text(subtitle, style: AppTypography.cardSubtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(badgeLabel, style: AppTypography.badgeText.copyWith(color: badgeFg)),
                      ),
                      const SizedBox(height: 8),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a themed mini-card matching newTheme MiniCard pattern.
  Widget _miniCard({
    required String label,
    required String value,
    required Color valueColor,
    required String sub,
    Gradient? gradient,
    VoidCallback? onTap,
    bool isActionCard = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 90),
          decoration: BoxDecoration(
            color: gradient == null ? AppColors.white : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 10, offset: Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(), style: AppTypography.miniLabel),
              isActionCard
                  ? Text(value, style: AppTypography.cardTitle.copyWith(color: valueColor, fontSize: 16))
                  : Text(value, style: AppTypography.miniValue.copyWith(color: valueColor)),
              Text(sub, style: AppTypography.miniLabel),
            ],
          ),
        ),
      ),
    );
  }

  /// Two-column mini card grid.
  // Widget _miniCardRow({
  //   required String leftLabel, required String leftValue, required Color leftValueColor,
  //   required String leftSub, Gradient? leftGradient, VoidCallback? leftTap, bool leftIsAction = false,
  //   required String rightLabel, required String rightValue, required Color rightValueColor,
  //   required String rightSub, Gradient? rightGradient, VoidCallback? rightTap, bool rightIsAction = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: Row(
  //       children: [
  //         Expanded(child: _miniCard(label: leftLabel, value: leftValue, valueColor: leftValueColor, sub: leftSub, gradient: leftGradient, onTap: leftTap, isActionCard: leftIsAction)),
  //         const SizedBox(width: 10),
  //         Expanded(child: _miniCard(label: rightLabel, value: rightValue, valueColor: rightValueColor, sub: rightSub, gradient: rightGradient, onTap: rightTap, isActionCard: rightIsAction)),
  //       ],
  //     ),
  //   );
  // }

  Widget _miniCardRow({
    required String leftLabel, required String leftValue, required Color leftValueColor,
    required String leftSub, Gradient? leftGradient, VoidCallback? leftTap, bool leftIsAction = false,
    required String rightLabel, required String rightValue, required Color rightValueColor,
    required String rightSub, Gradient? rightGradient, VoidCallback? rightTap, bool rightIsAction = false,
    bool rightHide = false, // 👈 add this
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _miniCard(label: leftLabel, value: leftValue, valueColor: leftValueColor, sub: leftSub, gradient: leftGradient, onTap: leftTap, isActionCard: leftIsAction)),
          if (!rightHide) ...[
            const SizedBox(width: 10),
            Expanded(child: _miniCard(label: rightLabel, value: rightValue, valueColor: rightValueColor, sub: rightSub, gradient: rightGradient, onTap: rightTap, isActionCard: rightIsAction)),
          ],
        ],
      ),
    );
  }

  /// Data row for DataListCard pattern.
  Widget _dataListCard(List<_DataRow> rows) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return _buildDataRow(e.value, !isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildDataRow(_DataRow item, bool showDivider) {
    return InkWell(
      onTap: item.onTap != null ? item.onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          border: showDivider ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: item.dotColor, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: AppTypography.dataRowLabel),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: AppTypography.cardSubtitle),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(item.value, style: AppTypography.dataRowValue),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(color: item.badgeBg, borderRadius: BorderRadius.circular(20)),
              child: Text(item.badgeLabel, style: AppTypography.badgeText.copyWith(color: item.badgeFg)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    formattedDate = settlementPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(settlementPendSince!))
        : 'No Date';
    formattedDatecdcms = cDCMDPendSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(cDCMDPendSince!))
        : 'No Date';
    totalPendingSettSinceDate = totalPendingSettSince != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(totalPendingSettSince!))
        : 'No Date';
    final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.bg2,
        body: RefreshIndicator(
          color: AppColors.blue,
          backgroundColor: AppColors.white,
          onRefresh: _onRefresh,
          edgeOffset: MediaQuery.of(context).padding.top + 200,
          child: CustomScrollView(
            // controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // ── Hero Strip ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHeroStrip(),
              ),

              // ── Body Content ────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                   delegate: SliverChildListDelegate([

                    // ════════════════════════════════════════════════════════
                    // SEQUENCE MIRRORS dashboard_screen.dart
                    // ════════════════════════════════════════════════════════

                    // ── 1. NEEDS ATTENTION ───────────────────────────────────
                    // Mirrors: SectionHeader('Needs Attention', red) + AlertActionCard list
                    SectionHeader(
                      title: 'Needs Attention',
                      dotColor: AppColors.red,
                    ),
                    ...() {
                      final List<AlertItem> _alerts = [
                        AlertItem(
                          title: 'Outstanding Settlement',
                          subtitle: totalPendAmount > 0
                              ? 'Pending since $totalPendingSettSinceDate'
                              : 'Settlement pending',
                          value: '₹${formatCurrency(totalPendAmount)}',
                          severity: totalPendAmount > 0 ? AlertSeverity.danger : AlertSeverity.info,
                          icon: Icons.account_balance_wallet_outlined,
                          onTap: () => showBottomSheetPrepaidSettlementStatus(context),
                        ),
                        AlertItem(
                          title: 'Postpaid Verification',
                          subtitle: 'Amount: ₹${formatCurrency(postPaidVerifPendAmt?.toDouble() ?? 0.0)}',
                          value: '${postPaidVerifPend ?? 0} cases',
                          severity: (postPaidVerifPend ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
                          icon: Icons.verified_outlined,
                          onTap: (postPaidVerifPend ?? 0) > 0
                              ? () => Navigator.pushNamed(context,
                                  DashboardPostPaidVerifPendDetails.screenName,
                                  arguments: {'flag': 'All'})
                              : null,
                        ),
                        AlertItem(
                          title: 'Undocumented SV',
                          subtitle: 'Stock verifications not yet documented',
                          value: '${UndocumentedSV ?? 0}',
                          severity: (UndocumentedSV ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
                          icon: Icons.inventory_2_outlined,
                          onTap: (UndocumentedSV ?? 0) > 0
                              ? () => Navigator.pushNamed(context,
                                  DashboardUndocumentedDetails.screenName,
                                  arguments: {'flag': 0})
                              : null,
                        ),
                        AlertItem(
                          title: 'Total Imbalance Stock',
                          subtitle: 'Cumulative stock imbalance as of date',
                          value: '${asOfDateImbQtyShow ?? 0} units',
                          severity: (asOfDateImbQtyShow ?? 0) > 0 ? AlertSeverity.danger : AlertSeverity.info,
                          icon: Icons.warning_amber_rounded,
                          onTap: () => showCardWithImbalanceStock(context),
                        ),
                        AlertItem(
                          title: 'Vendor Payment Due',
                          subtitle: 'Total vendor due amount',
                          value: '₹${formatCurrency(TotalVendorDueAmt?.toDouble() ?? 0.0)}',
                          severity: (TotalVendorDueAmt ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
                          icon: Icons.account_balance_wallet_outlined,
                          onTap: (TotalVendorDueAmt ?? 0) > 0
                              ? () => Navigator.pushNamed(context, VendorPaymentDetailListUI.screenName)
                              : null,
                        ),
                      ];
                      return _alerts.asMap().entries.map((e) => AlertActionCard(
                        item: e.value,
                        animationDelay: Duration(milliseconds: 80 * e.key),
                      ));
                    }(),

                    _sectionHeader('Financial Overview', AppColors.blueLight,
                        actionLabel: '', onAction: null),
                    _kpiCard(
                      icon: Icons.receipt_long_outlined,
                      iconBg: AppColors.orangeXL,
                      label: "Today's Expenses",
                      value: totalExpense != null ? '₹${formatIndianCurrency(totalExpense!)}' : '₹0',
                      subtitle: 'Tap to view expense breakdown',
                      badgeLabel: 'Expenses',
                      badgeBg: AppColors.orangeXL,
                      badgeFg: AppColors.orange,
                      onTap: roleId == Constants.roleIdOwner
                          ? () => Navigator.pushNamed(context, ExpensesScreenUI.screenName)
                          : null,
                    ),

                     // Container(
                     //   key: _financialOverviewKey,
                     //   child: Column(
                     //     crossAxisAlignment: CrossAxisAlignment.start,
                     //     children: [
                     //
                     //       _sectionHeader(
                     //         'Financial Overview',
                     //         AppColors.blueLight,
                     //         actionLabel: '',
                     //         onAction: null,
                     //       ),
                     //
                     //       _kpiCard(
                     //         icon: Icons.receipt_long_outlined,
                     //         iconBg: AppColors.orangeXL,
                     //         label: "Today's Expenses",
                     //         value: totalExpense != null
                     //             ? '₹${formatIndianCurrency(totalExpense!)}'
                     //             : '₹0',
                     //         subtitle: 'Tap to view expense breakdown',
                     //         badgeLabel: 'Expenses',
                     //         badgeBg: AppColors.orangeXL,
                     //         badgeFg: AppColors.orange,
                     //         onTap: roleId == Constants.roleIdOwner
                     //             ? () => Navigator.pushNamed(
                     //           context,
                     //           ExpensesScreenUI.screenName,
                     //         )
                     //             : null,
                     //       ),
                     //     ],
                     //   ),
                     // ),

                    _kpiCard(
                      icon: Icons.account_balance_outlined,
                      iconBg: AppColors.tealXL,
                      label: "Today's On Account",
                      value: onAccountToday != null ? '₹${formatCurrency(onAccountToday!)}' : '₹0',
                      subtitle: 'Cash collected on account today',
                      badgeLabel: 'On Account',
                      badgeBg: AppColors.tealXL,
                      badgeFg: AppColors.teal,
                      onTap: () => Navigator.pushNamed(context,
                          TodaysCashSummaryOnAccountList.screenName,
                          arguments: {'onAccount': onAccountAsOfDate}),
                    ),
                    _kpiCard(
                      icon: Icons.savings_outlined,
                      iconBg: AppColors.blueXL,
                      label: 'Total On Account',
                      value: onAccountAsOfDate != null ? '₹${formatCurrency(onAccountAsOfDate!)}' : '₹0',
                      subtitle: 'Cumulative outstanding on account',
                      badgeLabel: 'Cumulative',
                      badgeBg: AppColors.blueXXL,
                      badgeFg: AppColors.blue,
                      onTap: () => Navigator.pushNamed(context,
                          TodaysCashSummaryOnAccountList.screenName,
                          arguments: {'onAccount': onAccountAsOfDate}),
                    ),
                    _kpiCard(
                      icon: Icons.pending_actions_outlined,
                      iconBg: AppColors.redXL,
                      label: 'Credit Sale Outstanding',
                      value: '₹${formatCurrency(TotalCrdtOutstd?.toDouble() ?? 0.0)}',
                      subtitle: 'Total outstanding credit amount',
                      badgeLabel: (TotalCrdtOutstd ?? 0) > 0 ? 'Pending' : 'Clear ✓',
                      badgeBg: (TotalCrdtOutstd ?? 0) > 0 ? AppColors.redXL : AppColors.greenXL,
                      badgeFg: (TotalCrdtOutstd ?? 0) > 0 ? AppColors.red : AppColors.green,
                      onTap: (TotalCrdtOutstd ?? 0) > 0
                          ? () => Navigator.pushNamed(context, CreditSaleCountDetailListUI.screenName)
                          : null,
                    ),
                    // Vendor Payment Due removed from here — moved to Needs Attention

                    // ── 3. INVENTORY & STOCK ─────────────────────────────────
                    _sectionHeader('Inventory & Stock', AppColors.teal,
                        actionLabel: '',
                        onAction: () => showStockStatus(context)),

                     // Container(
                     //   key: _inventorySectionKey,
                     //   child: Column(
                     //     crossAxisAlignment: CrossAxisAlignment.start,
                     //     children: [
                     //       _sectionHeader(
                     //         'Inventory & Stock',
                     //         AppColors.teal,
                     //         actionLabel: '',
                     //         onAction: () => showStockStatus(context),
                     //       ),
                     //       // Stock Progress Card
                     //       SizedBox(width: double.infinity, child: _buildStockProgressCard()),
                     //       // Imbalance MiniCardGrid
                     //       _miniCardRow(
                     //         leftLabel: "Today's Imbalance",
                     //         leftValue: todaysImbQtyShow.toString(),
                     //         leftValueColor: AppColors.blueLight,
                     //         leftSub: 'Units today',
                     //         leftTap: () => showCardWithImbalanceStock(context),
                     //         rightLabel: 'Total Imbalance',
                     //         rightValue: asOfDateImbQtyShow.toString(),
                     //         rightValueColor: (asOfDateImbQtyShow ?? 0) > 0 ? AppColors.red : AppColors.green,
                     //         rightSub: (asOfDateImbQtyShow ?? 0) > 0 ? 'Needs review' : 'All clear',
                     //         rightTap: () => showCardWithImbalanceStock(context),
                     //       ),
                     //     ],
                     //   ),
                     // ),

                    // Stock Progress Card (Cylinder Status) ──────────────────
                    SizedBox(width: double.infinity,child: _buildStockProgressCard()),
                    // Imbalance MiniCardGrid ───────────────────────────────────
                    _miniCardRow(
                      leftLabel: "Today's Imbalance",
                      leftValue: todaysImbQtyShow.toString(),
                      leftValueColor: AppColors.blueLight,
                      leftSub: 'Units today',
                      leftTap: () => showCardWithImbalanceStock(context),
                      rightLabel: 'Total Imbalance',
                      rightValue: asOfDateImbQtyShow.toString(),
                      rightValueColor: (asOfDateImbQtyShow ?? 0) > 0 ? AppColors.red : AppColors.green,
                      rightSub: (asOfDateImbQtyShow ?? 0) > 0 ? 'Needs review' : 'All clear',
                      rightTap: () => showCardWithImbalanceStock(context),
                    ),
                    // Stock Difference (CDCMS) ─────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Stock Difference (CDCMS)',
                                    style: AppTypography.cardTitle,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                SizedBox(
                                  width: 140,
                                  height: 40,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<num>(
                                      isExpanded: true,
                                      value: selectedItemIdCDCMS,
                                      style: AppTypography.cardTitle.copyWith(
                                        color: AppColors.blue,
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.blue,
                                      ),
                                      items: getManagerDashboarDetailItemWise.map((item) {
                                        return DropdownMenuItem<num>(
                                          value: item.itemId,
                                          child: Text(
                                            item.itemName ?? 'Unknown',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: AppTypography.cardSubtitle,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedItemIdCDCMS = value!.toInt();

                                          final sel =
                                          getManagerDashboarDetailItemWise.firstWhere(
                                                (item) =>
                                            item.itemId == selectedItemIdCDCMS,
                                            orElse: () =>
                                                GetDashSummaryItemWiseForMgrModel(),
                                          );

                                          cdcmsFilledDiffShow =
                                              sel.filledDiff?.toInt() ?? 0;

                                          cdcmsEmptyDiffShow =
                                              sel.emptyDiff?.toInt() ?? 0;

                                          cdcmsDefectiveDiffShow =
                                              sel.defectiveDiff?.toInt() ?? 0;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(child: _stockDiffBox('Filled', cdcmsFilledDiffShow.toString(), AppColors.green, AppColors.greenXL)),
                                const SizedBox(width: 10),
                                Expanded(child: _stockDiffBox('Empty', cdcmsEmptyDiffShow.toString(), AppColors.orange, AppColors.orangeXL)),
                                const SizedBox(width: 10),
                                Expanded(child: _stockDiffBox('Defective', cdcmsDefectiveDiffShow.toString(), AppColors.red, AppColors.redXL)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── 4. BOOKINGS & OPERATIONS ─────────────────────────────
                    // Mirrors: SectionHeader('Bookings & Operations', orange) +
                    //          DataListCard(SV/TV/Unsettled) + MiniCardGrid(Refill/Cashmemo)
                    _sectionHeader('Bookings & Operations', AppColors.orange,
                        actionLabel: '', onAction: null),
                    _dataListCard([
                      _DataRow(
                        label: 'SV Pending Status',
                        subtitle: 'Stock verification orders',
                        value: sVPendingStk != null ? sVPendingStk.toString() : '0',
                        dotColor: AppColors.blueLight,
                        badgeLabel: 'SV',
                        badgeBg: AppColors.blueXL,
                        badgeFg: AppColors.blue,
                        onTap: () => Navigator.pushNamed(context,
                            DashboardSVDetails.screenName, arguments: {'flag': 0}),
                      ),
                      _DataRow(
                        label: 'TV Pending Status',
                        subtitle: 'Transfer vehicle orders',
                        value: tVPendingStk != null ? tVPendingStk.toString() : '0',
                        dotColor: AppColors.teal,
                        badgeLabel: 'TV',
                        badgeBg: AppColors.tealXL,
                        badgeFg: AppColors.teal,
                        onTap: () => Navigator.pushNamed(context,
                            DashboardTVDetails.screenName, arguments: {'flag': 0}),
                      ),
                      _DataRow(
                        label: 'Unsettled Sales',
                        subtitle: 'Count (DM wise) · ₹${formatCurrency(totalAmount ?? 0)}',
                        value: (deliveryMenCount ?? 0).toString(),
                        dotColor: AppColors.orange,
                        badgeLabel: (deliveryMenCount ?? 0) == 0 ? 'Clear ✓' : 'Pending',
                        badgeBg: (deliveryMenCount ?? 0) == 0 ? AppColors.greenXL : AppColors.orangeXL,
                        badgeFg: (deliveryMenCount ?? 0) == 0
                            ? const Color(0xFF166534)
                            : const Color(0xFF9A3412),
                        onTap: (deliveryMenCount ?? 0) > 0
                            ? () => Navigator.pushNamed(context, UnsettledSaleDetailList.screenName)
                            : null,
                      ),
                      _DataRow(
                        label: 'Prepaid Punching — Today',
                        subtitle: 'Tap to view punching details',
                        value: (todaysPunchingInNiyojanC ?? 0).toString(),
                        dotColor: AppColors.blue,
                        badgeLabel: 'Prepaid',
                        badgeBg: AppColors.blueXL,
                        badgeFg: AppColors.blue,
                        onTap: () => showBottomSheet(context),
                      ),
                    ]),
                    // Refill Booking + Cashmemo MiniCardGrid ──────────────────
                    _miniCardRow(
                      leftLabel: 'Refill Booking',
                      leftValue: 'Punch Now',
                      leftValueColor: AppColors.blueLight,
                      leftSub: '🆕 New feature',
                      leftIsAction: true,
                      leftGradient: const LinearGradient(
                        colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      leftTap: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: AppColors.blue.withOpacity(0.5),
                          builder: (ctx) => StatefulBuilder(
                            builder: (ctx, setM) => GestureDetector(
                              onTap: () {},
                              child: showCardWithBooking(ctx, setM),
                            ),
                          ),
                        );
                      },
                      rightLabel: 'Cashmemo',
                      rightValue: 'Punch Now',
                      rightValueColor: AppColors.teal,
                      rightSub: 'Quick entry',
                      rightIsAction: true,
                      rightGradient: const LinearGradient(
                        colors: [Color(0xFFF0FDFA), Color(0xFFCCFBF1)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      rightTap: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: AppColors.blue.withOpacity(0.5),
                          builder: (ctx) => StatefulBuilder(
                            builder: (ctx, setM) => GestureDetector(
                              onTap: () {},
                              child: showCardWithPunching(ctx, setM),
                            ),
                          ),
                        );
                      },
                    ),

                    // ── 5. THIS MONTH'S PERFORMANCE (Owner Only) ─────────────
                    // Mirrors: SectionHeader("This Month's Performance", green) +
                    //          ProfitSummaryCard
                    if (roleId == Constants.roleIdOwner) ...[
                      // Section header with period dropdown replacing pill tabs
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "THIS MONTH'S PERFORMANCE",
                              style: AppTypography.sectionHeader,
                            ),
                            const Spacer(),
                            // Dropdown replacing the "View All ›" / pill tabs
                            Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.blueXL,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.blueXXL, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedTransMode,
                                  isDense: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blue, size: 16),
                                  style: AppTypography.badgeText.copyWith(color: AppColors.blue),
                                  items: getTransMode.map((mode) {
                                    return DropdownMenuItem<String>(
                                      value: mode,
                                      child: Text(mode, style: AppTypography.badgeText.copyWith(color: AppColors.blue)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      selectedTransMode = value;
                                      if (value == "Today's") dayFlag = "TODAYS";
                                      else if (value == "This Month") dayFlag = "THISMONTH";
                                      else if (value == "Financial Year") dayFlag = "FINYEAR";
                                      else dayFlag = "";
                                      fetchSVARBFilterCountList(dayFlag!);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Profit Summary Card (matches ProfitSummaryCard layout)
                      _buildProfitTableCard(),
                    ],

                    // ════════════════════════════════════════════════════════
                    // REMAINING MANAGER-SPECIFIC SECTIONS (below all above)
                    // ════════════════════════════════════════════════════════

                    // ── 6. PREPAID STATUS ────────────────────────────────────
                    _sectionHeader('Prepaid Status', AppColors.blue),
                    _dataListCard([
                      _DataRow(
                        label: "Today's Punched",
                        subtitle: 'Prepaid bookings punched today in Niyojan',
                        value: (todaysPunchingInNiyojanC ?? 0).toString(),
                        dotColor: AppColors.blueLight,
                        badgeLabel: 'Today',
                        badgeBg: AppColors.blueXL,
                        badgeFg: AppColors.blue,
                        onTap: () => showBottomSheet(context),
                      ),
                      _DataRow(
                        label: 'Outstanding Settlement',
                        subtitle: totalPendingSettSinceDate != null
                            ? 'Since $totalPendingSettSinceDate'
                            : 'Tap to view settlement list',
                        value: '₹${formatCurrency(totalPendAmount)}',
                        dotColor: totalPendAmount > 0 ? AppColors.red : AppColors.green,
                        badgeLabel: totalPendAmount > 0 ? 'Pending' : 'Clear ✓',
                        badgeBg: totalPendAmount > 0 ? AppColors.redXL : AppColors.greenXL,
                        badgeFg: totalPendAmount > 0 ? AppColors.red : AppColors.green,
                        onTap: () => showBottomSheetPrepaidSettlementStatus(context),
                      ),
                    ]),

                    // ── 7. MORE (Navigation shortcuts) ──────────────────────
                    _sectionHeader('More', AppColors.textMuted),
                    // _miniCardRow(
                    //   leftLabel: 'Stock Status',
                    //   leftValue: 'View ›',
                    //   leftValueColor: AppColors.blue,
                    //   leftSub: 'Current inventory details',
                    //   leftIsAction: true,
                    //   leftGradient: const LinearGradient(
                    //     colors: [AppColors.blueXL, AppColors.blueXXL],
                    //     begin: Alignment.topLeft, end: Alignment.bottomRight,
                    //   ),
                    //   leftTap: () => showStockStatus(context),
                    //   rightLabel: 'Sales Comparison',
                    //   rightValue: 'View ›',
                    //   rightValueColor: AppColors.teal,
                    //   rightSub: 'Monthly sales analytics',
                    //   rightIsAction: true,
                    //   rightGradient: const LinearGradient(
                    //     colors: [AppColors.tealXL, AppColors.tealXXL],
                    //     begin: Alignment.topLeft, end: Alignment.bottomRight,
                    //   ),
                    //   rightTap: roleId == Constants.roleIdOwner
                    //       ? () => Navigator.pushNamed(context, SalesComparisonScreen.screenName)
                    //       : null,
                    // ),

                     _miniCardRow(
                       leftLabel: 'Stock Status',
                       leftValue: 'View ›',
                       leftValueColor: AppColors.blue,
                       leftSub: 'Current inventory details',
                       leftIsAction: true,
                       leftGradient: const LinearGradient(
                         colors: [AppColors.blueXL, AppColors.blueXXL],
                         begin: Alignment.topLeft, end: Alignment.bottomRight,
                       ),
                       leftTap: () => showStockStatus(context),
                       rightLabel: 'Sales Comparison',
                       rightValue: 'View ›',
                       rightValueColor: AppColors.teal,
                       rightSub: 'Monthly sales analytics',
                       rightIsAction: true,
                       rightGradient: const LinearGradient(
                         colors: [AppColors.tealXL, AppColors.tealXXL],
                         begin: Alignment.topLeft, end: Alignment.bottomRight,
                       ),
                       rightTap: () => Navigator.pushNamed(context, SalesComparisonScreen.screenName),
                       rightHide: roleId != Constants.roleIdOwner,
                     ),

                    const SizedBox(height: 8),
                  ]),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return
                  Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.refresh_rounded, color: Color(0xFF1E3A8A), size: 26),
                        ),
                        const SizedBox(height: 16),
                        const Text("Confirm Refresh",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                            textScaler: TextScaler.noScaling),
                        const SizedBox(height: 8),
                        const Text("Do you want to refresh data?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
                            textScaler: TextScaler.noScaling),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("No",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                                    textScaler: TextScaler.noScaling),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() { _onRefresh(); });
                                },
                                child: const Text("Yes",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                    textScaler: TextScaler.noScaling),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      );
  }

  // ── Hero Strip ─────────────────────────────────────────────────────────────
  Widget _buildHeroStrip() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DashFlowPainter())),
          Positioned(
            top: -50, right: -70,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
            ),
          ),
          Positioned(
            bottom: -40, left: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tealLight.withOpacity(0.12)),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: greeting + avatar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}, ${staffName.isNotEmpty ? staffName : 'Manager'} 👋',
                              style: AppTypography.heroSubtitle,
                            ),
                            const SizedBox(height: 4),
                            Text(distributorName.isNotEmpty ? distributorName : 'Niyojan LPG', style: AppTypography.heroTitle),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                              style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          () {
                            final parts = staffName.trim().split(RegExp(r'\s+'));
                            if (parts.length >= 2) {
                              return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                            } else if (parts.isNotEmpty && parts[0].length >= 2) {
                              return parts[0].substring(0, 2).toUpperCase();
                            }
                            return 'M';
                          }(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // KPI row: Today's Revenue + Cylinders Filled (matches DashboardHeroStrip)
                  Row(
                    children: [
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: _scrollToFinancialOverview,
                      //   child: _heroKpiChip(
                      //     label: "Today's Revenue",
                      //     value: totalIncome != null && totalIncome! > 0
                      //         ? '₹${formatIndianCurrency(totalIncome!)}'
                      //         : '₹0',
                      //     sub: totalIncome != null && totalIncome! > 0
                      //         ? 'Gross revenue'
                      //         : 'No bookings yet',
                      //     badgeLabel: totalIncome != null && totalIncome! > 0 ? '▲ Live' : '▼ No data',
                      //     badgeIsGood: totalIncome != null && totalIncome! > 0,
                      //   ),
                      //   ),
                      // ),
                      Expanded(
                        child: _heroKpiChip(
                          label: "Today's Revenue",
                          value: totalIncome != null && totalIncome! > 0
                              ? '₹${formatIndianCurrency(totalIncome!)}'
                              : '₹0',
                          sub: totalIncome != null && totalIncome! > 0
                              ? 'Gross revenue'
                              : 'No bookings yet',
                          badgeLabel: totalIncome != null && totalIncome! > 0 ? '▲ Live' : '▼ No data',
                          badgeIsGood: totalIncome != null && totalIncome! > 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _heroKpiChip(
                          label: 'Cylinders Filled',
                          value: (totalCurrentStockFilledTotal ?? 0).toString(),
                          sub: '${totalCurrentStockEmptyTotal ?? 0} empty · ${totalCurrentStockDefectiveTotal ?? 0} defective',
                          badgeLabel: (totalCurrentStockFilledTotal ?? 0) > 0 ? '✓ Good stock' : 'Low stock',
                          badgeIsGood: (totalCurrentStockFilledTotal ?? 0) > 0,
                        ),
                      ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: _scrollToInventorySection,
                      //     child: _heroKpiChip(
                      //       label: 'Cylinders Filled',
                      //       value: (totalCurrentStockFilledTotal ?? 0).toString(),
                      //       sub:
                      //       '${totalCurrentStockEmptyTotal ?? 0} empty · ${totalCurrentStockDefectiveTotal ?? 0} defective',
                      //       badgeLabel: (totalCurrentStockFilledTotal ?? 0) > 0
                      //           ? '✓ Good stock'
                      //           : 'Low stock',
                      //       badgeIsGood: (totalCurrentStockFilledTotal ?? 0) > 0,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroKpiChip({
    required String label, required String value,
    required String sub, required String badgeLabel, required bool badgeIsGood,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
          const SizedBox(height: 5),
          Text(value, style: AppTypography.heroKpiValue),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeIsGood ? AppColors.green.withOpacity(0.25) : AppColors.orange.withOpacity(0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeLabel,
              style: TextStyle(
                color: badgeIsGood ? const Color(0xFF86EFAC) : const Color(0xFFFDBA74),
                fontSize: 10, fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  Widget _stockDiffBox(String label, String value, Color valueColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.kpiValueMD.copyWith(color: valueColor), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSM, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Mirrors newTheme StockProgressCard using live current-stock data.
  Widget _buildStockProgressCard() {
    final filled = totalCurrentStockFilled ?? 0;
    final empty = totalCurrentStockEmpty ?? 0;
    final defective = totalCurrentStockDefective ?? 0;
    final total = filled + empty + defective;
    double filledPct = total > 0 ? filled / total : 0;
    double emptyPct = total > 0 ? empty / total : 0;
    double defectPct = total > 0 ? defective / total : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Cylinder Stock Status',
                style: AppTypography.cardTitle,
              ),

              const SizedBox(width: 12),

              if (getCurrentStockDetailManager.isNotEmpty)
                Expanded(
                  child:
                  DropdownButtonHideUnderline(
                    child: DropdownButton<num>(
                    isExpanded: true,
                      value: selectedItemId != null ? selectedItemId!.toDouble() : null,
                      style: AppTypography.cardSubtitle.copyWith(color: AppColors.blue),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blue, size: 18),
                      items: getCurrentStockDetailManager.map((item) {
                        return DropdownMenuItem<num>(
                          value: item.itemId,
                          child: Text(item.itemName ?? 'Unknown', style: AppTypography.cardSubtitle),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedItemId = value!.toInt();
                          final sel = getCurrentStockDetailManager.firstWhere(
                                (item) => item.itemId == selectedItemId,
                            orElse: () => GetCurrentStockDetailManagerModel(),
                          );
                          totalCurrentStockFilled = sel.filledCurrentStk?.toInt() ?? 0;
                          totalCurrentStockEmpty = sel.emptyCurrentStk?.toInt() ?? 0;
                          totalCurrentStockDefective = sel.deffCurrentStk?.toInt() ?? 0;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _progressRow('Filled', filled, filledPct, AppColors.green),
          const SizedBox(height: 12),
          _progressRow('Empty', empty, emptyPct, AppColors.orange),
          const SizedBox(height: 12),
          _progressRow('Defective', defective, defectPct, AppColors.red),
        ],
      ),
    );
  }

  Widget _progressRow(String label, int count, double fraction, Color color) {
    return Row(
      children: [
        SizedBox(width: 68, child: Text(label, style: AppTypography.progressLabel)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 36,
          child: Text(count.toString(), textAlign: TextAlign.right,
              style: AppTypography.progressValue.copyWith(color: color)),
        ),
      ],
    );
  }

  Widget _buildProfitTableCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table header
          Container(
            decoration: const BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                const Expanded(flex: 1, child: Text('', style: AppTypography.labelSM)),
                Expanded(flex: 2, child: Text('Gross Revenue', textAlign: TextAlign.center, style: AppTypography.labelSM)),
                Expanded(flex: 2, child: Text('Gross Profit', textAlign: TextAlign.center, style: AppTypography.labelSM)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // NC row
          _profitTableRow('NC', svGrossRevenueCount, null, showProfit: false,
            onRevTap: () => Navigator.pushNamed(context, SVProfitDetailScreenUI.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
            onProfTap: () => Navigator.pushNamed(context, SVProfitDetailScreenUI.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
          ),
          const Divider(height: 1, color: AppColors.border),
          // ARB row
          _profitTableRow('ARB', arbGrossRevenueCount, arbGrossProfitCount,
            onRevTap: () => Navigator.pushNamed(context, ARBProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
            onProfTap: () => Navigator.pushNamed(context, ARBProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossProfit'}),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Refill row
          _profitTableRow('Refill', refillGrossRevenueCount, refillGrossProfitCount,
            onRevTap: () => Navigator.pushNamed(context, RefillProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
            onProfTap: () => Navigator.pushNamed(context, RefillProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossProfit'}),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          // Summary rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text('Gross Profit =', style: AppTypography.profitRowLabel, textAlign: TextAlign.right)),
                Expanded(
                  flex: 2,
                  child: Text(totalGrossProfit != null ? formatCurrency(totalGrossProfit!) : '0',
                    style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight),
                    textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text('Expenses =', style: AppTypography.profitRowLabel, textAlign: TextAlign.right)),
                Expanded(
                  flex: 2,
                  child: Text(totalExpenseForProfit != null ? formatCurrency(totalExpenseForProfit!) : '0',
                    style: AppTypography.profitRowValue.copyWith(color: AppColors.red),
                    textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          // Net profit highlight
          Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Text('Net Profit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
                const Spacer(),
                Text(incomeProfit != null ? formatCurrency(incomeProfit!) : '0', style: AppTypography.profitHighlightValue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profitTableRow(String category, double? revenue, double? profit,
      {required VoidCallback onRevTap, required VoidCallback onProfTap, bool showProfit = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(category, style: AppTypography.profitRowLabel, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onRevTap,
              child: Text(
                revenue != null ? formatCurrency(revenue) : '0',
                style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: showProfit
              ? GestureDetector(
                  onTap: onProfTap,
                  child: Text(
                    profit != null ? formatCurrency(profit) : '0',
                    style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : GestureDetector(
                  onTap: onRevTap,
                  child: Text(
                    revenue != null ? formatCurrency(revenue) : '0',
                    style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
        ],
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
            for (var receipt in getCurrentStockDetailManager) {
              // totalOpeningStockFilledShow += (receipt.filledOpeningStk ?? 0)
              //     .toInt(); // Corrected summing of imbQty
              // totalOpeningStockEmptyShow += (receipt.emptyOpeningStk ?? 0)
              //     .toInt(); // Corrected summing of imbQty
              // totalOpeningStockDefectiveShow +=
              //     (receipt.deffOpeningStk ?? 0).toInt();
              totalCurrentStockFilledShow +=
                  (receipt.filledCurrentStk ?? 0).toInt();
              totalCurrentStockEmptyShow +=
                  (receipt.emptyCurrentStk ?? 0).toInt();
              totalCurrentStockDefectiveShow +=
                  (receipt.deffCurrentStk ?? 0).toInt();
            }
            // totalOpeningStockFilled = totalOpeningStockFilledShow;
            // totalOpeningStockEmpty = totalOpeningStockEmptyShow;
            // totalOpeningStockDefective = totalOpeningStockDefectiveShow;
            totalCurrentStockFilledTotal = totalCurrentStockFilledShow;
            totalCurrentStockEmptyTotal = totalCurrentStockEmptyShow;
            totalCurrentStockDefectiveTotal = totalCurrentStockDefectiveShow;

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
        String title = "Session Expired";
        String message = "Your session has expired. Please log in again.";
        String btnLabel = "OK";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(title, style: Styling.bodyTitle, textScaler: TextScaler.noScaling),
            content: Text(message, style: Styling.bodyTitle, textScaler: TextScaler.noScaling),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel, style: Styling.blueClrText, textScaler: TextScaler.noScaling),
                onPressed: () => logoutUser(context),
              ),
            ],
          ),
        )
            : WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.lock_clock_rounded, color: Color(0xFFEF4444), size: 26),
                  ),
                  const SizedBox(height: 16),
                  Text(title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                      textScaler: TextScaler.noScaling),
                  const SizedBox(height: 8),
                  Text(message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
                      textScaler: TextScaler.noScaling),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      onPressed: () => logoutUser(context),
                      child: Text(btnLabel,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                          textScaler: TextScaler.noScaling),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFF97316), size: 26),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Confirm Logout",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                  textScaler: TextScaler.noScaling,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please log in to the application again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
                  textScaler: TextScaler.noScaling,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      logoutUser(context);
                    },
                    child: const Text("OK",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                        textScaler: TextScaler.noScaling),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: SafeArea(
            child: DraggableScrollableSheet(
              initialChildSize: 0.78,
              minChildSize: 0.55,
              maxChildSize: 0.95,
              expand: false,

              builder: (context, scrollController) {
                return Column(
                  children: [

                    // ── Drag Handle ─────────────────────────────
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(
                          top: 12,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // ── Header ──────────────────────────────────
                    Container(
                      margin: const EdgeInsets.fromLTRB(
                        12,
                        12,
                        12,
                        0,
                      ),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E3A8A),
                            Color(0xFF1D6B7A),
                            Color(0xFF0F766E),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),

                        borderRadius: BorderRadius.circular(16),

                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E3A8A)
                                .withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          Container(
                            width: 40,
                            height: 40,

                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: const Icon(
                              Icons.credit_card_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Text(
                                  "PREPAID PUNCHING STATUS",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                  textScaler: TextScaler.noScaling,
                                ),

                                SizedBox(height: 2),

                                Text(
                                  "Real-time punching overview",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                  textScaler: TextScaler.noScaling,
                                ),
                              ],
                            ),
                          ),

                          Visibility(
                            visible: roleId == Constants.roleIdOwner,

                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  PrepaidBookingAndSettlementGraphScreen
                                      .screenName,
                                );
                              },

                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(20),

                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.35,
                                    ),
                                    width: 1,
                                  ),
                                ),

                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Graph",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      textScaler:
                                      TextScaler.noScaling,
                                    ),

                                    SizedBox(width: 3),

                                    Icon(
                                      Icons.bar_chart_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Scrollable Content ─────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,

                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            12,
                            12,
                            12,
                            20,
                          ),

                          child: Column(
                            children: [

                              // ── Row 1 ────────────────────
                              Row(
                                children: [

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      todaysPunchingInNiyojanC
                                          .toString(),

                                      label:
                                      "Today's Niyojan Punched",

                                      icon: Icons
                                          .check_circle_outline_rounded,

                                      accentColor:
                                      const Color(0xFF0F766E),

                                      bgColor:
                                      const Color(0xFFF0FDFA),

                                      onTap: () {
                                        todaysPunchingInNiyojanC! >
                                            0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "Punching"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      todaysIncorrectPunchingC
                                          .toString(),

                                      label:
                                      "Today's Incorrect",

                                      icon: Icons
                                          .warning_amber_rounded,

                                      accentColor:
                                      const Color(0xFFD97706),

                                      bgColor:
                                      const Color(0xFFFFFBEB),

                                      onTap: () {
                                        todaysIncorrectPunchingC! >
                                            0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "Incorrect"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // ── Row 2 ────────────────────
                              Row(
                                children: [

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      pendingInCdcmsC.toString(),

                                      label:
                                      "Pending in cDCMS\n(Since $formattedDatecdcms)",

                                      icon: Icons
                                          .hourglass_top_rounded,

                                      accentColor:
                                      const Color(0xFFEF4444),

                                      bgColor:
                                      const Color(0xFFFEF2F2),

                                      onTap: () {
                                        pendingInCdcmsC! > 0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "cDCMS"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      oldBkgPendNewBkgRecv
                                          .toString(),

                                      label:
                                      "Old Pending, New Booking Received",

                                      icon: Icons
                                          .swap_horiz_rounded,

                                      accentColor:
                                      const Color(0xFFF97316),

                                      bgColor:
                                      const Color(0xFFFFF7ED),

                                      onTap: () {
                                        oldBkgPendNewBkgRecv! > 0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "OldBkgPendNewBkgRecv"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // ── Row 3 ────────────────────
                              Row(
                                children: [

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      delDonNiyoJanPunPend
                                          .toString(),

                                      label:
                                      "Delivered in cDCMS, Pending in Niyojan",

                                      icon: Icons
                                          .cloud_done_outlined,

                                      accentColor:
                                      const Color(0xFF2D52C5),

                                      bgColor:
                                      const Color(0xFFEFF6FF),

                                      onTap: () {
                                        delDonNiyoJanPunPend! > 0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "DelDonNiyoJanPunPend"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: _buildPunchStatusCard(
                                      value:
                                      niyoJanPunDelPend
                                          .toString(),

                                      label:
                                      "Punched in Niyojan, Pending in cDCMS",

                                      icon:
                                      Icons.upload_rounded,

                                      accentColor:
                                      const Color(0xFF7C3AED),

                                      bgColor:
                                      const Color(0xFFF5F3FF),

                                      onTap: () {
                                        niyoJanPunDelPend! > 0
                                            ? Navigator.pushNamed(
                                          context,
                                          DashboardPrepaidDetails
                                              .screenName,
                                          arguments: {
                                            "flag":
                                            "NiyoJanPunDelPend"
                                          },
                                        )
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
  Widget _buildPunchStatusCard({
    required String value,
    required String label,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    final int count = int.tryParse(value) ?? 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            top: BorderSide(color: accentColor, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded, color: accentColor, size: 12),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: count > 0 ? accentColor : const Color(0xFF6B7280),
                letterSpacing: -0.5,
                height: 1.0,
              ),
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
              textScaler: TextScaler.noScaling,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheetPrepaidSettlementStatus(BuildContext context) {
    final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
    final totalDoneBtDelPend = paymtDoneBtDelPendAmt?.toDouble() ?? 0.0;
    final totaldelDoneBtPaymtPend = delDoneBtPaymtPendAmt?.toDouble() ?? 0.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PREPAID SETTLEMENT STATUS",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF374151),
                                letterSpacing: 0.8,
                              ),
                              textScaler: TextScaler.noScaling,
                            ),
                            Text(
                              "Data ref. cDCMS",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                              textScaler: TextScaler.noScaling,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSettlementCard(
                          count: settlPayReceiveDelPendC.toString(),
                          amount: formatCurrency(totalDoneBtDelPend),
                          label: "Payment done, delivery pending",
                          accentColor: const Color(0xFF0F766E),
                          bgColor: const Color(0xFFF0FDFA),
                          onTap: settlPayReceiveDelPendC != null && settlPayReceiveDelPendC! > 0
                              ? () {
                            Navigator.pushNamed(
                                context,
                                DashboardPrepaidDetails.screenName,
                                arguments: {"flag": "Settled"});
                          }
                              : null,
                          dividerWidget: verticalDividerSmallestRed(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSettlementCard(
                          count: settlDelPayPendC.toString(),
                          amount: formatCurrency(totaldelDoneBtPaymtPend),
                          label: "Since ($formattedDate) Delivered, payment pending",
                          accentColor: const Color(0xFFD97706),
                          bgColor: const Color(0xFFFFFBEB),
                          onTap: settlDelPayPendC != null && settlDelPayPendC! > 0
                              ? () {
                            Navigator.pushNamed(
                                context,
                                DashboardPrepaidDetails.screenName,
                                arguments: {"flag": "Delivered"});
                          }
                              : null,
                          dividerWidget: verticalDividerSmallestRed(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSettlementCard(
                          count: totalPendingSettCnt.toString(),
                          amount: formatCurrency(totalPendAmount),
                          label: "Since ($totalPendingSettSinceDate) Total Outstanding Pending",
                          accentColor: const Color(0xFFEF4444),
                          bgColor: const Color(0xFFFEF2F2),
                          onTap: totalPendingSettCnt != null && totalPendingSettCnt! > 0
                              ? () {
                            Navigator.pushNamed(
                                context,
                                DashboardPrepaidDetails.screenName,
                                arguments: {"flag": "TotalOutstanding"});
                          }
                              : null,
                          dividerWidget: verticalDividerSmallestRed(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettlementCard({
    required String count,
    required String amount,
    required String label,
    required Color accentColor,
    required Color bgColor,
    required VoidCallback? onTap,
    required Widget dividerWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: accentColor, width: 3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D1E3A8A),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: Styling.countNumber.copyWith(
                    color: const Color(0xFF2D52C5),
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF2D52C5),
                  ),
                  textScaler: TextScaler.noScaling,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: dividerWidget,
                ),
                Flexible(
                  child: Text(
                    amount,
                    style: Styling.countNumber.copyWith(
                      color: const Color(0xFF111827),
                      fontSize: 16,
                    ),
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: accentColor,
                height: 1.3,
              ),
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
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
                    color: Color(0xFF1E3A8A),
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
                Navigator.pop(context);
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const Text(
                                  'IMBALANCE STOCK',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF374151),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Table
                          Expanded(
                            child: getManagerDashboarDetailItemWise.isNotEmpty
                                ? Column(
                              children: [
                                // Table header with gradient
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Item Name", style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
                                      Expanded(child: Text("Today's Imb Qty", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
                                      Expanded(child: Text("As Of Imb Qty", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: getManagerDashboarDetailItemWise
                                        .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
                                        .toList()
                                        .length,
                                    itemBuilder: (context, index) {
                                      var item = getManagerDashboarDetailItemWise
                                          .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
                                          .toList()[index];
                                      final bg = index.isEven ? const Color(0xFFEFF6FF) : Colors.white;
                                      return Container(
                                        color: bg,
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(item.itemName ?? '', style: Styling.textFormText, textScaler: TextScaler.noScaling),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  print('Tapped on today imbalance qty: ${item.todayImbQty}');
                                                  Navigator.pushNamed(context, ImbalanceCountClickUI.screenName,
                                                      arguments: {"ItemId": item.itemId, "imbQtyType": 'today'});
                                                },
                                                child: Text(item.todayImbQty.toString(),
                                                    style: Styling.textFormTextWithUnderline,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  print('Tapped on as of date imbalance qty: ${item.asOfDateImbQty}');
                                                  Navigator.pushNamed(context, ImbalanceCountClickUI.screenName,
                                                      arguments: {"ItemId": item.itemId, "imbQtyType": 'asOfDate'});
                                                },
                                                child: Text(item.asOfDateImbQty.toString(),
                                                    style: Styling.textFormTextWithUnderline,
                                                    textAlign: TextAlign.center,
                                                    textScaler: TextScaler.noScaling),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                                : Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.info_outline_rounded, color: Color(0xFF1E3A8A)),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'No Data Available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));
        return SlideTransition(position: offsetAnimation, child: child);
      },
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
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40, height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header row
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              width: 36, height: 36,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE2E8F0),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(Icons.arrow_back_ios_new_rounded,
                                                  size: 16, color: Color(0xFF374151)),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Row(
                                            children: [
                                              Container(
                                                width: 6, height: 6,
                                                margin: const EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1E3A8A),
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                              const Text(
                                                'STOCK STATUS',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF374151),
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Opening Stock label + dropdown
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Opening Stock Status",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                            textScaler: TextScaler.noScaling,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: const Color(0xFFE2E8F0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0x0D1E3A8A),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<num>(
                                                isExpanded: true,
                                                value: selectedItemId,
                                                items: getCurrentStockDetailManager.map((item) {
                                                  return DropdownMenuItem<num>(
                                                    value: item.itemId,
                                                    child: Text(
                                                      item.itemName ?? 'Unknown',
                                                      style: Styling.dropdownVerySmallText,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setModalState(() {
                                                    selectedItemId = value!.toInt();
                                                    final selectedItem =
                                                    getCurrentStockDetailManager.firstWhere(
                                                          (item) => item.itemId == selectedItemId,
                                                      orElse: () => GetCurrentStockDetailManagerModel(),
                                                    );
                                                    totalOpeningStockFilled = selectedItem.filledOpeningStk?.toInt() ?? 0;
                                                    totalOpeningStockEmpty = selectedItem.emptyOpeningStk?.toInt() ?? 0;
                                                    totalOpeningStockDefective = selectedItem.deffOpeningStk?.toInt() ?? 0;
                                                    totalCurrentStockFilled = selectedItem.filledCurrentStk?.toInt() ?? 0;
                                                    totalCurrentStockEmpty = selectedItem.emptyCurrentStk?.toInt() ?? 0;
                                                    totalCurrentStockDefective = selectedItem.deffCurrentStk?.toInt() ?? 0;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Opening stock KPI mini-cards
                                    Row(
                                      children: [
                                        Expanded(child: _stockMiniCard(totalOpeningStockFilled.toString(), 'Filled', const Color(0xFF1E3A8A))),
                                        const SizedBox(width: 8),
                                        Expanded(child: _stockMiniCard(totalOpeningStockEmpty.toString(), 'Empty', const Color(0xFF0F766E))),
                                        const SizedBox(width: 8),
                                        Expanded(child: _stockMiniCard(totalOpeningStockDefective.toString(), 'Defective', const Color(0xFFEF4444))),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Current Stock section
                                    _stockSectionLabel('Current Stock Status', const Color(0xFF2D52C5)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: _stockMiniCard(totalCurrentStockFilled.toString(), 'Filled', const Color(0xFF1E3A8A))),
                                        const SizedBox(width: 8),
                                        Expanded(child: _stockMiniCard(totalCurrentStockEmpty.toString(), 'Empty', const Color(0xFF0F766E))),
                                        const SizedBox(width: 8),
                                        Expanded(child: _stockMiniCard(totalCurrentStockDefective.toString(), 'Defective', const Color(0xFFEF4444))),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Inward Stock section
                                    _stockSectionLabel('Inward Stock', const Color(0xFF0F766E)),
                                    const SizedBox(height: 10),
                              getCurrentStockDetailManager.any((item) =>
                              item.totalInvoiceCnt! > 0 ||
                                  item.filledEMRCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Filled',
                                accentColor: const Color(0xFF1E3A8A),
                                headers: const ['', 'Invoice', 'EMR'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.totalInvoiceCnt! > 0 || item.filledEMRCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.totalInvoiceCnt.toString(),
                                  items.filledEMRCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),
                              getCurrentStockDetailManager
                                  .any((item) => item.emptyTVCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Empty',
                                accentColor: const Color(0xFF0F766E),
                                headers: const ['', 'TV'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.emptyTVCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.emptyTVCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),

                              getCurrentStockDetailManager
                                  .any((item) => item.defectivCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Defective',
                                accentColor: const Color(0xFFEF4444),
                                headers: const ['', 'Defective'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.defectivCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.defectivCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),
                              // Outward Stock section
                              const SizedBox(height: 16),
                              _stockSectionLabel('Outward Stock', const Color(0xFFD97706)),
                              const SizedBox(height: 10),

                              getCurrentStockDetailManager.any((item) =>
                              item.emptyCRDCnt! > 0 ||
                                  item.emptyDefectivCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Empty',
                                accentColor: const Color(0xFF0F766E),
                                headers: const ['', 'CRD', 'Defective'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.emptyCRDCnt! > 0 || item.emptyDefectivCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.emptyCRDCnt.toString(),
                                  items.emptyDefectivCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),
                              // Title with larger font and a subtle shadow

                              getCurrentStockDetailManager.any((item) =>
                              item.sVQty! > 0 || item.refillSaleCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Refill Sale',
                                accentColor: const Color(0xFF2D52C5),
                                headers: const ['', 'SV', 'Refill Sale'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.sVQty! > 0 || item.refillSaleCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.sVQty.toString(),
                                  items.refillSaleCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),

                              getCurrentStockDetailManager
                                  .any((item) => item.imbalanceCnt! > 0)
                                  ? _stockSubTable(
                                subTitle: 'Imbalance',
                                accentColor: const Color(0xFFD97706),
                                headers: const ['', 'Imbalance'],
                                rows: getCurrentStockDetailManager
                                    .where((item) => item.imbalanceCnt! > 0)
                                    .map((items) => [
                                  items.itemName.toString(),
                                  items.imbalanceCnt.toString(),
                                ]).toList(),
                              )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      ),
                        ],
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

  /// Mini KPI card used in stock status for Filled / Empty / Defective counts
  Widget _stockMiniCard(String value, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: accentColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1E3A8A),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: -0.6,
            ),
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }

  /// Section label row with a colored dot
  Widget _stockSectionLabel(String title, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 6, height: 6,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
            letterSpacing: 0.8,
          ),
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }

  /// Reusable sub-table for stock detail (inward/outward)
  Widget _stockSubTable({
    required String subTitle,
    required Color accentColor,
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D1E3A8A),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(
              children: [
                Container(
                  width: 5, height: 5,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
              ),
            ),
            child: Row(
              children: headers.map((h) => Expanded(
                child: Text(
                  h,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.noScaling,
                ),
              )).toList(),
            ),
          ),
          // Data rows
          rows.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(12),
            child: Text("No Data Available",
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          )
              : Column(
            children: rows.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              final bg = index.isEven ? const Color(0xFFEFF6FF) : Colors.white;
              return Container(
                color: bg,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: row.map((cell) => Expanded(
                    child: Text(
                      cell,
                      style: Styling.textFormText,
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.noScaling,
                    ),
                  )).toList(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
        ],
      ),
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
      staffName = preferences.getString('StaffName') ?? '';
      distributorName = preferences.getString('DistributorName') ?? '';
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



  // void listenForegroundMessages() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Check if the message contains a notification
  //     if (message.notification != null) {
  //       NotificationService.showNotification(
  //         message.notification!.title ?? 'Notification',
  //         message.notification!.body ?? '',
  //       );
  //     }
  //
  //     // Optional: handle data messages as well
  //     if (message.data.isNotEmpty) {
  //       debugPrint('Foreground data message: ${message.data}');
  //     }
  //   });
  // }
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification?.title ?? 'Notification';
      String body = message.notification?.body ?? '';

      // Always use title
      NotificationService.showNotification(title, body, title);

      if (message.data.isNotEmpty) {
        debugPrint('Foreground data message: ${message.data}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String title = message.notification?.title ?? 'Unknown';
      debugPrint('Notification clicked: $title');
      // NotificationService.onSelectNotification(
      //   // NotificationResponse(payload: title),
      //     NotificationResponse({
      //       required this.notificationResponseType,
      //       this.payload,
      //
      //     })
      //
      // );
      NotificationService.onSelectNotification(
        NotificationResponse(
          notificationResponseType: NotificationResponseType.selectedNotification,
          payload: title,
        ),
      );

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
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F766E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Text(
                        'CASHMEMO PUNCHING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: Row(
                      children: [
                        Switch(
                          value: isOn,
                          activeColor: const Color(0xFF1E3A8A),
                          onChanged: (value) {
                            setModalState(() {
                              isOn = value;
                            });
                          },
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151),
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
              Column(
                children: getDashPunchSummaryCntModel.map((item) {
                  return Column(
                    children: [
                      _buildPunchRow1(
                        title: 'Manual',
                        today: !isOn ? punchManToday ?? 0 : punchManTodayPct ?? 0,
                        month: !isOn ? punchManAsOf ?? 0 : punchManAsOfPct ?? 0,
                        isPercentage: isOn,
                      ),
                      Divider(color: const Color(0xFFE2E8F0)),
                      _buildPunchRow1(
                        title: 'OTP / DAC',
                        today: !isOn ? punchDACToday ?? 0 : punchDACTodayPct ?? 0,
                        month: !isOn ? punchDACAsOf ?? 0 : punchDACAsOfPct ?? 0,
                        isPercentage: isOn,
                      ),
                      Divider(color: const Color(0xFFE2E8F0)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
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
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Text(
                        'REFILL BOOKING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: Row(
                      children: [
                        Switch(
                          value: isOnBook,
                          activeColor: const Color(0xFF1E3A8A),
                          onChanged: (value) {
                            setModalState(() {
                              isOnBook = value;
                            });
                          },
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151),
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
              Column(
                children: getDashPunchSummaryCntModel.map((item) {
                  return Column(
                    children: [
                      _buildPunchRow1(
                        title: 'Manual',
                        today: !isOnBook ? bkgManToday ?? 0 : bkgManTodayPct ?? 0,
                        month: !isOnBook ? bkgManAsOf ?? 0 : bkgManAsOfPct ?? 0,
                        isPercentage: isOnBook,
                      ),
                      Divider(color: const Color(0xFFE2E8F0)),
                      _buildPunchRow1(
                        title: 'Online',
                        today: !isOnBook ? bkgOnlineToday ?? 0 : bkgOnlineTodayPct ?? 0,
                        month: !isOnBook ? bkgOnlineAsOf ?? 0 : bkgOnlineAsOfPct ?? 0,
                        isPercentage: isOnBook,
                      ),
                      Divider(color: const Color(0xFFE2E8F0)),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _punchTableHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: const Text('', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: const Text('Today',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: const Text('This Month',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
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
            SizedBox(width: 8),
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
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   setState(() {
    //
    //       getDashPunchSummaryCntModel = data.map((json) {
    //         return GetDashPunchSummaryCntModel.fromJson(json);
    //       }).toList();
    //
    //       // --- Punch summary ---
    //       punchManToday = data['punchManToday'] ?? 0;
    //       punchManAsOf = data['punchManAsOf'] ?? 0;
    //       punchManTodayPct = data['punchManTodayPct'] ?? 0;
    //       punchManAsOfPct = data['punchManAsOfPct'] ?? 0;
    //
    //       punchDACToday = data['punchDACToday'] ?? 0;
    //       punchDACAsOf = data['punchDACAsOf'] ?? 0;
    //       punchDACTodayPct = data['punchDACTodayPct'] ?? 0;
    //       punchDACAsOfPct = data['punchDACAsOfPct'] ?? 0;
    //
    //       // --- Booking summary ---
    //       bkgManToday = data['bkgManToday'] ?? 0;
    //       bkgManAsOf = data['bkgManAsOf'] ?? 0;
    //       bkgManTodayPct = data['bkgManTodayPct'] ?? 0;
    //       bkgManAsOfPct = data['bkgManAsOfPct'] ?? 0;
    //
    //       bkgOnlineToday = data['bkgOnlineToday'] ?? 0;
    //       bkgOnlineAsOf = data['bkgOnlineAsOf'] ?? 0;
    //       bkgOnlineTodayPct = data['bkgOnlineTodayPct'] ?? 0;
    //       bkgOnlineAsOfPct = data['bkgOnlineAsOfPct'] ?? 0;
    //
    //       isLoading = false;
    //       EasyLoading.dismiss();
    //     });
    //
    // }
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        getDashPunchSummaryCntModel = data.map((json) {
          return GetDashPunchSummaryCntModel.fromJson(json);
        }).toList();

        if (getDashPunchSummaryCntModel.isNotEmpty) {
          print(
              'Total Amount of the first item: ${getDashPunchSummaryCntModel[0]
                  .bkgOnlineAsOf}');
          punchManToday =
              getDashPunchSummaryCntModel[0].punchManToday!.toInt();
          punchManAsOf =
              getDashPunchSummaryCntModel[0].punchManAsOf?.toInt();
          punchManTodayPct =
              getDashPunchSummaryCntModel[0].punchManTodayPct?.toDouble();
          punchManAsOfPct =
              getDashPunchSummaryCntModel[0].punchManAsOfPct?.toDouble();
          punchDACToday =
              getDashPunchSummaryCntModel[0].punchDACToday?.toInt();
          punchDACAsOf =
              getDashPunchSummaryCntModel[0].punchDACAsOf?.toInt();
          punchDACTodayPct =
              getDashPunchSummaryCntModel[0].punchDACTodayPct?.toDouble() ?? 0;
          punchDACAsOfPct =
              getDashPunchSummaryCntModel[0].punchDACAsOfPct?.toDouble() ?? 0;

          bkgManToday =
              getDashPunchSummaryCntModel[0].bkgManToday?.toInt();
          bkgManAsOf =
              getDashPunchSummaryCntModel[0].bkgManAsOf?.toInt();
          bkgManTodayPct =
              getDashPunchSummaryCntModel[0].bkgManTodayPct?.toDouble();
          bkgManAsOfPct =
              getDashPunchSummaryCntModel[0].bkgManAsOfPct?.toDouble();
          bkgOnlineToday =
              getDashPunchSummaryCntModel[0].bkgOnlineToday?.toInt();
          bkgOnlineAsOf =
              getDashPunchSummaryCntModel[0].bkgOnlineAsOf?.toInt();
          bkgOnlineTodayPct =
              getDashPunchSummaryCntModel[0].bkgOnlineTodayPct?.toDouble() ?? 0;
          bkgOnlineAsOfPct =
              getDashPunchSummaryCntModel[0].bkgOnlineAsOfPct?.toDouble() ?? 0;

        }

        isLoading = false;
        EasyLoading.dismiss();
      });
    }
    else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    if (routeArgs is Map<String, dynamic>) {

      if (routeArgs["openCashmemoSheet"] == true && !_cashmemoSheetOpened) {
        _cashmemoSheetOpened = true;
        _waitForPunchDataAndOpen();
      }

      if (routeArgs["refillBooking"] == true && !_refillBookingSheetOpened) {
        _refillBookingSheetOpened = true;
        _waitForBooingDataAndOpen();
      }

      if (routeArgs["openPrepaidSheet"] == true && !_prepaidSheetOpened) {
        _prepaidSheetOpened = true;
        _waitForPrepaidDataAndOpen();
      }
      // if (routeArgs["Total Outstanding Pending"] == true && !_SettlementSheetOpened) {
      //   _SettlementSheetOpened = true;
      //   _waitForSettlementDataAndOpen();
      // }

    }
  }

  void _waitForPunchDataAndOpen() async {
    int attempts = 0;

    while (getDashPunchSummaryCntModel.isEmpty && attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }

    if (mounted) {
      _openCashmemoSheet();
    }
  }

  void _waitForBooingDataAndOpen() async {
    int attempts = 0;

    while (getDashPunchSummaryCntModel.isEmpty && attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }

    if (mounted) {
      _openRefillBookinfSheet();
    }
  }

  void _openCashmemoSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0xFF1E3A8A),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GestureDetector(
              onTap: () {},
              child: showCardWithPunching(context, setModalState),
            );
          },
        );
      },
    );
  }

  void _openRefillBookinfSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0xFF1E3A8A),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GestureDetector(
              onTap: () {},
              child: showCardWithBooking(context, setModalState),
            );
          },
        );
      },
    );
  }

  void _waitForPrepaidDataAndOpen() async {
    int attempts = 0;

    while ((todaysPunchingInNiyojanC == null) && attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }

    if (mounted) {
      showBottomSheet(context);
    }
  }

}

// ── Helper data class for DataListCard rows ────────────────────────────────
class _DataRow {
  const _DataRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.dotColor,
    required this.badgeLabel,
    required this.badgeBg,
    required this.badgeFg,
    this.onTap,
  });
  final String label;
  final String subtitle;
  final String value;
  final Color dotColor;
  final String badgeLabel;
  final Color badgeBg;
  final Color badgeFg;
  final VoidCallback? onTap;
}

// ── Flow Vector Painter (matches newTheme DashboardHeroStrip) ───────────────
class _DashFlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = const Color(0xFF14B8A8).withOpacity(0.14) // tealLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final paint3 = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final p1 = Path()
      ..moveTo(-10, h * 0.75)
      ..cubicTo(w * 0.2, h * 0.25, w * 0.5, h * 0.6, w + 10, h * 0.38);
    canvas.drawPath(p1, paint1);

    final p2 = Path()
      ..moveTo(-10, h * 0.56)
      ..cubicTo(w * 0.24, h * 0.12, w * 0.5, h * 0.44, w + 10, h * 0.19);
    canvas.drawPath(p2, paint2);

    final p3 = Path()
      ..moveTo(w * 0.05, h)
      ..cubicTo(w * 0.3, h * 0.5, w * 0.6, h * 0.69, w + 10, h * 0.5);
    canvas.drawPath(p3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../newTheam/core/theme/app_colors.dart';
// import '../../newTheam/core/theme/app_typography.dart';
// import '../../newTheam/features/dashboard/models/dashboard_models.dart';
// import '../../newTheam/features/dashboard/widgets/alert_action_card.dart';
// import '../../newTheam/features/dashboard/widgets/kpi_card.dart';
// import '../../newTheam/features/dashboard/widgets/mini_card_grid.dart';
// import '../../newTheam/features/dashboard/widgets/profit_summary_card.dart';
// import '../../newTheam/features/dashboard/widgets/section_header.dart';
// import '../../newTheam/features/dashboard/widgets/stock_progress_card.dart';
// import '../ConstantScreen/widgets.dart';
// import '../IOSVersionUpdateService.dart';
// import '../PushNotification/NotificationApiHelper.dart';
// import '../PushNotification/NotificationService.dart';
// import '../UndocumentedSVDash/DashboardUndocumentedDetails.dart';
// import '../User/Login/provider/LoginProvider.dart';
// import '../User/splashscreen/page/splash_screen.dart';
// import '../Utils/Styling.dart';
// import '../Utils/UpdateService.dart';
// import '../Utils/Widget.dart';
// import '../Utils/app_url.dart';
// import '../Utils/constants.dart';
// import '../Utils/shared_preference.dart';
// import 'package:http/http.dart' as http;
// import 'CashHandoverScreen.dart';
// import 'ClickModelClass/HeadWiseExpenseLstModel.dart';
// import 'DashboardItemClickUI/ARBProfitDetailScreenUi.dart';
// import 'DashboardItemClickUI/CreditSaleCountDetailListUI.dart';
// import 'DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart';
// import 'DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
// import 'DashboardItemClickUI/DashboardPrepaidDetails.dart';
// import 'DashboardItemClickUI/DashboardSVDetails.dart';
// import 'DashboardItemClickUI/DashboardTVDetails.dart';
// import 'DashboardItemClickUI/ImbalanceCountClickUI.dart';
// import 'DashboardItemClickUI/PrepaidBookingAndSettlementGraphScreen.dart';
// import 'DashboardItemClickUI/RefillProfitDetailScreenUi.dart';
// import 'DashboardItemClickUI/SVProfitdetailScreenUi.dart';
// import 'DashboardItemClickUI/TodaysCashSummaryOnAccountList.dart';
// import 'DashboardItemClickUI/UnsettledSaleDetailList.dart';
// import 'DashboardItemClickUI/VendorPaymentDetailListUI.dart';
// import 'ExpensesScreen/ExpensesScreenUI.dart';
// import 'ExpensesScreen/SalesComparisonScreen.dart';
// import 'GetDashPuchSummaryCntModel.dart';
// import 'ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
// import 'ManagerModelClass/GetDashSummaryAllCountForMgrModel.dart';
// import 'ManagerModelClass/GetDashSummaryItemWiseForMgrModel.dart';
// import 'ManagerModelClass/GetDashSummarySettAllCountForMgrModel.dart';
// import 'ManagerModelClass/GetManagerDashboarDetailModel.dart';
//
// import 'ManagerModelClass/GetSVARBManagerDashboardCountModel.dart';
// import 'ManagerSingleItemUI/ImbalanceStockItemUI.dart';
// import 'PaymentReceiptScreen/PaymentReceiptScreen.dart';
// import 'SVSaleReportScreen.dart';
// import 'TVSaleScreen/TVSalesScreen.dart';
//
// // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class ManagerDashboardScreen extends StatefulWidget {
//   static const screenName = '/managerDashboardScreen';
//
//   @override
//   _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
// }
// class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool isPrepaidSettlementStatusListViewVisible = false;
//   bool isPrepaidPunchingStatusListViewVisible = false;
//   bool isPostpaidVerificationStatusListViewVisible = false;
//   bool isStockPendingStatusListViewVisible = false;
//   bool isTodaysCashSummaryListViewVisible = false;
//   bool isCDCMSStockDifferenceListViewVisible = false;
//   bool isImbalanceStockListViewVisible = false;
//   bool isInwardStockListViewVisible = false;
//   bool isInwardStockFilledListViewVisible = false;
//   bool isInwardStockEmptyListViewVisible = false;
//   bool isInwardStockDefectiveListViewVisible = false;
//   bool isOutwardStockListViewVisible = false;
//   bool isOutwardStockRefillSaleListViewVisible = false;
//   bool isOutwardStockEmptyListViewVisible = false;
//   bool isOutwardStockImbalanceListViewVisible = false;
//   bool isOpeningStockListViewVisible = false;
//   bool isCurrentStockListViewVisible = false;
//   // List<GetManagerDashboarDetailModel> getManagerDashboarDetail = [];
//   List<GetDashSummaryItemWiseForMgrModel> getManagerDashboarDetailItemWise = [];
//   List<GetDashSummaryAllCountForMgrModel> getManagerDashboarDetailAllCount = [];
//   List<GetDashSummarySettAllCountForMgrModel> getManagerDashboarDetailSettCount = [];
//   List<GetCurrentStockDetailManagerModel> getCurrentStockDetailManager = [];
//   List<GetDashPunchSummaryCntModel> getDashPunchSummaryCntModel = [];
//   List<String> getTransMode = ["Today's", "This Month","Financial Year"];
//   String? selectedTransMode = "This Month";
//   String? dayFlag = "THISMONTH";
//   bool isLoading = true;
//   String? mobileNo, cDCMDPendSince, settlementPendSince, totalPendingSettSince;
//   int? deliveryMenCount,
//       todaysPunchingInNiyojanC,
//       pendingInNiyojanC,
//       pendingInCdcmsC,
//       todaysIncorrectPunchingC,
//       settlPayReceiveDelPendC,
//       settlDelPayPendC,
//       oldBkgPendNewBkgRecv,
//       delDonNiyoJanPunPend,
//       niyoJanPunDelPend,
//       postPaidVerifPend,
//       sVPendingStk,
//       tVPendingStk,
//       paymtDoneBtDelPendAmt,
//       delDoneBtPaymtPendAmt,
//       totalPendingSettCnt,
//       totalPendingSettAmt,
//       postPaidVerifPendAmt,
//       UndocumentedSV,
//       TotalCrdtOutstd,
//       TotalVendorDueAmt;
//   double? totalAmount,
//       totalIncome,
//       totalExpense,
//       onAccountToday,
//       onAccountAsOfDate;
//
//   int? asOfDateImbQtyShow = 0;
//   int? todaysImbQtyShow = 0;
//   int? cdcmsFilledDiffShow = 0;
//   int? cdcmsEmptyDiffShow = 0;
//   int? cdcmsDefectiveDiffShow = 0;
//   double? filledPercent = 0;
//   double? emptyPercent = 0;
//   double? defectivePercent = 0;
//   int? total = 0;
//
//   int? totalOpeningStockFilled = 0;
//   int? totalOpeningStockEmpty = 0;
//   int? totalOpeningStockDefective = 0;
//   int? totalCurrentStockFilled = 0;
//   int? totalCurrentStockEmpty = 0;
//   int? totalCurrentStockDefective = 0;
//   int? totalCurrentStockFilledTotal = 0;
//   int? totalCurrentStockEmptyTotal = 0;
//   int? totalCurrentStockDefectiveTotal = 0;
//   int? selectedItemId;
//   int? selectedItemIdCDCMS;
//   List<GetSvarbManagerDashboardCountModel> svarbManagerDashboardCountModel = [];
//   List<HeadWiseExpenseLstModel> expenseReportModel = [];
//   double? svGrossRevenueCount = 0;
//   double? arbGrossRevenueCount = 0;
//   double? arbGrossProfitCount = 0;
//   double? refillGrossRevenueCount = 0;
//   double? refillGrossProfitCount = 0;
//   double? totalGrossProfit = 0;
//   double? totalExpenseForProfit = 0;
//   double? incomeProfit = 0;
//   bool isOn = true;
//   bool isOnBook = true;
//
//   // ── Release Notes ──────────────────────────────────────────────────────────
//   Timer? _releaseBlinkTimer;
//   bool _releaseBlink = true;
//   bool _releasePopupShown = false;
//   String _releaseFilter = "ThisWeek";
//   List<Map<String, dynamic>> _relNoteList = [];
//   List<Map<String, dynamic>> _relNoteDetails = [];
//   bool _bottomSheetOpened = false;
//   bool _sheetOpened = false;
//   bool _cashmemoSheetOpened = false;
//   bool _refillBookingSheetOpened = false;
//   bool _prepaidSheetOpened = false;
//   bool _SettlementSheetOpened = false;
//   int? punchManAsOf;
//   int? punchManToday;
//   double? punchManTodayPct;
//   double? punchManAsOfPct;
//   int? punchDACToday;
//   int? punchDACAsOf;
//   double? punchDACTodayPct;
//   double? punchDACAsOfPct;
//   int? bkgManToday;
//   int? bkgManAsOf;
//   double? bkgManTodayPct;
//   double? bkgManAsOfPct;
//   int? bkgOnlineToday;
//   int? bkgOnlineAsOf;
//   double? bkgOnlineTodayPct;
//   double? bkgOnlineAsOfPct;
//   // final GlobalKey _financialOverviewKey = GlobalKey();
//   // final GlobalKey _inventorySectionKey = GlobalKey();
//   // final ScrollController _scrollController = ScrollController();
//
//
//   // void _scrollToInventorySection() {
//   //   final context = _inventorySectionKey.currentContext;
//   //
//   //   if (context != null) {
//   //     Scrollable.ensureVisible(
//   //       context,
//   //       duration: const Duration(milliseconds: 600),
//   //       curve: Curves.easeInOut,
//   //       alignment: 0.1,
//   //     );
//   //   }
//   // }
//
//   // void _scrollToInventorySection() {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     final context = _inventorySectionKey.currentContext;
//   //     if (context == null) return;
//   //
//   //     final box = context.findRenderObject() as RenderBox;
//   //     final position = box.localToGlobal(Offset.zero);
//   //
//   //     final offset = _scrollController.offset +
//   //         position.dy -
//   //         MediaQuery.of(context).padding.top -
//   //         120; // adjust header height
//   //
//   //     _scrollController.animateTo(
//   //       offset.clamp(0.0, _scrollController.position.maxScrollExtent),
//   //       duration: const Duration(milliseconds: 600),
//   //       curve: Curves.easeInOut,
//   //     );
//   //   });
//   // }
//
//   // void _scrollToInventorySection() {
//   //   final ctx = _inventorySectionKey.currentContext;
//   //   if (ctx == null) return;
//   //
//   //   Scrollable.ensureVisible(
//   //     ctx,
//   //     duration: const Duration(milliseconds: 600),
//   //     curve: Curves.easeInOut,
//   //     alignment: 0.0, // align to top of viewport
//   //   );
//   // }
//
//
//   String formatIndianCurrency(num value) {
//     if (value >= 10000000) {
//       return '${(value / 10000000).floor()}Cr';
//     } else if (value >= 100000) {
//       return '${(value / 100000).floor()}L';
//     } else if (value >= 1000) {
//       return '${(value / 1000).floor()}k';
//     } else {
//       return value.floor().toString();
//     }
//   }
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   @override
//   void initState() {
//     super.initState();
//     getUserDetail();
//     NotificationService.init();
//
//
//     FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: false,
//       badge: false,
//       sound: false,
//     );
//     listenForegroundMessages();
//
//     setupNotifications(); // ✅ async flow
//     if (Platform.isAndroid) {
//       UpdateService.checkForUpdate(context);
//       debugPrint("Firebase initialize Dash${Platform}");
//     } else {
//       IosVersionUpdateCheck().checkForUpdate(context);
//
//     }
//     debugPrint("ManagerDashboardScreen: initState called");
//     // fetchDashboarDetail();
//     fetchDashboarDetailForSettItem();
//     fetchDashboarDetailItemWise();
//     fetchDashboarDetailForAllCount();
//     fetchCurrentStock();
//     fetchSavedData();
//     fetchSVARBFilterCountList("THISMONTH");
//     getDashPunchSummaryCntModeldata();
//
//     // ── Release Notes: blink timer + initial load ────────────────────────────
//     _releaseBlinkTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
//       if (!mounted) return;
//       setState(() => _releaseBlink = !_releaseBlink);
//     });
//     _initReleaseNotes();
//   }
//
//   Future<void> _onRefresh() async {
//     fetchCurrentStock();
//     // fetchDashboarDetail();
//     fetchDashboarDetailItemWise();
//     fetchDashboarDetailForAllCount();
//     fetchDashboarDetailForSettItem();
//     getDashPunchSummaryCntModeldata();
//     if(selectedTransMode == "Today's"){
//       dayFlag = "TODAYS";
//       debugPrint("dayFlag $dayFlag");
//       fetchSVARBFilterCountList(dayFlag!);
//     }else if(selectedTransMode == "This Month"){
//       dayFlag = "THISMONTH";
//       debugPrint("dayFlag $dayFlag");
//       fetchSVARBFilterCountList(dayFlag!);
//     }else if(selectedTransMode == "Financial Year"){
//       dayFlag = "FINYEAR";
//       debugPrint("dayFlag $dayFlag");
//       fetchSVARBFilterCountList(dayFlag!);
//     }else{
//       dayFlag = "";
//     }
//
//   }
//
//   final List<String> months = ['Apr', 'May', 'Jun', 'Jul', 'Aug'];
//   final List<double> income = [190000, 155000, 60000, 15000, 20000];
//   final List<double> expenses = [20000, 120000, 10000, 8000, 10000];
//   String? formattedDatecdcms;
//   String? formattedDate;
//   String? totalPendingSettSinceDate;
//   String? roleId, isUserActive,userActivet;
//   String staffName = '';
//   String distributorName = '';
//   // ─── NEW-THEME BUILD METHOD ─────────────────────────────────────────────────
//   // All business logic, variables, API calls unchanged.
//   // Only UI/UX styling matches NewTheme design system.
//   // ────────────────────────────────────────────────────────────────────────────
//
//   /// Returns section-header widget matching newTheme SectionHeader pattern.
//   Widget _sectionHeader(String title, Color dotColor, {String? actionLabel, VoidCallback? onAction}) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
//       child: Row(
//         children: [
//           Container(
//             width: 8, height: 8,
//             decoration: BoxDecoration(
//               color: dotColor,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             title.toUpperCase(),
//             style: AppTypography.sectionHeader,
//           ),
//           const Spacer(),
//           if (actionLabel != null)
//             GestureDetector(
//               onTap: onAction,
//               behavior: HitTestBehavior.opaque,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(actionLabel, style: AppTypography.seeAll),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// Returns a themed KPI card matching newTheme KpiCard pattern.
//   Widget _kpiCard({
//     required IconData icon,
//     required Color iconBg,
//     required String label,
//     required String value,
//     required String subtitle,
//     required String badgeLabel,
//     required Color badgeBg,
//     required Color badgeFg,
//     VoidCallback? onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Material(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(18),
//           splashColor: AppColors.blueXXL,
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color(0x0D1E3A8A),
//                   blurRadius: 12,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(18),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 50, height: 50,
//                     decoration: BoxDecoration(
//                       color: iconBg,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Icon(icon, color: AppColors.blue, size: 24),
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(label, style: AppTypography.labelMD),
//                         const SizedBox(height: 3),
//                         Text(value, style: AppTypography.kpiValueLG),
//                         const SizedBox(height: 4),
//                         Text(subtitle, style: AppTypography.cardSubtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: badgeBg,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(badgeLabel, style: AppTypography.badgeText.copyWith(color: badgeFg)),
//                       ),
//                       const SizedBox(height: 8),
//                       const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Returns a themed mini-card matching newTheme MiniCard pattern.
//   Widget _miniCard({
//     required String label,
//     required String value,
//     required Color valueColor,
//     required String sub,
//     Gradient? gradient,
//     VoidCallback? onTap,
//     bool isActionCard = false,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           constraints: const BoxConstraints(minHeight: 90),
//           decoration: BoxDecoration(
//             color: gradient == null ? AppColors.white : null,
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 10, offset: Offset(0, 2)),
//             ],
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(label.toUpperCase(), style: AppTypography.miniLabel),
//               isActionCard
//                   ? Text(value, style: AppTypography.cardTitle.copyWith(color: valueColor, fontSize: 16))
//                   : Text(value, style: AppTypography.miniValue.copyWith(color: valueColor)),
//               Text(sub, style: AppTypography.miniLabel),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Two-column mini card grid.
//   // Widget _miniCardRow({
//   //   required String leftLabel, required String leftValue, required Color leftValueColor,
//   //   required String leftSub, Gradient? leftGradient, VoidCallback? leftTap, bool leftIsAction = false,
//   //   required String rightLabel, required String rightValue, required Color rightValueColor,
//   //   required String rightSub, Gradient? rightGradient, VoidCallback? rightTap, bool rightIsAction = false,
//   // }) {
//   //   return Padding(
//   //     padding: const EdgeInsets.only(bottom: 10),
//   //     child: Row(
//   //       children: [
//   //         Expanded(child: _miniCard(label: leftLabel, value: leftValue, valueColor: leftValueColor, sub: leftSub, gradient: leftGradient, onTap: leftTap, isActionCard: leftIsAction)),
//   //         const SizedBox(width: 10),
//   //         Expanded(child: _miniCard(label: rightLabel, value: rightValue, valueColor: rightValueColor, sub: rightSub, gradient: rightGradient, onTap: rightTap, isActionCard: rightIsAction)),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _miniCardRow({
//     required String leftLabel, required String leftValue, required Color leftValueColor,
//     required String leftSub, Gradient? leftGradient, VoidCallback? leftTap, bool leftIsAction = false,
//     required String rightLabel, required String rightValue, required Color rightValueColor,
//     required String rightSub, Gradient? rightGradient, VoidCallback? rightTap, bool rightIsAction = false,
//     bool rightHide = false, // 👈 add this
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           Expanded(child: _miniCard(label: leftLabel, value: leftValue, valueColor: leftValueColor, sub: leftSub, gradient: leftGradient, onTap: leftTap, isActionCard: leftIsAction)),
//           if (!rightHide) ...[
//             const SizedBox(width: 10),
//             Expanded(child: _miniCard(label: rightLabel, value: rightValue, valueColor: rightValueColor, sub: rightSub, gradient: rightGradient, onTap: rightTap, isActionCard: rightIsAction)),
//           ],
//         ],
//       ),
//     );
//   }
//
//   /// Data row for DataListCard pattern.
//   Widget _dataListCard(List<_DataRow> rows) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         children: rows.asMap().entries.map((e) {
//           final isLast = e.key == rows.length - 1;
//           return _buildDataRow(e.value, !isLast);
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildDataRow(_DataRow item, bool showDivider) {
//     return InkWell(
//       onTap: item.onTap != null ? item.onTap : null,
//       borderRadius: BorderRadius.circular(18),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//         decoration: BoxDecoration(
//           border: showDivider ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)) : null,
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 10, height: 10,
//               decoration: BoxDecoration(color: item.dotColor, borderRadius: BorderRadius.circular(3)),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(item.label, style: AppTypography.dataRowLabel),
//                   if (item.subtitle.isNotEmpty) ...[
//                     const SizedBox(height: 2),
//                     Text(item.subtitle, style: AppTypography.cardSubtitle),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Text(item.value, style: AppTypography.dataRowValue),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//               decoration: BoxDecoration(color: item.badgeBg, borderRadius: BorderRadius.circular(20)),
//               child: Text(item.badgeLabel, style: AppTypography.badgeText.copyWith(color: item.badgeFg)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     formattedDate = settlementPendSince != null
//         ? DateFormat('dd-MM-yyyy').format(DateTime.parse(settlementPendSince!))
//         : 'No Date';
//     formattedDatecdcms = cDCMDPendSince != null
//         ? DateFormat('dd-MM-yyyy').format(DateTime.parse(cDCMDPendSince!))
//         : 'No Date';
//     totalPendingSettSinceDate = totalPendingSettSince != null
//         ? DateFormat('dd-MM-yyyy').format(DateTime.parse(totalPendingSettSince!))
//         : 'No Date';
//     final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: AppColors.bg2,
//       body: RefreshIndicator(
//         color: AppColors.blue,
//         backgroundColor: AppColors.white,
//         onRefresh: _onRefresh,
//         edgeOffset: MediaQuery.of(context).padding.top + 200,
//         child: CustomScrollView(
//           // controller: _scrollController,
//           physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//           slivers: [
//             // ── Hero Strip ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: _buildHeroStrip(),
//             ),
//
//             // ── Body Content ────────────────────────────────────────────────
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//
//                   // ════════════════════════════════════════════════════════
//                   // SEQUENCE MIRRORS dashboard_screen.dart
//                   // ════════════════════════════════════════════════════════
//
//                   // ── 1. NEEDS ATTENTION ───────────────────────────────────
//                   // Mirrors: SectionHeader('Needs Attention', red) + AlertActionCard list
//                   SectionHeader(
//                     title: 'Needs Attention',
//                     dotColor: AppColors.red,
//                   ),
//                   ...() {
//                     final List<AlertItem> _alerts = [
//                       AlertItem(
//                         title: 'Outstanding Settlement',
//                         subtitle: totalPendAmount > 0
//                             ? 'Pending since $totalPendingSettSinceDate'
//                             : 'Settlement pending',
//                         value: '₹${formatCurrency(totalPendAmount)}',
//                         severity: totalPendAmount > 0 ? AlertSeverity.danger : AlertSeverity.info,
//                         icon: Icons.account_balance_wallet_outlined,
//                         onTap: () => showBottomSheetPrepaidSettlementStatus(context),
//                       ),
//                       AlertItem(
//                         title: 'Postpaid Verification',
//                         subtitle: 'Amount: ₹${formatCurrency(postPaidVerifPendAmt?.toDouble() ?? 0.0)}',
//                         value: '${postPaidVerifPend ?? 0} cases',
//                         severity: (postPaidVerifPend ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
//                         icon: Icons.verified_outlined,
//                         onTap: (postPaidVerifPend ?? 0) > 0
//                             ? () => Navigator.pushNamed(context,
//                             DashboardPostPaidVerifPendDetails.screenName,
//                             arguments: {'flag': 'All'})
//                             : null,
//                       ),
//                       AlertItem(
//                         title: 'Undocumented SV',
//                         subtitle: 'Stock verifications not yet documented',
//                         value: '${UndocumentedSV ?? 0}',
//                         severity: (UndocumentedSV ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
//                         icon: Icons.inventory_2_outlined,
//                         onTap: (UndocumentedSV ?? 0) > 0
//                             ? () => Navigator.pushNamed(context,
//                             DashboardUndocumentedDetails.screenName,
//                             arguments: {'flag': 0})
//                             : null,
//                       ),
//                       AlertItem(
//                         title: 'Total Imbalance Stock',
//                         subtitle: 'Cumulative stock imbalance as of date',
//                         value: '${asOfDateImbQtyShow ?? 0} units',
//                         severity: (asOfDateImbQtyShow ?? 0) > 0 ? AlertSeverity.danger : AlertSeverity.info,
//                         icon: Icons.warning_amber_rounded,
//                         onTap: () => showCardWithImbalanceStock(context),
//                       ),
//                       AlertItem(
//                         title: 'Vendor Payment Due',
//                         subtitle: 'Total vendor due amount',
//                         value: '₹${formatCurrency(TotalVendorDueAmt?.toDouble() ?? 0.0)}',
//                         severity: (TotalVendorDueAmt ?? 0) > 0 ? AlertSeverity.warning : AlertSeverity.info,
//                         icon: Icons.account_balance_wallet_outlined,
//                         onTap: (TotalVendorDueAmt ?? 0) > 0
//                             ? () => Navigator.pushNamed(context, VendorPaymentDetailListUI.screenName)
//                             : null,
//                       ),
//                     ];
//                     return _alerts.asMap().entries.map((e) => AlertActionCard(
//                       item: e.value,
//                       animationDelay: Duration(milliseconds: 80 * e.key),
//                     ));
//                   }(),
//
//                   _sectionHeader('Financial Overview', AppColors.blueLight,
//                       actionLabel: '', onAction: null),
//                   _kpiCard(
//                     icon: Icons.receipt_long_outlined,
//                     iconBg: AppColors.orangeXL,
//                     label: "Today's Expenses",
//                     value: totalExpense != null ? '₹${formatIndianCurrency(totalExpense!)}' : '₹0',
//                     subtitle: 'Tap to view expense breakdown',
//                     badgeLabel: 'Expenses',
//                     badgeBg: AppColors.orangeXL,
//                     badgeFg: AppColors.orange,
//                     onTap: roleId == Constants.roleIdOwner
//                         ? () => Navigator.pushNamed(context, ExpensesScreenUI.screenName)
//                         : null,
//                   ),
//
//                   // Container(
//                   //   key: _financialOverviewKey,
//                   //   child: Column(
//                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                   //     children: [
//                   //
//                   //       _sectionHeader(
//                   //         'Financial Overview',
//                   //         AppColors.blueLight,
//                   //         actionLabel: '',
//                   //         onAction: null,
//                   //       ),
//                   //
//                   //       _kpiCard(
//                   //         icon: Icons.receipt_long_outlined,
//                   //         iconBg: AppColors.orangeXL,
//                   //         label: "Today's Expenses",
//                   //         value: totalExpense != null
//                   //             ? '₹${formatIndianCurrency(totalExpense!)}'
//                   //             : '₹0',
//                   //         subtitle: 'Tap to view expense breakdown',
//                   //         badgeLabel: 'Expenses',
//                   //         badgeBg: AppColors.orangeXL,
//                   //         badgeFg: AppColors.orange,
//                   //         onTap: roleId == Constants.roleIdOwner
//                   //             ? () => Navigator.pushNamed(
//                   //           context,
//                   //           ExpensesScreenUI.screenName,
//                   //         )
//                   //             : null,
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//
//                   _kpiCard(
//                     icon: Icons.account_balance_outlined,
//                     iconBg: AppColors.tealXL,
//                     label: "Today's On Account",
//                     value: onAccountToday != null ? '₹${formatCurrency(onAccountToday!)}' : '₹0',
//                     subtitle: 'Cash collected on account today',
//                     badgeLabel: 'On Account',
//                     badgeBg: AppColors.tealXL,
//                     badgeFg: AppColors.teal,
//                     onTap: () => Navigator.pushNamed(context,
//                         TodaysCashSummaryOnAccountList.screenName,
//                         arguments: {'onAccount': onAccountAsOfDate}),
//                   ),
//                   _kpiCard(
//                     icon: Icons.savings_outlined,
//                     iconBg: AppColors.blueXL,
//                     label: 'Total On Account',
//                     value: onAccountAsOfDate != null ? '₹${formatCurrency(onAccountAsOfDate!)}' : '₹0',
//                     subtitle: 'Cumulative outstanding on account',
//                     badgeLabel: 'Cumulative',
//                     badgeBg: AppColors.blueXXL,
//                     badgeFg: AppColors.blue,
//                     onTap: () => Navigator.pushNamed(context,
//                         TodaysCashSummaryOnAccountList.screenName,
//                         arguments: {'onAccount': onAccountAsOfDate}),
//                   ),
//                   _kpiCard(
//                     icon: Icons.pending_actions_outlined,
//                     iconBg: AppColors.redXL,
//                     label: 'Credit Sale Outstanding',
//                     value: '₹${formatCurrency(TotalCrdtOutstd?.toDouble() ?? 0.0)}',
//                     subtitle: 'Total outstanding credit amount',
//                     badgeLabel: (TotalCrdtOutstd ?? 0) > 0 ? 'Pending' : 'Clear ✓',
//                     badgeBg: (TotalCrdtOutstd ?? 0) > 0 ? AppColors.redXL : AppColors.greenXL,
//                     badgeFg: (TotalCrdtOutstd ?? 0) > 0 ? AppColors.red : AppColors.green,
//                     onTap: (TotalCrdtOutstd ?? 0) > 0
//                         ? () => Navigator.pushNamed(context, CreditSaleCountDetailListUI.screenName)
//                         : null,
//                   ),
//                   // Vendor Payment Due removed from here — moved to Needs Attention
//
//                   // ── 3. INVENTORY & STOCK ─────────────────────────────────
//                   _sectionHeader('Inventory & Stock', AppColors.teal,
//                       actionLabel: '',
//                       onAction: () => showStockStatus(context)),
//
//                   // Container(
//                   //   key: _inventorySectionKey,
//                   //   child: Column(
//                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                   //     children: [
//                   //       _sectionHeader(
//                   //         'Inventory & Stock',
//                   //         AppColors.teal,
//                   //         actionLabel: '',
//                   //         onAction: () => showStockStatus(context),
//                   //       ),
//                   //       // Stock Progress Card
//                   //       SizedBox(width: double.infinity, child: _buildStockProgressCard()),
//                   //       // Imbalance MiniCardGrid
//                   //       _miniCardRow(
//                   //         leftLabel: "Today's Imbalance",
//                   //         leftValue: todaysImbQtyShow.toString(),
//                   //         leftValueColor: AppColors.blueLight,
//                   //         leftSub: 'Units today',
//                   //         leftTap: () => showCardWithImbalanceStock(context),
//                   //         rightLabel: 'Total Imbalance',
//                   //         rightValue: asOfDateImbQtyShow.toString(),
//                   //         rightValueColor: (asOfDateImbQtyShow ?? 0) > 0 ? AppColors.red : AppColors.green,
//                   //         rightSub: (asOfDateImbQtyShow ?? 0) > 0 ? 'Needs review' : 'All clear',
//                   //         rightTap: () => showCardWithImbalanceStock(context),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//
//                   // Stock Progress Card (Cylinder Status) ──────────────────
//                   SizedBox(width: double.infinity,child: _buildStockProgressCard()),
//                   // Imbalance MiniCardGrid ───────────────────────────────────
//                   _miniCardRow(
//                     leftLabel: "Today's Imbalance",
//                     leftValue: todaysImbQtyShow.toString(),
//                     leftValueColor: AppColors.blueLight,
//                     leftSub: 'Units today',
//                     leftTap: () => showCardWithImbalanceStock(context),
//                     rightLabel: 'Total Imbalance',
//                     rightValue: asOfDateImbQtyShow.toString(),
//                     rightValueColor: (asOfDateImbQtyShow ?? 0) > 0 ? AppColors.red : AppColors.green,
//                     rightSub: (asOfDateImbQtyShow ?? 0) > 0 ? 'Needs review' : 'All clear',
//                     rightTap: () => showCardWithImbalanceStock(context),
//                   ),
//                   // Stock Difference (CDCMS) ─────────────────────────────────
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(18),
//                       boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(18),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Stock Difference (CDCMS)',
//                                   style: AppTypography.cardTitle,
//                                 ),
//                               ),
//
//                               const SizedBox(width: 12),
//
//                               SizedBox(
//                                 width: 140,
//                                 height: 40,
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButton<num>(
//                                     isExpanded: true,
//                                     value: selectedItemIdCDCMS,
//                                     style: AppTypography.cardTitle.copyWith(
//                                       color: AppColors.blue,
//                                     ),
//                                     icon: const Icon(
//                                       Icons.keyboard_arrow_down_rounded,
//                                       color: AppColors.blue,
//                                     ),
//                                     items: getManagerDashboarDetailItemWise.map((item) {
//                                       return DropdownMenuItem<num>(
//                                         value: item.itemId,
//                                         child: Text(
//                                           item.itemName ?? 'Unknown',
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                           style: AppTypography.cardSubtitle,
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedItemIdCDCMS = value!.toInt();
//
//                                         final sel =
//                                         getManagerDashboarDetailItemWise.firstWhere(
//                                               (item) =>
//                                           item.itemId == selectedItemIdCDCMS,
//                                           orElse: () =>
//                                               GetDashSummaryItemWiseForMgrModel(),
//                                         );
//
//                                         cdcmsFilledDiffShow =
//                                             sel.filledDiff?.toInt() ?? 0;
//
//                                         cdcmsEmptyDiffShow =
//                                             sel.emptyDiff?.toInt() ?? 0;
//
//                                         cdcmsDefectiveDiffShow =
//                                             sel.defectiveDiff?.toInt() ?? 0;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 14),
//                           Row(
//                             children: [
//                               Expanded(child: _stockDiffBox('Filled', cdcmsFilledDiffShow.toString(), AppColors.green, AppColors.greenXL)),
//                               const SizedBox(width: 10),
//                               Expanded(child: _stockDiffBox('Empty', cdcmsEmptyDiffShow.toString(), AppColors.orange, AppColors.orangeXL)),
//                               const SizedBox(width: 10),
//                               Expanded(child: _stockDiffBox('Defective', cdcmsDefectiveDiffShow.toString(), AppColors.red, AppColors.redXL)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // ── 4. BOOKINGS & OPERATIONS ─────────────────────────────
//                   // Mirrors: SectionHeader('Bookings & Operations', orange) +
//                   //          DataListCard(SV/TV/Unsettled) + MiniCardGrid(Refill/Cashmemo)
//                   _sectionHeader('Bookings & Operations', AppColors.orange,
//                       actionLabel: '', onAction: null),
//                   _dataListCard([
//                     _DataRow(
//                       label: 'SV Pending Status',
//                       subtitle: 'Stock verification orders',
//                       value: sVPendingStk != null ? sVPendingStk.toString() : '0',
//                       dotColor: AppColors.blueLight,
//                       badgeLabel: 'SV',
//                       badgeBg: AppColors.blueXL,
//                       badgeFg: AppColors.blue,
//                       onTap: () => Navigator.pushNamed(context,
//                           DashboardSVDetails.screenName, arguments: {'flag': 0}),
//                     ),
//                     _DataRow(
//                       label: 'TV Pending Status',
//                       subtitle: 'Transfer vehicle orders',
//                       value: tVPendingStk != null ? tVPendingStk.toString() : '0',
//                       dotColor: AppColors.teal,
//                       badgeLabel: 'TV',
//                       badgeBg: AppColors.tealXL,
//                       badgeFg: AppColors.teal,
//                       onTap: () => Navigator.pushNamed(context,
//                           DashboardTVDetails.screenName, arguments: {'flag': 0}),
//                     ),
//                     _DataRow(
//                       label: 'Unsettled Sales',
//                       subtitle: 'Count (DM wise) · ₹${formatCurrency(totalAmount ?? 0)}',
//                       value: (deliveryMenCount ?? 0).toString(),
//                       dotColor: AppColors.orange,
//                       badgeLabel: (deliveryMenCount ?? 0) == 0 ? 'Clear ✓' : 'Pending',
//                       badgeBg: (deliveryMenCount ?? 0) == 0 ? AppColors.greenXL : AppColors.orangeXL,
//                       badgeFg: (deliveryMenCount ?? 0) == 0
//                           ? const Color(0xFF166534)
//                           : const Color(0xFF9A3412),
//                       onTap: (deliveryMenCount ?? 0) > 0
//                           ? () => Navigator.pushNamed(context, UnsettledSaleDetailList.screenName)
//                           : null,
//                     ),
//                     _DataRow(
//                       label: 'Prepaid Punching — Today',
//                       subtitle: 'Tap to view punching details',
//                       value: (todaysPunchingInNiyojanC ?? 0).toString(),
//                       dotColor: AppColors.blue,
//                       badgeLabel: 'Prepaid',
//                       badgeBg: AppColors.blueXL,
//                       badgeFg: AppColors.blue,
//                       onTap: () => showBottomSheet(context),
//                     ),
//                   ]),
//                   // Refill Booking + Cashmemo MiniCardGrid ──────────────────
//                   _miniCardRow(
//                     leftLabel: 'Refill Booking',
//                     leftValue: 'Punch Now',
//                     leftValueColor: AppColors.blueLight,
//                     leftSub: '🆕 New feature',
//                     leftIsAction: true,
//                     leftGradient: const LinearGradient(
//                       colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     ),
//                     leftTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         useRootNavigator: true,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         barrierColor: AppColors.blue.withOpacity(0.5),
//                         builder: (ctx) => StatefulBuilder(
//                           builder: (ctx, setM) => GestureDetector(
//                             onTap: () {},
//                             child: showCardWithBooking(ctx, setM),
//                           ),
//                         ),
//                       );
//                     },
//                     rightLabel: 'Cashmemo',
//                     rightValue: 'Punch Now',
//                     rightValueColor: AppColors.teal,
//                     rightSub: 'Quick entry',
//                     rightIsAction: true,
//                     rightGradient: const LinearGradient(
//                       colors: [Color(0xFFF0FDFA), Color(0xFFCCFBF1)],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     ),
//                     rightTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         useRootNavigator: true,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         barrierColor: AppColors.blue.withOpacity(0.5),
//                         builder: (ctx) => StatefulBuilder(
//                           builder: (ctx, setM) => GestureDetector(
//                             onTap: () {},
//                             child: showCardWithPunching(ctx, setM),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//
//                   // ── 5. THIS MONTH'S PERFORMANCE (Owner Only) ─────────────
//                   // Mirrors: SectionHeader("This Month's Performance", green) +
//                   //          ProfitSummaryCard
//                   if (roleId == Constants.roleIdOwner) ...[
//                     // Section header with period dropdown replacing pill tabs
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 8, height: 8,
//                             decoration: BoxDecoration(
//                               color: AppColors.green,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             "THIS MONTH'S PERFORMANCE",
//                             style: AppTypography.sectionHeader,
//                           ),
//                           const Spacer(),
//                           // Dropdown replacing the "View All ›" / pill tabs
//                           Container(
//                             height: 32,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               color: AppColors.blueXL,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: AppColors.blueXXL, width: 1),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: selectedTransMode,
//                                 isDense: true,
//                                 icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blue, size: 16),
//                                 style: AppTypography.badgeText.copyWith(color: AppColors.blue),
//                                 items: getTransMode.map((mode) {
//                                   return DropdownMenuItem<String>(
//                                     value: mode,
//                                     child: Text(mode, style: AppTypography.badgeText.copyWith(color: AppColors.blue)),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   if (value == null) return;
//                                   setState(() {
//                                     selectedTransMode = value;
//                                     if (value == "Today's") dayFlag = "TODAYS";
//                                     else if (value == "This Month") dayFlag = "THISMONTH";
//                                     else if (value == "Financial Year") dayFlag = "FINYEAR";
//                                     else dayFlag = "";
//                                     fetchSVARBFilterCountList(dayFlag!);
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Profit Summary Card (matches ProfitSummaryCard layout)
//                     _buildProfitTableCard(),
//                   ],
//
//                   // ════════════════════════════════════════════════════════
//                   // REMAINING MANAGER-SPECIFIC SECTIONS (below all above)
//                   // ════════════════════════════════════════════════════════
//
//                   // ── 6. PREPAID STATUS ────────────────────────────────────
//                   _sectionHeader('Prepaid Status', AppColors.blue),
//                   _dataListCard([
//                     _DataRow(
//                       label: "Today's Punched",
//                       subtitle: 'Prepaid bookings punched today in Niyojan',
//                       value: (todaysPunchingInNiyojanC ?? 0).toString(),
//                       dotColor: AppColors.blueLight,
//                       badgeLabel: 'Today',
//                       badgeBg: AppColors.blueXL,
//                       badgeFg: AppColors.blue,
//                       onTap: () => showBottomSheet(context),
//                     ),
//                     _DataRow(
//                       label: 'Outstanding Settlement',
//                       subtitle: totalPendingSettSinceDate != null
//                           ? 'Since $totalPendingSettSinceDate'
//                           : 'Tap to view settlement list',
//                       value: '₹${formatCurrency(totalPendAmount)}',
//                       dotColor: totalPendAmount > 0 ? AppColors.red : AppColors.green,
//                       badgeLabel: totalPendAmount > 0 ? 'Pending' : 'Clear ✓',
//                       badgeBg: totalPendAmount > 0 ? AppColors.redXL : AppColors.greenXL,
//                       badgeFg: totalPendAmount > 0 ? AppColors.red : AppColors.green,
//                       onTap: () => showBottomSheetPrepaidSettlementStatus(context),
//                     ),
//                   ]),
//
//                   // ── 7. MORE (Navigation shortcuts) ──────────────────────
//                   _sectionHeader('More', AppColors.textMuted),
//                   // _miniCardRow(
//                   //   leftLabel: 'Stock Status',
//                   //   leftValue: 'View ›',
//                   //   leftValueColor: AppColors.blue,
//                   //   leftSub: 'Current inventory details',
//                   //   leftIsAction: true,
//                   //   leftGradient: const LinearGradient(
//                   //     colors: [AppColors.blueXL, AppColors.blueXXL],
//                   //     begin: Alignment.topLeft, end: Alignment.bottomRight,
//                   //   ),
//                   //   leftTap: () => showStockStatus(context),
//                   //   rightLabel: 'Sales Comparison',
//                   //   rightValue: 'View ›',
//                   //   rightValueColor: AppColors.teal,
//                   //   rightSub: 'Monthly sales analytics',
//                   //   rightIsAction: true,
//                   //   rightGradient: const LinearGradient(
//                   //     colors: [AppColors.tealXL, AppColors.tealXXL],
//                   //     begin: Alignment.topLeft, end: Alignment.bottomRight,
//                   //   ),
//                   //   rightTap: roleId == Constants.roleIdOwner
//                   //       ? () => Navigator.pushNamed(context, SalesComparisonScreen.screenName)
//                   //       : null,
//                   // ),
//
//                   _miniCardRow(
//                     leftLabel: 'Stock Status',
//                     leftValue: 'View ›',
//                     leftValueColor: AppColors.blue,
//                     leftSub: 'Current inventory details',
//                     leftIsAction: true,
//                     leftGradient: const LinearGradient(
//                       colors: [AppColors.blueXL, AppColors.blueXXL],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     ),
//                     leftTap: () => showStockStatus(context),
//                     rightLabel: 'Sales Comparison',
//                     rightValue: 'View ›',
//                     rightValueColor: AppColors.teal,
//                     rightSub: 'Monthly sales analytics',
//                     rightIsAction: true,
//                     rightGradient: const LinearGradient(
//                       colors: [AppColors.tealXL, AppColors.tealXXL],
//                       begin: Alignment.topLeft, end: Alignment.bottomRight,
//                     ),
//                     rightTap: () => Navigator.pushNamed(context, SalesComparisonScreen.screenName),
//                     rightHide: roleId != Constants.roleIdOwner,
//                   ),
//
//                   const SizedBox(height: 8),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.blue,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return
//                 Dialog(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   backgroundColor: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           width: 52, height: 52,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFEFF6FF),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: const Icon(Icons.refresh_rounded, color: Color(0xFF1E3A8A), size: 26),
//                         ),
//                         const SizedBox(height: 16),
//                         const Text("Confirm Refresh",
//                             style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
//                             textScaler: TextScaler.noScaling),
//                         const SizedBox(height: 8),
//                         const Text("Do you want to refresh data?",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
//                             textScaler: TextScaler.noScaling),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 style: OutlinedButton.styleFrom(
//                                   side: const BorderSide(color: Color(0xFFE2E8F0)),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   padding: const EdgeInsets.symmetric(vertical: 13),
//                                 ),
//                                 onPressed: () => Navigator.of(context).pop(),
//                                 child: const Text("No",
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
//                                     textScaler: TextScaler.noScaling),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.blue,
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                   padding: const EdgeInsets.symmetric(vertical: 13),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   setState(() { _onRefresh(); });
//                                 },
//                                 child: const Text("Yes",
//                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
//                                     textScaler: TextScaler.noScaling),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//             },
//           );
//         },
//         child: const Icon(Icons.refresh, color: Colors.white),
//       ),
//     );
//   }
//
//   // ── Hero Strip ─────────────────────────────────────────────────────────────
//   Widget _buildHeroStrip() {
//     return Container(
//       decoration: const BoxDecoration(gradient: AppColors.gradHero),
//       child: Stack(
//         children: [
//           Positioned.fill(child: CustomPaint(painter: _DashFlowPainter())),
//           Positioned(
//             top: -50, right: -70,
//             child: Container(
//               width: 220, height: 220,
//               decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
//             ),
//           ),
//           Positioned(
//             bottom: -40, left: -30,
//             child: Container(
//               width: 160, height: 160,
//               decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tealLight.withOpacity(0.12)),
//             ),
//           ),
//           SafeArea(
//             bottom: false,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top row: greeting + avatar
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Good ${_greeting()}, ${staffName.isNotEmpty ? staffName : 'Manager'} 👋',
//                               style: AppTypography.heroSubtitle,
//                             ),
//                             const SizedBox(height: 4),
//                             Text(distributorName.isNotEmpty ? distributorName : 'Niyojan LPG', style: AppTypography.heroTitle),
//                             const SizedBox(height: 5),
//                             Text(
//                               DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
//                               style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // ── Release Notes rocket icon ──────────────────
//                           _buildReleaseNoteIcon(),
//                           const SizedBox(width: 8),
//                           // ── Staff initials avatar ──────────────────────
//                           Container(
//                             width: 44, height: 44,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.16),
//                               borderRadius: BorderRadius.circular(13),
//                               border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                                   () {
//                                 final parts = staffName.trim().split(RegExp(r'\s+'));
//                                 if (parts.length >= 2) {
//                                   return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//                                 } else if (parts.isNotEmpty && parts[0].length >= 2) {
//                                   return parts[0].substring(0, 2).toUpperCase();
//                                 }
//                                 return 'M';
//                               }(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 18),
//                   // KPI row: Today's Revenue + Cylinders Filled (matches DashboardHeroStrip)
//                   Row(
//                     children: [
//                       // Expanded(
//                       //   child: GestureDetector(
//                       //     onTap: _scrollToFinancialOverview,
//                       //   child: _heroKpiChip(
//                       //     label: "Today's Revenue",
//                       //     value: totalIncome != null && totalIncome! > 0
//                       //         ? '₹${formatIndianCurrency(totalIncome!)}'
//                       //         : '₹0',
//                       //     sub: totalIncome != null && totalIncome! > 0
//                       //         ? 'Gross revenue'
//                       //         : 'No bookings yet',
//                       //     badgeLabel: totalIncome != null && totalIncome! > 0 ? '▲ Live' : '▼ No data',
//                       //     badgeIsGood: totalIncome != null && totalIncome! > 0,
//                       //   ),
//                       //   ),
//                       // ),
//                       Expanded(
//                         child: _heroKpiChip(
//                           label: "Today's Revenue",
//                           value: totalIncome != null && totalIncome! > 0
//                               ? '₹${formatIndianCurrency(totalIncome!)}'
//                               : '₹0',
//                           sub: totalIncome != null && totalIncome! > 0
//                               ? 'Gross revenue'
//                               : 'No bookings yet',
//                           badgeLabel: totalIncome != null && totalIncome! > 0 ? '▲ Live' : '▼ No data',
//                           badgeIsGood: totalIncome != null && totalIncome! > 0,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: _heroKpiChip(
//                           label: 'Cylinders Filled',
//                           value: (totalCurrentStockFilledTotal ?? 0).toString(),
//                           sub: '${totalCurrentStockEmptyTotal ?? 0} empty · ${totalCurrentStockDefectiveTotal ?? 0} defective',
//                           badgeLabel: (totalCurrentStockFilledTotal ?? 0) > 0 ? '✓ Good stock' : 'Low stock',
//                           badgeIsGood: (totalCurrentStockFilledTotal ?? 0) > 0,
//                         ),
//                       ),
//                       // Expanded(
//                       //   child: GestureDetector(
//                       //     onTap: _scrollToInventorySection,
//                       //     child: _heroKpiChip(
//                       //       label: 'Cylinders Filled',
//                       //       value: (totalCurrentStockFilledTotal ?? 0).toString(),
//                       //       sub:
//                       //       '${totalCurrentStockEmptyTotal ?? 0} empty · ${totalCurrentStockDefectiveTotal ?? 0} defective',
//                       //       badgeLabel: (totalCurrentStockFilledTotal ?? 0) > 0
//                       //           ? '✓ Good stock'
//                       //           : 'Low stock',
//                       //       badgeIsGood: (totalCurrentStockFilledTotal ?? 0) > 0,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _heroKpiChip({
//     required String label, required String value,
//     required String sub, required String badgeLabel, required bool badgeIsGood,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.13),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
//           const SizedBox(height: 5),
//           Text(value, style: AppTypography.heroKpiValue),
//           const SizedBox(height: 4),
//           Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
//           const SizedBox(height: 6),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//             decoration: BoxDecoration(
//               color: badgeIsGood ? AppColors.green.withOpacity(0.25) : AppColors.orange.withOpacity(0.25),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               badgeLabel,
//               style: TextStyle(
//                 color: badgeIsGood ? const Color(0xFF86EFAC) : const Color(0xFFFDBA74),
//                 fontSize: 10, fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _greeting() {
//     final h = DateTime.now().hour;
//     if (h < 12) return 'morning';
//     if (h < 17) return 'afternoon';
//     return 'evening';
//   }
//
//   Widget _stockDiffBox(String label, String value, Color valueColor, Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Text(value, style: AppTypography.kpiValueMD.copyWith(color: valueColor), textAlign: TextAlign.center),
//           const SizedBox(height: 4),
//           Text(label, style: AppTypography.labelSM, textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
//
//   /// Mirrors newTheme StockProgressCard using live current-stock data.
//   Widget _buildStockProgressCard() {
//     final filled = totalCurrentStockFilled ?? 0;
//     final empty = totalCurrentStockEmpty ?? 0;
//     final defective = totalCurrentStockDefective ?? 0;
//     final total = filled + empty + defective;
//     double filledPct = total > 0 ? filled / total : 0;
//     double emptyPct = total > 0 ? empty / total : 0;
//     double defectPct = total > 0 ? defective / total : 0;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Text(
//                 'Cylinder Stock Status',
//                 style: AppTypography.cardTitle,
//               ),
//
//               const SizedBox(width: 12),
//
//               if (getCurrentStockDetailManager.isNotEmpty)
//                 Expanded(
//                   child:
//                   DropdownButtonHideUnderline(
//                     child: DropdownButton<num>(
//                       isExpanded: true,
//                       value: selectedItemId != null ? selectedItemId!.toDouble() : null,
//                       style: AppTypography.cardSubtitle.copyWith(color: AppColors.blue),
//                       icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.blue, size: 18),
//                       items: getCurrentStockDetailManager.map((item) {
//                         return DropdownMenuItem<num>(
//                           value: item.itemId,
//                           child: Text(item.itemName ?? 'Unknown', style: AppTypography.cardSubtitle),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedItemId = value!.toInt();
//                           final sel = getCurrentStockDetailManager.firstWhere(
//                                 (item) => item.itemId == selectedItemId,
//                             orElse: () => GetCurrentStockDetailManagerModel(),
//                           );
//                           totalCurrentStockFilled = sel.filledCurrentStk?.toInt() ?? 0;
//                           totalCurrentStockEmpty = sel.emptyCurrentStk?.toInt() ?? 0;
//                           totalCurrentStockDefective = sel.deffCurrentStk?.toInt() ?? 0;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _progressRow('Filled', filled, filledPct, AppColors.green),
//           const SizedBox(height: 12),
//           _progressRow('Empty', empty, emptyPct, AppColors.orange),
//           const SizedBox(height: 12),
//           _progressRow('Defective', defective, defectPct, AppColors.red),
//         ],
//       ),
//     );
//   }
//
//   Widget _progressRow(String label, int count, double fraction, Color color) {
//     return Row(
//       children: [
//         SizedBox(width: 68, child: Text(label, style: AppTypography.progressLabel)),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: SizedBox(
//               height: 10,
//               child: LinearProgressIndicator(
//                 value: fraction.clamp(0.0, 1.0),
//                 backgroundColor: const Color(0xFFF1F5F9),
//                 valueColor: AlwaysStoppedAnimation<Color>(color),
//                 minHeight: 10,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         SizedBox(
//           width: 36,
//           child: Text(count.toString(), textAlign: TextAlign.right,
//               style: AppTypography.progressValue.copyWith(color: color)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProfitTableCard() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Table header
//           Container(
//             decoration: const BoxDecoration(
//               color: AppColors.border,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//             child: Row(
//               children: [
//                 const Expanded(flex: 1, child: Text('', style: AppTypography.labelSM)),
//                 Expanded(flex: 2, child: Text('Gross Revenue', textAlign: TextAlign.center, style: AppTypography.labelSM)),
//                 Expanded(flex: 2, child: Text('Gross Profit', textAlign: TextAlign.center, style: AppTypography.labelSM)),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: AppColors.border),
//           // NC row
//           _profitTableRow('NC', svGrossRevenueCount, null, showProfit: false,
//             onRevTap: () => Navigator.pushNamed(context, SVProfitDetailScreenUI.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
//             onProfTap: () => Navigator.pushNamed(context, SVProfitDetailScreenUI.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
//           ),
//           const Divider(height: 1, color: AppColors.border),
//           // ARB row
//           _profitTableRow('ARB', arbGrossRevenueCount, arbGrossProfitCount,
//             onRevTap: () => Navigator.pushNamed(context, ARBProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
//             onProfTap: () => Navigator.pushNamed(context, ARBProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossProfit'}),
//           ),
//           const Divider(height: 1, color: AppColors.border),
//           // Refill row
//           _profitTableRow('Refill', refillGrossRevenueCount, refillGrossProfitCount,
//             onRevTap: () => Navigator.pushNamed(context, RefillProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossRevenue'}),
//             onProfTap: () => Navigator.pushNamed(context, RefillProfitDetailScreenUi.screenName, arguments: {'DAYFLAG': dayFlag, 'PROFITFOR': 'GrossProfit'}),
//           ),
//           const Divider(height: 1, thickness: 1, color: AppColors.border),
//           // Summary rows
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//             child: Row(
//               children: [
//                 const Expanded(flex: 3, child: Text('Gross Profit =', style: AppTypography.profitRowLabel, textAlign: TextAlign.right)),
//                 Expanded(
//                   flex: 2,
//                   child: Text(totalGrossProfit != null ? formatCurrency(totalGrossProfit!) : '0',
//                       style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight),
//                       textAlign: TextAlign.center),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
//             child: Row(
//               children: [
//                 const Expanded(flex: 3, child: Text('Expenses =', style: AppTypography.profitRowLabel, textAlign: TextAlign.right)),
//                 Expanded(
//                   flex: 2,
//                   child: Text(totalExpenseForProfit != null ? formatCurrency(totalExpenseForProfit!) : '0',
//                       style: AppTypography.profitRowValue.copyWith(color: AppColors.red),
//                       textAlign: TextAlign.center),
//                 ),
//               ],
//             ),
//           ),
//           // Net profit highlight
//           Container(
//             margin: const EdgeInsets.fromLTRB(14, 8, 14, 14),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
//               borderRadius: BorderRadius.circular(13),
//             ),
//             child: Row(
//               children: [
//                 const Text('Net Profit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
//                 const Spacer(),
//                 Text(incomeProfit != null ? formatCurrency(incomeProfit!) : '0', style: AppTypography.profitHighlightValue),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _profitTableRow(String category, double? revenue, double? profit,
//       {required VoidCallback onRevTap, required VoidCallback onProfTap, bool showProfit = true}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       child: Row(
//         children: [
//           Expanded(flex: 1, child: Text(category, style: AppTypography.profitRowLabel, textAlign: TextAlign.center)),
//           Expanded(
//             flex: 2,
//             child: GestureDetector(
//               onTap: onRevTap,
//               child: Text(
//                 revenue != null ? formatCurrency(revenue) : '0',
//                 style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: showProfit
//                 ? GestureDetector(
//               onTap: onProfTap,
//               child: Text(
//                 profit != null ? formatCurrency(profit) : '0',
//                 style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             )
//                 : GestureDetector(
//               onTap: onRevTap,
//               child: Text(
//                 revenue != null ? formatCurrency(revenue) : '0',
//                 style: AppTypography.profitRowValue.copyWith(color: AppColors.blueLight, decoration: TextDecoration.underline),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Future<void> fetchDashboarDetail() async {
//   //   EasyLoading.show();
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (Constants.isNetworkAvailable) {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? godownId = prefs.getString('godownId');
//   //     String? addedBy = prefs.getString('StaffId');
//   //     String? godownKeeperId = prefs.getString('godownKeeperId');
//   //     String? token = prefs.getString('token'); // This is your bearer token
//   //
//   //     DateTime now = DateTime.now();
//   //     String formattedDate = DateFormat('yyyy-MM-dd')
//   //         .format(now); // You can change the format as needed
//   //
//   //     try {
//   //       final response = await http.get(
//   //         Uri.parse('${AppUrl.GetMobDashboardSummaryForMgr}/$distributorId'),
//   //         headers: {
//   //           'Authorization': 'Bearer $token', // Add the Bearer token here
//   //           'cDCMDPendSince': formattedDate,
//   //           'SettlementPendSince': formattedDate,
//   //           // Any other headers you need can go here
//   //         },
//   //       );
//   //
//   //       // Print the URL and the headers (including the Bearer token)
//   //       print("Request URL GetMobDashboardSummaryForMgr: ${response.request}");
//   //       print("Request Headers: {'Authorization': 'Bearer $token'}");
//   //       // Print the raw response for debugging
//   //       print(
//   //           "API Response Status GetMobDashboardSummaryForMgr: ${response.statusCode}");
//   //       print("API Response GetMobDashboardSummaryForMgr: ${response.body}");
//   //       if (response.statusCode == 200) {
//   //         final List<dynamic> data = json.decode(response.body);
//   //         setState(() {
//   //           getManagerDashboarDetail = data
//   //               .map((json) => GetManagerDashboarDetailModel.fromJson(json))
//   //               .toList();
//   //           isLoading = false;
//   //           EasyLoading.dismiss();
//   //
//   //           // Initialize totalImbQty
//   //           num dMCounts = 0;
//   //           double totalAmounts = 0;
//   //           double totalIncomes = 0;
//   //           double totalExpenses = 0;
//   //           double onAccountTodays = 0;
//   //           double onAccountAsOfDates = 0;
//   //           int asOfDateImbQtys = 0;
//   //           int todayImbCount = 0;
//   //           // int cdcmsFilledDiff = 0;
//   //           // int cdcmsEmptyDiff = 0;
//   //           // int cdcmsDefectiveDiff = 0;
//   //
//   //           // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
//   //           for (var receipt in getManagerDashboarDetail) {
//   //             // Add imbQty to totalImbQty, treating null as 0
//   //             dMCounts += receipt.dMCount ?? 0;
//   //             totalAmounts +=
//   //                 receipt.totalAmount ?? 0; // Corrected summing of imbQty
//   //             totalIncomes +=
//   //                 receipt.totalIncome ?? 0; // Corrected summing of imbQty
//   //             totalExpenses +=
//   //                 receipt.totalExp ?? 0; // Corrected summing of imbQty
//   //             onAccountTodays +=
//   //                 receipt.staffOnAccToday ?? 0; // Corrected summing of imbQty
//   //             onAccountAsOfDates +=
//   //                 receipt.staffOnAccAsOf ?? 0; // Corrected summing of imbQty
//   //             asOfDateImbQtys += (receipt.asOfDateImbQty ?? 0).toInt();
//   //             todayImbCount += (receipt.todayImbQty ?? 0).toInt();
//   //             // cdcmsFilledDiff += (receipt.filledDiff ?? 0).toInt();
//   //             // cdcmsEmptyDiff += (receipt.emptyDiff ?? 0).toInt();
//   //             // cdcmsDefectiveDiff += (receipt.defectiveDiff ?? 0).toInt();
//   //           }
//   //           asOfDateImbQtyShow = asOfDateImbQtys;
//   //           todaysImbQtyShow = todayImbCount;
//   //           // cdcmsFilledDiffShow = cdcmsFilledDiff;
//   //           // cdcmsEmptyDiffShow = cdcmsEmptyDiff;
//   //           // cdcmsDefectiveDiffShow = cdcmsDefectiveDiff;
//   //           // total = cdcmsFilledDiff + cdcmsEmptyDiff + cdcmsDefectiveDiff;
//   //           // filledPercent = cdcmsFilledDiff / total! * 100;
//   //           // emptyPercent = cdcmsEmptyDiff / total! * 100;
//   //           // defectivePercent = cdcmsDefectiveDiff / total! * 100;
//   //
//   //           // deliveryMenCount = dMCounts.toInt();
//   //           // totalAmount = totalAmounts.toDouble();
//   //           // totalIncome = totalIncomes.toDouble();
//   //           // totalExpense = totalExpenses.toDouble();
//   //           // onAccountToday = onAccountTodays.toDouble();
//   //           // onAccountAsOfDate = onAccountAsOfDates.toDouble();
//   //
//   //           // Print the totalAmount of the first item (if exists)
//   //
//   //           String _normalize(String? value) {
//   //             return value
//   //                 ?.toLowerCase()
//   //                 .replaceAll(RegExp(r'\s+'), '')
//   //                 .trim() ??
//   //                 '';
//   //           }
//   //
//   //           final defaultItem = getManagerDashboarDetail.firstWhere(
//   //                 (item) => _normalize(item.itemName) == '14.2kg',
//   //             orElse: () => GetManagerDashboarDetailModel(),
//   //           );
//   //
//   //           if (defaultItem.itemId != null) {
//   //             selectedItemIdCDCMS = defaultItem.itemId!.toInt();
//   //             // Set opening stock values
//   //             cdcmsFilledDiffShow = defaultItem.filledDiff?.toInt() ?? 0;
//   //             cdcmsEmptyDiffShow = defaultItem.emptyDiff?.toInt() ?? 0;
//   //             cdcmsDefectiveDiffShow = defaultItem.defectiveDiff!.toInt();
//   //           }
//   //           if (getManagerDashboarDetail.isNotEmpty) {
//   //             print(
//   //                 'Total Amount of the first item: ${getManagerDashboarDetail[0].totalAmount}');
//   //             deliveryMenCount = getManagerDashboarDetail[0].dMCount?.toInt();
//   //             totalAmount = getManagerDashboarDetail[0].totalAmount?.toDouble();
//   //             totalIncome = getManagerDashboarDetail[0].totalIncome?.toDouble();
//   //             totalExpense = getManagerDashboarDetail[0].totalExp?.toDouble();
//   //             onAccountToday =
//   //                 getManagerDashboarDetail[0].staffOnAccToday?.toDouble();
//   //             onAccountAsOfDate =
//   //                 getManagerDashboarDetail[0].staffOnAccAsOf?.toDouble();
//   //
//   //             todaysPunchingInNiyojanC =
//   //                 getManagerDashboarDetail[0].niyojanPun?.toInt() ?? 0;
//   //             pendingInNiyojanC =
//   //                 getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
//   //             pendingInCdcmsC =
//   //                 getManagerDashboarDetail[0].cDCMSPunPend?.toInt() ?? 0;
//   //             todaysIncorrectPunchingC =
//   //                 getManagerDashboarDetail[0].niyojanDuplicate?.toInt() ?? 0;
//   //             settlPayReceiveDelPendC =
//   //                 getManagerDashboarDetail[0].paymtDoneBtDelPend?.toInt() ?? 0;
//   //             settlDelPayPendC =
//   //                 getManagerDashboarDetail[0].delDoneBtPaymtPend?.toInt() ?? 0;
//   //             oldBkgPendNewBkgRecv =
//   //                 getManagerDashboarDetail[0].oldBkgPendNewBkgRecv?.toInt() ??
//   //                     0;
//   //             delDonNiyoJanPunPend =
//   //                 getManagerDashboarDetail[0].delDonNiyoJanPunPend?.toInt() ??
//   //                     0;
//   //             niyoJanPunDelPend =
//   //                 getManagerDashboarDetail[0].niyoJanPunDelPend?.toInt() ?? 0;
//   //             postPaidVerifPend =
//   //                 getManagerDashboarDetail[0].postPaidVerifPend?.toInt() ?? 0;
//   //             sVPendingStk =
//   //                 getManagerDashboarDetail[0].sVPendingStk?.toInt() ?? 0;
//   //             tVPendingStk =
//   //                 getManagerDashboarDetail[0].tVPendingStk?.toInt() ?? 0;
//   //             cDCMDPendSince =
//   //                 getManagerDashboarDetail[0].cDCMDPendSince?.toString();
//   //             settlementPendSince =
//   //                 getManagerDashboarDetail[0].settlementPendSince?.toString();
//   //             totalPendingSettSince =
//   //                 getManagerDashboarDetail[0].totalPendingSettSince?.toString();
//   //             paymtDoneBtDelPendAmt =
//   //                 getManagerDashboarDetail[0].paymtDoneBtDelPendAmt?.toInt() ??
//   //                     0;
//   //             delDoneBtPaymtPendAmt =
//   //                 getManagerDashboarDetail[0].delDoneBtPaymtPendAmt?.toInt() ??
//   //                     0;
//   //             totalPendingSettCnt =
//   //                 getManagerDashboarDetail[0].totalPendingSettCnt?.toInt() ?? 0;
//   //             totalPendingSettAmt =
//   //                 getManagerDashboarDetail[0].totalPendingSettAmt?.toInt() ?? 0;
//   //             postPaidVerifPendAmt =
//   //                 getManagerDashboarDetail[0].postPaidVerifPendAmt?.toInt() ??
//   //                     0;
//   //             UndocumentedSV =
//   //                 getManagerDashboarDetail[0].UndocumentedSV?.toInt() ?? 0;
//   //             TotalCrdtOutstd =
//   //                 getManagerDashboarDetail[0].TotalCrdtOutstd?.toInt() ?? 0;
//   //           }
//   //         });
//   //       } else {
//   //         // Handle non-200 responses
//   //         setState(() {
//   //           refreshTokens();
//   //           isLoading = false;
//   //           EasyLoading.dismiss();
//   //         });
//   //         // refreshTokens();
//   //         // showFlushBar(context, Constants.listGettingFail);
//   //       }
//   //     } catch (e) {
//   //       if (mounted) {
//   //         // Check if the widget is still mounted
//   //         setState(() {
//   //           refreshTokens();
//   //           EasyLoading.dismiss();
//   //           isLoading = false;
//   //         });
//   //       }
//   //       // refreshTokens();
//   //       // ScaffoldMessenger.of(context).showSnackBar(
//   //       //   SnackBar(content: Text('Error: $e')),
//   //       // );
//   //       // showFlushBar(context, Constants.listGettingFail);
//   //     }
//   //   } else {
//   //     EasyLoading.dismiss();
//   //     showFlushBar(context, Constants.connectionMessage);
//   //   }
//   // }
//
//   Future<void> fetchDashboarDetailItemWise() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       DateTime now = DateTime.now();
//       String formattedDate = DateFormat('yyyy-MM-dd')
//           .format(now); // You can change the format as needed
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDashSummaryItemWiseForMgr}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//             'cDCMDPendSince': formattedDate,
//             'SettlementPendSince': formattedDate,
//             // Any other headers you need can go here
//           },
//         );
//
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL GetDashSummaryItemWiseForMgr: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print(
//             "API Response Status GetDashSummaryItemWiseForMgr: ${response.statusCode}");
//         print("API Response GetDashSummaryItemWiseForMgr: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getManagerDashboarDetailItemWise = data
//                 .map((json) => GetDashSummaryItemWiseForMgrModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//             EasyLoading.dismiss();
//
//             // Initialize totalImbQty
//             num dMCounts = 0;
//             double totalAmounts = 0;
//             double totalIncomes = 0;
//             double totalExpenses = 0;
//             double onAccountTodays = 0;
//             double onAccountAsOfDates = 0;
//             int asOfDateImbQtys = 0;
//             int todayImbCount = 0;
//
//             String _normalize(String? value) {
//               return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ?? '';
//             }
//             final defaultItem = getManagerDashboarDetailItemWise.firstWhere(
//                   (item) => _normalize(item.itemName) == '14.2kg',
//               orElse: () => GetDashSummaryItemWiseForMgrModel(),
//             );
//
//             if (defaultItem.itemId != null) {
//               selectedItemIdCDCMS = defaultItem.itemId!.toInt();
//               // Set opening stock values
//
//               cdcmsFilledDiffShow = defaultItem.filledDiff?.toInt() ?? 0;
//               cdcmsEmptyDiffShow = defaultItem.emptyDiff?.toInt() ?? 0;
//               cdcmsDefectiveDiffShow = defaultItem.defectiveDiff!.toInt();
//             }
//             for (var receipt in getManagerDashboarDetailItemWise) {
//               asOfDateImbQtys += (receipt.asOfDateImbQty ?? 0).toInt();
//               todayImbCount += (receipt.todayImbQty ?? 0).toInt();
//             }
//             asOfDateImbQtyShow = asOfDateImbQtys;
//             todaysImbQtyShow = todayImbCount;
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchDashboarDetailForAllCount() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       DateTime now = DateTime.now();
//       String formattedDate = DateFormat('yyyy-MM-dd')
//           .format(now); // You can change the format as needed
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDashSummaryAllCountForMgr}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//             'cDCMDPendSince': formattedDate,
//             'SettlementPendSince': formattedDate,
//             // Any other headers you need can go here
//           },
//         );
//
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL GetDashSummaryAllCountForMgr: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print(
//             "API Response Status GetDashSummaryAllCountForMgr: ${response.statusCode}");
//         print("API Response GetDashSummaryAllCountForMgr: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getManagerDashboarDetailAllCount = data
//                 .map((json) => GetDashSummaryAllCountForMgrModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//             EasyLoading.dismiss();
//
//             // Initialize totalImbQty
//             num dMCounts = 0;
//             double totalAmounts = 0;
//             double totalIncomes = 0;
//             double totalExpenses = 0;
//             double onAccountTodays = 0;
//             double onAccountAsOfDates = 0;
//             int asOfDateImbQtys = 0;
//             int todayImbCount = 0;
//             // int cdcmsFilledDiff = 0;
//             // int cdcmsEmptyDiff = 0;
//             // int cdcmsDefectiveDiff = 0;
//
//             // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
//             for (var receipt in getManagerDashboarDetailAllCount) {
//               // Add imbQty to totalImbQty, treating null as 0
//               dMCounts += receipt.dMCount ?? 0;
//               totalAmounts +=
//                   receipt.totalAmount ?? 0; // Corrected summing of imbQty
//               totalIncomes +=
//                   receipt.totalIncome ?? 0; // Corrected summing of imbQty
//               totalExpenses +=
//                   receipt.totalExp ?? 0; // Corrected summing of imbQty
//               onAccountTodays +=
//                   receipt.staffOnAccToday ?? 0; // Corrected summing of imbQty
//               onAccountAsOfDates +=
//                   receipt.staffOnAccAsOf ?? 0; // Corrected summing of imbQty
//
//               if (getManagerDashboarDetailAllCount.isNotEmpty) {
//                 print(
//                     'Total Amount of the first item: ${getManagerDashboarDetailAllCount[0]
//                         .totalAmount}');
//                 deliveryMenCount =
//                     getManagerDashboarDetailAllCount[0].dMCount?.toInt();
//                 totalAmount =
//                     getManagerDashboarDetailAllCount[0].totalAmount?.toDouble();
//                 totalIncome =
//                     getManagerDashboarDetailAllCount[0].totalIncome?.toDouble();
//                 totalExpense =
//                     getManagerDashboarDetailAllCount[0].totalExp?.toDouble();
//                 onAccountToday =
//                     getManagerDashboarDetailAllCount[0].staffOnAccToday
//                         ?.toDouble();
//                 onAccountAsOfDate =
//                     getManagerDashboarDetailAllCount[0].staffOnAccAsOf
//                         ?.toDouble();
//                 postPaidVerifPend =
//                     getManagerDashboarDetailAllCount[0].postPaidVerifPend
//                         ?.toInt() ?? 0;
//                 sVPendingStk =
//                     getManagerDashboarDetailAllCount[0].sVPendingStk?.toInt() ??
//                         0;
//                 tVPendingStk =
//                     getManagerDashboarDetailAllCount[0].tVPendingStk?.toInt() ??
//                         0;
//                 postPaidVerifPendAmt =
//                     getManagerDashboarDetailAllCount[0].postPaidVerifPendAmt
//                         ?.toInt() ?? 0;
//                 TotalCrdtOutstd = getManagerDashboarDetailAllCount[0].totalCrdtOutstd?.toInt() ?? 0;
//
//                 UndocumentedSV = getManagerDashboarDetailAllCount[0].undocumentedSV?.toInt() ?? 0;
//
//                 TotalVendorDueAmt = getManagerDashboarDetailAllCount[0].totalVendorDueAmt?.toInt() ?? 0;
//               }
//             }
//           });
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           // Check if the widget is still mounted
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchDashboarDetailForSettItem() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       DateTime now = DateTime.now();
//       String formattedDate = DateFormat('yyyy-MM-dd')
//           .format(now); // You can change the format as needed
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDashSummarySettAllCountForMgr}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//             'cDCMDPendSince': formattedDate,
//             'SettlementPendSince': formattedDate,
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL GetMobDashboardSummaryForMgr: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print(
//             "API Response Status GetMobDashboardSummaryForMgr: ${response.statusCode}");
//         print("API Response GetMobDashboardSummaryForMgr: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getManagerDashboarDetailSettCount = data
//                 .map((json) => GetDashSummarySettAllCountForMgrModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//             EasyLoading.dismiss();
//
//             // Initialize totalImbQty
//             num dMCounts = 0;
//             double totalAmounts = 0;
//             double totalIncomes = 0;
//             double totalExpenses = 0;
//             double onAccountTodays = 0;
//             double onAccountAsOfDates = 0;
//             int asOfDateImbQtys = 0;
//             int todayImbCount = 0;
//
//             // asOfDateImbQtyShow = asOfDateImbQtys;
//             // todaysImbQtyShow = todayImbCount;
//
//
//             String _normalize(String? value) {
//               return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ?? '';
//             }
//
//             if (getManagerDashboarDetailSettCount.isNotEmpty) {
//               print(
//                   'niyojan Amount of the first item: ${getManagerDashboarDetailSettCount[0]
//                       .niyojanPun}');
//               todaysPunchingInNiyojanC =
//                   getManagerDashboarDetailSettCount[0].niyojanPun?.toInt() ?? 0;
//               pendingInNiyojanC =
//                   getManagerDashboarDetailSettCount[0].niyoJanPunDelPend?.toInt() ?? 0;
//               pendingInCdcmsC =
//                   getManagerDashboarDetailSettCount[0].cDCMSPunPend?.toInt() ?? 0;
//               todaysIncorrectPunchingC =
//                   getManagerDashboarDetailSettCount[0].niyojanDuplicate?.toInt() ?? 0;
//               settlPayReceiveDelPendC =
//                   getManagerDashboarDetailSettCount[0].paymtDoneBtDelPend?.toInt() ?? 0;
//               settlDelPayPendC =
//                   getManagerDashboarDetailSettCount[0].delDoneBtPaymtPend?.toInt() ?? 0;
//               oldBkgPendNewBkgRecv =
//                   getManagerDashboarDetailSettCount[0].oldBkgPendNewBkgRecv?.toInt() ??
//                       0;
//               delDonNiyoJanPunPend =
//                   getManagerDashboarDetailSettCount[0].delDonNiyoJanPunPend?.toInt() ??
//                       0;
//               niyoJanPunDelPend =
//                   getManagerDashboarDetailSettCount[0].niyoJanPunDelPend?.toInt() ?? 0;
//               cDCMDPendSince =
//                   getManagerDashboarDetailSettCount[0].cDCMDPendSince?.toString();
//               settlementPendSince =
//                   getManagerDashboarDetailSettCount[0].settlementPendSince?.toString();
//               totalPendingSettSince =
//                   getManagerDashboarDetailSettCount[0].totalPendingSettSince?.toString();
//               paymtDoneBtDelPendAmt =
//                   getManagerDashboarDetailSettCount[0].paymtDoneBtDelPendAmt?.toInt() ??
//                       0;
//               delDoneBtPaymtPendAmt =
//                   getManagerDashboarDetailSettCount[0].delDoneBtPaymtPendAmt?.toInt() ??
//                       0;
//               totalPendingSettCnt =
//                   getManagerDashboarDetailSettCount[0].totalPendingSettCnt?.toInt() ?? 0;
//               totalPendingSettAmt =
//                   getManagerDashboarDetailSettCount[0].totalPendingSettAmt?.toInt() ?? 0;
//             }
//           });
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     print("Request URL InventoryCurrentStockDtlsForMobDash:");
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//       print("StaffId $addedBy'}");
//       try {
//         final response = await http.get(
//           Uri.parse(
//               '${AppUrl.InventoryCurrentStockDtlsForMobDash}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print(
//             "Request URL InventoryCurrentStockDtlsForMobDash: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print(
//             "API Response Status InventoryCurrentStockDtlsForMobDash: ${response.statusCode}");
//         print(
//             "API Response InventoryCurrentStockDtlsForMobDash: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStockDetailManager = data
//                 .map((json) => GetCurrentStockDetailManagerModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//
//             int totalOpeningStockFilledShow = 0;
//             int totalOpeningStockEmptyShow = 0;
//             int totalOpeningStockDefectiveShow = 0;
//             int totalCurrentStockFilledShow = 0;
//             int totalCurrentStockEmptyShow = 0;
//             int totalCurrentStockDefectiveShow = 0;
//
//             // // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
//             for (var receipt in getCurrentStockDetailManager) {
//               // totalOpeningStockFilledShow += (receipt.filledOpeningStk ?? 0)
//               //     .toInt(); // Corrected summing of imbQty
//               // totalOpeningStockEmptyShow += (receipt.emptyOpeningStk ?? 0)
//               //     .toInt(); // Corrected summing of imbQty
//               // totalOpeningStockDefectiveShow +=
//               //     (receipt.deffOpeningStk ?? 0).toInt();
//               totalCurrentStockFilledShow +=
//                   (receipt.filledCurrentStk ?? 0).toInt();
//               totalCurrentStockEmptyShow +=
//                   (receipt.emptyCurrentStk ?? 0).toInt();
//               totalCurrentStockDefectiveShow +=
//                   (receipt.deffCurrentStk ?? 0).toInt();
//             }
//             // totalOpeningStockFilled = totalOpeningStockFilledShow;
//             // totalOpeningStockEmpty = totalOpeningStockEmptyShow;
//             // totalOpeningStockDefective = totalOpeningStockDefectiveShow;
//             totalCurrentStockFilledTotal = totalCurrentStockFilledShow;
//             totalCurrentStockEmptyTotal = totalCurrentStockEmptyShow;
//             totalCurrentStockDefectiveTotal = totalCurrentStockDefectiveShow;
//
//             // Assuming getCurrentStockDetailManager is already populated
//             String _normalize(String? value) {
//               return value
//                   ?.toLowerCase()
//                   .replaceAll(RegExp(r'\s+'), '')
//                   .trim() ??
//                   '';
//             }
//
//             final defaultItem = getCurrentStockDetailManager.firstWhere(
//                   (item) => _normalize(item.itemName) == '14.2kg',
//               orElse: () => GetCurrentStockDetailManagerModel(),
//             );
//
//             if (defaultItem.itemId != null) {
//               selectedItemId = defaultItem.itemId!.toInt();
//
//               // Set opening stock values
//               totalOpeningStockFilled =
//                   defaultItem.filledOpeningStk?.toInt() ?? 0;
//               totalOpeningStockEmpty =
//                   defaultItem.emptyOpeningStk?.toInt() ?? 0;
//               totalOpeningStockDefective =
//                   defaultItem.deffOpeningStk?.toInt() ?? 0;
//               totalCurrentStockFilled = defaultItem.filledCurrentStk!.toInt();
//               totalCurrentStockEmpty = defaultItem.emptyCurrentStk!.toInt();
//               totalCurrentStockDefective = defaultItem.deffCurrentStk!.toInt();
//             }
//             EasyLoading.dismiss();
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//           // refreshTokens();
//           // showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         if (mounted) {
//           // Check if the widget is still mounted
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//             showFlushBar(context, Constants.listGettingFail);
//           });
//         }
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchSavedData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String isAlreadyLogin =
//       preferences.getString("IsAlreadyLogin").toString();
//       debugPrint("isAlreadyLogin$isAlreadyLogin");
//       if (isAlreadyLogin == "0" ||
//           isAlreadyLogin == null ||
//           isAlreadyLogin == "null" ||
//           isAlreadyLogin.isEmpty) {
//         _showLogoutDialog(context);
//       } else {}
//     } catch (error) {
//       rethrow;
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchCurrentStock();
//             // fetchDashboarDetail();
//             fetchDashboarDetailForSettItem();
//             fetchSVARBFilterCountList("THISMONTH");
//           } else if (response['message'] == "Token Expired") {
//             debugPrint('RefreshTokenExc401 - true');
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = "Session Expired";
//         String message = "Your session has expired. Please log in again.";
//         String btnLabel = "OK";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(title, style: Styling.bodyTitle, textScaler: TextScaler.noScaling),
//             content: Text(message, style: Styling.bodyTitle, textScaler: TextScaler.noScaling),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel, style: Styling.blueClrText, textScaler: TextScaler.noScaling),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: Dialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             backgroundColor: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 52, height: 52,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFEF2F2),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(Icons.lock_clock_rounded, color: Color(0xFFEF4444), size: 26),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(title,
//                       style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
//                       textScaler: TextScaler.noScaling),
//                   const SizedBox(height: 8),
//                   Text(message,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
//                       textScaler: TextScaler.noScaling),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1E3A8A),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         padding: const EdgeInsets.symmetric(vertical: 13),
//                       ),
//                       onPressed: () => logoutUser(context),
//                       child: Text(btnLabel,
//                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
//                           textScaler: TextScaler.noScaling),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     ///Save data before logout logic
//     EasyLoading.show(status: 'Loading...');
//
//     try {
//       SharedPref().removeUser();
//
//       // try {
//       //   if (Platform.isAndroid) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
//       //   } else if (Platform.isIOS) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
//       //   }
//       // } on PlatformException {
//       //   debugPrint('###PlatformExc');
//       // }
//
//       EasyLoading.dismiss();
//
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
//
//   String formatCurrency(double amount) {
//     if (amount == 0) {
//       return '0.00'; // Return "0.00" if the amount is zero
//     }
//     final format =
//     NumberFormat('#,##,###.00', 'en_IN'); // Indian locale without symbol
//
//     return format.format(amount);
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 52, height: 52,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF7ED),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.logout_rounded, color: Color(0xFFF97316), size: 26),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "Confirm Logout",
//                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
//                   textScaler: TextScaler.noScaling,
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Please log in to the application again.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF6B7280)),
//                   textScaler: TextScaler.noScaling,
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1E3A8A),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       padding: const EdgeInsets.symmetric(vertical: 13),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       logoutUser(context);
//                     },
//                     child: const Text("OK",
//                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
//                         textScaler: TextScaler.noScaling),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFF8FAFC),
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(28),
//             ),
//           ),
//
//           child: SafeArea(
//             child: DraggableScrollableSheet(
//               initialChildSize: 0.78,
//               minChildSize: 0.55,
//               maxChildSize: 0.95,
//               expand: false,
//
//               builder: (context, scrollController) {
//                 return Column(
//                   children: [
//
//                     // ── Drag Handle ─────────────────────────────
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         margin: const EdgeInsets.only(
//                           top: 12,
//                           bottom: 0,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFCBD5E1),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//
//                     // ── Header ──────────────────────────────────
//                     Container(
//                       margin: const EdgeInsets.fromLTRB(
//                         12,
//                         12,
//                         12,
//                         0,
//                       ),
//
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF1E3A8A),
//                             Color(0xFF1D6B7A),
//                             Color(0xFF0F766E),
//                           ],
//                           stops: [0.0, 0.5, 1.0],
//                         ),
//
//                         borderRadius: BorderRadius.circular(16),
//
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF1E3A8A)
//                                 .withValues(alpha: 0.25),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//
//                       child: Row(
//                         children: [
//
//                           Container(
//                             width: 40,
//                             height: 40,
//
//                             decoration: BoxDecoration(
//                               color: Colors.white.withValues(alpha: 0.18),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//
//                             child: const Icon(
//                               Icons.credit_card_rounded,
//                               color: Colors.white,
//                               size: 22,
//                             ),
//                           ),
//
//                           const SizedBox(width: 12),
//
//                           const Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//
//                               mainAxisSize: MainAxisSize.min,
//
//                               children: [
//                                 Text(
//                                   "PREPAID PUNCHING STATUS",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w800,
//                                     color: Colors.white,
//                                     letterSpacing: 0.8,
//                                   ),
//                                   textScaler: TextScaler.noScaling,
//                                 ),
//
//                                 SizedBox(height: 2),
//
//                                 Text(
//                                   "Real-time punching overview",
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.white70,
//                                   ),
//                                   textScaler: TextScaler.noScaling,
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           Visibility(
//                             visible: roleId == Constants.roleIdOwner,
//
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                   context,
//                                   PrepaidBookingAndSettlementGraphScreen
//                                       .screenName,
//                                 );
//                               },
//
//                               child: Container(
//                                 padding:
//                                 const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 6,
//                                 ),
//
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withValues(
//                                     alpha: 0.2,
//                                   ),
//
//                                   borderRadius:
//                                   BorderRadius.circular(20),
//
//                                   border: Border.all(
//                                     color: Colors.white.withValues(
//                                       alpha: 0.35,
//                                     ),
//                                     width: 1,
//                                   ),
//                                 ),
//
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       "Graph",
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                       ),
//                                       textScaler:
//                                       TextScaler.noScaling,
//                                     ),
//
//                                     SizedBox(width: 3),
//
//                                     Icon(
//                                       Icons.bar_chart_rounded,
//                                       size: 13,
//                                       color: Colors.white,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // ── Scrollable Content ─────────────────────
//                     Expanded(
//                       child: SingleChildScrollView(
//                         controller: scrollController,
//
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(
//                             12,
//                             12,
//                             12,
//                             20,
//                           ),
//
//                           child: Column(
//                             children: [
//
//                               // ── Row 1 ────────────────────
//                               Row(
//                                 children: [
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       todaysPunchingInNiyojanC
//                                           .toString(),
//
//                                       label:
//                                       "Today's Niyojan Punched",
//
//                                       icon: Icons
//                                           .check_circle_outline_rounded,
//
//                                       accentColor:
//                                       const Color(0xFF0F766E),
//
//                                       bgColor:
//                                       const Color(0xFFF0FDFA),
//
//                                       onTap: () {
//                                         todaysPunchingInNiyojanC! >
//                                             0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "Punching"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//
//                                   const SizedBox(width: 8),
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       todaysIncorrectPunchingC
//                                           .toString(),
//
//                                       label:
//                                       "Today's Incorrect",
//
//                                       icon: Icons
//                                           .warning_amber_rounded,
//
//                                       accentColor:
//                                       const Color(0xFFD97706),
//
//                                       bgColor:
//                                       const Color(0xFFFFFBEB),
//
//                                       onTap: () {
//                                         todaysIncorrectPunchingC! >
//                                             0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "Incorrect"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 8),
//
//                               // ── Row 2 ────────────────────
//                               Row(
//                                 children: [
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       pendingInCdcmsC.toString(),
//
//                                       label:
//                                       "Pending in cDCMS\n(Since $formattedDatecdcms)",
//
//                                       icon: Icons
//                                           .hourglass_top_rounded,
//
//                                       accentColor:
//                                       const Color(0xFFEF4444),
//
//                                       bgColor:
//                                       const Color(0xFFFEF2F2),
//
//                                       onTap: () {
//                                         pendingInCdcmsC! > 0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "cDCMS"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//
//                                   const SizedBox(width: 8),
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       oldBkgPendNewBkgRecv
//                                           .toString(),
//
//                                       label:
//                                       "Old Pending, New Booking Received",
//
//                                       icon: Icons
//                                           .swap_horiz_rounded,
//
//                                       accentColor:
//                                       const Color(0xFFF97316),
//
//                                       bgColor:
//                                       const Color(0xFFFFF7ED),
//
//                                       onTap: () {
//                                         oldBkgPendNewBkgRecv! > 0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "OldBkgPendNewBkgRecv"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 8),
//
//                               // ── Row 3 ────────────────────
//                               Row(
//                                 children: [
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       delDonNiyoJanPunPend
//                                           .toString(),
//
//                                       label:
//                                       "Delivered in cDCMS, Pending in Niyojan",
//
//                                       icon: Icons
//                                           .cloud_done_outlined,
//
//                                       accentColor:
//                                       const Color(0xFF2D52C5),
//
//                                       bgColor:
//                                       const Color(0xFFEFF6FF),
//
//                                       onTap: () {
//                                         delDonNiyoJanPunPend! > 0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "DelDonNiyoJanPunPend"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//
//                                   const SizedBox(width: 8),
//
//                                   Expanded(
//                                     child: _buildPunchStatusCard(
//                                       value:
//                                       niyoJanPunDelPend
//                                           .toString(),
//
//                                       label:
//                                       "Punched in Niyojan, Pending in cDCMS",
//
//                                       icon:
//                                       Icons.upload_rounded,
//
//                                       accentColor:
//                                       const Color(0xFF7C3AED),
//
//                                       bgColor:
//                                       const Color(0xFFF5F3FF),
//
//                                       onTap: () {
//                                         niyoJanPunDelPend! > 0
//                                             ? Navigator.pushNamed(
//                                           context,
//                                           DashboardPrepaidDetails
//                                               .screenName,
//                                           arguments: {
//                                             "flag":
//                                             "NiyoJanPunDelPend"
//                                           },
//                                         )
//                                             : null;
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 16),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildPunchStatusCard({
//     required String value,
//     required String label,
//     required IconData icon,
//     required Color accentColor,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     final int count = int.tryParse(value) ?? 0;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border(
//             top: BorderSide(color: accentColor, width: 3),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: accentColor.withValues(alpha: 0.08),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 34, height: 34,
//                   decoration: BoxDecoration(
//                     color: bgColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: accentColor, size: 18),
//                 ),
//                 if (count > 0)
//                   Container(
//                     padding: const EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: accentColor.withValues(alpha: 0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.arrow_forward_rounded, color: accentColor, size: 12),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w800,
//                 color: count > 0 ? accentColor : const Color(0xFF6B7280),
//                 letterSpacing: -0.5,
//                 height: 1.0,
//               ),
//               textScaler: TextScaler.noScaling,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF6B7280),
//                 height: 1.3,
//               ),
//               textScaler: TextScaler.noScaling,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showBottomSheetPrepaidSettlementStatus(BuildContext context) {
//     final totalPendAmount = totalPendingSettAmt?.toDouble() ?? 0.0;
//     final totalDoneBtDelPend = paymtDoneBtDelPendAmt?.toDouble() ?? 0.0;
//     final totaldelDoneBtPaymtPend = delDoneBtPaymtPendAmt?.toDouble() ?? 0.0;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFF8FAFC),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Drag handle
//                   Center(
//                     child: Container(
//                       width: 40, height: 4,
//                       margin: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFCBD5E1),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   // Header
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 14),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 6, height: 6,
//                           margin: const EdgeInsets.only(right: 8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF1E3A8A),
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "PREPAID SETTLEMENT STATUS",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF374151),
//                                 letterSpacing: 0.8,
//                               ),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                             Text(
//                               "Data ref. cDCMS",
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFF6B7280),
//                               ),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildSettlementCard(
//                           count: settlPayReceiveDelPendC.toString(),
//                           amount: formatCurrency(totalDoneBtDelPend),
//                           label: "Payment done, delivery pending",
//                           accentColor: const Color(0xFF0F766E),
//                           bgColor: const Color(0xFFF0FDFA),
//                           onTap: settlPayReceiveDelPendC != null && settlPayReceiveDelPendC! > 0
//                               ? () {
//                             Navigator.pushNamed(
//                                 context,
//                                 DashboardPrepaidDetails.screenName,
//                                 arguments: {"flag": "Settled"});
//                           }
//                               : null,
//                           dividerWidget: verticalDividerSmallestRed(),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: _buildSettlementCard(
//                           count: settlDelPayPendC.toString(),
//                           amount: formatCurrency(totaldelDoneBtPaymtPend),
//                           label: "Since ($formattedDate) Delivered, payment pending",
//                           accentColor: const Color(0xFFD97706),
//                           bgColor: const Color(0xFFFFFBEB),
//                           onTap: settlDelPayPendC != null && settlDelPayPendC! > 0
//                               ? () {
//                             Navigator.pushNamed(
//                                 context,
//                                 DashboardPrepaidDetails.screenName,
//                                 arguments: {"flag": "Delivered"});
//                           }
//                               : null,
//                           dividerWidget: verticalDividerSmallestRed(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildSettlementCard(
//                           count: totalPendingSettCnt.toString(),
//                           amount: formatCurrency(totalPendAmount),
//                           label: "Since ($totalPendingSettSinceDate) Total Outstanding Pending",
//                           accentColor: const Color(0xFFEF4444),
//                           bgColor: const Color(0xFFFEF2F2),
//                           onTap: totalPendingSettCnt != null && totalPendingSettCnt! > 0
//                               ? () {
//                             Navigator.pushNamed(
//                                 context,
//                                 DashboardPrepaidDetails.screenName,
//                                 arguments: {"flag": "TotalOutstanding"});
//                           }
//                               : null,
//                           dividerWidget: verticalDividerSmallestRed(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSettlementCard({
//     required String count,
//     required String amount,
//     required String label,
//     required Color accentColor,
//     required Color bgColor,
//     required VoidCallback? onTap,
//     required Widget dividerWidget,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(14),
//           border: Border(left: BorderSide(color: accentColor, width: 3)),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0x0D1E3A8A),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   count,
//                   style: Styling.countNumber.copyWith(
//                     color: const Color(0xFF2D52C5),
//                     fontSize: 18,
//                     decoration: TextDecoration.underline,
//                     decorationColor: const Color(0xFF2D52C5),
//                   ),
//                   textScaler: TextScaler.noScaling,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: dividerWidget,
//                 ),
//                 Flexible(
//                   child: Text(
//                     amount,
//                     style: Styling.countNumber.copyWith(
//                       color: const Color(0xFF111827),
//                       fontSize: 16,
//                     ),
//                     textScaler: TextScaler.noScaling,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: accentColor,
//                 height: 1.3,
//               ),
//               textScaler: TextScaler.noScaling,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard(String count, String title, Color bgColor,
//       {required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: SizedBox(
//         height: 120,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//           ),
//           elevation: 0,
//           color: bgColor,
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Column(
//               children: [
//                 Text(
//                   count,
//                   style: Styling.bodyTitleWithBlueHightDash.copyWith(
//                     color: Colors.blue,
//                     decoration: TextDecoration.underline,
//                     decorationColor: Colors.blue,
//                   ),
//                   textScaler: TextScaler.noScaling,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF1E3A8A),
//                   ),
//                   textScaler: TextScaler.noScaling,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTableCell(String content) {
//     return Expanded(
//       child: Text(
//         content,
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.black87,
//         ),
//         textAlign: TextAlign.center,
//         textScaler: TextScaler.noScaling,
//       ),
//     );
//   }
//
//   Widget buildTableHeader(String title) {
//     return Expanded(
//       child: Text(
//         title,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//           color: Colors.black,
//         ),
//         textAlign: TextAlign.center,
//         textScaler: TextScaler.noScaling,
//       ),
//     );
//   }
//
//   void showCardWithImbalanceStock(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (context, animation1, animation2) {
//         return Align(
//           alignment: Alignment.bottomCenter,
//           child: GestureDetector(
//             onHorizontalDragEnd: (details) {
//               if (details.primaryVelocity != null &&
//                   details.primaryVelocity!.abs() > 300) {
//                 Navigator.pop(context);
//               }
//             },
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8FAFC),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Column(
//                 children: [
//                   // Drag handle
//                   Center(
//                     child: Container(
//                       width: 40, height: 4,
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFCBD5E1),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Header
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 6, height: 6,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFD97706),
//                                     borderRadius: BorderRadius.circular(2),
//                                   ),
//                                 ),
//                                 const Text(
//                                   'IMBALANCE STOCK',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF374151),
//                                     letterSpacing: 0.8,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Table
//                           Expanded(
//                             child: getManagerDashboarDetailItemWise.isNotEmpty
//                                 ? Column(
//                               children: [
//                                 // Table header with gradient
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10),
//                                     ),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
//                                   child: Row(
//                                     children: [
//                                       Expanded(child: Text("Item Name", style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
//                                       Expanded(child: Text("Today's Imb Qty", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
//                                       Expanded(child: Text("As Of Imb Qty", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13), textScaler: TextScaler.noScaling)),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: ListView.builder(
//                                     padding: EdgeInsets.zero,
//                                     physics: const BouncingScrollPhysics(),
//                                     itemCount: getManagerDashboarDetailItemWise
//                                         .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
//                                         .toList()
//                                         .length,
//                                     itemBuilder: (context, index) {
//                                       var item = getManagerDashboarDetailItemWise
//                                           .where((item) => item.todayImbQty! > 0 || item.asOfDateImbQty! > 0)
//                                           .toList()[index];
//                                       final bg = index.isEven ? const Color(0xFFEFF6FF) : Colors.white;
//                                       return Container(
//                                         color: bg,
//                                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                               child: Text(item.itemName ?? '', style: Styling.textFormText, textScaler: TextScaler.noScaling),
//                                             ),
//                                             Expanded(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   print('Tapped on today imbalance qty: ${item.todayImbQty}');
//                                                   Navigator.pushNamed(context, ImbalanceCountClickUI.screenName,
//                                                       arguments: {"ItemId": item.itemId, "imbQtyType": 'today'});
//                                                 },
//                                                 child: Text(item.todayImbQty.toString(),
//                                                     style: Styling.textFormTextWithUnderline,
//                                                     textAlign: TextAlign.center,
//                                                     textScaler: TextScaler.noScaling),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   print('Tapped on as of date imbalance qty: ${item.asOfDateImbQty}');
//                                                   Navigator.pushNamed(context, ImbalanceCountClickUI.screenName,
//                                                       arguments: {"ItemId": item.itemId, "imbQtyType": 'asOfDate'});
//                                                 },
//                                                 child: Text(item.asOfDateImbQty.toString(),
//                                                     style: Styling.textFormTextWithUnderline,
//                                                     textAlign: TextAlign.center,
//                                                     textScaler: TextScaler.noScaling),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )
//                                 : Center(
//                               child: Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFEFF6FF),
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(Icons.info_outline_rounded, color: Color(0xFF1E3A8A)),
//                                     const SizedBox(width: 8),
//                                     const Text(
//                                       'No Data Available',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color(0xFF1E3A8A),
//                                       ),
//                                       textScaler: TextScaler.noScaling,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation1, animation2, child) {
//         final offsetAnimation = Tween<Offset>(
//           begin: const Offset(0, 1),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));
//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     );
//   }
//
//   void showStockStatus(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (context, animation1, animation2) {
//         return Align(
//           alignment: Alignment.bottomCenter,
//           child: GestureDetector(
//             onHorizontalDragEnd: (details) {
//               if (details.primaryVelocity != null &&
//                   details.primaryVelocity!.abs() > 300) {
//                 Navigator.pop(context); // Close if swipe velocity is high
//               }
//             },
//             child: StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setModalState) {
//                   return Container(
//                     height: MediaQuery.of(context).size.height * 0.9,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF8FAFC),
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                     ),
//                     child: Column(
//                       children: [
//                         // Drag handle
//                         Center(
//                           child: Container(
//                             width: 40, height: 4,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFCBD5E1),
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Header row
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 14),
//                                     child: Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () => Navigator.pop(context),
//                                           child: Container(
//                                             width: 36, height: 36,
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFFE2E8F0),
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             child: const Icon(Icons.arrow_back_ios_new_rounded,
//                                                 size: 16, color: Color(0xFF374151)),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Row(
//                                           children: [
//                                             Container(
//                                               width: 6, height: 6,
//                                               margin: const EdgeInsets.only(right: 8),
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xFF1E3A8A),
//                                                 borderRadius: BorderRadius.circular(2),
//                                               ),
//                                             ),
//                                             const Text(
//                                               'STOCK STATUS',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Color(0xFF374151),
//                                                 letterSpacing: 0.8,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Opening Stock label + dropdown
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "Opening Stock Status",
//                                           style: const TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                             color: Color(0xFF6B7280),
//                                           ),
//                                           textScaler: TextScaler.noScaling,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Flexible(
//                                         child: Container(
//                                           height: 40,
//                                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(10),
//                                             border: Border.all(color: const Color(0xFFE2E8F0)),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: const Color(0x0D1E3A8A),
//                                                 blurRadius: 6,
//                                               ),
//                                             ],
//                                           ),
//                                           child: DropdownButtonHideUnderline(
//                                             child: DropdownButton<num>(
//                                               isExpanded: true,
//                                               value: selectedItemId,
//                                               items: getCurrentStockDetailManager.map((item) {
//                                                 return DropdownMenuItem<num>(
//                                                   value: item.itemId,
//                                                   child: Text(
//                                                     item.itemName ?? 'Unknown',
//                                                     style: Styling.dropdownVerySmallText,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     maxLines: 1,
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (value) {
//                                                 setModalState(() {
//                                                   selectedItemId = value!.toInt();
//                                                   final selectedItem =
//                                                   getCurrentStockDetailManager.firstWhere(
//                                                         (item) => item.itemId == selectedItemId,
//                                                     orElse: () => GetCurrentStockDetailManagerModel(),
//                                                   );
//                                                   totalOpeningStockFilled = selectedItem.filledOpeningStk?.toInt() ?? 0;
//                                                   totalOpeningStockEmpty = selectedItem.emptyOpeningStk?.toInt() ?? 0;
//                                                   totalOpeningStockDefective = selectedItem.deffOpeningStk?.toInt() ?? 0;
//                                                   totalCurrentStockFilled = selectedItem.filledCurrentStk?.toInt() ?? 0;
//                                                   totalCurrentStockEmpty = selectedItem.emptyCurrentStk?.toInt() ?? 0;
//                                                   totalCurrentStockDefective = selectedItem.deffCurrentStk?.toInt() ?? 0;
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   // Opening stock KPI mini-cards
//                                   Row(
//                                     children: [
//                                       Expanded(child: _stockMiniCard(totalOpeningStockFilled.toString(), 'Filled', const Color(0xFF1E3A8A))),
//                                       const SizedBox(width: 8),
//                                       Expanded(child: _stockMiniCard(totalOpeningStockEmpty.toString(), 'Empty', const Color(0xFF0F766E))),
//                                       const SizedBox(width: 8),
//                                       Expanded(child: _stockMiniCard(totalOpeningStockDefective.toString(), 'Defective', const Color(0xFFEF4444))),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   // Current Stock section
//                                   _stockSectionLabel('Current Stock Status', const Color(0xFF2D52C5)),
//                                   const SizedBox(height: 10),
//                                   Row(
//                                     children: [
//                                       Expanded(child: _stockMiniCard(totalCurrentStockFilled.toString(), 'Filled', const Color(0xFF1E3A8A))),
//                                       const SizedBox(width: 8),
//                                       Expanded(child: _stockMiniCard(totalCurrentStockEmpty.toString(), 'Empty', const Color(0xFF0F766E))),
//                                       const SizedBox(width: 8),
//                                       Expanded(child: _stockMiniCard(totalCurrentStockDefective.toString(), 'Defective', const Color(0xFFEF4444))),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   // Inward Stock section
//                                   _stockSectionLabel('Inward Stock', const Color(0xFF0F766E)),
//                                   const SizedBox(height: 10),
//                                   getCurrentStockDetailManager.any((item) =>
//                                   item.totalInvoiceCnt! > 0 ||
//                                       item.filledEMRCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Filled',
//                                     accentColor: const Color(0xFF1E3A8A),
//                                     headers: const ['', 'Invoice', 'EMR'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.totalInvoiceCnt! > 0 || item.filledEMRCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.totalInvoiceCnt.toString(),
//                                       items.filledEMRCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//                                   getCurrentStockDetailManager
//                                       .any((item) => item.emptyTVCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Empty',
//                                     accentColor: const Color(0xFF0F766E),
//                                     headers: const ['', 'TV'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.emptyTVCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.emptyTVCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//
//                                   getCurrentStockDetailManager
//                                       .any((item) => item.defectivCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Defective',
//                                     accentColor: const Color(0xFFEF4444),
//                                     headers: const ['', 'Defective'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.defectivCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.defectivCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//                                   // Outward Stock section
//                                   const SizedBox(height: 16),
//                                   _stockSectionLabel('Outward Stock', const Color(0xFFD97706)),
//                                   const SizedBox(height: 10),
//
//                                   getCurrentStockDetailManager.any((item) =>
//                                   item.emptyCRDCnt! > 0 ||
//                                       item.emptyDefectivCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Empty',
//                                     accentColor: const Color(0xFF0F766E),
//                                     headers: const ['', 'CRD', 'Defective'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.emptyCRDCnt! > 0 || item.emptyDefectivCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.emptyCRDCnt.toString(),
//                                       items.emptyDefectivCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//                                   // Title with larger font and a subtle shadow
//
//                                   getCurrentStockDetailManager.any((item) =>
//                                   item.sVQty! > 0 || item.refillSaleCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Refill Sale',
//                                     accentColor: const Color(0xFF2D52C5),
//                                     headers: const ['', 'SV', 'Refill Sale'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.sVQty! > 0 || item.refillSaleCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.sVQty.toString(),
//                                       items.refillSaleCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//
//                                   getCurrentStockDetailManager
//                                       .any((item) => item.imbalanceCnt! > 0)
//                                       ? _stockSubTable(
//                                     subTitle: 'Imbalance',
//                                     accentColor: const Color(0xFFD97706),
//                                     headers: const ['', 'Imbalance'],
//                                     rows: getCurrentStockDetailManager
//                                         .where((item) => item.imbalanceCnt! > 0)
//                                         .map((items) => [
//                                       items.itemName.toString(),
//                                       items.imbalanceCnt.toString(),
//                                     ]).toList(),
//                                   )
//                                       : const SizedBox.shrink(),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation1, animation2, child) {
//         final offsetAnimation = Tween<Offset>(
//           begin: const Offset(-1, 0), // From left side
//           end: Offset.zero, // To original position
//         ).animate(CurvedAnimation(parent: animation1, curve: Curves.easeInOut));
//
//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//     );
//   }
//
//   /// Mini KPI card used in stock status for Filled / Empty / Defective counts
//   Widget _stockMiniCard(String value, String label, Color accentColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border(top: BorderSide(color: accentColor, width: 3)),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x0D1E3A8A),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               color: accentColor,
//               letterSpacing: -0.6,
//             ),
//             textAlign: TextAlign.center,
//             textScaler: TextScaler.noScaling,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF6B7280),
//             ),
//             textAlign: TextAlign.center,
//             textScaler: TextScaler.noScaling,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section label row with a colored dot
//   Widget _stockSectionLabel(String title, Color dotColor) {
//     return Row(
//       children: [
//         Container(
//           width: 6, height: 6,
//           margin: const EdgeInsets.only(right: 8),
//           decoration: BoxDecoration(
//             color: dotColor,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         Text(
//           title.toUpperCase(),
//           style: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF374151),
//             letterSpacing: 0.8,
//           ),
//           textScaler: TextScaler.noScaling,
//         ),
//       ],
//     );
//   }
//
//   /// Reusable sub-table for stock detail (inward/outward)
//   Widget _stockSubTable({
//     required String subTitle,
//     required Color accentColor,
//     required List<String> headers,
//     required List<List<String>> rows,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: accentColor, width: 3)),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x0D1E3A8A),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Sub-title bar
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: accentColor.withValues(alpha: 0.08),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 5, height: 5,
//                   margin: const EdgeInsets.only(right: 6),
//                   decoration: BoxDecoration(
//                     color: accentColor,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 Text(
//                   subTitle,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: accentColor,
//                   ),
//                   textScaler: TextScaler.noScaling,
//                 ),
//               ],
//             ),
//           ),
//           // Header row
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
//               ),
//             ),
//             child: Row(
//               children: headers.map((h) => Expanded(
//                 child: Text(
//                   h,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     fontSize: 13,
//                   ),
//                   textAlign: TextAlign.center,
//                   textScaler: TextScaler.noScaling,
//                 ),
//               )).toList(),
//             ),
//           ),
//           // Data rows
//           rows.isEmpty
//               ? const Padding(
//             padding: EdgeInsets.all(12),
//             child: Text("No Data Available",
//                 style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
//           )
//               : Column(
//             children: rows.asMap().entries.map((entry) {
//               final index = entry.key;
//               final row = entry.value;
//               final bg = index.isEven ? const Color(0xFFEFF6FF) : Colors.white;
//               return Container(
//                 color: bg,
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 child: Row(
//                   children: row.map((cell) => Expanded(
//                     child: Text(
//                       cell,
//                       style: Styling.textFormText,
//                       textAlign: TextAlign.center,
//                       textScaler: TextScaler.noScaling,
//                     ),
//                   )).toList(),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
//
//   Future<void> fetchSVARBFilterCountList(String flag) async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDashboardProfitCount_Mob}/$distributorId/$flag'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//           },
//         );
//         print("Request URL GetDashboardSVARBProfit_Mob: ${response.request}");
//         print(
//             "API Response Status GetDashboardSVARBProfit_Mob: ${response.statusCode}");
//         print("API Response GetDashboardSVARBProfit_Mob: ${response.body}");
//         if (response.statusCode == 200) {
//           // final List<dynamic> data = json.decode(response.body);
//           setState(() {
//
//             try{
//               final Map<String, dynamic> data = json.decode(response.body);
//               svarbManagerDashboardCountModel = [
//                 GetSvarbManagerDashboardCountModel.fromJson(data)
//               ];
//
//               arbGrossRevenueCount = svarbManagerDashboardCountModel[0].aRBGrossRevenue?.toDouble();
//               arbGrossProfitCount = svarbManagerDashboardCountModel[0].aRBGrossProfit?.toDouble();
//               svGrossRevenueCount = svarbManagerDashboardCountModel[0].sVGrossRevenue?.toDouble();
//               refillGrossRevenueCount = svarbManagerDashboardCountModel[0].refillGrossRevenue?.toDouble();
//               refillGrossProfitCount = svarbManagerDashboardCountModel[0].refillGrossProfit?.toDouble();
//
//               totalGrossProfit = svGrossRevenueCount! + arbGrossProfitCount! + refillGrossProfitCount!;
//               debugPrint("totalGrossProfit $totalGrossProfit");
//               getHeadWiseExpenseLstModel(flag);
//               isLoading = false;
//               EasyLoading.dismiss();
//             }catch(e){
//               debugPrint("exc $e");
//             }
//
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//           // refreshTokens();
//           // showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         if (mounted) {
//           // Check if the widget is still mounted
//           debugPrint("exxxe $e");
//           setState(() {
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//         // refreshTokens();
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//         // showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> getHeadWiseExpenseLstModel(String flag) async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//       "FlagFor": flag,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetHeadWiseExpense}/$distributorId/$flag'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetHeadWiseExpense : " +
//         '${AppUrl.GetHeadWiseExpense}/$distributorId/$flag');
//     debugPrint("GetHeadWiseExpense : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         expenseReportModel = data.map((json) {
//           return HeadWiseExpenseLstModel.fromJson(json);
//         }).toList();
//
//         totalExpenseForProfit = expenseReportModel.fold(0.0, (sum, item) {
//           return sum! + (item.totExpAmt ?? 0.0);
//         });
//         incomeProfit = totalGrossProfit! - totalExpenseForProfit!;
//         debugPrint("totalGrossProfit $totalGrossProfit");
//         debugPrint("totalExpenseForProfit $totalExpenseForProfit");
//         debugPrint("incomeProfit $incomeProfit");
//         debugPrint("Total Expense: $totalExpenseForProfit");
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getUserDetail() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       roleId = preferences.getString('roleId');
//       userActivet = preferences.getString('userActive');
//       staffName = preferences.getString('StaffName') ?? '';
//       distributorName = preferences.getString('DistributorName') ?? '';
//       debugPrint("roleId $roleId");
//       debugPrint(userActivet);
//
//     } catch (error) {
//       rethrow;
//     }
//   }
//
//
//   Future<void> requestNotificationPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future<void> getFcmToken() async {
//     String? token = await messaging.getToken();
//     print("Firebase not initialize Token: $token");
//
//     // Send token to backend API
//   }
//
//
//
//   // void listenForegroundMessages() {
//   //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     // Check if the message contains a notification
//   //     if (message.notification != null) {
//   //       NotificationService.showNotification(
//   //         message.notification!.title ?? 'Notification',
//   //         message.notification!.body ?? '',
//   //       );
//   //     }
//   //
//   //     // Optional: handle data messages as well
//   //     if (message.data.isNotEmpty) {
//   //       debugPrint('Foreground data message: ${message.data}');
//   //     }
//   //   });
//   // }
//   void listenForegroundMessages() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       String title = message.notification?.title ?? 'Notification';
//       String body = message.notification?.body ?? '';
//
//       // Always use title
//       NotificationService.showNotification(title, body, title);
//
//       if (message.data.isNotEmpty) {
//         debugPrint('Foreground data message: ${message.data}');
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       String title = message.notification?.title ?? 'Unknown';
//       debugPrint('Notification clicked: $title');
//       // NotificationService.onSelectNotification(
//       //   // NotificationResponse(payload: title),
//       //     NotificationResponse({
//       //       required this.notificationResponseType,
//       //       this.payload,
//       //
//       //     })
//       //
//       // );
//       NotificationService.onSelectNotification(
//         NotificationResponse(
//           notificationResponseType: NotificationResponseType.selectedNotification,
//           payload: title,
//         ),
//       );
//
//     });
//   }
//
//
//   Future<void> setupNotifications() async {
//     final messaging = FirebaseMessaging.instance;
//
//     // 1️⃣ Request permission (iOS + Android safe)
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // 2️⃣ iOS: wait until APNS token is ready
//     if (Platform.isIOS) {
//       String? apnsToken;
//       int retry = 0;
//
//       while (apnsToken == null && retry < 5) {
//         apnsToken = await messaging.getAPNSToken();
//         retry++;
//         await Future.delayed(const Duration(seconds: 1));
//       }
//
//       if (apnsToken == null) {
//         debugPrint("❌ APNS token not available");
//         return;
//       }
//
//       debugPrint("✅ APNS token ready");
//     }
//
//     // 3️⃣ Now it's safe to get FCM token
//     final fcmToken = await messaging.getToken();
//     debugPrint("✅ FCM Token: $fcmToken");
//
//     if (fcmToken != null) {
//       await NotificationApiHelper.sendTokenToBackend();
//     }
//
//     // 4️⃣ Optional: listen for token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((token) {
//       NotificationApiHelper.sendTokenToBackend();
//     });
//   }
//
//   Widget showCardWithPunching(
//       BuildContext context,
//       void Function(void Function()) setModalState,
//       ) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Drag handle
//               Center(
//                 child: Container(
//                   width: 40, height: 4,
//                   margin: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFCBD5E1),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 6, height: 6,
//                         margin: const EdgeInsets.only(right: 8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0F766E),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       const Text(
//                         'CASHMEMO PUNCHING',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF374151),
//                           letterSpacing: 0.8,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Transform.scale(
//                     scale: 0.85,
//                     child: Row(
//                       children: [
//                         Switch(
//                           value: isOn,
//                           activeColor: const Color(0xFF1E3A8A),
//                           onChanged: (value) {
//                             setModalState(() {
//                               isOn = value;
//                             });
//                           },
//                         ),
//                         const SizedBox(width: 2),
//                         const Text(
//                           '%',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF374151),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               _punchTableHeader(),
//               const SizedBox(height: 8),
//               Column(
//                 children: getDashPunchSummaryCntModel.map((item) {
//                   return Column(
//                     children: [
//                       _buildPunchRow1(
//                         title: 'Manual',
//                         today: !isOn ? punchManToday ?? 0 : punchManTodayPct ?? 0,
//                         month: !isOn ? punchManAsOf ?? 0 : punchManAsOfPct ?? 0,
//                         isPercentage: isOn,
//                       ),
//                       Divider(color: const Color(0xFFE2E8F0)),
//                       _buildPunchRow1(
//                         title: 'OTP / DAC',
//                         today: !isOn ? punchDACToday ?? 0 : punchDACTodayPct ?? 0,
//                         month: !isOn ? punchDACAsOf ?? 0 : punchDACAsOfPct ?? 0,
//                         isPercentage: isOn,
//                       ),
//                       Divider(color: const Color(0xFFE2E8F0)),
//                     ],
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget showCardWithBooking(
//       BuildContext context,
//       void Function(void Function()) setModalState,
//       ) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Drag handle
//               Center(
//                 child: Container(
//                   width: 40, height: 4,
//                   margin: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFCBD5E1),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 6, height: 6,
//                         margin: const EdgeInsets.only(right: 8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1E3A8A),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       const Text(
//                         'REFILL BOOKING',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF374151),
//                           letterSpacing: 0.8,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Transform.scale(
//                     scale: 0.85,
//                     child: Row(
//                       children: [
//                         Switch(
//                           value: isOnBook,
//                           activeColor: const Color(0xFF1E3A8A),
//                           onChanged: (value) {
//                             setModalState(() {
//                               isOnBook = value;
//                             });
//                           },
//                         ),
//                         const SizedBox(width: 2),
//                         const Text(
//                           '%',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF374151),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               _punchTableHeader(),
//               const SizedBox(height: 8),
//               Column(
//                 children: getDashPunchSummaryCntModel.map((item) {
//                   return Column(
//                     children: [
//                       _buildPunchRow1(
//                         title: 'Manual',
//                         today: !isOnBook ? bkgManToday ?? 0 : bkgManTodayPct ?? 0,
//                         month: !isOnBook ? bkgManAsOf ?? 0 : bkgManAsOfPct ?? 0,
//                         isPercentage: isOnBook,
//                       ),
//                       Divider(color: const Color(0xFFE2E8F0)),
//                       _buildPunchRow1(
//                         title: 'Online',
//                         today: !isOnBook ? bkgOnlineToday ?? 0 : bkgOnlineTodayPct ?? 0,
//                         month: !isOnBook ? bkgOnlineAsOf ?? 0 : bkgOnlineAsOfPct ?? 0,
//                         isPercentage: isOnBook,
//                       ),
//                       Divider(color: const Color(0xFFE2E8F0)),
//                     ],
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _punchTableHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(8)),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: const Text('', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
//           ),
//           Expanded(
//             flex: 3,
//             child: const Text('Today',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
//           ),
//           Expanded(
//             flex: 3,
//             child: const Text('This Month',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPunchRow1({
//     required String title,
//     required dynamic today,
//     required dynamic month,
//     required bool isPercentage,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           /// Title
//           Expanded(
//             flex: 4,
//             child: Text(
//               title,
//               style: Styling.bodyTitleWithBlueHightDashboard,
//               textScaler: TextScaler.noScaling,
//             ),
//           ),
//
//           /// Today
//           Expanded(
//             flex: 3,
//             child: Text(
//               _formatValue(today, isPercentage),
//               textAlign: TextAlign.center,
//               style: Styling.blueClrText,
//               textScaler: TextScaler.noScaling,
//             ),
//           ),
//
//           /// This Month
//           Expanded(
//             flex: 3,
//             child: Text(
//               _formatValue(month, isPercentage),
//               textAlign: TextAlign.center,
//               style: Styling.blueClrText,
//               textScaler: TextScaler.noScaling,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _noDataWidget() {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.blueGrey[50],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.warning, color: Colors.orange),
//             SizedBox(width: 8),
//             Text(
//               'No Data Available',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.blueGrey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatValue(dynamic value, bool isPercentage) {
//     if (value == null) return '0';
//
//     if (isPercentage && value is num) {
//       if (value % 1 == 0) {
//         return value.toInt().toString(); // remove .0
//       }
//       return value.toString(); // keep decimal as-is
//     }
//
//     return value.toString();
//   }
//
//   Future<void> getDashPunchSummaryCntModeldata() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetDashPunchSummaryCnt}/$distributorId'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetDashPunchSummaryCnt : " +
//         '${AppUrl.GetDashPunchSummaryCnt}/$distributorId');
//     debugPrint("GetDashPunchSummaryCnt : " + '${response.body}');
//     // if (response.statusCode == 200) {
//     //   final List<dynamic> data = json.decode(response.body);
//     //   setState(() {
//     //
//     //       getDashPunchSummaryCntModel = data.map((json) {
//     //         return GetDashPunchSummaryCntModel.fromJson(json);
//     //       }).toList();
//     //
//     //       // --- Punch summary ---
//     //       punchManToday = data['punchManToday'] ?? 0;
//     //       punchManAsOf = data['punchManAsOf'] ?? 0;
//     //       punchManTodayPct = data['punchManTodayPct'] ?? 0;
//     //       punchManAsOfPct = data['punchManAsOfPct'] ?? 0;
//     //
//     //       punchDACToday = data['punchDACToday'] ?? 0;
//     //       punchDACAsOf = data['punchDACAsOf'] ?? 0;
//     //       punchDACTodayPct = data['punchDACTodayPct'] ?? 0;
//     //       punchDACAsOfPct = data['punchDACAsOfPct'] ?? 0;
//     //
//     //       // --- Booking summary ---
//     //       bkgManToday = data['bkgManToday'] ?? 0;
//     //       bkgManAsOf = data['bkgManAsOf'] ?? 0;
//     //       bkgManTodayPct = data['bkgManTodayPct'] ?? 0;
//     //       bkgManAsOfPct = data['bkgManAsOfPct'] ?? 0;
//     //
//     //       bkgOnlineToday = data['bkgOnlineToday'] ?? 0;
//     //       bkgOnlineAsOf = data['bkgOnlineAsOf'] ?? 0;
//     //       bkgOnlineTodayPct = data['bkgOnlineTodayPct'] ?? 0;
//     //       bkgOnlineAsOfPct = data['bkgOnlineAsOfPct'] ?? 0;
//     //
//     //       isLoading = false;
//     //       EasyLoading.dismiss();
//     //     });
//     //
//     // }
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         getDashPunchSummaryCntModel = data.map((json) {
//           return GetDashPunchSummaryCntModel.fromJson(json);
//         }).toList();
//
//         if (getDashPunchSummaryCntModel.isNotEmpty) {
//           print(
//               'Total Amount of the first item: ${getDashPunchSummaryCntModel[0]
//                   .bkgOnlineAsOf}');
//           punchManToday =
//               getDashPunchSummaryCntModel[0].punchManToday!.toInt();
//           punchManAsOf =
//               getDashPunchSummaryCntModel[0].punchManAsOf?.toInt();
//           punchManTodayPct =
//               getDashPunchSummaryCntModel[0].punchManTodayPct?.toDouble();
//           punchManAsOfPct =
//               getDashPunchSummaryCntModel[0].punchManAsOfPct?.toDouble();
//           punchDACToday =
//               getDashPunchSummaryCntModel[0].punchDACToday?.toInt();
//           punchDACAsOf =
//               getDashPunchSummaryCntModel[0].punchDACAsOf?.toInt();
//           punchDACTodayPct =
//               getDashPunchSummaryCntModel[0].punchDACTodayPct?.toDouble() ?? 0;
//           punchDACAsOfPct =
//               getDashPunchSummaryCntModel[0].punchDACAsOfPct?.toDouble() ?? 0;
//
//           bkgManToday =
//               getDashPunchSummaryCntModel[0].bkgManToday?.toInt();
//           bkgManAsOf =
//               getDashPunchSummaryCntModel[0].bkgManAsOf?.toInt();
//           bkgManTodayPct =
//               getDashPunchSummaryCntModel[0].bkgManTodayPct?.toDouble();
//           bkgManAsOfPct =
//               getDashPunchSummaryCntModel[0].bkgManAsOfPct?.toDouble();
//           bkgOnlineToday =
//               getDashPunchSummaryCntModel[0].bkgOnlineToday?.toInt();
//           bkgOnlineAsOf =
//               getDashPunchSummaryCntModel[0].bkgOnlineAsOf?.toInt();
//           bkgOnlineTodayPct =
//               getDashPunchSummaryCntModel[0].bkgOnlineTodayPct?.toDouble() ?? 0;
//           bkgOnlineAsOfPct =
//               getDashPunchSummaryCntModel[0].bkgOnlineAsOfPct?.toDouble() ?? 0;
//
//         }
//
//         isLoading = false;
//         EasyLoading.dismiss();
//       });
//     }
//     else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     final routeArgs = ModalRoute.of(context)?.settings.arguments;
//
//     if (routeArgs is Map<String, dynamic>) {
//
//       if (routeArgs["openCashmemoSheet"] == true && !_cashmemoSheetOpened) {
//         _cashmemoSheetOpened = true;
//         _waitForPunchDataAndOpen();
//       }
//
//       if (routeArgs["refillBooking"] == true && !_refillBookingSheetOpened) {
//         _refillBookingSheetOpened = true;
//         _waitForBooingDataAndOpen();
//       }
//
//       if (routeArgs["openPrepaidSheet"] == true && !_prepaidSheetOpened) {
//         _prepaidSheetOpened = true;
//         _waitForPrepaidDataAndOpen();
//       }
//       // if (routeArgs["Total Outstanding Pending"] == true && !_SettlementSheetOpened) {
//       //   _SettlementSheetOpened = true;
//       //   _waitForSettlementDataAndOpen();
//       // }
//
//     }
//   }
//
//   void _waitForPunchDataAndOpen() async {
//     int attempts = 0;
//
//     while (getDashPunchSummaryCntModel.isEmpty && attempts < 20) {
//       await Future.delayed(const Duration(milliseconds: 300));
//       attempts++;
//     }
//
//     if (mounted) {
//       _openCashmemoSheet();
//     }
//   }
//
//   void _waitForBooingDataAndOpen() async {
//     int attempts = 0;
//
//     while (getDashPunchSummaryCntModel.isEmpty && attempts < 20) {
//       await Future.delayed(const Duration(milliseconds: 300));
//       attempts++;
//     }
//
//     if (mounted) {
//       _openRefillBookinfSheet();
//     }
//   }
//
//   void _openCashmemoSheet() {
//     showModalBottomSheet(
//       context: context,
//       useRootNavigator: true,
//       isScrollControlled: true,
//       isDismissible: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: Color(0xFF1E3A8A),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return GestureDetector(
//               onTap: () {},
//               child: showCardWithPunching(context, setModalState),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _openRefillBookinfSheet() {
//     showModalBottomSheet(
//       context: context,
//       useRootNavigator: true,
//       isScrollControlled: true,
//       isDismissible: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: Color(0xFF1E3A8A),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return GestureDetector(
//               onTap: () {},
//               child: showCardWithBooking(context, setModalState),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _waitForPrepaidDataAndOpen() async {
//     int attempts = 0;
//
//     while ((todaysPunchingInNiyojanC == null) && attempts < 20) {
//       await Future.delayed(const Duration(milliseconds: 300));
//       attempts++;
//     }
//
//     if (mounted) {
//       showBottomSheet(context);
//     }
//   }
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // RELEASE NOTES
//   // ══════════════════════════════════════════════════════════════════════════
//
//   @override
//   void dispose() {
//     _releaseBlinkTimer?.cancel();
//     super.dispose();
//   }
//
//   // ── Animated rocket icon shown in the hero strip ───────────────────────────
//   Widget _buildReleaseNoteIcon() {
//     final count = _relNoteList.length;
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Material(
//           color: Colors.white.withOpacity(0.14),
//           borderRadius: BorderRadius.circular(12),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: () => _showReleaseNotesDialog(_relNoteList),
//             child: Container(
//               width: 44, height: 44,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
//               ),
//               alignment: Alignment.center,
//               child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 22),
//             ),
//           ),
//         ),
//         if (count > 0)
//           Positioned(
//             right: -4, top: -4,
//             child: AnimatedOpacity(
//               opacity: _releaseBlink ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 200),
//               child: Container(
//                 constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//                 decoration: BoxDecoration(
//                   color: AppColors.red,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.white, width: 1.5),
//                 ),
//                 child: Text(
//                   count > 9 ? '9+' : '$count',
//                   style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
//                   textAlign: TextAlign.center,
//                   textScaler: TextScaler.noScaling,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   // ── Boot: load list + check for today popup ────────────────────────────────
//   Future<void> _initReleaseNotes() async {
//     await _loadReleaseNoteList(_releaseFilter);
//     final todayDetails = await _fetchReleaseNoteDetails("Today");
//     if (!mounted) return;
//     setState(() => _relNoteDetails = todayDetails);
//     if (_relNoteDetails.isNotEmpty) _maybeShowReleasePopup();
//   }
//
//   // ── Fetch unseen list (drives badge count) ─────────────────────────────────
//   Future<void> _loadReleaseNoteList(String flag) async {
//     try {
//       final prefs  = await SharedPreferences.getInstance();
//       final distId = prefs.getString('DistributorId');
//       final token  = prefs.getString('token');
//       final rId    = prefs.getString('roleId');
//       if (token == null || distId == null) return;
//
//       final url = '${AppUrl.GetReleaseNoteList}/$distId/$rId/$flag/MOB';
//       final res = await http.get(Uri.parse(url),
//           headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
//
//       if (res.statusCode == 200) {
//         final decoded = json.decode(res.body);
//         final raw = (decoded is List) ? decoded : ((decoded['data'] as List?) ?? []);
//         final list = List<Map<String, dynamic>>.from(raw);
//         list.sort((a, b) {
//           final da = DateTime.tryParse(a['Date'] ?? a['date'] ?? '') ?? DateTime(2000);
//           final db = DateTime.tryParse(b['Date'] ?? b['date'] ?? '') ?? DateTime(2000);
//           return db.compareTo(da);
//         });
//         if (mounted) setState(() => _relNoteList = list);
//       }
//     } catch (e) {
//       debugPrint("_loadReleaseNoteList error: $e");
//     }
//   }
//
//   // ── Fetch details for a given period ─────────────────────────────────────
//   Future<List<Map<String, dynamic>>> _fetchReleaseNoteDetails(String flag) async {
//     try {
//       final prefs  = await SharedPreferences.getInstance();
//       final distId = prefs.getString('DistributorId');
//       final token  = prefs.getString('token');
//       final rId    = prefs.getString('roleId');
//       if (token == null || distId == null) return [];
//
//       final url = '${AppUrl.GetReleaseNotesDtls}/$distId/$rId/$flag/MOB';
//       final res = await http.get(Uri.parse(url),
//           headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
//
//       if (res.statusCode == 200) {
//         final decoded = json.decode(res.body);
//         final raw = (decoded is List) ? decoded : ((decoded['data'] as List?) ?? []);
//         final list = List<Map<String, dynamic>>.from(raw);
//         list.sort((a, b) {
//           final da = DateTime.tryParse(a['Date'] ?? a['date'] ?? '') ?? DateTime(2000);
//           final db = DateTime.tryParse(b['Date'] ?? b['date'] ?? '') ?? DateTime(2000);
//           return db.compareTo(da);
//         });
//         return list;
//       }
//     } catch (e) {
//       debugPrint("_fetchReleaseNoteDetails error: $e");
//     }
//     return [];
//   }
//
//   // ── POST: mark a release as seen ─────────────────────────────────────────
//   Future<void> _markReleaseSeen(String relId) async {
//     try {
//       final prefs  = await SharedPreferences.getInstance();
//       final distId = prefs.getString('DistributorId');
//       final token  = prefs.getString('token');
//       final rId    = prefs.getString('roleId');
//       final url    = '${AppUrl.SaveReleaseSeen}/$distId/$rId/$relId';
//       await http.post(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
//       debugPrint("Release $relId marked as seen");
//     } catch (e) {
//       debugPrint("_markReleaseSeen error: $e");
//     }
//   }
//
//   // ── Show popup once per session / per release ─────────────────────────────
//   Future<void> _maybeShowReleasePopup() async {
//     if (_relNoteDetails.isEmpty || _releasePopupShown) return;
//     final prefs    = await SharedPreferences.getInstance();
//     const key      = 'lastSeenReleaseId';
//     final lastSeen = prefs.getString(key);
//     final note     = _relNoteDetails.first;
//     final currentId = (note['ReleaseId'] ?? note['releaseId'] ?? '').toString().trim();
//     if (lastSeen == currentId) return;
//     _releasePopupShown = true;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       _showReleasePopup(
//         notes: _relNoteDetails,
//         onGotIt: (id) async {
//           final p = await SharedPreferences.getInstance();
//           await p.setString(key, id);
//           await _markReleaseSeen(id);
//           _releasePopupShown = false;
//           _loadReleaseNoteList(_releaseFilter); // refresh badge
//         },
//       );
//     });
//   }
//
//   // ── Dialog: full list (opened by tapping rocket) ─────────────────────────
//   void _showReleaseNotesDialog(List<Map<String, dynamic>> notes) {
//     if (notes.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("No release notes available"),
//           backgroundColor: AppColors.blue,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (_) => _ReleaseListDialog(
//         notes: notes,
//         fetchDetails: _fetchReleaseNoteDetails,
//         currentFilter: _releaseFilter,
//       ),
//     );
//   }
//
//   // ── Dialog: "What's New" auto-popup ───────────────────────────────────────
//   void _showReleasePopup({
//     required List<Map<String, dynamic>> notes,
//     required Future<void> Function(String id) onGotIt,
//   }) {
//     String localFilter = "Today";
//     List<Map<String, dynamic>> currentNotes = notes;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
//         final note        = currentNotes.isNotEmpty ? currentNotes.first : null;
//         final releaseNo   = note?['ReleaseNo']   ?? note?['releaseNo']   ?? '';
//         final issueType   = note?['IssueType']   ?? note?['issueType']   ?? '';
//         final description = note?['Description'] ?? note?['description'] ?? '';
//         final releaseId   = (note?['ReleaseId']  ?? note?['releaseId']   ?? '').toString();
//
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           backgroundColor: Colors.white,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.fromLTRB(20, 16, 14, 14),
//                 decoration: const BoxDecoration(
//                   gradient: AppColors.gradHero,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
//                     const SizedBox(width: 8),
//                     const Expanded(
//                       child: Text("What's New",
//                           style: TextStyle(color: Colors.white, fontSize: 16,
//                               fontWeight: FontWeight.w800, letterSpacing: -0.3)),
//                     ),
//                     // Period filter
//                     Theme(
//                       data: Theme.of(ctx).copyWith(canvasColor: Colors.white),
//                       child: DropdownButton<String>(
//                         value: localFilter,
//                         dropdownColor: Colors.white,
//                         underline: const SizedBox.shrink(),
//                         iconEnabledColor: Colors.white70,
//                         style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 12, fontWeight: FontWeight.w600),
//                         items: const [
//                           DropdownMenuItem(value: "Today",     child: Text("Today")),
//                           DropdownMenuItem(value: "ThisWeek",  child: Text("This Week")),
//                           DropdownMenuItem(value: "ThisMonth", child: Text("This Month")),
//                         ],
//                         onChanged: (val) async {
//                           if (val == null) return;
//                           final fresh = await _fetchReleaseNoteDetails(val);
//                           setD(() { localFilter = val; currentNotes = fresh; });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Body
//               if (note == null)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 36),
//                   child: Column(children: [
//                     Icon(Icons.check_circle_outline_rounded, color: Color(0xFF22C55E), size: 44),
//                     SizedBox(height: 12),
//                     Text("You're all caught up!", style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
//                   ]),
//                 )
//               else
//                 Flexible(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                       Row(children: [
//                         Text(releaseNo,
//                             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
//                         const SizedBox(width: 8),
//                         _releaseTypeBadge(issueType),
//                       ]),
//                       const SizedBox(height: 12),
//                       ..._splitBullets(description).map((line) => Padding(
//                         padding: const EdgeInsets.only(bottom: 6),
//                         child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                           Container(
//                             margin: const EdgeInsets.only(top: 6, right: 8),
//                             width: 6, height: 6,
//                             decoration: const BoxDecoration(color: Color(0xFF1E3A8A), shape: BoxShape.circle),
//                           ),
//                           Expanded(child: Text(line,
//                               style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.5))),
//                         ]),
//                       )),
//                       const SizedBox(height: 8),
//                     ]),
//                   ),
//                 ),
//
//               // Footer
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                 child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                   TextButton(
//                     style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B7280)),
//                     onPressed: () {
//                       _releasePopupShown = false;
//                       Navigator.pop(ctx);
//                     },
//                     child: const Text("Remind Me Later"),
//                   ),
//                   if (note != null) ...[
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.blue,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
//                       ),
//                       onPressed: () async {
//                         await onGotIt(releaseId);
//                         if (ctx.mounted) Navigator.pop(ctx);
//                       },
//                       child: const Text("Got It",
//                           style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
//                     ),
//                   ],
//                 ]),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   // ── Colour-coded issue-type badge ─────────────────────────────────────────
//   Widget _releaseTypeBadge(String type) {
//     final Color bg = type == 'New'
//         ? AppColors.blue
//         : type == 'Bug'
//         ? AppColors.red
//         : AppColors.orange;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
//       child: Text(type,
//           style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
//     );
//   }
//
//   // ── Split dot-separated description into bullets ──────────────────────────
//   List<String> _splitBullets(String desc) =>
//       desc.split('.').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//
// }
//
// // ── Release Notes: full list dialog ──────────────────────────────────────────
// // Stateful so it manages its own expand/collapse and filter state independently.
// class _ReleaseListDialog extends StatefulWidget {
//   const _ReleaseListDialog({
//     required this.notes,
//     required this.fetchDetails,
//     required this.currentFilter,
//   });
//
//   final List<Map<String, dynamic>> notes;
//   final Future<List<Map<String, dynamic>>> Function(String flag) fetchDetails;
//   final String currentFilter;
//
//   @override
//   State<_ReleaseListDialog> createState() => _ReleaseListDialogState();
// }
//
// class _ReleaseListDialogState extends State<_ReleaseListDialog> {
//   late List<Map<String, dynamic>> _notes;
//   late List<bool> _expanded;
//   late String _filter;
//
//   @override
//   void initState() {
//     super.initState();
//     _notes    = widget.notes;
//     _filter   = widget.currentFilter;
//     _expanded = List.generate(_notes.length, (_) => false);
//   }
//
//   String _monthName(int m) => const [
//     '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//   ][m];
//
//   String _fmtDate(String? raw) {
//     if (raw == null || raw.isEmpty) return '';
//     try {
//       final d = DateTime.parse(raw);
//       return '${d.day.toString().padLeft(2, '0')} ${_monthName(d.month)} ${d.year}';
//     } catch (_) { return ''; }
//   }
//
//   List<String> _bullets(String desc) =>
//       desc.split('.').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
//
//   Widget _badge(String type) {
//     final Color bg = type == 'New'
//         ? AppColors.blue
//         : type == 'Bug'
//         ? AppColors.red
//         : AppColors.orange;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
//       child: Text(type,
//           style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Branded header ───────────────────────────────────────────────
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(20, 16, 14, 14),
//             decoration: const BoxDecoration(
//               gradient: AppColors.gradHero,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Row(children: [
//               const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text("Release Notes",
//                       style: TextStyle(color: Colors.white, fontSize: 16,
//                           fontWeight: FontWeight.w800, letterSpacing: -0.3)),
//                   Text("Niyojan Updates",
//                       style: TextStyle(color: Colors.white70, fontSize: 12,
//                           fontWeight: FontWeight.w500)),
//                 ]),
//               ),
//               // Period filter
//               Theme(
//                 data: Theme.of(context).copyWith(canvasColor: Colors.white),
//                 child: DropdownButton<String>(
//                   value: _filter,
//                   dropdownColor: Colors.white,
//                   underline: const SizedBox.shrink(),
//                   iconEnabledColor: Colors.white70,
//                   style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 12, fontWeight: FontWeight.w600),
//                   items: const [
//                     DropdownMenuItem(value: "Today",     child: Text("Today")),
//                     DropdownMenuItem(value: "ThisWeek",  child: Text("This Week")),
//                     DropdownMenuItem(value: "ThisMonth", child: Text("This Month")),
//                   ],
//                   onChanged: (val) async {
//                     if (val == null) return;
//                     final fresh = await widget.fetchDetails(val);
//                     setState(() {
//                       _filter   = val;
//                       _notes    = fresh;
//                       _expanded = List.generate(fresh.length, (_) => false);
//                     });
//                   },
//                 ),
//               ),
//             ]),
//           ),
//
//           // ── Note cards ──────────────────────────────────────────────────
//           Flexible(
//             child: _notes.isEmpty
//                 ? const Padding(
//               padding: EdgeInsets.symmetric(vertical: 40),
//               child: Column(children: [
//                 Icon(Icons.check_circle_outline_rounded, color: Color(0xFF22C55E), size: 44),
//                 SizedBox(height: 12),
//                 Text("No updates for this period",
//                     style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
//               ]),
//             )
//                 : SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
//               child: Column(
//                 children: _notes.asMap().entries.map((entry) {
//                   final i    = entry.key;
//                   final note = entry.value;
//                   final releaseNo   = note['ReleaseNo']   ?? note['releaseNo']   ?? '';
//                   final issueType   = note['IssueType']   ?? note['issueType']   ?? '';
//                   final title       = note['Title']       ?? note['title']       ?? '';
//                   final description = note['Description'] ?? note['description'] ?? '';
//                   final dateRaw     = note['Date']        ?? note['date'];
//                   final bullets     = _bullets(description);
//                   final isExpanded  = _expanded[i];
//
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8FAFC),
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(color: const Color(0xFFE2E8F0)),
//                       ),
//                       padding: const EdgeInsets.all(14),
//                       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                         // Date
//                         Text(_fmtDate(dateRaw),
//                             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
//                                 color: Color(0xFF9CA3AF), letterSpacing: 0.3)),
//                         const SizedBox(height: 6),
//                         // Release # + badge
//                         Row(children: [
//                           Text(releaseNo,
//                               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
//                                   color: Color(0xFF111827))),
//                           const SizedBox(width: 8),
//                           _badge(issueType),
//                         ]),
//                         if (title.isNotEmpty) ...[
//                           const SizedBox(height: 6),
//                           Text(title,
//                               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
//                                   color: Color(0xFF374151))),
//                         ],
//                         const SizedBox(height: 8),
//                         // Bullets
//                         ...(isExpanded ? bullets : bullets.take(2)).map((line) => Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                             Container(
//                               margin: const EdgeInsets.only(top: 6, right: 8),
//                               width: 5, height: 5,
//                               decoration: const BoxDecoration(
//                                   color: Color(0xFF1E3A8A), shape: BoxShape.circle),
//                             ),
//                             Expanded(child: Text(line,
//                                 style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), height: 1.5))),
//                           ]),
//                         )),
//                         // Expand toggle
//                         if (bullets.length > 2) ...[
//                           const SizedBox(height: 4),
//                           GestureDetector(
//                             onTap: () => setState(() => _expanded[i] = !_expanded[i]),
//                             child: Text(
//                               isExpanded ? "View Less ▲" : "View More ▼",
//                               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                                   color: Color(0xFF1E3A8A)),
//                             ),
//                           ),
//                         ],
//                       ]),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//
//           // ── Footer ──────────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.blue,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Close",
//                     style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Helper data class for DataListCard rows ────────────────────────────────
// class _DataRow {
//   const _DataRow({
//     required this.label,
//     required this.subtitle,
//     required this.value,
//     required this.dotColor,
//     required this.badgeLabel,
//     required this.badgeBg,
//     required this.badgeFg,
//     this.onTap,
//   });
//   final String label;
//   final String subtitle;
//   final String value;
//   final Color dotColor;
//   final String badgeLabel;
//   final Color badgeBg;
//   final Color badgeFg;
//   final VoidCallback? onTap;
// }
//
// // ── Flow Vector Painter (matches newTheme DashboardHeroStrip) ───────────────
// class _DashFlowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final w = size.width;
//     final h = size.height;
//
//     final paint1 = Paint()
//       ..color = Colors.white.withOpacity(0.08)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5
//       ..strokeCap = StrokeCap.round;
//
//     final paint2 = Paint()
//       ..color = const Color(0xFF14B8A8).withOpacity(0.14) // tealLight
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0
//       ..strokeCap = StrokeCap.round;
//
//     final paint3 = Paint()
//       ..color = Colors.white.withOpacity(0.06)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..strokeCap = StrokeCap.round;
//
//     final p1 = Path()
//       ..moveTo(-10, h * 0.75)
//       ..cubicTo(w * 0.2, h * 0.25, w * 0.5, h * 0.6, w + 10, h * 0.38);
//     canvas.drawPath(p1, paint1);
//
//     final p2 = Path()
//       ..moveTo(-10, h * 0.56)
//       ..cubicTo(w * 0.24, h * 0.12, w * 0.5, h * 0.44, w + 10, h * 0.19);
//     canvas.drawPath(p2, paint2);
//
//     final p3 = Path()
//       ..moveTo(w * 0.05, h)
//       ..cubicTo(w * 0.3, h * 0.5, w * 0.6, h * 0.69, w + 10, h * 0.5);
//     canvas.drawPath(p3, paint3);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
