import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetails.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_typography.dart';
import 'package:lpgsalesandinventory/newTheam/features/dsr_report/bloc/dsr_report_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'BootomNavigatinBarManager.dart';
import 'ClickModelClass/ManagerGetDSRDMwiseSummaryListModel.dart';
import 'ClickModelClass/ManagerGetDsrSVTVListModel.dart';
import 'DSRItemClickUI/ManagerCashInHandScreenDetails.dart';
import 'DSRItemClickUI/ManagerDSRReportScreenDetails.dart';
import 'DSRItemClickUI/ManagerExpenseTabScreenDetails.dart';

import 'ManagerModelClass/ManagerDSRReportCDCMSListModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashHandOverModel.dart';
import 'ManagerModelClass/ManagerDSRReportExpenseDetailListModel.dart';

import 'ManagerModelClass/ManagerDsrReoprtCashFlowSummaryMode.dart';
import 'ManagerModelClass/ManagerDsrReportIncomeSalesModel.dart';
import 'ManagerModelClass/ManagerDsrReportSavedDataFetchModelList.dart';

class ManagerDSRReportScreen extends StatefulWidget {
  static const screenName = '/managerDSRReportScreen';

  const ManagerDSRReportScreen({super.key});

  @override
  State<ManagerDSRReportScreen> createState() => _ManagerDSRReportScreenState();
}

class _ManagerDSRReportScreenState extends State<ManagerDSRReportScreen> {
  int _selectedTabIndex = 0;
  DateTime selectedDate = DateTime.now();
  DateTime today = DateTime.now();
  List<ExpDtls> getCurrentStockDetailManager = [];
  bool isLoading = true;
  String staffName = '';
  String distributorName = '';
  String? roleId, isUserActive, userActivet;
  List<dynamic> dataIncomeDailySaleList = [];
  List<dynamic> dataDMSaleList = [];
  List<dynamic> dataSVSaleList = [];
  List<dynamic> dataTVSaleList = [];
  List<dynamic> dataSVTVSaleList = [];
  List<dynamic> dataIncomeArbSaleList = [];
  List<dynamic> dataIncomeSVSaleList = [];
  List<dynamic> dataIncomeReceiptSaleList = [];
  List<dynamic> dataExpenseList = [];
  List<dynamic> dataCashInHandList = [];
  List<dynamic> dataCashDenominationList = [];
  List<dynamic> dataIncomeTotalAmountList = [];
  List<dynamic> dataExpenseTotalAmountList = [];
  List<dynamic> dataCashFlowSummaryList = [];
  List<dynamic> dataCashFlowSummaryAmountList = [];
  List<ManagerDsrReportCdcmsListModel> cdcmsListData = [];

  double totalAmountCashDenomination = 0;

  // Create lists to store the differences for each item
  List<double> filledDiffList = [];
  List<double> emptyDiffList = [];
  List<double> defectiveDiffList = [];

  List<double> totalDiffList = [];
  String? startOnDate;

  ///regulator
  List<dynamic> dataIncomeRegulatorReplacementList = [];

