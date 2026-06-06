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
import '../CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../ManagerMoreScreen.dart';
import 'GetBalanceByStaffIdModel.dart';
import 'GetCashHandOverDtlsListModel.dart';
import 'GetExpenseHeaderListModel.dart';
import 'GetPaymentDetailListModel.dart';
import 'GetPaymentdetailCashDenominationDtlModel.dart';
import 'GetStaffDetailsListModel.dart';
import 'GetVehicleDetailsByStaffIdModel.dart';
import 'GetVendorMasterListModel.dart';


class UpdatePaymentScreen extends StatefulWidget {
  static const screenName = '/updatePaymentScreen';
  final bool disableNetworkCallsForTest;

  const UpdatePaymentScreen({super.key, this.disableNetworkCallsForTest = false});

  @override
  State<UpdatePaymentScreen> createState() => _UpdatePaymentScreenState();
}
class _UpdatePaymentScreenState extends State<UpdatePaymentScreen>{

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // final DateTime now = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  List<String> getTransStaff = ["Staff", "Vendor"];
  String? selectedStaff = "Staff";

  late List<TextEditingController> qtyController;
  late List<double> amounts;
  double totalAmount = 0.0;
  late double finalAmountCashDeno;
  late Map<int, bool> isQtyFilled;

  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  late final _balanceController = TextEditingController();
  bool _isDepositEmpty = false;
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isCashDenominationListViewVisible = false;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  bool isLoading = true;
  List<GetBankMappingDetailsListModel> bankModel = [];
  List<GetPaymentDetailListModel> paymentModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetVendorMasterListModel> vendorModel = [];
  GetVendorMasterListModel? _selectVendor;
  List<GetPaymentdetailCashDenominationDtlModel> denominationModel = [];
  GetPaymentdetailCashDenominationDtlModel? _selectDenomination;
  String? selectedBankName;
  String? selectedBankId;
  double? valueBal;
  bool _isTranscode = false;
  bool _isVendorName = false;
  String? receiptNoText;
  String? receiptNoTextEdit;
  List<dynamic> dataCashInHandList = [];
  DateTime selectedDate = DateTime.now();
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  double? totalamt;
  String? userName,userId;
  List<GetStaffDetailsListModel> staffmodel = [];
  List<GetVehicleDetailsByStaffIdModel> vehiclemodel = [];
  List<GetBalanceByStaffIdModel> balancemodel = [];
  GetStaffDetailsListModel? selectedstaff;
  List<GetExpenseHeaderListModel> expenseModel = [];
  GetExpenseHeaderListModel? selectedExpense;
  String? _selectedItem;
  int? selectedItemId;
  String? _selectedExp;
  int? selectedExpId;
  String? _selectedVendor;
  int? vendorId;
  String? _errorText;
  bool _isConCOntactEmpty = false;
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  String balanceAmount = '';
  String vehicleNumber = '';
  int? vehicleId = 0;
  int? selecteBankIDApi;
  int? accMappingId;
  bool isEditing = false;
  var argValue;
  String? modes;
  int? paymentId;
  int? payId;
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
    checkCashDenominationFlagMandatory();
    checkAndSaveDayEndData();
    getNoteTypeAndIDList();
    fetchBank();
    fetchSavedData();
    getCashHandOverDtlsList(selectedDate);
    getStaffDetailsList();
    getVendorMasterList();
    getExpenseHeaderList();
    loadInitialStaffData();
    getPaymentDetailList();
    getVoucherNoForExpense();

