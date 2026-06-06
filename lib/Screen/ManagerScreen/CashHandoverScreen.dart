import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';
import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import 'BootomNavigatinBarManager.dart';
import 'CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import 'CashHandoverListViewUI.dart';
import 'CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import 'CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import 'CashHandoverModelClass/GetStaffDetailsListUserIsMadeModel.dart';
import 'ManagerModelClass/DenomModel.dart';
import 'ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
class CashHandoverScreen extends StatefulWidget {
  static const screenName = '/cashHandoverScreen';
  const CashHandoverScreen({super.key});

  @override
  State<CashHandoverScreen> createState() => _CashHandoverScreenState();
}

class _CashHandoverScreenState extends State<CashHandoverScreen> {
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  List<CylItemListModel> _items = [];
  List<GetStaffDetailsListUserIsMadeModel> staffdetailsmodel = [];
  List<GetCashHandOverDtlsModel> cashInHandDetails = [];
  GetStaffDetailsListUserIsMadeModel? _selectedItemModel;
  List<GetBankMappingDetailsListModel> bankmappingModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  double totalAmountCashDenomination = 0;
  GetBankMappingDetailsListModel? _selectBankModel;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  List<TextEditingController> qtyController = [];
  List<double> amounts = [];
  double totalAmount = 0.0;// Keep track of the total amount.

  String? _selectedItem;
  int? selectedItemId;
  bool isLoading = true;
  Map<int, String?> _selectedItems = {};
  DateTime? date;
  var argValue;
  String? userName,userId;
  double? totalamt;
  List<String> getTransMode = ["ATM","BRANCH"];
  List<String> getTransModeListForBank(GetBankMappingDetailsListModel? bank) {
    // Implement logic to return transaction modes based on the bank
    return ['ATM', 'BRANCH']; // Example
  }
  String? _selectedItemId;
  String? _selectedItemName;
  String? selectedBankName;
  String? selectedBankId;
  String? selectedTransMode;
  int? selecteBankIDApi;
  int? accMappingId;
  bool isCashDenominationListViewVisible = false;
  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool isBankDisabled = false;
  bool isStaffSelected = false;
  double? balancedamt;
  double? cashamt;

