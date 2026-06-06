import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBarManager.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
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

  final bool disableNetworkCallsForTest;

  const TVSalesScreen({super.key, this.disableNetworkCallsForTest = false});

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
  List<DenomModel> getNoteTypeAndIdFroDenominationListModel = [];
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
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  bool isCashDenominationChecked = false;

  @override
  void initState() {
    super.initState();
    if (widget.disableNetworkCallsForTest) {
      return;
    }
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    getStaffDetailsList();
    getItemMasterList();
    fetchBank();
    getNoteTypeAndIDList();
    getCashHandOverDtlsList(selectedDate);
    fetchTVItemList();

    Future.delayed(Duration.zero, () async {
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
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode = 'Online';
        } else {
          selectedTransMode = null;
        }

        if (regulatorReceived.contains(isRegulatorV)) {
          selectedRegulatorReceived = isRegulatorV;
        } else {
          selectedRegulatorReceived = '';
        }

        await getStaffDetailsList();
        getStaffDetailsList().whenComplete(() {
          debugPrint("referredByNameEdit:$staffNameV");
          if (staffNameV != "null" && staffNameV.isNotEmpty && staffNameV != null) {
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

        await fetchBank();

        if (bankIdV != null && bankIdV is String && bankIdV.isNotEmpty && bankIdV != "null") {
          final match = bankModel.firstWhere(
            (item) => item.bankId?.toString().trim() == bankIdV.trim(),
            orElse: () => GetBankMappingDetailsListModel(),
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

        await getItemMasterList();
        getItemMasterList().whenComplete(() {
          debugPrint("productNameEdit:$itemNameV");
          if (itemNameV != "null" && itemNameV.isNotEmpty && itemNameV != null) {
            setState(() {
              selectedMaster = masterListModel.firstWhere(
                (item) => item.itemName == itemNameV,
                orElse: () => GetItemMasterListModel(itemId: 0, itemName: ''),
              );
              selectedItemId = selectedMaster?.itemId?.toInt();
              debugPrint("selectedItemId:$selectedItemId");
            });
          }
        });

        loadDenominationData(tvIdEdit!);

        if (getDenominationLis.isNotEmpty) {
          initializeControllers();
        } else {
          debugPrint("empty");
        }
      }
    });
  }

  // ── Shared input decoration ───────────────────────────────────────────────
  InputDecoration _fieldDeco(String hint, {bool required = false}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.blue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.red, width: 1.5)),
        filled: true,
        fillColor: AppColors.white,
      );

  // ── Form row helper ───────────────────────────────────────────────────────
  Widget _formRow(String label, Widget field, {bool required = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blue),
                children: required
                    ? [TextSpan(text: ' *', style: TextStyle(color: AppColors.red))]
                    : [],
              ),
            ),
            const SizedBox(height: 5),
            field,
          ],
        ),
      );

  // ── Section header ────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.blueXXL,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blueLight, width: 0.8),
        ),
        child: Text(
          title,
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13),
          textScaler: TextScaler.noScaling,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        appBar: CustomAppBarManagerr(title: 'TV Receipt'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── KPI hero strip ─────────────────────────────────────────
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.gradHero,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cash In Hand',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                              textScaler: TextScaler.noScaling),
                          const SizedBox(height: 2),
                          Text(
                            formatCurrency(totalamt ?? 0),
                            style: TextStyle(
                                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                            textScaler: TextScaler.noScaling,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('TV Date',
                            style: TextStyle(
                                fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                            textScaler: TextScaler.noScaling),
                        const SizedBox(height: 2),
                        Text(formattedDate,
                            style: TextStyle(
                                fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                            textScaler: TextScaler.noScaling),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Form card ──────────────────────────────────────────────
              Card(
                elevation: 0,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('TV Receipt Details'),

                      // Referred By
                      _formRow(
                        'Referred By',
                        DropdownButtonFormField<GetStaffDetailsListModel>(
                          key: formKey1,
                          value: staffdetailsmodel.contains(selectedStaff) ? selectedStaff : null,
                          decoration: _fieldDeco('Select Staff'),
                          style: TextStyle(fontSize: 13, color: AppColors.text),
                          items: staffdetailsmodel
                              .map((s) => DropdownMenuItem<GetStaffDetailsListModel>(
                                    value: s,
                                    child: Text(s.staffName ?? ''),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStaff = value;
                              selectedReferredID = value?.staffId!.toInt();
                              selectedReferredName = value?.staffName!.toString();
                            });
                          },
                          isExpanded: true,
                        ),
                      ),

                      // Consumer No.
                      _formRow(
                        'Consumer No.',
                        Form(
                          key: _formKeyConsumerNo,
                          child: TextFormField(
                            controller: _consumerNoController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            enabled: modes != "Edit",
                            decoration: _fieldDeco('Enter Consumer No.', required: true),
                            style: TextStyle(fontSize: 13, color: AppColors.text),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Consumer No. is Required';
                              return null;
                            },
                            onTap: () => _formKeyConsumerNo.currentState!.validate(),
                          ),
                        ),
                        required: true,
                      ),

                      // Consumer Name
                      _formRow(
                        'Consumer Name',
                        Form(
                          key: _formKeyConsumerName,
                          child: TextFormField(
                            controller: _consumerNameController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: _fieldDeco('Enter Consumer Name', required: true),
                            style: TextStyle(fontSize: 13, color: AppColors.text),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Consumer Name is Required';
                              return null;
                            },
                            onTap: () => _formKeyConsumerName.currentState!.validate(),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        required: true,
                      ),

                      // Select Item
                      _formRow(
                        'Select Item',
                        DropdownButtonFormField<GetItemMasterListModel>(
                          key: formKey2,
                          value: masterListModel.contains(selectedMaster) ? selectedMaster : null,
                          decoration: _fieldDeco('Select Item'),
                          style: TextStyle(fontSize: 13, color: AppColors.text),
                          items: masterListModel
                              .map((s) => DropdownMenuItem<GetItemMasterListModel>(
                                    value: s,
                                    child: Text(s.itemName ?? ''),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMaster = value!;
                              selectedItemId = selectedMaster?.itemId?.toInt();
                            });
                          },
                          isExpanded: true,
                        ),
                        required: true,
                      ),

                      // Cyl. Holding Qty. & Cyl. Receive Qty. side-by-side
                      Row(
                        children: [
                          Expanded(
                            child: _formRow(
                              'Cyl. Holding Qty.',
                              Form(
                                key: _formKeyCylHoldQty,
                                child: TextFormField(
                                  controller: _cylHoldingQtyController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: _fieldDeco('Qty.', required: true),
                                  style: TextStyle(fontSize: 13, color: AppColors.text),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  onChanged: (value) => setState(() {}),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Required';
                                    return null;
                                  },
                                  onTap: () => _formKeyCylHoldQty.currentState!.validate(),
                                ),
                              ),
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _formRow(
                              'Cyl. Receive Qty.',
                              Form(
                                key: _formKeyCylReceQty,
                                child: TextFormField(
                                  controller: _cylReceiveQtyController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: _fieldDeco('Qty.', required: true),
                                  style: TextStyle(fontSize: 13, color: AppColors.text),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  onChanged: (value) => setState(() {}),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Required';
                                    return null;
                                  },
                                  onTap: () => _formKeyCylReceQty.currentState!.validate(),
                                ),
                              ),
                              required: true,
                            ),
                          ),
                        ],
                      ),

                      // Regulator Received
                      _formRow(
                        'Regulator Received',
                        DropdownButtonFormField<String>(
                          key: formKey3,
                          decoration: _fieldDeco('Select'),
                          value: selectedRegulatorReceived,
                          style: TextStyle(fontSize: 13, color: AppColors.text),
                          items: regulatorReceived
                              .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                              .toList(),
                          onChanged: (value) => setState(() => selectedRegulatorReceived = value),
                          isExpanded: true,
                        ),
                        required: true,
                      ),

                      // Deposit Amt. & Refill Gas Payment side-by-side
                      Row(
                        children: [
                          Expanded(
                            child: _formRow(
                              'Deposit Amt. Paid',
                              TextField(
                                controller: _depositAmountPaidController,
                                decoration: _fieldDeco('Enter Amount'),
                                style: TextStyle(fontSize: 13, color: AppColors.text),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _formRow(
                              'Refill Gas Payment',
                              TextField(
                                controller: _refillGasPaymentController,
                                decoration: _fieldDeco('Enter Amount'),
                                style: TextStyle(fontSize: 13, color: AppColors.text),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Payment Amount
                      _formRow(
                        'Payment Amount',
                        Form(
                          key: _formKeyPayAmt,
                          child: TextFormField(
                            controller: _paymentAmountController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: _fieldDeco('Enter Payment Amount', required: true),
                            style: TextStyle(fontSize: 13, color: AppColors.text),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (value) => setState(() {}),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Payment Amount is Required';
                              return null;
                            },
                            onTap: () => _formKeyPayAmt.currentState!.validate(),
                          ),
                        ),
                        required: true,
                      ),

                      // Payment Mode
                      _formRow(
                        'Payment Mode',
                        DropdownButtonFormField<String>(
                          key: formKey4,
                          decoration: _fieldDeco('Select Mode'),
                          value: selectedTransMode,
                          style: TextStyle(fontSize: 13, color: AppColors.text),
                          items: getTransMode
                              .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                              .toList(),
                          onChanged: (value) => setState(() => selectedTransMode = value),
                          isExpanded: true,
                        ),
                        required: true,
                      ),

                      // Online-only fields
                      if (selectedTransMode == 'Online') ...[
                        _formRow(
                          'Select Bank Account No.',
                          DropdownButtonFormField<GetBankMappingDetailsListModel>(
                            key: _formKeyBankAcc,
                            isExpanded: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: _fieldDeco('Select Acc No', required: true),
                            style: TextStyle(fontSize: 13, color: AppColors.text),
                            value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                            items: bankModel
                                .map((item) => DropdownMenuItem<GetBankMappingDetailsListModel>(
                                      value: item,
                                      child: Text('${item.bankName ?? ''} - ${item.accountNo ?? ''}'),
                                    ))
                                .toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                _selectBankModel = selectedItem;
                                selectedBankName = selectedItem?.bankName;
                                selectedBankId = selectedItem?.accountNo;
                                selecteBankIDApi = selectedItem?.bankId?.toInt();
                                accMappingId = selectedItem?.mappingId?.toInt();
                              });
                            },
                          ),
                          required: true,
                        ),
                        _formRow(
                          'Transaction Code',
                          Form(
                            key: _formKeyTranCode,
                            child: TextFormField(
                              controller: _transactionCodeController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: _fieldDeco('Enter Transaction Code', required: true),
                              style: TextStyle(fontSize: 13, color: AppColors.text),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                                FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')),
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              onChanged: (value) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Transaction Code Required';
                                return null;
                              },
                              onTap: () => _formKeyTranCode.currentState!.validate(),
                            ),
                          ),
                          required: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _formRow(
                                'Time',
                                TextField(
                                  controller: _transactionTimeController,
                                  decoration: _fieldDeco('HH:MM'),
                                  style: TextStyle(fontSize: 13, color: AppColors.text),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  onChanged: (value) => setState(() {}),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _formRow(
                                'Transaction Remark',
                                TextField(
                                  controller: _transactionRemarkController,
                                  decoration: _fieldDeco('Enter Tran. Remark'),
                                  style: TextStyle(fontSize: 13, color: AppColors.text),
                                  inputFormatters: [LengthLimitingTextInputFormatter(250)],
                                  onChanged: (value) => setState(() {}),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Remark
                      _formRow(
                        'Remark',
                        TextField(
                          controller: _paymentRemarkController,
                          decoration: _fieldDeco('Enter Remark'),
                          style: TextStyle(fontSize: 13, color: AppColors.text),
                          inputFormatters: [LengthLimitingTextInputFormatter(250)],
                          onChanged: (value) => setState(() {}),
                        ),
                      ),

                      // Cash denomination checkbox
                      if (selectedTransMode == 'Cash')
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.blueXL,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              'Cash Denomination',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w600),
                            ),
                            value: isCashDenominationChecked,
                            activeColor: AppColors.blue,
                            onChanged: (bool? value) =>
                                setState(() => isCashDenominationChecked = value ?? false),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          ),
                        ),

                      // Cash denomination table
                      if (selectedTransMode == 'Cash' && isCashDenominationChecked) ...[
                        _sectionHeader(cashDenominationMandatory
                            ? 'Cash Denomination (Mandatory)'
                            : 'Cash Denomination'),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                decoration: BoxDecoration(
                                  color: AppColors.bg2,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text('Note Type',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue),
                                            textScaler: TextScaler.noScaling)),
                                    Expanded(
                                        flex: 3,
                                        child: Text('Qty',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue),
                                            textScaler: TextScaler.noScaling)),
                                    Expanded(
                                        flex: 3,
                                        child: Text('Amount',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue),
                                            textScaler: TextScaler.noScaling)),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: getNoteTypeAndIdFroDenominationListModel.length,
                                itemBuilder: (context, index) {
                                  final data = getNoteTypeAndIdFroDenominationListModel[index];
                                  return Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.border, width: 0.6)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text('${data.noteType}',
                                                style: TextStyle(
                                                    fontSize: 12, color: AppColors.textMid),
                                                textScaler: TextScaler.noScaling)),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 34,
                                            child: TextField(
                                              controller: qtyController[index],
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12, color: AppColors.text),
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6, vertical: 7),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                    borderSide:
                                                        BorderSide(color: AppColors.border)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                    borderSide:
                                                        BorderSide(color: AppColors.border)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                    borderSide: BorderSide(
                                                        color: AppColors.blue, width: 1.5)),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  amounts[index] =
                                                      (double.tryParse(value) ?? 0.0) *
                                                          data.noteType!;
                                                  totalAmount = amounts.fold(
                                                      0.0, (sum, amount) => sum + amount);
                                                  finalAmountCashDeno =
                                                      totalAmount - returnAmount;
                                                  isQtyFilled[index] = value.isNotEmpty;
                                                  debugPrint("Collected$totalAmount");
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Text(amounts[index].toStringAsFixed(2),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12, color: AppColors.textMid),
                                                textScaler: TextScaler.noScaling)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.blueXXL,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text('Collected:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue),
                                            textScaler: TextScaler.noScaling)),
                                    Text(totalAmount.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.blue),
                                        textScaler: TextScaler.noScaling),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: Text('Final Total:',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue),
                                            textScaler: TextScaler.noScaling)),
                                    Text(finalAmountCashDeno.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.blue),
                                        textScaler: TextScaler.noScaling),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => cancelAction(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.blue,
                                side: BorderSide(color: AppColors.blue),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text('Cancel',
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (saveFlag) {
                                  showFlushBar(context, Constants.dayEndCompleted);
                                } else {
                                  if (modes == "Edit") {
                                    updateTVAddEditForMob(tvIdEdit!, "EDIT");
                                  } else {
                                    updateTVAddEditForMob(0, "ADD");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    saveFlag ? AppColors.textMuted : AppColors.blue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(modes == "Edit" ? 'Update' : 'Save',
                                  style:
                                      TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── TV Receipt List ────────────────────────────────────────
              _sectionHeader('TV Receipt List'),
              if (tvReceiptList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('No Records Found',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tvReceiptList.length,
                  itemBuilder: (context, index) {
                    GetTvSaleListModel? tvSale = tvReceiptList[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.blueXXL,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    DateFormat('dd-MM-yyyy')
                                        .format(DateTime.parse(tvSale.tVDate ?? '')),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w600),
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tvSale.staffName.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMid,
                                        fontWeight: FontWeight.w500),
                                    textScaler: TextScaler.noScaling,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    loadDenominationData(tvSale.tVId!.toInt());
                                    final args = {
                                      'ptvIDV': tvSale.tVId.toString(),
                                      'sVDateV': tvSale.tVDate.toString(),
                                      'staffIdV': tvSale.staffId.toString(),
                                      'staffNameV': tvSale.staffName.toString(),
                                      'consumerNumberV': tvSale.consumerNo.toString(),
                                      'consumerNameV': tvSale.consumerName.toString(),
                                      'itemIdV': tvSale.itemId.toString(),
                                      'itemNameV': tvSale.itemName.toString(),
                                      'cylHoldingQtyV': tvSale.clyHoldQty.toString(),
                                      'cylReceiveQtyV': tvSale.clyReceivedQty.toString(),
                                      'isRegulatorV': tvSale.isRegulator.toString(),
                                      'depositAmountV': tvSale.depositAmt.toString(),
                                      'refillGasAmountV': tvSale.refillGasAmt.toString(),
                                      'paymentAmountV': tvSale.paidAmt.toString(),
                                      'paymentModeV': tvSale.paymentMode.toString(),
                                      'bankIdV': tvSale.bankId.toString(),
                                      'bankMappingIdV': tvSale.bankMappingId.toString(),
                                      'transactionCodeV': tvSale.transactionCode.toString(),
                                      'transactionTimeV': tvSale.transactionTime.toString(),
                                      'transactionRemarkV': tvSale.transactionRemark.toString(),
                                      'addedByV': tvSale.addedBy.toString(),
                                      'actionV': tvSale.action.toString(),
                                      'remarkV': tvSale.remark.toString(),
                                      'modeChange': "Edit"
                                    };
                                    if (saveFlag) {
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      Navigator.pushNamed(
                                          context, TVSalesScreen.screenName,
                                          arguments: args);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: saveFlag ? AppColors.bg : AppColors.blueXL,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Icon(Icons.edit_outlined,
                                        size: 16,
                                        color: saveFlag
                                            ? AppColors.textMuted
                                            : AppColors.blue),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (saveFlag) {
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      int? tvId = tvSale.tVId?.toInt();
                                      bool? confirmDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text('You want to delete?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(false),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(true),
                                                  child: const Text('Delete')),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirmDelete == true && tvId != null) {
                                        updateTVAddEditForMob(tvId, "DELETE");
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: saveFlag ? AppColors.bg : AppColors.redXL,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Icon(Icons.delete_outline,
                                        size: 16,
                                        color: saveFlag ? AppColors.textMuted : AppColors.red),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(height: 1, thickness: 0.6, color: AppColors.border),
                            const SizedBox(height: 8),
                            _tvInfoRow('Cons. No.', tvSale.consumerNo.toString(), 'Cons. Name',
                                tvSale.consumerName.toString()),
                            _tvInfoRow('Item Type', tvSale.itemName.toString(), 'Mode',
                                tvSale.paymentMode == "Bank"
                                    ? "Online"
                                    : tvSale.paymentMode.toString()),
                            _tvInfoRow('Deposit Amt.', tvSale.depositAmt.toString(),
                                'Refill Amt.', tvSale.refillGasAmt.toString()),
                            _tvInfoRow('Payment Amt.', tvSale.paidAmt.toString(), 'Remark',
                                tvSale.remark.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tvInfoRow(String label1, String val1, String label2, String val2) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Expanded(
                child: RichText(
                    text: TextSpan(children: [
              TextSpan(
                  text: '$label1: ',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500)),
              TextSpan(
                  text: val1,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600)),
            ]))),
            Expanded(
                child: RichText(
                    text: TextSpan(children: [
              TextSpan(
                  text: '$label2: ',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500)),
              TextSpan(
                  text: val2,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w600)),
            ]))),
          ],
        ),
      );

  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint("GetStaffDetailsList : ${AppUrl.GetStaffDetailsList}/$distributorId/1/0");
    debugPrint("GetStaffDetailsList : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        staffdetailsmodel =
            data.map((json) => GetStaffDetailsListModel.fromJson(json)).toList();
        staffdetailsmodel.sort((a, b) => (a.staffName ?? '')
            .toLowerCase()
            .compareTo((b.staffName ?? '').toLowerCase()));
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
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint("GetItemMasterList : ${AppUrl.GetItemMasterList}/$distributorId/0/C");
    debugPrint("GetItemMasterList : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        masterListModel =
            data.map((json) => GetItemMasterListModel.fromJson(json)).toList();
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
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/0'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        "GetBankMappingDetailsListModel : ${AppUrl.GetBankMappingDetailsList}/$distributorId/0");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        bankModel =
            data.map((json) => GetBankMappingDetailsListModel.fromJson(json)).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getNoteTypeAndIDList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? bearerToken = prefs.getString('token');
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }
        final response = await http.get(
          Uri.parse('${AppUrl.GetCashDenominationItemList}/0'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        debugPrint("Response body GetCashDenominationItemList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          final filteredList =
              jsonResponse.map((item) => DenomModel.fromJson(item)).toList();
          setState(() {
            getNoteTypeAndIdFroDenominationListModel = filteredList;
            dataCashDenominationList = filteredList;
            isLoading = false;
            qtyController = List.generate(
                filteredList.length, (i) => TextEditingController());
            amounts = List.generate(filteredList.length, (i) => 0.0);
            qtyControllerReturn = List.generate(
                filteredList.length, (i) => TextEditingController());
            amountsReturn = List.generate(filteredList.length, (i) => 0.0);
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
      }
    }
  }

  Future<void> getCashHandOverDtlsList(DateTime date) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
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
        String fd = DateFormat('yyyy-MM-dd').format(date);
        final response = await http.post(
          Uri.parse('${AppUrl.GetCashHandOverDtls}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({"DistributorId": distributorId, "Date": fd}),
        );
        debugPrint("Response body GetCashHandOverDtls: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashdatamodel = data
                .map((jsonItem) => GetCashHandOverDtlsListModel.fromJson(jsonItem))
                .toList();
            isLoading = false;
            for (var item in cashdatamodel) {
              if (item.staffId.toString() == userId) {
                print("Matched Staff Total Amount: ${item.totalAmt}");
                totalamt = (item.totalAmt ?? 0.0).toDouble();
                break;
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
      }
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
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
    // ignore: unused_local_variable
    int addedBys = int.parse(addedBy!);
    int distributorIds = int.parse(distributorId!);
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

    if (actionMode != "DELETE") {
      if (_consumerNoController.text.isNotEmpty) {
        conDSNo = int.parse(_consumerNoController.text);
      }
      if (_consumerNameController.text.isNotEmpty) consName = _consumerNameController.text;
      if (_cylHoldingQtyController.text.isNotEmpty)
        cylHoldingQty = int.parse(_cylHoldingQtyController.text);
      if (_cylReceiveQtyController.text.isNotEmpty)
        cylReceiveQty = int.parse(_cylReceiveQtyController.text);
      if (_transactionCodeController.text.isNotEmpty)
        tranCode = _transactionCodeController.text;
      if (_transactionTimeController.text.isNotEmpty) times = _transactionTimeController.text;
      if (_transactionRemarkController.text.isNotEmpty)
        transRemark = _transactionRemarkController.text;
      if (_paymentRemarkController.text.isNotEmpty) paymentRemark = _paymentRemarkController.text;

      if (_consumerNoController.text.isEmpty) {
        showFlushBar(context, "Enter Consumer Number.");
        return;
      }
      if (_consumerNameController.text.isEmpty) {
        showFlushBar(context, "Enter Consumer Name.");
        return;
      }
      if (selectedMaster == null) {
        showFlushBar(context, "Select Item.");
        return;
      }
      if (_cylHoldingQtyController.text.isEmpty) {
        showFlushBar(context, "Enter Cylinder Holding Quantity.");
        return;
      }
      if (_cylReceiveQtyController.text.isEmpty) {
        showFlushBar(context, "Enter Cylinder Receive Quantity.");
        return;
      }
      if (selectedRegulatorReceived == null) {
        showFlushBar(context, "Select Is Regulator Received.");
        return;
      }
      if (_paymentAmountController.text.isEmpty) {
        showFlushBar(context, "Enter Payment Amount.");
        return;
      }
      if (selectedTransMode == null) {
        showFlushBar(context, "Select Transaction Mode.");
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
      if (_paymentAmountController.text.isNotEmpty)
        payAmount = double.parse(_paymentAmountController.text);
      if (_refillGasPaymentController.text.isNotEmpty)
        refiillGasAmount = double.parse(_refillGasPaymentController.text);
      if (_depositAmountPaidController.text.isNotEmpty)
        depositAmount = double.parse(_depositAmountPaidController.text);

      if (selectedTransMode == 'Cash') {
        if (finalAmountCashDeno > 0) {
          if (finalAmountCashDeno != payAmount) {
            showFlushBar(context,
                "The Entered Payment Amt. Should Not Be Greater Than The Cash Denomination Total Amount.");
            return;
          }
        }
      }
      if (selectedTransMode == 'Cash') {
        if (cashDenominationMandatory) {
          if (finalAmountCashDeno > 0) {
            if (finalAmountCashDeno != payAmount) {
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
      if (selectedTransMode == 'Cash') {
        if (modes == "Edit") {
          if (editPaymentMode == "Cash") {
            double? editCash = double.tryParse(paymentAmountV!);
            double totalCash = editCash! + totalamt!;
            if (payAmount! > totalCash) {
              showFlushBar(
                  context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
              return;
            }
          } else {
            if (payAmount! > totalamt!) {
              showFlushBar(
                  context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
              return;
            }
          }
        } else {
          if (payAmount! > totalamt!) {
            showFlushBar(
                context, "Payment Amount Can Not Be Greater Than Cash In Hand Amount.");
            return;
          }
        }
      }
      if (selectedTransMode == "Online") {
        payMode = "Bank";
      } else if (selectedTransMode == "Cash") {
        payMode = "Cash";
      } else {
        payMode = "";
      }
    }

    final List<Map<String, dynamic>> dataCashDenomination =
        getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0,
        "NoteQty": qtyController[index].text.isNotEmpty
            ? int.tryParse(qtyController[index].text)
            : 0,
        "NoteAmt": amounts[index],
        "RetNoteQty": qtyControllerReturn[index].text.isNotEmpty
            ? int.tryParse(qtyControllerReturn[index].text)
            : 0,
        "RetNoteAmt": amountsReturn[index],
      };
    }).toList();

    int? bankId;
    int? accMappingIds;
    if (selectedBankName != null) {
      bankId = selecteBankIDApi;
      accMappingIds = accMappingId;
    } else {
      bankId = 0;
      accMappingIds = 0;
    }

    final Map<String, dynamic> requestBody = {
      "TVId": tvID,
      "DistributorId": distributorIds,
      "TVDate": formattedDate,
      "StaffId": selectedReferredID ?? '',
      "ConsumerNo": conDSNo ?? '',
      "ConsumerName": consName ?? '',
      "ItemId": selectedItemId ?? 0,
      "ClyHoldQty": cylHoldingQty ?? '',
      "ClyReceivedQty": cylReceiveQty ?? '',
      "IsRegulator": selectedRegulatorReceived ?? '',
      "DepositAmt": depositAmount,
      "RefillGasAmt": refiillGasAmount,
      "PaidAmt": payAmount,
      "PaymentMode": payMode ?? '',
      "BankId": bankId ?? 0,
      "BankMappingId": accMappingIds ?? 0,
      "TransactionCode": tranCode ?? '',
      "TransactionTime": times ?? '',
      "TransactionRemark": transRemark ?? '',
      "Remark": paymentRemark ?? '',
      "AddedBy": userId,
      "Action": actionMode,
      "UpdatedFrom": "MOB",
      "DenomTVList": dataCashDenomination,
    };

    print("TVDtlsAddEdit: $requestBody");
    requestBody.forEach((key, value) => print('$key: $value'));

    final response = await http.post(
      Uri.parse('${AppUrl.TVDtlsAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );

    print(
        "requestBody TVDtlsAddEdit: ${response.statusCode} - ${response.request}$requestBody");
    requestBody.forEach((key, value) => print('$key: $value'));

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
        print("Response TVDtlsAddEdit: ${response.body}");
        if (actionMode != "DELETE") {
          EasyLoading.showToast(Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000));
        } else {
          EasyLoading.showToast(Constants.dataDeleted,
              duration: const Duration(milliseconds: 3000));
        }
        Navigator.pushNamed(context, BottomNavBarExample.screenName, arguments: 3);
        setState(() {
          fetchTVItemList();
        });
      }
    } else {
      print("Error TVDtlsAddEdit: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> fetchTVItemList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? token = prefs.getString('token');
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetTVDetails}/$distributorId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("API Response Status GetTVDetails: ${response.statusCode}");
        print("API Response GetTVDetails: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            tvReceiptList =
                data.map((json) => GetTvSaleListModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() => isLoading = false);
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
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
          text: getDenominationLis[index].qty?.toString() ?? "0");
    });
    amounts = List.generate(getDenominationLis.length, (index) {
      final qty = getDenominationLis[index].qty?.toDouble() ?? 0.0;
      final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType;
    });
    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);
    isQtyFilled = Map.fromIterable(
      List.generate(getDenominationLis.length, (index) => index),
      key: (index) => index,
      value: (index) => (getDenominationLis[index].qty ?? 0) > 0,
    );
    qtyControllerReturn = List.generate(getDenominationLis.length, (index) {
      return TextEditingController(
          text: getDenominationLis[index].retNoteQty?.toString() ?? "0");
    });
    amountsReturn = List.generate(getDenominationLis.length, (index) {
      final qty = getDenominationLis[index].retNoteQty?.toDouble() ?? 0.0;
      final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType;
    });
    returnAmount = amountsReturn.fold(0.0, (sum, item) => sum + item);
    finalAmountCashDeno = totalAmount - returnAmount;
  }

  Future<void> fetchDenominationListAddEditList(int tvId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? token = prefs.getString('token');
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetTVEntryCashDenominationDtl}/$tvId/$distributorId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("API Response Status GetTVEntryCashDenominationDtl: ${response.statusCode}");
        print("API Response GetTVEntryCashDenominationDtl: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDenominationLis =
                data.map((json) => DenominationListForTvModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() => isLoading = false);
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  void cancelAction() {
    Navigator.pop(context);
    Navigator.pushNamed(context, TVSalesScreen.screenName);
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (distributorId == null || bearerToken == null) {
      return;
    }
    int? distributorIds = int.tryParse(distributorId);
    if (distributorIds == null) {
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
        } else {
          saveFlag = true;
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> checkCashDenominationFlagMandatory() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
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
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        debugPrint("Response body GetPageActionPermissionDtls: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashDenoMandatoryList = data
                .map((jsonItem) =>
                    CahsDenominationMandatoryFlagModel.fromJson(jsonItem))
                .toList();
            isLoading = false;
            for (var item in cashDenoMandatoryList) {
              if (item.distributorId.toString() == distributorId &&
                  item.permissionFor == "Cash Denomination" &&
                  item.isActive == 1) {
                cashDenominationMandatory = true;
                break;
              } else {
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
      }
    }
  }
}

