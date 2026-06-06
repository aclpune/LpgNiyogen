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
import '../UpdatePaymentsScreen/GetCashHandOverDtlsListModel.dart';
import '../UpdatePaymentsScreen/GetStaffDetailsListModel.dart';
import 'GetCashDenominationDtlsByIdModel.dart';
import 'GetSalaryIncentiveEntryListModel.dart';

class SalaryPaymentScreen extends StatefulWidget {
  static const screenName = '/salaryPaymentScreen';
  final bool disableNetworkCallsForTest;
  const SalaryPaymentScreen({super.key, this.disableNetworkCallsForTest = false});

  @override
  State<SalaryPaymentScreen> createState() => _SalaryPaymentScreenState();
}
class _SalaryPaymentScreenState extends State<SalaryPaymentScreen>{

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> getpaidAgainstSalary = ["Commission Charges", "Salary", "Incentive", "Advance"];
  String? selectedpaidAgainstSalary;
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetSalaryIncentiveEntryListModel> listModel = [];
  List<GetCashDenominationDtlsByIdModel> returndenominationModel = [];
  final String cDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late List<TextEditingController> qtyController;
  late List<double> amounts;
  double totalAmount = 0.0;
  late double finalAmountCashDeno;
  late Map<int, bool> isQtyFilled;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  late final _balanceController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool _isDepositEmpty = false;
  bool isCashDenominationListViewVisible = false;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  bool isLoading = true;
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  List<GetStaffDetailsListModel> staffmodel = [];
  GetStaffDetailsListModel? selectedstaff;
   bool isvisibilityStaffStatus = false;
  List<GetBankMappingDetailsListModel> bankModel = [];
  String? selectedBankName;
  String? selectedBankId;
  double? valueBal;
  bool _isTranscode = false;
  bool _isVendorName = false;
  String? receiptNoText;
  String? cashInHandEdit;
  List<dynamic> dataCashInHandList = [];
  DateTime selectedDate = DateTime.now();

