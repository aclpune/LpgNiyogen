import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBSaleScreen/GetARBSalesListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../SVSaleModel/GetARBItemMasterListModel.dart';
import '../SVSaleModel/GetArbCurrentStockListModel.dart';
import '../SalaryPaymentScreen/GetStaffDetailsListModel.dart';
import 'GetARBSalesCashDenoDtlsByIdModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';


class ArbSaleScreen extends StatefulWidget {
  static const screenName = '/arbSaleScreen';

  const ArbSaleScreen({super.key});

  @override
  State<ArbSaleScreen> createState() => _ArbSaleScreen();
}

class _ArbSaleScreen extends State<ArbSaleScreen> {

  String? formattedDate;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  GetStaffDetailsListModel? selectedStaff;
  int? selectedReferredID;
  String? selectedReferredName;
  bool _isConsumerEmpty = false;
  bool _isInvoiceEmpty = false;
  bool _isconNoEmpty = false;
  bool isLoading = true;
  bool _isTranscode = false;
  List<GetArbSalesCashDenoDtlsByIdModel> denominationModel = [];
  GetArbSalesCashDenoDtlsByIdModel? _selectDenomination;
  final conNoController = TextEditingController();
  // final invNoController = TextEditingController();
  late final invNoController = TextEditingController();
  final conNameController = TextEditingController();
  final conContNoController = TextEditingController();
  final conAddNoController = TextEditingController();
  final totalAmountController = TextEditingController();
  final TranCodeController = TextEditingController();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final cashTotalReceiptAmount = TextEditingController();
  final merchantQrTotalReceiptAmount = TextEditingController();
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  bool _isConCOntactEmpty = false;
  List<GetArbSalesListModel> arbSalesModel = [];
  List<Map<String, TextEditingController>> items = [];
  Map<int, String?> _selectedItems = {};
  List<GetArbItemMasterListModel> _items = [];
  List<GetArbCurrentStockListModel> svcStock = [];
  GetArbCurrentStockListModel? _selectStockModel;
  Map<int, int?> _itemStockByIndex = {};
  Map<int, int?> _selectedItemIds = {};
  List<String> getTransMode = ["Cash", "Merchant QR","Partial"];
  String? selectedTransMode;
  int _selectedIndex = 0;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<TextEditingController> qtyControllerReturn = [];
  List<double> amounts = [];
  List<double> amountsReturn = [];
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  double balanceAmount = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  int? receiptFromID;
  bool saveFlag = false;
  String? modes;
  var argValue;
  int? arbSalesIdEdit;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  List<FocusNode> _discountFocusNodes = [];
  List<FocusNode> _dropdownFocusNodes = [];
  bool isEditingQR = false;
  bool isEditingCash = false;
  List<CahsDenominationMandatoryFlagModel> autoMnualList = [];
  bool invoiceAutoManualMandatory = false;
  bool isCashDenominationChecked = false;


  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    InvoiceAutoManualFlagMandatory();
    _addNewItem();
    getStaffDetailsList();
    getArbItemMasterListModel();
    getArbCurrentStockList();
    getNoteTypeAndIDList();
    fetchBank();
    getARBSalesItemPurList();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();

