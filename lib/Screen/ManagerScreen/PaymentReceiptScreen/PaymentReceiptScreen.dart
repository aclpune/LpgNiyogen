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
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
import '../UpdatePaymentsScreen/GetBalanceByStaffIdModel.dart';
import '../UpdatePaymentsScreen/GetPaymentdetailCashDenominationDtlModel.dart';
import '../UpdatePaymentsScreen/GetStaffDetailsListModel.dart';
import 'GetBankcashReceiptListModel.dart';
import 'GetCashDenominationItemListModel.dart';
import 'GetCustTypeListModel.dart';
import 'GetCustomerListModel.dart';
import 'GetReceiptCashDenominationDtl.dart';

class PaymentReceiptScreen extends StatefulWidget {
  static const screenName = '/paymentreceiptscreen';
  const PaymentReceiptScreen({super.key});

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreen();
}
class _PaymentReceiptScreen extends State<PaymentReceiptScreen>{

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  String? receiptNoText;
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  List<String> getStaff = ["Staff", "Reticulated Or ND", "Other"];
  String? selectedStaffMode = "Staff";
  List<String> getCustomerMode = ["Exempted", "ND", "Other", "POS", "Reticulated"];
  String? selectedCustomerMode;
  bool isCashDenominationListViewVisible = false;
  int _selectedIndex = 0;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  bool isLoading = true;
  List<TextEditingController> qtyController = [];
  List<TextEditingController> qtyControllerReturn = [];
  List<double> amounts = [];
  List<double> amountsReturn = [];
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetCustomerListModel> customerModel = [];
  GetCustomerListModel? selectedCustomer;
  List<GetCustTypeListModel> customerTypeModel = [];
  GetCustTypeListModel? selectedCustomerType;
  List<GetBankcashReceiptListModel> customerListModel = [];
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  int? receiptFromID;
  bool _isDepositEmpty = false;
  bool _isTranscode = false;
  final TranCodeController = TextEditingController();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final customerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final customerEmailController = TextEditingController();
  final amountController = TextEditingController();
  final remarkController = TextEditingController();
  List<GetReceiptCashDenominationDtl> denominationModel = [];
  GetReceiptCashDenominationDtl? _selectDenomination;
  GetStaffDetailsListModel? selectedstaff;
  List<GetStaffDetailsListModel> staffmodel = [];
  String? _selectedItem;
  String? _selectedCustomer;
  int? _selectedCustomerId;
  String? _selectedCustomerType;
  String? _selectedCustomerTypeId;
  int? selectedItemId;
  bool _isCustomerName = false;
  bool _isCustomerEmail = false;
  bool _isConContactEmpty = false;
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  bool _isCustomerEmailInvalid = false;
  String? receiptNoTextEdit;
  FocusNode amountFocusNode = FocusNode();
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  var argValue;
  String? modes;
  int? customerId;
  int? receiptId;
  bool isReticulatedOrNDMode = false;
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  List<GetBalanceByStaffIdModel> balancemodel = [];
  double balanceAmount = 0.0;
  bool isCashDenominationChecked = false;