  final depositController = TextEditingController();
  bool _isDepositEmpty = false;
  double remainingAmount = 0.0;
  bool saveFlag = false;
  bool isCashDenominationChecked = false;
  @override
  void initState() {

    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-mm-yyyy').format(now);
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    fetchItems();
    fetchStaff();
    fetchBank();
    fetchSavedData();
    fetchStaffList(selectedDate);
    getNoteTypeAndIDList();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    for (var controller in qtyController) {
      controller.dispose();
    }
    super.dispose();
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
        appBar: CustomAppBarManagerr(title: 'Cash Handover - Bank Deposit'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Hero strip (matches ManagerDashboard gradHero) ───────────
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
                          Text('Cash Handover',
                              style: AppTypography.heroTitle),
                          const SizedBox(height: 4),
                          Text('Deposit handover details and denomination',
                              style: AppTypography.heroSubtitle),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text('Date',
                              style: AppTypography.labelSM
                                  .copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          const SizedBox(height: 2),
                          Text(formattedDate,
                              style: AppTypography.cardTitle.copyWith(color: AppColors.white)),
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
                    // ── Info card ────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                        children: [
                          _infoRow('Deposit By', userName ?? '-'),
                          const Divider(height: 16, thickness: 1, color: Color(0xFFF1F5F9)),
                          _infoRow('Cash In Hand',
                              '₹ ${(totalamt ?? 0).toStringAsFixed(2)}',
                              valueColor: AppColors.blue),
                          const Divider(height: 16, thickness: 1, color: Color(0xFFF1F5F9)),
                          _infoRow('Balanced Amount',
                              '₹ ${remainingAmount.toStringAsFixed(2)}',
                              valueColor: remainingAmount > 0 ? AppColors.teal : AppColors.textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Form card ─────────────────────────────────────────
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
                          // Cash Handover To
                          _buildFieldLabel('Cash Handover To', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<GetStaffDetailsListUserIsMadeModel>(
                            isExpanded: true,
                            key: formKey1,
                            value: _selectedItemModel,
                            decoration: _inputDecoration(hint: 'Select Staff'),
                            items: staffdetailsmodel
                                .map((item) =>
                                    DropdownMenuItem<GetStaffDetailsListUserIsMadeModel>(
                                      value: item,
                                      child: Text(item.staffName ?? '',
                                          style: AppTypography.dataRowValue),
                                    ))
                                .toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                _selectedItemModel = selectedItem;
                                _selectedItem = selectedItem?.staffName ?? '';
                                selectedItemId = selectedItem?.userId?.toInt();
                                _selectBankModel = null;
                                selectedBankName = null;
                                selectedBankId = null;
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          // OR divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFF1F5F9))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('OR',
                                    style: AppTypography.labelMD
                                        .copyWith(color: AppColors.textMuted)),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFF1F5F9))),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Bank Account
                          _buildFieldLabel('Select Bank Account No.', required: true),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<GetBankMappingDetailsListModel>(
                            isExpanded: true,
                            key: formKey2,
                            value: _selectBankModel,
                            decoration: _inputDecoration(hint: 'Select Bank Account'),
                            items: bankmappingModel
                                .map((item) =>
                                    DropdownMenuItem<GetBankMappingDetailsListModel>(
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
                                getTransMode = getTransModeListForBank(selectedItem);
                                selecteBankIDApi = selectedItem?.bankId?.toInt();
                                accMappingId = selectedItem?.mappingId?.toInt();
                                selectedTransMode = null;
                                _selectedItemModel = null;
                                _selectedItem = null;
                                selectedItemId = null;
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          // Deposit Amount
                          _buildFieldLabel('Cash Hand / Deposit Amt.', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: depositController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            style: AppTypography.dataRowValue,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            decoration: _inputDecoration(hint: 'Enter Deposit Amt.').copyWith(
                              errorText:
                                  _isDepositEmpty ? 'Deposit Amt. is Required' : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isDepositEmpty = value.isEmpty;
                                double val = double.parse(value);
                                if (val > totalamt!) {
                                  depositController.clear();
                                  remainingAmount = 0;
                                } else {
                                  updateRemainingAmount();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 14),

                          // Deposit Mode (shown when bank is selected)
                          if (selectedBankName != null) ...[
                            _buildFieldLabel('Select Deposit Mode', required: true),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              key: formKey3,
                              value: selectedTransMode,
                              decoration: _inputDecoration(hint: 'Select Mode'),
                              isExpanded: true,
                              items: getTransMode
                                  .map((String v) =>
                                      DropdownMenuItem<String>(value: v, child: Text(v)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() { selectedTransMode = value; });
                              },
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Cash Denomination checkbox
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.blueXXL,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                            ),
                            child: CheckboxListTile(
                              dense: true,
                              title: Text(
                                cashDenominationMandatory
                                    ? 'Cash Denomination (Mandatory)'
                                    : 'Cash Denomination',
                                style: AppTypography.dataRowLabel,
                              ),
                              value: isCashDenominationChecked,
                              activeColor: AppColors.blue,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCashDenominationChecked = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),

                          // Denomination table
                          if (isCashDenominationChecked) ...[
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x0D1E3A8A),
                                      blurRadius: 8,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                      color: AppColors.blueXXL,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 2,
                                            child: Center(child: Text('Note Type',
                                                style: AppTypography.dataRowLabel))),
                                        Expanded(flex: 3,
                                            child: Center(child: Text('Qty',
                                                style: AppTypography.dataRowLabel))),
                                        Expanded(flex: 3,
                                            child: Center(child: Text('Amount',
                                                style: AppTypography.dataRowLabel))),
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
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: Color(0xFFF1F5F9))),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(flex: 2,
                                                child: Center(child: Text('${data.noteType}',
                                                    style: AppTypography.dataRowValue))),
                                            Expanded(flex: 1,
                                                child: Center(child: Text('X',
                                                    style: AppTypography.dataRowLabel))),
                                            Expanded(
                                              flex: 3,
                                              child: TextField(
                                                controller: qtyController[index],
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                textAlign: TextAlign.center,
                                                style: AppTypography.dataRowValue,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                      borderSide: const BorderSide(color: Color(0xFFF1F5F9))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                      borderSide: const BorderSide(color: Color(0xFFF1F5F9))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                      borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
                                                  filled: true,
                                                  fillColor: AppColors.bg2,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;
                                                    totalAmount = amounts.fold(0.0, (sum, amount) => sum + amount);
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(flex: 1,
                                                child: Center(child: Text('=',
                                                    style: AppTypography.dataRowLabel))),
                                            Expanded(flex: 3,
                                                child: Center(child: Text(
                                                    amounts[index].toStringAsFixed(2),
                                                    style: AppTypography.dataRowValue))),
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
                                        Text('Total Amount : ', style: AppTypography.dataRowLabel),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.blueXXL,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(totalAmount.toStringAsFixed(2),
                                              style: AppTypography.dataRowValue.copyWith(color: AppColors.blue)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      updateCashAddEditForMob();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: saveFlag ? AppColors.textMuted : AppColors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                  ),
                                  child: Text('Save',
                                      style: AppTypography.labelMD
                                          .copyWith(color: AppColors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Cash-in-hand staff table ─────────────────────────
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
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.blueXXL,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 1,
                                    child: Text('Sr.No.',
                                        style: AppTypography.dataRowLabel,
                                        textAlign: TextAlign.center)),
                                Container(width: 1, height: 20, color: AppColors.border2),
                                Expanded(flex: 3,
                                    child: Text('Staff Name',
                                        style: AppTypography.dataRowLabel,
                                        textAlign: TextAlign.center)),
                                Container(width: 1, height: 20, color: AppColors.border2),
                                Expanded(flex: 2,
                                    child: Text('Cash In Hand',
                                        style: AppTypography.dataRowLabel,
                                        textAlign: TextAlign.center)),
                              ],
                            ),
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                          cashInHandDetails.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cashInHandDetails.length,
                                  itemBuilder: (context, index) {
                                    return CashHandoverListViewUI(
                                        cashInHandDetails[index],
                                        index + 1,
                                        cashInHandDetails.length);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                      child: Text('No Records Found',
                                          style: AppTypography.cardSubtitle)),
                                ),
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
    );
  }

  // ── Private UI helpers ────────────────────────────────────────────────────
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
      filled: true,
      fillColor: AppColors.bg2,
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
            child: Text(label,
                style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted))),
        Text(value,
            style: AppTypography.dataRowValue
                .copyWith(color: valueColor ?? AppColors.textMid)),
      ],
    );
  }

  // Fetch data from API
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
    debugPrint("item" + response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }
  Future<void> fetchStaff() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,

    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsListUserIsMade}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsListUserIsMade : " + '${AppUrl.GetStaffDetailsListUserIsMade}/$distributorId');
    debugPrint("GetStaffDetailsListUserIsMade : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        staffdetailsmodel = data.map((json) {
          // String dateString = json['TransDate'];
          // DateTime date = DateTime.parse(dateString);
          // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // json['TransDate'] = formattedDate;

          return GetStaffDetailsListUserIsMadeModel.fromJson(json);
        }).toList();
        isLoading = false;
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
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankMappingDetailsListModel : " + '${AppUrl.GetBankMappingDetailsList}/$distributorId/0');
    debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        bankmappingModel = data.map((json) {
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
  Future<void> fetchStaffList(DateTime date) async {
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

        //DateTime now = DateTime.now();
        // String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        // debugPrint("formattedDate :- ${formattedDate.toString()}");

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
        debugPrint("Request body GetCashHandOverDtls: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashInHandDetails = data.map((jsonItem) =>
                GetCashHandOverDtlsModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashInHandDetails) {
              if (item.staffId.toString() == userId) {
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
  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      debugPrint("User Name:- $userName");
    } catch (error) {
      rethrow;
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
  void updateRemainingAmount() {
    final deposit = double.tryParse(depositController.text) ?? 0.0;
    final total = totalamt ?? 0.0;

    setState(() {
      remainingAmount = total - deposit;
    });
  }
  void cancelAction(){
    setState(() {
      _selectedItemModel = null;
      _selectedItem = '';
      selectedItemId = null;
      _selectBankModel = null;
      selectedBankName = '';
      selectedBankId = null;
      depositController.clear();
      selectedTransMode = null;

    });
    formKey1.currentState?.reset();
    formKey2.currentState?.reset();
    formKey3.currentState?.reset();
  }
  Future<void> updateCashAddEditForMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    double hvrBnkDepAmt = 0;
    // if(depositController.text.isNotEmpty){
    //   hvrBnkDepAmt = double.parse(depositController.text);
    //   if(totalAmount != null){
    //     if(totalAmount != hvrBnkDepAmt){
    //       showFlushBar(context, Constants.cashHandOverDeno);
    //       return;
    //     }
    //   }
    // }else{
    //   showFlushBar(context, Constants.cashAmount);
    // }

    if((_selectedItem == null || selectedItemId == null) && (selectedBankName == null || selectedBankId == null)){
      showFlushBar(context, Constants.selectValidItemReceipt);
      return;
    }

    if(selectedBankName != null || selectedBankId != null){
      if(selectedTransMode == null){
        showFlushBar(context, Constants.selectValidItemReceipt);
        return;
      }
    }

    if (cashDenominationMandatory) {
      if (depositController.text.isEmpty) {
        showFlushBar(context, Constants.cashAmount);
        return;
      }

      hvrBnkDepAmt = double.parse(depositController.text);

      if (totalAmount == null || totalAmount <= 0) {
        showFlushBar(context, Constants.cashDenominationIsMandatory);
        return;
      }

      if (totalAmount != hvrBnkDepAmt) {
        showFlushBar(context, Constants.cashHandOverDeno);
        return;
      }
    } else {
      // Bank / BRANCH â†’ denomination NOT mandatory
      if (depositController.text.isEmpty) {
        showFlushBar(context, Constants.cashAmount);
        return;
      }
      hvrBnkDepAmt = double.parse(depositController.text);
    }

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
    if(cashDenominationMandatory){
      if(depositController.text.isNotEmpty){
        hvrBnkDepAmt = double.parse(depositController.text);
        if(totalAmount != null || totalAmount>0){
          if(totalAmount != hvrBnkDepAmt){
            showFlushBar(context, Constants.cashHandOverDeno);
            return;
          }
        }else{
          showFlushBar(context, Constants.cashDenominationIsMandatory);
          return;
        }
      }else{
        showFlushBar(context, Constants.cashAmount);
        return;
      }
    }

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
      "HvrBnkDepId": 0,
      "DistributorId":distributorIds,
      "HvrBnkDepDate": formattedDate,
      "HvrBnkDepFrom": userId,
      "CashInHand":totalamt,
      "HandoverToId": selectedItemId,
      "BankId":bankId ,
      "AccMappingId":accMappingIds,
      "HvrBnkDepAmt":hvrBnkDepAmt,
      "BalAmt": remainingAmount,
      "DepositMode":selectedTransMode ?? '',
      "HandoverStatus": 2,
      "AddedBy": userId,
      "UpdatedFrom": 'MOB',
      "DenomDtList": dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
      final response = await http.post(
        Uri.parse('${AppUrl.DepositCashAddEdit}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: json.encode(requestBody),
      );
      // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
      print(
          "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response UpdateSaleAddEditForMob: ${response.body}");

        Navigator.pushNamed(
          context,
          BottomNavBarExample.screenName,
          arguments: 3, // This opens the third tab
        );
        EasyLoading.showToast(Constants.expenseSendMgr,
            duration: const Duration(milliseconds: 3000));
        setState(() {
          fetchStaffList(selectedDate);
        });
      } else {
        // Error response
        print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
      }
    // } catch (e) {
    //   // Exception handling
    //   print("Exception UpdateSaleAddEditForMob: $e");
    // }
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