  double totalCashAmountCashFlow = 0.0;
  double totalBankAmountCashFlow = 0.0;
  double totalCreditAmountCashFlow = 0.0;
  double totalUnsettledAmountCashFlow = 0.0;
  double totalSettledAmountCashFlow = 0.0;
  double totalExpenseAmountCashFlow = 0.0;
  double totalCahFlowSummaryAmountCashFlow = 0.0;
  double totalCashInHandAmountCashFlow = 0.0;
  double totalPrepaidOnlineCashFlow = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(2002),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        selectedDate = pickedDate;
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchData("y");
  // }
  // Declare controllers for each field in the list
  List<TextEditingController> filledCDControllers = [];
  List<TextEditingController> emptyCDControllers = [];
  List<TextEditingController> defectiveCDControllers = [];
  bool saveFlag = false;
  GlobalKey _globalKey = GlobalKey();
  bool isGenerating = false;
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _tabKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    getUserDetail();
    checkIfSavedOrNot(selectedDate);
    checkAndSaveDayEndData();
  }

  void getUserDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      staffName = preferences.getString('StaffName') ?? '';
      distributorName = preferences.getString('DistributorName') ?? '';
      roleId = preferences.getString('RoleId');
      isUserActive = preferences.getString('IsUserActive');
      userActivet = preferences.getString('userActivet');
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  // ── Hero Strip (owns full screen) ─────────────────────────────────────────
  Widget _buildHeroStrip() {
    return Column(
      children: [
        // ── Gradient Hero Header ──
        Container(
          decoration: const BoxDecoration(gradient: AppColors.gradHero),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50, right: -70,
                child: Container(
                  width: 220, height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -40, left: -30,
                child: Container(
                  width: 160, height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tealLight.withValues(alpha: 0.12),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Good ${_greeting()}, ${staffName.isNotEmpty ? staffName : 'Manager'} 👋',
                                //   style: AppTypography.heroSubtitle,
                                //   textScaler: TextScaler.noScaling,
                                // ),
                                // const SizedBox(height: 3),
                                const Text(
                                  'Daily Sale Report',
                                  style: AppTypography.heroTitle,
                                  textScaler: TextScaler.noScaling,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  distributorName.isNotEmpty ? distributorName : 'Niyojan LPG',
                                  style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
                                  textScaler: TextScaler.noScaling,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Avatar chip
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.28),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              () {
                                final parts = staffName.trim().split(RegExp(r'\s+'));
                                if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                                if (parts.isNotEmpty && parts[0].length >= 2) return parts[0].substring(0, 2).toUpperCase();
                                return 'M';
                              }(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Date selector + Show DSR action row
                      _buildHeroActionRow(),
                      const SizedBox(height: 14),
                      // Cash-flow KPI chips row
                      _buildHeroCashKpiRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // ── Tab panel card ──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                // borderRadius: BorderRadius.circular(18),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                boxShadow: const [
                  BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  children: [
                    // Tab bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: [
                          _buildTabText('Revenue', 0),
                          _buildTabText('DM Sale', 1),
                          _buildTabText('Expense', 2),
                          _buildTabText('SV&TV', 3),
                          _buildTabText('CDCMS Stock', 4),
                          _buildTabText('Cash', 5),
                        ].map((tab) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: tab,
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tab content
                    Expanded(
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: IndexedStack(
                          index: _selectedTabIndex,
                          children: [
                            _buildIncomeTab(),
                            _buildDMSaleTab(),
                            _buildExpenseTab(),
                            _buildSVTVTab(),
                            _buildCDCMSStockTab(),
                            _buildCashInHandTab(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Hero action row: date picker + Show DSR button ────────────────────────
  Widget _buildHeroActionRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM yyyy').format(selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            checkIfSavedOrNot(selectedDate);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tealLight,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: const Text(
            'Show DSR',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            textScaler: TextScaler.noScaling,
          ),
        ),
      ],
    );
  }

  // ── Hero cash-flow KPI chips (horizontal scrollable) ──────────────────────
  Widget _buildHeroCashKpiRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _heroCashChip('Cash', totalCashAmountCashFlow, 'Cash'),
          const SizedBox(width: 8),
          _heroCashChip('Merchant', totalBankAmountCashFlow, 'MERCHANT'),
          const SizedBox(width: 8),
          _heroCashChip('Credit', totalCreditAmountCashFlow, 'Credit'),
          const SizedBox(width: 8),
          _heroCashChip('Expenses', totalExpenseAmountCashFlow, 'Expenses'),
          const SizedBox(width: 8),
          _heroCashChip('Prepaid', totalPrepaidOnlineCashFlow, 'PREPAID'),
        ],
      ),
    );
  }

  Widget _heroCashChip(String label, double amount, String screenMode) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ManagerDSRReportScreenDetails.screenName,
        arguments: {'ScreenMode': screenMode, 'Date': selectedDate},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 4),
            Text(
              formatCurrency(amount),
              style: AppTypography.heroKpiValue.copyWith(fontSize: 15),
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.open_in_new_rounded, color: Colors.white54, size: 10),
                SizedBox(width: 3),
                Text(
                  'View details',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    for (var controller in filledCDControllers) {
      controller.dispose();
    }
    for (var controller in emptyCDControllers) {
      controller.dispose();
    }
    for (var controller in defectiveCDControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  late bool isDateValid;

  @override
  Widget build(BuildContext context) {
    isDateValid = selectedDate.isAfter(today.subtract(Duration(days: 1)));
    return BlocProvider(
      create: (context) => DsrReportCubit()..loadDsrReport(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.bg2,
          body: _buildHeroStrip(),
        ),
      ),
    );
  }

  // ── Legacy tab-panel content (was inside _buildOriginalDsrContent) ─────────
  // The cash-flow summary chips moved to _buildHeroCashKpiRow in the hero.
  // The date + Show DSR action moved to _buildHeroActionRow in the hero.
  // The tab bar + IndexedStack are now inlined in _buildHeroStrip.
  // Keeping the below as comment reference only.
  //
  // Previously contained:
  //   Cash / Merchant QR / Credit / Expenses / Prepaid Online rows  (→ now _buildHeroCashKpiRow)
  //   Date picker + Show DSR row                                     (→ now _buildHeroActionRow)
  //   Tab bar + IndexedStack                                         (→ now inline in _buildHeroStrip)

  // ── [All old _buildOriginalDsrContent UI removed — now in _buildHeroStrip] ──
                       // Container(
                       //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             // First Column (Refill and TV)
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 60,
                      //                       child: Text(
                      //                         'Cash:',
                      //                         style: Styling.itemGreyTextSmallReport, // No need to modify the "Cash:" text
                      //                       ),
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         Navigator.pushNamed(
                      //                             context,
                      //                             ManagerDSRReportScreenDetails
                      //                                 .screenName,
                      //                             arguments: {
                      //                               "ScreenMode": "Cash",
                      //                               "Date":selectedDate,
                      //                             });
                      //
                      //                       },
                      //                       child: Text(
                      //                         formatCurrency(totalCashAmountCashFlow), // The amount text
                      //                         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700).copyWith(
                      //                           color: AppColors.blue, // Set color to blue for link appearance
                      //                           decoration: TextDecoration.underline,
                      //                           decorationcolor: AppColors.blue,// Add underline decoration
                      //                         ),// The amount style
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 const SizedBox(height: 8),
                      //                 Row(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 70,
                      //                       child: Text(
                      //                         'Merchant:',
                      //                         style: Styling.itemGreyTextSmallReport, // "Bank:" text style without underline
                      //                       ),
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         // Navigate to BankDetailsScreen when the amount is tapped
                      //                         Navigator.pushNamed(
                      //                             context,
                      //                             ManagerDSRReportScreenDetails
                      //                                 .screenName,
                      //                             arguments: {
                      //                               "ScreenMode": "Bank",
                      //                               "Date":selectedDate,
                      //                             });
                      //                       },
                      //                       child: Text(
                      //                         formatCurrency(totalBankAmountCashFlow), // The amount text
                      //                         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700).copyWith(
                      //                           color: AppColors.blue, // Set color to blue for link appearance
                      //                           decoration: TextDecoration.underline,
                      //                           decorationcolor: AppColors.blue,// Add underline decoration to the amount
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //
                      //               ],
                      //             ),
                      //             // Second Column (SV and Amount)
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 80,
                      //                       child: Text(
                      //                         'Credit:',
                      //                         style: Styling.itemGreyTextSmallReport, // The "Credit:" text style
                      //                       ),
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         Navigator.pushNamed(
                      //                             context,
                      //                             ManagerDSRReportScreenDetails
                      //                                 .screenName,
                      //                             arguments: {
                      //                               "ScreenMode": "Credit",
                      //                               "Date":selectedDate,
                      //                             });
                      //                       },
                      //                       child: Text(
                      //                         formatCurrency(totalCreditAmountCashFlow), // The amount text
                      //                         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700).copyWith(
                      //                           color: AppColors.blue, // Set color to blue for link appearance
                      //                           decoration: TextDecoration.underline,
                      //                           decorationcolor: AppColors.blue,// Add underline decoration to the amount
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //
                      //                 const SizedBox(
                      //                   height: 8,
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 80,
                      //                       child: Text(
                      //                         'Expenses:',
                      //                         style: Styling.itemGreyTextSmallReport, // The "Expenses:" text style
                      //                       ),
                      //                     ),
                      //                     GestureDetector(
                      //                       onTap: () {
                      //                         // Navigate to ExpensesDetailsScreen when the amount is tapped
                      //                         Navigator.pushNamed(
                      //                             context,
                      //                             ManagerDSRReportScreenDetails
                      //                                 .screenName,
                      //                             arguments: {
                      //                               "ScreenMode": "Expenses",
                      //                               "Date":selectedDate,
                      //                             }
                      //                             );
                      //                       },
                      //                       child: Text(
                      //                         formatCurrency(totalExpenseAmountCashFlow), // The amount text
                      //                         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700).copyWith(
                      //                           color: AppColors.blue, // Set color to blue for link appearance
                      //                           decoration: TextDecoration.underline,
                      //                           decorationcolor: AppColors.blue,// Add underline decoration to the amount
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //
                      //                 // Row(
                      //                 //   children: [
                      //                 //     SizedBox(
                      //                 //         width: 70,
                      //                 //         child: Text('Unsettled:',
                      //                 //             style:
                      //                 //             Styling.itemGreyTextSmall)),
                      //                 //     Text(totalUnsettledAmountCashFlow.toStringAsFixed(2),
                      //                 //         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700)),
                      //                 //   ],
                      //                 // ),
                      //                 // SizedBox(
                      //                 //   height: 2,
                      //                 // ),
                      //                 // Row(
                      //                 //   children: [
                      //                 //     SizedBox(
                      //                 //         width: 70,
                      //                 //         child: Text('Settled:',
                      //                 //             style:
                      //                 //             Styling.itemGreyTextSmall)),
                      //                 //     Text(totalSettledAmountCashFlow.toStringAsFixed(2),
                      //                 //         style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700)),
                      //                 //   ],
                      //                 // ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 5),
                      //         Row(
                      //           children: [
                      //             SizedBox(
                      //               width: 70,
                      //               child: Text(
                      //                 'Prepaid:',
                      //                 style: Styling.itemGreyTextSmallReport, // "Bank:" text style without underline
                      //               ),
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 // Navigate to BankDetailsScreen when the amount is tapped
                      //                 Navigator.pushNamed(
                      //                     context,
                      //                     ManagerDSRReportScreenDetails
                      //                         .screenName,
                      //                     arguments: {
                      //                       "ScreenMode": "Bank",
                      //                       "Date":selectedDate,
                      //                     });
                      //               },
                      //               child: Text(
                      //                 formatCurrency(totalBankAmountCashFlow), // The amount text
                      //                 style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700).copyWith(
                      //                   color: AppColors.blue, // Set color to blue for link appearance
                      //                   decoration: TextDecoration.underline,
                      //                   decorationcolor: AppColors.blue,// Add underline decoration to the amount
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 Text(
                      //                   "${selectedDate.toLocal()}".split(' ')[0],
                      //                   // Display date as "yyyy-MM-dd"
                      //                   style: TextStyle(fontSize: 14),
                      //                 ),
                      //                 IconButton(
                      //                   icon: Icon(Icons.calendar_today),
                      //                   // Icon for the calendar
                      //                   onPressed: () => _selectDate(context),
                      //                   iconSize: 24,
                      //                 ),
                      //               ],
                      //             ),
                      //             ElevatedButton(
                      //               onPressed: () {
                      //                 // Handle submit logic here
                      //                 checkIfSavedOrNot(selectedDate);
                      //                 // createPdf();
                      //                 print(
                      //                     "Date Submitted: ${selectedDate.toLocal()}");
                      //               },
                      //               child: Text(
                      //                 'Show DSR',
                      //                 style: TextStyle(color: Colors.white),
                      //               ),
                      //               style: ButtonStyle(
                      //                 backgroundColor:
                      //                     MaterialStateProperty.all<Color>(
                      //                         const AppColors.blue),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),


  // ── Tab chip – newTheam pill style ────────────────────────────────────────
  Widget _buildTabText(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTabIndex = index);
        _scrollToCenter(index);
      },
      child: Container(
        key: _tabKeys[index],
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueXXL : AppColors.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.blueLight : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? const [BoxShadow(color: Color(0x1A1E3A8A), blurRadius: 6, offset: Offset(0, 2))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.blue : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }

  void _scrollToCenter(int index) {
    final keyContext = _tabKeys[index].currentContext;
    if (keyContext == null) return;

    final box = keyContext.findRenderObject() as RenderBox;
    final tabPosition =
        box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
    final tabWidth = box.size.width;

    final screenWidth = MediaQuery.of(context).size.width;
    final scrollOffset = _scrollController.offset;

    // Calculate target scroll offset so that the tab is centered horizontally
    double targetScrollX =
        scrollOffset + tabPosition.dx - (screenWidth / 2) + (tabWidth / 2);

    // Clamp to scroll extent
    if (targetScrollX < 0) targetScrollX = 0;
    if (targetScrollX > _scrollController.position.maxScrollExtent) {
      targetScrollX = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      targetScrollX,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildIncomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataIncomeDailySaleList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Sale'),
                      _buildTableHeaderRow([
                        Expanded(flex: 2, child: Text('Item', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700), textScaler: TextScaler.noScaling)),
                        Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700), textAlign: TextAlign.center, textScaler: TextScaler.noScaling)),
                        Expanded(flex: 2, child: Text('Unsettled', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, textScaler: TextScaler.noScaling)),
                        Expanded(flex: 2, child: Text('Settled', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, textScaler: TextScaler.noScaling)),
                        Expanded(flex: 2, child: Text('', style: TextStyle(fontSize: 12), textAlign: TextAlign.center, textScaler: TextScaler.noScaling)),
                        Expanded(flex: 3, child: Text('Amt', style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700), textAlign: TextAlign.right, textScaler: TextScaler.noScaling)),
                      ]),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: dataIncomeDailySaleList.length,
                            itemBuilder: (context, index) {
                              var item = dataIncomeDailySaleList[index];
                              // Check if quantity and amount are zero and display empty text
                              String? displayQuantity = (item
                                      is ManagerDsrReportIncomeSalesModel)
                                  ? (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          ?.toInt()
                                          .toString()) // Convert to integer if quantity is a double
                                  : (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          .toInt()
                                          .toString()); // For other cases

                              String displayUnsettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString())
                                      : (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString());

                              String displaySettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString())
                                      : (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString());

                              String displayMode =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString())
                                      : (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString());

                              // Check if mode is null, 0, or empty and set the displayAmount accordingly
                              double displayAmount =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount!)
                                      : (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount);

                              TextStyle amountStyle = (item.mode == null ||
                                      item.mode == 0 ||
                                      item.mode == "")
                                  ? TextStyle(fontSize: 12, color: AppColors.textMuted)
                                  : TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700);

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: AppColors.border, width: 0.6)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item is ManagerDsrReportIncomeSalesModel
                                            ? item.itemName ?? ''
                                            : item.itemName ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displayQuantity!,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              ManagerIncomeUnsettledScreenDetails
                                                  .screenName,
                                              arguments: {
                                                "itemId": item
                                                        is ManagerDsrReportIncomeSalesModel
                                                    ? item.itemId ?? ''
                                                    : item.itemId ?? '',
                                                "FlagCheck": 1,
                                                "Date": selectedDate,
                                              });
                                        },
                                        child: Text(
                                          displayUnsettledQuantity,
                                          style: TextStyle(fontSize: 12, color: AppColors.blue, decoration: TextDecoration.underline, decorationColor: AppColors.blue),
                                          textAlign: TextAlign.center,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              ManagerIncomeUnsettledScreenDetails
                                                  .screenName,
                                              arguments: {
                                                "itemId": item
                                                        is ManagerDsrReportIncomeSalesModel
                                                    ? item.itemId ?? ''
                                                    : item.itemId ?? '',
                                                "FlagCheck": 2,
                                                "Date": selectedDate,
                                              });
                                        },
                                        child: Text(
                                          displaySettledQuantity,
                                          style: TextStyle(fontSize: 12, color: AppColors.blue, decoration: TextDecoration.underline, decorationColor: AppColors.blue),
                                          textAlign: TextAlign.center,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayMode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                  : const SizedBox.shrink(),
//               dataIncomeArbSaleList.isNotEmpty
//                   ? Container(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text("ARB Sale",
//                               style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),  textScaler:
//                             TextScaler.noScaling,)),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(0),
//                           topRight: Radius.circular(0),
//                         ),
//                         // Add a color to differentiate header row
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               flex: 4,
//                               child: Text(
//                                 'Item',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.left,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 'Qty',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.center,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 '',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.center,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 '',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.center,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 2,
//                               child: Text(
//                                 '',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.center,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: Text(
//                                 'Amt',
//                                 style:
//                                 TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
//                                 textAlign: TextAlign.right,
//                                 textScaler:
//                                 TextScaler.noScaling,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       itemCount: dataIncomeArbSaleList.length,
//                       // Change this to the length of your data
//                       itemBuilder: (context, index) {
//                         var item = dataIncomeArbSaleList[index];
//                         // Check if quantity and amount are zero and display empty text
//                         String? displayQuantity = (item
//                         is ManagerDsrReportIncomeSalesModel)
//                             ? (item.quantity == 0
//                             ? ''
//                             : item.quantity
//                             ?.toInt()
//                             .toString()) // Convert to integer if quantity is a double
//                             : (item.quantity == 0
//                             ? ''
//                             : item.quantity
//                             .toInt()
//                             .toString()); // For other cases
//
//                         String displayUnsettledQuantity =
//                         (item is ManagerDsrReportIncomeSalesModel)
//                             ? (item.unsettQty == 0
//                             ? ''
//                             : item.unsettQty.toString())
//                             : (item.unsettQty == 0
//                             ? ''
//                             : item.unsettQty.toString());
//
//                         String displaySettledQuantity =
//                         (item is ManagerDsrReportIncomeSalesModel)
//                             ? (item.settQty == 0
//                             ? ''
//                             : item.settQty.toString())
//                             : (item.settQty == 0
//                             ? ''
//                             : item.settQty.toString());
//
//                         String displayMode =
//                         (item is ManagerDsrReportIncomeSalesModel)
//                             ? (item.mode == null || item.mode == 0
//                             ? ''
//                             : item.mode.toString())
//                             : (item.mode == null || item.mode == 0
//                             ? ''
//                             : item.mode.toString());
//
//                         // Check if mode is null, 0, or empty and set the displayAmount accordingly
//                         double displayAmount =
//                         (item is ManagerDsrReportIncomeSalesModel)
//                             ? (item.amount == null || item.amount == 0
//                             ? 0.0
//                             : item.amount!)
//                             : (item.amount == null || item.amount == 0
//                             ? 0.0
//                             : item.amount);
//
// // Apply different styles based on the condition
//                         TextStyle amountStyle = (item.mode == null ||
//                             item.mode == 0 ||
//                             item.mode == "")
//                             ? Styling
//                             .itemBlackTestSmallReport // Normal style if condition is true
//                             : Styling
//                             .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false
//
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 flex: 4,
//                                 child: Text(
//                                   item is ManagerDsrReportIncomeSalesModel
//                                       ? item.itemName ?? ''
//                                       : item.itemName ?? '',
//                                   style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//                                   textAlign: TextAlign.left,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   displayQuantity,
//                                   style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//                                   textAlign: TextAlign.center,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Text(
//                                   displayUnsettledQuantity,
//                                   style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//                                   textAlign: TextAlign.center,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Text(
//                                   displaySettledQuantity,
//                                   style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//                                   textAlign: TextAlign.center,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   displayMode,
//                                   style: TextStyle(fontSize: 12, color: AppColors.textMuted),
//                                   textAlign: TextAlign.center,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   formatCurrency(displayAmount),
//                                   style: amountStyle,
//                                   textAlign: TextAlign.right,
//                                   textScaler:
//                                   TextScaler.noScaling,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )
//                   : Container(),
              dataIncomeSVSaleList.isNotEmpty
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "ARB-SV",
                                  style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              // Add a color to differentiate header row
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Category',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amt',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //  ListView.builder(
                          //   shrinkWrap: true,
                          //   physics: BouncingScrollPhysics(),
                          //   itemCount: dataIncomeSVSaleList.length,
                          //   // Change this to the length of your data
                          //   itemBuilder: (context, index) {
                          //     var item = dataIncomeSVSaleList[index];
                          //     // Check if quantity and amount are zero and display empty text
                          //     String? displayQuantity = (item
                          //     is ManagerDsrReportIncomeSalesModel)
                          //         ? (item.quantity == 0
                          //         ? ''
                          //         : item.quantity
                          //         ?.toInt()
                          //         .toString()) // Convert to integer if quantity is a double
                          //         : (item.quantity == 0
                          //         ? ''
                          //         : item.quantity
                          //         .toInt()
                          //         .toString()); // For other cases
                          //
                          //     String displayUnsettledQuantity =
                          //     (item is ManagerDsrReportIncomeSalesModel)
                          //         ? (item.unsettQty == 0
                          //         ? ''
                          //         : item.unsettQty.toString())
                          //         : (item.unsettQty == 0
                          //         ? ''
                          //         : item.unsettQty.toString());
                          //
                          //     String displaySettledQuantity =
                          //     (item is ManagerDsrReportIncomeSalesModel)
                          //         ? (item.settQty == 0
                          //         ? ''
                          //         : item.settQty.toString())
                          //         : (item.settQty == 0
                          //         ? ''
                          //         : item.settQty.toString());
                          //
                          //     String displayMode =
                          //     (item is ManagerDsrReportIncomeSalesModel)
                          //         ? (item.mode == null || item.mode == 0
                          //         ? ''
                          //         : item.mode.toString())
                          //         : (item.mode == null || item.mode == 0
                          //         ? ''
                          //         : item.mode.toString());
                          //
                          //     // Check if mode is null, 0, or empty and set the displayAmount accordingly
                          //     double displayAmount =
                          //     (item is ManagerDsrReportIncomeSalesModel)
                          //         ? (item.amount == null || item.amount == 0
                          //         ? 0.0
                          //         : item.amount!)
                          //         : (item.amount == null || item.amount == 0
                          //         ? 0.0
                          //         : item.amount);
                          //
                          //     // Apply different styles based on the condition
                          //     TextStyle amountStyle = (item.mode == null ||
                          //         item.mode == 0 ||
                          //         item.mode == "")
                          //         ? Styling
                          //         .itemBlackTestSmallReport // Normal style if condition is true
                          //         : Styling
                          //         .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false
                          //
                          //     return
                          //       Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child:
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Expanded(
                          //             flex: 4,
                          //             child: Text(
                          //               item is ManagerDsrReportIncomeSalesModel
                          //                   ? item.itemName ?? ''
                          //                   : item.itemName ?? '',
                          //               style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          //               textAlign: TextAlign.left,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //           Expanded(
                          //             flex: 2,
                          //             child: Text(
                          //               displayQuantity,
                          //               style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          //               textAlign: TextAlign.center,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //           Expanded(
                          //             flex: 1,
                          //             child: Text(
                          //               displayUnsettledQuantity,
                          //               style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          //               textAlign: TextAlign.center,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //           Expanded(
                          //             flex: 1,
                          //             child: Text(
                          //               displaySettledQuantity,
                          //               style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          //               textAlign: TextAlign.center,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //           Expanded(
                          //             flex: 2,
                          //             child: Text(
                          //               displayMode,
                          //               style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          //               textAlign: TextAlign.center,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //           Expanded(
                          //             flex: 3,
                          //             child: Text(
                          //               formatCurrency(displayAmount),
                          //               style: amountStyle,
                          //               textAlign: TextAlign.right,
                          //               textScaler:
                          //               TextScaler.noScaling,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: dataIncomeSVSaleList.length,
                            itemBuilder: (context, index) {
                              var item = dataIncomeSVSaleList[index];

                              // Helper to get seq safely for both models
                              int? getSeq(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.seq?.toInt();
                                if (model is IncDtls) return model.seq?.toInt();
                                return null;
                              }

                              // Helper to get displayable properties similarly
                              String getItemName(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.itemName ?? '';
                                if (model is IncDtls)
                                  return model.itemName ?? '';
                                return '';
                              }

                              num? getQuantity(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.quantity;
                                if (model is IncDtls) return model.quantity;
                                return 0;
                              }

                              num? getUnsettQty(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.unsettQty;
                                if (model is IncDtls) return model.unsettQty;
                                return 0;
                              }

                              num? getSettQty(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.settQty;
                                if (model is IncDtls) return model.settQty;
                                return 0;
                              }

                              dynamic getMode(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.mode;
                                if (model is IncDtls) return model.mode;
                                return null;
                              }

                              double getAmount(dynamic model) {
                                if (model is ManagerDsrReportIncomeSalesModel)
                                  return model.amount?.toDouble() ?? 0.0;
                                if (model is IncDtls)
                                  return model.amount?.toDouble() ?? 0.0;
                                return 0.0;
                              }

                              // Extract properties for the current item
                              int? seq = getSeq(item);

                              String displayQuantity = (getQuantity(item) == 0)
                                  ? ''
                                  : getQuantity(item)?.toInt().toString() ?? '';
                              String displayUnsettledQuantity =
                                  (getUnsettQty(item) == 0)
                                      ? ''
                                      : getUnsettQty(item).toString();
                              String displaySettledQuantity =
                                  (getSettQty(item) == 0)
                                      ? ''
                                      : getSettQty(item).toString();
                              String displayMode = (getMode(item) == null ||
                                      getMode(item) == 0 ||
                                      getMode(item) == "0")
                                  ? ''
                                  : getMode(item).toString();

                              double displayAmount = getAmount(item);

                              TextStyle amountStyle = (getMode(item) == null ||
                                      getMode(item) == 0 ||
                                      getMode(item) == "0")
                                  ? TextStyle(fontSize: 12, color: AppColors.textMuted)
                                  : TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700);

                              // Check if this item is the last seq 1,2,3 item followed by non seq 1,2,3
                              bool insertDivider = false;
                              if (seq != null &&
                                  [1, 2, 3].contains(seq) &&
                                  index + 1 < dataIncomeSVSaleList.length) {
                                var nextItem = dataIncomeSVSaleList[index + 1];
                                int? nextSeq = getSeq(nextItem);
                                if (nextSeq == null ||
                                    ![1, 2, 3].contains(nextSeq)) {
                                  insertDivider = true;
                                }
                              }

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            getItemName(item),
                                            style: Styling
                                                .itemBlackTestSmallReport,
                                            textAlign: TextAlign.left,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            displayQuantity,
                                            style: Styling
                                                .itemBlackTestSmallReport,
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            displayUnsettledQuantity,
                                            style: Styling
                                                .itemBlackTestSmallReport,
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            displaySettledQuantity,
                                            style: Styling
                                                .itemBlackTestSmallReport,
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            displayMode,
                                            style: Styling
                                                .itemBlackTestSmallReport,
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            formatCurrency(displayAmount),
                                            style: amountStyle,
                                            textAlign: TextAlign.right,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Insert divider only once, between seq groups
                                  if (insertDivider)
                                    Divider(thickness: 0.6, color: AppColors.border, height: 1),
                                ],
                              );
                            },
                          ),


    ],
                      ),
                    )
                  : Container(),
              dataIncomeReceiptSaleList.isNotEmpty
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Credit Payment Receipt",
                                  style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              // Add a color to differentiate header row
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Receipt From',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amt',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: dataIncomeReceiptSaleList.length,
                            // Change this to the length of your data
                            itemBuilder: (context, index) {
                              var item = dataIncomeReceiptSaleList[index];
                              // Check if quantity and amount are zero and display empty text
                              String? displayQuantity = (item
                                      is ManagerDsrReportIncomeSalesModel)
                                  ? (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          ?.toInt()
                                          .toString()) // Convert to integer if quantity is a double
                                  : (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          .toInt()
                                          .toString()); // For other cases

                              String displayUnsettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString())
                                      : (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString());

                              String displaySettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString())
                                      : (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString());

                              String displayMode =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString())
                                      : (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString());

                              // Check if mode is null, 0, or empty and set the displayAmount accordingly
                              double displayAmount =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount!)
                                      : (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount);