    Future.delayed(Duration.zero, ()  async {
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';
      if (argValue != null) {
        final itemsToShow = argValue["itemsToShow"] ?? [];
        arbSalesIdEdit = int.tryParse(argValue["arbSalesV"] ?? '') ?? 0;
        String salesDateEdit = argValue["salesDateV"] ?? 0;
        String paymentModeEdit = argValue["paymentModeV"] ?? 0;
        String referredByNameEdit = argValue["referredByNameV"] ?? '';
        String referredByIdEdit = argValue["referredByIdV"] ?? '';
        String consumerNoEdit = argValue["consumerNoV"] ?? 0;
        String consumerNameEdit = argValue["consumerNameV"] ?? 0;
        String consumerContactEdit = argValue["consumerContactV"] ?? '';
        String consumerAddressEdit = argValue["consumerAddressV"] ?? 0;
        // String InvoiceNoEdit = argValue["invoiceNumberV"] ?? 0;
        String InvoiceNoEdit = argValue["invoiceNumberV"]?.toString() ?? '';
        String InvoiceTypeEdit = argValue["invoiceTypeV"] ?? 0;


        if (itemsToShow.isNotEmpty) {
          _initializeItems(itemsToShow);
        } else {
          // If no initial data, start with an empty list or default values
          _initializeItems([]);
        }
        if(getTransMode.contains(paymentModeEdit)){
          selectedTransMode = paymentModeEdit;
        }
        else if(paymentModeEdit == "Bank"){
          selectedTransMode = "Merchant QR";
        }
        else{
          selectedTransMode = null;
        }

        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
        double amountCashEdit = double.tryParse(argValue["cashReceiptAmtV"] ?? '') ?? 0;
        double amountQrEdit = double.tryParse(argValue["qrReceiptAmtV"] ?? '') ?? 0;
        String transTimeEdit = argValue["transTimeV"] ?? 0;
        timeController.text = transTimeEdit;
        String transationCodeEdit = argValue["transationCodeV"] ?? 0;
        TranCodeController.text = transationCodeEdit;
        String transRemarkEdit = argValue["transRemarkV"] ?? 0;
        transReviewController.text = transRemarkEdit;
        totalAmountController.text = amountTotalEdit.toString();
        cashTotalReceiptAmount.text = amountCashEdit.toString();
        merchantQrTotalReceiptAmount.text = amountQrEdit.toString();
        String bankIdV = argValue["bankIdV"] ?? '';
        debugPrint("bank id1 $bankIdV");
        String accMappingIdEdit =argValue["mappingIdV"] ?? 0;
        _selectBankModel = bankModel.firstWhere(
              (item) => item.accountNo == bankIdV,
          orElse: () => GetBankMappingDetailsListModel(
            bankName: 'Default Bank',
            accountNo: '',
          ),
        );

        await getStaffDetailsList();
        await getStaffDetailsList().whenComplete((){
          debugPrint("referredByNameEdit:$referredByNameEdit");
          if(referredByNameEdit != "null" && referredByNameEdit.isNotEmpty && referredByNameEdit != null){
            setState(() {
              selectedStaff = staffdetailsmodel.firstWhere(
                    (item) => item.staffName == referredByNameEdit,
                orElse: () => GetStaffDetailsListModel(staffName: ''),
              );
              selectedReferredID = int.parse(referredByIdEdit);
              selectedReferredName = referredByNameEdit;
              // invNoController.text = InvoiceNoEdit;
              // Set controller text and editable/read-only state
              // Determine if the invoice exists in the saved record
              final bool isExistingInvoice = InvoiceNoEdit.isNotEmpty &&
                  InvoiceNoEdit != "0" &&
                  InvoiceNoEdit != "null";

// Set controller text and editable/read-only state
              if (isExistingInvoice) {
                invNoController.text = InvoiceNoEdit;

                if (InvoiceTypeEdit == "Auto") {
                  invoiceAutoManualMandatory = true;  // read-only
                } else if (InvoiceTypeEdit == "Manual") {
                  invoiceAutoManualMandatory = false; // editable
                }
              } else {
                invNoController.clear();
                invoiceAutoManualMandatory = false; // default editable
                InvoiceAutoManualFlagMandatory();   // API call to determine default
              }

              conNoController.text = consumerNoEdit;
              conNameController.text = consumerNameEdit;
              conContNoController.text = consumerContactEdit;
              conAddNoController.text = consumerAddressEdit;
            }
            );
          }
        });

        // await getStaffDetailsList();
        //
        // debugPrint("referredByIdEdit: $referredByIdEdit");
        //
        // if (referredByIdEdit != null && referredByIdEdit!.isNotEmpty) {
        //   final staff = staffdetailsmodel.firstWhere(
        //         (item) => item.staffId.toString() == referredByIdEdit,
        //     orElse: () => GetStaffDetailsListModel(),
        //   );
        //
        //   if (staff.staffId != null) {
        //     setState(() {
        //       selectedStaff = staff;          // object from list
        //       selectedReferredID = staff.staffId?.toInt();
        //       selectedReferredName = staff.staffName;
        //     });
        //   }
        // }

        loadDenominationData(arbSalesIdEdit!);
        if(denominationModel.isNotEmpty){
          initializeControllers();
        }else{
          debugPrint("empty");
        }

        await fetchBank().whenComplete((){
          debugPrint("bank id2 $bankIdV");// wait for data first
          if (bankIdV.isNotEmpty && bankIdV != "null") {
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
      }
    });

  }

  void _addNewItem() {
    _discountFocusNodes.add(FocusNode());
    _dropdownFocusNodes.add(FocusNode());
    // Check if there are existing items
    if (items.isNotEmpty) {
      // Get the last added item
      var lastItem = items.last;

      // Extract and validate each controller's value
      String? rate = lastItem['rate']?.text.trim();
      String? qty = lastItem['qty']?.text.trim();
      String? discount = lastItem['discount']?.text.trim();
      String? amt = lastItem['amt']?.text.trim();

      if (rate!.isEmpty || qty!.isEmpty || amt!.isEmpty) {
        // Show a warning/toast/snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields before adding a new item.')),
        );
        return;
      }
    }

    // Add a new item if previous one is valid or if it's the first item
    setState(() {
      int newIndex = items.length;
      items.add({
        'selectItem':TextEditingController(),
        'rate': TextEditingController(),
        'qty': TextEditingController(),
        'discount': TextEditingController(),
        'amt': TextEditingController(),
      });
      _selectedItems[newIndex] = null;
    });
  }

  void _removeItem(int index) {
    setState(() {
      // Debugging: Print before removing
      print('Removing item at index: $index');
      print('Selected Items Before: $_selectedItems');

      // Dispose the TextEditingController instances associated with the index
      items[index]['rate']?.dispose();
      items[index]['qty']?.dispose();
      items[index]['discount']?.dispose();
      items[index]['amt']?.dispose();

      items.removeAt(index);

      _selectedItems.remove(index);
      _selectedItems = Map.fromEntries(
        _selectedItems.entries.map((entry) {
          return entry.key > index
              ? MapEntry(entry.key - 1,
              entry.value) // Shift keys down after the removed index
              : entry;
        }),
      );
      updateTotalAmount();
      // Debugging: Print after removing
      print('Selected Items After: $_selectedItems');

    });

  }
  @override
  void dispose() {
    for (var node in _discountFocusNodes) {
      node.dispose();
    }
    for (var node in _dropdownFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool get _isAddNewItemEnabled {
    // Check if there are any available items that haven't been selected yet
    return _items.any((item) => !_selectedItems.values.contains(item.itemName));
  }

  // â”€â”€â”€ UI HELPERS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  InputDecoration _themedInput(String hint, {String? errorText, Widget? suffixIcon, bool readOnly = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.labelMD.copyWith(color: AppColors.textMuted.withOpacity(0.6)),
      errorText: errorText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: readOnly ? AppColors.bg : AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.blueLight, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.red, width: 1.8),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border, width: 1.0),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 15, color: accentColor),
                const SizedBox(width: 6),
                Text(title, style: AppTypography.sectionHeader.copyWith(color: accentColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.labelMD),
          if (required) ...[
            const SizedBox(width: 3),
            const Text('*', style: TextStyle(color: AppColors.red, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldBlock(String label, Widget field, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, required: required),
        field,
        const SizedBox(height: 12),
      ],
    );
  }

  // â”€â”€â”€ BUILD â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
        appBar: CustomAppBarManagerr(title: 'ARB Sale'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // â”€â”€ SECTION 1: Sale Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _sectionCard(
                title: 'SALE INFORMATION',
                icon: Icons.receipt_long_rounded,
                accentColor: AppColors.blue,
                children: [
                  // Sale Date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Sale Date'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.blueLight),
                                  const SizedBox(width: 8),
                                  Text(
                                    formattedDate != null
                                        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(formattedDate!))
                                        : '',
                                    style: AppTypography.cardTitle.copyWith(color: AppColors.textMid),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Referred By
                  _fieldLabel('Referred By'),
                  DropdownButtonFormField<GetStaffDetailsListModel>(
                    key: formKey1,
                    value: staffdetailsmodel.contains(selectedStaff) ? selectedStaff : null,
                    decoration: _themedInput('Select Staff'),
                    items: staffdetailsmodel.map((GetStaffDetailsListModel staff) {
                      return DropdownMenuItem<GetStaffDetailsListModel>(
                        value: staff,
                        child: Text(staff.staffName ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStaff = value;
                        selectedReferredID = value?.staffId!.toInt();
                        selectedReferredName = value?.staffName!.toString();
                        debugPrint("selectedReferredID $selectedReferredID");
                      });
                    },
                    isExpanded: true,
                  ),
                ],
              ),

              // â”€â”€ SECTION 2: Consumer Details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _sectionCard(
                title: 'CONSUMER DETAILS',
                icon: Icons.person_rounded,
                accentColor: AppColors.teal,
                children: [
                  // Consumer No.
                  _fieldLabel('Consumer No.'),
                  TextField(
                    controller: conNoController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _themedInput('Enter Consumer No.'),
                    onChanged: (value) { setState(() {}); },
                  ),
                  const SizedBox(height: 12),
                  // Invoice No.
                  _fieldLabel('Invoice No. OR DC No.', required: true),
                  TextField(
                    controller: invNoController,
                    readOnly: invoiceAutoManualMandatory,
                    enabled: true,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    inputFormatters: invoiceAutoManualMandatory
                        ? []
                        : <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(16),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _themedInput(
                      invoiceAutoManualMandatory ? 'Invoice No. (Auto)' : 'Enter Invoice No.',
                      readOnly: invoiceAutoManualMandatory,
                      errorText: _isInvoiceEmpty ? 'Invoice No. OR DC No. Is Required' : null,
                      suffixIcon: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: invoiceAutoManualMandatory ? 'auto-generated Invoice number' : 'Manual Invoice Number',
                        child: Icon(Icons.info_outline_rounded, color: AppColors.blueLight),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() { _isInvoiceEmpty = value.isEmpty; });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Consumer Name
                  _fieldLabel('Consumer Name', required: true),
                  TextField(
                    controller: conNameController,
                    decoration: _themedInput('Enter Consumer Name',
                      errorText: _isconNoEmpty ? 'Consumer Name Is Required' : null,
                    ),
                    onChanged: (value) {
                      setState(() { _isconNoEmpty = value.isEmpty; });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Consumer Contact No.
                  _fieldLabel('Consumer Contact No.'),
                  TextField(
                    controller: conContNoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: _themedInput('Enter Consumer Contact No.',
                      errorText: _isConCOntactEmpty
                          ? 'Please Enter A Valid Consumer Contact No.'
                          : _isInvalidMobile
                          ? 'Please Enter A Valid Consumer Contact No.'
                          : _isShortLength
                          ? 'Consumer Contact No. must be 10 digits'
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
                    },
                  ),
                  const SizedBox(height: 12),
                  // Consumer Address
                  _fieldLabel('Consumer Address'),
                  TextField(
                    controller: conAddNoController,
                    inputFormatters: [LengthLimitingTextInputFormatter(250)],
                    decoration: _themedInput('Enter Consumer Address'),
                    onChanged: (value) {},
                  ),
                ],
              ),

              // â”€â”€ SECTION 3: Items â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _sectionCard(
                title: 'SALE ITEMS',
                icon: Icons.inventory_2_rounded,
                accentColor: AppColors.orange,
                children: [
                  // Add New Item button
                  Row(
                    children: [
                      Text('Add Item', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _isAddNewItemEnabled ? _addNewItem : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            gradient: _isAddNewItemEnabled ? AppColors.gradPrimary : null,
                            color: _isAddNewItemEnabled ? null : AppColors.border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintText: 'Select Item *',
                                      hintStyle: AppTypography.labelMD.copyWith(color: AppColors.textMuted),
                                      filled: true,
                                      fillColor: AppColors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: AppColors.border),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: AppColors.border),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: AppColors.blueLight, width: 1.8),
                                      ),
                                    ),
                                    value: _selectedItems[index]?.isEmpty ?? true ? null : _selectedItems[index],
                                    items: _items
                                        .where((item) =>
                                    !_selectedItems.values.contains(item.itemName) ||
                                        _selectedItems[index] == item.itemName)
                                        .toSet()
                                        .map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.itemName,
                                        child: Text(item.itemName ?? 'Unknown'),
                                      );
                                    }).toList(),
                                    onChanged: (selectedItemName) {
                                      if (selectedItemName != null) {
                                        setState(() {
                                          _selectedItems[index] = selectedItemName;
                                          final selectedItem = _items.firstWhere(
                                                (item) => item.itemName == selectedItemName,
                                            orElse: () => GetArbItemMasterListModel(),
                                          );
                                          int? currentStock = getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
                                          _itemStockByIndex[index] = currentStock;
                                          _selectedItemIds[index] = selectedItem.itemId?.toInt();
                                          String? category = selectedItem.categoryName;
                                          if (category != "Non ARB Item" && currentStock == 0 || currentStock == null) {
                                            items[index]['amt']?.clear();
                                            items[index]['qty']?.clear();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('The Item Quantity Cannot Exceed The Available Stock: $currentStock')),
                                            );
                                            double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                            double amount = 0;
                                            items[index]['rate']?.text = rate.toString();
                                            items[index]['amt']?.text = amount.toString();
                                            items[index]['qty']?.text = '1';
                                            items[index]['discount']?.clear();
                                            print("Selected item: ${selectedItem.itemName}");
                                            print("Rate: $rate");
                                            print("Amount: $amount");
                                          } else {
                                            double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                            double amount = rate * 1;
                                            items[index]['rate']?.text = rate.toString();
                                            items[index]['amt']?.text = amount.toString();
                                            items[index]['qty']?.clear();
                                            items[index]['discount']?.clear();
                                            print("Selected item: ${selectedItem.itemName}");
                                            print("Rate: $rate");
                                            print("Amount: $amount");
                                            items[index]['qty']?.text = '1';
                                          }
                                          _updateSum(index);
                                          updateTotalAmount();
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            if (_discountFocusNodes.length > index) {
                                              FocusScope.of(context).requestFocus(_discountFocusNodes[index]);
                                            }
                                          });
                                          if (index == items.length - 1) {
                                            _addNewItem();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () { _removeItem(index); },
                                  child: Container(
                                    width: 34, height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColors.redXL,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.redXXL),
                                    ),
                                    child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Rate', style: AppTypography.miniLabel),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: items[index]['rate'],
                                        enabled: false,
                                        style: AppTypography.labelMD.copyWith(color: AppColors.textMuted),
                                        decoration: _themedInput('0', readOnly: true),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text('Qty', style: AppTypography.miniLabel),
                                        const Text(' *', style: TextStyle(color: AppColors.red, fontSize: 11, fontWeight: FontWeight.w700)),
                                      ]),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: items[index]['qty'],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        decoration: _themedInput('Qty'),
                                        onChanged: (value) {
                                          setState(() {
                                            bool isNotNull = value.isNotEmpty;
                                            int enteredQty = int.tryParse(value) ?? 0;
                                            int? stockLimit = _itemStockByIndex[index];
                                            final selectedItem = _items.firstWhere(
                                                  (item) => item.itemName == _selectedItems[index],
                                              orElse: () => GetArbItemMasterListModel(),
                                            );
                                            String? category = selectedItem.categoryName;
                                            debugPrint("Category: $category | stockLimit: $stockLimit");
                                            if (isNotNull) {
                                              if (category != "Non ARB Item") {
                                                if (stockLimit != null && enteredQty > stockLimit) {
                                                  items[index]['amt']?.clear();
                                                  items[index]['qty']?.clear();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('The Item Quantity Cannot Exceed The Available Stock: $stockLimit')),
                                                  );
                                                  _updateSum(index);
                                                  updateTotalAmount();
                                                  return;
                                                }
                                              }
                                              _updateSum(index);
                                              updateTotalAmount();
                                            } else {
                                              _updateSum(index);
                                              updateTotalAmount();
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Discount', style: AppTypography.miniLabel),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: items[index]['discount'],
                                        focusNode: _discountFocusNodes[index],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(7),
                                        ],
                                        decoration: _themedInput('0'),
                                        onChanged: (value) {
                                          setState(() {
                                            _updateSum(index);
                                            updateTotalAmount();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Amount', style: AppTypography.miniLabel),
                                      const SizedBox(height: 4),
                                      TextField(
                                        controller: items[index]['amt'],
                                        enabled: false,
                                        style: AppTypography.labelMD.copyWith(color: AppColors.textMuted),
                                        decoration: _themedInput('0', readOnly: true),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Total Amount
                  if (items.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text('Total Amount', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                            ],
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: totalAmountController,
                            builder: (_, val, __) => Text(
                              val.text,
                              style: AppTypography.cardTitle.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              // â”€â”€ SECTION 4: Payment â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _sectionCard(
                title: 'PAYMENT',
                icon: Icons.payment_rounded,
                accentColor: AppColors.tealLight,
                children: [
                  _fieldLabel('Payment Mode', required: true),
                  DropdownButtonFormField<String>(
                    key: formKey2,
                    decoration: _themedInput('Select Payment Mode'),
                    value: getTransMode.contains(selectedTransMode) ? selectedTransMode : null,
                    items: getTransMode.map((String value) =>
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        )).toList(),
                    // onChanged: (value) {
                    //   setState(() {
                    //     selectedTransMode = value;
                    //     if (selectedTransMode != 'Cash' && selectedTransMode != 'Partial') {
                    //       isCashDenominationChecked = false;
                    //     }
                    //
                    //     if (value == 'Cash') {
                    //       clearQrFields();
                    //     } else if (value == 'Merchant QR') {
                    //       clearCashFields();
                    //     }
                    //   });
                    // },
                    onChanged: (value) {
                      setState(() {
                        final previousMode = selectedTransMode;
                        selectedTransMode = value;

                        if (selectedTransMode != 'Cash' && selectedTransMode != 'Partial') {
                          isCashDenominationChecked = false;
                        }

                        // Clear only the fields that belong to the mode you're LEAVING
                        if (previousMode == 'Cash') {
                          clearCashFields();
                        } else if (previousMode == 'Merchant QR') {
                          clearQrFields();
                        } else if (previousMode == 'Partial') {
                          // Leaving Partial: clear BOTH
                          clearCashFields();
                          clearQrFields();
                        }
                      });
                    },
                    isExpanded: true,
                  ),
                  if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') ...[
                    const SizedBox(height: 12),
                    _fieldLabel('Cash Receipt Amount', required: true),
                    TextField(
                      controller: cashTotalReceiptAmount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}'))],
                      decoration: _themedInput('Enter Cash Amount'),
                      onChanged: (value) {
                        setState(() {
                          var _isCash = value.isEmpty;
                          isEditingQR = false;
                          isEditingCash = true;
                          double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
                          double qrAmount = double.tryParse(value) ?? 0.0;
                          if (qrAmount > totalAmount) {
                            cashTotalReceiptAmount.clear();
                          } else {
                            if (selectedTransMode == 'Partial') { updateRemainingAmount(); }
                          }
                        });
                      },
                    ),
                  ],
                  if (selectedTransMode == 'Merchant QR' || selectedTransMode == 'Partial') ...[
                    const SizedBox(height: 12),
                    _fieldLabel('Merchant QR Amount', required: true),
                    TextField(
                      controller: merchantQrTotalReceiptAmount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}'))],
                      decoration: _themedInput('Enter QR Amount'),
                      onChanged: (value) {
                        setState(() {
                          var _isQRcode = value.isEmpty;
                          isEditingQR = true;
                          isEditingCash = false;
                          double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
                          double qrAmount = double.tryParse(value) ?? 0.0;
                          if (qrAmount > totalAmount) {
                            merchantQrTotalReceiptAmount.clear();
                          } else {
                            if (selectedTransMode == 'Partial') { updateRemainingAmount(); }
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Bank selection
                    _fieldLabel('Bank Account'),
                    DropdownButtonFormField<GetBankMappingDetailsListModel>(
                      value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,
                      decoration: _themedInput('Select Account No.'),
                      items: bankModel.map((item) {
                        return DropdownMenuItem<GetBankMappingDetailsListModel>(
                          value: item,
                          child: Text('${item.bankName ?? ''} - ${item.accountNo ?? ''}'),
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
                      isExpanded: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Transaction Code', required: true),
                              TextField(
                                controller: TranCodeController,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(30),
                                  FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')),
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ],
                                decoration: _themedInput('Enter Code',
                                  errorText: _isTranscode ? 'Transaction code is Required' : null,
                                ),
                                onChanged: (value) {
                                  setState(() { _isTranscode = value.isEmpty; });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Time'),
                              TextField(
                                controller: timeController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: _themedInput('HH:MM'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _fieldLabel('Transaction Remark'),
                    TextField(
                      controller: transReviewController,
                      inputFormatters: [LengthLimitingTextInputFormatter(250)],
                      decoration: _themedInput('Enter Remark'),
                    ),
                  ],
                  if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') ...[
                    const SizedBox(height: 4),
                    // Cash Denomination Checkbox
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.blueXL,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.blueXXL),
                      ),
                      child: CheckboxListTile(
                        title: Text('Cash Denomination', style: AppTypography.cardTitle.copyWith(color: AppColors.blue)),
                        value: isCashDenominationChecked,
                        activeColor: AppColors.blue,
                        onChanged: (bool? value) {
                          setState(() { isCashDenominationChecked = value ?? false; });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        dense: true,
                      ),
                    ),
                  ],
                ],
              ),

              // â”€â”€ SECTION 5: Cash Denomination (conditional) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if ((selectedTransMode == 'Cash' || selectedTransMode == 'Partial') && isCashDenominationChecked)
                _sectionCard(
                  title: cashDenominationMandatory ? 'CASH DENOMINATION (MANDATORY)' : 'CASH DENOMINATION',
                  icon: Icons.account_balance_wallet_rounded,
                  accentColor: AppColors.green,
                  children: [
                    // Tab Toggle
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.blueXXL,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () { setState(() { _selectedIndex = 0; }); },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _selectedIndex == 0 ? AppColors.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Cash Denomination',
                                  style: AppTypography.labelMD.copyWith(
                                    color: _selectedIndex == 0 ? Colors.white : AppColors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () { setState(() { _selectedIndex = 1; }); },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _selectedIndex == 1 ? AppColors.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Cash Return',
                                  style: AppTypography.labelMD.copyWith(
                                    color: _selectedIndex == 1 ? Colors.white : AppColors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Cash Denomination Tab
                    Visibility(
                      visible: _selectedIndex == 0,
                      child: _buildDenoTable(
                        controllers: qtyController,
                        amountsData: amounts,
                        summaryLabel: 'Collected',
                        summaryValue: totalAmount,
                        finalValue: finalAmountCashDeno,
                        enabledFn: (i) => true,
                        onChanged: (index, value, data) {
                          setState(() {
                            amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;
                            totalAmount = amounts.fold(0.0, (sum, a) => sum + a);
                            finalAmountCashDeno = totalAmount - returnAmount;
                            isQtyFilled[index] = value.isNotEmpty;
                            debugPrint("Collected$totalAmount");
                          });
                        },
                      ),
                    ),
                    // Cash Return Tab
                    Visibility(
                      visible: _selectedIndex == 1,
                      child: _buildDenoTable(
                        controllers: qtyControllerReturn,
                        amountsData: amountsReturn,
                        summaryLabel: 'Return',
                        summaryValue: returnAmount,
                        finalValue: finalAmountCashDeno,
                        enabledFn: (i) => !isQtyFilled.containsKey(i) || !isQtyFilled[i]!,
                        onChanged: (index, value, data) {
                          setState(() {
                            amountsReturn[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;
                            returnAmount = amountsReturn.fold(0.0, (sum, a) => sum + a);
                            finalAmountCashDeno = totalAmount - returnAmount;
                            debugPrint("return$returnAmount");
                          });
                        },
                      ),
                    ),
                  ],
                ),

              // â”€â”€ ACTION BUTTONS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () { cancelAction(); },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.border2, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Cancel', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.gradPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: AppColors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (saveFlag) {
                              print('saveFlag $saveFlag');
                              showFlushBar(context, Constants.dayEndCompleted);
                            } else {
                              if (modes == "EDIT") {
                                arbSalesAddEditForMob(arbSalesIdEdit!, "EDIT");
                              } else {
                                arbSalesAddEditForMob(0, "ADD");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            modes == "EDIT" ? 'Update' : 'Save',
                            style: AppTypography.cardTitle.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // â”€â”€ SECTION 6: ARB Sales Records â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (arbSalesModel.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_rounded, size: 40, color: AppColors.border2),
                      const SizedBox(height: 8),
                      Text('No Records Found', style: AppTypography.cardSubtitle),
                    ],
                  ),
                )
              else
                ...arbSalesModel.asMap().entries.map((entry) {
                  final index = entry.key;
                  final payList = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        // Card header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.blueXL,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.receipt_rounded, size: 16, color: AppColors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  payList.staffName ?? '',
                                  style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                                ),
                              ),
                              Text(
                                payList.saleDate != null
                                    ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.saleDate!))
                                    : '',
                                style: AppTypography.labelMD,
                              ),
                              const SizedBox(width: 6),
                              // Edit
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    loadDenominationData(payList.aRBSalesId!.toInt());
                                    var itemsToShow = payList.itemDataList?.toList();
                                    var saleDate = payList.saleDate.toString();
                                    var referredByName = payList.staffName.toString();
                                    var referredById = payList.staffId.toString();
                                    var consumerNo = payList.consumerNo.toString();
                                    var consumerName = payList.consumerName.toString();
                                    var paymentMode = payList.paymentMode.toString();
                                    var amountTotal = payList.totalAmount.toString();
                                    var transTime = payList.transactionTime.toString();
                                    var transationCode = payList.transactionCode.toString();
                                    var transRemark = payList.transactionRemark.toString();
                                    var bankId = payList.bankId.toString();
                                    var mappingId = payList.bankMappingId.toString();
                                    var arbSaleId = payList.aRBSalesId.toString();
                                    var cashReceiptAmt = payList.receiptAmt.toString();
                                    var qrReceiptAmt = payList.qRReceiptAmt.toString();
                                    var consumerConNumber = payList.consuContactNo.toString();
                                    var consumerAddress = payList.consuAddress.toString();
                                    var invoiceNumber = payList.invoiceNo.toString();
                                    var invoiceType = payList.invoiceType.toString();
                                    int payId = int.parse(arbSaleId);
                                    if (saveFlag) {
                                      print('saveFlag $saveFlag');
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        ArbSaleScreen.screenName,
                                        arguments: {
                                          'arbSalesV': arbSaleId,
                                          'salesDateV': saleDate,
                                          'itemsToShow': itemsToShow,
                                          'paymentModeV': paymentMode,
                                          'referredByNameV': referredByName,
                                          'referredByIdV': referredById,
                                          'consumerNoV': consumerNo,
                                          'consumerNameV': consumerName,
                                          'amountTotalV': amountTotal,
                                          'transTimeV': transTime,
                                          'transationCodeV': transationCode,
                                          'transRemarkV': transRemark,
                                          'bankIdV': bankId,
                                          'mappingIdV': mappingId,
                                          'modeChange': "EDIT",
                                          'cashReceiptAmtV': cashReceiptAmt,
                                          'qrReceiptAmtV': qrReceiptAmt,
                                          'consumerContactV': consumerConNumber,
                                          'consumerAddressV': consumerAddress,
                                          'invoiceNumberV': invoiceNumber,
                                          'invoiceTypeV': invoiceType,
                                        },
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  width: 30, height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueXXL,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Icon(Icons.edit_rounded, size: 15, color: AppColors.blue),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Delete
                              GestureDetector(
                                onTap: () async {
                                  if (saveFlag) {
                                    print('saveFlag $saveFlag');
                                    showFlushBar(context, Constants.dayEndCompleted);
                                  } else {
                                    int? pId = payList.aRBSalesId?.toInt();
                                    print('Delete button pressed ${payList.aRBSalesId}');
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
                                        arbSalesAddEditForMob(pId, "DELETE");
                                        print('Delete button pressed $pId');
                                      } else {
                                        print("Receipt ID is null.");
                                      }
                                    } else {
                                      print('Delete action was canceled');
                                    }
                                  }
                                },
                                child: Container(
                                  width: 30, height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.redXL,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Icon(Icons.delete_outline_rounded, size: 15, color: AppColors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card body
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              _recordRow(
                                'Consumer No / Invoice No',
                                (payList.consumerNo != null && payList.consumerNo!.isNotEmpty ? payList.consumerNo! : '') +
                                    ((payList.consumerNo != null && payList.consumerNo!.isNotEmpty) && (payList.invoiceNo != null && payList.invoiceNo!.isNotEmpty) ? '/' : '') +
                                    (payList.invoiceNo != null && payList.invoiceNo!.isNotEmpty ? payList.invoiceNo! : ''),
                              ),
                              _recordRow('Consumer Name', payList.consumerName ?? ''),
                              _recordRow('Payment Mode', (payList.paymentMode == 'Bank') ? 'Merchant QR' : (payList.paymentMode ?? '')),
                              _recordRow('Total Amount', formatCurrency(payList.totalAmount!.toDouble())),
                              _recordRow('Cash Rec. Amount', formatCurrency(payList.receiptAmt!.toDouble())),
                              _recordRow('QR Rec. Amount', formatCurrency(payList.qRReceiptAmt!.toDouble())),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: AppTypography.cardSubtitle.copyWith(color: AppColors.textMuted)),
          ),
          Text(':', style: AppTypography.cardSubtitle.copyWith(color: AppColors.textMuted)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppTypography.labelMD.copyWith(color: AppColors.text))),
        ],
      ),
    );
  }

  Widget _buildDenoTable({
    required List<TextEditingController> controllers,
    required List<double> amountsData,
    required String summaryLabel,
    required double summaryValue,
    required double finalValue,
    required bool Function(int) enabledFn,
    required void Function(int, String, DenomModel) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Center(child: Text('Note Type', style: AppTypography.labelMD))),
                Expanded(flex: 3, child: Center(child: Text('Qty', style: AppTypography.labelMD))),
                Expanded(flex: 3, child: Center(child: Text('Amount', style: AppTypography.labelMD))),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: getNoteTypeAndIdFroDenominationListModel.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final data = getNoteTypeAndIdFroDenominationListModel[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Center(child: Text('${data.noteType}', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)))),
                    // Expanded(flex: 1, child: Center(child: Text('Ã—', style: AppTypography.cardTitle.copyWith(color: AppColors.textMuted)))),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: controllers[index],
                          enabled: enabledFn(index),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          textAlign: TextAlign.center,
                          style: AppTypography.labelMD,
                          decoration: _themedInput('0'),
                          onChanged: (value) { onChanged(index, value, data); },
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Center(child: Text('=', style: AppTypography.cardTitle.copyWith(color: AppColors.textMuted)))),
                    Expanded(flex: 3, child: Center(child: Text(amountsData[index].toStringAsFixed(2), style: AppTypography.labelMD.copyWith(color: AppColors.text)))),
                  ],
                ),
              );
            },
          ),
          // Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [
                      Text('$summaryLabel: ', style: AppTypography.labelMD),
                      Text(summaryValue.toStringAsFixed(2), style: AppTypography.cardTitle.copyWith(color: AppColors.blue)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text('Final Total: ', style: AppTypography.labelMD),
                      Text(finalValue.toStringAsFixed(2), style: AppTypography.cardTitle.copyWith(color: AppColors.green)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initializeItems(List<ItemDataList> itemsToShow) {
    setState(() {
      items.clear(); // Clear any existing data
      _selectedItems.clear(); // Clear previous selections if any
      _discountFocusNodes.add(FocusNode());
      _dropdownFocusNodes.add(FocusNode());
      for (var i = 0; i < itemsToShow.length; i++) {
        var item = itemsToShow[i];

        // Add the item with controllers for each field
        items.add({
          'selectItem': TextEditingController(text: item.itemName ?? ''),
          'rate': TextEditingController(text: item.rate?.toString() ?? '0'),
          'qty': TextEditingController(text: item.itemQty?.toString() ?? '0'),
          'discount': TextEditingController(text: item.discountAmt?.toString() ?? '0'),
          'amt': TextEditingController(text: item.aRBAmount?.toString() ?? '0'),

        });

        // Directly assign the selected item name for this index in _selectedItems map
        _selectedItems[items.length - 1] = item.itemName ?? ''; // Ensure this is added correctly for each index
        _discountFocusNodes.add(FocusNode());
        _dropdownFocusNodes.add(FocusNode());

      }

      // Debugging step to check the number of items
      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }

  void _updateSum(int index) {
    // Get the values from the receivedQty, discount, and rate controllers
    double qtyNew = double.tryParse(items[index]['qty']?.text ?? '') ?? 0;
    double discountNew =
        double.tryParse(items[index]['discount']?.text ?? '') ?? 0;
    double rateNew = double.tryParse(items[index]['rate']?.text ?? '') ?? 0;
    double totalSum = 0.0;
    double newAmt = 0.0;
    // Check if stock is available
    int? currentStock = _itemStockByIndex[index]; // Assuming you have a way to fetch current stock for this item
    if (currentStock == null || currentStock == 0) {
      // If no stock, clear amt and set it to 0
      items[index]['amt']?.text = '0.00';
      debugPrint("Item is out of stock. Setting amt to 0.");
      return; // Exit the function to avoid further calculations
    }
    if (qtyNew > currentStock) {
      // If entered quantity exceeds available stock, reset amt to 0 and show a message
      items[index]['amt']?.text = '0.00';

      debugPrint("Entered quantity exceeds stock. Setting amt to 0.");
      return; // Exit the function to avoid further calculations
    }

    if (qtyNew == null || qtyNew == 0) {
      items[index]['amt']?.text = '0.00';
      debugPrint("Quantity is null or 0. Setting amt to 0.");
      return; // Exit the function to avoid further calculations
    }
    // If qtyNew is not null or empty, calculate the sum
    if (qtyNew != 0) {
      newAmt = qtyNew * rateNew;
      if (discountNew != 0) {
        // If discount is provided, apply the discount
        totalSum = qtyNew * rateNew - discountNew;
        items[index]['amt']?.text = totalSum
            .toStringAsFixed(2); // Update the amount with 2 decimal points
        debugPrint("totalSum with discount: $totalSum");
      } else {
        // If no discount is provided, just multiply qty and rate
        totalSum = qtyNew * rateNew;
        items[index]['amt']?.text = totalSum.toStringAsFixed(2);
        debugPrint("totalSum without discount: $totalSum");
      }
    } else {
      // If qty is 0 or empty, set the amount to 0 regardless of discount
      newAmt =  rateNew;
      totalSum = rateNew - discountNew;
      items[index]['amt']?.text = totalSum.toStringAsFixed(2);
      debugPrint("totalSum (qty is empty): $totalSum");
    }
    if(newAmt >= discountNew){

    }else{
      items[index]['discount']?.clear();
      _updateSum(index);
      updateTotalAmount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Constants.discountError)),
      );
    }
  }

  void updateTotalAmount() {
    double total = 0.0;

    for (var item in items) {
      // Get the quantity (assuming 'qty' is the key for quantity)
      final qty = item['qty'] ?? 0;

      // If the quantity is 0, set the total amount to 0.00 immediately
      if (qty == 0) {
        totalAmountController.text = '0.00';
        debugPrint("Quantity is 0, total set to 0.00");
        return; // No need to continue further if qty is 0
      }

      // Get the net amount for the item
      final netAmtText = item['amt']?.text.trim() ?? '';
      final netAmt = double.tryParse(netAmtText) ?? 0.0;

      // Add the net amount to the total
      total += netAmt;
    }

    // Format the total amount to two decimal places
    final formattedTotal = total.toStringAsFixed(2);

    // Update the total amount field
    totalAmountController.text = formattedTotal;

    debugPrint("formattedTotal $formattedTotal");
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

        //  Sort alphabetically by a string field like "staffName"
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

  Future<void> getArbItemMasterListModel() async {
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
      Uri.parse('${AppUrl.GetARBItemMasterList}/$distributorId/1/ARB'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemMasterList : " +
        '${AppUrl.GetARBItemMasterList}/$distributorId/1/ARB');
    debugPrint("GetARBItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data
            .map((json) => GetArbItemMasterListModel.fromJson(json))
            .toList();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  num? getArbItemCurrentStock(int? itemId) {
    if (itemId == null) return null;

    try {
      final stockItem = svcStock.firstWhere(
            (element) => element.itemId?.toInt() == itemId,
        orElse: () => GetArbCurrentStockListModel(currentStk: 0),
      );

      print("Selected itemId: $itemId | Stock Found: ${stockItem.currentStk}");
      return stockItem.currentStk ?? 0;
    } catch (e) {
      print("Error: $e");
      return 0;
    }
  }

  Future<void> getArbCurrentStockList() async {
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
      Uri.parse('${AppUrl.GetArbCurrentStockList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetArbCurrentStockList : " +
        '${AppUrl.GetArbCurrentStockList}/$distributorId/1');
    debugPrint("GetArbCurrentStockList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        svcStock = data.map((json) {
          return GetArbCurrentStockListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getArbCashDenominationDtl(int arbsalesId) async {
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
      Uri.parse('${AppUrl.GetARBSalesCashDenoDtlsById}/$arbsalesId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBSalesCashDenoDtlsById : " +
        '${AppUrl.GetARBSalesCashDenoDtlsById}/$arbsalesId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetArbSalesCashDenoDtlsByIdModel : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetArbSalesCashDenoDtlsByIdModel.fromJson(json);
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

  Future<void> arbSalesAddEditForMob(int arbSalesId ,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);

    String? tranCode;
    String? tranTime;
    String? tranReview;
    String? remark;
    int? paidTo;
    int? bankId;
    int? accMappingIds;
    String? consumerNo;
    String? consumerName;
    String? conConNo;
    String? ConAddress;
    String? InvNumber;
    String? bankName;
    double amtController = 0.0;
    double cashController = 0.0;
    double merchantQrController = 0.0;

    List<Map<String, dynamic>> ItemDetails = items.map((item) {
      String? selectedItemName = _selectedItems[items.indexOf(item)];

      GetArbItemMasterListModel? selectedItem = _items.firstWhere(
            (model) => model.itemName == selectedItemName,
        orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
      );

      return {
        'ItemId': selectedItem.itemId ?? 0,
        'Rate': item['rate']?.text ?? '',
        'ItemQty': item['qty']?.text ?? '',
        'DiscountAmt': item['discount']?.text ?? '',
        'ARBAmount': item['amt']?.text ?? '',
      };
    }).where((item) =>
    item['ItemId'] != 0 && item['ARBAmount'] != '0.00' && item['ARBAmount'] != '0') // Filter for non-zero amounts
        .toList();
    //.where((item) => item['ItemId'] != 0).toList();

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


    if(action != "DELETE") {

      bool hasValidItems = ItemDetails.any((item) =>
      item['ItemId'] != 0 &&
          item['ItemName'].toString().isNotEmpty
      );
      if (!hasValidItems) {
        showFlushBar(context, "Please Select The Item");
        return;
      }

      bool hasValidRate = ItemDetails.any((item) =>
      item['ItemId'] != 0 &&
          item['Rate'].toString().isNotEmpty &&
          num.tryParse(item['Rate'].toString()) != null &&
          num.parse(item['Rate'].toString()) > 0
      );
      if (!hasValidRate) {
        showFlushBar(context, "Please Select The Rate");
        return;
      }

      bool hasValidQty = ItemDetails.any((item) =>
      item['ItemId'] != 0 &&
          item['ItemQty'].toString().isNotEmpty &&
          num.tryParse(item['ItemQty'].toString()) != null &&
          num.parse(item['ItemQty'].toString()) > 0
      );
      if (!hasValidQty) {
        showFlushBar(context, "Please Select a Valid Qty");
        return;
      }

      if (totalAmountController.text.isNotEmpty) {
        amtController = double.parse(totalAmountController.text);
      }

      if(selectedTransMode == "Merchant QR" || selectedTransMode == 'Partial'){
        if (merchantQrTotalReceiptAmount.text.isNotEmpty) {
          merchantQrController = double.parse(merchantQrTotalReceiptAmount.text);
        }
      }else{
        merchantQrController = 0.0;
      }

      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
        if (cashTotalReceiptAmount.text.isNotEmpty) {
          cashController = double.parse(cashTotalReceiptAmount.text);
        }
      }else{
        cashController = 0.0;
      }

      if (conNoController.text.isNotEmpty) {
        consumerNo = conNoController.text;
      }
      if (conNameController.text.isNotEmpty) {
        consumerName = conNameController.text;
      }
      if (conContNoController.text.isNotEmpty) {
        conConNo = conContNoController.text;
      }
      if (conAddNoController.text.isNotEmpty) {
        ConAddress = conAddNoController.text;
      }

      if (invNoController.text.isNotEmpty) {
        InvNumber = invNoController.text;
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

      if(_selectBankModel != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
        bankName = selectedBankName;
      }
      else{
        bankId = 0;
        accMappingIds = 0;
        bankName = '';
      }
      if (_selectedItems.isEmpty) {
        showFlushBar(context, Constants.reqfield);
        return;
      }

      if (!invNoController.text.isNotEmpty) {
        showFlushBar(context, "Please Enter Invoice No Or DC No");
        return;
      }
      if (!conNameController.text.isNotEmpty) {
        showFlushBar(context, "Please Enter Consumer Name");
        return;
      }

      if (selectedTransMode == null || selectedTransMode!.isEmpty)
      {
        showFlushBar(context, "Please Select Payment Mode");
        return;
      }

      if(selectedTransMode == "Merchant QR" || selectedTransMode == 'Partial'){
        if(selectedBankName == null || selectedBankId == null){
          showFlushBar(context, "Select Bank.");
          return;
        }
        if(TranCodeController.text.isEmpty){
          showFlushBar(context, "Enter Transaction Code.");
          return;
        }
      }

      if(selectedTransMode == "Merchant QR" || selectedTransMode == 'Partial'){
        if(merchantQrTotalReceiptAmount.text.isEmpty){
          showFlushBar(context, Constants.arbSaleQrAmount);
          return;
        }
      }
      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
        if(cashTotalReceiptAmount.text.isEmpty){
          showFlushBar(context, Constants.arbSaleCashAmount);
          return;
        }
      }

      if (selectedTransMode == 'Cash'){
        if(amtController != cashController){
          showFlushBar(context, Constants.arbSaleCashAmount);
          return;
        }
      }
      if(selectedTransMode == "Merchant QR"){
        if(amtController != merchantQrController){
          showFlushBar(context, Constants.arbSaleQrAmount);
          return;
        }
      }
      if (selectedTransMode == 'Partial'){
        if(cashController > 0){
          if(merchantQrController > 0){
            double amtTotal = cashController + merchantQrController;
            if(amtController != amtTotal){
              showFlushBar(context, Constants.arbSaleQrCashAmount);
              return;
            }
          }else{
            showFlushBar(context, Constants.arbSaleQrAmount);
            return;
          }
        }else{
          showFlushBar(context, Constants.arbSaleCashAmount);
          return;
        }

      }
      // Conditional check for cash payment mode
      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
        if(finalAmountCashDeno > 0) {
          if (finalAmountCashDeno != cashController) {
            showFlushBar(context, Constants.denominationAmount);
            return;
          }
        }
      }

      if(cashDenominationMandatory){
        if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
          if(finalAmountCashDeno > 0) {
            if (finalAmountCashDeno != cashController) {
              showFlushBar(context, Constants.denominationAmount);
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }
    }
    if (selectedTransMode != null && selectedTransMode == "Merchant QR") {
      selectedTransMode = 'Bank';
    }


    final Map<String, dynamic> requestBody =
    {
      "ARBSalesId": arbSalesId,
      "DistributorId":distributorId,
      "SaleDate": formattedDate,
      "StaffId": selectedReferredID ?? 0,
      "StaffName": selectedReferredName,
      "ConsumerNo": consumerNo ?? '',
      "ConsumerName": consumerName ?? '',
      "TotalAmount": amtController ?? 0,
      "PaymentMode": action != "DELETE" ? (selectedTransMode ?? '') : "Bank",
      "BankName": bankName ?? '',
      "TransactionCode": tranCode ?? '',
      "TransactionTime": tranTime ?? '',
      "TransactionRemark": tranReview ?? '',
      "Action": action,
      "AddedBy": userId ?? '',
      "ItemId": 0,
      "ItemName": '',
      "Rate": 0,
      "ItemQty": 0,
      "DiscountAmt": 0,
      "ARBAmount": 0,
      "BankId": bankId ?? 0,
      "UpdatedFrom":'MOB',
      "BankMappingId": accMappingIds ?? 0,
      "ItemDataList": ItemDetails,
      "DenomDtList": dataCashDenomination,
      "QRReceiptAmt": merchantQrController,
      "ConsuContactNo": conConNo ?? 0,
      "ConsuAddress": ConAddress ?? '',
      "InvoiceType": invoiceAutoManualMandatory ? "Auto" : "Manual",
      "InvoiceNo": InvNumber ?? 0,
      "ReceiptAmt": cashController,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.ARBSalesAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody arbSalesAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    print("Response arbSalesAddEditForMob11: ${response.body}");

    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        print("Response arbSalesAddEditForMob: ${response.body}");

        Navigator.pushNamed(
          context,
          ArbSaleScreen.screenName,
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
          getARBSalesItemPurList();
        });
      }
    } else {
      print("Error ARBSalesAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }


  Future<void> getARBSalesItemPurList() async {
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
      Uri.parse('${AppUrl.GetARBSalesList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBSalesList : " +
        '${AppUrl.GetARBSalesList}/$distributorId');
    debugPrint("GetARBSalesList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        arbSalesModel = data.map((json) {
          return GetArbSalesListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  void cancelAction() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(
          context,
          ArbSaleScreen.screenName // This opens the third tab
      );
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

  Future<void> loadDenominationData(int psvID) async {
    await getArbCashDenominationDtl(psvID.toInt());

    // Now call initializeControllers after list is fetched
    initializeControllers();

    // Refresh UI
    setState(() {});
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        // Parse the API response
        List<dynamic> apiResponse = json.decode(response.body);

        // Check if the response list is empty
        if (apiResponse.isEmpty) {
          // If the list is empty, do not save
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            // If the conditions are met, set the flag and save the data
            print("Data is valid, proceeding to save.");
          } else {
            // If any condition is not met, print a message
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      // Exception handling
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

  // Future<void> InvoiceAutoManualFlagMandatory() async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //
  //   if (!Constants.isNetworkAvailable) {
  //     showFlushBar(context, Constants.connectionMessage);
  //     isLoading = false;
  //     return;
  //   }
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken = prefs.getString('token');
  //
  //     if (bearerToken == null || distributorId == null) {
  //       throw Exception('Token or DistributorId missing');
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //     );
  //
  //     debugPrint("Response body: ${response.body}");
  //
  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to load permission data');
  //     }
  //
  //     final List<dynamic> data = json.decode(response.body);
  //
  //     // Convert API response
  //     autoMnualList = data
  //         .map((e) => CahsDenominationMandatoryFlagModel.fromJson(e))
  //         .toList();
  //
  //     // ðŸ”¹ Find Invoice Auto configuration
  //     final autoInvoiceItem = autoMnualList.firstWhere(
  //           (item) =>
  //       item.distributorId.toString() == distributorId &&
  //           item.permissionFor == "Invoice Number",
  //       orElse: () => CahsDenominationMandatoryFlagModel(),
  //     );
  //
  //     setState(() {
  //       isLoading = false;
  //
  //       if (autoInvoiceItem.invoiceType == "Auto") {
  //         invoiceAutoManualMandatory = true;
  //
  //         // ðŸ‘‡ Set auto invoice number
  //         invNoController.text =
  //             autoInvoiceItem.fromInvoiceNo?.toString() ?? '';
  //
  //         _isInvoiceEmpty = false;
  //       } else {
  //         // Manual Entry
  //         invoiceAutoManualMandatory = false;
  //         invNoController.clear();
  //       }
  //     });
  //   } catch (error) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     debugPrint("Error: $error");
  //   }
  // }

  double remainingAmount = 0.0;

  void updateRemainingAmount() {
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
    double qrAmount = double.tryParse(merchantQrTotalReceiptAmount.text) ?? 0.0;
    double cashAmount = double.tryParse(cashTotalReceiptAmount.text) ?? 0.0;

    setState(() {
      if (isEditingQR) {
        remainingAmount = totalAmount - qrAmount;
        if (remainingAmount < 0) remainingAmount = 0.0;
        cashTotalReceiptAmount.text = remainingAmount.toStringAsFixed(2);
      } else if (isEditingCash) {
        remainingAmount = totalAmount - cashAmount;
        if (remainingAmount < 0) remainingAmount = 0.0;
        merchantQrTotalReceiptAmount.text = remainingAmount.toStringAsFixed(2);
      }
    });
  }

  Future<void> InvoiceAutoManualFlagMandatory() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    try {
      setState(() => isLoading = true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null || distributorId == null) {
        throw Exception('Token or DistributorId missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load permission data');
      }

      final List<dynamic> data = json.decode(response.body);

      autoMnualList = data
          .map((e) => CahsDenominationMandatoryFlagModel.fromJson(e))
          .toList();

      // âœ… STRICTLY FIND AUTO
      final autoInvoiceItem = autoMnualList.firstWhere(
            (item) =>
        item.distributorId.toString() == distributorId &&
            item.permissionFor == "Invoice Number" &&
            item.invoiceType == "Auto",
        orElse: () => CahsDenominationMandatoryFlagModel(),
      );

      debugPrint("InvoiceType: ${autoInvoiceItem.invoiceType}");
      debugPrint("FromInvoiceNo: ${autoInvoiceItem.fromInvoiceNo}");

      setState(() {
        isLoading = false;

        // if (autoInvoiceItem.invoiceType == "Auto" &&
        //     autoInvoiceItem.fromInvoiceNo != null) {
        //   invoiceAutoManualMandatory = true;
        //   invNoController.text =
        //       autoInvoiceItem.fromInvoiceNo.toString();
        //   _isInvoiceEmpty = false;
        // } else {
        //   invoiceAutoManualMandatory = false;
        //   invNoController.clear();
        // }

        if (autoInvoiceItem.invoiceType == "Auto") {
          invoiceAutoManualMandatory = true;
        } else {
          invoiceAutoManualMandatory = false;
          invNoController.clear();
        }
      });
      if (autoInvoiceItem.invoiceType == "Auto") {
        getInvoiceGenerateNewNoForARBSale("Auto");
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error111: $e");
    }
  }

  // Future<void> getInvoiceGenerateNewNoForARBSale(String invType) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken = prefs.getString('token');
  //
  //     if (bearerToken == null || distributorId == null) {
  //       throw Exception("Token or DistributorId missing");
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse(
  //         '${AppUrl.InvoiceGenerateNewNoForARBSale}/$distributorId/$invType',
  //       ),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to generate invoice number');
  //     }
  //
  //     // âœ… API RETURNS PLAIN VALUE (e.g. 90008)
  //     final invoiceNo = response.body.replaceAll('"', '');
  //
  //     debugPrint("Generated Invoice: $invoiceNo");
  //
  //     setState(() {
  //       invNoController.text = invoiceNo;
  //       _isInvoiceEmpty = false;
  //       invoiceAutoManualMandatory = true;
  //     });
  //   } catch (e) {
  //     debugPrint("Invoice Generate Error: $e");
  //     showFlushBar(context, "Unable to generate invoice number");
  //   }
  // }
  Future<void> getInvoiceGenerateNewNoForARBSale(String invType) async {
    try {
      // Get distributor ID and token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      debugPrint('DistributorId: $distributorId');
      debugPrint('BearerToken present: ${bearerToken != null}');

      if (bearerToken == null || distributorId == null) {
        throw Exception("Token or DistributorId missing");
      }

      // Build the URL
      final url = '${AppUrl.InvoiceGenerateNewNoForARBSale}/$distributorId/$invType';
      debugPrint('Invoice Generate URL: $url');

      // Call the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Invoice API Status: ${response.statusCode}');
      debugPrint('Invoice API Response Body: ${response.body}');

      // Check if API call succeeded
      if (response.statusCode != 200) {
        showFlushBar(context, 'Failed to generate invoice. Status: ${response.statusCode}');
        return;
      }

      // âœ… API RETURNS PLAIN VALUE (e.g. 90008) OR QUOTED STRING
      final invoiceNo = response.body.replaceAll('"', '').trim();
      debugPrint('Generated Invoice: $invoiceNo');

      // Update UI
      setState(() {
        invNoController.text = invoiceNo;
        _isInvoiceEmpty = false;
        invoiceAutoManualMandatory = true;
      });

    } catch (e) {
      debugPrint("Invoice Generate Error: $e");
      showFlushBar(context, "Unable to generate invoice number");
    }
  }

  void clearQrFields() {
    merchantQrTotalReceiptAmount.clear();
    _selectBankModel = null;
    selectedBankName = null;
    selectedBankId = null;
    selecteBankIDApi = null;
    accMappingId = null;
    TranCodeController.clear();
    timeController.clear();
    transReviewController.clear();
  }

  void clearCashFields() {
    cashTotalReceiptAmount.clear();
    isCashDenominationChecked = false;
  }


}