  @override
  void initState() {
    super.initState();
    checkCashDenominationFlagMandatory();
    checkAndSaveDayEndData();
    getNoteTypeAndIDList();
    fetchBank();
    getStaffDetailsList();
    getReceiptNoForBank();
    getCustTypeList();
    getCustomerList();
    getBankcashReceiptList();

    Future.delayed(Duration.zero, () async {
      // Directly work with arguments and populate fields without setState()
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;

      if (argValue != null) {
        modes = argValue?["modeChange"] ?? '';
        String payVoucherNoEdit = argValue["receiptNoV"] ?? '0';
        receiptNoTextEdit = payVoucherNoEdit;
        String depositDateEdit = argValue["depositDateV"] ?? '0';
        String paymentModeEdit = argValue["paymentModeV"] ?? '0';
        String paymentToIDEdit = argValue["paymentToIDV"] ?? '0';
        String staffNameEdit = argValue["staffNameV"] ?? '0';
        String customerNameEdit = argValue["customerNameV"] ?? '';

        selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;
        _selectedCustomerId = int.tryParse(argValue["customerIdV"] ?? '') ?? 0;

        debugPrint("selectedItemId $selectedItemId");
        debugPrint("_selectedCustomerId $_selectedCustomerId");

        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode = 'Online'; // fallback or handle invalid values
        } else {
          selectedTransMode = null;
        }

        String vehicleNoEdit = argValue["vehicleNoV"] ?? '0';
        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0.0;
        String payRemarkEdit = argValue["payRemarkV"] ?? '0';
        String transTimeEdit = argValue["transTimeV"] ?? '0';
        timeController.text = transTimeEdit;
        String transationCodeEdit = argValue["transationCodeV"] ?? '0';
        TranCodeController.text = transationCodeEdit;
        String transRemarkEdit = argValue["transRemarkV"] ?? '0';
        String remarkEdit = argValue["remarkEditV"] ?? '0';
        transReviewController.text = transRemarkEdit;
        String expHeadNameEdit = argValue["expHeadNameV"] ?? '0';

        amountController.text = amountTotalEdit.toString();
        remarkController.text = remarkEdit;


        // Set account information and bank
        String accountNoEdit = argValue["accountNoV"] ?? '0';
        selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
        accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
        receiptFromID = int.tryParse(argValue["receiptFromIDs"] ?? '') ?? 0;

        // Set the bank model
        _selectBankModel = bankModel.firstWhere(
              (item) => item.accountNo == accountNoEdit,
          orElse: () => GetBankMappingDetailsListModel(
            bankName: 'Default Bank',
            accountNo: '',
          ),
        );

        receiptId = int.tryParse(argValue["receiptIdEdit"] ?? 0);

        loadDenominationData(receiptId!);
        // Handle receipt cash denomination details
        getNoteTypeAndIDList().whenComplete((){
          getReceiptCashDenominationDtl(receiptId!).whenComplete(() {
            if (denominationModel.isNotEmpty) {
              initializeControllers();
            } else {
              debugPrint("Denomination data is empty");
            }
          });
        });

        if (selectedItemId != 0) {
          selectedStaffMode = "Staff";
          await getStaffDetailsList(); // Make sure the list is fetched before accessing
          await getStaffDetailsList(); // Make sure the list is fetched before accessing
          selectedstaff = staffmodel.firstWhere(
                (item) => item.staffId == selectedItemId,
            orElse: () => GetStaffDetailsListModel(staffName: ''),
          );
          debugPrint("Staff selected during edit: ${selectedstaff?.staffId}");
        }else{
          // Set the staff mode and perform customer lookup
          if (receiptFromID == 2) {
            debugPrint("receiptFromID: ${receiptFromID}");
            selectedStaffMode = "Reticulated Or ND";
            await getCustomerList();
            await getCustomerList();
            selectedCustomer = customerModel.firstWhere(
                  (item) => item.customerId == _selectedCustomerId,
              orElse: () => GetCustomerListModel(customerName: ''),
            );
            debugPrint("Customer selected in Reticulated Or ND mode: $selectedCustomer");
          } else if (receiptFromID == 3) {
            debugPrint("receiptFromID2: ${receiptFromID}");
            selectedStaffMode = "Other";
            await getCustomerList();
            await getCustomerList();
            selectedCustomer = customerModel.firstWhere(
                  (item) => item.customerId == _selectedCustomerId,
              orElse: () => GetCustomerListModel(customerName: ''),
            );
            debugPrint("Customer selected in Other mode: $selectedCustomer");
          }
          debugPrint("receiptFromID3: ${receiptFromID}");
        }

        // Handle bank and account details
        fetchBank().then((_) {
          if (accountNoEdit.isNotEmpty && accountNoEdit != "null") {
            final match = bankModel.firstWhere(
                  (item) => item.accountNo?.trim() == accountNoEdit.trim(),
              orElse: () => GetBankMappingDetailsListModel(),
            );

            if ((match.accountNo ?? '').isNotEmpty) {
              setState(() {
                _selectBankModel = match;
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } else {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          }
        },
        child: Scaffold(
        appBar:CustomAppBarManager(
          title: 'Payments Receipt', // Title or hint text for the text field
        ),
        body:  Padding(
          padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
          child: SingleChildScrollView(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar(
                          'Receipt No'),
                    ),
                    Flexible(flex: 1,
                      child:
                      Text(
                        modes == "EDIT" ? (receiptNoTextEdit ?? '') : (receiptNoText ?? ''),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar('Receipt Date'),
                    ),
                    Flexible(flex: 1,
                      child: Text(''
                          "$formattedDate",
                        style: TextStyle(color: Colors.grey),
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
                  CheckboxListTile(
                    title: const Text(
                      "Cash Denomination",
                      style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: isCashDenominationChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isCashDenominationChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                if (selectedTransMode == 'Cash' && isCashDenominationChecked)
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
                                cashDenominationMandatory?"Cash Denomination Is Mandatory":
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
                if (selectedTransMode == 'Cash' && isCashDenominationChecked)
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
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
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
                              ),
                              maxLines: 2, // Allows multiline remarks
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
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
                        'Receipt From',
                        "*", // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        key: formKey2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        //value: selectedStaffMode,
                        value:getStaff.contains(selectedStaffMode) ? selectedStaffMode : null,

                        items: getStaff.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStaffMode = value;  // Updates selectedStaffMode when an item is selected
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                if(selectedStaffMode == 'Staff')...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar(
                            'Staff Name',
                            "*"
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:0.0),
                          child:
                          DropdownButtonFormField<GetStaffDetailsListModel>(
                            isExpanded: true,
                            key: formKey3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            ),
                            value:staffmodel.contains(selectedstaff)?selectedstaff:null ,
                            items: staffmodel.map((item) {
                              return DropdownMenuItem<GetStaffDetailsListModel>(
                                value: item,
                                child: Text(
                                  item.staffName ?? '',
                                  style: Styling.itemBlackTest,
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                selectedstaff = selectedItem;
                                _selectedItem = selectedItem?.staffName ?? '';
                                selectedItemId = selectedItem?.staffId?.toInt();
                                if (selectedItem?.staffId != null) {
                                  getBalanceByStaffId(selectedItem!.staffId.toString());
                                }
                              });

                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar(
                            'Balance'),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          balanceAmount != null && balanceAmount != 0.0 ? balanceAmount.toString() : '0.0',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
                if(selectedStaffMode == 'Reticulated Or ND' || selectedStaffMode == 'Other')...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidgetBlueColorWithStar(
                        'Customer Name',
                        "*",
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _showAddCustomerPopup();
                          });
                        },
                        // onPressed: _addNewItem,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(12),
                            backgroundColor: Colors.blue),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:0.0),
                          child:
                          DropdownButtonFormField<GetCustomerListModel>(
                            isExpanded: true,
                            key: formKey4,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            ),
                            value:customerModel.contains(selectedCustomer)?selectedCustomer:null ,
                            items: customerModel.map((item) {
                              return DropdownMenuItem<GetCustomerListModel>(
                                value: item,
                                child: Text(
                                  item.customerName ?? '',
                                  style: Styling.itemBlackTest,
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                selectedCustomer = selectedItem;
                                _selectedCustomer = selectedItem?.customerName ?? '';
                                _selectedCustomerId = selectedItem?.customerId!.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
                // SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithStar(
                        'Amount',
                        "*",
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                          LengthLimitingTextInputFormatter(9), // Limit to 9 characters total
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isDepositEmpty = value.isEmpty;
                            double val = double.tryParse(value.replaceAll(',', '')) ?? 0;
                            if(selectedStaffMode != 'Reticulated Or ND' && selectedStaffMode != 'Other') {
                              if (selectedTransMode == "Cash") {
                                if (val > balanceAmount) {
                                  amountController.clear();
                                }
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Amount',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar(
                          'Remark'
                      ),
                    ),
                    Flexible(flex: 1,
                      child:
                      TextField(
                        controller: remarkController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter your remarks',
                          // border: OutlineInputBorder(),
                        ),
                        maxLines: 2, // Allows multiline remarks

                      ),
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

                    SizedBox(width: 10), // Adds space between buttons

                    ElevatedButton(
                      onPressed: () {
                        if (saveFlag) {
                          print('saveFlag $saveFlag');
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (modes == "EDIT") {
                            customerAddEditForMob(receiptId!, "EDIT");
                          } else {
                            customerAddEditForMob(0, "ADD");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:saveFlag?Colors.grey:Colors.blue,
                        //backgroundColor: modes == "EDIT" ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10, // Adjust padding to make button smaller
                        ),
                      ),
                      child: Text(
                        modes == "EDIT" ? 'Update' : 'Save',
                        // 'Save',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Card(
                  child: customerListModel.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: customerListModel.length,
                    itemBuilder: (context, index) {
                      GetBankcashReceiptListModel? payList = customerListModel[index];
                      return  Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(child: Text(payList.receiptDate ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(child: Text(payList.receiptNo ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(
                                flex: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                  children: [
                                    // Edit Icon
                                    IconButton(
                                      icon: Icon(Icons.edit, color:saveFlag?Colors.blueGrey:Colors.blue),  // Icon for edit
                                      onPressed: () {
                                        setState(() {
                                          loadDenominationData(payList.receiptId!.toInt());
                                          var payVoucherNo = payList.receiptNo.toString();
                                          var depositDate = payList.receiptDate.toString();
                                          var paymentMode = payList.receiptMode.toString();
                                          var paymentToId = payList.receiptFrom.toString();
                                          var staffName = payList.staffName.toString();
                                          var staffId = payList.staffId.toString();
                                          var customerId = payList.customerId.toString();
                                          var customerName = payList.vendorName.toString();
                                          var amountTotal = payList.amount.toString();
                                          var payRemark = payList.remarkForVendor.toString();
                                          var transTime = payList.transTime.toString();
                                          var transationCode = payList.transationCode.toString();
                                          var transRemark = payList.transRemark.toString();
                                          var bankId = payList.bankId.toString();
                                          var mappingId = payList.mappingId.toString();
                                          var accountNo = payList.accountNo.toString();
                                          var receiptId = payList.receiptId.toString();
                                          var receiptFromID = payList.receiptFrom.toString();
                                          int payId = int.parse(receiptId);
                                          if (saveFlag) {
                                            print('saveFlag $saveFlag');
                                            showFlushBar(context, Constants.dayEndCompleted);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              PaymentReceiptScreen.screenName,
                                              arguments: {

                                                'receiptNoV': payVoucherNo,
                                                'depositDateV': depositDate,
                                                'paymentModeV': paymentMode,
                                                'paymentToIDV': paymentToId,
                                                'staffNameV' : staffName,
                                                'customerIdV' : customerId,
                                                'customerNameV' : customerName,
                                                'staffIdV': staffId,
                                                'remarkEditV': payRemark,
                                                'amountTotalV': amountTotal,
                                                'payRemarkV': payRemark,
                                                'transTimeV': transTime,
                                                'transationCodeV': transationCode,
                                                'transRemarkV': transRemark,
                                                'bankIdV': bankId,
                                                'mappingIdV': mappingId,
                                                'accountNoV': accountNo,
                                                'receiptIdEdit': receiptId,
                                                'receiptFromIDs': receiptFromID,
                                                'modeChange': "EDIT"
                                              },
                                            );
                                          }

                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color:saveFlag?Colors.redAccent:Colors.red), // Icon for delete
                                      onPressed: () async {
                                        if (saveFlag) {
                                          print('saveFlag $saveFlag');
                                          showFlushBar(context, Constants.dayEndCompleted);
                                        } else {
                                          int? pId = (payList.receiptId)?.toInt();
                                          print('Delete button pressedd${payList.receiptId}');
                                          // Show confirmation dialog
                                          bool? confirmDelete = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Are you sure?'),
                                                content: const Text('You want to delete?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(false); // User pressed Cancel
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true); // User pressed Delete
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          // If user confirmed deletion
                                          if (confirmDelete == true) {
                                            // Check if receiptId is not null
                                            // int? pId = payList.receiptId;
                                            if (pId != null) {
                                              selectedItemId  = payList.staffId?.toInt()?? 0;
                                              _selectedCustomerId  = payList.customerId?.toInt()?? 0;
                                              customerAddEditForMob(pId, "DELETE");
                                              print('Delete button pressed$pId');
                                            } else {
                                              print("Receipt ID is null.");
                                            }
                                          } else {
                                            print('Delete action was canceled');
                                          }
                                        }

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Staff/Vendor Name", payList.staffName ?? '')),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context, "Receipt Mode", (payList.receiptMode == 'Bank') ? 'Online' : (payList.receiptMode ?? ''))),

                              Expanded(flex:1,child: countTextWidgetText(context,"Amount", payList.amount.toString()  )),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Account No", payList.accountNo ?? '')),
                            ],
                          ),
                          Divider(
                              color: Colors.white70, thickness: 3
                          ),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: Text('No Records Found'),
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
      );
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
            // totalAmountCashDenomination = totalAmount;
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

  Future<void> getReceiptCashDenominationDtl(int ReceiptId) async {
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
      Uri.parse('${AppUrl.GetReceiptCashDenominationDtl}/$ReceiptId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetReceiptCashDenominationDtl : " +
        '${AppUrl.GetReceiptCashDenominationDtl}/$ReceiptId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetReceiptCashDenominationDtl : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetReceiptCashDenominationDtl.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> loadDenominationData(int psvID) async {
    await getReceiptCashDenominationDtl(psvID.toInt());

    // Now call initializeControllers after list is fetched
    initializeControllers();

    // Refresh UI
    setState(() {});
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

  Future<void> getStaffDetailsList() async {
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
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsList : " +
        '${AppUrl.GetStaffDetailsList}/$distributorId/1/0');
    debugPrint("GetStaffDetailsList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        staffmodel = data.map((json) {
          return GetStaffDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  void _showAddCustomerPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Add Vendor Name"),
              content: SingleChildScrollView(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left:0.0),
                        child:
                        DropdownButtonFormField<GetCustTypeListModel>(
                          isExpanded: true,
                          key: formKey5,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                          value:customerTypeModel.contains(selectedCustomerType)?selectedCustomerType:null ,
                          items: customerTypeModel.map((item) {
                            return DropdownMenuItem<GetCustTypeListModel>(
                              value: item,
                              child: Text(
                                item.customerType ?? '',
                                style: Styling.itemBlackTest,
                              ),
                            );
                          }).toList(),
                          onChanged: (selectedItem) {
                            setState(() {
                              selectedCustomerType = selectedItem;
                              _selectedCustomerType = selectedItem?.customerType ?? '';
                              _selectedCustomerTypeId = selectedItem?.custTypeId?.toString();
                            });
                          },
                          hint: Text('Customer Type'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: customerNameController,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                      inputFormatters: <TextInputFormatter>[
                      ],
                      decoration: InputDecoration(
                        errorText: _isCustomerName ? 'Customer Name Is Required' : null,

                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Customer Name',
                              showAsterisk: true,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isCustomerName = value.isEmpty;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: mobileNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        errorText: _isConContactEmpty
                            ? 'Mobile No Is Required'
                            : _isInvalidMobile
                            ? 'Please Enter A Valid Consumer Contact No.'
                            : _isShortLength
                            ? 'Consumer Contact No. must be 10 digits'
                            : null,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Customer Contact No',
                              showAsterisk: true,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isConContactEmpty = value.isEmpty;
                          if (value.isNotEmpty) {
                            _isInvalidMobile = !RegExp(r'^[6789]').hasMatch(value); // Check first digit
                            _isShortLength = value.length < 10;
                          } else {
                            _isInvalidMobile = false; // Reset the error if the input is empty
                            _isShortLength = false;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: customerEmailController,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: <TextInputFormatter>[],
                      decoration: InputDecoration(
                        errorText: _isCustomerEmailInvalid ? 'Enter a valid email address' : null,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Customer Email',
                              showAsterisk: true,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isCustomerEmailInvalid = value.isEmpty || !_isValidEmail(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    customerNameController.clear();
                    mobileNumberController.clear();
                    customerEmailController.clear();
                    selectedCustomerType = null;
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String customerName = customerNameController.text.trim();
                    String mobileNumber = mobileNumberController.text.trim();
                    String customerEmail = customerEmailController.text.trim();

                    // Check if the mobile number is valid
                    if (_isConContactEmpty || _isInvalidMobile || _isShortLength) {
                      showFlushBar(context, "Invalid mobile number.");
                      return;
                    }

                    // Check if both fields are empty
                    if (customerName.isEmpty || mobileNumber.isEmpty || customerEmail.isEmpty) {
                      showFlushBar(context, "All fields are required.");
                      return;
                    }

                    // Proceed with saving
                    saveCustomerPopupForMob(0);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> getReceiptNoForBank() async {
    EasyLoading.show();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Bearer token is missing');
      }
      debugPrint('mnhfgjfjf');
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetReceiptNoForBank}/$distributorId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      if (response.statusCode == 200) {
        // Assuming response.body is the string you want to set.
        String receiptNo = response.body;
        debugPrint('receiptNo$receiptNo');// Remove any leading/trailing spaces
        receiptNo = receiptNo.replaceAll('"', '');
        setState(() {
          receiptNoText = receiptNo;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error: $e');
    }
  }

  Future<void> getCustomerList() async {
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
      Uri.parse('${AppUrl.GetCustomerList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetCustomerListModel : " +
        '${AppUrl.GetCustomerList}/$distributorId/1');
    debugPrint("GetCustomerList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        customerModel = data.map((json) {
          return GetCustomerListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getCustTypeList() async {
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
      Uri.parse('${AppUrl.GetCustTypeList}/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetCustTypeList : " +
        '${AppUrl.GetCustTypeList}/0');
    debugPrint("GetCustTypeList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        customerTypeModel = data.map((json) {
          return GetCustTypeListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> saveCustomerPopupForMob(int customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    String? customerEmail = customerEmailController.text;
    if(customerEmailController.text.isNotEmpty){
      customerEmail = customerEmailController.text;
    }

    String? customerMobNo = mobileNumberController.text;
    if(mobileNumberController.text.isNotEmpty){
      customerMobNo = mobileNumberController.text;
    }
    String? customerName = customerNameController.text;
    if(customerNameController.text.isNotEmpty){
      customerName = customerNameController.text;
    }

    if (_selectedCustomerTypeId == null || _selectedCustomerTypeId!.isEmpty) {
      showFlushBar(context, Constants.selectConsumerTypeMode);
      return;
    }
    final Map<String, dynamic> requestBody = {
      "CustomerId":customerId,
      "DistributorId":distributorId,
      "CustTypeId":_selectedCustomerTypeId,
      "CustomerName":customerName,
      "ContactNo":customerMobNo,
      "CustomerEmail":customerEmail,
      "CustomerGSTNo":"",
      "CustAddress":"",
      "SVQty":0,
      "IsActive":1,
      "IsAlertMessage":0,
      "AlertInterval":"",
      "AddedBy":userId,
      "Action":"ADD"
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.AddEditCustomer}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody AddEditCustomer: ${response.statusCode} - ${response.request}${requestBody}");

    // Handling response
    if (response.statusCode == 200) {
      // Successful response
      print("Response AddEditCustomer: ${response.body}");

      Navigator.pushNamed(
        context,
        BottomNavBarExample.screenName,
        arguments: 3, // This opens the third tab
      );
      EasyLoading.showToast(Constants.expenseSendMgr,
          duration: const Duration(milliseconds: 3000));
      setState(() {
        getCustomerList();
      });
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> getBankcashReceiptList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankcashReceiptList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankcashReceiptList : " + '${AppUrl.GetBankcashReceiptList}/$distributorId');
    debugPrint("GetBankcashReceiptList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        customerListModel = data.map((json) => GetBankcashReceiptListModel.fromJson(json)).toList();
        // EasyLoading.dismiss();
        isLoading = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> customerAddEditForMob(int ReceiptId,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    //String? paymentId = prefs.getString("PaymentId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int? receiptFrom;
    String? tranCode;
    String? tranTime;
    String? tranReview;
    String? remark;
    int? paidTo;
    int? bankId;
    int? accMappingIds;
    double amtController = 0.0;
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
    if(action != "DELETE"){
      if(amountController.text.isNotEmpty){
        amtController = double.parse(amountController.text);
      }

      if(TranCodeController.text.isNotEmpty){
        tranCode = TranCodeController.text;
      }else{
        tranCode = "";
      }
      if(timeController.text.isNotEmpty){
        tranTime = timeController.text;
      }else{
        tranTime = "";
      }
      if(transReviewController.text.isNotEmpty){
        tranReview = transReviewController.text;
      }else{
        tranReview = "";
      }
      if(remarkController.text.isNotEmpty){
        remark = remarkController.text;
      }else{
        remark = "";
      }

      if (selectedTransMode == null || selectedTransMode!.isEmpty

      )  {
        showFlushBar(context, Constants.reqfield);
        return;
      }

      if (selectedTransMode == null || selectedTransMode!.isEmpty)
      {
        showFlushBar(context, Constants.TransMode);
        return;
      }

      if (!amountController.text.isNotEmpty) {
        showFlushBar(context, Constants.salaryAmt);
        return;
      }

      if (selectedStaffMode == null || selectedStaffMode!.isEmpty) {
        showFlushBar(context, Constants.selStaff);
        return;
      }

      if (selectedStaffMode == 'Staff') {
        if (selectedstaff == null || selectedstaff!.staffName == null || selectedstaff!.staffName!.isEmpty) {
          showFlushBar(context, 'Item selection is mandatory for Staff.');
          return;
        }
      }

      // Check if selectedStaffMode is 'Reticulated', 'ND', or 'Other' and _selectedCustomer is mandatory
      if (['Reticulated Or ND', 'Other'].contains(selectedStaffMode)) {
        if (_selectedCustomerId == null) {
          showFlushBar(context, 'Customer selection is mandatory for the selected mode.');
          return;
        }
      }


      if (selectedTransMode == 'Online') {

        if (_selectBankModel == null || _selectBankModel!.accountNo == null ||
            _selectBankModel!.accountNo!.isEmpty
        ) {
          showFlushBar(context, Constants.bankname);
          return;
        }

        if (!TranCodeController.text.isNotEmpty) {
          showFlushBar(context, Constants.transCode);
          return;
        }
      }

      // Conditional check for cash payment mode
      if (selectedTransMode == 'Cash'){
        if(finalAmountCashDeno != null || finalAmountCashDeno>0){
          if(amtController != finalAmountCashDeno || amtController <= 0) {
            showFlushBar(context, Constants.denominationAmount);
            return;
          }
        }
      }
      if (selectedTransMode == 'Cash'){
        if(cashDenominationMandatory){
          if(finalAmountCashDeno != null || finalAmountCashDeno>0){
            if(amtController != finalAmountCashDeno || amtController <= 0) {
              showFlushBar(context, Constants.denominationAmount);
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }


      // if (selectedTransMode == 'Cash') {
      //   if (cashDenominationMandatory) {
      //
      //     double amount = amtController;
      //
      //     if (amount > 0) {
      //
      //       if (finalAmountCashDeno == null || finalAmountCashDeno <= 0) {
      //         showFlushBar(context, Constants.cashDenominationIsMandatory);
      //         return;
      //       }
      //
      //       if (amount != finalAmountCashDeno) {
      //         showFlushBar(context, Constants.denominationAmount);
      //         return;
      //       }
      //
      //     }
      //
      //   }
      // }

      if(selectedStaffMode == "Staff"){
        receiptFrom = 1;
        _selectedCustomerId = 0;
      }else if(selectedStaffMode == "Reticulated Or ND"){
        receiptFrom = 2 ;
        selectedItemId = 0;
      }else if(selectedStaffMode == "Other"){
        receiptFrom = 3 ;
        selectedItemId = 0;
      }

      if(_selectBankModel != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      }
      else{
        bankId = 0;
        accMappingIds = 0;
      }

    }


    final Map<String, dynamic> requestBody =
    {
      "ReceiptId": ReceiptId,
      "DistributorId": distributorId,
      "ReceiptDate":formattedDate,
      "ReceiptMode": selectedTransMode ?? '',
      "ReceiptFrom":receiptFrom ?? '',
      "StaffId": selectedItemId ?? 0,
      "Balance": balanceAmount,
      "CustomerId":_selectedCustomerId ?? 0,
      "Amount": amtController ?? '',
      "RemarkForVendor": remark ?? '',
      "TransationCode":tranCode ?? '',
      "TransTime":tranTime ?? '',
      "TransRemark":tranReview ?? '',
      "BankMappingId":accMappingIds ?? '',
      "BankId":bankId ?? '',
      "AddedBy": userId ?? '',
      "Action": action,
      "DenomDetailList":dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.BankCashReceiptAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody BankCashReceiptAddEdit: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // Process the valid response (JSON or data)
        print("Response BankCashReceiptAddEdit: ${response.body}");
        Navigator.pushNamed(
          context,
          PaymentReceiptScreen.screenName,
          //arguments: 3, // This opens the third tab
        );

        Future.delayed(Duration(milliseconds: 300), () {
          if (action == "DELETE") {
            EasyLoading.showToast(
              Constants.expenseSendMgrDelete,
              duration: const Duration(milliseconds: 3000),
            );
          } else if(action == "EDIT") {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          }else {
            EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
          }
        });
        setState(() {
          getBankcashReceiptList();
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }
  void cancelAction(){
    setState(() {
      _selectedItem = '';
      selectedBankName = '';
      totalAmount = 0.0;
      selectedTransMode = null;
      selectedBankId = null;
      selectedTransMode = null;
      selectedstaff = null;
      selectedItemId = null;
      _selectBankModel = null;
      selectedTransMode = null;
      selectedCustomerType = null;
      TranCodeController.clear();
      timeController.clear();
      remarkController.clear();
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      amountController.clear();
      modes = "Save";
      Navigator.pushNamed(
          context,
          PaymentReceiptScreen.screenName// This opens the third tab
      );
    });
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
          saveFlag = true;
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   print("Data is valid, proceeding to save.");
          // } else {
          //   print("Data is incomplete. Cannot proceed to save.");
          // }
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
  Future<void> getBalanceByStaffId(String staffId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetBalanceByStaffId}/$staffId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    debugPrint("Response body GetBalanceByStaffId: ${response.body}");
    debugPrint("Request body GetBalanceByStaffId: ${response.request}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        balancemodel = data.map((json) => GetBalanceByStaffIdModel.fromJson(json)).toList();
        // balanceAmount = balancemodel.isNotEmpty ? balancemodel.first.balanceAmt.toString() : '';
        //balanceAmount = balancemodel.isNotEmpty ? balancemodel.first.balanceAmt : 0.0;
        balanceAmount = (balancemodel.isNotEmpty && balancemodel.first.balanceAmt != null)
            ? balancemodel.first.balanceAmt!.toDouble()  // force unwrap to double
            : 0.0;
        EasyLoading.dismiss();
        debugPrint("GetBalanceByStaffId: $balanceAmount");
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load balance');
    }
  }
}