    Future.delayed(Duration.zero, ()  async{

        argValue = ModalRoute.of(context)?.settings.arguments as Map?;
        modes = argValue?['modeChange'] ?? '';
        if (argValue != null) {
          String payVoucherNoEdit = argValue["payVoucherNoV"] ?? 0;
          receiptNoTextEdit = payVoucherNoEdit;
          String depositDateEdit = argValue["depositDateV"] ?? 0;
          String paymentModeEdit = argValue["paymentModeV"] ?? 0;
          // selectedTransMode = paymentModeEdit;
          String paymentToIDEdit = argValue["paymentToIDV"] ?? 0;
          String staffNameEdit = argValue["staffNameV"] ?? 0;
          // selectedItemId = argValue["staffIdV"] ?? 0;
          selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;
          vendorId = int.tryParse(argValue["vendorIdV"] ?? '') ?? 0;
          vehicleId = int.tryParse(argValue["vehIdV"] ?? '') ?? 0;

          if (getTransMode.contains(paymentModeEdit)) {
            selectedTransMode = paymentModeEdit;
          } else if (paymentModeEdit == "Bank") {
            selectedTransMode = 'Online'; // fallback or handle invalid values
          } else {
            selectedTransMode = null;
          }
          // String payVoucherNoEdit = argValue["payVoucherNoV"] ?? 0;
          // receiptNoText = payVoucherNoEdit;


          // vendorId = argValue["vendorIdV"] ?? 0;
          // vehicleId = argValue["vehIdV"] ?? 0;
          String vehicleNoEdit = argValue["vehicleNoV"] ?? 0;
          // double amountTotalEdit = argValue["amountTotalV"] ?? 0;
          double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
          // selectedExpId = argValue["expHeadId"] ?? 0;
          selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
          String payRemarkEdit = argValue["payRemarkV"] ?? 0;
          String transTimeEdit = argValue["transTimeV"] ?? 0;
          timeController.text = transTimeEdit;
          String transationCodeEdit = argValue["transationCodeV"] ?? 0;
          TranCodeController.text = transationCodeEdit;
          String transRemarkEdit = argValue["transRemarkV"] ?? 0;
          transReviewController.text = transRemarkEdit;
          String expHeadNameEdit = argValue["expHeadNameV"] ?? 0;

          _balanceController.text = amountTotalEdit.toString();
          remarkController.text = transRemarkEdit;
          // selecteBankIDApi = argValue["bankIdV"] ?? 0;
          // accMappingId = argValue["mappingIdV"] ?? 0;
          String accountNoEdit = argValue["accountNoV"] ?? 0;
          selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
          accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
          _selectBankModel = bankModel.firstWhere(
                (item) => item.accountNo == accountNoEdit,
            orElse: () => GetBankMappingDetailsListModel(
              bankName: 'Default Bank',
              accountNo: '',
            ),
          );

          paymentId = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          getNoteTypeAndIDList().whenComplete((){
            getPaymentdetailCashDenominationDtl(paymentId!).whenComplete((){
              if(denominationModel.isNotEmpty){
                initializeControllers();
              }else{
                debugPrint("empty");
              }
            });
          });
          // int? paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          //
          // getPaymentdetailCashDenominationDtl(paymentIdEdit).whenComplete(() {
          //   if (denominationModel.isNotEmpty) {
          //     initializeControllers();
          //   } else {
          //     debugPrint("empty");
          //   }
          // });
          //   paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          //   if(selectedItemId != 0){
          //     selectedStaff = "Staff";
          //     getStaffDetailsList().whenComplete((){
          //       selectedstaff = staffmodel.firstWhere(
          //             (item) => item.staffName == staffNameEdit,
          //         orElse: () => GetStaffDetailsListModel(
          //           staffName: '',
          //
          //         ),
          //       );
          //     });
          // debugPrint("dgkjsljg");
          //   }
          //paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;

          if (selectedItemId != 0) {
            selectedStaff = "Staff";
          }
          else if( vendorId != 0){
            selectedStaff = "Vendor";
          }
          await getStaffDetailsList();
          getStaffDetailsList().whenComplete(() {
            selectedstaff = staffmodel.firstWhere(
                  (item) => item.staffId == selectedItemId,
              orElse: () => GetStaffDetailsListModel(staffName: ''),
            );

            // Call balance and vehicle details functions when editing
            if (selectedstaff?.staffId != null) {
              getBalanceByStaffId(selectedstaff!.staffId.toString());
              getVehicleDetailsByStaffId(selectedstaff!.staffId.toString());
            }

            debugPrint("Staff selected during edit: ${selectedstaff?.staffName}");
          });
          await getVendorMasterList();
          getVendorMasterList().whenComplete((){
            _selectVendor = vendorModel.firstWhere(
                  (item) => item.vendorId == vendorId,
              orElse: () => GetVendorMasterListModel(vendorName: ''),
            );
            debugPrint("vendorName $_selectVendor");
          });

          debugPrint("feffefefef$staffNameEdit");
         await getExpenseHeaderList();
          getExpenseHeaderList().whenComplete((){
            selectedExpense = expenseModel.firstWhere(
                  (item) => item.expHeadName == expHeadNameEdit,
              orElse: () => GetExpenseHeaderListModel(
                expHeadName: '',
              ),
            );
          });
          // loadDenominationData(psvIdEdit!);

          await fetchBank();
          if(accountNoEdit.isNotEmpty && accountNoEdit != "null"){
            final match = bankModel.firstWhere(
                  (item) => item.accountNo?.trim() == accountNoEdit.trim(),
              orElse: () => GetBankMappingDetailsListModel(),
            );

            if((match.accountNo ?? '').isNotEmpty){
              setState(() {
                _selectBankModel = match;
              });
            }
          }
        }

    });
  }

  // ─── themed field decoration ───────────────────────────────────────────────
  InputDecoration _fieldDecoration(String label, {String? errorText, bool required = false}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      labelStyle: AppTypography.dataRowLabel.copyWith(color: AppColors.blue),
      filled: true,
      fillColor: AppColors.white,
      errorText: errorText,
      errorStyle: const TextStyle(color: Colors.red),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.blue.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _infoTile(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.blue),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(label, style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600)),
          ),
          Text(value, style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.blue.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AppColors.blue),
                  const SizedBox(width: 8),
                ],
                Text(title, style: AppTypography.cardTitle.copyWith(color: AppColors.blue, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
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
        appBar: CustomAppBarManagerr(
          title: 'Update Payment',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Header ──────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradPrimary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.payment_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Update Payment', style: AppTypography.cardTitle.copyWith(color: AppColors.white, fontSize: 18)),
                            const SizedBox(height: 2),
                            Text('Review and update voucher details', style: AppTypography.heroSubtitle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Summary Info Card ────────────────────────────────────
                _sectionCard(
                  title: 'Voucher Summary',
                  icon: Icons.receipt_long_rounded,
                  children: [
                    _infoTile('Cash In Hand', formatCurrency(totalamt ?? 0), icon: Icons.account_balance_wallet_outlined),
                    const Divider(height: 16),
                    _infoTile('Pay Voucher No.', modes == "EDIT" ? (receiptNoTextEdit ?? '') : (receiptNoText ?? ''), icon: Icons.confirmation_number_outlined),
                    const Divider(height: 16),
                    _infoTile('Deposit Date', formattedDate, icon: Icons.calendar_today_outlined),
                  ],
                ),

                // ── Payment Mode Card ────────────────────────────────────
                _sectionCard(
                  title: 'Payment Mode',
                  icon: Icons.credit_card_rounded,
                  children: [
                    DropdownButtonFormField<String>(
                      key: formKey1,
                      decoration: _fieldDecoration('Payment Mode *'),
                      value: selectedTransMode,
                      items: getTransMode.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                      onChanged: (value) { setState(() { selectedTransMode = value; }); },
                      isExpanded: true,
                    ),
                    if (selectedTransMode == 'Cash') ...[
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.blue.withOpacity(0.04),
                        ),
                        child: CheckboxListTile(
                          title: Text("Cash Denomination", style: AppTypography.dataRowLabel.copyWith(fontWeight: FontWeight.w500)),
                          value: isCashDenominationChecked,
                          activeColor: AppColors.blue,
                          onChanged: (bool? value) { setState(() { isCashDenominationChecked = value ?? false; }); },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                    if (selectedTransMode == "Online") ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<GetBankMappingDetailsListModel>(
                        value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                        decoration: _fieldDecoration('Select Bank Account *'),
                        items: bankModel.map((item) => DropdownMenuItem<GetBankMappingDetailsListModel>(
                          value: item,
                          child: Text('${item.bankName ?? ''} - ${item.accountNo ?? ''}'),
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
                        hint: const Text('Select Acc No'),
                        isExpanded: true,
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
                              decoration: _fieldDecoration('Transaction Code *', errorText: _isTranscode ? 'Transaction code is Required' : null),
                              onChanged: (value) { setState(() { _isTranscode = value.isEmpty; }); },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: timeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: _fieldDecoration('Time'),
                              onChanged: (value) { setState(() {}); },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: transReviewController,
                        inputFormatters: [LengthLimitingTextInputFormatter(250)],
                        decoration: _fieldDecoration('Transaction Remark'),
                        maxLines: 2,
                        onChanged: (value) { setState(() {}); },
                      ),
                    ],
                  ],
                ),

                // ── Payment To Card ──────────────────────────────────────
                _sectionCard(
                  title: 'Payment To',
                  icon: Icons.person_rounded,
                  children: [
                    DropdownButtonFormField<String>(
                      key: formKey2,
                      decoration: _fieldDecoration('Payment To *'),
                      value: selectedStaff,
                      items: ['Vendor', 'Staff'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                      onChanged: (value) { setState(() { selectedStaff = value!; }); },
                      isExpanded: true,
                    ),
                    if (selectedStaff == "Staff") ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<GetStaffDetailsListModel>(
                        isExpanded: true,
                        key: formKey3,
                        decoration: _fieldDecoration('Staff Name *'),
                        value: staffmodel.contains(selectedstaff) ? selectedstaff : null,
                        items: staffmodel.map((item) => DropdownMenuItem<GetStaffDetailsListModel>(
                          value: item,
                          child: Text(item.staffName ?? '', style: Styling.itemBlackTest),
                        )).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            selectedstaff = selectedItem;
                            _selectedItem = selectedItem?.staffName ?? '';
                            selectedItemId = selectedItem?.staffId?.toInt();
                          });
                          if (selectedItem?.staffId != null) {
                            getBalanceByStaffId(selectedItem!.staffId.toString());
                            getVehicleDetailsByStaffId(selectedItem.staffId.toString());
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.blue.withOpacity(0.15)),
                        ),
                        child: Column(
                          children: [
                            _infoTile('Balance', balanceAmount.isNotEmpty ? balanceAmount : '--', icon: Icons.account_balance_outlined),
                            const Divider(height: 12),
                            _infoTile('Vehicle No', vehicleNumber.isNotEmpty ? vehicleNumber : 'MH12A0000', icon: Icons.directions_car_outlined),
                          ],
                        ),
                      ),
                    ],
                    if (selectedStaff == "Vendor") ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Vendor Name *', style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () { setState(() { _showAddVendorPopup(); }); },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              backgroundColor: AppColors.blue,
                              elevation: 2,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<GetVendorMasterListModel>(
                        isExpanded: true,
                        key: formKey5,
                        decoration: _fieldDecoration('Select Vendor'),
                        value: vendorModel.contains(_selectVendor) ? _selectVendor : null,
                        items: vendorModel.map((item) => DropdownMenuItem<GetVendorMasterListModel>(
                          value: item,
                          child: Text(item.vendorName ?? '', style: Styling.itemBlackTest),
                        )).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectVendor = selectedItem;
                            _selectedVendor = selectedItem?.vendorName ?? '';
                            vendorId = selectedItem?.vendorId?.toInt();
                          });
                          validator: (value) {
                            if (value == null) { return 'Please select a vendor'; }
                            return null;
                          };
                        },
                      ),
                    ],
                  ],
                ),

                // ── Expense & Amount Card ────────────────────────────────
                _sectionCard(
                  title: 'Expense & Amount',
                  icon: Icons.attach_money_rounded,
                  children: [
                    DropdownButtonFormField<GetExpenseHeaderListModel>(
                      isExpanded: true,
                      key: formKey6,
                      decoration: _fieldDecoration('Expense Type *'),
                      value: expenseModel.contains(selectedExpense) ? selectedExpense : null,
                      items: expenseModel.map((item) => DropdownMenuItem<GetExpenseHeaderListModel>(
                        value: item,
                        child: Text(item.expHeadName ?? '', style: Styling.itemBlackTest),
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
                          if (selectedTransMode == 'Cash') {
                            if (val > totalamt!) { _balanceController.clear(); }
                          }
                        });
                      },
                      decoration: _fieldDecoration('Total Amount *', errorText: _isDepositEmpty ? 'Amount is required' : null),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: remarkController,
                      inputFormatters: [LengthLimitingTextInputFormatter(250)],
                      decoration: _fieldDecoration('Remark'),
                      maxLines: 2,
                    ),
                  ],
                ),

                // ── Cash Denomination Card ───────────────────────────────
                if (selectedTransMode == "Cash" && isCashDenominationChecked)
                  _sectionCard(
                    title: cashDenominationMandatory ? 'Cash Denomination (Mandatory)' : 'Cash Denomination',
                    icon: Icons.money_rounded,
                    children: [
                      GestureDetector(
                        onTap: () { setState(() { isCashDenominationListViewVisible = !isCashDenominationListViewVisible; }); },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.blue.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Center(child: Text("Note Type", style: AppTypography.dataRowLabel.copyWith(fontWeight: FontWeight.bold, color: AppColors.blue)))),
                                  Expanded(flex: 3, child: Center(child: Text("Qty", style: AppTypography.dataRowLabel.copyWith(fontWeight: FontWeight.bold, color: AppColors.blue)))),
                                  Expanded(flex: 3, child: Center(child: Text("Amount", style: AppTypography.dataRowLabel.copyWith(fontWeight: FontWeight.bold, color: AppColors.blue)))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: getNoteTypeAndIdFroDenominationListModel.length,
                              itemBuilder: (context, index) {
                                final data = getNoteTypeAndIdFroDenominationListModel[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Center(child: Text("${data.noteType}", style: AppTypography.dataRowLabel))),
                                      Expanded(flex: 1, child: Center(child: Text("X", style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue)))),
                                      Expanded(flex: 3, child: Center(child: TextField(
                                        controller: qtyController[index],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
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
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.blue.withOpacity(0.3))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.blue)),
                                        ),
                                      ))),
                                      Expanded(flex: 1, child: Center(child: Text("=", style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue)))),
                                      Expanded(flex: 3, child: Center(child: Text("${amounts[index].toStringAsFixed(2)}", style: AppTypography.dataRowLabel))),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: AppColors.gradPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Total Amount : ", style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                                  Text(totalAmount.toStringAsFixed(2), style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                // ── Action Buttons ───────────────────────────────────────
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () { cancelAction(); },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.blue,
                          side: BorderSide(color: AppColors.blue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (saveFlag) {
                            print('saveFlag $saveFlag');
                            showFlushBar(context, Constants.dayEndCompleted);
                          } else {
                            if (modes == "EDIT") {
                              paymentDetailAddEditForMob(paymentId!, "EDIT");
                            } else {
                              paymentDetailAddEditForMob(0, "ADD");
                            }
                          }
                        },
                        icon: Icon(modes == "EDIT" ? Icons.update_rounded : Icons.save_rounded),
                        label: Text(modes == "EDIT" ? 'Update' : 'Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saveFlag ? AppColors.textMuted : AppColors.blue,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: saveFlag ? 0 : 3,
                        ),
                      ),
                    ),
                  ],
                ),
                // ── Payment Records ──────────────────────────────────────
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.blue.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withOpacity(0.07),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.list_alt_rounded, size: 18, color: AppColors.blue),
                            const SizedBox(width: 8),
                            Text('Payment Records', style: AppTypography.cardTitle.copyWith(color: AppColors.blue, fontSize: 14)),
                          ],
                        ),
                      ),
                      paymentModel.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentModel.length,
                        itemBuilder: (context, index) {
                          GetPaymentDetailListModel? payList = paymentModel[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.bg2,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.blue.withOpacity(0.12)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(payList.voucherNo ?? '', style: AppTypography.cardTitle.copyWith(color: AppColors.blue, fontSize: 13)),
                                          const SizedBox(height: 2),
                                          Text(payList.paymentDate ?? '', style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted, fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit_rounded, color: saveFlag ? AppColors.textMuted : AppColors.blue, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          var payVoucherNo = payList.voucherNo.toString();
                                          var depositDate = payList.paymentDate.toString();
                                          var paymentMode = payList.paymentMode.toString();
                                          var paymentToId = payList.paymentTo.toString();
                                          var staffName = payList.staffName.toString();
                                          var staffId = payList.staffId.toString();
                                          var vendorId = payList.vendorId.toString();
                                          var vehId = payList.vehId.toString();
                                          var vehicleNo = payList.vehicleNo.toString();
                                          var amountTotal = payList.amount.toString();
                                          var expHeadId = payList.expHeadId.toString();
                                          var payRemark = payList.payRemark.toString();
                                          var transTime = payList.transTime.toString();
                                          var transationCode = payList.transationCode.toString();
                                          var transRemark = payList.transRemark.toString();
                                          var expHeadName = payList.expHeadName.toString();
                                          var bankId = payList.bankId.toString();
                                          var mappingId = payList.mappingId.toString();
                                          var accountNo = payList.accountNo.toString();
                                          var paymentId = payList.paymentId.toString();
                                          int payId = int.parse(paymentId);
                                          if (saveFlag) {
                                            print('saveFlag $saveFlag');
                                            showFlushBar(context, Constants.dayEndCompleted);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              UpdatePaymentScreen.screenName,
                                              arguments: {
                                                'payVoucherNoV': payVoucherNo,
                                                'depositDateV': depositDate,
                                                'paymentModeV': paymentMode,
                                                'paymentToIDV': paymentToId,
                                                'staffNameV' : staffName,
                                                'staffIdV': staffId,
                                                'vendorIdV': vendorId,
                                                'vehIdV': vehId,
                                                'vehicleNoV': vehicleNo,
                                                'amountTotalV': amountTotal,
                                                'expHeadId': expHeadId,
                                                'payRemarkV': payRemark,
                                                'transTimeV': transTime,
                                                'transationCodeV': transationCode,
                                                'transRemarkV': transRemark,
                                                'expHeadNameV': expHeadName,
                                                'bankIdV': bankId,
                                                'mappingIdV': mappingId,
                                                'accountNoV': accountNo,
                                                'paymentIdV': paymentId,
                                                'modeChange': "EDIT"
                                              },
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_rounded, color: saveFlag ? Colors.redAccent.withOpacity(0.4) : Colors.redAccent, size: 20),
                                      onPressed: () async {
                                        if (saveFlag) {
                                          print('saveFlag $saveFlag');
                                          showFlushBar(context, Constants.dayEndCompleted);
                                        } else {
                                          int? pId = (payList.paymentId)?.toInt();
                                          print('Delete button pressedd${payList.paymentId}');
                                          bool? confirmDelete = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Are you sure?'),
                                                content: const Text('You want to delete?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () { Navigator.of(context).pop(false); },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () { Navigator.of(context).pop(true); },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (confirmDelete == true) {
                                            if (pId != null) {
                                              paymentDetailAddEditForMob(pId, "DELETE");
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
                                const Divider(height: 10),
                                _infoTile('Account No.', payList.accountNo ?? ''),
                                _infoTile('Staff/Vendor', payList.staffName ?? ''),
                                _infoTile('Expense Type', payList.expHeadName ?? ''),
                                Row(
                                  children: [
                                    Expanded(child: _infoTile('Amount', payList.amount.toString())),
                                    Expanded(child: _infoTile('Mode', (payList.paymentMode == 'Bank') ? 'Online' : (payList.paymentMode ?? ''))),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                          : const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No Records Found')),
                      ),
                      const SizedBox(height: 6),
                    ],
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

  Future<void> getVoucherNoForExpense() async {
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
            '${AppUrl.GetVoucherNoForExpense}/$distributorId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      if (response.statusCode == 200) {
        // Assuming response.body is the string you want to set.
        String receiptNo = response.body;
        debugPrint('mnhfgjfjf$receiptNo');// Remove any leading/trailing spaces
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

  Future<void> getVendorMasterList() async {
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
      Uri.parse('${AppUrl.GetVendorMasterList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetVendorMasterList : " +
        '${AppUrl.GetVendorMasterList}/$distributorId/1');
    debugPrint("GetVendorMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        vendorModel = data.map((json) {
          return GetVendorMasterListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getPaymentdetailCashDenominationDtl(int paymentId) async {
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
      Uri.parse('${AppUrl.GetPaymentdetailCashDenominationDtl}/$paymentId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetPaymentdetailCashDenominationDtl : " +
        '${AppUrl.GetPaymentdetailCashDenominationDtl}/$paymentId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetPaymentdetailCashDenominationDtl : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetPaymentdetailCashDenominationDtlModel.fromJson(json);
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

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        balancemodel = data.map((json) => GetBalanceByStaffIdModel.fromJson(json)).toList();
        balanceAmount = balancemodel.isNotEmpty ? balancemodel.first.balanceAmt.toString() : '';
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load balance');
    }
  }

  Future<void> getVehicleDetailsByStaffId(String staffId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        vehiclemodel = data.map((json) => GetVehicleDetailsByStaffIdModel.fromJson(json)).toList();
        vehicleNumber = vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleNo ?? '' : '';
        vehicleId = (vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleId ?? 0 : 0) as int?;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load vehicle details');
    }
  }

  Future<void> loadInitialStaffData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? staffId = prefs.getString('StaffId');
    if (staffId != null) {
      await getVehicleDetailsByStaffId(staffId);
      await getBalanceByStaffId(staffId);
    }
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      debugPrint("User Name:- $userName");
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getPaymentDetailList() async {
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
      Uri.parse('${AppUrl.GetPaymentDetailList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetPaymentDetailListModel : " + '${AppUrl.GetPaymentDetailList}/$distributorId');
    debugPrint("GetPaymentDetailListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) => GetPaymentDetailListModel.fromJson(json)).toList();
        // EasyLoading.dismiss();
        isLoading = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
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

  Widget _buildFieldLabel(String label, {bool required = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: AppTypography.labelMD.copyWith(color: AppColors.textMid)),
      if (required) ...[
        const SizedBox(width: 2),
        Text('*', style: const TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ]);
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.labelMD,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
      filled: true,
      fillColor: AppColors.bg,
    );
  }

  void _showAddVendorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.blue, AppColors.blueXL],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_add_alt_1_rounded, color: AppColors.white, size: 22),
                          const SizedBox(width: 10),
                          Text('Add Vendor', style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                        ],
                      ),
                    ),
                    // Fields
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Vendor Name', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: vendorNameController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: <TextInputFormatter>[],
                            style: AppTypography.dataRowValue,
                            decoration: _inputDecoration(hint: 'Enter vendor name').copyWith(
                              errorText: _isVendorName ? 'Vendor Name is required' : null,
                            ),
                            onChanged: (value) {
                              setState(() { _isVendorName = value.isEmpty; });
                              setDialogState(() {});
                            },
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel('Mobile No', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: mobileNumberController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.dataRowValue,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: _inputDecoration(hint: 'Enter 10-digit mobile no').copyWith(
                              errorText: _isConCOntactEmpty
                                  ? 'Mobile No is required'
                                  : _isInvalidMobile
                                  ? 'Please enter a valid mobile no.'
                                  : _isShortLength
                                  ? 'Mobile no. must be 10 digits'
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isConCOntactEmpty = value.isEmpty;
                                if (value.isNotEmpty) {
                                  _isInvalidMobile = !RegExp(r'^[6789]').hasMatch(value);
                                  _isShortLength = value.length < 10;
                                } else {
                                  _isInvalidMobile = false;
                                  _isShortLength = false;
                                }
                              });
                              setDialogState(() {});
                            },
                          ),
                          const SizedBox(height: 20),
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    vendorNameController.clear();
                                    mobileNumberController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.blue),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text('Cancel', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    String vendorName = vendorNameController.text.trim();
                                    String mobileNumber = mobileNumberController.text.trim();
                                    if (_isConCOntactEmpty || _isInvalidMobile || _isShortLength) {
                                      showFlushBar(context, "Invalid mobile number.");
                                      return;
                                    }
                                    if (vendorName.isEmpty || mobileNumber.isEmpty) {
                                      showFlushBar(context, "Both fields are required.");
                                      return;
                                    }
                                    saveVendorPopupForMob();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 0,
                                  ),
                                  child: Text('Save', style: AppTypography.labelMD.copyWith(color: AppColors.white)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void cancelAction(){
    setState(() {
      _selectedItem = '';
      selectedBankName = '';
      balanceAmount = '0.0';
      vehicleNumber = '';
      totalAmount = 0.0;
      selectedTransMode = null;
      selectedBankId = null;
      selectedTransMode = null;
      selectedExpense = null;
      selectedstaff = null;
      selectedItemId = null;
      _selectBankModel = null;
      selectedTransMode = null;
      _selectVendor = null;
      _balanceController.clear();
      TranCodeController.clear();
      timeController.clear();
      remarkController.clear();
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      modes = "Save";
    });
  }

  Future<void> saveVendorPopupForMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String? vendorName = vendorNameController.text;
    String? vendorMobNo = mobileNumberController.text;

    final Map<String, dynamic> requestBody = {
      "VendorId":0,
      "DistributorId": distributorId,
      "VendorName": vendorName,
      "ContactNumber":vendorMobNo,
      "IsActive":1,
      "AddedBy":userId,
      "Action":"ADD"
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.SaveVendorMaster}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

    // Handling response
    if (response.statusCode == 200) {
      // Successful response
      print("Response UpdateSaleAddEditForMob: ${response.body}");

      // Navigator.pushNamed(
      //   context,
      //   BottomNavBarExample.screenName,
      //   arguments: 3, // This opens the third tab
      // );
      EasyLoading.showToast(Constants.expenseSendMgr,
          duration: const Duration(milliseconds: 3000));

      setState(() {
        getCashHandOverDtlsList(selectedDate);
        getVendorMasterList();
        vendorNameController.clear();
        mobileNumberController.clear();
      });
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> paymentDetailAddEditForMob(int paymentId,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    double discountAmt = 0.0;
    String? tranCode;
    String? tranTime;
    String? tranReview;
    String? remark;
    int? bankId;
    int? accMappingIds;
    int? paidTo;
    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
        "RetNoteQty": 0, // Replace with actual value if available
        "RetNoteAmt": 0.0, // Replace with actual value if available
      };
    }).toList();

    if(action != "DELETE") {
      if (_balanceController.text.isNotEmpty) {
        discountAmt = double.parse(_balanceController.text);
      }

      if (TranCodeController.text.isNotEmpty) {
        tranCode = TranCodeController.text;
      } else {
        tranCode = "";
      }
      if (timeController.text.isNotEmpty) {
        tranTime = timeController.text;
      } else {
        tranTime = "";
      }
      if (transReviewController.text.isNotEmpty) {
        tranReview = transReviewController.text;
      } else {
        tranReview = "";
      }
      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      } else {
        remark = "";
      }

      //Condition On Save Button
      if ((selectedTransMode == null || selectedTransMode!.isEmpty) ||
          (selectedStaff == null || selectedStaff!.isEmpty) ||
          (selectedExpense == null)) {
        showFlushBar(context, Constants.reqfield);
        return;
      }

      // Conditional check for cash payment mode
      if (selectedTransMode == 'Cash') {
        // if(totalAmount != null || totalAmount>0){
        if (totalAmount != null && totalAmount > 0) {
          if (discountAmt != totalAmount || discountAmt <= 0) {
            showFlushBar(context, Constants.denominationAmount);
            return;
          }
        }
      }

      if (selectedTransMode == 'Cash') {
        if(cashDenominationMandatory){
          // if(totalAmount != null || totalAmount>0){
            if (totalAmount != null && totalAmount > 0) {
            if (discountAmt != totalAmount || discountAmt <= 0) {
              showFlushBar(context, Constants.denominationAmount);
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
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

      if (_selectBankModel != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      }
      else {
        bankId = 0;
        accMappingIds = 0;
      }

      if (selectedStaff == "Vendor") {
        paidTo = 2;
        staffId = 0.toString();
      } else {
        paidTo = 1;
        vendorId = 0;
      }
    }


    final Map<String, dynamic> requestBody =
    {
      "PaymentId": paymentId,
      "DistributorId":distributorIds,
      "VoucherNo":receiptNoText ?? '',
      "PaymentDate": formattedDate,
      "PaymentMode": selectedTransMode ?? '',
      "PaymentTo":paidTo ?? '',
      "VendorId": vendorId ?? '',
      "StaffId":selectedItemId ?? '',
      "VehId":vehicleId ?? '',
      "ExpHeadId": selectedExpId ?? '',
      "TotalAmtPaid":discountAmt ?? '',
      "PaidFor": 0,
      "PaidForId": 0,
      "TransationCode": tranCode ?? '',
      "TransTime": tranTime ?? '',
      "TransRemark": tranReview ?? '',
      "PayRemark": remark ?? '',
      "BankMappingId": accMappingIds ?? '',
      "BankId": bankId ?? '',
      "AddedBy": userId ?? '',
      "Action": action,
      "DenomAllList": dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PaymentDetailAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // totalAmount = totalAmount - discountAmt;

        // Process the valid response (JSON or data)
        print("Response PaymentDetailAddEdit: ${response.body}");

        Navigator.pushNamed(
          context,
          UpdatePaymentScreen.screenName,
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

        setState(() {
          getPaymentDetailList();
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
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





