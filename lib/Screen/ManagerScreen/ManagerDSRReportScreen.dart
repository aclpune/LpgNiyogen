import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetUnsettledAmountListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetails.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'package:http/http.dart' as http;

import 'DSRItemClickUI/ManagerCashInHandScreenDetails.dart';
import 'DSRItemClickUI/ManagerDSRReportScreenDetails.dart';
import 'DSRItemClickUI/ManagerExpenseTabScreenDetails.dart';
import 'DSRItemClickUI/ManagerExpenseTabScreenUI.dart';
import 'ManagerModelClass/ManagerDSRReportCDCMSListModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashHandOverModel.dart';
import 'ManagerModelClass/ManagerDSRReportExpenseDetailListModel.dart';
import 'ManagerModelClass/ManagerDSRReportIncomeSalesModel.dart';
import 'ManagerModelClass/ManagerDSRReportSavedDataFetchModel.dart';

import 'dart:typed_data';

import 'ManagerModelClass/ManagerDsrReoprtCashFlowSummaryMode.dart';  // Correct import for ByteData

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
  List<dynamic> dataIncomeDailySaleList = [];
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

  double totalCashAmountCashFlow = 0.0;
  double totalBankAmountCashFlow = 0.0;
  double totalCreditAmountCashFlow = 0.0;
  double totalUnsettledAmountCashFlow = 0.0;
  double totalSettledAmountCashFlow = 0.0;
  double totalExpenseAmountCashFlow = 0.0;
  double totalCahFlowSummaryAmountCashFlow = 0.0;

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
  @override
  void initState() {
    super.initState();
    // _fetchData("Y");
    checkIfSavedOrNot(selectedDate);
    checkAndSaveDayEndData();

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
   var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
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
        // appBar: CustomAppBarManager(
        //   title: 'Daily Sale Report', // Title or hint text for the text field
        // ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Light blue background color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // First Column (Refill and TV)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              'Cash:',
                                              style: Styling.itemGreyTextSmallReport, // No need to modify the "Cash:" text
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  ManagerDSRReportScreenDetails
                                                      .screenName,
                                                  arguments: {
                                                    "ScreenMode": "Cash",
                                                    "Date":selectedDate,
                                                  });

                                            },
                                            child: Text(
                                              formatCurrency(totalCashAmountCashFlow), // The amount text
                                              style: Styling.itemBlackTestSmallReportBold.copyWith(
                                                color: Colors.blue, // Set color to blue for link appearance
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.blue,// Add underline decoration
                                              ),// The amount style
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              'Bank:',
                                              style: Styling.itemGreyTextSmallReport, // "Bank:" text style without underline
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to BankDetailsScreen when the amount is tapped
                                              Navigator.pushNamed(
                                                  context,
                                                  ManagerDSRReportScreenDetails
                                                      .screenName,
                                                  arguments: {
                                                    "ScreenMode": "Bank",
                                                    "Date":selectedDate,
                                                  });
                                            },
                                            child: Text(
                                              formatCurrency(totalBankAmountCashFlow), // The amount text
                                              style: Styling.itemBlackTestSmallReportBold.copyWith(
                                                color: Colors.blue, // Set color to blue for link appearance
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.blue,// Add underline decoration to the amount
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Second Column (SV and Amount)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Credit:',
                                              style: Styling.itemGreyTextSmallReport, // The "Credit:" text style
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  ManagerDSRReportScreenDetails
                                                      .screenName,
                                                  arguments: {
                                                    "ScreenMode": "Credit",
                                                    "Date":selectedDate,
                                                  });
                                            },
                                            child: Text(
                                              formatCurrency(totalCreditAmountCashFlow), // The amount text
                                              style: Styling.itemBlackTestSmallReportBold.copyWith(
                                                color: Colors.blue, // Set color to blue for link appearance
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.blue,// Add underline decoration to the amount
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'Expenses:',
                                              style: Styling.itemGreyTextSmallReport, // The "Expenses:" text style
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to ExpensesDetailsScreen when the amount is tapped
                                              Navigator.pushNamed(
                                                  context,
                                                  ManagerDSRReportScreenDetails
                                                      .screenName,
                                                  arguments: {
                                                    "ScreenMode": "Expenses",
                                                    "Date":selectedDate,
                                                  }
                                                  );
                                            },
                                            child: Text(
                                              formatCurrency(totalExpenseAmountCashFlow), // The amount text
                                              style: Styling.itemBlackTestSmallReportBold.copyWith(
                                                color: Colors.blue, // Set color to blue for link appearance
                                                decoration: TextDecoration.underline,
                                                decorationColor: Colors.blue,// Add underline decoration to the amount
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Row(
                                      //   children: [
                                      //     SizedBox(
                                      //         width: 70,
                                      //         child: Text('Unsettled:',
                                      //             style:
                                      //             Styling.itemGreyTextSmall)),
                                      //     Text(totalUnsettledAmountCashFlow.toStringAsFixed(2),
                                      //         style: Styling.itemBlackTestSmallReportBold),
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 2,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     SizedBox(
                                      //         width: 70,
                                      //         child: Text('Settled:',
                                      //             style:
                                      //             Styling.itemGreyTextSmall)),
                                      //     Text(totalSettledAmountCashFlow.toStringAsFixed(2),
                                      //         style: Styling.itemBlackTestSmallReportBold),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${selectedDate.toLocal()}".split(' ')[0],
                                        // Display date as "yyyy-MM-dd"
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        // Icon for the calendar
                                        onPressed: () => _selectDate(context),
                                        iconSize: 24,
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle submit logic here
                                      checkIfSavedOrNot(selectedDate);
                                      // createPdf();
                                      print(
                                          "Date Submitted: ${selectedDate.toLocal()}");
                                    },
                                    child: Text(
                                      'Show DSR',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff1280b3)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // TabBar with clickable tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTabText('Income', 0),
                          _buildTabText('Expense', 1),
                          _buildTabText('CDCMS Stock', 2),
                          _buildTabText('Cash', 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildIncomeTab(),
                      _buildExpenseTab(),
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
      );
  }

  Widget _buildTabText(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
                color: _selectedTabIndex == index ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            color:
                _selectedTabIndex == index ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dataIncomeDailySaleList.isNotEmpty
                  ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Text("Sale", style: Styling.bodyTitleBigBold)),
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
                              flex: 2,
                              child: Text(
                                'Item',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Unsettled',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Settled',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Amt',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                flex: 2,
                                child: Text(
                                  item is ManagerDsrReportIncomeSalesModel
                                      ? item.itemName ?? ''
                                      : item.itemName ?? '',
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    displayQuantity!,
                                    style: Styling.itemBlackTestSmallReport,
                                    textAlign: TextAlign.center,
                                  ),

                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(
                                        context,
                                        ManagerIncomeUnsettledScreenDetails
                                            .screenName,
                                        arguments: {
                                          "itemId":item is ManagerDsrReportIncomeSalesModel
                                              ? item.itemId ?? ''
                                              : item. itemId?? '',
                                          "FlagCheck":1,
                                          "Date":selectedDate,
                                        }
                                    );
                                  },
                                  child: Text(
                                    displayUnsettledQuantity,
                                    style: Styling.blueClrTextWithUnderline,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(
                                        context,
                                        ManagerIncomeUnsettledScreenDetails
                                            .screenName,
                                        arguments: {
                                          "itemId":item is ManagerDsrReportIncomeSalesModel
                                              ? item.itemId ?? ''
                                              : item. itemId?? '',
                                          "FlagCheck":2,
                                          "Date":selectedDate,
                                        }
                                    );
                                  },
                                  child: Text(
                                    displaySettledQuantity,
                                    style: Styling.blueClrTextWithUnderline,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayMode,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatCurrency(displayAmount),
                                  style: amountStyle,
                                  textAlign: TextAlign.right,
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
              dataIncomeArbSaleList.isNotEmpty
                  ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("ARB Sale",
                              style: Styling.bodyTitleBigBold)),
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
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Qty',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Amt',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataIncomeArbSaleList.length,
                      // Change this to the length of your data
                      itemBuilder: (context, index) {
                        var item = dataIncomeArbSaleList[index];
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
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayQuantity!,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displayUnsettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displaySettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayMode,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatCurrency(displayAmount),
                                  style: amountStyle,
                                  textAlign: TextAlign.right,
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
              dataIncomeSVSaleList.isNotEmpty
                  ? Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "SV",
                            style: Styling.bodyTitleBigBold,
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
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Amt',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataIncomeSVSaleList.length,
                      // Change this to the length of your data
                      itemBuilder: (context, index) {
                        var item = dataIncomeSVSaleList[index];
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
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayQuantity!,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displayUnsettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displaySettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayMode,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatCurrency(displayAmount),
                                  style: amountStyle,
                                  textAlign: TextAlign.right,
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
                            style: Styling.bodyTitleBigBold,
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
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Amt',
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.right,
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
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayQuantity!,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displayUnsettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  displaySettledQuantity,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  displayMode,
                                  style: Styling.itemBlackTestSmallReport,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatCurrency(displayAmount),
                                  style: amountStyle,
                                  textAlign: TextAlign.right,
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              // If TransCate is different, show the header row
                              if (showHeaderRow)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.transCate,
                                    // Assuming 'transCate' is what you're checking
                                    style: Styling.bodyTitleBigBold,
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
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Amt',
                                          style: Styling
                                              .itemBlackTestSmallReportBold,
                                          textAlign: TextAlign.right,
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
                                          expId = item is ManagerDsrReportExpenseDetailListModel
                                              ? item.expHeadId?? ''
                                              : item. expHeadId?? '';
                                          String flags;
                                          if(expId != 0){
                                            flags = "Exp";
                                          }else{
                                            flags = item is ManagerDsrReportExpenseDetailListModel
                                                ? item.expenseItemName?? ''
                                                : item. expenseItemName?? '';
                                          }
                                          Navigator.pushNamed(
                                              context,
                                              ManagerExpenseTabScreenDetails
                                                  .screenName,
                                              arguments: {
                                                "expenseHeadId":expId,
                                                "FlagCheck":flags,
                                                "Date":selectedDate,
                                              }
                                          );
                                        },
                                        child: Text(
                                          item.expenseItemName.isEmpty ? '' : item.expenseItemName,
                                          style: Styling.itemBlackTestSmallReport.copyWith(
                                            color: Colors.blue, // Text color set to blue
                                            decoration: TextDecoration.underline, // Underline the text
                                            decorationColor: Colors.blue, // Color for the underline
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.mode.isEmpty ? '' : item.mode,
                                        style: Styling.itemBlackTestSmallReport,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        formatCurrency(displayAmount),
                                        style: amountStyle,
                                        textAlign: TextAlign.right,
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
                          child: Text("Stock Updated On : ", style: Styling.bodyTitleBigBold)),
                      Text(startOnDate.toString(), style: Styling.bodyTitleBigBold)
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
                      ManagerDsrReportCdcmsListModel data = cdcmsListData[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Header row for stock item
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(data.itemName ?? 'Item Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              ],
                            ),
                            // Current Stock row
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text("Current Stock", style: TextStyle(fontSize: 12), textAlign: TextAlign.left)),
                                  Expanded(flex: 2, child: Text("Filled", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                                  Expanded(flex: 2, child: Text("Empty", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                                  Expanded(flex: 2, child: Text("Def", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(flex: 3, child: Text("Stock", style: TextStyle(fontSize: 12), textAlign: TextAlign.left)),
                                Expanded(flex: 2, child: Text(data.currentStkFilled?.toString() ?? '0', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                                Expanded(flex: 2, child: Text(data.currentStkEmpty?.toString() ?? '0', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                                Expanded(flex: 2, child: Text(data.currentStkDefective?.toString() ?? '0', style: TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                              ],
                            ),
                            // Editable TextFields for the user to update stock values
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text("CDCMS", style: TextStyle(fontSize: 12), textAlign: TextAlign.left)),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: filledCDControllers[index],
                                      decoration: buildInputWithSmallUnderline(context),
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        double newValue = double.tryParse(value) ?? 0.0;
                                        setState(() {
                                          filledDiffList[index] = (data.currentStkFilled?.toDouble() ?? 0.0) - newValue;
                                          totalDiffList[index] = filledDiffList[index] + emptyDiffList[index] + defectiveDiffList[index];
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: emptyCDControllers[index],
                                      decoration: buildInputWithSmallUnderline(context),
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        double newValue = double.tryParse(value) ?? 0.0;
                                        setState(() {
                                          emptyDiffList[index] = (data.currentStkEmpty?.toDouble() ?? 0.0) - newValue;
                                          totalDiffList[index] = filledDiffList[index] + emptyDiffList[index] + defectiveDiffList[index];
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: defectiveCDControllers[index],
                                      decoration: buildInputWithSmallUnderline(context),
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        double newValue = double.tryParse(value) ?? 0.0;
                                        setState(() {
                                          defectiveDiffList[index] = (data.currentStkDefective?.toDouble() ?? 0.0) - newValue;
                                          totalDiffList[index] = filledDiffList[index] + emptyDiffList[index] + defectiveDiffList[index];
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
                                Expanded(flex: 3, child: Text("Difference", style: TextStyle(fontSize: 12), textAlign: TextAlign.left)),
                                Expanded(flex: 2, child: Text(filledDiffList[index].toStringAsFixed(2), style: TextStyle(fontSize: 12, color: filledDiffList[index] < 0 ? Colors.red : Colors.black), textAlign: TextAlign.center)),
                                Expanded(flex: 2, child: Text(emptyDiffList[index].toStringAsFixed(2), style: TextStyle(fontSize: 12, color: emptyDiffList[index] < 0 ? Colors.red : Colors.black), textAlign: TextAlign.center)),
                                Expanded(flex: 2, child: Text(defectiveDiffList[index].toStringAsFixed(2), style: TextStyle(fontSize: 12, color: defectiveDiffList[index] < 0 ? Colors.red : Colors.black), textAlign: TextAlign.center)),
                              ],
                            ),
                            // Display total difference
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(flex: 0, child: Text("Total : ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
                                Expanded(flex: 0, child: Text(totalDiffList[index].toStringAsFixed(2), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: totalDiffList[index] < 0 ? Colors.red : Colors.black), textAlign: TextAlign.center)),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.shrink();  // Return an empty widget if index is out of bounds
                    }
                  },
                )
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No CDCMS Data Available',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
                              child: Text("Cash In Hand ",
                                  style: Styling.bodyTitleBigBold)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text("Staff Name",
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text("Collected\nAmount",
                                style: Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center)),
                        Expanded(
                            flex: 2,
                            child: Text("Paid\nAmount",
                                style:Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center)),
                        Expanded(
                            flex: 2,
                            child: Text("Cash\nCollection",
                                style:Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: dataCashInHandList.length,
                      itemBuilder: (context, index) {
                        var data = dataCashInHandList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom:0.0),
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
                                  //         style: Styling.itemBlackTestSmallReport,
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
                                              "staffId": data is ManagerDsrReportCashHandOverModel
                                                  ? data.staffId
                                                  : data.staffId,
                                              "Date":selectedDate,
                                            }
                                        );
                                      },
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? data.staffName
                                            : data.staffName, // Display staffName based on data type
                                        style: Styling.itemBlackTestSmallReport.copyWith(
                                          color: Colors.blue, // Make the text blue like a link
                                          decoration: TextDecoration.underline, // Underline the text
                                          decorationColor: Colors.blue, // Set underline color to blue
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReportCashHandOverModel
                                              ? formatCurrency((data.collAmt ?? 0.0).toDouble())
                                              : formatCurrency((data.collAmt ?? 0.0).toDouble()),
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReportCashHandOverModel
                                              ? formatCurrency((data.paidAmt ?? 0.0).toDouble())
                                              : formatCurrency((data.paidAmt ?? 0.0).toDouble()),
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReportCashHandOverModel
                                              ? formatCurrency((data.totalAmt ?? 0.0).toDouble())
                                              : formatCurrency((data.totalAmt ?? 0.0).toDouble()),
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 0,
                                      child: Text("Total Cash In Hand : ",
                                          style: Styling.itemBlackTestBold,
                                          textAlign: TextAlign.left)),
                                  Expanded(
                                      flex: 0,
                                      child: Text(
                                        data is ManagerDsrReportCashHandOverModel
                                            ? formatCurrency((data.totalAmt ?? 0.0).toDouble())
                                            : formatCurrency((data.totalAmt ?? 0.0).toDouble()),
                                          style: Styling.itemBlackTestBold,
                                          )),
                                ],
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Cash Flow Summary",
                                  style: Styling.bodyTitleBigBold)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text("",
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left)),
                        Expanded(
                            flex: 3,
                            child: Text("Staff/Bank Name",
                                style:
                                Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.left)),
                        Expanded(
                            flex: 2,
                            child: Text("Amount",
                                style: Styling.itemBlackTestSmallReportBold,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    SizedBox(height: 10,),
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
                                      child: Text(data is ManagerDsrReoprtCashFlowSummaryMode
                                          ? data.headerNameStr
                                          : data.headerNameStr,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.left)),
                                  Expanded(
                                      flex: 3,
                                      child: Text(data is ManagerDsrReoprtCashFlowSummaryMode
                                          ? data.staffName
                                          : data.staffName,
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.left)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReoprtCashFlowSummaryMode
                                              ? formatCurrency((data.totalAmt ?? 0.0).toDouble())
                                              : formatCurrency((data.totalAmt ?? 0.0).toDouble()),
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                              SizedBox(height: 10,),

                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 0,
                            child: Text("Total Cash Flow Amount : ",
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left)),
                        Expanded(
                            flex: 0,
                            child: Text(
                              formatCurrency(totalCahFlowSummaryAmountCashFlow),
                              style: Styling.itemBlackTestBold,
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child:
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Denomination Table",
                                  style: Styling.bodyTitleBigBold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text("Note Type",
                                  style:
                                  Styling.itemBlackTestSmallReportBold,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              flex: 2,
                              child: Text("Qty",
                                  style: Styling.itemBlackTestSmallReportBold,
                                  textAlign: TextAlign.center)),
                          Expanded(
                              flex: 2,
                              child: Text("Amount",
                                  style:Styling.itemBlackTestSmallReportBold,
                                  textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
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
                                      child: Text(data is ManagerDsrReportCashDeniminationModel
                                          ? "${data.noteType.toString()} X"
                                          : "${data.noteType.toString()} X",
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.left)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReportCashDeniminationModel
                                              ? data.qty?.toString() ??'0'
                                              : data.qty?.toString() ??'0',
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          data is ManagerDsrReportCashDeniminationModel
                                              ? data.amount?.toStringAsFixed(2)??'0'
                                              : data.amount?.toStringAsFixed(2) ??'0',
                                          style: Styling.itemBlackTestSmallReport,
                                          textAlign: TextAlign.right)),

                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 0,
                              child: Text("Total Amount : ",
                                  style: Styling.itemBlackTestBold,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              flex: 0,
                              child: Text(
                                totalAmountCashDenomination.toStringAsFixed(2),
                                style: Styling.itemBlackTestBold,
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
                        ElevatedButton(
                          onPressed: isDateValid ? (){
                            // saveDayEndDataMob();
                            if(saveFlag){
                              debugPrint("Save data");
                              showFlushBar(context,
                                  Constants.dayEndCompleted);
                            }else{
                              _showConfirmationDialog(context);
                            }
                          }:null,
                          child: Text("Confirm DSR"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:isDateValid? saveFlag ? Colors.grey : Colors.blue:Colors.grey,
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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
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

      debugPrint('jsonRequestBodyGetDsrIncomeReportListForMob: ${response.request}');
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

        var filteredDataArbSale = jsonResponse
            .where((item) => item['TransCate'] == 'ARBSale') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        var filteredDataSVSale = jsonResponse
            .where((item) => item['TransCate'] == 'SV') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        var filteredDataReceiptSale = jsonResponse
            .where((item) => item['TransCate'] == 'Receipt') // Filter the list
            .map((item) =>
                ManagerDsrReportIncomeSalesModel.fromJson(item)) // Map to model
            .toList();

        dataIncomeTotalAmountList = jsonResponse.map((json) => ManagerDsrReportIncomeSalesModel.fromJson(json)).toList();

        setState(() {
          // Use filtered data to update the UI
          dataIncomeDailySaleList = filteredData;
          dataIncomeArbSaleList = filteredDataArbSale;
          dataIncomeSVSaleList = filteredDataSVSale;
          dataIncomeReceiptSaleList = filteredDataReceiptSale;
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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
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
        dataExpenseTotalAmountList = jsonResponse.map((json) => ManagerDsrReportExpenseDetailListModel.fromJson(json)).toList();
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

  // Call first API when flag is 'y'
  Future<void> _fetchCashHandoverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
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

        dataCashFlowSummaryAmountList = jsonResponse.map((json) => ManagerDsrReoprtCashFlowSummaryMode.fromJson(json)).toList();

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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
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
          double totalAmount = 0;
          for (var data in filteredDataCashDenominationList) {
            totalAmount += data.amount ?? 0.0; // Ensure null safety
          }

          // totalAmountCashDenomination = totalAmount;
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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDate); // Format selectedDate
    // String formattedDate = "2025-02-14"; // Format selectedDate

    try {
      final response = await http.post(
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
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
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

      debugPrint('jsonRequestBody: ${response.request}');
      debugPrint('response: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body as a Map
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the response contains valid data
        if (jsonResponse != null && jsonResponse['IncDtls'] != null) {
          // Access the 'IncDtls' list from the response map and filter based on 'TransCate'
          var filteredData =
              List.from(jsonResponse['IncDtls']) // Access the list 'IncDtls'
                  .where((item) =>
                      item['TransCate'] == 'DailySale') // Filter the list
                  .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
                  .toList();

          var filteredDataArbSale =
              List.from(jsonResponse['IncDtls']) // Access the list 'IncDtls'
                  .where((item) =>
                      item['TransCate'] == 'ARBSale') // Filter the list
                  .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
                  .toList();

          var filteredDataSVSale =
              List.from(jsonResponse['IncDtls']) // Access the list 'IncDtls'
                  .where((item) => item['TransCate'] == 'SV') // Filter the list
                  .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
                  .toList();

          var filteredDataReceiptSale =
              List.from(jsonResponse['IncDtls']) // Access the list 'IncDtls'
                  .where((item) =>
                      item['TransCate'] == 'Receipt') // Filter the list
                  .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
                  .toList();

          var filteredDataExpenseList =
              List.from(jsonResponse['expDtls']) // Access the list 'IncDtls'
                  .map((item) => ExpDtls.fromJson(item)) // Map to IncDtls model
                  .toList();

          var filteredDataCashInHandList =
          List.from(jsonResponse['handoverDtls']) // Access the list 'IncDtls'
              .map((item) => HandoverDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataCashDenominationList =
          List.from(jsonResponse['CashDenomDtls']) // Access the list 'IncDtls'
              .map((item) => CashDenomDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          var filteredDataCashFlowSummaryList =
          List.from(jsonResponse['cashflowDtls']) // Access the list 'IncDtls'
              .map((item) => CashflowDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataIncomeTotalAmountList = List.from(jsonResponse['IncDtls']) // Access the list 'IncDtls'
              .map((item) => IncDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataExpenseTotalAmountList = List.from(jsonResponse['expDtls']) // Access the list 'IncDtls'
              .map((item) => ExpDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          dataCashFlowSummaryAmountList = List.from(jsonResponse['cashflowDtls']) // Access the list 'IncDtls'
              .map((item) => CashflowDtls.fromJson(item)) // Map to IncDtls model
              .toList();

          setState(() {
            dataIncomeDailySaleList = filteredData;
            dataIncomeArbSaleList = filteredDataArbSale;
            dataIncomeSVSaleList = filteredDataSVSale;
            dataIncomeReceiptSaleList = filteredDataReceiptSale;
            dataExpenseList = filteredDataExpenseList;
            dataCashInHandList = filteredDataCashInHandList;
            dataCashDenominationList = filteredDataCashDenominationList;
            dataCashFlowSummaryList = filteredDataCashFlowSummaryList;
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
      if(mounted){
        EasyLoading.dismiss();
      }
    } else {
      await _fetchIncomeData();
      await _fetchExpenseData();
      await _fetchCDCMSStockData();
      await _fetchCashHandoverData();
      await _fetchCashDenominationData();
      await _fetchCashFlowSummaryData();
      if (mounted) {
        EasyLoading.dismiss();
      }
    }

    // Ensure the diff lists have the correct length based on cdcmsListData
    if(mounted) {
      setState(() {
        filledDiffList.clear();
        emptyDiffList.clear();
        defectiveDiffList.clear();

        filledCDControllers.clear();
        emptyCDControllers.clear();
        defectiveCDControllers.clear();

        debugPrint("cdcmsListData Length: ${cdcmsListData.length}");
        // Add the initial values to the lists
        if(cdcmsListData.isNotEmpty) {
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
        double totalUnsettledAmount = 0.0;
        double totalSettledAmount = 0.0;
        double totalExpenseAmount = 0.0;
        double totalCahFlowSummaryAmount = 0.0;
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
            } else if (incomeData.mode == 'Bank -') {
              totalBankAmount +=
                  incomeData.amount ?? 0.0; // Add the amount to the bank total
            } else if (incomeData.mode == 'Credit -') {
              totalCreditAmount += incomeData.amount ??
                  0.0; // Add the amount to the credit total
            }
          }
        }
        totalCashAmountCashFlow = totalCashAmount;
        totalBankAmountCashFlow = totalBankAmount;
        totalCreditAmountCashFlow = totalCreditAmount;
        totalUnsettledAmountCashFlow = totalUnsettledAmount;
        totalSettledAmountCashFlow = totalSettledAmount;

// Output the totals for each mode
        debugPrint("Total Cash Amount: $totalCashAmount");
        debugPrint("Total Bank Amount: $totalBankAmount");
        debugPrint("Total Credit Amount: $totalCreditAmount");
        debugPrint("Total Unsettled Amount: $totalUnsettledAmount");
        debugPrint("Total Settled Amount: $totalSettledAmount");


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
      int defectiveDiff = (data.currentStkDefective?.toInt() ?? 0) - defectiveCDValue;
      int totalDiff = filledDiff + emptyDiff + defectiveDiff;

      // Create a new Map for the cDCMS model to be sent in the request
      Map<String, dynamic> cDCMSData = {
        "DistributorId": distributorIds,
        "ItemId": data.itemId, // Assuming ItemId is available in your data
        "AddedBy": staffIds,
        "IsDayEndDone": 1,
        "DayEndTime":formattedDate, // If you want to send a specific time, update it
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
      print("response SavecDCMSDataFromMob: ${response.statusCode} - ${response.body}");
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
    final List<Map<String, dynamic>> dataCashDenomination = dataCashDenominationList.map((e) {
      return {
        "Noteid": e.noteId,
        "NoteQty": e.qty,
        "NoteAmt": e.totalAmount,
        "RetNoteQty": e.retNoteQty,
        "RetNoteAmt": e.retNoteAmt
      };
    }).toList();

    // Process Cash In Hand Data
    final List<Map<String, dynamic>> dataCashInHand = dataCashInHandList.map((e) {
      return {
        "StaffId": e.staffId,
        "CollAmt": e.collAmt,
        "PaidAmt": e.paidAmt,
        "TotalAmt": e.totalAmt,
        "CashStatus":0
      };
    }).toList();



    final List<Map<String, dynamic>> dataCashFlowSummary= dataCashFlowSummaryList.map((e) {
      return {
        "StaffId": e.staffId ?? 0,
        "DistributorId": distributorIds,
        "HeaderNameStr": e.headerNameStr,
        "BankId": e.bankId ?? 0,
        "TotalAmt":e.totalAmt ?? 0,
        "MappingId":e.mappingId ?? 0
      };
    }).toList();

    // Process Income & Expense Data
    final List<Map<String, dynamic>> dataIncomeTotalAmount = []
      ..addAll(dataIncomeTotalAmountList.map((e) {
        return {
          "TransCate": e.transCate,
          "ItemId": e.itemId,
          "ItemName": e.itemName,
          "TotalSaleQty": e.quantity,
          "UnsettQty": e.unsettQty,
          "SettQty": e.settQty,
          "Mode": e.mode,
          "Amount": e.amount,
          "SectionType":1
        };
      }).toList())
      ..addAll(dataExpenseList.map((e) {
        return {
          "TransCate": e.transCate,
          "ItemName": e.expenseItemName,
          "Mode": e.mode,
          "Amount": e.expenseAmount,
          "SectionType":2,
        };
      }).toList());

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
      "ExpCash": 0,
      "ExpBank": 0,
      "ExpCredit": 0,
      "AddedBy": staffIds,
      "DSRIncomeExpenseList": dataIncomeTotalAmount,
      "CashInhandDetailList": dataCashInHand,
      "DenomDetailList": dataCashDenomination,
      "CashflowDetailList": dataCashFlowSummary,
      "Action": 'ADD'
    };
    // print("response SaveAllDSRDataFromMob: ${response.statusCode} - ${response.body}");
    print("requestBody SaveAllDSRDataFromMob: $requestBody");
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
      print("response SaveAllDSRDataFromMob: ${response.statusCode} - ${response.body}");
      print("requestBody SaveAllDSRDataFromMob: $requestBody");

      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response: ${response.body}");
        checkAndSaveDayEndData();
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

  Future<void> checkIfSavedOrNot(DateTime selectedDateS) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    String? StaffName = prefs.getString('StaffName');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDateS);
    final Map<String, dynamic> requestBody = {
      "DistributorId":distributorIds,  // Replace with your actual distributor ID
      "DSRDate":formattedDate      // Replace with the actual date
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
          print("Response is less than or equal to 0DSRCheckSavedornot: $responseData");
        }
      } else {
        print("Request failed with statusDSRCheckSavedornot: ${response.statusCode}");
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
          title: Text("Confirm DSR Submission"),
          content: Text(Constants.DSRMessage),
          actions: [
            TextButton(
              onPressed: () {
                // If "No" is clicked, close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // If "Yes" is clicked, call the method and close the dialog
                saveDayEndDataMob();
                Navigator.of(context).pop();
              },
              child: Text("Yes Confirm DSR"),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        // Parse the API response
        List<dynamic> apiResponse = json.decode(response.body);

        // Check if the response list is empty
        if (apiResponse.isEmpty) {
          // If the list is empty, do not save
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            // If the conditions are met, set the flag and save the data
            print("Data is valid, proceeding to save.");
          } else {
            // If any condition is not met, print a message
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      // Exception handling
      print("Exception: $e");
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