  double? totalAmt;
  String? userName,userId;
  String? _selectedItem;
  int? selectedItemId;
  int? selectedItemType;
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
  int? salaryEntryId;
  int? payId;
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  bool isCashDenominationChecked = false;
  @override
  void initState() {
    super.initState();
    if (widget.disableNetworkCallsForTest) {
      qtyController = [];
      amounts = [];
      isQtyFilled = {};
      finalAmountCashDeno = 0.0;
      fetchSavedData();
      return;
    }
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    // First, execute asynchronous operations without calling setState
    getNoteTypeAndIDList();
    fetchBank();
    fetchSavedData();
    getCashHandOverDtlsList(selectedDate);
    getStaffDetailsList();
    loadInitialStaffData();
    getSalaryPaymentList();
    getVoucherNoForExpense();

    // Then, execute delayed tasks that involve async code
    Future.delayed(Duration.zero, () async {
      // Fetch data from arguments
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';

      if (argValue != null) {
        String paymentModeEdit = argValue["paymentModeV"] ?? 0;
        selectedTransMode = paymentModeEdit;

        String staffNameEdit = argValue["staffNameV"] ?? 0;
        selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;

        String paidModeEdit = argValue["paidModeV"] ?? 0;
        selectedpaidAgainstSalary = paidModeEdit;

        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
        selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
        String payRemarkEdit = argValue["payRemarkV"] ?? 0;
        String transTimeEdit = argValue["transTimeV"] ?? 0;
        String transRemarkEdit = argValue["transRemarkV"] ?? 0;
        String transationCodeEdit = argValue["transationCodeV"] ?? 0;
        String accountNoEdit = argValue["accountNoV"] ?? 0;
        selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
        accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
        salaryEntryId = int.tryParse(argValue["salaryEntryIDV"] ?? '') ?? 0;
        if (filteredPaidAgainstSalary.contains(paidModeEdit)) {
          selectedpaidAgainstSalary = paidModeEdit;

        } else {
          selectedpaidAgainstSalary = null;
        }
        // Set controller texts
        timeController.text = transTimeEdit;
        TranCodeController.text = transationCodeEdit;
        transReviewController.text = transRemarkEdit;
        _balanceController.text = amountTotalEdit.toString();
        remarkController.text = payRemarkEdit;



        // Edit action for transaction mode
        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode = "Online";
        } else {
          selectedTransMode = null;
        }

        // Edit action for selected staff
        if (selectedItemId != 0) {
          await getStaffDetailsList(); // Wait for staff details list to load
          selectedstaff = staffmodel.firstWhere(
                (item) => item.staffId == selectedItemId,
            orElse: () => GetStaffDetailsListModel(staffName: ''),
          );
          debugPrint("Staff selected during edit: ${selectedstaff?.staffId}");
          setState(() {
            // Assuming 'staffType' is part of your staff model
            selectedItemType = selectedstaff?.staffType != null
                ? int.tryParse(selectedstaff!.staffType.toString())
                : null;
            debugPrint("selectecteItemTypeEditint $selectedItemType");

          });
        }


        // Edit action for cash denomination
        await getNoteTypeAndIDList(); // Wait for denomination data
        await getReceiptCashDenominationDtl(salaryEntryId!); // Get denomination details
        if (returndenominationModel.isNotEmpty) {
          initializeControllers();
        } else {
          debugPrint("Denomination data is empty");
        }

        // Edit action for bank mode
        await fetchBank();
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
        appBar: CustomAppBarManagerr(
          title: 'Salary Payment',
        ),
        body:
        Padding(
          padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Strip ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradPrimary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Salary Payment', style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
                            const SizedBox(height: 2),
                            Text('Record staff payout details securely', style: AppTypography.heroSubtitle),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Cash In Hand', style: AppTypography.labelSM.copyWith(color: AppColors.white.withValues(alpha: 0.8))),
                            const SizedBox(height: 2),
                            Text('${formatCurrency(totalAmt ?? 0)}',
                              style: AppTypography.kpiValueLG.copyWith(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Form Card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Paid Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text('Paid Date:', style: AppTypography.labelMD),
                          const SizedBox(width: 8),
                          Text(formattedDate, style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Staff Name
                      _buildFieldLabel('Staff Name', required: true),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<GetStaffDetailsListModel>(
                        isExpanded: true,
                        key: formKey1,
                        decoration: _inputDecoration(hint: 'Select Staff'),
                        value: staffmodel.contains(selectedstaff) ? selectedstaff : null,
                        items: staffmodel.map((item) {
                          return DropdownMenuItem<GetStaffDetailsListModel>(
                            value: item,
                            child: Text(
                              item.staffName ?? '',
                              style: AppTypography.dataRowLabel,
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            debugPrint("on chabge");
                            selectedstaff = selectedItem;
                            _selectedItem = selectedItem?.staffName ?? '';
                            selectedItemId = selectedItem?.staffId?.toInt();
                            selectedItemType = selectedItem?.staffType?.toInt();
                            debugPrint("selectedItemType $selectedItemType");
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      // Paid Against (conditional)
                      Visibility(
                        visible: selectedstaff != null && selectedItemType != 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Paid Against', required: true),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              key: formKey2,
                              isExpanded: true,
                              decoration: _inputDecoration(hint: 'Select Type'),
                              value: filteredPaidAgainstSalary.contains(selectedpaidAgainstSalary) ? selectedpaidAgainstSalary : null,
                              items: filteredPaidAgainstSalary.toSet().toList().map((String value) =>
                                  DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: AppTypography.dataRowLabel),
                                  )
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedpaidAgainstSalary = value;
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),

                      // Paid Salary Amount
                      _buildFieldLabel('Paid Salary Amount', required: true),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _balanceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          LengthLimitingTextInputFormatter(9),
                        ],
                        style: AppTypography.dataRowLabel,
                        onChanged: (value) {
                          setState(() {
                            _isDepositEmpty = value.isEmpty;
                          });
                        },
                        decoration: _inputDecoration(hint: 'Enter paid salary amount').copyWith(
                          errorText: _isDepositEmpty ? 'Paid Salary Amt is required and must be greater than zero' : null,
                          errorStyle: const TextStyle(color: AppColors.red),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Payment Mode
                      _buildFieldLabel('Payment Mode', required: true),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        key: formKey4,
                        isExpanded: true,
                        decoration: _inputDecoration(hint: 'Select Mode'),
                        value: selectedTransMode,
                        items: getTransMode.map((String value) =>
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.dataRowLabel),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTransMode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      // Online mode fields
                      if (selectedTransMode == "Online")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Bank / Account'),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<GetBankMappingDetailsListModel>(
                              isExpanded: true,
                              decoration: _inputDecoration(hint: 'Select Acc No'),
                              value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                              items: bankModel.map((item) {
                                return DropdownMenuItem<GetBankMappingDetailsListModel>(
                                  value: item,
                                  child: Text(
                                    '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                                    style: AppTypography.dataRowLabel,
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
                            ),
                            const SizedBox(height: 10),
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
                                    style: AppTypography.dataRowLabel,
                                    decoration: _inputDecoration(hint: 'Transaction Code').copyWith(
                                      errorText: _isTranscode ? 'Transaction code is Required' : null,
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          countTextWidgetTextStar(context, 'Transaction Code', showAsterisk: true),
                                        ],
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _isTranscode = value.isEmpty;
                                      });
                                    },
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
                                    style: AppTypography.dataRowLabel,
                                    decoration: _inputDecoration(hint: 'HH:MM').copyWith(
                                      labelText: 'Time',
                                      labelStyle: AppTypography.labelMD,
                                    ),
                                    onChanged: (value) { setState(() {}); },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: transReviewController,
                              style: AppTypography.dataRowLabel,
                              decoration: _inputDecoration(hint: 'Transaction remark...').copyWith(
                                labelText: 'Transaction Remark',
                                labelStyle: AppTypography.labelMD,
                              ),
                              maxLines: 2,
                              inputFormatters: [LengthLimitingTextInputFormatter(250)],
                              onChanged: (value) { setState(() {}); },
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),

                      // Remark
                      _buildFieldLabel('Remark'),
                      const SizedBox(height: 4),
                      TextField(
                        controller: remarkController,
                        inputFormatters: [LengthLimitingTextInputFormatter(250)],
                        style: AppTypography.dataRowLabel,
                        decoration: _inputDecoration(hint: 'Enter remark...').copyWith(
                          labelText: 'Remark',
                          labelStyle: AppTypography.labelMD,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),

                      // Cash Denomination checkbox
                      if (selectedTransMode == 'Cash')
                        CheckboxListTile(
                          title: Text(
                            "Cash Denomination",
                            style: AppTypography.dataRowLabel,
                          ),
                          value: isCashDenominationChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isCashDenominationChecked = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.blue,
                          contentPadding: EdgeInsets.zero,
                        ),

                      // Cash Denomination table
                      if (selectedTransMode == "Cash" && isCashDenominationChecked)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isCashDenominationListViewVisible = !isCashDenominationListViewVisible;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppColors.blueXL,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.blueXXL),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cashDenominationMandatory ? "Cash Denomination Is Mandatory" : "Cash Denomination",
                                        style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                                      ),
                                      Icon(
                                        isCashDenominationListViewVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        color: AppColors.blue,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Column(
                                      children: [
                                        // Header row
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.blueXXL,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(flex: 2, child: Center(child: Text("Note Type", style: AppTypography.dataRowLabel))),
                                              Expanded(flex: 3, child: Center(child: Text("Qty", style: AppTypography.dataRowLabel))),
                                              Expanded(flex: 3, child: Center(child: Text("Amount", style: AppTypography.dataRowLabel))),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          itemCount: getNoteTypeAndIdFroDenominationListModel.length,
                                          itemBuilder: (context, index) {
                                            final data = getNoteTypeAndIdFroDenominationListModel[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text("${data.noteType}", style: AppTypography.cardSubtitle, textAlign: TextAlign.left),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(child: Text("X", style: AppTypography.cardSubtitle)),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: TextField(
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
                                                        style: AppTypography.dataRowLabel,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(child: Text("=", style: AppTypography.cardSubtitle)),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: Text("${amounts[index].toStringAsFixed(2)}", style: AppTypography.cardSubtitle),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.blueXXL,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Total : ", style: AppTypography.dataRowLabel),
                                              Text(totalAmount.toStringAsFixed(2), style: AppTypography.dataRowValue),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Action Buttons ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () { cancelAction(); },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: Text('Cancel', style: AppTypography.cardTitle.copyWith(color: AppColors.blue)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (saveFlag) {
                              print('saveFlag $saveFlag');
                              showFlushBar(context, Constants.dayEndCompleted);
                            } else {
                              if (modes == "EDIT") {
                                SalaryIncentiveEntryAddEdit(salaryEntryId!, "EDIT");
                              } else {
                                SalaryIncentiveEntryAddEdit(0, "ADD");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: saveFlag ? AppColors.textMuted : AppColors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: Text(
                            modes == "EDIT" ? 'Update' : 'Save',
                            style: AppTypography.cardTitle.copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Records List ──
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: AppColors.blue.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: listModel.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listModel.length,
                    itemBuilder: (context, index) {
                      GetSalaryIncentiveEntryListModel? payList = listModel[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row with date, name, actions
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 4, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    payList.paidDate != null
                                        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.paidDate!))
                                        : '',
                                    style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    payList.staffName ?? '',
                                    style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: saveFlag ? AppColors.textMuted : AppColors.blue, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          var paidDate = payList.paidDate.toString();
                                          var paymentMode = payList.paymentMode.toString();
                                          var staffName = payList.staffName.toString();
                                          var staffId = payList.staffId.toString();
                                          var paidAgainst = payList.paidAgainst.toString();
                                          var amountTotal = payList.paidSalaryAmt.toString();
                                          var transTime = payList.transactionTime.toString();
                                          var transationCode = payList.transactionCode.toString();
                                          var transRemark = payList.transactionRemark.toString();
                                          var bankId = payList.bankId.toString();
                                          var itemType = payList.runtimeType.toString();
                                          var mappingId = payList.bankMappingId.toString();
                                          var accountNo = payList.accountNo.toString();
                                          var remark = payList.remark.toString();
                                          var salaryEntryId = payList.salaryEntryId.toString();

                                          if (saveFlag) {
                                            print('saveFlag $saveFlag');
                                            showFlushBar(context, Constants.dayEndCompleted);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              SalaryPaymentScreen.screenName,
                                              arguments: {
                                                'depositDateV': paidDate,
                                                'paymentModeV': paymentMode,
                                                'staffNameV': staffName,
                                                'staffIdV': staffId,
                                                'paidModeV': paidAgainst,
                                                'amountTotalV': amountTotal,
                                                'payRemarkV': remark,
                                                'transTimeV': transTime,
                                                'transationCodeV': transationCode,
                                                'transRemarkV': transRemark,
                                                'bankIdV': bankId,
                                                'ItemTypeV': itemType,
                                                'mappingIdV': mappingId,
                                                'accountNoV': accountNo,
                                                'salaryEntryIDV': salaryEntryId,
                                                'modeChange': "EDIT"
                                              },
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: saveFlag ? AppColors.redXXL : AppColors.red, size: 20),
                                      onPressed: () async {
                                        if (saveFlag) {
                                          print('saveFlag $saveFlag');
                                          showFlushBar(context, Constants.dayEndCompleted);
                                        } else {
                                          int? pId = (payList.salaryEntryId)?.toInt();
                                          print('Delete button pressedd${payList.salaryEntryId}');
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
                                              SalaryIncentiveEntryAddEdit(pId, "DELETE");
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
                              ],
                            ),
                          ),
                          // Detail rows
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                            child: Column(
                              children: [
                                _listDetailRow("Paid Against", payList.paidAgainst ?? ''),
                                _listDetailRow("Paid Salary Amt", payList.paidSalaryAmt.toString()),
                                _listDetailRow("Payment Mode", (payList.paymentMode == 'Bank') ? 'Online' : (payList.paymentMode ?? '')),
                                _listDetailRow("Remark", payList.remark.toString()),
                              ],
                            ),
                          ),
                          const Divider(color: AppColors.border, thickness: 1, height: 16),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('No Records Found', style: AppTypography.cardSubtitle),
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

  // ── Private UI helpers ──

  Widget _buildFieldLabel(String label, {bool required = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTypography.labelMD.copyWith(color: AppColors.textMid)),
        if (required) ...[
          const SizedBox(width: 2),
          const Text('*', style: TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.labelMD,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      filled: true,
      fillColor: AppColors.bg,
    );
  }

  Widget _listDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('$label :', style: AppTypography.labelMD.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.dataRowLabel),
          ),
        ],
      ),
    );
  }

  // ── Computed Getters ──

  List<String> get filteredPaidAgainstSalary {
    // For staff type 1 (field staff), show all options; otherwise show full list
    return getpaidAgainstSalary;
  }

  // ── Utility ──

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0$formattedAmount';
    }
    return formattedAmount;
  }

  void cancelAction() {
    setState(() {
      selectedstaff = null;
      selectedpaidAgainstSalary = null;
      selectedTransMode = null;
      _selectBankModel = null;
      _balanceController.clear();
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      remarkController.clear();
      isCashDenominationChecked = false;
      totalAmount = 0.0;
      if (qtyController.isNotEmpty) {
        for (var c in qtyController) { c.clear(); }
      }
      if (amounts.isNotEmpty) {
        for (int i = 0; i < amounts.length; i++) { amounts[i] = 0.0; }
      }
    });
  }

  // ── API Methods ──

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false
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
        },
      );
      debugPrint("Response body CheckDayEndConfirmation: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        setState(() {
          saveFlag = apiResponse.isNotEmpty;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception checkAndSaveDayEndData: $e");
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
        if (bearerToken == null) { isLoading = false; throw Exception('Bearer token is missing'); }
        final response = await http.get(
          Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
          headers: { 'Authorization': 'Bearer $bearerToken' },
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashDenoMandatoryList = data.map((jsonItem) => CahsDenominationMandatoryFlagModel.fromJson(jsonItem)).toList();
            isLoading = false;
            cashDenominationMandatory = false;
            for (var item in cashDenoMandatoryList) {
              if (item.distributorId.toString() == distributorId && item.permissionFor == "Cash Denomination" && item.isActive == 1) {
                cashDenominationMandatory = true;
                break;
              }
            }
          });
        } else {
          isLoading = false;
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error checkCashDenominationFlagMandatory: $error");
      }
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
        if (bearerToken == null) { isLoading = false; throw Exception('Bearer token is missing'); }
        final response = await http.get(
          Uri.parse('${AppUrl.GetCashDenominationItemList}/0'),
          headers: { 'Authorization': 'Bearer $bearerToken' },
        );
        debugPrint("Response body GetCashDenominationItemList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          var filteredDataCashDenominationList = jsonResponse.map((item) => DenomModel.fromJson(item)).toList();
          setState(() {
            getNoteTypeAndIdFroDenominationListModel = filteredDataCashDenominationList;
            dataCashDenominationList = filteredDataCashDenominationList;
            isLoading = false;
            qtyController = List.generate(getNoteTypeAndIdFroDenominationListModel.length, (index) => TextEditingController());
            amounts = List.generate(getNoteTypeAndIdFroDenominationListModel.length, (index) => 0.0);
            finalAmountCashDeno = 0.0;
            isQtyFilled = {};
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load denomination data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error getNoteTypeAndIDList: $error");
      }
    }
  }

  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (bearerToken == null) { EasyLoading.dismiss(); throw Exception('Bearer token is missing'); }
    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/0'),
      headers: { 'Authorization': 'Bearer $bearerToken' },
    );
    debugPrint("GetBankMappingDetailsList: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        bankModel = data.map((json) => GetBankMappingDetailsListModel.fromJson(json)).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load bank list');
    }
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      userId = preferences.getString("UserId").toString();
      debugPrint("User Name: $userName");
    } catch (error) {
      rethrow;
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
        if (bearerToken == null) { isLoading = false; throw Exception('Bearer token is missing'); }
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        Map<String, dynamic> requestBody = { "DistributorId": distributorId, "Date": formattedDate };
        final response = await http.post(
          Uri.parse('${AppUrl.GetCashHandOverDtls}'),
          headers: { 'Authorization': 'Bearer $bearerToken', 'Content-Type': 'application/json' },
          body: json.encode(requestBody),
        );
        debugPrint("Response body GetCashHandOverDtls: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashdatamodel = data.map((jsonItem) => GetCashHandOverDtlsListModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashdatamodel) {
              if (item.staffId.toString() == userId) {
                totalAmt = (item.totalAmt ?? 0.0).toDouble();
                break;
              }
            }
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load cash handover data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error getCashHandOverDtlsList: $error");
      }
    }
  }

  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (bearerToken == null) { EasyLoading.dismiss(); throw Exception('Bearer token is missing'); }
    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: { 'Authorization': 'Bearer $bearerToken' },
    );
    debugPrint("GetStaffDetailsList: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        staffmodel = data.map((json) => GetStaffDetailsListModel.fromJson(json)).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load staff list');
    }
  }

  Future<void> loadInitialStaffData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? staffId = prefs.getString('StaffId');
    if (staffId != null) {
      debugPrint("loadInitialStaffData staffId: $staffId");
    }
  }

  Future<void> getSalaryPaymentList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (bearerToken == null) { EasyLoading.dismiss(); throw Exception('Bearer token is missing'); }
    final response = await http.get(
      Uri.parse('${AppUrl.GetSalaryIncentiveEntryList}/$distributorId'),
      headers: { 'Authorization': 'Bearer $bearerToken' },
    );
    debugPrint("GetSalaryIncentiveEntryList: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        listModel = data.map((json) => GetSalaryIncentiveEntryListModel.fromJson(json)).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load salary payment list');
    }
  }

