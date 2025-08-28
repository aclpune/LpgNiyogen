import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ARBScreen/GetCashDenominationDtlsByIdModel.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import 'TodaysCashSummaryOnAccountList.dart';

class OnAccountPopupScreen extends StatefulWidget {
  static const screenName = '/onAccountPopupScreen';

  const OnAccountPopupScreen({super.key});

  @override
  State<OnAccountPopupScreen> createState() => _OnAccountPopupScreenState();
}
class _OnAccountPopupScreenState extends State<OnAccountPopupScreen> {

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetCashDenominationDtlsByIdModel> denominationModel = [];
  GetCashDenominationDtlsByIdModel? _selectDenomination;
  bool isLoading = true;
  int _selectedIndex = 0;
  String? formattedDate;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  late List<TextEditingController> qtyController;
  late List<double> amounts;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  double totalAmount = 0.0;
  bool _isTranscode = false;
  List<TextEditingController> qtyControllerReturn = [];
  List<double> amountsReturn = [];
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  double balanceAmount = 0.0;
  Map<int, bool> isQtyFilled = {};
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  late final _balanceController = TextEditingController();
  late final recDateController = TextEditingController();
  late final categoryController = TextEditingController();
  late final staffNameController = TextEditingController();
  late final balanceController = TextEditingController();
  bool isCashDenominationListViewVisible = false;
  String? _selectedExp;
  int? selectedExpId;
  bool _isDepositEmpty = false;
  String? modes;
  var argValue;
  int? paymentId;
  bool isEditMode = false;
  double? getEditTotalAmount;
  bool saveFlag = false;
  String? ledgerId;
  String? receiptDate;
  String? category;
  String? selectedstaffId;
  String? staffName;
  String? totalBalanceAmt;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  late List<String> selectedLedgerIds;

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    fetchBank();
    getNoteTypeAndIDList();
    //checkAndSaveDayEndData();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();

