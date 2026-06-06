import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../ARBScreen/GetCashDenominationDtlsByIdModel.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import 'TodaysCashSummaryOnAccountList.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT RECEIPT SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class OnAccountPopupScreen extends StatefulWidget {
  static const screenName = '/onAccountPopupScreen';

  const OnAccountPopupScreen({super.key});

  @override
  State<OnAccountPopupScreen> createState() => _OnAccountPopupScreenState();
}

class _OnAccountPopupScreenState extends State<OnAccountPopupScreen> {
  // ── Form keys ──
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  // ── Transaction mode ──
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;

  // ── Bank / denomination models ──
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetCashDenominationDtlsByIdModel> denominationModel = [];
  GetCashDenominationDtlsByIdModel? _selectDenomination;

  // ── UI state ──
  bool isLoading = true;
  int _selectedIndex = 0; // 0 = Cash Denomination, 1 = Cash Return

  // ── Date ──
  String? formattedDate;

  // ── Denomination lists ──
  List<DenomModel> getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  late List<TextEditingController> qtyController;
  late List<double> amounts;

  // ── Bank selection ──
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;

  // ── Amounts ──
  double totalAmount = 0.0;
  bool _isTranscode = false;
  List<TextEditingController> qtyControllerReturn = [];
  List<double> amountsReturn = [];
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  double balanceAmount = 0.0;
  Map<int, bool> isQtyFilled = {};

  // ── Text controllers ──
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  late final _balanceController = TextEditingController();
  late final recDateController = TextEditingController();
  late final categoryController = TextEditingController();
  late final staffNameController = TextEditingController();
  late final balanceController = TextEditingController();

  // ── Flags ──
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

  // ── Route arguments ──
  String? ledgerId;
  String? receiptDate;
  String? category;
  String? selectedstaffId;
  String? staffName;
  String? totalBalanceAmt;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  late List<String> selectedLedgerIds;

  // ─────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    fetchBank();
    getNoteTypeAndIDList();

    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();