// Apply different styles based on the condition
                              TextStyle amountStyle = (item.mode == null ||
                                      item.mode == 0 ||
                                      item.mode == "")
                                  ? Styling
                                      .itemBlackTestSmallReport // Normal style if condition is true
                                  : Styling
                                      .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item is ManagerDsrReportIncomeSalesModel
                                            ? item.itemName ?? ''
                                            : item.itemName ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayQuantity!,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displayUnsettledQuantity,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displaySettledQuantity,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayMode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              dataIncomeRegulatorReplacementList.isNotEmpty
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Regulator Replacement",
                                  style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              // Add a color to differentiate header row
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Item Name',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amt',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                dataIncomeRegulatorReplacementList.length,
                            // Change this to the length of your data
                            itemBuilder: (context, index) {
                              var item =
                                  dataIncomeRegulatorReplacementList[index];
                              // Check if quantity and amount are zero and display empty text
                              String? displayQuantity = (item
                                      is ManagerDsrReportIncomeSalesModel)
                                  ? (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          ?.toInt()
                                          .toString()) // Convert to integer if quantity is a double
                                  : (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          .toInt()
                                          .toString()); // For other cases

                              String displayUnsettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString())
                                      : (item.unsettQty == 0
                                          ? ''
                                          : item.unsettQty.toString());

                              String displaySettledQuantity =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString())
                                      : (item.settQty == 0
                                          ? ''
                                          : item.settQty.toString());

                              String displayMode =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString())
                                      : (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString());

                              // Check if mode is null, 0, or empty and set the displayAmount accordingly
                              double displayAmount =
                                  (item is ManagerDsrReportIncomeSalesModel)
                                      ? (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount!)
                                      : (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount);

