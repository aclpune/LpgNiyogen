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
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
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
  final bool enableNetworkCalls;
  const PaymentReceiptScreen({super.key, this.enableNetworkCalls = true});

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
    if (!widget.enableNetworkCalls) {
      return;
    }
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
        backgroundColor: AppColors.bg,
        appBar: CustomAppBarManagerr(title: 'Payments Receipt'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // â”€â”€ Hero strip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.blue, AppColors.blueXL],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Receipt', style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                          const SizedBox(height: 4),
                          Text(modes == "EDIT" ? 'Edit existing receipt' : 'Create new receipt',
                              style: AppTypography.cardSubtitle.copyWith(color: AppColors.white.withValues(alpha: 0.85))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text('Receipt No', style: AppTypography.labelSM.copyWith(color: AppColors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: 2),
                          Text(
                            modes == "EDIT" ? (receiptNoTextEdit ?? '-') : (receiptNoText ?? '-'),
                            style: AppTypography.cardTitle.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // â”€â”€ Info card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.blueXXL,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.blue.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.blue),
                          const SizedBox(width: 8),
                          Text('Receipt Date:', style: AppTypography.labelMD.copyWith(color: AppColors.textMid)),
                          const SizedBox(width: 6),
                          Text(formattedDate, style: AppTypography.dataRowValue.copyWith(color: AppColors.blue)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // â”€â”€ Form card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Mode
                          _buildFieldLabel('Payment Mode', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: formKey1,
                            value: selectedTransMode,
                            decoration: _inputDecoration(hint: 'Select Payment Mode'),
                            isExpanded: true,
                            items: getTransMode.map((String v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
                            onChanged: (value) { setState(() { selectedTransMode = value; }); },
                          ),
                          const SizedBox(height: 14),

                          // Cash Denomination checkbox
                          if (selectedTransMode == 'Cash')
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.blueXXL,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.blue.withValues(alpha: 0.15)),
                              ),
                              child: CheckboxListTile(
                                dense: true,
                                title: Text('Cash Denomination', style: AppTypography.dataRowLabel),
                                value: isCashDenominationChecked,
                                activeColor: AppColors.blue,
                                onChanged: (bool? value) { setState(() { isCashDenominationChecked = value ?? false; }); },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),

                          // Denomination toggle + tables
                          if (selectedTransMode == 'Cash' && isCashDenominationChecked) ...[
                            const SizedBox(height: 12),
                            // Toggle tab
                            Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.blueXXL,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () { setState(() { _selectedIndex = 0; }); },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: _selectedIndex == 0 ? AppColors.blue : Colors.transparent,
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                                        ),
                                        child: Text(
                                          cashDenominationMandatory ? 'Cash Denomination (Mandatory)' : 'Cash Denomination',
                                          style: AppTypography.labelSM.copyWith(color: _selectedIndex == 0 ? AppColors.white : AppColors.blue),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () { setState(() { _selectedIndex = 1; }); },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: _selectedIndex == 1 ? AppColors.blue : Colors.transparent,
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7)),
                                        ),
                                        child: Text('Cash Return',
                                            style: AppTypography.labelSM.copyWith(color: _selectedIndex == 1 ? AppColors.white : AppColors.blue)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Cash Denomination table
                            Visibility(
                              visible: _selectedIndex == 0,
                              child: _buildDenomTable(
                                controllers: qtyController,
                                amounts: amounts,
                                isReturn: false,
                                onChanged: (index, value) {
                                  setState(() {
                                    amounts[index] = (double.tryParse(value) ?? 0.0) * getNoteTypeAndIdFroDenominationListModel[index].noteType!;
                                    totalAmount = amounts.fold(0.0, (sum, a) => sum + a);
                                    finalAmountCashDeno = totalAmount - returnAmount;
                                    isQtyFilled[index] = value.isNotEmpty;
                                  });
                                },
                                summaryRows: [
                                  _denomSummaryRow('Collected:', totalAmount.toStringAsFixed(2)),
                                  _denomSummaryRow('Final Total:', finalAmountCashDeno.toStringAsFixed(2)),
                                ],
                              ),
                            ),
                            // Cash Return table
                            Visibility(
                              visible: _selectedIndex == 1,
                              child: _buildDenomTable(
                                controllers: qtyControllerReturn,
                                amounts: amountsReturn,
                                isReturn: true,
                                onChanged: (index, value) {
                                  setState(() {
                                    amountsReturn[index] = (double.tryParse(value) ?? 0.0) * getNoteTypeAndIdFroDenominationListModel[index].noteType!;
                                    returnAmount = amountsReturn.fold(0.0, (sum, a) => sum + a);
                                    finalAmountCashDeno = totalAmount - returnAmount;
                                  });
                                },
                                summaryRows: [
                                  _denomSummaryRow('Return:', returnAmount.toStringAsFixed(2)),
                                  _denomSummaryRow('Final Total:', finalAmountCashDeno.toStringAsFixed(2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Online fields
                          if (selectedTransMode == 'Online') ...[
                            const SizedBox(height: 4),
                            _buildFieldLabel('Bank Account', required: true),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<GetBankMappingDetailsListModel>(
                              value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                              decoration: _inputDecoration(hint: 'Select Account No'),
                              isExpanded: true,
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
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Transaction Code', required: true),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: TranCodeController,
                                        style: AppTypography.dataRowValue,
                                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(30),
                                          FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')),
                                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                        ],
                                        decoration: _inputDecoration(hint: 'Enter transaction code').copyWith(
                                          errorText: _isTranscode ? 'Transaction code is Required' : null,
                                        ),
                                        onChanged: (value) { setState(() { _isTranscode = value.isEmpty; }); },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel('Time'),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: timeController,
                                        style: AppTypography.dataRowValue,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                          LengthLimitingTextInputFormatter(5),
                                        ],
                                        decoration: _inputDecoration(hint: 'HH:MM'),
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
                              controller: transReviewController,
                              style: AppTypography.dataRowValue,
                              inputFormatters: [LengthLimitingTextInputFormatter(250)],
                              maxLines: 2,
                              decoration: _inputDecoration(hint: 'Enter transaction remark'),
                              onChanged: (value) { setState(() {}); },
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Receipt From
                          _buildFieldLabel('Receipt From', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: formKey2,
                            value: getStaff.contains(selectedStaffMode) ? selectedStaffMode : null,
                            decoration: _inputDecoration(hint: 'Select Receipt From'),
                            isExpanded: true,
                            items: getStaff.map((String v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
                            onChanged: (value) { setState(() { selectedStaffMode = value; }); },
                          ),
                          const SizedBox(height: 14),

                          // Staff fields
                          if (selectedStaffMode == 'Staff') ...[
                            _buildFieldLabel('Staff Name', required: true),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<GetStaffDetailsListModel>(
                              isExpanded: true,
                              key: formKey3,
                              value: staffmodel.contains(selectedstaff) ? selectedstaff : null,
                              decoration: _inputDecoration(hint: 'Select Staff'),
                              items: staffmodel.map((item) => DropdownMenuItem<GetStaffDetailsListModel>(
                                value: item,
                                child: Text(item.staffName ?? '', style: AppTypography.dataRowValue),
                              )).toList(),
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
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.blueXXL,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.blue.withValues(alpha: 0.15)),
                              ),
                              child: Row(
                                children: [
                                  Text('Balance:', style: AppTypography.dataRowLabel),
                                  const SizedBox(width: 8),
                                  Text(
                                    balanceAmount != 0.0 ? balanceAmount.toString() : '0.0',
                                    style: AppTypography.dataRowValue.copyWith(color: AppColors.blue),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Customer fields (Reticulated Or ND / Other)
                          if (selectedStaffMode == 'Reticulated Or ND' || selectedStaffMode == 'Other') ...[
                            Row(
                              children: [
                                Expanded(child: _buildFieldLabel('Customer Name', required: true)),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () { setState(() { _showAddCustomerPopup(); }); },
                                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: AppColors.white),
                                  label: Text('Add', style: AppTypography.labelSM.copyWith(color: AppColors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<GetCustomerListModel>(
                              isExpanded: true,
                              key: formKey4,
                              value: customerModel.contains(selectedCustomer) ? selectedCustomer : null,
                              decoration: _inputDecoration(hint: 'Select Customer'),
                              items: customerModel.map((item) => DropdownMenuItem<GetCustomerListModel>(
                                value: item,
                                child: Text(item.customerName ?? '', style: AppTypography.dataRowValue),
                              )).toList(),
                              onChanged: (selectedItem) {
                                setState(() {
                                  selectedCustomer = selectedItem;
                                  _selectedCustomer = selectedItem?.customerName ?? '';
                                  _selectedCustomerId = selectedItem?.customerId!.toInt();
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Amount
                          _buildFieldLabel('Amount', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.dataRowValue,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              LengthLimitingTextInputFormatter(9),
                            ],
                            decoration: _inputDecoration(hint: 'Enter amount').copyWith(
                              errorText: _isDepositEmpty ? 'Amount is required' : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isDepositEmpty = value.isEmpty;
                                double val = double.tryParse(value.replaceAll(',', '')) ?? 0;
                                if (selectedStaffMode != 'Reticulated Or ND' && selectedStaffMode != 'Other') {
                                  if (selectedTransMode == "Cash") {
                                    if (val > balanceAmount) {
                                      amountController.clear();
                                    }
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          // Remark
                          _buildFieldLabel('Remark'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: remarkController,
                            style: AppTypography.dataRowValue,
                            inputFormatters: [LengthLimitingTextInputFormatter(250)],
                            maxLines: 2,
                            decoration: _inputDecoration(hint: 'Enter your remarks'),
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
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text('Cancel', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (saveFlag) {
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
                                    backgroundColor: saveFlag ? AppColors.textMuted : AppColors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    modes == "EDIT" ? 'Update' : 'Save',
                                    style: AppTypography.labelMD.copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // â”€â”€ Records list â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: customerListModel.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: customerListModel.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: AppColors.border),
                              itemBuilder: (context, index) {
                                final payList = customerListModel[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(payList.receiptDate ?? '',
                                                style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue)),
                                          ),
                                          Expanded(
                                            child: Text(payList.receiptNo ?? '',
                                                style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue)),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(Icons.edit_rounded,
                                                color: saveFlag ? AppColors.textMuted : AppColors.blue, size: 20),
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
                                                      'staffNameV': staffName,
                                                      'customerIdV': customerId,
                                                      'customerNameV': customerName,
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
                                          const SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(Icons.delete_rounded,
                                                color: saveFlag ? AppColors.textMuted : AppColors.red, size: 20),
                                            onPressed: () async {
                                              if (saveFlag) {
                                                showFlushBar(context, Constants.dayEndCompleted);
                                              } else {
                                                int? pId = (payList.receiptId)?.toInt();
                                                bool? confirmDelete = await showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                      backgroundColor: AppColors.white,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(24),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Icon(Icons.delete_forever_rounded, color: AppColors.red, size: 40),
                                                            const SizedBox(height: 12),
                                                            Text('Delete Record?', style: AppTypography.cardTitle),
                                                            const SizedBox(height: 8),
                                                            Text('Are you sure you want to delete this receipt?',
                                                                style: AppTypography.cardSubtitle, textAlign: TextAlign.center),
                                                            const SizedBox(height: 20),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: OutlinedButton(
                                                                    onPressed: () => Navigator.of(context).pop(false),
                                                                    style: OutlinedButton.styleFrom(
                                                                      side: const BorderSide(color: AppColors.blue),
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                    ),
                                                                    child: Text('Cancel', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () => Navigator.of(context).pop(true),
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: AppColors.red,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                      elevation: 0,
                                                                    ),
                                                                    child: Text('Delete', style: AppTypography.labelMD.copyWith(color: AppColors.white)),
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
                                                if (confirmDelete == true && pId != null) {
                                                  selectedItemId = payList.staffId?.toInt() ?? 0;
                                                  _selectedCustomerId = payList.customerId?.toInt() ?? 0;
                                                  customerAddEditForMob(pId, "DELETE");
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      _listDetailRow('Staff/Vendor', payList.staffName ?? ''),
                                      const SizedBox(height: 4),
                                      _listDetailRow('Receipt Mode', (payList.receiptMode == 'Bank') ? 'Online' : (payList.receiptMode ?? '')),
                                      const SizedBox(height: 4),
                                      _listDetailRow('Amount', payList.amount.toString()),
                                      if ((payList.accountNo ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        _listDetailRow('Account No', payList.accountNo ?? ''),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(child: Text('No Records Found', style: AppTypography.cardSubtitle)),
                            ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ Private UI helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFieldLabel(String label, {bool required = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: AppTypography.labelMD.copyWith(color: AppColors.textMid)),
      if (required) ...[
        const SizedBox(width: 2),
        const Text('*', style: TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _listDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: AppTypography.dataRowLabel)),
        const Text(' : ', style: TextStyle(color: AppColors.textMuted)),
        Expanded(child: Text(value, style: AppTypography.dataRowValue)),
      ],
    );
  }

  Widget _denomSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: AppTypography.dataRowLabel),
        const SizedBox(width: 8),
        Text(value, style: AppTypography.dataRowValue.copyWith(color: AppColors.blue)),
      ],
    );
  }

  Widget _buildDenomTable({
    required List<TextEditingController> controllers,
    required List<double> amounts,
    required bool isReturn,
    required void Function(int index, String value) onChanged,
    required List<Widget> summaryRows,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.blueXXL,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Center(child: Text('Note Type', style: AppTypography.dataRowLabel))),
                Expanded(flex: 3, child: Center(child: Text('Qty', style: AppTypography.dataRowLabel))),
                Expanded(flex: 3, child: Center(child: Text('Amount', style: AppTypography.dataRowLabel))),
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Center(child: Text('${data.noteType}', style: AppTypography.dataRowValue))),
                    Expanded(flex: 1, child: Center(child: Text('X', style: AppTypography.dataRowLabel))),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: controllers[index],
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textAlign: TextAlign.center,
                        style: AppTypography.dataRowValue,
                        enabled: !isReturn || !isQtyFilled.containsKey(index) || !isQtyFilled[index]!,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.border)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: AppColors.blue)),
                          filled: true,
                          fillColor: AppColors.bg,
                        ),
                        onChanged: (value) => onChanged(index, value),
                      ),
                    ),
                    Expanded(flex: 1, child: Center(child: Text('=', style: AppTypography.dataRowLabel))),
                    Expanded(flex: 3, child: Center(child: Text(amounts[index].toStringAsFixed(2), style: AppTypography.dataRowValue))),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: summaryRows,
            ),
          ),
        ],
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
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──────────────────────────────────────────────
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
                        Text('Add Customer', style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                  // ── Fields ───────────────────────────────────────────────
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Type dropdown
                          _buildFieldLabel('Customer Type'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<GetCustTypeListModel>(
                            isExpanded: true,
                            key: formKey5,
                            value: customerTypeModel.contains(selectedCustomerType) ? selectedCustomerType : null,
                            decoration: _inputDecoration(hint: 'Select Customer Type'),
                            items: customerTypeModel.map((item) => DropdownMenuItem<GetCustTypeListModel>(
                              value: item,
                              child: Text(item.customerType ?? '', style: AppTypography.dataRowValue),
                            )).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                selectedCustomerType = selectedItem;
                                _selectedCustomerType = selectedItem?.customerType ?? '';
                                _selectedCustomerTypeId = selectedItem?.custTypeId?.toString();
                              });
                              setDialogState(() {});
                            },
                          ),
                          const SizedBox(height: 14),

                          // Customer Name
                          _buildFieldLabel('Customer Name', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: customerNameController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: <TextInputFormatter>[],
                            style: AppTypography.dataRowValue,
                            decoration: _inputDecoration(hint: 'Enter customer name').copyWith(
                              errorText: _isCustomerName ? 'Customer Name is required' : null,
                            ),
                            onChanged: (value) {
                              setState(() { _isCustomerName = value.isEmpty; });
                              setDialogState(() {});
                            },
                          ),
                          const SizedBox(height: 14),

                          // Mobile No
                          _buildFieldLabel('Customer Contact No', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: mobileNumberController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.dataRowValue,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: _inputDecoration(hint: 'Enter 10-digit mobile no').copyWith(
                              errorText: _isConContactEmpty
                                  ? 'Mobile No is required'
                                  : _isInvalidMobile
                                  ? 'Please enter a valid contact no.'
                                  : _isShortLength
                                  ? 'Contact no. must be 10 digits'
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isConContactEmpty = value.isEmpty;
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
                          const SizedBox(height: 14),

                          // Customer Email
                          _buildFieldLabel('Customer Email', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: customerEmailController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: <TextInputFormatter>[],
                            style: AppTypography.dataRowValue,
                            decoration: _inputDecoration(hint: 'Enter email address').copyWith(
                              errorText: _isCustomerEmailInvalid ? 'Enter a valid email address' : null,
                            ),
                            onChanged: (value) {
                              setState(() { _isCustomerEmailInvalid = value.isEmpty || !_isValidEmail(value); });
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
                                    customerNameController.clear();
                                    mobileNumberController.clear();
                                    customerEmailController.clear();
                                    setState(() { selectedCustomerType = null; });
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
                                    String customerName = customerNameController.text.trim();
                                    String mobileNumber = mobileNumberController.text.trim();
                                    String customerEmail = customerEmailController.text.trim();
                                    if (_isConContactEmpty || _isInvalidMobile || _isShortLength) {
                                      showFlushBar(context, "Invalid mobile number.");
                                      return;
                                    }
                                    if (_isCustomerEmailInvalid) {
                                      showFlushBar(context, "Please enter a valid email address.");
                                      return;
                                    }
                                    if (customerName.isEmpty || mobileNumber.isEmpty || customerEmail.isEmpty) {
                                      showFlushBar(context, "All fields are required.");
                                      return;
                                    }
                                    saveCustomerPopupForMob(0);
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
                  )],
                ),
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

      // Navigator.pushNamed(
      //   context,
      //   BottomNavBarExample.screenName,
      //   arguments: 3, // This opens the third tab
      // );
      EasyLoading.showToast(Constants.expenseSendMgr,
          duration: const Duration(milliseconds: 3000));
      setState(() {
        getCustomerList();
        customerNameController.clear();
        mobileNumberController.clear();
        customerEmailController.clear();
        customerTypeModel.clear();
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
        if(finalAmountCashDeno != null && finalAmountCashDeno>0){
          if(amtController != finalAmountCashDeno || amtController <= 0) {
            showFlushBar(context, Constants.denominationAmount);
            return;
          }
        }
      }
      if (selectedTransMode == 'Cash'){
        if(cashDenominationMandatory){
          if(finalAmountCashDeno != null && finalAmountCashDeno>0){
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