    Future.delayed(Duration.zero, () {
      setState(() {
        final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
        if (argValue != null) {
          ledgerId = argValue["ledgerId"];
          category = argValue["category"];
          selectedstaffId = argValue["staffId"];
          staffName = argValue["staffName"];
          totalBalanceAmt = argValue["totalBalance"];
          selectedLedgerIds = List<String>.from(argValue["ledgerIds"] ?? []);
          print('Selected Ledger IDs: $selectedLedgerIds');
        } else {
          print('No arguments found!');
        }
      });
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      // appBar: _buildAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
          title: 'Payment Receipt',
          subtitle: staffName != null ? 'for $staffName' : '',
          icon: Icons.receipt_long_rounded,
          // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
          onBack: () => Navigator.pop(context)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoSummaryCard(
              date: formattedDate != null
                  ? DateFormat('dd/MM/yyyy').format(DateTime.parse(formattedDate!))
                  : '',
              staffName: staffName ?? '',
              category: category ?? '',
              totalBalance: totalBalanceAmt ?? '',
            ),
            const SizedBox(height: 16),
            _buildReceiptCard(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Receipt',
            style: AppTypography.heroTitle,
          ),
          Text(
            staffName != null ? 'for $staffName' : '',
            style: AppTypography.heroSubtitle,
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradHero),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RECEIPT FORM CARD
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildReceiptCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Receipt Amount',
            isRequired: true,
            child: _buildReceiptAmountField(),
          ),
          const SizedBox(height: 14),
          _buildFormField(
            label: 'Payment Mode',
            isRequired: true,
            child: _buildPaymentModeDropdown(),
          ),
          if (selectedTransMode == 'Cash') ...[
            const SizedBox(height: 16),
            _buildCashSection(),
          ],
          if (selectedTransMode == 'Online') ...[
            const SizedBox(height: 16),
            _buildOnlineSection(),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RECEIPT AMOUNT FIELD
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildReceiptAmountField() {
    return TextField(
      controller: _balanceController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        LengthLimitingTextInputFormatter(8),
      ],
      onChanged: (value) {
        setState(() {
          double enteredAmount = double.tryParse(value) ?? 0.0;
          double totalBalance = double.tryParse(totalBalanceAmt ?? '') ?? 0.0;
          if (enteredAmount > totalBalance) {
            showFlushBar(context, "Entered amount cannot be greater than the total balance.");
            _balanceController.clear();
          }
        });
      },
      decoration: InputDecoration(
        hintText: 'Enter Receipt Amount',
        hintStyle: AppTypography.cardSubtitle,
        errorText: _isDepositEmpty ? 'Amount is required' : null,
        prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 18, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.primaryXLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAYMENT MODE DROPDOWN
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildPaymentModeDropdown() {
    return DropdownButtonFormField<String>(
      key: formKey1,
      value: selectedTransMode,
      decoration: InputDecoration(
        hintText: 'Select mode',
        filled: true,
        fillColor: AppColors.primaryXLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      items: getTransMode
          .map((v) => DropdownMenuItem(value: v, child: Text(v, style: AppTypography.cardSubtitle.copyWith(color: AppColors.textPrimary))))
          .toList(),
      onChanged: (value) => setState(() => selectedTransMode = value),
      isExpanded: true,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CASH SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mandatory label
        Row(
          children: [
            Icon(
              cashDenominationMandatory ? Icons.warning_amber_rounded : Icons.account_balance_wallet_outlined,
              size: 16,
              color: cashDenominationMandatory ? AppColors.orange : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              cashDenominationMandatory
                  ? 'Cash Denomination Is Mandatory'
                  : 'Cash Denomination',
              style: AppTypography.cardTitle.copyWith(
                color: cashDenominationMandatory ? AppColors.orange : AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Toggle tabs
        _CashTabToggle(
          selectedIndex: _selectedIndex,
          onTabSelected: (index) => setState(() => _selectedIndex = index),
        ),
        const SizedBox(height: 12),
        // Cash denomination table
        Visibility(
          visible: _selectedIndex == 0,
          child: _DenominationTable(
            noteList: getNoteTypeAndIdFroDenominationListModel,
            qtyControllers: qtyController,
            amounts: amounts,
            isQtyFilled: isQtyFilled,
            totalLabel: 'Collected',
            totalAmount: totalAmount,
            onAmountChanged: (index, value, noteType) {
              setState(() {
                amounts[index] = (double.tryParse(value) ?? 0.0) * (noteType ?? 0);
                totalAmount = amounts.fold(0.0, (s, a) => s + a);
                finalAmountCashDeno = totalAmount - returnAmount;
                isQtyFilled[index] = value.isNotEmpty;
              });
            },
            isReadOnly: false,
          ),
        ),
        // Cash return table
        Visibility(
          visible: _selectedIndex == 1,
          child: _DenominationTable(
            noteList: getNoteTypeAndIdFroDenominationListModel,
            qtyControllers: qtyControllerReturn,
            amounts: amountsReturn,
            isQtyFilled: const {},
            totalLabel: 'Return',
            totalAmount: returnAmount,
            onAmountChanged: (index, value, noteType) {
              setState(() {
                amountsReturn[index] = (double.tryParse(value) ?? 0.0) * (noteType ?? 0);
                returnAmount = amountsReturn.fold(0.0, (s, a) => s + a);
                finalAmountCashDeno = totalAmount - returnAmount;
              });
            },
            isReadOnly: false,
            showFinalTotal: true,
            finalTotal: finalAmountCashDeno,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ONLINE SECTION
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildOnlineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bank dropdown
        DropdownButtonFormField<GetBankMappingDetailsListModel>(
          value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
          decoration: InputDecoration(
            labelText: 'Bank Account',
            labelStyle: AppTypography.labelMD,
            prefixIcon: const Icon(Icons.account_balance_rounded, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.primaryXLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryXXLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryXXLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          items: bankModel.map((item) {
            return DropdownMenuItem<GetBankMappingDetailsListModel>(
              value: item,
              child: Text(
                '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                style: AppTypography.cardSubtitle.copyWith(color: AppColors.textPrimary),
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
          hint: Text('Select Account', style: AppTypography.cardSubtitle),
          isExpanded: true,
        ),
        const SizedBox(height: 12),
        // Transaction Code + Time row
        Row(
          children: [
            Expanded(
              child: _buildStyledTextField(
                controller: TranCodeController,
                labelText: 'Transaction Code *',
                errorText: _isTranscode ? 'Transaction code is Required' : null,
                prefixIcon: Icons.tag_rounded,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                onChanged: (value) => setState(() => _isTranscode = value.isEmpty),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildStyledTextField(
                controller: timeController,
                labelText: 'Time (HH:MM)',
                prefixIcon: Icons.access_time_rounded,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Transaction Remark
        _buildStyledTextField(
          controller: transReviewController,
          labelText: 'Transaction Remark',
          prefixIcon: Icons.notes_rounded,
          inputFormatters: [LengthLimitingTextInputFormatter(250)],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ACTION BUTTONS
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: cancelAction,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border, width: 1.5),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Cancel',
              style: AppTypography.cardTitle.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: saveFlag
                ? null
                : () => staffLedgerSettlementAddEditMob(0, "ADD"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.textDisabled,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Save Receipt',
                  style: AppTypography.cardTitle.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SHARED HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.labelMD.copyWith(color: AppColors.textSecondary)),
            if (isRequired)
              Text(' *', style: AppTypography.labelMD.copyWith(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    IconData? prefixIcon,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: AppTypography.cardSubtitle.copyWith(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTypography.labelMD,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppColors.primary)
            : null,
        filled: true,
        fillColor: AppColors.primaryXLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUSINESS LOGIC (UNCHANGED)
  // ─────────────────────────────────────────────────────────────────────────

  void cancelAction() {
    setState(() {
      selectedBankName = '';
      selectedTransMode = null;
      selectedBankId = null;
      _selectBankModel = null;
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      _balanceController.clear();
      modes = "Save";
    });
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
    debugPrint("GetBankMappingDetailsListModel : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        bankModel = data.map((j) => GetBankMappingDetailsListModel.fromJson(j)).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> staffLedgerSettlementAddEditMob(int receiptNo, String action) async {
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
    String ledgerIdsString = selectedLedgerIds.join(',');

    // Build denomination list using the same field names as the original
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

    // Parse amount if not empty
    if (_balanceController.text.isNotEmpty) {
      totalAmt = double.parse(_balanceController.text);
    }

    double totalBalance = double.tryParse(totalBalanceAmt ?? '') ?? 0.0;

    // Validate cash denomination matches receipt amount
    if (selectedTransMode == "Cash") {
      if (finalAmountCashDeno > 0) {
        if (finalAmountCashDeno != totalAmt) {
          showFlushBar(context,
              "The Receipt amount and cash denomination total must be the same.");
          return;
        }
      }
    }
    if (cashDenominationMandatory) {
      if (selectedTransMode == "Cash") {
        if (finalAmountCashDeno > 0) {
          if (finalAmountCashDeno != totalAmt) {
            showFlushBar(context,
                "The Receipt amount and cash denomination total must be the same.");
            return;
          }
        } else {
          showFlushBar(context, Constants.cashDenominationIsMandatory);
          return;
        }
      }
    }

    tranCode = TranCodeController.text.isNotEmpty ? TranCodeController.text : "";
    tranTime = timeController.text.isNotEmpty ? timeController.text : "";
    remark = transReviewController.text.isNotEmpty ? transReviewController.text : "";

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

    final Map<String, dynamic> requestBody = {
      "ReceiptNo": receiptNo,
      "ReceiptFrom": "",
      "ReceiptDate": formattedDate,
      "StaffId": selectedstaffId,
      "Balance": totalBalanceAmt,
      "CustomerId": "",
      "Amount": 0,
      "ReceiptMode": selectedTransMode ?? '',
      "TransRemark": remark,
      "DistributorId": distributorId,
      "RemarkForVendor": "",
      "TransationCode": tranCode,
      "TransTime": tranTime,
      "Action": action,
      "AddedBy": userId ?? '',
      "ReceiptAmt": totalAmt,
      "ReceiptRemark": "",
      "BankId": bankId,
      "SettledFrom": category,
      "BankMappingId": accMappingIds ?? '',
      "LedgerIdstr": ledgerIdsString,
      "DenomDetailList": dataCashDenomination,
    };

    print("StaffLedgerAddEdit: $requestBody");
    requestBody.forEach((key, value) => print('$key: $value'));

    final response = await http.post(
      Uri.parse('${AppUrl.StaffLedgerSettlementAddEditMob_V1}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        EasyLoading.showToast("Something went wrong. Please try again.",
            duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        print("Response StaffLedgerAddEdit: ${response.body}");
        Navigator.pushNamed(
          context,
          TodaysCashSummaryOnAccountList.screenName,
          arguments: {
            'staffId': selectedstaffId,
            'staffName': staffName,
          },
        );
        debugPrint("totalBalanceAmt: $totalBalanceAmt");
        Future.delayed(const Duration(milliseconds: 300), () {
          EasyLoading.showToast(Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000));
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.",
          duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> getNoteTypeAndIDList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      return;
    }
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
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint("Response body GetCashDenominationItemList: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          getNoteTypeAndIdFroDenominationListModel =
              data.map((item) => DenomModel.fromJson(item)).toList();
          qtyController = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (_) => TextEditingController());
          amounts = List.filled(getNoteTypeAndIdFroDenominationListModel.length, 0.0);
          qtyControllerReturn = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (_) => TextEditingController());
          amountsReturn =
              List.filled(getNoteTypeAndIdFroDenominationListModel.length, 0.0);
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      debugPrint("Error: $e");
    }
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
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
        } else {
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
          }
        }
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
      return;
    }
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
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cashDenoMandatoryList = data
              .map((jsonItem) => CahsDenominationMandatoryFlagModel.fromJson(jsonItem))
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

// ─────────────────────────────────────────────────────────────────────────────
// _InfoSummaryCard — shows date / staff / category / balance at the top
// ─────────────────────────────────────────────────────────────────────────────

class _InfoSummaryCard extends StatelessWidget {
  const _InfoSummaryCard({
    required this.date,
    required this.staffName,
    required this.category,
    required this.totalBalance,
  });

  final String date;
  final String staffName;
  final String category;
  final String totalBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _InfoChip(icon: Icons.calendar_today_rounded, label: 'Date', value: date),
              const SizedBox(width: 10),
              _InfoChip(icon: Icons.person_rounded, label: 'Staff', value: staffName),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _InfoChip(icon: Icons.category_rounded, label: 'Category', value: category),
              const SizedBox(width: 10),
              _InfoChip(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Total Balance',
                value: totalBalance,
                valueColor: const Color(0xFFBBF7D0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: Colors.white70),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelSM.copyWith(color: Colors.white54, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.isEmpty ? '—' : value,
                    style: AppTypography.labelMD.copyWith(
                      color: valueColor ?? Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionCard — white rounded card container
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CashTabToggle — segmented control for Cash Denomination / Cash Return
// ─────────────────────────────────────────────────────────────────────────────

class _CashTabToggle extends StatelessWidget {
  const _CashTabToggle({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final void Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryXXLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Cash Denomination',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
            leftRadius: true,
          ),
          _Tab(
            label: 'Cash Return',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
            rightRadius: true,
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leftRadius = false,
    this.rightRadius = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool leftRadius;
  final bool rightRadius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: leftRadius ? const Radius.circular(10) : Radius.zero,
              bottomLeft: leftRadius ? const Radius.circular(10) : Radius.zero,
              topRight: rightRadius ? const Radius.circular(10) : Radius.zero,
              bottomRight: rightRadius ? const Radius.circular(10) : Radius.zero,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: isSelected ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DenominationTable — shared table for Cash Denomination and Cash Return
// ─────────────────────────────────────────────────────────────────────────────

class _DenominationTable extends StatelessWidget {
  const _DenominationTable({
    required this.noteList,
    required this.qtyControllers,
    required this.amounts,
    required this.isQtyFilled,
    required this.totalLabel,
    required this.totalAmount,
    required this.onAmountChanged,
    required this.isReadOnly,
    this.showFinalTotal = false,
    this.finalTotal = 0.0,
  });

  final List<DenomModel> noteList;
  final List<TextEditingController> qtyControllers;
  final List<double> amounts;
  final Map<int, bool> isQtyFilled;
  final String totalLabel;
  final double totalAmount;
  final void Function(int index, String value, int? noteType) onAmountChanged;
  final bool isReadOnly;
  final bool showFinalTotal;
  final double finalTotal;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: _headerText('Note Type')),
                Expanded(flex: 3, child: _headerText('Qty', align: TextAlign.center)),
                Expanded(flex: 3, child: _headerText('Amount', align: TextAlign.right)),
              ],
            ),
          ),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: noteList.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final data = noteList[index];
              final isEven = index % 2 == 0;
              return Container(
                color: isEven ? AppColors.surface : AppColors.surfaceMuted,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  children: [
                    // Note type chip
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryXLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '₹${data.noteType}',
                          style: AppTypography.labelMD.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Qty input
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 38,
                        child: TextField(
                          controller: qtyControllers[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) => onAmountChanged(index, value, data.noteType?.toInt()),
                          textAlign: TextAlign.center,
                          enabled: !isQtyFilled.containsKey(index) || !isQtyFilled[index]!,
                          style: AppTypography.cardSubtitle.copyWith(
                              color: AppColors.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTypography.cardSubtitle,
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.primaryXLight,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.primaryXXLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.primaryXXLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Amount
                    Expanded(
                      flex: 3,
                      child: Text(
                        amounts.length > index
                            ? amounts[index].toStringAsFixed(2)
                            : '0.00',
                        style: AppTypography.cardSubtitle.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Footer totals
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(top: BorderSide(color: AppColors.primaryXXLight, width: 1)),
            ),
            child: Column(
              children: [
                _TotalRow(label: totalLabel, amount: totalAmount),
                if (showFinalTotal) ...[
                  const SizedBox(height: 4),
                  _TotalRow(
                    label: 'Final Total',
                    amount: finalTotal,
                    isPrimary: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String label, {TextAlign align = TextAlign.left}) {
    return Text(
      label,
      style: AppTypography.labelSM.copyWith(color: Colors.white, letterSpacing: 0.3),
      textAlign: align,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TotalRow — label + formatted amount in the table footer
// ─────────────────────────────────────────────────────────────────────────────

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.amount,
    this.isPrimary = false,
  });

  final String label;
  final double amount;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: isPrimary ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: AppTypography.alertValue.copyWith(
            color: isPrimary ? AppColors.primary : AppColors.textPrimary,
            fontSize: isPrimary ? 16 : 14,
          ),
        ),
      ],
    );
  }
}