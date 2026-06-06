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
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../SalaryPaymentScreen/GetCashDenominationDtlsByIdModel.dart';
import '../UpdatePaymentsScreen/GetExpenseHeaderListModel.dart';
import '../UpdatePaymentsScreen/GetPaymentdetailCashDenominationDtlModel.dart';
import 'ArbScreen.dart';
import 'GetARBItemPurListModel.dart';
import 'GetPaymentDetlARBPurLstModel.dart';

class AddPaymentPopupScreen extends StatefulWidget {
  static const screenName = '/addPaymentPopupScreen';

  const AddPaymentPopupScreen({super.key});

  @override
  State<AddPaymentPopupScreen> createState() => _AddPaymentPopupScreenState();
}

class _AddPaymentPopupScreenState extends State<AddPaymentPopupScreen> {

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  //List<GetPaymentdetailCashDenominationDtlModel> denominationModel = [];
  List<GetCashDenominationDtlsByIdModel> denominationModel = [];
  GetCashDenominationDtlsByIdModel? _selectDenomination;
  bool isLoading = true;
  // final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
 // bool saveFlag = false;
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  late final _balanceController = TextEditingController();
  bool isCashDenominationListViewVisible = false;
  List<GetExpenseHeaderListModel> expenseModel = [];
  List<GetPaymentDetlArbPurLstModel> paymentModel = [];
  GetExpenseHeaderListModel? selectedExpense;
  String? _selectedExp;
  int? selectedExpId;
  bool _isDepositEmpty = false;
  String? invoiceNo;
  String? vendorName;
  String? vendorId;
  String? totalBillAmt;
  String? balanceAmt;
  String? arbPurId;
  String? invoiceNoEdit;
  String? amountTotal;
  String? vendorNameEdit;
  String? vendorIdEdit;
  String? totalBillAmtEdit;
  String? balanceAmtEdit;
  int? arbPurIdEdit;
  String? modes;
  var argValue;
  //int? paymentIdEdit;
  int? paymentId;
  late Map<int, bool> isQtyFilled;
  late double finalAmountCashDeno;
  bool isEditMode = false;
  double? getEditTotalAmount;
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  bool isCashDenominationChecked = false;
  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    fetchBank();
    getNoteTypeAndIDList();
    getExpenseHeaderList();
    //checkAndSaveDayEndData();
    DateTime now = DateTime.now().toUtc();
     formattedDate = now.toIso8601String();