  Future<void> getVoucherNoForExpense() async {
    EasyLoading.show();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) { isLoading = false; EasyLoading.dismiss(); throw Exception('Bearer token is missing'); }
      final response = await http.get(
        Uri.parse('${AppUrl.GetVoucherNoForExpense}/$distributorId'),
        headers: { 'Authorization': 'Bearer $bearerToken' },
      );
      if (response.statusCode == 200) {
        String receiptNo = response.body.replaceAll('"', '');
        setState(() {
          receiptNoText = receiptNo;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        print('Failed to load voucher: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error getVoucherNoForExpense: $e');
    }
  }

  Future<void> getReceiptCashDenominationDtl(int salaryEntryId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (bearerToken == null) { EasyLoading.dismiss(); throw Exception('Bearer token is missing'); }
    final response = await http.get(
      Uri.parse('${AppUrl.GetCashDenominationDtlsById}/$salaryEntryId/$distributorId'),
      headers: { 'Authorization': 'Bearer $bearerToken' },
    );
    debugPrint("GetCashDenominationDtlsById: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        returndenominationModel = data.map((json) => GetCashDenominationDtlsByIdModel.fromJson(json)).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load denomination details');
    }
  }

  void initializeControllers() {
    qtyController = List.generate(returndenominationModel.length, (index) {
      return TextEditingController(
        text: returndenominationModel[index].qty?.toString() ?? "0",
      );
    });
    amounts = List.generate(returndenominationModel.length, (index) {
      final qty = returndenominationModel[index].qty?.toDouble() ?? 0.0;
      final noteType = returndenominationModel[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType;
    });
    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);
    finalAmountCashDeno = totalAmount;
    isQtyFilled = Map.fromIterable(
      List.generate(returndenominationModel.length, (index) => index),
      key: (index) => index,
      value: (index) => (returndenominationModel[index].qty ?? 0) > 0,
    );
  }

  Future<void> SalaryIncentiveEntryAddEdit(int salaryId, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? userId = prefs.getString("UserId");
    int? distributorIds = int.tryParse(distributorId ?? '0') ?? 0;
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    double paidAmt = 0.0;
    String tranCode = '';
    String tranTime = '';
    String tranReview = '';
    String remark = '';
    int bankId = 0;
    int accMappingIds = 0;

    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0,
        "NoteQty": qtyController.length > index && qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) ?? 0 : 0,
        "NoteAmt": amounts.length > index ? amounts[index] : 0.0,
        "RetNoteQty": 0,
        "RetNoteAmt": 0.0,
      };
    }).toList();

    if (action != "DELETE") {
      if (_balanceController.text.isNotEmpty) {
        paidAmt = double.tryParse(_balanceController.text) ?? 0.0;
      }
      tranCode = TranCodeController.text.isNotEmpty ? TranCodeController.text : '';
      tranTime = timeController.text.isNotEmpty ? timeController.text : '';
      tranReview = transReviewController.text.isNotEmpty ? transReviewController.text : '';
      remark = remarkController.text.isNotEmpty ? remarkController.text : '';

      // Validations
      if (selectedstaff == null) {
        showFlushBar(context, Constants.reqfield);
        return;
      }
      if (paidAmt <= 0) {
        showFlushBar(context, Constants.reqfield);
        return;
      }
      if (selectedTransMode == null || selectedTransMode!.isEmpty) {
        showFlushBar(context, Constants.reqfield);
        return;
      }
      if (selectedTransMode == 'Online') {
        if (_selectBankModel == null || (_selectBankModel!.accountNo ?? '').isEmpty) {
          showFlushBar(context, Constants.bankname);
          return;
        }
        if (!TranCodeController.text.isNotEmpty) {
          showFlushBar(context, Constants.transCode);
          return;
        }
      }
      // if (selectedTransMode == 'Cash' && cashDenominationMandatory && isCashDenominationChecked) {
      //   if (totalAmount <= 0) {
      //     showFlushBar(context, Constants.cashDenominationIsMandatory);
      //     return;
      //   }
      // }

      if (selectedTransMode == 'Cash' && cashDenominationMandatory) {
        if (totalAmount <= 0) {
          showFlushBar(context, Constants.cashDenominationIsMandatory);
          return;
        }
      }

      if (_selectBankModel != null) {
        bankId = selecteBankIDApi ?? 0;
        accMappingIds = accMappingId ?? 0;
      }
    }

    final Map<String, dynamic> requestBody = {
      "SalaryEntryId": salaryId,
      "DistributorId": distributorIds,
      "PaidDate": formattedDate,
      "StaffId": selectedItemId ?? 0,
      "PaidAgainst": selectedpaidAgainstSalary ?? '',
      "PaidSalaryAmt": paidAmt,
      "PaymentMode": selectedTransMode ?? '',
      "BankMappingId": accMappingIds,
      "BankId": bankId,
      "TransactionCode": tranCode,
      "TransactionTime": tranTime,
      "TransactionRemark": tranReview,
      "Remark": remark,
      "AddedBy": userId ?? '',
      "Action": action,
      "DenomDtList": dataCashDenomination,
    };
    debugPrint("SalaryIncentiveEntryAddEdit requestBody: $requestBody");

    final response = await http.post(
      Uri.parse('${AppUrl.SalaryIncentiveEntryAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    debugPrint("SalaryIncentiveEntryAddEdit response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      if (response.body == '0') {
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
      } else {
        Navigator.pushNamed(context, SalaryPaymentScreen.screenName);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (action == "DELETE") {
            EasyLoading.showToast(Constants.expenseSendMgrDelete, duration: const Duration(milliseconds: 3000));
          } else if (action == "EDIT") {
            EasyLoading.showToast(Constants.expenseSendMgrEdit, duration: const Duration(milliseconds: 3000));
          } else {
            EasyLoading.showToast(Constants.expenseSendMgr, duration: const Duration(milliseconds: 3000));
          }
        });
        setState(() { getSalaryPaymentList(); });
      }
    } else {
      debugPrint("Error SalaryIncentiveEntryAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

}



