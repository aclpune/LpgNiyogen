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
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
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
  final bool disableNetworkCallsForTest;

  const ReceiptRegulatorScreen({super.key, this.disableNetworkCallsForTest = false});

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
    if (widget.disableNetworkCallsForTest) {
      return;
    }
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        appBar: CustomAppBarManagerr(title: 'Receipt Defective Regulator'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // â”€â”€ Hero strip (gradHero â€” matches ManagerDashboard) â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(gradient: AppColors.gradHero),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Receipt Defective Regulator',
                              style: AppTypography.heroTitle),
                          const SizedBox(height: 4),
                          Text('Track returned regulator receipt details',
                              style: AppTypography.heroSubtitle),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text('Date',
                              style: AppTypography.labelSM
                                  .copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: 2),
                          Text(formattedDate,
                              style: AppTypography.cardTitle
                                  .copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // â”€â”€ Form card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0D1E3A8A),
                              blurRadius: 12,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Referred By
                          _buildFieldLabel('Referred By'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<GetStaffDetailsListModel>(
                            key: formKey1,
                            value: staffdetailsmodel.contains(selectedStaff)
                                ? selectedStaff
                                : null,
                            decoration: _inputDecoration(hint: 'Select Staff'),
                            isExpanded: true,
                            items: staffdetailsmodel
                                .map((GetStaffDetailsListModel staff) =>
                                    DropdownMenuItem<GetStaffDetailsListModel>(
                                      value: staff,
                                      child: Text(staff.staffName ?? '',
                                          style: AppTypography.dataRowValue),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStaff = value;
                                selectedReferredID = value?.staffId!.toInt();
                                selectedReferredName = value?.staffName!.toString();
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          // Consumer No.
                          _buildFieldLabel('Consumer No.', required: true),
                          const SizedBox(height: 6),
                          Form(
                            key: _formKeyConsumerNo,
                            child: TextFormField(
                              controller: _consumerNoController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              style: AppTypography.dataRowValue,
                              decoration: _inputDecoration(hint: 'Enter Consumer No.'),
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
                                _formKeyConsumerNo.currentState!.validate();
                              },
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Consumer Name
                          _buildFieldLabel('Consumer Name', required: true),
                          const SizedBox(height: 6),
                          Form(
                            key: _formKeyConsumerName,
                            child: TextFormField(
                              controller: _consumerNameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              style: AppTypography.dataRowValue,
                              decoration: _inputDecoration(hint: 'Enter Consumer Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Consumer Name is Required';
                                }
                                return null;
                              },
                              onTap: () {
                                _formKeyConsumerName.currentState!.validate();
                              },
                              onChanged: (value) { setState(() {}); },
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Item Name
                          _buildFieldLabel('Select Item Name', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<GetItemMasterListRegulatorListModel>(
                            key: formKey2,
                            value: itemDetailModel.isNotEmpty &&
                                    itemDetailModel.first.itemName != null &&
                                    itemDetailModel.first.itemId != null
                                ? itemDetailModel.first
                                : null,
                            decoration: _inputDecoration(hint: 'Select Item'),
                            isExpanded: true,
                            items: itemDetailModel
                                .map((GetItemMasterListRegulatorListModel item) =>
                                    DropdownMenuItem<
                                        GetItemMasterListRegulatorListModel>(
                                      value: item,
                                      child: Text(item.itemName ?? 'Unknown',
                                          style: AppTypography.dataRowValue),
                                    ))
                                .toList(),
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
                          ),
                          const SizedBox(height: 14),

                          // Regulator Defective Qty.
                          _buildFieldLabel('Regulator Defective Qty.', required: true),
                          const SizedBox(height: 6),
                          Form(
                            key: _formKeyItemName,
                            child: TextFormField(
                              controller: _defectiveItemController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              style: AppTypography.dataRowValue,
                              decoration:
                                  _inputDecoration(hint: 'Enter Defective Qty.'),
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
                                _formKeyItemName.currentState!.validate();
                              },
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Replacement Chargeable
                          _buildFieldLabel('Replacement Chargeable', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: formKey3,
                            value: regulatorReceived.contains(selectedRegulatorReceived)
                                ? selectedRegulatorReceived
                                : null,
                            decoration: _inputDecoration(hint: 'Select Yes / No'),
                            isExpanded: true,
                            items: regulatorReceived
                                .map((String v) => DropdownMenuItem<String>(
                                    value: v,
                                    child: Text(v, style: AppTypography.dataRowValue)))
                                .toList(),
                            onChanged: (value) {
                              setState(() { selectedRegulatorReceived = value; });
                            },
                          ),
                          const SizedBox(height: 14),

                          // â”€â”€ Conditional: Replacement Chargeable == Yes â”€â”€
                          if (selectedRegulatorReceived == "Yes") ...[
                            // Payment Amount
                            _buildFieldLabel('Payment Amt.', required: true),
                            const SizedBox(height: 6),
                            Form(
                              key: _formKeyPaymentAmt,
                              child: TextFormField(
                                controller: _paymentAmtController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.number,
                                style: AppTypography.dataRowValue,
                                decoration:
                                    _inputDecoration(hint: 'Enter Payment Amt.'),
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
                                  _formKeyPaymentAmt.currentState!.validate();
                                },
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Payment Mode
                            _buildFieldLabel('Payment Mode', required: true),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              key: formKey4,
                              value: selectedTransMode,
                              decoration: _inputDecoration(hint: 'Select Mode'),
                              isExpanded: true,
                              items: getTransMode
                                  .map((String v) => DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(v, style: AppTypography.dataRowValue)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() { selectedTransMode = value; });
                              },
                            ),
                            const SizedBox(height: 14),

                            // Online fields
                            if (selectedTransMode == 'Online') ...[
                              _buildFieldLabel('Bank Account No.', required: true),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<GetBankMappingDetailsListModel>(
                                isExpanded: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                value: bankModel.contains(_selectBankModel)
                                    ? _selectBankModel
                                    : null,
                                decoration: _inputDecoration(hint: 'Select Account'),
                                items: bankModel
                                    .map((item) => DropdownMenuItem<
                                            GetBankMappingDetailsListModel>(
                                          value: item,
                                          child: Text(
                                              '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                                              style: AppTypography.dataRowValue),
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
                              const SizedBox(height: 14),

                              _buildFieldLabel('Transaction Code', required: true),
                              const SizedBox(height: 6),
                              Form(
                                key: _formKeyTranCode,
                                child: TextFormField(
                                  controller: _transactionCodeController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: AppTypography.dataRowValue,
                                  decoration: _inputDecoration(
                                      hint: 'Enter Transaction Code'),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[^\u0000-\u007F]')),
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                  ],
                                  onChanged: (value) { setState(() {}); },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Transaction Code Required';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    _formKeyTranCode.currentState!.validate();
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildFieldLabel('Time'),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _transactionTimeController,
                                          style: AppTypography.dataRowValue,
                                          decoration: _inputDecoration(hint: 'HH:MM'),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                          onChanged: (value) { setState(() {}); },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              _buildFieldLabel('Transaction Remark'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _transactionRemarkController,
                                style: AppTypography.dataRowValue,
                                decoration:
                                    _inputDecoration(hint: 'Enter Tran. Remark'),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(250),
                                ],
                                onChanged: (value) { setState(() {}); },
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Cash denomination section
                            if (selectedTransMode == 'Cash') ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.blueXXL,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFFF1F5F9)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.monetization_on_outlined,
                                        color: AppColors.blue, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      cashDenominationMandatory
                                          ? 'Cash Denomination (Mandatory)'
                                          : 'Cash Denomination',
                                      style: AppTypography.dataRowLabel
                                          .copyWith(color: AppColors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFF1F5F9)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color(0x0D1E3A8A),
                                        blurRadius: 8,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: const BoxDecoration(
                                        color: AppColors.blueXXL,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 2,
                                              child: Center(child: Text(
                                                  'Note Type',
                                                  style:
                                                      AppTypography.dataRowLabel))),
                                          Expanded(flex: 3,
                                              child: Center(child: Text('Qty',
                                                  style:
                                                      AppTypography.dataRowLabel))),
                                          Expanded(flex: 3,
                                              child: Center(child: Text('Amount',
                                                  style:
                                                      AppTypography.dataRowLabel))),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          getNoteTypeAndIdFroDenominationListModel
                                              .length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            getNoteTypeAndIdFroDenominationListModel[
                                                index];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xFFF1F5F9))),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(flex: 2,
                                                  child: Center(child: Text(
                                                      '${data.noteType}',
                                                      style: AppTypography
                                                          .dataRowValue))),
                                              Expanded(flex: 1,
                                                  child: Center(child: Text('X',
                                                      style: AppTypography
                                                          .dataRowLabel))),
                                              Expanded(
                                                flex: 3,
                                                child: TextField(
                                                  controller:
                                                      qtyController[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        3),
                                                  ],
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTypography.dataRowValue,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 6),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                6),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFF1F5F9))),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                6),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFF1F5F9))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                6),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: AppColors
                                                                    .blue,
                                                                width: 1.5)),
                                                    filled: true,
                                                    fillColor: AppColors.bg2,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      amounts[index] =
                                                          (double.tryParse(
                                                                      value) ??
                                                                  0.0) *
                                                              data.noteType!;
                                                      totalAmount = amounts.fold(
                                                          0.0,
                                                          (sum, amount) =>
                                                              sum + amount);
                                                      final valueBal =
                                                          double.tryParse(
                                                              _paymentAmtController
                                                                  .text);
                                                      if (valueBal == null) {
                                                        showFlushBar(context,
                                                            Constants.cashAmount);
                                                      } else if (valueBal <
                                                          totalAmount) {
                                                        showFlushBar(context,
                                                            Constants.amountEqual);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(flex: 1,
                                                  child: Center(child: Text('=',
                                                      style: AppTypography
                                                          .dataRowLabel))),
                                              Expanded(flex: 3,
                                                  child: Center(child: Text(
                                                      amounts[index]
                                                          .toStringAsFixed(2),
                                                      style: AppTypography
                                                          .dataRowValue))),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('Amount : ',
                                              style: AppTypography.dataRowLabel),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.blueXXL,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                totalAmount.toStringAsFixed(2),
                                                style: AppTypography.dataRowValue
                                                    .copyWith(
                                                        color: AppColors.blue)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ],

                          // Remark
                          _buildFieldLabel('Remark'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _paymentRemarkController,
                            style: AppTypography.dataRowValue,
                            decoration: _inputDecoration(hint: 'Enter Remark'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(250),
                            ],
                            onChanged: (value) { setState(() {}); },
                          ),
                          const SizedBox(height: 20),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () { cancelAction(); },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.blue),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text('Cancel',
                                      style: AppTypography.labelMD
                                          .copyWith(color: AppColors.blue)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (saveFlag) {
                                      showFlushBar(
                                          context, Constants.dayEndCompleted);
                                    } else {
                                      if (modes == "Edit") {
                                        getRegulatorReceiptAddEdit(
                                            regRcptIdEdit!, "EDIT");
                                      } else {
                                        getRegulatorReceiptAddEdit(0, "ADD");
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        saveFlag ? AppColors.textMuted : AppColors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    modes == "Edit" ? 'Update' : 'Save',
                                    style: AppTypography.labelMD
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // â”€â”€ Records list â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0D1E3A8A),
                              blurRadius: 12,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: receiptDefList.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: receiptDefList.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) {
                                final tvSale = receiptDefList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header row: date + staff + actions
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(
                                                      tvSale.regDefRcptDate ??
                                                          '')),
                                              style: AppTypography.dataRowLabel
                                                  .copyWith(
                                                      color: AppColors.blue),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              tvSale.staffName.toString(),
                                              style: AppTypography.dataRowLabel
                                                  .copyWith(
                                                      color: AppColors.blue),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(Icons.edit_rounded,
                                                color: saveFlag
                                                    ? AppColors.textMuted
                                                    : AppColors.blue,
                                                size: 20),
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
                                              if (saveFlag) {
                                                showFlushBar(context, Constants.dayEndCompleted);
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
                                          const SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(Icons.delete_rounded,
                                                color: saveFlag
                                                    ? AppColors.textMuted
                                                    : AppColors.red,
                                                size: 20),
                                            onPressed: () async {
                                              if (saveFlag) {
                                                showFlushBar(context,
                                                    Constants.dayEndCompleted);
                                              } else {
                                                int? tvId = tvSale.regDefRcptId?.toInt();
                                                bool? confirmDelete =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  14)),
                                                      backgroundColor:
                                                          AppColors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                24),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .delete_forever_rounded,
                                                                color:
                                                                    AppColors.red,
                                                                size: 40),
                                                            const SizedBox(
                                                                height: 12),
                                                            Text('Delete Record?',
                                                                style:
                                                                    AppTypography
                                                                        .cardTitle),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                                'Are you sure you want to delete this record?',
                                                                style:
                                                                    AppTypography
                                                                        .cardSubtitle,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            const SizedBox(
                                                                height: 20),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: OutlinedButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop(false),
                                                                    style: OutlinedButton.styleFrom(
                                                                        side: const BorderSide(
                                                                            color: AppColors
                                                                                .blue),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8))),
                                                                    child: Text(
                                                                        'Cancel',
                                                                        style: AppTypography
                                                                            .labelMD
                                                                            .copyWith(
                                                                                color: AppColors.blue)),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop(true),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            AppColors
                                                                                .red,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8)),
                                                                        elevation:
                                                                            0),
                                                                    child: Text(
                                                                        'Delete',
                                                                        style: AppTypography
                                                                            .labelMD
                                                                            .copyWith(
                                                                                color: AppColors.white)),
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
                                                if (confirmDelete == true &&
                                                    tvId != null) {
                                                  getRegulatorReceiptAddEdit(
                                                      tvId, "DELETE");
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _listRow('Cons. No.', tvSale.consumerNo.toString()),
                                      const SizedBox(height: 4),
                                      _listRow('Cons. Name', tvSale.consumerName.toString()),
                                      const SizedBox(height: 4),
                                      _listRow('Item Name', tvSale.itemName.toString()),
                                      const SizedBox(height: 4),
                                      _listRow('Def. Qty.', tvSale.regDefRcptQty.toString()),
                                      const SizedBox(height: 4),
                                      _listRow('Mode', tvSale.paymentMode.toString()),
                                      const SizedBox(height: 4),
                                      _listRow('Pay Amt', tvSale.paidAmt.toString()),
                                      if ((tvSale.remark ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        _listRow('Remark', tvSale.remark.toString()),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                  child: Text('No Records Found',
                                      style: AppTypography.cardSubtitle)),
                            ),
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

  // â”€â”€ Private UI helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFieldLabel(String label, {bool required = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: AppTypography.labelMD.copyWith(color: AppColors.textMid)),
      if (required) ...[
        const SizedBox(width: 2),
        const Text('*',
            style: TextStyle(
                color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ]);
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.labelMD.copyWith(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5)),
      filled: true,
      fillColor: AppColors.bg2,
    );
  }

  Widget _listRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 90,
            child: Text(label,
                style: AppTypography.dataRowLabel
                    .copyWith(color: AppColors.textMuted))),
        const Text(' : ',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Expanded(
            child: Text(value, style: AppTypography.dataRowValue)),
      ],
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
    if (widget.disableNetworkCallsForTest) {
      return;
    }
    EasyLoading.instance
      ..maskType =
          EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
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