// Apply different styles based on the condition
                              TextStyle amountStyle = (item.mode == null ||
                                      item.mode == 0 ||
                                      item.mode == "")
                                  ? Styling
                                      .itemBlackTestSmallReport // Normal style if condition is true
                                  : Styling
                                      .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item is ManagerDsrReportIncomeSalesModel
                                            ? item.itemName ?? ''
                                            : item.itemName ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayQuantity!,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displayUnsettledQuantity,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displaySettledQuantity,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayMode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );

  }

  // Widget _buildDMSaleTab() {
  //   return
  //   SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
  //       child: Container(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             dataDMSaleList.isNotEmpty
  //                 ? ListView.builder(
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(), // Prevents scroll conflict
  //               itemCount: dataDMSaleList.length,
  //               itemBuilder: (context, index) {
  //                 var sale = dataDMSaleList[index];
  //                 return DSRDMWIseListItem(sale);
  //                 // var sale = dataDMSaleList[index];
  //                 // var converted = ManagerGetDsrdMwiseSummaryListModel.fromDmsaleDtls(sale); // implement this
  //                 // return DSRDMWIseListItem(converted);
  //               },
  //             )
  //                 : Text('No data Found'), // Show placeholder with 0 values
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDMSaleTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataDMSaleList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataDMSaleList.length,
                    itemBuilder: (context, index) {
                      var sale = dataDMSaleList[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 6),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sale.staffName ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue,
                                        fontFamily: 'OpenSans'),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                  Text(
                                    sale.itemName ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue,
                                        fontFamily: 'OpenSans'),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildHeaderText('Sale Qty'),
                                  _buildHeaderText('Act.Sale'),
                                  _buildHeaderText('SV'),
                                  _buildHeaderText('TV'),
                                  _buildHeaderText('Def'),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  _buildDataText('${sale.filledSaleQty ?? 0}'),
                                  _buildDataText('${sale.actualSaleQty ?? 0}'),
                                  _buildDataText('${sale.sVQty ?? 0}'),
                                  _buildDataText('${sale.tVQty ?? 0}'),
                                  _buildDataText('${sale.deffQty ?? 0}'),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildAmountText(
                                      'Total Amt.: ',
                                      formatCurrency(
                                          (sale.totalAmount ?? 0).toDouble())),
                                  _buildAmountText(
                                      'Received Amt.',
                                      formatCurrency(
                                          (sale.denoCashRcvd ?? 0).toDouble())),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: _buildSmallAmountRow(
                                            'Online/Prepaid :',
                                            formatCurrency(
                                                (sale.totPrepaidAmt ?? 0)
                                                    .toDouble())),
                                      ),
                                      _verticalDivider(),
                                      Expanded(
                                        child: _buildSmallAmountRow(
                                            'Merchant QR :',
                                            formatCurrency(
                                                (sale.totPostpaidAmt ?? 0)
                                                    .toDouble())),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: _buildSmallAmountRow(
                                            'Credit :',
                                            formatCurrency(
                                                (sale.totRetiCrAmt ?? 0)
                                                    .toDouble())),
                                      ),
                                      _verticalDivider(),
                                      Expanded(
                                        child: _buildSmallAmountRow(
                                            'Cash :',
                                            formatCurrency(
                                                (sale.totCashAmt ?? 0)
                                                    .toDouble())),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }

  // ── newTheam tab UI helpers ──────────────────────────────────────────────

  /// Pill-style section header banner
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.blueXXL,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blueLight, width: 1),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        textScaler: TextScaler.noScaling,
      ),
    );
  }

  /// Themed table header row
  Widget _buildTableHeaderRow(List<Widget> cells) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: cells),
    );
  }

  Widget _buildHeaderText(String title) {
    return Expanded(
      flex: 1,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'OpenSans',
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
        textScaler: TextScaler.noScaling,
      ),
    );
  }

  Widget _buildDataText(String value) {
    return Expanded(
      flex: 1,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'OpenSans',
          color: AppColors.blue,
          fontWeight: FontWeight.w700,
        ),
        textScaler: TextScaler.noScaling,
      ),
    );
  }

  Widget _buildAmountText(String label, String value) {
    return Expanded(
      flex: 0,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'OpenSans',
              color: AppColors.textMuted,
            ),
            textScaler: TextScaler.noScaling,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'OpenSans',
              color: AppColors.blue,
              fontWeight: FontWeight.w700,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAmountRow(String label, String amount) {
    return Row(
      children: [
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontFamily: 'OpenSans',
            ),
            textScaler: TextScaler.noScaling,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.blue,
            fontWeight: FontWeight.w600,
            fontFamily: 'OpenSans',
          ),
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1.0,
      height: 20.0,
      color: AppColors.border,
    );
  }

  Widget _buildExpenseTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataExpenseList.length,
                      // Assuming this is the length of your data
                      itemBuilder: (context, index) {
                        var item = dataExpenseList[index];
                        // Check if mode is null, 0, or empty and set the displayAmount accordingly
                        double displayAmount =
                            (item is ManagerDsrReportExpenseDetailListModel)
                                ? (item.expenseAmount == null ||
                                        item.expenseAmount == 0
                                    ? 0.0
                                    : item.expenseAmount!)
                                : (item.expenseAmount == null ||
                                        item.expenseAmount == 0
                                    ? 0.0
                                    : item.expenseAmount);

// Apply different styles based on the condition
                        TextStyle amountStyle = (item.mode == null ||
                                item.mode == 0 ||
                                item.mode == "")
                            ? Styling
                                .itemBlackTestSmallReport // Normal style if condition is true
                            : Styling
                                .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false

                        // Check if current item has a different 'TransCate' or 'categoryName'
                        bool showHeaderRow = index == 0 ||
                            (dataExpenseList[index].transCate !=
                                dataExpenseList[index - 1].transCate);

                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              // If TransCate is different, show the header row
                              if (showHeaderRow)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.transCate,
                                    // Assuming 'transCate' is what you're checking
                                    style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              if (showHeaderRow)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Expense Head',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.left,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          item.transCate == "TV Refund"
                                              ? 'Qty'
                                              : '',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.center,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.center,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Amt',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.right,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          int expId;
                                          expId = item
                                                  is ManagerDsrReportExpenseDetailListModel
                                              ? item.expHeadId ?? ''
                                              : item.expHeadId ?? '';
                                          String flags;
                                          if (expId != 0) {
                                            flags = "Exp";
                                          } else {
                                            flags = item
                                                    is ManagerDsrReportExpenseDetailListModel
                                                ? item.expenseItemName ?? ''
                                                : item.expenseItemName ?? '';
                                          }
                                          Navigator.pushNamed(
                                              context,
                                              ManagerExpenseTabScreenDetails
                                                  .screenName,
                                              arguments: {
                                                "expenseHeadId": expId,
                                                "FlagCheck": flags,
                                                "Date": selectedDate,
                                              });
                                        },
                                        child: Text(
                                          item.expenseItemName.isEmpty
                                              ? ''
                                              : item.expenseItemName,
                                          style: Styling
                                              .itemBlackTestSmallReport
                                              .copyWith(
                                            color: AppColors.blue,
                                            // Text color set to blue
                                            decoration:
                                                TextDecoration.underline,
                                            // Underline the text
                                            decorationColor: Colors
                                                .blue, // Color for the underline
                                          ),
                                          textAlign: TextAlign.left,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item.transCate == "TV Refund"
                                            ? item.quantity == 0
                                                ? ' '
                                                : item.quantity.toString()
                                            : ' ',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.mode.isEmpty ? '' : item.mode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSVTVTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataSVSaleList.isNotEmpty
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "SV Summary",
                                  style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              // Add a color to differentiate header row
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Item',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Voucher Type',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amt',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: dataSVSaleList.length,
                            // Change this to the length of your data
                            itemBuilder: (context, index) {
                              var item = dataSVSaleList[index];
                              // Check if quantity and amount are zero and display empty text
                              String? displayQuantity = (item
                                      is ManagerGetDsrSvtvListModel)
                                  ? (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          ?.toInt()
                                          .toString()) // Convert to integer if quantity is a double
                                  : (item.quantity == 0
                                      ? ''
                                      : item.quantity
                                          .toInt()
                                          .toString()); // For other cases

                              // String displayVoucherType =
                              // (item is ManagerGetDsrSvtvListModel && item.sVType != null && item.sVType != 0)
                              //     ? item.sVType.toString()
                              //     : '';

                              String? displayVoucherType = (item
                                      is ManagerGetDsrSvtvListModel)
                                  ? (item.sVType == ''
                                      ? ''
                                      : item.sVType
                                          ?.toString()
                                          .toString()) // Convert to integer if quantity is a double
                                  : (item.sVType == ''
                                      ? ''
                                      : item.sVType.toString().toString());
                              debugPrint(
                                  'displayVoucherType: $displayVoucherType');

                              String displayMode =
                                  (item is ManagerGetDsrSvtvListModel)
                                      ? (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString())
                                      : (item.mode == null || item.mode == 0
                                          ? ''
                                          : item.mode.toString());

                              // Check if mode is null, 0, or empty and set the displayAmount accordingly
                              double displayAmount =
                                  (item is ManagerGetDsrSvtvListModel)
                                      ? (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount!)
                                      : (item.amount == null || item.amount == 0
                                          ? 0.0
                                          : item.amount);

                              // Apply different styles based on the condition
                              TextStyle amountStyle = (item.mode == null ||
                                      item.mode == 0 ||
                                      item.mode == "")
                                  ? Styling
                                      .itemBlackTestSmallReport // Normal style if condition is true
                                  : Styling
                                      .itemBlackTestSmallReportBold; // Bold and bigger font if condition is false

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item is ManagerGetDsrSvtvListModel
                                            ? item.itemName ?? ''
                                            : item.itemName ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        displayQuantity!,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayVoucherType ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayMode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              dataTVSaleList.isNotEmpty
                  ? Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "TV Summary",
                                  style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                  textScaler: TextScaler.noScaling,
                                )),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                              // Add a color to differentiate header row
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Item',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Qty',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amt',
                                      style:
                                          TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.right,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: dataTVSaleList.length,
                            itemBuilder: (context, index) {
                              var item = dataTVSaleList[index];

                              String? displayQuantity = (item.quantity == 0)
                                  ? ''
                                  : item.quantity.toInt().toString();

                              String displayMode =
                                  (item.mode == null || item.mode == 0)
                                      ? ''
                                      : item.mode.toString();

                              double displayAmount =
                                  (item.amount == null || item.amount == 0)
                                      ? 0.0
                                      : item.amount;

                              TextStyle amountStyle = (item.mode == null ||
                                      item.mode == 0 ||
                                      item.mode == "")
                                  ? TextStyle(fontSize: 12, color: AppColors.textMuted)
                                  : TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700);

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item.itemName ?? '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayQuantity,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '',
                                        textScaler: TextScaler
                                            .noScaling, // keep if placeholder is necessary, else remove
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        displayMode,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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


  Widget _buildCDCMSStockTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Stock Updated On : ",
                            style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                            textScaler: TextScaler.noScaling,
                          )),
                      Text(
                        startOnDate.toString(),
                        style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                        textScaler: TextScaler.noScaling,
                      )
                    ],
                  ),
                ),
                cdcmsListData.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: cdcmsListData.length,
                        itemBuilder: (context, index) {
                          // Ensure that the lists have valid lengths before accessing them
                          if (index < filledCDControllers.length &&
                              index < emptyCDControllers.length &&
                              index < defectiveCDControllers.length) {
                            ManagerDsrReportCdcmsListModel data =
                                cdcmsListData[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Header row for stock item
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data.itemName ?? 'Item Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Current Stock row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              "Current Stock",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                              textScaler: TextScaler.noScaling,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Filled",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Empty",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Def",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Stock",
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.left,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            data.currentStkFilled?.toString() ??
                                                '0',
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            data.currentStkEmpty?.toString() ??
                                                '0',
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            data.currentStkDefective
                                                    ?.toString() ??
                                                '0',
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                    ],
                                  ),
                                  // Editable TextFields for the user to update stock values
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              "CDCMS",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                              textScaler: TextScaler.noScaling,
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: TextField(
                                            controller:
                                                filledCDControllers[index],
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.blue, width: 1.5)),
                                            ),
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              double newValue =
                                                  double.tryParse(value) ?? 0.0;
                                              setState(() {
                                                filledDiffList[index] = (data
                                                            .currentStkFilled
                                                            ?.toDouble() ??
                                                        0.0) -
                                                    newValue;
                                                totalDiffList[index] =
                                                    filledDiffList[index] +
                                                        emptyDiffList[index] +
                                                        defectiveDiffList[
                                                            index];
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        Expanded(
                                          flex: 2,
                                          child: TextField(
                                            controller:
                                                emptyCDControllers[index],
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.blue, width: 1.5)),
                                            ),
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              double newValue =
                                                  double.tryParse(value) ?? 0.0;
                                              setState(() {
                                                emptyDiffList[index] = (data
                                                            .currentStkEmpty
                                                            ?.toDouble() ??
                                                        0.0) -
                                                    newValue;
                                                totalDiffList[index] =
                                                    filledDiffList[index] +
                                                        emptyDiffList[index] +
                                                        defectiveDiffList[
                                                            index];
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        Expanded(
                                          flex: 2,
                                          child: TextField(
                                            controller:
                                                defectiveCDControllers[index],
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.blue, width: 1.5)),
                                            ),
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              double newValue =
                                                  double.tryParse(value) ?? 0.0;
                                              setState(() {
                                                defectiveDiffList[index] = (data
                                                            .currentStkDefective
                                                            ?.toDouble() ??
                                                        0.0) -
                                                    newValue;
                                                totalDiffList[index] =
                                                    filledDiffList[index] +
                                                        emptyDiffList[index] +
                                                        defectiveDiffList[
                                                            index];
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Display calculated differences
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Difference",
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.left,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            filledDiffList[index]
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: filledDiffList[index] < 0
                                                    ? Colors.red
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            emptyDiffList[index]
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: emptyDiffList[index] < 0
                                                    ? Colors.red
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            defectiveDiffList[index]
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    defectiveDiffList[index] < 0
                                                        ? Colors.red
                                                        : Colors.black),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                    ],
                                  ),
                                  // Display total difference
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 0,
                                          child: Text(
                                            "Total : ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                      Expanded(
                                          flex: 0,
                                          child: Text(
                                            totalDiffList[index]
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: totalDiffList[index] < 0
                                                    ? Colors.red
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox
                                .shrink(); // Return an empty widget if index is out of bounds
                          }
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No CDCMS Data Available',
                            style: TextStyle(fontSize: 14, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                        ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isDateValid
                          ? () {
                              if (saveFlag) {
                                debugPrint("Save data$saveFlag");
                                showFlushBar(
                                    context, Constants.dayEndCompleted);
                              } else {
                                saveCDCMSDataMob();
                                debugPrint("Save data$saveFlag");
                              }
                            }
                          : null,
                      child: Text(
                        "Save CDCMS Data",
                        textScaler: TextScaler.noScaling,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDateValid ? saveFlag ? Colors.grey : AppColors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCashInHandTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cash In Hand ",
                                style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textScaler: TextScaler.noScaling,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Staff Name",
                            style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Collected\nAmount",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Paid\nAmount",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Cash\nCollection",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.noScaling,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataCashInHandList.length,
                      itemBuilder: (context, index) {
                        var data = dataCashInHandList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //     flex: 3,
                                  //     child: Text(data is ManagerDsrReportCashHandOverModel
                                  //         ? data.staffName
                                  //         : data.staffName,
                                  //         style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  //         textAlign: TextAlign.left),
                                  // ),

                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            ManagerCashInHandScreenDeails
                                                .screenName,
                                            arguments: {
                                              "staffId": data
                                                      is ManagerDsrReportCashHandOverModel
                                                  ? data.staffId
                                                  : data.staffId,
                                              "Date": selectedDate,
                                            });
                                      },
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? data.staffName
                                            : data.staffName,
                                        // Display staffName based on data type
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)
                                            .copyWith(
                                          color: AppColors.blue,
                                          // Make the text blue like a link
                                          decoration: TextDecoration.underline,
                                          // Underline the text
                                          decorationColor: Colors
                                              .blue, // Set underline color to blue
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? formatCurrency(
                                                (data.collAmt ?? 0.0)
                                                    .toDouble())
                                            : formatCurrency(
                                                (data.collAmt ?? 0.0)
                                                    .toDouble()),
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? formatCurrency(
                                                (data.paidAmt ?? 0.0)
                                                    .toDouble())
                                            : formatCurrency(
                                                (data.paidAmt ?? 0.0)
                                                    .toDouble()),
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? formatCurrency(
                                                (data.totalAmt ?? 0.0)
                                                    .toDouble())
                                            : formatCurrency(
                                                (data.totalAmt ?? 0.0)
                                                    .toDouble()),
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 0,
                            child: Text(
                              "Total Cash In Hand : ",
                              style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 0,
                            child: Text(
                              formatCurrency(totalCashInHandAmountCashFlow),
                              style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textScaler: TextScaler.noScaling,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cash Flow Summary",
                                style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textScaler: TextScaler.noScaling,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              "",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "Staff/Bank Name",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Amount",
                              style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                              textScaler: TextScaler.noScaling,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataCashFlowSummaryList.length,
                      itemBuilder: (context, index) {
                        var data = dataCashFlowSummaryList[index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        data is ManagerDsrReoprtCashFlowSummaryMode
                                            ? data.headerNameStr
                                            : data.headerNameStr,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                         textAlign: TextAlign.left,
                                         textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        data is ManagerDsrReoprtCashFlowSummaryMode
                                            ? data.staffName
                                            : data.staffName,
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                         textAlign: TextAlign.left,
                                         textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      data is ManagerDsrReoprtCashFlowSummaryMode
                                          ? formatCurrency(
                                              (data.totalAmt ?? 0.0).toDouble())
                                          : formatCurrency(
                                              (data.totalAmt ?? 0.0)
                                                  .toDouble()),
                                      style: TextStyle(fontSize: 12, color: AppColors.textMuted)
                                          .copyWith(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 0,
                            child: Text(
                              "Total Cash Flow Amount : ",
                              style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                              textScaler: TextScaler.noScaling,
                            )),
                        Expanded(
                            flex: 0,
                            child: Text(
                              formatCurrency(totalCahFlowSummaryAmountCashFlow),
                              style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                              textScaler: TextScaler.noScaling,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Denomination Table",
                                style: TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textScaler: TextScaler.noScaling,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text(
                                "Note Type",
                                style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                                textScaler: TextScaler.noScaling,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Qty",
                                style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.noScaling,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.right,
                                textScaler: TextScaler.noScaling,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataCashDenominationList.length,
                      itemBuilder: (context, index) {
                        var data = dataCashDenominationList[index];
                        // Calculate total amount
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        data is ManagerDsrReportCashDeniminationModel
                                            ? "${data.noteType.toString()} X"
                                            : "${data.noteType.toString()} X",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.left,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        data is ManagerDsrReportCashDeniminationModel
                                            ? data.qty?.toString() ?? '0'
                                            : data.qty?.toString() ?? '0',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.center,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        data is ManagerDsrReportCashDeniminationModel
                                            ? data.amount?.toStringAsFixed(2) ??
                                                '0'
                                            : data.amount?.toStringAsFixed(2) ??
                                                '0',
                                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        textAlign: TextAlign.right,
                                        textScaler: TextScaler.noScaling,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 0,
                              child: Text(
                                "Total Amount : ",
                                style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                                textScaler: TextScaler.noScaling,
                              )),
                          Expanded(
                              flex: 0,
                              child: Text(
                                totalAmountCashDenomination.toStringAsFixed(2),
                                style: TextStyle(fontSize: 13, color: AppColors.blue, fontWeight: FontWeight.w700),
                                textScaler: TextScaler.noScaling,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   onPressed: isDateValid ? (){
                        //     // saveDayEndDataMob();
                        //     if(saveFlag){
                        //       debugPrint("Save data");
                        //       showFlushBar(context,
                        //           Constants.dayEndCompleted);
                        //     }else{
                        //
                        //        // bool allZero = true;
                        //
                        //         // for (int i = 0; i < cdcmsListData.length; i++) {
                        //         //   double filled = double.tryParse(filledCDControllers[i].text) ?? 0.0;
                        //         //   double empty = double.tryParse(emptyCDControllers[i].text) ?? 0.0;
                        //         //   double defective = double.tryParse(defectiveCDControllers[i].text) ?? 0.0;
                        //         //   if (filled > 0 || empty > 0 || defective > 0) {
                        //         //     allZero = false;
                        //         //     break; // No need to continue; at least one value is non-zero
                        //         //   }
                        //         // }
                        //
                        //         bool allZero = cdcmsListData.any((item) => item.StkRecoId == 0);
                        //
                        //         if (allZero) {
                        //           // Show AlertDialog and stop further execution
                        //           showDialog(
                        //             context: context,
                        //             builder: (context) => AlertDialog(
                        //               title: Text('Warning:'),
                        //               content: Text('Please update CDCM stock before confirming the DSR.'),
                        //               actions: [
                        //                 TextButton(
                        //                   onPressed: () => Navigator.pop(context),
                        //                   child: Text('OK'),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //           return; // Stop here
                        //         }
                        //
                        //         // if (allZero ) {
                        //         //   showCustomAlertDialog(
                        //         //     context,
                        //         //     title: 'CDCMS Stock Missing',
                        //         //     content: 'Warning: Please update CDCM stock before confirming the DSR.',
                        //         //   );
                        //         // }
                        //         else {
                        //           // Proceed with save logic (e.g., API call or local state update)
                        //           _showConfirmationDialog(context);
                        //           print('Saving data...');
                        //         }
                        //     }
                        //   }:null,
                        //   child: Text("Confirm DSR"),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:isDateValid? saveFlag ? Colors.grey : Colors.blue:Colors.grey,
                        //     foregroundColor: Colors.white,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(50),
                        //     ),
                        //   ),
                        // ),
                        ElevatedButton(
                          onPressed: isDateValid
                              ? () {
                                  //saveDayEndDataMob();
                                  if (saveFlag) {
                                    debugPrint("Save data");
                                    showFlushBar(
                                        context, Constants.dayEndCompleted);
                                  } else {
                                    //  Check for missing CDCMS Stock entries
                                    bool hasMissingStockData = cdcmsListData
                                        .every((item) => item.StkRecoId == 0);
                                    // bool hasMissingStockData = cdcmsListData.any((item) => item.StkRecoId == 0);

                                    if (hasMissingStockData) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Warning:',
                                            textScaler: TextScaler.noScaling,
                                          ),
                                          content: Text(
                                            'Please update CDCM stock before confirming the DSR.',
                                            textScaler: TextScaler.noScaling,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'OK',
                                                textScaler:
                                                    TextScaler.noScaling,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      return; // Stop further execution
                                    } else {
                                      // Proceed with save logic (e.g., API call or local state update)
                                      _showConfirmationDialog(context);
                                      print('Saving data...');
                                    }
                                  }
                                }
                              : null,
                          child: Text(
                            "Confirm DSR",
                            textScaler: TextScaler.noScaling,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDateValid ? saveFlag ? Colors.grey : AppColors.blue : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchIncomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-14"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDsrIncomeReportListForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBodyGetDsrIncomeReportListForMob: ${response.request}');
      debugPrint('responseGetDsrIncomeReportListForMob: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredData = jsonResponse
            .where(
                (item) => item['TransCate'] == 'DailySale') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        // var filteredDataArbSale = jsonResponse
        //     .where((item) => item['TransCate'] == 'ARBSale') // Filter the list
        //     .map((item) =>
        //         ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
        //     .toList();

        var filteredDataSVSale = jsonResponse
            .where((item) => item['TransCate'] == 'ARB-SV') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        var filteredDataReceiptSale = jsonResponse
            .where((item) => item['TransCate'] == 'Receipt') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        var filteredDataRegReplacementSale = jsonResponse
            .where((item) =>
                item['TransCate'] == 'Regulator Replacement') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        dataIncomeTotalAmountList = jsonResponse
            .map((json) => ManagerDsrReportIncomeSalesModel.fromJson(json))
            .toList();

        setState(() {
          // Use filtered data to update the UI
          dataIncomeDailySaleList = filteredData;
          // dataIncomeArbSaleList = filteredDataArbSale;
          dataIncomeSVSaleList = filteredDataSVSale;
          dataIncomeReceiptSaleList = filteredDataReceiptSale;
          dataIncomeRegulatorReplacementList = filteredDataRegReplacementSale;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchDMSaleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDSRDMwiseSummaryList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'FromDate': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBodyGetDsrDMSaleReportListForMob: ${response.request}');
      debugPrint('responseGetDsrDMSaleReportListForMob: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        var dmSaleAmountList = jsonResponse
            .map((item) => ManagerGetDsrdMwiseSummaryListModel.fromJson(
                item)) // Map to model
            .toList();

        dataDMSaleList = jsonResponse
            .map((json) => ManagerGetDsrdMwiseSummaryListModel.fromJson(json))
            .toList();
        setState(() {
          // Use filtered data to update the UI
          dataDMSaleList = dmSaleAmountList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Call first API when flag is 'y'
  Future<void> _fetchExpenseData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-14"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDsrExpenseReportListForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBody GetDsrExpenseReportListForMob: ${response.request}');
      debugPrint('response GetDsrExpenseReportListForMob:  ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredDataExpenseList = jsonResponse
            .map((item) => ManagerDsrReportExpenseDetailListModel.fromJson(
                item)) // Map to model
            .toList();
        dataExpenseTotalAmountList = jsonResponse
            .map(
                (json) => ManagerDsrReportExpenseDetailListModel.fromJson(json))
            .toList();
        setState(() {
          // Use filtered data to update the UI
          dataExpenseList = filteredDataExpenseList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchSVTVData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-14"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDsrSVTVList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'Date': formattedDate,
          'DistributorId': distributorId,
        }),
      );

      debugPrint(
          'jsonRequestBodyGetDsrSVTVReportListForMob: ${response.request}');
      debugPrint('responseGetDsrSVTVReportListForMob: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')

        var filteredTVData = jsonResponse
            .where(
                (item) => item['TransCate'] == 'TV Refund') // Filter the list
            .map((item) =>
                ManagerGetDsrSvtvListModel.fromJson(item)) // Map to model
            .toList();

        var filteredDataSVSale = jsonResponse
            .where((item) => item['TransCate'] == 'SV') // Filter the list
            .map((item) =>
                ManagerGetDsrSvtvListModel.fromJson(item)) // Map to model
            .toList();

        dataSVTVSaleList = jsonResponse
            .map((json) => ManagerGetDsrSvtvListModel.fromJson(json))
            .toList();

        setState(() {
          // Use filtered data to update the UI
          dataSVSaleList = filteredDataSVSale;
          dataTVSaleList = filteredTVData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Call first API when flag is 'y'
  Future<void> _fetchCashHandoverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-17"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetCashHandOverDSRDtlsForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBody GetCashHandOverDSRDtlsForMob: ${response.request}');
      debugPrint('response GetCashHandOverDSRDtlsForMob:  ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredDataCashInHandList = jsonResponse
            .map((item) => ManagerDsrReportCashHandOverModel.fromJson(
                item)) // Map to model
            .toList();

        setState(() {
          // Use filtered data to update the UI
          dataCashInHandList = filteredDataCashInHandList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Call first API when flag is 'y'
  Future<void> _fetchCashFlowSummaryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-17"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetCashFlowSummaryDSRMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBody GetCashFlowSummaryDSRMob: ${response.request}');
      debugPrint('response GetCashFlowSummaryDSRMob:  ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredDataCashInHandList = jsonResponse
            .map((item) => ManagerDsrReoprtCashFlowSummaryMode.fromJson(
                item)) // Map to model
            .toList();

        dataCashFlowSummaryAmountList = jsonResponse
            .map((json) => ManagerDsrReoprtCashFlowSummaryMode.fromJson(json))
            .toList();

        setState(() {
          // Use filtered data to update the UI
          dataCashFlowSummaryList = filteredDataCashInHandList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Call first API when flag is 'y'
  Future<void> _fetchCashDenominationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-11"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetCashDenomDSRRprtForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBody GetCashDenomDSRRprtForMob: ${response.request}');
      debugPrint('response GetCashDenomDSRRprtForMob:  ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredDataCashDenominationList = jsonResponse
            .map((item) => ManagerDsrReportCashDeniminationModel.fromJson(
                item)) // Map to model
            .toList();

        setState(() {
          // Use filtered data to update the UI
          dataCashDenominationList = filteredDataCashDenominationList;
          isLoading = false;
          // totalAmountCashDenomination: not yet wired to state
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Call first API when flag is 'y'
  Future<void> _fetchCDCMSStockData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-14"; // Format selectedDate

    try {
      final response = await http.post(
        // Uri.parse(AppUrl.GetCDCMsStockUpdateForMob),
        Uri.parse(AppUrl.GetCDCMsStockUpdateForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate,
        }),
      );

      debugPrint(
          'jsonRequestBody GetCDCMsStockUpdateForMob: ${response.request}');
      debugPrint('response GetCDCMsStockUpdateForMob:  ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a List
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Filter the data based on the condition (TransCate == 'DailySale')
        var filteredDataCDCMSList = jsonResponse
            .map((item) =>
                ManagerDsrReportCdcmsListModel.fromJson(item)) // Map to model
            .toList();

        setState(() {
          // Use filtered data to update the UI
          cdcmsListData = filteredDataCDCMSList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchSavedListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // This is your bearer token

    // Convert selectedDate to a string in 'yyyy-MM-dd' format
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    // String formattedDate = "2025-02-17"; // Use selectedDate here

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDSRDataAgainstDateForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'Date': formattedDate, // Pass formatted date as a string
        }),
      );

      debugPrint('jsonRequestBody: ${response.request}${formattedDate}');
      debugPrint('GetDSRDataAgainstDateForMobresponse: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a Map
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the response contains valid data
        if (jsonResponse['IncDtls'] != null) {
          // Access the 'IncDtls' list from the response map and filter based on 'TransCate'
          var filteredData = List.from(
                  jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
              .where(
                  (item) => item['TransCate'] == 'DailySale') // Filter the list
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          // var filteredDataArbSale =
          //     List.from(jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
          //         .where((item) =>
          //             item['TransCate'] == 'ARBSale') // Filter the list
          //         .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
          //         .toList();

          var filteredDataSVSale = List.from(
                  jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
              .where((item) => item['TransCate'] == 'ARB-SV') // Filter the list
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataReceiptSale = List.from(
                  jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
              .where(
                  (item) => item['TransCate'] == 'Receipt') // Filter the list
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataRegReplacementSale = List.from(
                  jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
              .where((item) =>
                  item['TransCate'] ==
                  'Regulator Replacement') // Filter the list
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataExpenseList = List.from(
                  jsonResponse['expDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => ExpDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataCashInHandList = List.from(
                  jsonResponse['handoverDtls'] ??
                      []) // Access the list 'IncDtls'
              .map(
                  (item) => HandoverDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataCashDenominationList = List.from(
                  jsonResponse['CashDenomDtls'] ??
                      []) // Access the list 'IncDtls'
              .map((item) =>
                  CashDenomDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataCashFlowSummaryList = List.from(
                  jsonResponse['cashflowDtls'] ??
                      []) // Access the list 'IncDtls'
              .map(
                  (item) => CashflowDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataDMSaleSummaryList = List.from(
                  jsonResponse['dmsaleDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => DmsaleDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataSVSaleSummaryList = List.from(
                  jsonResponse['SvTvDtls'] ?? []) // Access the list 'IncDtls'
              .where((item) => item['TransCate'] == 'SV') // Filter the list
              .map((item) => SvTvDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataTVSaleSummaryList = List.from(
                  jsonResponse['SvTvDtls'] ?? []) // Access the list 'IncDtls'
              .where(
                  (item) => item['TransCate'] == 'TV Refund') // Filter the list
              .map((item) => SvTvDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataIncomeTotalAmountList = List.from(
                  jsonResponse['IncDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataExpenseTotalAmountList = List.from(
                  jsonResponse['expDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => ExpDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataCashFlowSummaryAmountList = List.from(
                  jsonResponse['cashflowDtls'] ??
                      []) // Access the list 'IncDtls'
              .map(
                  (item) => CashflowDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataDMSaleList = List.from(
                  jsonResponse['dmsaleDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => DmsaleDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataSVTVSaleList = List.from(
                  jsonResponse['SvTvDtls'] ?? []) // Access the list 'IncDtls'
              .map((item) => SvTvDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          setState(() {
            dataIncomeDailySaleList = filteredData;
            //dataIncomeArbSaleList = filteredDataArbSale;
            dataIncomeSVSaleList = filteredDataSVSale;
            dataIncomeReceiptSaleList = filteredDataReceiptSale;
            dataExpenseList = filteredDataExpenseList;
            dataCashInHandList = filteredDataCashInHandList;
            dataCashDenominationList = filteredDataCashDenominationList;
            dataCashFlowSummaryList = filteredDataCashFlowSummaryList;
            dataIncomeRegulatorReplacementList = filteredDataRegReplacementSale;
            dataDMSaleList = filteredDataDMSaleSummaryList;
            //dataSVTVSaleList = filteredDataSVTVSaleSummaryList;
            dataSVSaleList = filteredDataSVSaleSummaryList;
            dataTVSaleList = filteredDataTVSaleSummaryList;
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format or missing data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchData(String flag) async {
    EasyLoading.show();
    if (flag == 'Y') {
      await _fetchSavedListData();
      await _fetchCDCMSStockData();
      if (mounted) {
        EasyLoading.dismiss();
      }
    } else {
      await _fetchIncomeData();
      await _fetchDMSaleData();
      await _fetchExpenseData();
      await _fetchSVTVData();
      await _fetchCDCMSStockData();
      await _fetchCashHandoverData();
      await _fetchCashDenominationData();
      await _fetchCashFlowSummaryData();
      if (mounted) {
        EasyLoading.dismiss();
      }
    }

    // Ensure the diff lists have the correct length based on cdcmsListData
    if (mounted) {
      setState(() {
        filledDiffList.clear();
        emptyDiffList.clear();
        defectiveDiffList.clear();
        filledCDControllers.clear();
        emptyCDControllers.clear();
        defectiveCDControllers.clear();

        debugPrint("cdcmsListData Length: ${cdcmsListData.length}");
        // Add the initial values to the lists
        if (cdcmsListData.isNotEmpty) {
          for (int i = 0; i < cdcmsListData.length; i++) {
            ManagerDsrReportCdcmsListModel data = cdcmsListData[i];
            startOnDate = cdcmsListData[0].stockUpdatedOn ?? '';

            filledDiffList.add(data.filledDiff?.toDouble() ?? 0.0);
            emptyDiffList.add(data.emptyDiff?.toDouble() ?? 0.0);
            defectiveDiffList.add(data.defectiveDiff?.toDouble() ?? 0.0);

            totalDiffList.add(data.total?.toDouble() ?? 0.0);

            filledCDControllers.add(TextEditingController());
            emptyCDControllers.add(TextEditingController());
            defectiveCDControllers.add(TextEditingController());

            // Set the initial controller text
            filledCDControllers[i].text = (data.filledCD?.toString() ?? '0');
            emptyCDControllers[i].text = (data.emptyCD?.toString() ?? '0');
            defectiveCDControllers[i].text =
                (data.defectiveCD?.toString() ?? '0');
          }
        }
        debugPrint("filledCDControllers Length: ${filledCDControllers.length}");
        debugPrint("emptyCDControllers Length: ${emptyCDControllers.length}");
        debugPrint(
            "defectiveCDControllers Length: ${defectiveCDControllers.length}");
        // Now calculate the totalAmountCashDenomination once after processing data
        double totalAmount = 0.0;
        for (var data in dataCashDenominationList) {
          totalAmount +=
              data.amount ?? 0.0; // Sum up the amounts from your data
        }

        // Update the totalAmountCashDenomination only once here
        totalAmountCashDenomination = totalAmount;
        debugPrint("totalAmountCashDenomination: $totalAmountCashDenomination");

        double totalCashAmount = 0.0;
        double totalBankAmount = 0.0;
        double totalCreditAmount = 0.0;
        double totalPrepaiOnlineAmount = 0.0;
        double totalUnsettledAmount = 0.0;
        double totalSettledAmount = 0.0;
        double totalExpenseAmount = 0.0;
        double totalCahFlowSummaryAmount = 0.0;
        double totalCahInHandAmount = 0.0;
        // Iterate through each item in your data
        for (var incomeData in dataIncomeTotalAmountList) {
          // Debugging each item to see Mode and Amount
          // debugPrint("Processing item: ${incomeData.itemName}, Mode: ${incomeData.mode}, Amount: ${incomeData.amount}");
          if (incomeData.unsettQty != null && incomeData.unsettQty! > 0) {
            // Add to total for unsettled items
            totalUnsettledAmount += incomeData.amount ?? 0.0;
          }

          if (incomeData.settQty != null && incomeData.settQty! > 0) {
            // Add to total for settled items
            totalSettledAmount += incomeData.amount ?? 0.0;
          }
          // Check if Mode is Cash, Bank, or Credit and accumulate the amounts accordingly
          if (incomeData.mode != null) {
            if (incomeData.mode == 'Cash -') {
              totalCashAmount +=
                  incomeData.amount ?? 0.0; // Add the amount to the cash total
            } else if (incomeData.mode == 'Merchant QR -') {
              totalBankAmount +=
                  incomeData.amount ?? 0.0; // Add the amount to the bank total
            } else if (incomeData.mode == 'Credit -') {
              totalCreditAmount += incomeData.amount ??
                  0.0; // Add the amount to the credit total
            } else if (incomeData.mode == 'Prepaid Online -') {
              totalPrepaiOnlineAmount += incomeData.amount ??
                  0.0; // Add the amount to the credit total
            }
          }
        }
        totalCashAmountCashFlow = totalCashAmount;
        totalBankAmountCashFlow = totalBankAmount;
        totalCreditAmountCashFlow = totalCreditAmount;
        totalUnsettledAmountCashFlow = totalUnsettledAmount;
        totalSettledAmountCashFlow = totalSettledAmount;
        totalPrepaidOnlineCashFlow = totalPrepaiOnlineAmount;

// Output the totals for each mode
        debugPrint("Total Cash Amount: $totalCashAmount");
        debugPrint("Total Merchant QR Amount: $totalBankAmount");
        debugPrint("Total Credit Amount: $totalCreditAmount");
        debugPrint("Total Unsettled Amount: $totalUnsettledAmount");
        debugPrint("Total Settled Amount: $totalSettledAmount");
        debugPrint("Total prepaid online Amount: $totalPrepaiOnlineAmount");

        for (var expensess in dataExpenseTotalAmountList) {
          if (expensess.mode != null) {
            if (expensess.mode == 'Cash -' || expensess.mode == 'Bank -') {
              totalExpenseAmount += expensess.expenseAmount ??
                  0.0; // Add the amount to the cash total
            }
          }
        }
        totalExpenseAmountCashFlow = totalExpenseAmount;
        debugPrint("Total Expense Amount: $totalExpenseAmount");

        for (var cashflow in dataCashFlowSummaryAmountList) {
          totalCahFlowSummaryAmount +=
              cashflow.totalAmt ?? 0.0; // Add the amount to the cash total
        }

        totalCahFlowSummaryAmountCashFlow = totalCahFlowSummaryAmount;
        debugPrint("Total CahFlowSummary Amount: $totalCahFlowSummaryAmount");

        for (var cashInHand in dataCashInHandList) {
          totalCahInHandAmount +=
              cashInHand.totalAmt ?? 0.0; // Add the amount to the cash total
        }

        totalCashInHandAmountCashFlow = totalCahInHandAmount;
        debugPrint("Total totalCahInHandAmount Amount: $totalCahInHandAmount");

        if (mounted) {
          EasyLoading.dismiss();
        }
      });
    }
  }

  Future<void> saveCDCMSDataMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);

    // Format selectedDate to match the format required by the API
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Now update the cdcmsListData based on user inputs from the TextFields
    List<Map<String, dynamic>> cDCMSModel = [];

    for (int i = 0; i < cdcmsListData.length; i++) {
      ManagerDsrReportCdcmsListModel data = cdcmsListData[i];

      // Capture the updated values from TextField controllers
      int filledCDValue = int.tryParse(filledCDControllers[i].text) ?? 0;
      int emptyCDValue = int.tryParse(emptyCDControllers[i].text) ?? 0;
      int defectiveCDValue = int.tryParse(defectiveCDControllers[i].text) ?? 0;

      // Calculate differences based on current values and input values
      int filledDiff = (data.currentStkFilled?.toInt() ?? 0) - filledCDValue;
      int emptyDiff = (data.currentStkEmpty?.toInt() ?? 0) - emptyCDValue;
      int defectiveDiff =
          (data.currentStkDefective?.toInt() ?? 0) - defectiveCDValue;
      int totalDiff = filledDiff + emptyDiff + defectiveDiff;

      // Create a new Map for the cDCMS model to be sent in the request
      Map<String, dynamic> cDCMSData = {
        "DistributorId": distributorIds,
        "ItemId": data.itemId,
        // Assuming ItemId is available in your data
        "AddedBy": staffIds,
        "IsDayEndDone": 1,
        "DayEndTime": formattedDate,
        // If you want to send a specific time, update it
        "FilledCurr": data.currentStkFilled?.toInt() ?? 0,
        "EmptyCurr": data.currentStkEmpty?.toInt() ?? 0,
        "DefectiveCurr": data.currentStkDefective?.toInt() ?? 0,
        "FilledCDCMS": filledCDValue,
        "EmptyCDCMS": emptyCDValue,
        "DefectiveCDCMS": defectiveCDValue,
        "FilledDiff": filledDiff,
        "EmptyDiff": emptyDiff,
        "DefectiveDiff": defectiveDiff,
        "TotalDiff": totalDiff
      };

      // Add the created data to the cDCMSModel list
      cDCMSModel.add(cDCMSData);
    }

    // Request body with only the required data
    final Map<String, dynamic> requestBody = {
      "Sktrecold": 0,
      "DistributorId": distributorId,
      "StkUpdateDate": formattedDate,
      "IsDayEndDone": 1,
      "DayEndTime": formattedDate,
      "AddedBy": StaffId,
      "Action": 'ADD',
      "CDCMSDetailList": cDCMSModel
    };

    // Making the POST request
    try {
      final response = await http.post(
        Uri.parse('${AppUrl.SavecDCMSDataFromMob}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: json.encode(requestBody),
      );
      print(
          "response SavecDCMSDataFromMob: ${response.statusCode} - ${response.body}");
      print("requestBody SavecDCMSDataFromMob: $requestBody");

      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Save successfully!')),
        );
      } else {
        // Error response
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Exception handling
      print("Exception: $e");
    }
  }

  Future<void> saveDayEndDataMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);

    // Format selected date
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Process and filter the relevant data for each model

    // Process Cash Denomination Data
    final List<Map<String, dynamic>> dataCashDenomination =
        dataCashDenominationList.map((e) {
      return {
        "Noteid": e.noteId,
        "NoteQty": e.qty,
        "NoteAmt": e.totalAmount,
        "RetNoteQty": e.retNoteQty,
        "RetNoteAmt": e.retNoteAmt
      };
    }).toList();

    // Process Cash In Hand Data
    final List<Map<String, dynamic>> dataCashInHand =
        dataCashInHandList.map((e) {
      return {
        "StaffId": e.staffId,
        "CollAmt": e.collAmt,
        "PaidAmt": e.paidAmt,
        "TotalAmt": e.totalAmt,
        "CashStatus": 0
      };
    }).toList();

    final List<Map<String, dynamic>> dataCashFlowSummary =
        dataCashFlowSummaryList.map((e) {
      return {
        "StaffId": e.staffId ?? 0,
        "DistributorId": distributorIds,
        "HeaderNameStr": e.headerNameStr,
        "BankId": e.bankId ?? 0,
        "TotalAmt": e.totalAmt ?? 0,
        "MappingId": e.mappingId ?? 0
      };
    }).toList();
    for (var e in dataIncomeTotalAmountList) {
      print('quantity: ${e.quantity}, type: ${e.quantity.runtimeType}');
      print('Seq: ${e.seq.toString()}');
    }
    // Process Income & Expense Data
    final List<Map<String, dynamic>> dataIncomeTotalAmount = []
      ..addAll(dataIncomeTotalAmountList.map((e) {
        return {
          "TransCate": e.transCate,
          "ItemId": e.itemId,
          "ItemName": e.itemName,
          "Seq": e.seq,
          "TotalSaleQty": double.tryParse(e.quantity.toString())?.toInt() ?? 0,
          "UnsettQty": e.unsettQty,
          "SettQty": e.settQty,
          "Mode": e.mode,
          "Amount": e.amount,
          "SectionType": 1,
        };
      }).toList())
      ..addAll(dataExpenseList.map((e) {
        return {
          "TransCate": e.transCate,
          "ItemName": e.expenseItemName,
          "Mode": e.mode,
          "TotalSaleQty": e.quantity,
          "Amount": e.expenseAmount,
          "SectionType": 2,
        };
      }).toList());

    final List<Map<String, dynamic>> dataDMSale = dataDMSaleList.map((e) {
      return {
        "DMId": e.dMId,
        "StaffName": e.staffName,
        "ItemId": e.itemId,
        "ItemName": e.itemName,
        "FilledSaleQty": e.filledSaleQty,
        "ActualSaleQty": e.actualSaleQty,
        "SVQty": e.sVQty,
        "TVQty": e.tVQty,
        "DeffQty": e.deffQty,
        "TotalAmount": e.totalAmount,
        "TotPrepaidAmt": e.totPrepaidAmt,
        "TotPostpaidAmt": e.totPostpaidAmt,
        "TotRetiCrAmt": e.totRetiCrAmt,
        "TotCashAmt": e.totCashAmt,
        "DenoCashRcvd": e.denoCashRcvd
      };
    }).toList();

    // final List<Map<String, dynamic>> dataSVTVSale = dataSVTVSaleList.map((e) {
    //   return {
    //     "DistributorId": e.distributorId,
    //     "TransCate": e.transCate,
    //     "ItemId": e.itemId,
    //     "ItemName": e.itemName,
    //     "Quantity": e.quantity,
    //     "SVType": e.sVType,
    //     "Mode": e.mode,
    //     "Amount":e.amount
    //   };
    // }).toList();

    final List<Map<String, dynamic>> dataSVTVSale = dataSVTVSaleList.map((e) {
      return {
        "DistributorId": e.distributorId,
        "TransCate": e.transCate ?? '',
        "ItemId": e.itemId ?? 0,
        "ItemName": e.itemName ?? '',
        "Quantity": e.quantity ?? 0,
        "SVType": e.sVType ?? '',
        "Mode": e.mode ?? '',
        "Amount": (e.amount ?? 0).toDouble(),
      };
    }).toList();

    for (var item in dataIncomeTotalAmount) {
      print('--- Entry ---');
      item.forEach((key, value) {
        print('$key: $value');
      });
    }

    print(jsonEncode(dataIncomeTotalAmount));
    // Request Body to send data to the API
    final Map<String, dynamic> requestBody = {
      "DSRId": 0,
      "DistributorId": distributorIds,
      "DSRDate": formattedDate,
      "IncCash": totalCashAmountCashFlow,
      "IncBank": totalBankAmountCashFlow,
      "IncCredit": totalCreditAmountCashFlow,
      "UnsettledAmt": totalUnsettledAmountCashFlow,
      "SettledAmt": totalSettledAmountCashFlow,
      "PrepaidAmt": totalPrepaidOnlineCashFlow,
      "ExpCash": 0,
      "ExpBank": 0,
      "ExpCredit": 0,
      "AddedBy": staffIds,
      "DSRIncomeExpenseList": dataIncomeTotalAmount,
      "CashInhandDetailList": dataCashInHand,
      "DenomDetailList": dataCashDenomination,
      "CashflowDetailList": dataCashFlowSummary,
      "DMSaleDetailList": dataDMSale,
      "SVTVDetailList": dataSVTVSale,
      "Action": 'ADD'
    };
    // print("response SaveAllDSRDataFromMob: ${response.statusCode} - ${response.body}");
    print("requestBody SaveAllDSRDataFromMob: $requestBody");
    print("requestBody SaveAllDSRDataFromMob1: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // Making the POST request
    try {
      final response = await http.post(
        Uri.parse('${AppUrl.SaveAllDSRDataFromMob}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: json.encode(requestBody),
      );
      print(
          "response SaveAllDSRDataFromMob: ${response.statusCode} - ${response.body}");
      print("requestBody SaveAllDSRDataFromMob: $requestBody");

      //Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response: ${response.body}");
        checkAndSaveDayEndData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Save successfully!')),
        );
        Navigator.pushReplacementNamed(context, BottomNavBarExample.screenName);
      } else {
        // Error response
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Exception handling
      print("Exception: $e");
    }
  }

  Future<void> checkIfSavedOrNot(DateTime selectedDateS) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDateS);
    final Map<String, dynamic> requestBody = {
      "DistributorId": distributorIds,
      // Replace with your actual distributor ID
      "DSRDate": formattedDate
      // Replace with the actual date
    };

    try {
      // Make the POST request with Bearer token authorization
      final response = await http.post(
        Uri.parse('${AppUrl.DSRCheckSavedornot}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successfully received a response
        final responseData = jsonDecode(response.body);

        // Check if the response is greater than 0
        if (responseData > 0) {
          _fetchData("Y");
          _fetchCDCMSStockData();
          checkAndSaveDayEndData();
          print("Response is greater than 0DSRCheckSavedornot: $responseData");
        } else {
          _fetchData("N");
          _fetchCDCMSStockData();
          checkAndSaveDayEndData();
          print(
              "Response is less than or equal to 0DSRCheckSavedornot: $responseData");
        }
      } else {
        print(
            "Request failed with statusDSRCheckSavedornot: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm DSR Submission",
            textScaler: TextScaler.noScaling,
          ),
          content: Text(Constants.DSRMessage),
          actions: [
            TextButton(
              onPressed: () {
                // If "No" is clicked, close the dialog
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                textScaler: TextScaler.noScaling,
              ),
            ),
            TextButton(
              onPressed: () {
                // If "Yes" is clicked, call the method and close the dialog
                saveDayEndDataMob();
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes Confirm DSR",
                textScaler: TextScaler.noScaling,
              ),
            ),
          ],
        );
      },
    );
  }

  // Future<void> checkAndSaveDayEndData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   int? distributorIds = int.parse(distributorId!);
  //   try {
  //     // Make the GET request
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $bearerToken",
  //         // Pass bearer token in headers
  //       },
  //     );
  //     debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
  //     debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
  //     if (response.statusCode == 200) {
  //       // Parse the API response
  //       List<dynamic> apiResponse = json.decode(response.body);
  //
  //       // Check if the response list is empty
  //       if (apiResponse.isEmpty) {
  //         // If the list is empty, do not save
  //         saveFlag = false;
  //         print("The list is empty, no data to save.");
  //       } else {
  //         saveFlag = true;
  //         // Access the first item in the list (assuming it's an object)
  //         // var dayEndData = apiResponse[0];
  //
  //         // You can validate the fields in the response as needed
  //
  //         // // Check if all required fields are saved
  //         // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
  //         //   saveFlag = true;
  //         //   // If the conditions are met, set the flag and save the data
  //         //   print("Data is valid, proceeding to save.");
  //         // } else {
  //         //   // If any condition is not met, print a message
  //         //   print("Data is incomplete. Cannot proceed to save.");
  //         // }
  //       }
  //     } else {
  //       // Handle API error
  //       print("Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Exception handling
  //     print("Exception: $e");
  //   }
  // }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? distributorId = prefs.getString('DistributorId');
      final String? bearerToken = prefs.getString('token');

      // Guard: abort silently if required prefs are missing
      if (distributorId == null || distributorId.isEmpty) {
        debugPrint('checkAndSaveDayEndData: DistributorId not found in prefs');
        return;
      }
      if (bearerToken == null || bearerToken.isEmpty) {
        debugPrint('checkAndSaveDayEndData: token not found in prefs');
        return;
      }

      // Safe parse — avoids FormatException and null-crash
      final int? distributorIds = int.tryParse(distributorId);
      if (distributorIds == null) {
        debugPrint('checkAndSaveDayEndData: DistributorId "$distributorId" is not a valid integer');
        return;
      }

      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );

      debugPrint("Response body  CheckDayEndConfirmation: ${response.body}");
      debugPrint("Request        CheckDayEndConfirmation: ${response.request}");

      if (response.statusCode == 200) {
        final List<dynamic> apiResponse = json.decode(response.body);

        if (apiResponse.isEmpty) {
          saveFlag = false;
          debugPrint('checkAndSaveDayEndData: list is empty — saveFlag = false');
        } else {
          saveFlag = true;
          debugPrint('checkAndSaveDayEndData: list has data — saveFlag = true');
        }
      } else {
        debugPrint('checkAndSaveDayEndData: HTTP ${response.statusCode}');
      }
    } catch (e, st) {
      // Catches SocketException, FormatException, any remaining runtime errors.
      // Does NOT rethrow — keeps background failure silent so tests/UI are stable.
      debugPrint('checkAndSaveDayEndData: exception — $e\n$st');
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat(
        '#,##,###.00', 'en_IN'); // Indian locale with comma separator

    // Ensure the result always shows a leading zero before the decimal point
    String formattedAmount = format.format(amount);

    // If there's no integer part, it ensures that a leading zero is added before decimal
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }

    return formattedAmount;
  }

  void showCustomAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = 'OK',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: prevent tap outside to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel_outlined,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Styling.bodyTitleWithBlueHight,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_outlined,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      content,
                      style: AppTypography.dataRowLabel,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cancelText,
                    style: const TextStyle(color: Colors.white),
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


