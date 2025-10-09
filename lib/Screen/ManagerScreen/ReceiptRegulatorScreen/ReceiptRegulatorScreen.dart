
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
import '../SVSaleModel/GetStaffDetailsListModel.dart';
import 'GetItemMasterListRegulatorListModel.dart';
import 'GetRegDefReceiptDenominationDtlModel.dart';
import 'GetRegDefReceiptDetailsModel.dart';

class ReceiptRegulatorScreen extends StatefulWidget {
  static const screenName = '/receiptRegulatorScreen';
  const ReceiptRegulatorScreen({super.key});

  @override
  State<ReceiptRegulatorScreen> createState() => _ReceiptRegulatorScreenState();
}

class _ReceiptRegulatorScreenState extends State<ReceiptRegulatorScreen>{
  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  GetStaffDetailsListModel? selectedStaff;
  List<GetItemMasterListRegulatorListModel> itemDetailModel = [];
  GetItemMasterListRegulatorListModel? selectedRegulatorItemReceived;
  int? selectedReferredID;
  String? selectedReferredName;
  int? selectedItemId;
  String? selectedItemName;
  String? selectedTransMode;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  bool isLoading = true;
  bool saveFlag = false;
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<double> amounts = [];
  List<double> amountsReturn = [];
  var argValue;
  String? modes;
  int? regRcptIdEdit;
  String? paymentAmountV;
  String? editPaymentMode;
  bool cashDenominationMandatory = false;
  List<String> regulatorReceived = ["Yes", "No"];
  String? selectedRegulatorReceived;
  List<String> getTransMode = ["Cash", "Online"];
  GetBankMappingDetailsListModel? _selectBankModel;
  final _formKeyConsumerNo = GlobalKey<FormState>();
  final _formKeyPaymentAmt = GlobalKey<FormState>();
  final _formKeyTranCode = GlobalKey<FormState>();
  final _formKeyItemName = GlobalKey<FormState>();
  final _formKeyConsumerName = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final TextEditingController _consumerNoController = TextEditingController();
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _defectiveItemController = TextEditingController();
  final TextEditingController _paymentRemarkController = TextEditingController();
  final TextEditingController _paymentAmtController = TextEditingController();
  final TextEditingController _transactionCodeController = TextEditingController();
  final TextEditingController _transactionTimeController = TextEditingController();
  final TextEditingController _transactionRemarkController = TextEditingController();
  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<GetBankMappingDetailsListModel> bankModel = [];
  List<TextEditingController> qtyControllerReturn = [];
  List<GetRegDefReceiptDetailsModel> receiptDefList = [];
  List<DenomModel> getNoteTypeAndIdFroDenominationListModel = [];
  List<GetRegDefReceiptDenominationDtlModel> getDenominationLis = [];
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    getStaffDetailsList();
    fetchBank();
    getNoteTypeAndIDList();
    checkCashDenominationFlagMandatory();
    GetItemMasterListRegulatorList();
    fetchReceiptDefRegulator();