    Future.delayed(Duration.zero, ()  {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        invoiceNo = argValue["invoiceNoEdit"];
        vendorName = argValue["VendorNameEdit"];
        vendorId = argValue["VendorIdEdit"];
        totalBillAmt = argValue["totalBillAmtEdit"];
        balanceAmt = argValue["balanceAmt"];
        arbPurId = argValue["arbPurIdEdit"];

        getARBItemPaymentList(int.parse(arbPurId!));
      });
    });


    Future.delayed(Duration.zero, () async{

      argValue = ModalRoute.of(context)?.settings.arguments as Map;

      modes = argValue?["modeChange"]?? '';
      if (argValue != null  && argValue["paymentIdV"] != null) {
        isEditMode = true;
        String bankIdV = argValue["bankIdV"] ?? '';
        debugPrint("bank id1 $bankIdV");
        String paymentModeEdit = argValue["paymentModeV"] ?? '';
        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
        selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
        String transTimeEdit = argValue["transTimeV"] ?? '';
        timeController.text = transTimeEdit;
        String transationCodeEdit = argValue["transationCodeV"] ?? '';
        TranCodeController.text = transationCodeEdit;
        String transRemarkEdit = argValue["transRemarkV"] ?? '';
        transReviewController.text = transRemarkEdit;
        String expHeadNameEdit = argValue["expHeadNameV"] ?? '';
        _balanceController.text = amountTotalEdit.toString();
        remarkController.text = transRemarkEdit;
        amountTotal = argValue["amountTotalV"];

        getEditTotalAmount = double.tryParse(amountTotal!);
        print('balanceAmt$balanceAmt');
        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if(paymentModeEdit == "Bank") {
          selectedTransMode = 'Online';// fallback or handle invalid values
        }else{
          selectedTransMode = null;
        }
        await fetchBank();
        await fetchBank().whenComplete((){
          debugPrint("bank id2 $bankIdV");// wait for data first
          if (bankIdV != null && bankIdV is String && bankIdV.isNotEmpty && bankIdV != "null") {
            debugPrint("bank id3 $bankIdV");
            final match = bankModel.firstWhere(
                  (item) => item.bankId?.toString().trim() == bankIdV.trim(), // Convert bankId to string before calling trim()
              orElse: () => GetBankMappingDetailsListModel(),
              // fallback empty object
            );
            debugPrint("bank id4 $match");
            // Only set if a valid match found
            if ((match.bankId?.toString() ?? '').isNotEmpty) { // Convert bankId to string for comparison
              setState(() {
                debugPrint("bank id5 $match");
                _selectBankModel = match;
                selectedBankName = match.bankName;
                selectedBankId = match.accountNo;
                selecteBankIDApi = match.bankId?.toInt();
                accMappingId = match.mappingId?.toInt();
              });
            }else{
              debugPrint("bank id6 $match");
            }
          }else{
            debugPrint("bank id7 ");
          }
        });

        paymentId = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;

        getNoteTypeAndIDList().whenComplete((){
          getPaymentdetailCashDenominationDtl(int.parse(arbPurId!)).whenComplete((){
            if(denominationModel.isNotEmpty){
              initializeControllers();
            }else{
              debugPrint("empty");
            }
          });
        });


        getExpenseHeaderList().whenComplete((){
          selectedExpense = expenseModel.firstWhere(
                (item) => item.expHeadName == expHeadNameEdit,
            orElse: () => GetExpenseHeaderListModel(
              expHeadName: '',
            ),
          );
        });
      }
    });
  }

  // â”€â”€ Themed input decoration â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  InputDecoration _themedInput(String label, {bool required = false, String? errorText, Widget? labelWidget}) {
    return InputDecoration(
      labelText: labelWidget == null ? (required ? '$label *' : label) : null,
      label: labelWidget,
      errorText: errorText,
      errorStyle: const TextStyle(color: AppColors.red, fontSize: 11),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.blueLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
    );
  }

  Widget _infoTile(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.5),
            textScaler: TextScaler.noScaling),
        const SizedBox(height: 2),
        Text(value.isEmpty ? 'â€”' : value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.text),
            textScaler: TextScaler.noScaling),
      ],
    );
  }

  Widget _sectionLabel(String text, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 6, height: 6,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: dotColor, borderRadius: BorderRadius.circular(2)),
        ),
        Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMid, letterSpacing: 0.8),
            textScaler: TextScaler.noScaling),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A8A), Color(0xFF1D6B7A), Color(0xFF0F766E)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modes == "EDIT" ? "Update Payment" : "Add Payment",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                      textScaler: TextScaler.noScaling,
                    ),
                    Text(
                      vendorName ?? '',
                      style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w400),
                      textScaler: TextScaler.noScaling,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // â”€â”€ Invoice Summary Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: const Border(top: BorderSide(color: AppColors.blue, width: 3)),
                boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Column(
                children: [
                  // header bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.blueXL,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: AppColors.blue, size: 16),
                        const SizedBox(width: 8),
                        _sectionLabel("INVOICE SUMMARY", AppColors.blue),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(child: _infoTile("Invoice No.", invoiceNo ?? '')),
                        Expanded(child: _infoTile("Vendor", vendorName ?? '')),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(child: _infoTile("Total Bill Amt", totalBillAmt ?? '', valueColor: AppColors.text)),
                        Expanded(
                          child: _infoTile(
                            "Balance Amt",
                            balanceAmt ?? '',
                            valueColor: (double.tryParse(balanceAmt ?? '0') ?? 0) > 0 ? AppColors.red : AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // â”€â”€ Payment Form Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: const Border(top: BorderSide(color: AppColors.teal, width: 3)),
                boxShadow: [BoxShadow(color: AppColors.teal.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("PAYMENT DETAILS", AppColors.teal),
                  const SizedBox(height: 14),

                  // Payment Mode
                  DropdownButtonFormField<String>(
                    key: formKey1,
                    decoration: _themedInput('Payment Mode', required: true),
                    value: selectedTransMode,
                    items: getTransMode.map((String value) =>
                        DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                    onChanged: (value) { setState(() { selectedTransMode = value; }); },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 12),

                  // Expense Head
                  DropdownButtonFormField<GetExpenseHeaderListModel>(
                    isExpanded: true,
                    key: formKey2,
                    decoration: _themedInput('Expense Head', required: true),
                    value: expenseModel.contains(selectedExpense) ? selectedExpense : null,
                    items: expenseModel.map((item) => DropdownMenuItem<GetExpenseHeaderListModel>(
                      value: item,
                      child: Text(item.expHeadName ?? '', style: const TextStyle(fontSize: 14)),
                    )).toList(),
                    onChanged: (selectedItem) {
                      setState(() {
                        selectedExpense = selectedItem;
                        _selectedExp = selectedItem?.expHeadName ?? '';
                        selectedExpId = selectedItem?.expHeadId?.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Paid Amount
                  TextField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      LengthLimitingTextInputFormatter(9),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _isDepositEmpty = value.isEmpty;
                        double val = double.tryParse(value.replaceAll(',', '')) ?? 0;
                        num? balanceAmtNum = num.tryParse(balanceAmt!);
                      });
                    },
                    decoration: _themedInput('Paid Amount', required: true,
                        errorText: _isDepositEmpty ? 'Amount is required' : null),
                  ),
                  const SizedBox(height: 8),

                  // Cash Denomination toggle
                  if (selectedTransMode == 'Cash')
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tealXL,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.tealXXL),
                      ),
                      child: CheckboxListTile(
                        title: const Text(
                          "Cash Denomination",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.teal),
                        ),
                        value: isCashDenominationChecked,
                        onChanged: (bool? value) { setState(() { isCashDenominationChecked = value ?? false; }); },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                  // Online fields
                  if (selectedTransMode == 'Online') ...[
                    const SizedBox(height: 4),
                    DropdownButtonFormField<GetBankMappingDetailsListModel>(
                      decoration: _themedInput('Select Account No.', required: true),
                      value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                      isExpanded: true,
                      items: bankModel.map((item) => DropdownMenuItem<GetBankMappingDetailsListModel>(
                        value: item,
                        child: Text('${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                            style: const TextStyle(fontSize: 13)),
                      )).toList(),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TranCodeController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(30),
                              FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')),
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            decoration: _themedInput('Transaction Code', required: true,
                                errorText: _isTranscode ? 'Transaction code is Required' : null),
                            onChanged: (value) { setState(() { _isTranscode = value.isEmpty; }); },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            decoration: _themedInput('Time'),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}:?$')),
                            ],
                            onChanged: (value) { setState(() {}); },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: transReviewController,
                      decoration: _themedInput('Transaction Remark'),
                      inputFormatters: [LengthLimitingTextInputFormatter(250)],
                      onChanged: (value) { setState(() {}); },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // â”€â”€ Cash Denomination Table â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (selectedTransMode == "Cash" && isCashDenominationChecked)
              GestureDetector(
                onTap: () { setState(() { isCashDenominationListViewVisible = !isCashDenominationListViewVisible; }); },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    children: [
                      // Gradient header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)],
                          ),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.money_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cashDenominationMandatory ? "CASH DENOMINATION (MANDATORY)" : "CASH DENOMINATION",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.8),
                                textScaler: TextScaler.noScaling,
                              ),
                            ),
                            Icon(
                              isCashDenominationListViewVisible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: Colors.white, size: 20,
                            ),
                          ],
                        ),
                      ),
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        color: AppColors.blueXL,
                        child: const Row(
                          children: [
                            Expanded(flex: 2, child: Text("Note Type", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.blue), textAlign: TextAlign.center, textScaler: TextScaler.noScaling)),
                            Expanded(flex: 3, child: Text("Qty", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.blue), textAlign: TextAlign.center, textScaler: TextScaler.noScaling)),
                            Expanded(flex: 3, child: Text("Amount", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.blue), textAlign: TextAlign.center, textScaler: TextScaler.noScaling)),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: getNoteTypeAndIdFroDenominationListModel.length,
                        itemBuilder: (context, index) {
                          final data = getNoteTypeAndIdFroDenominationListModel[index];
                          final bool isEven = index % 2 == 0;
                          return Container(
                            color: isEven ? AppColors.blueXXL.withValues(alpha: 0.35) : AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("${data.noteType}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text), textAlign: TextAlign.center, textScaler: TextScaler.noScaling),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child: Center(child: Text("Ã—", style: TextStyle(fontSize: 13, color: AppColors.textMuted))),
                                // ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: TextField(
                                      controller: qtyController[index],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;
                                          totalAmount = amounts.fold(0.0, (sum, amount) => sum + amount);
                                          debugPrint("totalAmount: $totalAmount");
                                          final valueBal = double.tryParse(_balanceController.text);
                                          if (valueBal == null) {
                                            showFlushBar(context, Constants.cashAmount);
                                          } else if (valueBal < totalAmount) {
                                            showFlushBar(context, Constants.amountEqual);
                                          }
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.blueLight, width: 1.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(child: Text("=", style: TextStyle(fontSize: 13, color: AppColors.textMuted))),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(amounts[index].toStringAsFixed(2),
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text), textAlign: TextAlign.center, textScaler: TextScaler.noScaling),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Total row
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.blueXL,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Total Amount : ",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.blue),
                                textScaler: TextScaler.noScaling),
                            Text(totalAmount.toStringAsFixed(2),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.blue),
                                textScaler: TextScaler.noScaling),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // â”€â”€ Action Buttons â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () { cancelAction(); },
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textMid,
                      side: const BorderSide(color: AppColors.border2, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF2D52C5)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: const Color(0xFF1E3A8A).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (modes == "EDIT") {
                          paymentDetailsAddEditForMob(paymentId!, "EDIT");
                        } else {
                          paymentDetailsAddEditForMob(0, "ADD");
                        }
                      },
                      icon: Icon(modes == "EDIT" ? Icons.update_rounded : Icons.save_rounded, size: 16),
                      label: Text(modes == "EDIT" ? 'Update Payment' : 'Save Payment',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // â”€â”€ Payment History â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (paymentModel.isNotEmpty) ...[
              _sectionLabel("PAYMENT HISTORY", AppColors.orange),
              const SizedBox(height: 10),
            ],
            ...paymentModel.asMap().entries.map((entry) {
              final index = entry.key;
              final GetPaymentDetlArbPurLstModel payList = entry.value;
              final bool canEdit = !(balanceAmt == "0" || balanceAmt == "0.0");
              final bool canDelete = (double.tryParse(balanceAmt!) ?? 0) != 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border(left: BorderSide(
                    color: index % 2 == 0 ? AppColors.teal : AppColors.blueLight,
                    width: 4,
                  )),
                  boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(payList.expHeadName ?? '',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text),
                                textScaler: TextScaler.noScaling),
                          ),
                          Text(
                            payList.paymentDate != null
                                ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.paymentDate!))
                                : '',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            textScaler: TextScaler.noScaling,
                          ),
                          Opacity(
                            opacity: canEdit ? 1.0 : 0.3,
                            child: IconButton(
                              icon: const Icon(Icons.edit_rounded, color: AppColors.blueLight, size: 18),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (balanceAmt == "0" || balanceAmt == "0.0") {
                                  debugPrint("noedit");
                                } else {
                                  setState(() {
                                    var paymentMode = payList.paymentMode.toString();
                                    var expHeadId = payList.expHeadId.toString();
                                    var transTime = payList.transTime.toString();
                                    var arbPurId = payList.aRBPurId.toString();
                                    var transationCode = payList.transationCode.toString();
                                    var transRemark = payList.transRemark.toString();
                                    var expHeadName = payList.expHeadName.toString();
                                    var bankId = payList.bankId.toString();
                                    var mappingId = payList.bankMappingId.toString();
                                    var accountNo = payList.accountNo.toString();
                                    var paymentId = payList.paymentId.toString();
                                    var amountTotal = payList.totalAmtPaid.toString();
                                    int payId = int.parse(paymentId);
                                    if (saveFlag) {
                                      print('saveFlag $saveFlag');
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      Navigator.pushNamed(context, AddPaymentPopupScreen.screenName, arguments: {
                                        'paymentModeV': paymentMode,
                                        'expHeadId': expHeadId,
                                        'transTimeV': transTime,
                                        'transationCodeV': transationCode,
                                        'transRemarkV': transRemark,
                                        'expHeadNameV': expHeadName,
                                        'arbPurIdEditV': arbPurId,
                                        'bankIdV': bankId,
                                        'mappingIdV': mappingId,
                                        'accountNoV': accountNo,
                                        'paymentIdV': paymentId,
                                        'amountTotalV': amountTotal,
                                        'modeChange': "EDIT",
                                        "invoiceNoEdit": invoiceNo,
                                        "VendorNameEdit": vendorName,
                                        "VendorIdEdit": vendorId,
                                        "totalBillAmtEdit": totalBillAmt,
                                        "balanceAmt": balanceAmt,
                                        "arbPurIdEdit": arbPurId,
                                        "amountTotalV": amountTotal,
                                      });
                                    }
                                    // Navigate to the target screen and pass the data
                                  });
                                }
                              },
                            ),
                          ),
                          Opacity(
                            opacity: canDelete ? 1.0 : 0.3,
                            child: IconButton(
                              icon: const Icon(Icons.delete_rounded, color: AppColors.red, size: 18),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                if (saveFlag) {
                                  showFlushBar(context, Constants.dayEndCompleted);
                                } else {
                                  double? parsedBalance = double.tryParse(balanceAmt!);
                                  int? pId = (payList.paymentId)?.toInt();
                                  if (parsedBalance != null && parsedBalance != 0.0) {
                                    bool? confirmDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 52, height: 52,
                                                  decoration: BoxDecoration(color: AppColors.redXL, borderRadius: BorderRadius.circular(14)),
                                                  child: const Icon(Icons.delete_rounded, color: AppColors.red, size: 28),
                                                ),
                                                const SizedBox(height: 16),
                                                const Text('Delete Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                                                const SizedBox(height: 8),
                                                const Text('Are you sure you want to delete this payment record?', textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4)),
                                                const SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: OutlinedButton(
                                                        onPressed: () => Navigator.of(ctx).pop(false),
                                                        style: OutlinedButton.styleFrom(
                                                          foregroundColor: AppColors.textMid,
                                                          side: const BorderSide(color: AppColors.border2),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                                        ),
                                                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () => Navigator.of(ctx).pop(true),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: AppColors.red,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                                        ),
                                                        child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
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
                                    if (confirmDelete == true) {
                                      if (pId != null) {
                                        paymentDetailsAddEditForMob(pId, "DELETE");
                                        print('Delete button pressed $pId');
                                      } else {
                                        print("Receipt ID is null.");
                                      }
                                    } else {
                                      print('Delete action was canceled');
                                    }
                                  } else {
                                    print('Balance is 0. Cannot delete.');
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _payChip(Icons.account_balance_wallet_rounded, payList.paymentMode == "Bank" ? "Online" : (payList.paymentMode ?? ''), AppColors.teal),
                          _payChip(Icons.currency_rupee_rounded, formatCurrency(payList.totalAmtPaid!.toDouble()), AppColors.blue),
                          if ((payList.transationCode ?? '').isNotEmpty && payList.transationCode.toString() != 'null')
                            _payChip(Icons.tag_rounded, payList.transationCode.toString(), AppColors.orange),
                          if ((payList.transTime ?? '').isNotEmpty && payList.transTime.toString() != 'null')
                            _payChip(Icons.access_time_rounded, payList.transTime.toString(), AppColors.textMuted),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            if (paymentModel.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: const Center(
                  child: Column(children: [
                    Icon(Icons.receipt_long_rounded, color: AppColors.border2, size: 36),
                    SizedBox(height: 8),
                    Text('No payment records found', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _payChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color), textScaler: TextScaler.noScaling),
        ],
      ),
    );
  }
  // â”€â”€ End of build method â”€â”€

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

  Future<void> getExpenseHeaderList() async {
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
      Uri.parse('${AppUrl.GetExpenseHeaderList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetExpenseHeaderList : " +
        '${AppUrl.GetExpenseHeaderList}/$distributorId/1');
    debugPrint("GetExpenseHeaderList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        expenseModel = data.map((json) {
          return GetExpenseHeaderListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> paymentDetailsAddEditForMob(int paymentId ,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);

    double totalAmt = 0.0;
    String remark = '';
    int? bankId;
    int? accMappingIds;
    String? tranCode;
    String? tranTime;
    int? vendorId;
    //int? arbPurId;

    // if(paymentData?.vendorId != null ){
    //   //int vendorId =
    //   vendorId = paymentData?.vendorId;
    // }

    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
      };
    }).toList();

    if (action != "DELETE") {
      // Parse amount if not empty
      if (_balanceController.text.isNotEmpty) {
        totalAmt = double.parse(_balanceController.text);
      }

      double? balanceAmtNum = double.tryParse(balanceAmt!);

      // Validate amount doesn't exceed total
      if(selectedTransMode == "Cash"){
        if(totalAmount > 0){
          if (totalAmt != totalAmount) {
            showFlushBar(context, "Amount exceeds total amount");
            return;
          }
        }
      }
      if(cashDenominationMandatory){
        if(selectedTransMode == "Cash"){
          if(totalAmount > 0){
            if (totalAmt != totalAmount) {
              showFlushBar(context, "Amount exceeds total amount");
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }
      double? editAmt;
      if(modes == "EDIT"){
        editAmt = getEditTotalAmount! + balanceAmtNum!;
        debugPrint("getEditTotalAmount $getEditTotalAmount");
        debugPrint("balanceAmtNum $balanceAmtNum");
        if (totalAmt > editAmt) {
          debugPrint("editAmt $editAmt");
          showFlushBar(context, "Paid amount cannot be greater than balance amount ");
          return;
        }
      }else{
        if (totalAmt > balanceAmtNum!) {
          debugPrint("balanceAmtNum $balanceAmtNum");
          showFlushBar(context, "Paid amount cannot be greater than balance amount ");
          return;
        }
      }

      // Validate paid amount is less than or equal to balance


      // Get transaction code
      tranCode = TranCodeController.text.isNotEmpty ? TranCodeController.text : "";

      // Get transaction time
      tranTime = timeController.text.isNotEmpty ? timeController.text : "";

      // Get remark if present
      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
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

      if (selectedExpense == null) {
        showFlushBar(context, "Please select expense");
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
    }

    final Map<String, dynamic> requestBody =
    {
        "PaymentId":paymentId,
        "DistributorId":distributorId,
        "ARBPurId":arbPurId,
        "PaymentMode":selectedTransMode ?? '',
        "VendorId":vendorId ?? '',
        "ExpHeadId":selectedExpId ?? '',
        "CashCollDenomId":0,
        "BankId":bankId,
        "BankMappingId":accMappingIds ?? '',
        "TransactionCode": tranCode ?? '',
        "TransTime":tranTime ?? '',
        "TotalAmt":totalAmt,
        "TransRemark": remark ?? '',
        "Action":action,
        "AddedBy":userId ?? '',
        "UpdatedFrom":"MOB",
        "CashDenominationList":dataCashDenomination,
        "PaymentDate":formattedDate,

    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PaymentDetailsAdd}'),
      //InventoryStock/PaymentDetailsAdd
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody PaymentDetailsAdd: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // totalAmount = totalAmount - discountAmt;

        // Process the valid response (JSON or data)
        print("Response AddEditARBItemPurchase: ${response.body}");

        Navigator.pushNamed(
          context,
          ArbScreen.screenName,
        );

        Future.delayed(Duration(milliseconds: 300), () {
          if (action == "DELETE") {
            EasyLoading.showToast(
              Constants.expenseSendMgrDelete,
              duration: const Duration(milliseconds: 3000),
            );
          }else if(action == "EDIT") {
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
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> getARBItemPaymentList(int? arbPurId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    // int? arbPurId = prefs.getInt('ARBPurId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetPaymentDetlARBPurLst}/$distributorId/$arbPurId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("PaymentDetailsAdd : " +
        '${AppUrl.GetPaymentDetlARBPurLst}/$distributorId/$arbPurId');
    debugPrint("PaymentDetailsAdd : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) {
          return GetPaymentDetlArbPurLstModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getPaymentdetailCashDenominationDtl(int ArbPurId) async {
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
      Uri.parse('${AppUrl.GetARBItemPurCashDenoDtlsById}/$ArbPurId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemPurCashDenoDtlsById : " +
        '${AppUrl.GetARBItemPurCashDenoDtlsById}/$ArbPurId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetARBItemPurCashDenoDtlsById : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetCashDenominationDtlsByIdModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // Future<void> checkAndSaveDayEndData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? StaffId = prefs.getString('StaffId');
  //   int? staffIds = int.parse(StaffId!);
  //   int? distributorIds = int.parse(distributorId!);
  //   try {
  //     // Make the GET request
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
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
  //         // If there is data in the response, process it and save
  //         var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)
  //
  //         // You can validate the fields in the response as needed
  //         int DSRSaved = dayEndData['DSRSaved'] ?? 0;
  //         int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
  //         int OpClSaved = dayEndData['OpClSaved'] ?? 0;
  //
  //         // Check if all required fields are saved
  //         if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
  //           saveFlag = true;
  //           // If the conditions are met, set the flag and save the data
  //           print("Data is valid, proceeding to save.");
  //         } else {
  //           // If any condition is not met, print a message
  //           print("Data is incomplete. Cannot proceed to save.");
  //         }
  //       }
  //     } else {
  //       // Handle API error
  //
  //       print("Error: ${response.statusCode}");
  //     }
  //   }
  //   catch (e) {
  //
  //     // Exception handling
  //     print("Exception: $e");
  //   }
  // }

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
      selectedExpense = null;
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
}
