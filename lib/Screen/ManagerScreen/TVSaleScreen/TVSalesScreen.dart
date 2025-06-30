import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../SVSaleModel/GetItemMasterListModel.dart';
import '../SVSaleModel/GetStaffDetailsListModel.dart';
import 'package:http/http.dart' as http;

import '../UpdatePaymentsScreen/GetCashHandOverDtlsListModel.dart';
import 'DenominationListForTVModel.dart';
import 'GetTVSaleListModel.dart';
class TVSalesScreen extends StatefulWidget {
  static const screenName = '/tvSalesScreen';
  const TVSalesScreen({super.key});

  @override
  State<TVSalesScreen> createState() => _TVSalesScreenState();
}

class _TVSalesScreenState extends State<TVSalesScreen> {
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  GetStaffDetailsListModel? selectedStaff;
  int? selectedReferredID;
  String? selectedReferredName;
  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final TextEditingController _consumerNoController = TextEditingController();
  final _formKeyConsumerNo = GlobalKey<FormState>();
  final _formKeyConsumerName = GlobalKey<FormState>();
  final _formKeyCylHoldQty = GlobalKey<FormState>();
  final _formKeyCylReceQty = GlobalKey<FormState>();
  final _formKeyPayAmt = GlobalKey<FormState>();
  final _formKeyTranCode = GlobalKey<FormState>();
  final _formKeyIsRegReceive = GlobalKey<FormState>();
  final _formKeyBankAcc = GlobalKey<FormState>();
  final _formKeyItem = GlobalKey<FormState>();
  bool isDropdownTouched = false;
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _cylReceiveQtyController = TextEditingController();
  final TextEditingController _cylHoldingQtyController = TextEditingController();
  final TextEditingController _depositAmountPaidController = TextEditingController();
  final TextEditingController _refillGasPaymentController = TextEditingController();
  final TextEditingController _paymentAmountController = TextEditingController();
  final TextEditingController _paymentRemarkController = TextEditingController();
  final TextEditingController _transactionRemarkController = TextEditingController();
  final TextEditingController _transactionTimeController = TextEditingController();
  final TextEditingController _transactionCodeController = TextEditingController();
  List<GetItemMasterListModel> masterListModel = [];
  GetItemMasterListModel? selectedMaster;
  int? selectedItemId;
  List<String> regulatorReceived = ["Yes", "No"];
  String? selectedRegulatorReceived;
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<TextEditingController> qtyControllerReturn = [];
  List<double> amounts = [];
  List<double> amountsReturn = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  double? totalamt;
  DateTime selectedDate = DateTime.now();

  List<GetTvSaleListModel> tvReceiptList = [];
  List<DenominationListForTvModel> getDenominationLis = [];
  var argValue;
  String? modes;
  int? tvIdEdit;
  String? paymentAmountV;
  String? editPaymentMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStaffDetailsList();
    getItemMasterList();
    fetchBank();
    getNoteTypeAndIDList();
    getCashHandOverDtlsList(selectedDate);
    fetchTVItemList();