    Future.delayed(Duration.zero, () {
      setState(() {
        // Extracting arguments from the previous route
        final argValue = ModalRoute.of(context)?.settings.arguments as Map?;

        if (argValue != null) {
          // Extracting individual arguments
          ledgerId = argValue["ledgerId"];
          category = argValue["category"];
          selectedstaffId = argValue["staffId"];
          staffName = argValue["staffName"];
          totalBalanceAmt = argValue["totalBalance"];

          // Extracting the list of ledgerIds (which was passed as a list)
         selectedLedgerIds = List<String>.from(argValue["ledgerIds"] ?? []);
          print('Selected Ledger IDs: $selectedLedgerIds'); // Now you can use this list

        } else {
          // Handle case where arguments are not found (optional)
          print('No arguments found!');
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Receipt"),
            SizedBox(height: 4),
          ],
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(left: 5.0,right: 5,top: 5,bottom: 15),
        child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: countTextWidgetTextcash(
                      context,
                      formattedDate != null
                          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(formattedDate!))
                          : '', // Fallback to empty string if receiptDate is null
                    ),
                  ),
                  Expanded(flex:1,child: countTextWidgetTextcash(context, staffName != null ? staffName!:'')),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(flex:1,child: countTextWidgetTextcash(context, category != null ? category!:'')),
                  Expanded(flex:1,child:  countTextWidgetTextcash(context, totalBalanceAmt != null ? totalBalanceAmt.toString() : '',),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: textWidgetBlueColorWithStar(
                      'Receipt Amount',
                      "*",
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child:
                    TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                        LengthLimitingTextInputFormatter(8), // Limit to 9 characters total
                      ],
                      onChanged: (value) {
                        setState(() {
                          // Try to parse the entered value to a double
                          double enteredAmount = double.tryParse(value) ?? 0.0;

                          // Ensure totalBalanceAmt is treated as a double for comparison
                          double totalBalance = double.tryParse(totalBalanceAmt ?? '') ?? 0.0;

                          // Validate that enteredAmount is not greater than totalBalanceAmt
                          if (enteredAmount > totalBalance) {
                            showFlushBar(context, "Entered amount cannot be greater than the total balance.");
                            _balanceController.clear();  // _balanceController is your TextEditingController
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Receipt Amount',
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        errorText: _isDepositEmpty ? 'Amount is required' : null,
                        errorStyle: TextStyle(color: Colors.red),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                    textWidgetBlueColorWithStar(
                      'Payment Mode',
                      "*", // Add a parameter to conditionally show the asterisk
                    ),
                  ),
                  Flexible(flex: 1,
                    child:
                    DropdownButtonFormField<String>(
                      key: formKey1,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                      ),
                      value: selectedTransMode,
                      // Bind the selected value
                      items: getTransMode.map((String value) =>
                          DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTransMode =
                              value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              if (selectedTransMode == 'Cash')
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cashDenominationMandatory?"Cash Denomination Is Mandatory":
                        "Cash denomination",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),
                ),
              if (selectedTransMode == 'Cash')
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: Row(
                    children: [
                      // First Half (Cash Denomination)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0; // Show Container 1
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedIndex == 0
                                  ? Colors.blue
                                  : Colors.blue[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(2),
                                bottomLeft: Radius.circular(2),
                              ),
                            ),
                            child: Text(
                              "Cash Denomination",
                              style: Styling.buttonTextBlack.copyWith(
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Second Half (Cash Return)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1; // Show Container 2
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectedIndex == 1
                                  ? Colors.blue
                                  : Colors.blue[200],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                            ),
                            child: Text(
                              "Cash Return",
                              style: Styling.buttonTextBlack.copyWith(
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (selectedTransMode == 'Cash')
                Visibility(
                  visible: _selectedIndex == 0,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // Background color of the box
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width:
                                  1), // Optional: Add rounded corners
                            ),
                            child: Column(
                              children: [
                                // First Row with Vertical Divider
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    // Center the row content
                                    children: [
                                      // First Text and Divider inside Expanded to ensure equal size
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text(
                                              "Note Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )), // Centering the text
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Text(
                                              "Qty",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )), // Centering the text
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Text(
                                              "Amount",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )), // Centering the text
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                  getNoteTypeAndIdFroDenominationListModel
                                      .length,
                                  itemBuilder: (context, index) {
                                    final data =
                                    getNoteTypeAndIdFroDenominationListModel[
                                    index];
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                  "${data.noteType}",
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                  textAlign:
                                                  TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  "X",
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                child: TextField(
                                                  controller:
                                                  qtyController[
                                                  index],
                                                  keyboardType:
                                                  TextInputType
                                                      .number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      amounts[
                                                      index] = (double.tryParse(
                                                          value) ?? 0.0) *
                                                          data.noteType!;
                                                      totalAmount = amounts.fold(
                                                          0.0, (sum, amount) => sum + amount);
                                                      finalAmountCashDeno = totalAmount - returnAmount;
                                                      isQtyFilled[index] = value.isNotEmpty; // Mark index as filled
                                                      debugPrint(
                                                          "Collected$totalAmount");
                                                    });
                                                  },
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  "=",
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                child: Text(
                                                  "${amounts[index].toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  "Collected:",
                                                  style: Styling
                                                      .itemBlackTestBold,
                                                  //textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  totalAmount
                                                      .toStringAsFixed(
                                                      2),
                                                  style: Styling
                                                      .itemBlackTestBold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  "Final Total:",
                                                  style: Styling
                                                      .itemBlackTestBold,
                                                  textAlign:
                                                  TextAlign.left,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  finalAmountCashDeno
                                                      .toStringAsFixed(2),
                                                  style: Styling
                                                      .itemBlackTestBold,
                                                ),
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
                      ),
                    ],
                  ),
                ),
              Visibility(
                visible: _selectedIndex == 1,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // Background color of the box
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width:
                                1), // Optional: Add rounded corners
                          ),
                          child: Column(
                            children: [
                              // First Row with Vertical Divider
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  // Center the row content
                                  children: [
                                    // First Text and Divider inside Expanded to ensure equal size
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text(
                                            "Note Type",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )), // Centering the text
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                          child: Text(
                                            "Qty",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )), // Centering the text
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                          child: Text(
                                            "Amount",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )), // Centering the text
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                getNoteTypeAndIdFroDenominationListModel
                                    .length,
                                itemBuilder: (context, index) {
                                  final data =
                                  getNoteTypeAndIdFroDenominationListModel[
                                  index];
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child: Text(
                                                "${data.noteType}",
                                                style: TextStyle(
                                                    fontSize: 12),
                                                textAlign:
                                                TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                "X",
                                                style: TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: TextField(
                                                controller:
                                                qtyControllerReturn[
                                                index],
                                                keyboardType:
                                                TextInputType
                                                    .number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    amountsReturn[index] = (double.tryParse(value) ?? 0.0) *
                                                        data.noteType!;
                                                    returnAmount = amountsReturn.fold(0.0, (sum, amount) =>
                                                    sum + amount);
                                                    finalAmountCashDeno = totalAmount - returnAmount;
                                                    debugPrint("return$returnAmount");
                                                  });
                                                },
                                                textAlign: TextAlign.center,
                                                enabled: !isQtyFilled.containsKey(index) ||
                                                    !isQtyFilled[index]!,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                "=",
                                                style: TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: Text(
                                                "${amountsReturn[index].toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                "Return:",
                                                style: Styling
                                                    .itemBlackTestBold,
                                                //textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                returnAmount
                                                    .toStringAsFixed(
                                                    2),
                                                style: Styling
                                                    .itemBlackTestBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Final Total section
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                "Final Total:",
                                                style: Styling
                                                    .itemBlackTestBold,
                                                textAlign:
                                                TextAlign.left,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                finalAmountCashDeno
                                                    .toStringAsFixed(2),
                                                style: Styling
                                                    .itemBlackTestBold,
                                              ),
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
                    ),
                  ],
                ),
              ),
              if (selectedTransMode == 'Online')
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                          DropdownButtonFormField<
                              GetBankMappingDetailsListModel>(
                            value:bankModel.contains(_selectBankModel)?_selectBankModel:null ,
                            items: bankModel.map((item) {
                              return DropdownMenuItem<
                                  GetBankMappingDetailsListModel>(
                                value: item,
                                child: Text(
                                  '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                _selectBankModel = selectedItem;
                                selectedBankName = selectedItem?.bankName;
                                selectedBankId = selectedItem?.accountNo;
                                selecteBankIDApi = selectedItem?.bankId?.toInt();
                                accMappingId = selectedItem?.mappingId?.toInt();
                              });
                            },
                            hint: Text('Select Acc No'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                          TextField(
                            controller: TranCodeController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(30), // Limit to 30 characters
                              FilteringTextInputFormatter.deny(
                                RegExp(r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                              ),
                              FilteringTextInputFormatter.deny(
                                RegExp(r'\s'), // Block all whitespace including space, tab, etc.
                              ),
                            ],
                            decoration: InputDecoration(
                              errorText: _isTranscode
                                  ? 'Transaction code is Required'
                                  : null,
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  countTextWidgetTextStar(
                                    context,
                                    'Transaction Code',
                                    showAsterisk: true,
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isTranscode = value.isEmpty;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                              LengthLimitingTextInputFormatter(5),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Time',
                              labelStyle: Styling.itemBlackTestSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                          TextField(
                            controller: transReviewController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                            ],
                            decoration: InputDecoration(
                              labelText: 'Transaction Remark',
                              labelStyle: Styling.itemBlackTestSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cancelAction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Adds space between buttons
                  ElevatedButton(
                    onPressed: () {
                      staffLedgerSettlementAddEditMob(0, "ADD");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10, // Adjust padding to make button smaller
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }

  Future<void> getNoteTypeAndIDList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCashDenominationItemList}/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint(
            "Response body GetCashDenominationItemList: ${response.body}");
        debugPrint(
            "request body GetCashDenominationItemList: ${response.request}");

        if (response.statusCode == 200) {
          // Decode the response body as a List
          final List<dynamic> jsonResponse = jsonDecode(response.body);

          // Filter the data based on the condition (TransCate == 'DailySale')
          var filteredDataCashDenominationList = jsonResponse
              .map((item) => DenomModel.fromJson(
              item)) // Map to model
              .toList();

          setState(() {
            // Use filtered data to update the UI
            getNoteTypeAndIdFroDenominationListModel =
                filteredDataCashDenominationList;
            dataCashDenominationList = filteredDataCashDenominationList;

            isLoading = false;
            double totalAmount = 0;
            for (var data in filteredDataCashDenominationList) {
              totalAmount += data.totalAmt ?? 0.0; // Ensure null safety
            }
            qtyController = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => TextEditingController(),
            );

            amounts = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => 0.0,
            );

            qtyControllerReturn = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => TextEditingController(),
            );

            amountsReturn = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => 0.0,
            );
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankMappingDetailsListModel : " +
        '${AppUrl.GetBankMappingDetailsList}/$distributorId/0');
    debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        bankModel = data.map((json) {
          return GetBankMappingDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  void cancelAction(){
    setState(() {
      selectedBankName = '';
      selectedTransMode = null;
      selectedBankId = null;
      selectedTransMode = null;
      _selectBankModel = null;
      selectedTransMode = null;
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      _balanceController.clear();
      modes = "Save";
    });
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

  void initializeControllers() {
    qtyController = List.generate(denominationModel.length, (index) {
      return TextEditingController(
        text: denominationModel[index].qty?.toString() ?? "0",
      );
    });

    amounts = List.generate(denominationModel.length, (index) {
      final qty = denominationModel[index].qty?.toDouble() ?? 0.0;
      final noteType = denominationModel[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });

    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);

    isQtyFilled = Map.fromIterable(
      List.generate(denominationModel.length, (index) => index),
      key: (index) => index,
      value: (index) => (denominationModel[index].qty ?? 0) > 0,
    );

    qtyControllerReturn = List.generate(denominationModel.length, (index) {
      return TextEditingController(
        text: denominationModel[index].retNoteQty?.toString() ?? "0",
      );
    });

    amountsReturn = List.generate(denominationModel.length, (index) {
      final qty = denominationModel[index].retNoteQty?.toDouble() ?? 0.0;
      final noteType = denominationModel[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });
    returnAmount = amountsReturn.fold(0.0, (sum, item) => sum + item);
    finalAmountCashDeno = totalAmount - returnAmount;
  }

  Future<void> staffLedgerSettlementAddEditMob(int receiptNo ,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);

    double totalAmt = 0.0;
    String remark;
    int? bankId;
    int? accMappingIds;
    String? tranCode;
    String? tranTime;
    int? vendorId;
    String ledgerIdsString = selectedLedgerIds.join(',');


    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
        "RetNoteQty": qtyControllerReturn[index].text.isNotEmpty ? int.tryParse(qtyControllerReturn[index].text) : 0, // Replace with actual value if available
        "RetNoteAmt":amountsReturn[index], // Replace with actual value if available
      };
    }).toList();


    // Parse amount if not empty
    if (_balanceController.text.isNotEmpty) {
      totalAmt = double.parse(_balanceController.text);
    }

    double totalBalance = double.tryParse(totalBalanceAmt ?? '') ?? 0.0;

    // Validate amount doesn't exceed total
    if(selectedTransMode == "Cash"){
      if(finalAmountCashDeno > 0){
        if (finalAmountCashDeno != totalAmt) {
          showFlushBar(context, "The Receipt amount and cash denomination total must be the same.");
          return;
        }
      }
    }
    if(cashDenominationMandatory){
      if(selectedTransMode == "Cash"){
        if(finalAmountCashDeno > 0){
          if (finalAmountCashDeno != totalAmt) {
            showFlushBar(context, "The Receipt amount and cash denomination total must be the same.");
            return;
          }
        }else{
          showFlushBar(context, Constants.cashDenominationIsMandatory);
          return;
        }
      }
    }
    double? editAmt;
    // Get transaction code
    tranCode = TranCodeController.text.isNotEmpty ? TranCodeController.text : "";

    // Get transaction time
    tranTime = timeController.text.isNotEmpty ? timeController.text : "";
    if(transReviewController.text.isNotEmpty){
      remark = transReviewController.text;
    }else{
      remark = "";
    }


    // Set bank and account mapping IDs
    if (_selectBankModel != null) {
      bankId = selecteBankIDApi;
      accMappingIds = accMappingId;
    } else {
      bankId = 0;
      accMappingIds = 0;
    }

    // Validation checks
    if (selectedTransMode == null || selectedTransMode!.isEmpty) {
      showFlushBar(context, "Please select transaction mode");
      return;
    }

    if (_balanceController.text.isEmpty) {
      showFlushBar(context, "Please enter paid amount");
      return;
    }

    if (selectedTransMode == "Online") {
      if (_selectBankModel == null) {
        showFlushBar(context, "Please select bank");
        return;
      }

      if (TranCodeController.text.isEmpty) {
        showFlushBar(context, "Please enter transaction code");
        return;
      }
    }

 //i want to share ledgerid, if second is there then again ledgerId
    final Map<String, dynamic> requestBody =
    {
      "ReceiptNo":receiptNo,
      "ReceiptFrom":"",
      "ReceiptDate":formattedDate,
      "StaffId":selectedstaffId,
      "Balance":totalBalanceAmt,
      "CustomerId":"",
      "Amount":0,
      "ReceiptMode":selectedTransMode ?? '',
      "TransRemark":remark ?? '',
      "DistributorId": distributorId,
      "RemarkForVendor":"",
      "TransationCode":tranCode ?? '',
      "TransTime": tranTime ?? '',
      "Action":action,
      "AddedBy":userId ?? '',
      "ReceiptAmt":totalAmt,
      "ReceiptRemark":"",
      "BankId":bankId,
      "SettledFrom":category,
      "BankMappingId":accMappingIds ?? '',
      "LedgerIdstr":ledgerIdsString,
      "DenomDetailList":dataCashDenomination,

    };
    print("StaffLedgerAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.StaffLedgerSettlementAddEditMob_V1}'),
      //InventoryStock/PaymentDetailsAdd
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody StaffLedgerAddEdit: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // totalAmount = totalAmount - discountAmt;

        // Process the valid response (JSON or data)
        print("Response StaffLedgerAddEdit: ${response.body}");
        Navigator.pushNamed(
          context,
          TodaysCashSummaryOnAccountList.screenName,
          //'staffId': selectedstaffId,arguments:
          arguments: {
            'staffId': selectedstaffId,
            'staffName': staffName
          },
        );
        debugPrint("totalBalanceAmt: $totalBalanceAmt");


        Future.delayed(Duration(milliseconds: 300), () {
          EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            print("Data is valid, proceeding to save.");
          } else {
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> checkCashDenominationFlagMandatory() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }
        final response = await http.get(
          Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint("Response body GetPageActionPermissionDtls: ${response.body}");
        debugPrint("Request body GetPageActionPermissionDtls: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashDenoMandatoryList = data.map((jsonItem) =>
                CahsDenominationMandatoryFlagModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashDenoMandatoryList) {
              if (item.distributorId.toString() == distributorId && item.permissionFor == "Cash Denomination" && item.isActive == 1) {
                print("Flag truet:");
                cashDenominationMandatory = true;
                break; // Exit loop after finding the match
              }else{
                cashDenominationMandatory = false;
              }
            }
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }
}