    Future.delayed(Duration.zero, () async {
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';
      if (argValue != null) {
        regRcptIdEdit = int.tryParse(argValue["regRcpIdV"] ?? 0);
        String regRcpDateEdit = argValue["regRcpDateV"] ?? 0;
        String staffIdV = argValue["staffIdV"] ?? 0;
        String staffNameV = argValue["staffNameV"] ?? 0;
        String consumerNumberV = argValue["consumerNumberV"] ?? 0;
        String consumerNameV = argValue["consumerNameV"] ?? 0;
        String itemIdV = argValue["itemIdV"] ?? 0;
        String itemNameV = argValue["itemNameV"] ?? 0;
        String regDefQtyV = argValue["regDefQtyV"] ?? 0;
        String replacementRechagebleV = argValue["replacementRechargebleV"] ?? 0;
        paymentAmountV = argValue["paymentAmountV"] ?? 0;
        String paymentModeEdit = argValue["paymentModeV"] ?? 0;
        String bankIdV = argValue["bankIdV"] ?? 0;
        String bankMappingIdV = argValue["bankMappingIdV"] ?? 0;
        String transactionCodeV = argValue["transactionCodeV"] ?? 0;
        String transactionTimeV = argValue["transactionTimeV"] ?? 0;
        String transactionRemarkV = argValue["transactionRemarkV"] ?? 0;
        String addedByV = argValue["addedByV"] ?? 0;
        String actionV = argValue["actionV"] ?? 0;
        String remarkV = argValue["remarkV"] ?? 0;
        editPaymentMode = paymentModeEdit;
        _consumerNoController.text = consumerNumberV;
        _consumerNameController.text = consumerNameV;
        _defectiveItemController.text = regDefQtyV;
        _paymentAmtController.text = paymentAmountV!;
        _paymentRemarkController.text = remarkV;
        _transactionRemarkController.text = transactionRemarkV;
        _transactionTimeController.text = transactionTimeV;
        _transactionCodeController.text = transactionCodeV;

        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode = 'Online'; // fallback or handle invalid values
        } else {
          selectedTransMode = null;
        }

        await getStaffDetailsList();
        getStaffDetailsList().whenComplete(() {
          debugPrint("referredByNameEdit:$staffNameV");
          if (staffNameV != "null" &&
              staffNameV.isNotEmpty &&
              staffNameV != null) {
            setState(() {
              selectedStaff = staffdetailsmodel.firstWhere(
                    (item) => item.staffName == staffNameV,
                orElse: () => GetStaffDetailsListModel(staffName: ''),
              );
              selectedReferredID = int.parse(staffIdV);
              selectedReferredName = staffNameV;
            });
          }
        });

        await GetItemMasterListRegulatorList();
        GetItemMasterListRegulatorList().whenComplete(() {
          debugPrint("referredByNameEdit:$itemNameV");
          if (itemNameV != "null" &&
              itemNameV.isNotEmpty &&
              itemNameV != null) {
            setState(() {
              selectedRegulatorItemReceived = itemDetailModel.firstWhere(
                    (item) => item.itemName == itemNameV,
                orElse: () => GetItemMasterListRegulatorListModel(itemName: ''),
              );
              selectedItemId = int.parse(itemIdV);
              selectedItemName = itemNameV;
            });
          }
        });

        await fetchBank();
        if (bankIdV != null &&
            bankIdV is String &&
            bankIdV.isNotEmpty &&
            bankIdV != "null") {
          final match = bankModel.firstWhere(
                (item) => item.bankId?.toString().trim() == bankIdV.trim(),
            orElse: () =>
                GetBankMappingDetailsListModel(),
          );

          if ((match.bankId?.toString() ?? '').isNotEmpty) {
            setState(() {
              _selectBankModel = match;
              selectedBankName = match.bankName;
              selectedBankId = match.accountNo;
              selecteBankIDApi = match.bankId?.toInt();
              accMappingId = match.mappingId?.toInt();
            });
          }
        }

        if (replacementRechagebleV == "1" && regulatorReceived.contains("Yes")) {
          selectedRegulatorReceived = "Yes";
        } else if (replacementRechagebleV == "0" && regulatorReceived.contains("No")) {
          selectedRegulatorReceived = "No";
        } else {
          selectedRegulatorReceived = '';
        }
        print('selectedRegulatorReceived: $selectedRegulatorReceived');

        int ReplacementCharge = (selectedRegulatorReceived == 'Yes') ? 1 : 0;

        print("ReplacementCharge: $ReplacementCharge");

        loadDenominationData(regRcptIdEdit!);

        if (getDenominationLis.isNotEmpty) {
          initializeControllers();
        } else {
          debugPrint("empty");
        }
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
            title: 'Receipt Defective Regulator', // Title or hint text for the text field
          ),
            body:
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5, top: 15, bottom: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithoutStar('Date')),
                          Flexible(flex: 1, child: Text("$formattedDate",
                            style: TextStyle(fontSize: 13),)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithoutStar('Referred By')),
                          Flexible(
                            flex: 1,
                            child:
                            DropdownButtonFormField<GetStaffDetailsListModel>(
                              key: formKey1,
                              value: staffdetailsmodel.contains(selectedStaff)
                                  ? selectedStaff
                                  : null,
                              items: staffdetailsmodel
                                  .map((GetStaffDetailsListModel staff) {
                                return DropdownMenuItem<GetStaffDetailsListModel>(
                                  value: staff,
                                  child: Text(staff.staffName ?? '',
                                      style: TextStyle(fontSize: 12),), // Use a default if null
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedStaff = value;
                                  selectedReferredID = value?.staffId!
                                      .toInt();
                                  selectedReferredName = value?.staffName!
                                      .toString();
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child:
                              textWidgetBlueColorWithStar("Consumer No.", "*")),
                          Flexible(
                            flex: 1,
                            child:
                            Form(
                              key: _formKeyConsumerNo,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _consumerNoController,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      label: countTextWidgetTextStarverysmall(
                                        context,
                                        'Enter Consumer No.',
                                        showAsterisk: true,
                                      ),
                                    ),
                                    style: Styling.textFormText,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Consumer No. is Required';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      _formKeyConsumerNo.currentState!
                                          .validate();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithStar(
                                  "Consumer Name", "*")),
                          Flexible(
                            flex: 1,
                            child: Form(
                              key: _formKeyConsumerName,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _consumerNameController,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    decoration: buildInputBorderUpdateStatusMgr(
                                        "Enter Consumer Name", context),
                                    style: Styling.textFormText,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Consumer Name is Required';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      _formKeyConsumerName.currentState!
                                          .validate();
                                    },
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithStar(
                                  "Select Item Name", "*")),
                          Flexible(
                            flex: 1,
                            child:
                            DropdownButtonFormField<GetItemMasterListRegulatorListModel>(
                              key: formKey2,
                              value: itemDetailModel.isNotEmpty && itemDetailModel.first.itemName != null && itemDetailModel.first.itemId != null
                                  ? itemDetailModel.first
                                  : null,
                              items: itemDetailModel.map((GetItemMasterListRegulatorListModel item) {
                                return DropdownMenuItem<GetItemMasterListRegulatorListModel>(
                                  value: item,
                                  child: Text(item.itemName ?? 'Unknown',
                                  style: TextStyle(fontSize: 12),),
                                );
                              }).toList(),
                              onChanged: (value) {
                                print("Selected value: $value");
                                setState(() {
                                  if (value != null) {
                                    selectedRegulatorItemReceived = value;
                                    selectedItemId = value.itemId?.toInt() ?? -1;
                                    selectedItemName = value.itemName ?? 'Unknown';
                                  } else {
                                    selectedItemId = null;
                                    selectedItemName = null;
                                  }
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithStar(
                                  "Regulator Defective Qty.", "*")),
                          Flexible(
                            flex: 1,
                            child:
                            Form(
                              key: _formKeyItemName,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _defectiveItemController,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      label: countTextWidgetTextStarverysmall(
                                        context,
                                        'Regulator Defective Qty.',
                                        showAsterisk: true,
                                      ),
                                    ),
                                    style: Styling.textFormText,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Regulator Defective Qty. is Required';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      _formKeyItemName.currentState!
                                          .validate(); // Validate on field submit
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: textWidgetBlueColorWithStar(
                                  "Replacement Chargeable", "*")),
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              key: formKey3,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                              ),
                              value: regulatorReceived.contains(selectedRegulatorReceived)
                                  ? selectedRegulatorReceived
                                  : null,
                              items: regulatorReceived
                                  .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                  style: TextStyle(fontSize: 13),),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRegulatorReceived =
                                      value; // Update the selected value
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                  if (selectedRegulatorReceived == "Yes") ...[
                    Row(
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar(
                                "Payment Amt.", "*")),
                        Flexible(
                          flex: 1,
                          child: Form(
                            key: _formKeyPaymentAmt,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _paymentAmtController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  //enabled: modes != "Edit",
                                  decoration: InputDecoration(
                                    label: countTextWidgetTextStarverysmall(
                                      context,
                                      'Enter Payment Amt.',
                                      showAsterisk: true,
                                    ),
                                  ),
                                  style: Styling.textFormText,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Amount is required';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    _formKeyPaymentAmt.currentState!
                                        .validate(); //  Validate on field submit
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar(
                                "Payment Mode", "*")),
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            key: formKey4,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                            ),
                            value: selectedTransMode,
                            // Bind the selected value
                            items: getTransMode
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                        style: TextStyle(fontSize: 13),),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTransMode =
                                    value; // Update the selected value
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                    if (selectedTransMode == 'Online')
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: textWidgetBlueColorWithStar(
                                      "Select Bank Account No.", "*")),
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField<
                                    GetBankMappingDetailsListModel>(
                                  isExpanded: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                    label: countTextWidgetTextStarverysmall(
                                      context,
                                      'Select Acc No',
                                      showAsterisk:
                                          true, // Add a parameter to conditionally show the asterisk
                                    ),
                                  ),
                                  value: bankModel.contains(_selectBankModel)
                                      ? _selectBankModel
                                      : null,

                                  items: bankModel.map((item) {
                                    return DropdownMenuItem<
                                        GetBankMappingDetailsListModel>(
                                      value: item,
                                      child: Text(
                                        '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                                        style: TextStyle(fontSize: 12),),
                                    );
                                  }).toList(),

                                  onChanged: (selectedItem) {
                                    setState(() {
                                      _selectBankModel = selectedItem;
                                      selectedBankName = selectedItem?.bankName;
                                      selectedBankId = selectedItem?.accountNo;
                                      selecteBankIDApi =
                                          selectedItem?.bankId?.toInt();
                                      accMappingId =
                                          selectedItem?.mappingId?.toInt();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: textWidgetBlueColorWithStar(
                                      "Transaction Code", "*")),
                              Flexible(
                                flex: 1,
                                child: Form(
                                  key: _formKeyTranCode,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _transactionCodeController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration:
                                            buildInputBorderUpdateStatusMgr(
                                                "Enter Transaction Code",
                                                context),
                                        style: Styling.textFormText,
                                        // Set keyboard type to numeric
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(30),
                                          // Limit to 30 characters
                                          FilteringTextInputFormatter.deny(
                                            RegExp(
                                                r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                                          ),
                                          FilteringTextInputFormatter.deny(
                                            RegExp(
                                                r'\s'), // Block all whitespace including space, tab, etc.
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Transaction Code Required';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          _formKeyTranCode.currentState!
                                              .validate(); // 👈 Validate on field submit
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child:
                                      textWidgetBlueColorWithoutStar("Time")),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _transactionTimeController,
                                  decoration: buildInputBorderUpdateStatusMgr(
                                      "Enter Time", context),
                                  style: Styling.textFormText,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                    LengthLimitingTextInputFormatter(5),
                                  ],
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
                                  child: textWidgetBlueColorWithoutStar(
                                      "Transaction Remark")),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _transactionRemarkController,
                                  decoration: buildInputBorderUpdateStatusMgr(
                                      "Enter Tran. Remark", context),
                                  style: Styling.textFormText,
                                  // Set keyboard type to numeric
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(250),
                                    // Limit to 250 characters
                                  ],
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (selectedTransMode == 'Cash')
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cashDenominationMandatory
                                      ? "Cash Denomination Is Mandatory"
                                      : "Cash denomination",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              // Background color of the box
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1), // Optional: Add rounded corners
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  "X",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                child: TextField(
                                                  controller:
                                                      qtyController[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    // Allow only digits
                                                    LengthLimitingTextInputFormatter(3),
                                                    // Limit input to 3 digits only
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      amounts[index] =
                                                          (double.tryParse(
                                                                      value) ??
                                                                  0.0) *
                                                              data.noteType!;

                                                      // Recalculate totalAmount
                                                      totalAmount =
                                                          amounts.fold(
                                                              0.0,
                                                              (sum, amount) =>
                                                                  sum + amount);
                                                      debugPrint(
                                                          "totalAmount: $totalAmount");

                                                      // Parse the balance input
                                                      final valueBal =
                                                          double.tryParse(
                                                              _paymentAmtController
                                                                  .text);

                                                      // Validate the balance
                                                      if (valueBal == null) {
                                                        // Handle invalid input
                                                        showFlushBar(
                                                            context,
                                                            Constants
                                                                .cashAmount);
                                                      } else if (valueBal <
                                                          totalAmount) {
                                                        // Handle insufficient balance
                                                        showFlushBar(
                                                            context,
                                                            Constants
                                                                .amountEqual);
                                                      }
                                                    });
                                                  },
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  "=",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                child: Text(
                                                  "${amounts[index].toStringAsFixed(2)}",
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          flex: 0,
                                          child: Text("Amount : ",
                                              style: Styling.itemBlackTestBold,
                                              textAlign: TextAlign.left)),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          totalAmount.toStringAsFixed(2),
                                          style: Styling.itemBlackTestBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //),
                        ],
                      ),
                    ],
                    Row(
                        children: [
                          Expanded(child: textWidgetBlueColorWithoutStar("Remark")),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _paymentRemarkController,
                              decoration: buildInputBorderUpdateStatusMgr(
                                  "Enter Remark", context),
                              style: Styling.textFormText,
                              // Set keyboard type to numeric
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250),
                              ],
                              onChanged: (value) {
                                setState(() {
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical:
                                  10), // Adjust padding to make button smaller
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
                                if (modes == "Edit") {
                                  getRegulatorReceiptAddEdit(regRcptIdEdit!, "EDIT");
                                } else {
                                  getRegulatorReceiptAddEdit(0, "ADD");
                                }
                             }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical:
                                  10),
                            ),
                            child: Text(
                             modes == "Edit" ? 'Update' : 'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Card(
                        child: receiptDefList.isNotEmpty
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: receiptDefList.length,
                          itemBuilder: (context, index) {
                            GetRegDefReceiptDetailsModel? tvSale = receiptDefList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  tvSale.regDefRcptDate ?? '')),
                                          style: Styling.blueClrText,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          tvSale.staffName.toString(),
                                          style: Styling.blueClrText,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          // Align the icons to the right
                                          children: [
                                            // Edit Icon
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: saveFlag
                                                      ? Colors.blueGrey
                                                      : Colors.blue),
                                              // Icon for edit
                                              onPressed: () {
                                                loadDenominationData(
                                                    tvSale.regDefRcptId!.toInt());
                                                var regDefRcptId = tvSale.regDefRcptId.toString();
                                                var regDefRecptDate = tvSale.regDefRcptDate.toString();
                                                var staffId = tvSale.staffId.toString();
                                                var staffName = tvSale.staffName.toString();
                                                var consumerNumber = tvSale.consumerNo.toString();
                                                var consumerName = tvSale.consumerName.toString();
                                                var itemId = tvSale.itemId.toString();
                                                var itemName = tvSale.itemName.toString();
                                                var regDefRecptQty = tvSale.regDefRcptQty.toString();
                                                var replacementChrge = tvSale.replacementCharge.toString();
                                                var paidAmt = tvSale.paidAmt.toString();
                                                var paymentMode = tvSale.paymentMode.toString();
                                                var bankId = tvSale.bankId.toString();
                                                var bankMappingId = tvSale.bankMappingId.toString();
                                                var transactionCode = tvSale.transactionCode.toString();
                                                var transactionTime = tvSale.transactionTime.toString();
                                                var transactionRemark = tvSale.transactionRemark.toString();
                                                var addedBy = tvSale.addedBy.toString();
                                                var action = tvSale.action.toString();
                                                var remark = tvSale.remark.toString();
                                                // Navigate to the target screen and pass the data
                                                if (saveFlag) {
                                                  print('saveFlag $saveFlag');
                                                  showFlushBar(
                                                      context,
                                                      Constants
                                                          .dayEndCompleted);
                                                } else {
                                                  Navigator.pushNamed(
                                                    context,
                                                    ReceiptRegulatorScreen.screenName,
                                                    arguments: {
                                                      'regRcpIdV': regDefRcptId,
                                                      'regRcpDateV': regDefRecptDate,
                                                      'staffIdV': staffId,
                                                      'staffNameV': staffName,
                                                      'consumerNumberV': consumerNumber,
                                                      'consumerNameV': consumerName,
                                                      'itemIdV': itemId,
                                                      'itemNameV': itemName,
                                                      'regDefQtyV': regDefRecptQty,
                                                      'replacementRechargebleV': replacementChrge,
                                                      'paymentAmountV': paidAmt,
                                                      'paymentModeV': paymentMode,
                                                      'bankIdV': bankId,
                                                      'bankMappingIdV': bankMappingId,
                                                      'transactionCodeV': transactionCode,
                                                      'transactionTimeV': transactionTime,
                                                      'transactionRemarkV': transactionRemark,
                                                      'addedByV': addedBy,
                                                      'actionV': action,
                                                      'remarkV': remark,
                                                      'modeChange': "Edit"
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                            // Delete Icon
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color:saveFlag?Colors.redAccent:Colors.red),
                                              // Icon for delete
                                              onPressed: () async {
                                                if (saveFlag) {
                                                  print('saveFlag $saveFlag');
                                                  showFlushBar(
                                                      context,
                                                      Constants
                                                          .dayEndCompleted);
                                                } else {
                                                  int? tvId =
                                                  tvSale.regDefRcptId?.toInt();
                                                  bool? confirmDelete =
                                                  await showDialog<bool>(
                                                    context: context,
                                                    builder: (BuildContext
                                                    context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Are you sure?'),
                                                        content: const Text(
                                                            'You want to delete?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop(
                                                                  false); // User pressed Cancel
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop(
                                                                  true); // User pressed Delete
                                                            },
                                                            child: const Text(
                                                                'Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (confirmDelete == true) {
                                                    if (tvId != null) {
                                                      getRegulatorReceiptAddEdit(tvId!, "DELETE");
                                                      print(
                                                          'Delete button pressed$tvId');
                                                    } else {
                                                      print(
                                                          "Receipt ID is null.");
                                                    }
                                                  } else {
                                                    print(
                                                        'Delete action was canceled');
                                                  }
                                                }
                                                print(
                                                    'Delete button pressed');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Cons. No.: ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.consumerNo.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Cons. Name : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.consumerName.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Item Name : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.itemName.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Def. Qty. : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.regDefRcptQty.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Mode : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.paymentMode.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Pay Amt : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.paidAmt.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Remark : ",
                                              style:
                                              Styling.itemGreyTextSmall,
                                            ),
                                            Text(
                                              tvSale.remark.toString(),
                                              style:
                                              Styling.itemBlackTestSmall,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Text('No Records Found'),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
  }
  void cancelAction() {
    Navigator.pop(context);
    Navigator.pushNamed(
        context, ReceiptRegulatorScreen.screenName // This opens the third tab
    );
  }

  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? staffStatus = prefs.getString('StaffStatus');
    String? designation = prefs.getString('Designation');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "StaffStatus": staffStatus,
      "Designation": designation,
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
        staffdetailsmodel = data.map((json) {
          return GetStaffDetailsListModel.fromJson(json);
        }).toList();
        staffdetailsmodel.sort((a, b) {
          final nameA = a.staffName ?? '';
          final nameB = b.staffName ?? '';
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
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

  Future<void> getNoteTypeAndIDList() async {
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
              .map((item) => DenomModel.fromJson(item)) // Map to model
              .toList();

          setState(() {
            // Use filtered data to update the UI
            getNoteTypeAndIdFroDenominationListModel =
                filteredDataCashDenominationList;
            dataCashDenominationList = filteredDataCashDenominationList;
            isLoading = false;

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

  Future<void> getRegulatorReceiptAddEdit(int regRcptId, String actionMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    int? conDSNo;
    String? consName;
    int? cylHoldingQty;
    int? defQty;
    String? tranCode;
    String? times;
    String? transRemark;
    String? paymentRemark;
    double? paymentAmt = 0;
    double? refiillGasAmount = 0.0;
    int? regulatorValue;
    int? bankId;
    int? accMappingIds;
    List<Map<String, dynamic>> dataCashDenomination;


    double? depositAmount = 0.0;
    String? payMode;
    if (actionMode != "DELETE") {
      if (_consumerNoController.text.isNotEmpty) {
        conDSNo = int.parse(_consumerNoController.text);
      }
      if (_consumerNameController.text.isNotEmpty) {
        consName = _consumerNameController.text;
      }
      if (_defectiveItemController.text.isNotEmpty) {
        defQty = int.parse(_defectiveItemController.text);
      }

      if (_transactionCodeController.text.isNotEmpty) {
        tranCode = _transactionCodeController.text;
      }
      if (_transactionTimeController.text.isNotEmpty) {
        times = _transactionTimeController.text;
      }
      if (_transactionRemarkController.text.isNotEmpty) {
        transRemark = _transactionRemarkController.text;
      }

      if (_paymentRemarkController.text.isNotEmpty) {
        paymentRemark = _paymentRemarkController.text;
      }

      if (_paymentAmtController.text.isNotEmpty) {
        paymentAmt = double.parse(_paymentAmtController.text);
      }

      if (_consumerNoController.text.isEmpty) {
        showFlushBar(context, "Enter Consumer Number.");
        return;
      }

      if (_consumerNameController.text.isEmpty) {
        showFlushBar(context, "Enter Consumer Name.");
        return;
      }
      if (selectedRegulatorReceived == null) {
        showFlushBar(context, "Select Is Regulator Received.");
        return;
      }

      if (selectedRegulatorReceived == null) {
        showFlushBar(context, "Select Replacement Chargeble.");
        return;
      }

      if (selectedRegulatorItemReceived == null) {
        showFlushBar(context, "Select Item Name.");
        return;
      }

      if (selectedRegulatorReceived == "Yes") {
        if (_paymentAmtController.text.isEmpty || double.tryParse(_paymentAmtController.text)! <= 0) {
          showFlushBar(context, "Payment Amount Must Be Greater Than Zero.");
          return;
        }
        if (selectedBankName != null || selectedBankId != null) {
          if (selectedTransMode == null) {
            showFlushBar(context, "Select Transaction Mode.");
            return;
          }
        }

        if (selectedTransMode == "Online") {
          if (selectedBankName == null || selectedBankId == null) {
            showFlushBar(context, "Select Bank.");
            return;
          }
          if (_transactionCodeController.text.isEmpty) {
            showFlushBar(context, "Enter Transaction Code.");
            return;
          }
        }

        if (selectedTransMode == 'Cash') {
          if (totalAmount > 0) {
            if (totalAmount != paymentAmt) {
              showFlushBar(context,
                  "The Entered Payment Amt. Should Not Be Greater Than The Cash Denomination Total Amount.");
              return;
            }
          }
        }

        if (selectedTransMode == 'Cash') {
          if (cashDenominationMandatory) {
            if (totalAmount > 0) {
              if (totalAmount != paymentAmt) {
                showFlushBar(context,
                    "The Entered Payment Amt. Should Not Be Greater Than The Cash Denomination Total Amount.");
                return;
              }
            } else {
              showFlushBar(context, Constants.cashDenominationIsMandatory);
              return;
            }
          }
        }
        if(selectedTransMode == 'Cash') {
          tranCode = "";
          times = "";
          transRemark = "";
          selecteBankIDApi = 0;
          selecteBankIDApi = 0;
          selectedBankName = "";
          selectedBankId = "0";
          accMappingId = 0;
        }else if(selectedTransMode == 'Online'){
          dataCashDenomination = [];
        }
      }
      else if (selectedRegulatorReceived == "No") {
        paymentAmt = 0;
        selectedBankName = "";
        selectedBankId = "0";
        selecteBankIDApi = 0;
        accMappingId = 0;
        selectedTransMode = "";
        dataCashDenomination = [];
        tranCode = "";
        times = "";
        transRemark = "";

      }
      if (selectedBankName != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      } else {
        bankId = 0;
        accMappingIds = 0;
      }

      if (selectedTransMode == "Online") {
        payMode = "Bank";
      } else if (selectedTransMode == "Cash") {
        payMode = "Cash";
      } else {
        payMode = "";
      }
    }

    dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0,
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
        "RetNoteQty": 0,
        "RetNoteAmt": 0.0,
      };
    }).toList();


    final Map<String, dynamic> requestBody = {
      "RegDefRcptId": regRcptId,
      "DistributorId": distributorIds,
      "RegDefRcptDate": formattedDate,
      "StaffId": selectedReferredID ?? '',
      "StaffName": selectedReferredName ?? '',
      "ConsumerNo": conDSNo ?? '',
      "ConsumerName": consName ?? 0,
      "ItemId": selectedItemId,
      "ItemName":  selectedItemName,
      "RegDefRcptQty": defQty ?? 0,
      "ReplacementCharge": selectedRegulatorReceived == "Yes" ? 1 : 0,
      "PaidAmt": paymentAmt,
      "PaymentMode": payMode ?? '',
      "TransactionCode": tranCode ?? '',
      "TransactionTime": times ?? '',
      "TransactionRemark": transRemark ?? '',
      "BankId": bankId ?? 0,
      "BankMappingId": accMappingIds ?? 0,
      "Remark": paymentRemark ?? '',
      "AddedBy": userId,
      "Action": actionMode,
      "DenomRegDefList": dataCashDenomination,
    };

    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.RegDefReceiptAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print("requestBody RegDefReceiptAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // Handling response
    if (response.statusCode == 200) {
      if (response == -1 ||
          response.body == -1 ||
          response == "-1" ||
          response.body == "-1") {
        EasyLoading.showToast(Constants.expenseExistMgr,
            duration: const Duration(milliseconds: 3000));
      } else if (response == 0 ||
          response.body == 0 ||
          response == "0" ||
          response.body == "0") {
        EasyLoading.showToast(Constants.failToInserRecord,
            duration: const Duration(milliseconds: 3000));
      } else {
        // Successful response
        print("Response RegDefReceiptAddEdit: ${response.body}");
        if (actionMode != "DELETE") {
          EasyLoading.showToast(Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000));
        } else {
          EasyLoading.showToast(Constants.dataDeleted,
              duration: const Duration(milliseconds: 3000));
        }
        // Navigator.pushNamed(
        //   context,
        //   ReceiptRegulatorScreen.screenName,
        // );
        Navigator.pushNamed(
          context,
          BottomNavBarExample.screenName,
          arguments: 3, // This opens the third tab
        );
        setState(() {
          fetchReceiptDefRegulator();
        });
      }
    } else {
      // Error response
      print("Error RegDefReceiptAddEdit: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> fetchReceiptDefRegulator() async {
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
          Uri.parse('${AppUrl.GetRegDefReceiptDetails}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetRegDefReceiptDetails: ${response.request}");
        print("Request GetRegDefReceiptDetails: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status GetRegDefReceiptDetails: ${response.statusCode}");
        print("API Response GetRegDefReceiptDetails: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptDefList = data.map((json) => GetRegDefReceiptDetailsModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          EasyLoading.dismiss();
          throw Exception('Failed to load items');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> GetItemMasterListRegulatorList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? itemSubType = prefs.getString('ItemSubType');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "ItemSubType": itemSubType,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterListRegulatorList}/$distributorId/SC'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        itemDetailModel = data.map((json) {
          return GetItemMasterListRegulatorListModel.fromJson(json);
        }).toList();

        if (itemDetailModel.isNotEmpty) {
          selectedRegulatorItemReceived = itemDetailModel.first;
          selectedItemId = selectedRegulatorItemReceived?.itemId?.toInt();
          selectedItemName = selectedRegulatorItemReceived?.itemName ?? 'Unknown';
        }

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> loadDenominationData(int psvID) async {
    await fetchDenominationListAddEditList(psvID.toInt());

    initializeControllers();

    setState(() {});
  }

  void initializeControllers() {
    qtyController = List.generate(getDenominationLis.length, (index) {
      return TextEditingController(
        text: getDenominationLis[index].qty?.toString() ?? "0",
      );
    });

    amounts = List.generate(getDenominationLis.length, (index) {
      final qty = getDenominationLis[index].qty?.toDouble() ?? 0.0;
      final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });

    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);

    isQtyFilled = Map.fromIterable(
      List.generate(getDenominationLis.length, (index) => index),
      key: (index) => index,
      value: (index) => (getDenominationLis[index].qty ?? 0) > 0,
    );
  }

  Future<void> fetchDenominationListAddEditList(int RegDefRcptId) async {
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
              '${AppUrl.GetRegDefReceiptDenominationDtl}/$RegDefRcptId/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetTVEntryCashDenominationDtl: ${response.request}");
        print(
            "Request GetTVEntryCashDenominationDtl: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetTVEntryCashDenominationDtl: ${response.statusCode}");
        print("API Response GetTVEntryCashDenominationDtl: ${response.body}");
        if (response.statusCode == 200) {
          print("API Response GetTVEntryCashDenominationDtl: ${response.body}");
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDenominationLis = data
                .map((json) => GetRegDefReceiptDenominationDtlModel.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType =
          EasyLoadingMaskType.black // This creates a modal blocking interaction
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
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}