    Future.delayed(Duration.zero, ()  async {
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
          modes = argValue?["modeChange"] ?? '';
      if (argValue != null) {
        tvIdEdit = int.tryParse(argValue["ptvIDV"] ?? 0);
        String sVDateV = argValue["sVDateV"] ?? 0;
        String staffIdV = argValue["staffIdV"] ?? 0;
        String staffNameV = argValue["staffNameV"] ?? 0;
        String consumerNumberV = argValue["consumerNumberV"] ?? 0;
        String consumerNameV = argValue["consumerNameV"] ?? 0;
        String itemIdV = argValue["itemIdV"] ?? 0;
        String itemNameV = argValue["itemNameV"] ?? 0;
        String cylHoldingQtyV = argValue["cylHoldingQtyV"] ?? 0;
        String cylReceiveQtyV = argValue["cylReceiveQtyV"] ?? 0;
        String isRegulatorV = argValue["isRegulatorV"] ?? 0;
        String depositAmountV = argValue["depositAmountV"] ?? 0;
        String refillGasAmountV = argValue["refillGasAmountV"] ?? 0;
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
        _cylReceiveQtyController.text = cylReceiveQtyV;
        _cylHoldingQtyController.text = cylHoldingQtyV;
        _depositAmountPaidController.text = depositAmountV;
        _refillGasPaymentController.text = refillGasAmountV;
        _paymentAmountController.text = paymentAmountV!;
        _paymentRemarkController.text = remarkV;
        _transactionRemarkController.text = transactionRemarkV;
        _transactionTimeController.text = transactionTimeV;
        _transactionCodeController.text = transactionCodeV;

        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if(paymentModeEdit == "Bank") {
          selectedTransMode = 'Online';// fallback or handle invalid values
        }else{
          selectedTransMode = null;
        }

        if (regulatorReceived.contains(isRegulatorV)) {
          selectedRegulatorReceived = isRegulatorV;
        } else {
          selectedRegulatorReceived = '';// fallback or handle invalid values
        }

        await getStaffDetailsList();
        getStaffDetailsList().whenComplete((){
          debugPrint("referredByNameEdit:$staffNameV");
          if(staffNameV != "null" && staffNameV.isNotEmpty && staffNameV != null){
            setState(() {
              selectedStaff = staffdetailsmodel.firstWhere(
                    (item) => item.staffName == staffNameV,
                orElse: () => GetStaffDetailsListModel(staffName: ''),
              );
              selectedReferredID = int.parse(staffIdV);
              selectedReferredName = staffNameV;
            }
            );
          }
        });

        await fetchBank(); // wait for data first

        if (bankIdV != null && bankIdV is String && bankIdV.isNotEmpty && bankIdV != "null") {
          final match = bankModel.firstWhere(
                (item) => item.bankId?.toString().trim() == bankIdV.trim(), // Convert bankId to string before calling trim()
            orElse: () => GetBankMappingDetailsListModel(), // fallback empty object
          );

          // Only set if a valid match found
          if ((match.bankId?.toString() ?? '').isNotEmpty) { // Convert bankId to string for comparison
            setState(() {
              _selectBankModel = match;
              selectedBankName = match.bankName;
              selectedBankId = match.accountNo;
              selecteBankIDApi = match.bankId?.toInt();
              accMappingId = match.mappingId?.toInt();
            });
          }
        }


        await getItemMasterList();
        getItemMasterList().whenComplete((){
          debugPrint("productNameEdit:$itemNameV");
          if(itemNameV != "null" && itemNameV.isNotEmpty && itemNameV != null){
            setState(() {
              selectedMaster = masterListModel.firstWhere(
                    (item) => item.itemName == itemNameV,
                orElse: () => GetItemMasterListModel(itemId: 0, itemName: ''),
              );
              selectedItemId =  selectedMaster?.itemId?.toInt();
              debugPrint("selectedItemId:$selectedItemId");
              // selectedMaster = itemNameV as GetItemMasterListModel?;
            });
          }
        });

        loadDenominationData(tvIdEdit!);

        if(getDenominationLis.isNotEmpty){
          initializeControllers();
        }else{
          debugPrint("empty");
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
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
        appBar: CustomAppBarManager(
          title: 'TV Receipt', // Title or hint text for the text field
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.only(left: 5.0, right: 5, top: 15, bottom: 15),
            child:
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: textWidgetBlueColorWithoutStar('Cash In Hand')),
                    Flexible(flex: 1, child: Text('${formatCurrency(totalamt ?? 0)}',
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: textWidgetBlueColorWithoutStar('TV Date')),
                    Flexible(flex: 1, child: Text("$formattedDate")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: textWidgetBlueColorWithoutStar('Referred By')),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<GetStaffDetailsListModel>(
                        key: formKey1,
                        // value: selectedStaff,
                        value: staffdetailsmodel.contains(selectedStaff) ? selectedStaff : null,
                        // This should be a GetStaffDetailsListModel? variable
                        items: staffdetailsmodel
                            .map((GetStaffDetailsListModel staff) {
                          return DropdownMenuItem<GetStaffDetailsListModel>(
                            value: staff,
                            child: Text(
                                staff.staffName ?? ''), // Use a default if null
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStaff = value;
                            selectedReferredID = value?.staffId!.toInt();// value is of type GetStaffDetailsListModel?
                            selectedReferredName = value?.staffName!.toString();// value is of type GetStaffDetailsListModel?
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: textWidgetBlueColorWithStar("Consumer No.","*")),
                    Flexible(
                      flex: 1,
                      child:
                      // TextField(
                      //   controller: _consumerNoController,
                      //   // decoration: buildInputBorderUpdateStatusMgr(
                      //   //     "Enter Consumer No.", context),
                      //   decoration: InputDecoration(
                      //     errorText: (isShow)
                      //         ? 'Consumer No. is Required'
                      //         : null,
                      //     label: countTextWidgetTextStarverysmall(
                      //       context,
                      //       'Enter Consumer No.',
                      //       showAsterisk:
                      //       true, // Add a parameter to conditionally show the asterisk
                      //     ),
                      //   ),
                      //   style: Styling.textFormText,
                      //   keyboardType: TextInputType.number,
                      //   enabled: modes == "Edit"?false:true,
                      //   // Set keyboard type to numeric
                      //   inputFormatters: <TextInputFormatter>[
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     LengthLimitingTextInputFormatter(6),
                      //     // Allow only digits
                      //   ],
                      //   onTap: (){
                      //     if(_consumerNoController.text.isEmpty){
                      //       isShow = true;
                      //     }
                      //   },
                      //   onChanged: (value) {
                      //     setState(() {
                      //
                      //     });
                      //   },
                      //
                      // ),
                      Form(
                        key: _formKeyConsumerNo,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _consumerNoController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              enabled: modes != "Edit",
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
                                _formKeyConsumerNo.currentState!.validate(); // 👈 Validate on field submit
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
                    Expanded(child: textWidgetBlueColorWithStar("Consumer Name","*")),
                    Flexible(
                      flex: 1,
                      child: Form(
                        key: _formKeyConsumerName,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _consumerNameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: buildInputBorderUpdateStatusMgr(
                                  "Enter Consumer Name", context),
                              // decoration: InputDecoration(
                              //   errorText: (_consumerNameController
                              //       .text.isEmpty)
                              //       ? 'Consumer Name is Required'
                              //       : null,
                              //   label: countTextWidgetTextStarverysmall(
                              //     context,
                              //     'Enter Consumer Name',
                              //     showAsterisk:
                              //     true, // Add a parameter to conditionally show the asterisk
                              //   ),
                              // ),
                              style: Styling.textFormText,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Consumer Name is Required';
                                }
                                return null;
                              },
                              onTap: () {
                                _formKeyConsumerName.currentState!.validate(); // 👈 Validate on field submit
                              },
                              // Set keyboard type to numeric
                              onChanged: (value) {
                                setState(() {

                                });
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
                    Expanded(child: textWidgetBlueColorWithStar("Select Item","*")),
                    Flexible(
                      flex: 1,
                      child:
                      DropdownButtonFormField<GetItemMasterListModel>(
                        key: formKey2,
                        value: masterListModel.contains(selectedMaster) ? selectedMaster : null,
                        items:
                        masterListModel.map((GetItemMasterListModel staff) {
                          return DropdownMenuItem<GetItemMasterListModel>(
                            value: staff,
                            child: Text(staff.itemName ?? ''),
                          );
                        }).toList(),
                        // decoration: InputDecoration(
                        //   label: countTextWidgetTextStarverysmall(
                        //     context,
                        //     'Select Item',
                        //     showAsterisk:
                        //     true, // Add a parameter to conditionally show the asterisk
                        //   ),
                        // ),
                        onChanged: (value) {
                          setState(() {
                            selectedMaster = value!;
                            selectedItemId = selectedMaster?.itemId?.toInt();
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: textWidgetBlueColorWithStar("Cyl. Holding Qty.","*")),
                    Flexible(
                      flex: 1,
                      child: Form(
                        key: _formKeyCylHoldQty,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cylHoldingQtyController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: buildInputBorderUpdateStatusMgr(
                                  "Enter Cyl. Holding Qty.", context),
                              style: Styling.textFormText,
                              keyboardType: TextInputType.number,
                              // Set keyboard type to numeric
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                                // Allow only digits
                              ],
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cyl. Holding Qty.is Required';
                                }
                                return null;
                              },
                              onTap: () {
                                _formKeyCylHoldQty.currentState!.validate(); // 👈 Validate on field submit
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
                    Expanded(child: textWidgetBlueColorWithStar("Cyl. Receive Qty.","*")),
                    Flexible(
                      flex: 1,
                      child: Form(
                        key: _formKeyCylReceQty,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cylReceiveQtyController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: buildInputBorderUpdateStatusMgr(
                                  "Enter Cyl. Receive Qty.", context),
                              style: Styling.textFormText,
                              keyboardType: TextInputType.number,
                              // Set keyboard type to numeric
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                                // Allow only digits
                              ],
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cyl. Receive Qty.is Required';
                                }
                                return null;
                              },
                              onTap: () {
                                _formKeyCylReceQty.currentState!.validate(); // 👈 Validate on field submit
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
                    Expanded(child: textWidgetBlueColorWithStar("Regulator Received","*")),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        key: formKey3,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: selectedRegulatorReceived,
                        // Bind the selected value
                        items: regulatorReceived
                            .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
                Row(
                  children: [
                    Expanded(child: textWidgetBlueColorWithoutStar("Deposit Amt. Paid")),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _depositAmountPaidController,
                        decoration: buildInputBorderUpdateStatusMgr(
                            "Enter Deposit Amt.", context),
                        style: Styling.textFormText,
                        keyboardType: TextInputType.number,
                        // Set keyboard type to numeric
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                          LengthLimitingTextInputFormatter(5), // Limit to 9 characters total
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
                  children: [
                    Expanded(child: textWidgetBlueColorWithoutStar("Refill Gas Payment")),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _refillGasPaymentController,
                        decoration: buildInputBorderUpdateStatusMgr(
                            "Enter Refill Gas Payment", context),
                        style: Styling.textFormText,
                        keyboardType: TextInputType.number,
                        // Set keyboard type to numeric
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                          LengthLimitingTextInputFormatter(5), // Limit to 9 characters total
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
                  children: [
                    Expanded(child: textWidgetBlueColorWithStar("Payment Amount","*")),
                    Flexible(
                      flex: 1,
                      child: Form(
                        key: _formKeyPayAmt,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _paymentAmountController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: buildInputBorderUpdateStatusMgr(
                                  "Enter Payment Amount", context),
                              style: Styling.textFormText,
                              keyboardType: TextInputType.number,
                              // Set keyboard type to numeric
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                                LengthLimitingTextInputFormatter(10), // Limit to 9 characters total
                              ],
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Payment Amount is Required';
                                }
                                return null;
                              },
                              onTap: () {
                                _formKeyPayAmt.currentState!.validate(); // 👈 Validate on field submit
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
                    Expanded(child: textWidgetBlueColorWithStar("Payment Mode","*")),
                    Flexible(
                      flex: 1,
                      child:
                      DropdownButtonFormField<String>(
                        key: formKey4,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: selectedTransMode,
                        // Bind the selected value
                        items: getTransMode
                            .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
                        Expanded(child: textWidgetBlueColorWithStar("Select Bank Account No.","*")),
                        Flexible(
                          flex: 1,
                          child:
                            DropdownButtonFormField<
                                GetBankMappingDetailsListModel>(
                              isExpanded: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                label: countTextWidgetTextStarverysmall(
                                  context,
                                  'Select Acc No',
                                  showAsterisk:
                                  true, // Add a parameter to conditionally show the asterisk
                                ),
                              ),
                              value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,

                              items: bankModel.map((item) {
                                return
                                  DropdownMenuItem<GetBankMappingDetailsListModel>(
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
                              // hint: Text('Select Acc No'),

                            ),

                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: textWidgetBlueColorWithStar("Transaction Code","*")),
                        Flexible(
                          flex: 1,
                          child: Form(
                            key: _formKeyTranCode,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _transactionCodeController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: buildInputBorderUpdateStatusMgr(
                                      "Enter Transaction Code", context),
                                  // decoration: InputDecoration(
                                  //   errorText: (_transactionCodeController
                                  //       .text.isEmpty)
                                  //       ? 'Transaction Code Required'
                                  //       : null,
                                  //   label: countTextWidgetTextStarverysmall(
                                  //     context,
                                  //     'Enter Transaction Code',
                                  //     showAsterisk:
                                  //     true, // Add a parameter to conditionally show the asterisk
                                  //   ),
                                  // ),
                                  style: Styling.textFormText,
                                  // Set keyboard type to numeric
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(30), // Limit to 30 characters
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                                    ),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'), // Block all whitespace including space, tab, etc.
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {

                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Transaction Code Required';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    _formKeyTranCode.currentState!.validate(); // 👈 Validate on field submit
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
                        Expanded(child: textWidgetBlueColorWithoutStar("Time")),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _transactionTimeController,
                            decoration: buildInputBorderUpdateStatusMgr(
                                "Enter Time", context),
                            style: Styling.textFormText,
                            // Set keyboard type to numeric
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                              LengthLimitingTextInputFormatter(5),
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
                      children: [
                        Expanded(child: textWidgetBlueColorWithoutStar("Transaction Remark")),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _transactionRemarkController,
                            decoration: buildInputBorderUpdateStatusMgr(
                                "Enter Tran. Remark", context),
                            style: Styling.textFormText,
                            // Set keyboard type to numeric
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                            ],
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                          LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                        ],
                        onChanged: (value) {
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (selectedTransMode == 'Cash')
                  Column(
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
                                                      index] = (double
                                                          .tryParse(
                                                          value) ??
                                                          0.0) *
                                                          data.noteType!;
                                                      totalAmount =
                                                          amounts.fold(
                                                              0.0,
                                                                  (sum, amount) =>
                                                              sum +
                                                                  amount);
                                                      finalAmountCashDeno =
                                                          totalAmount -
                                                              returnAmount;
                                                      isQtyFilled[index] =
                                                          value
                                                              .isNotEmpty; // Mark index as filled
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
                                                      .toStringAsFixed(2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Cancel action
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
                        if(modes == "Edit"){
                          updateTVAddEditForMob(tvIdEdit!,"EDIT");
                        }else{
                          updateTVAddEditForMob(0,"ADD");
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
                            10), // Adjust padding to make button smaller
                      ),
                      child: Text(
                        modes == "Edit"?'Update':'Save',
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
                  child: tvReceiptList.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tvReceiptList.length,
                    itemBuilder: (context, index) {
                      GetTvSaleListModel? tvSale = tvReceiptList[index];
                      return
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex:1,child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(tvSale.tVDate ?? '')),style: Styling.blueClrText,),),
                                  Expanded(flex:1,child: Text(tvSale.staffName.toString(),style: Styling.blueClrText,),),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                      children: [
                                        // Edit Icon
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                          onPressed: () {
                                            loadDenominationData(tvSale.tVId!.toInt());
                                            var ptvID = tvSale.tVId.toString();
                                            var sVDate = tvSale.tVDate.toString();
                                            var staffId = tvSale.staffId.toString();
                                            var staffName = tvSale.staffName.toString();
                                            var consumerNumber = tvSale.consumerNo.toString();
                                            var consumerName = tvSale.consumerName.toString();
                                            var itemId = tvSale.itemId.toString();
                                            var itemName = tvSale.itemName.toString();
                                            var cylHoldingQty = tvSale.clyHoldQty.toString();
                                            var cylReceiveQty = tvSale.clyReceivedQty.toString();
                                            var isRegulator = tvSale.isRegulator.toString();
                                            var depositAmount = tvSale.depositAmt.toString();
                                            var refillGasAmount = tvSale.refillGasAmt.toString();
                                            var paymentAmount = tvSale.paidAmt.toString();
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
                                            Navigator.pushNamed(
                                              context,
                                              TVSalesScreen.screenName,
                                              arguments: {
                                                'ptvIDV' : ptvID,
                                                'sVDateV' : sVDate,
                                                'staffIdV' : staffId,
                                                'staffNameV' : staffName,
                                                'consumerNumberV' : consumerNumber,
                                                'consumerNameV' : consumerName,
                                                'itemIdV' : itemId,
                                                'itemNameV' : itemName,
                                                'cylHoldingQtyV' : cylHoldingQty,
                                                'cylReceiveQtyV' : cylReceiveQty,
                                                'isRegulatorV' : isRegulator,
                                                'depositAmountV' : depositAmount,
                                                'refillGasAmountV' : refillGasAmount,
                                                'paymentAmountV' : paymentAmount,
                                                'paymentModeV' : paymentMode,
                                                'bankIdV' : bankId,
                                                'bankMappingIdV' : bankMappingId,
                                                'transactionCodeV' : transactionCode,
                                                'transactionTimeV' : transactionTime,
                                                'transactionRemarkV' : transactionRemark,
                                                'addedByV' : addedBy,
                                                'actionV' : action,
                                                'remarkV' : remark,
                                                'modeChange': "Edit"
                                              },
                                            );
                                          },
                                        ),
                                        // Delete Icon
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),  // Icon for delete
                                          onPressed: () async {
                                            int? tvId = tvSale.tVId?.toInt();
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
                                              if (tvId != null) {
                                                updateTVAddEditForMob(tvId!,"DELETE");
                                                print('Delete button pressed$tvId');
                                              } else {
                                                print("Receipt ID is null.");
                                              }
                                            } else {
                                              print('Delete action was canceled');
                                            }
                                            print('Delete button pressed');
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
                                        Text("Cons. No.: ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.consumerNo.toString(),style: Styling.itemBlackTestSmall,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Cons. Name : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.consumerName.toString(),style: Styling.itemBlackTestSmall,),
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
                                        Text("Item Type : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.itemName.toString(),style: Styling.itemBlackTestSmall,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Mode : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.paymentMode == "Bank"?"Online":tvSale.paymentMode.toString(),style: Styling.itemBlackTestSmall,),
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
                                        Text("Deposit Amt. : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.depositAmt.toString(),style: Styling.itemBlackTestSmall,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Refill Amt. : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.refillGasAmt.toString(),style: Styling.itemBlackTestSmall,),
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
                                        Text("Payment Amt. : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.paidAmt.toString(),style: Styling.itemBlackTestSmall,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Remark : ",style: Styling.itemGreyTextSmall,),
                                        Text(tvSale.remark.toString(),style: Styling.itemBlackTestSmall,),
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
            )
          ),
        ),
      ),
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

        // 🔤 Sort alphabetically by a string field like "staffName"
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
  Future<void> getItemMasterList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? isActive = prefs.getString('IsActive');
    String? itemType = prefs.getString('ItemType');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "IsActive": isActive,
      "ItemType": itemType,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetItemMasterList : " +
        '${AppUrl.GetItemMasterList}/$distributorId/0/C');
    debugPrint("GetItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        masterListModel = data.map((json) {
          // String dateString = json['TransDate'];
          // DateTime date = DateTime.parse(dateString);
          // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // json['TransDate'] = formattedDate;

          return GetItemMasterListModel.fromJson(json);
        }).toList();

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
  Future<void> getNoteTypeAndIDList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(
          context,  Constants.connectionMessage);
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
            getNoteTypeAndIdFroDenominationListModel = filteredDataCashDenominationList;
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
  Future<void> getCashHandOverDtlsList(DateTime date) async {
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
        String? userId = prefs.getString("UserId");


        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,

        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetCashHandOverDtls}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetCashHandOverDtls: ${response.body}");
        debugPrint("Request body GetCashHandOverDtls: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashdatamodel = data.map((jsonItem) =>
                GetCashHandOverDtlsListModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashdatamodel) {
              // debugPrint("userId $userId item.staffId.toString() ${item.staffId.toString()}");

              if (item.staffId.toString() == userId) {
                // debugPrint("userId $userId item.staffId.toString() ${item.staffId.toString()}");
                print("Matched Staff Total Amount: ${item.totalAmt}");
                totalamt = (item.totalAmt ?? 0.0).toDouble();
                break; // Exit loop after finding the match
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

  Future<void> updateTVAddEditForMob(int tvID, String actionMode) async {
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
    int? cylReceiveQty;
    String? tranCode;
    String? times;
    String? transRemark;
    String? paymentRemark;
    double? payAmount = 0.0;
    double? refiillGasAmount = 0.0;
    double? depositAmount = 0.0;
    String? payMode;
    if(actionMode != "DELETE"){
      if(_consumerNoController.text.isNotEmpty){
        conDSNo = int.parse(_consumerNoController.text);
      }
      if(_consumerNameController.text.isNotEmpty){
        consName = _consumerNameController.text;
      }

      if(_cylHoldingQtyController.text.isNotEmpty){
        cylHoldingQty = int.parse(_cylHoldingQtyController.text);
      }
      if(_cylReceiveQtyController.text.isNotEmpty){
        cylReceiveQty = int.parse(_cylReceiveQtyController.text);
      }


      if(_transactionCodeController.text.isNotEmpty){
        tranCode = _transactionCodeController.text;
      }
      if(_transactionTimeController.text.isNotEmpty){
        times = _transactionTimeController.text;
      }
      if(_transactionRemarkController.text.isNotEmpty){
        transRemark = _transactionRemarkController.text;
      }

      if(_paymentRemarkController.text.isNotEmpty){
        paymentRemark = _paymentRemarkController.text;
      }

      if(_consumerNoController.text.isEmpty){
        showFlushBar(context,"Enter Consumer Number.");
        return;
      }

      if(_consumerNameController.text.isEmpty){
        showFlushBar(context,"Enter Consumer Name.");
        return;
      }

      if(selectedMaster == null){
        showFlushBar(context, "Select Item.");
        return;
      }
      if(_cylHoldingQtyController.text.isEmpty){
        showFlushBar(context, "Enter Cylinder Holding Quantity.");
        return;
      }
      if(_cylReceiveQtyController.text.isEmpty){
        showFlushBar(context, "Enter Cylinder Receive Quantity.");
        return;
      }
      if(selectedRegulatorReceived == null){
        showFlushBar(context, "Select Is Regulator Received.");
        return;
      }
      if(_paymentAmountController.text.isEmpty){
        showFlushBar(context, "Enter Payment Amount.");
        return;
      }

      if(selectedTransMode == null){
        showFlushBar(context, "Select Transaction Mode.");
        return;
      }

      if(selectedBankName != null || selectedBankId != null){
        if(selectedTransMode == null){
          showFlushBar(context, "Select Transaction Mode.");
          return;
        }
      }

      if(selectedTransMode == "Online"){
        if(selectedBankName == null || selectedBankId == null){
          showFlushBar(context, "Select Bank.");
          return;
        }
        if(_transactionCodeController.text.isEmpty){
          showFlushBar(context, "Enter Transaction Code.");
          return;
        }
      }

      if(_paymentAmountController.text.isNotEmpty){
        payAmount = double.parse(_paymentAmountController.text);
      }

      if(_refillGasPaymentController.text.isNotEmpty){
        refiillGasAmount = double.parse(_refillGasPaymentController.text);
      }

      if(_depositAmountPaidController.text.isNotEmpty){
        depositAmount = double.parse(_depositAmountPaidController.text);
      }

      if(selectedTransMode == 'Cash'){
        if(finalAmountCashDeno > 0){
          if(finalAmountCashDeno != payAmount){
            showFlushBar(context, "The Entered Payment Amt. Should Not Be Greater Than The Cash Denomination Total Amount.");
            return;
          }
        }
      }
      if(selectedTransMode == 'Cash'){
        if(modes == "Edit"){
          if(editPaymentMode == "Cash"){
            double? editCash = double.tryParse(paymentAmountV!);
            double totalCash = editCash! + totalamt! ;
            if(payAmount > totalCash!){
              showFlushBar(context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
              return;
            }
          }else{
            if(payAmount > totalamt!){
              showFlushBar(context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
              return;
            }
          }
        }else{
          if(payAmount > totalamt!){
            showFlushBar(context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
            return;
          }
        }
      }

      if(selectedTransMode == "Online"){
        payMode = "Bank";
      }else if(selectedTransMode == "Cash"){
        payMode = "Cash";
      }else{
        payMode = "";
      }
    }

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

    int? bankId;
    int? accMappingIds;
    if(selectedBankName != null) {
      bankId = selecteBankIDApi;
      accMappingIds = accMappingId;
    }else{
      bankId = 0;
      accMappingIds = 0;
    }

    final Map<String, dynamic> requestBody = {
      "TVId": tvID,
      "DistributorId":distributorIds,
      "TVDate": formattedDate,
      "StaffId": selectedReferredID ?? '',
      "ConsumerNo":conDSNo ?? '',
      "ConsumerName":consName ?? '',
      "ItemId":selectedItemId ?? 0,
      "ClyHoldQty":cylHoldingQty ?? '',
      "ClyReceivedQty":cylReceiveQty ?? '',
      "IsRegulator": selectedRegulatorReceived ?? '',
      "DepositAmt":depositAmount,
      "RefillGasAmt": refiillGasAmount,
      "PaidAmt":payAmount,
      "PaymentMode": payMode ?? '',
      "BankId": bankId ?? 0,
      "BankMappingId": accMappingIds ?? 0,
      "TransactionCode": tranCode ??'',
      "TransactionTime": times ??'',
      "TransactionRemark": transRemark ?? '',
      "Remark": paymentRemark ?? '',
      "AddedBy": userId,
      "Action": actionMode,
      "UpdatedFrom": "MOB",
      "DenomTVList": dataCashDenomination,
    };

    print("TVDtlsAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.TVDtlsAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    print(
        "requestBody TVDtlsAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // Handling response
    if (response.statusCode == 200) {
      // print("Response TVDtlsAddEdit: ${response.body}");
      //
      // // Navigator.pushNamed(
      // //   context,
      // //   BottomNavBarExample.screenName,
      // //   arguments: 3, // This opens the third tab
      // // );
      // EasyLoading.showToast(Constants.expenseSendMgr,
      //     duration: const Duration(milliseconds: 3000));
      // setState(() {
      //   fetchTVItemList();
      // });
      if(response == -1 || response.body == -1 || response == "-1" || response.body == "-1"){
        EasyLoading.showToast(Constants.expenseExistMgr,
            duration: const Duration(milliseconds: 3000));
      }else if(response == 0 || response.body == 0 || response == "0" || response.body == "0"){
        EasyLoading.showToast(Constants.failToInserRecord,
            duration: const Duration(milliseconds: 3000));
      }else{
        // Successful response
        print("Response TVDtlsAddEdit: ${response.body}");
        if(actionMode != "DELETE"){
          EasyLoading.showToast(Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000));
        }else{
          EasyLoading.showToast(Constants.dataDeleted,
              duration: const Duration(milliseconds: 3000));
        }
        Navigator.pushNamed(
          context,
          BottomNavBarExample.screenName,
          arguments: 3, // This opens the third tab
        );
        // EasyLoading.showToast(Constants.expenseSendMgr,
        //     duration: const Duration(milliseconds: 3000));
        setState(() {
          fetchTVItemList();
        });
      }
    } else {
      // Error response
      print("Error TVDtlsAddEdit: ${response.statusCode} - ${response.body}");
    }
    // } catch (e) {
    //   // Exception handling
    //   print("Exception UpdateSaleAddEditForMob: $e");
    // }
  }

  Future<void> fetchTVItemList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetTVDetails}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetTVDetails: ${response.request}");
        print("Request GetTVDetails: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status GetTVDetails: ${response.statusCode}");
        print("API Response GetTVDetails: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            tvReceiptList = data.map((json) => GetTvSaleListModel.fromJson(json)).toList();
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
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  Future<void> loadDenominationData(int psvID) async {
    await fetchDenominationListAddEditList(psvID.toInt());

    // Now call initializeControllers after list is fetched
    initializeControllers();

    // Refresh UI
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

    qtyControllerReturn = List.generate(getDenominationLis.length, (index) {
      return TextEditingController(
        text: getDenominationLis[index].retNoteQty?.toString() ?? "0",
      );
    });

    amountsReturn = List.generate(getDenominationLis.length, (index) {
      final qty = getDenominationLis[index].retNoteQty?.toDouble() ?? 0.0;
      final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });
    returnAmount = amountsReturn.fold(0.0, (sum, item) => sum + item);
    finalAmountCashDeno = totalAmount - returnAmount;

  }

  Future<void> fetchDenominationListAddEditList(int tvId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
          Uri.parse('${AppUrl.GetTVEntryCashDenominationDtl}/$tvId/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetTVEntryCashDenominationDtl: ${response.request}");
        print("Request GetTVEntryCashDenominationDtl: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status GetTVEntryCashDenominationDtl: ${response.statusCode}");
        print("API Response GetTVEntryCashDenominationDtl: ${response.body}");
        if (response.statusCode == 200) {
          print("API Response GetTVEntryCashDenominationDtl: ${response.body}");
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDenominationLis = data.map((json) => DenominationListForTvModel.fromJson(json)).toList();
            isLoading = false;
            // initializeControllers();
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  void cancelAction(){
    Navigator.pop(context);
    Navigator.pushNamed(
        context,
        TVSalesScreen.screenName// This opens the third tab
    );
  }
}
