import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../newTheam/core/theme/app_colors.dart';
import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'BootomNavigatinBarManager.dart';
import 'CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import 'CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import 'ManagerModelClass/DenomModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
import 'ManagerSingleItemUI/SVSaleReportScreenUI.dart';
import 'SVSaleModel/GetARBItemMasterListModel.dart';
import 'SVSaleModel/GetAddEditDataSvSaleItemModel.dart';
import 'SVSaleModel/GetArbCurrentStockListModel.dart';
import 'SVSaleModel/GetDenominationListForAddEdit.dart';
import 'SVSaleModel/GetDistStampDutyModel.dart';
import 'SVSaleModel/GetItemMasterListModel.dart';
import 'SVSaleModel/GetRSPDetailsListModel.dart';
import 'SVSaleModel/GetStaffDetailsListModel.dart';

class SVSaleReportScreen extends StatefulWidget {
  static const screenName = '/svSaleReportScreen';
  final bool disableNetworkCallsForTest;

  const SVSaleReportScreen(
      {super.key, this.disableNetworkCallsForTest = false});

  @override
  State<SVSaleReportScreen> createState() => _SVSaleReportScreen();
}

class _SVSaleReportScreen extends State<SVSaleReportScreen> {
  List<DenomModel> getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<TextEditingController> qtyControllerReturn = [];
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  GetStaffDetailsListModel? selectedStaff;
  int? selectedReferredID;
  String? selectedReferredName;
  List<GetItemMasterListModel> masterListModel = [];
  GetItemMasterListModel? selectedMaster;
  List<GetDistStampDutyModel> getDistStampDutyModel = [];
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetArbCurrentStockListModel> svcStock = [];
  GetArbCurrentStockListModel? _selectStockModel;
  List<GetArbItemMasterListModel> svstockmaster = [];
  GetArbItemMasterListModel? _svstockmaster;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  final conNameController = TextEditingController();
  final conContactController = TextEditingController();
  final conNoController = TextEditingController();
  final recPaymentController = TextEditingController();
  final stampDutyController = TextEditingController();
  final TranCodeController = TextEditingController();
  final partialQRController = TextEditingController();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final rateController = TextEditingController();
  final QtyController = TextEditingController();
  final discountController = TextEditingController();
  final amtController = TextEditingController();
  final scRegulatorController = TextEditingController(text: "1");
  final depositCylinderAmountController = TextEditingController();
  final refillCylinderAmountController = TextEditingController();
  final regulatorDepositAmountController = TextEditingController();
  final regulatorBasicAmountController = TextEditingController();
  final regulatorDiscountAmountController = TextEditingController();
  final cylinderQtyAddController = TextEditingController();
  final totalAmountController = TextEditingController();
  final nameChangeAmtChargesController = TextEditingController();
  String? previousRegulatorDepositAmount;
  int _selectedIndex = 0;
  double? arbTotalAmount;
  double? arbTotalDiscount;
  double? stampDuty;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey7 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey8 = GlobalKey<FormState>();
  bool isCashDenominationListViewVisible = false;
  bool isSVPending = false;
  bool isExemptedReticulated = false;
  String? selectedTransMode;
  String? selectedTransacc;
  String? selectedTranssvItemName;
  int? selectedProductID;
  String? selectedTranqty;
  int? cylinderQty;
  double? depositAmount;
  double? refillAmountCyl;
  double? getRegulatorDepositAmountFromApi;
  bool _isConsumerEmpty = false;
  bool _isConCOntactEmpty = false;
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  bool _isTranscode = false;
  bool _iscashcode = false;
  bool _isQRcode = false;
  List<double> amounts = [];
  List<double> amountsReturn = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<String> getTransMode = ["Cash", "Merchant QR", "Partial"];
  List<GetAddEditDataSvSaleItemModel> receiptList = [];
  List<GetDenominationListForAddEdit> getDenominationLis = [];
  List<String> getTransacc = ["NC", "RC", "DBC", "Name Change"];
  List<String> getTransqty = ["1", "2"];
  List<String> getSelectedFTLRegulatorQty = ["0", "1"];
  String? getSelectedFTLRegulatorQtyString;
  int? selectedFTLRegQty;
  List<Map<String, TextEditingController>> items = [];
  int? arbCurrentStock;
  Map<int, int?> _itemStockByIndex = {};
  Map<int, int?> _selectedItemIds = {};
  Map<int, String?> _selectedCategoryName = {};
  List<GetArbItemMasterListModel> _items = [];
  Map<int, String?> _selectedItems = {};
  List<GetRspDetailsListModel> getrsplistmodel = [];
  Map<int, String?> _getrsplistitems = {};

  var argValue;
  String? modes;
  int? psvIdEdit;
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  List<FocusNode> _discountFocusNodes = [];
  List<FocusNode> _dropdownFocusNodes = [];
  late FocusNode _conNoFocusNode;
  bool _isInitComplete = false; // This avoids API call during initState prefill
  bool isEditingQR = false;
  bool isEditingCash = false;
  List<CahsDenominationMandatoryFlagModel> autoMnualList = [];
  bool invoiceAutoManualMandatory = false;
  late final invNoController = TextEditingController();
  bool _isInvoiceEmpty = false;
  final conAddNoController = TextEditingController();
  bool _isEditingExistingConsumerNo = false;
  bool _isInvoiceEditable = false;
  bool isCashDenominationChecked = false;

  @override
  void initState() {
    super.initState();
    _conNoFocusNode = FocusNode();
    _conNoFocusNode.addListener(() {
      if (!_conNoFocusNode.hasFocus && _isInitComplete) {
        final value = conNoController.text.trim();

        if (value.isNotEmpty) {
          if (selectedMaster == null) {
            conNoController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Please select product before entering Consumer No./DC No.')),
            );
          } else if (selectedTransacc == null) {
            conNoController.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Please select SV type before entering Consumer No./DC No.')),
            );
          } else {
            // ✅ Only call API if this is a new input, not an existing saved value
            if (!_isEditingExistingConsumerNo) {
              CheckSVConsumerNoStatus();
            }
          }
        }
      }
    });

    if (widget.disableNetworkCallsForTest) {
      return;
    }

    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    InvoiceAutoManualFlagMandatory();
    _addNewItem();
    getNoteTypeAndIDList();
    getStaffDetailsList();
    getItemMasterList();
    getDistStampDuty();
    fetchBank();
    getArbCurrentStockList();
    getArbItemMasterListModel();
    getRspDetailsListModel();
    fetchItemSvAddEditList();

    Future.delayed(Duration.zero, () async {
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';
      if (argValue != null) {
        final itemsToShow = argValue["itemsToShow"] ?? [];
        psvIdEdit = int.tryParse(argValue["psvIDV"] ?? 0);
        String sVDateEdit = argValue["sVDateV"] ?? 0;
        String referredByIdEdit = argValue["referredByIdV"] ?? 0;
        String referredByNameEdit = argValue["referredByNameV"] ?? 0;
        String otherNameEdit = argValue["otherNameV"] ?? 0;
        String productIdEdit = argValue["productIdV"] ?? 0;
        String productNameEdit = argValue["productNameV"] ?? 0;
        String isUndocumentEdit = argValue["isUndocumentV"] ?? 0;
        String sVTypeEdit = argValue["sVTypeV"] ?? 0;
        String cylQtyEdit = argValue["cylQtyV"] ?? 0;
        String sCRegulatorEdit = argValue["sCRegulatorV"] ?? 0;
        String depositCylEdit = argValue["depositCylV"] ?? 0;
        String cylRefillRSPEdit = argValue["cylRefillRSPV"] ?? 0;
        String regulatorDepositEdit = argValue["regulatorDepositV"] ?? 0;
        String stampDutyEdit = argValue["stampDutyV"] ?? 0;
        String fTLRegulatorEdit = argValue["fTLRegulatorV"] ?? 0;
        String basicAmtEdit = argValue["basicAmtV"] ?? 0;
        String consuDCNoEdit = argValue["consuDCNoV"] ?? 0;
        String consumerNameEdit = argValue["consumerNameV"] ?? 0;
        String consuContactNoEdit = argValue["consuContactNoV"] ?? 0;
        String totalAmountEdit = argValue["totalAmountV"] ?? 0;
        String partialQREdit = argValue["partialQRV"] ?? 0;
        String receiptAmtEdit = argValue["receiptAmtV"] ?? 0;
        String paymentModeEdit = argValue["paymentModeV"] ?? 0;
        String transactionCodeEdit = argValue["transactionCodeV"] ?? 0;
        String transactionTimeEdit = argValue["transactionTimeV"] ?? 0;
        String transactionRemarkEdit = argValue["transactionRemarkV"] ?? 0;
        String addedByEdit = argValue["addedByV"] ?? 0;
        String actionEdit = argValue["actionV"] ?? 0;
        String itemIdEdit = argValue["itemIdV"] ?? 0;
        String itemNameEdit = argValue["itemNameV"] ?? 0;
        String rateEdit = argValue["rateV"] ?? 0;
        String itemQtyEdit = argValue["itemQtyV"] ?? 0;
        String discountAmtEdit = argValue["discountAmtV"] ?? 0;
        String aRBAmountEdit = argValue["aRBAmountV"] ?? 0;
        String amtChargesEdit = argValue["amtChargesV"] ?? 0;
        String categoryNameEdit = argValue["categoryNameV"] ?? 0;
        String bankIdEdit = argValue["bankIdV"] ?? 0;
        String bankMappingIdEdit = argValue["bankMappingIdV"] ?? 0;
        String accountNoEdit = argValue["accountNoV"] ?? 0;
        String bankNameEdit = argValue["bankNameV"] ?? 0;
        String isExemptRetiEdit = argValue["isExemptRetiV"] ?? 0;
        String sVDiscountAmtEdit = argValue["sVDiscountAmtV"] ?? 0;
        String InvoiceNoEdit = argValue["invoiceNumberV"]?.toString() ?? '';
        String InvoiceTypeEdit = argValue["invoiceTypeV"] ?? 0;
        String consumerAddressEdit = argValue["consumerAddressV"] ?? 0;

        // invoiceAutoManualMandatory = InvoiceTypeEdit == "Auto";

        selectedProductID = int.parse(productIdEdit);
        cylinderQty = int.parse(cylQtyEdit);

        depositCylinderAmountController.text = depositCylEdit;
        refillCylinderAmountController.text = cylRefillRSPEdit;
        depositAmount = double.tryParse(depositCylEdit);
        refillAmountCyl = double.tryParse(cylRefillRSPEdit);
        debugPrint("regulatorDepositEdit $regulatorDepositEdit");
        if (regulatorDepositEdit.isEmpty ||
            regulatorDepositEdit == null ||
            regulatorDepositEdit == "null") {
          regulatorDepositAmountController.text = "0";
        } else {
          regulatorDepositAmountController.text = regulatorDepositEdit;
        }

        stampDutyController.text = stampDutyEdit;
        regulatorDiscountAmountController.text = sVDiscountAmtEdit;
        regulatorBasicAmountController.text = basicAmtEdit;
        // conNoController.text = consuDCNoEdit;
        if (consuDCNoEdit.isNotEmpty && consuDCNoEdit != "null") {
          conNoController.text = consuDCNoEdit;
          _isEditingExistingConsumerNo = true; // mark existing record
        }
        conNameController.text = consumerNameEdit;
        conContactController.text = consuContactNoEdit;
        recPaymentController.text = receiptAmtEdit;
        TranCodeController.text = transactionCodeEdit;
        timeController.text = transactionTimeEdit;
        transReviewController.text = transactionRemarkEdit;
        totalAmountController.text = totalAmountEdit;
        partialQRController.text = partialQREdit;

        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode =
              'Merchant QR'; // fallback or handle invalid values
        } else {
          selectedTransMode = null;
        }
        await getStaffDetailsList();
        getStaffDetailsList().whenComplete(() {
          debugPrint("referredByNameEdit:$referredByNameEdit");
          if (referredByNameEdit != "null" &&
              referredByNameEdit.isNotEmpty &&
              referredByNameEdit != null) {
            setState(() {
              selectedStaff = staffdetailsmodel.firstWhere(
                (item) => item.staffName == referredByNameEdit,
                orElse: () => GetStaffDetailsListModel(staffName: ''),
              );
              selectedReferredID = int.parse(referredByIdEdit);
              selectedReferredName = referredByNameEdit;
              // invNoController.text = InvoiceNoEdit;

              final bool isExistingInvoice = InvoiceNoEdit.isNotEmpty &&
                  InvoiceNoEdit != "0" &&
                  InvoiceNoEdit != "null";

              if (isExistingInvoice) {
                invNoController.text = InvoiceNoEdit;
                invoiceAutoManualMandatory = InvoiceTypeEdit == "Auto";
              } else if (InvoiceTypeEdit == "Manual") {
                // Manual record but no invoice saved
                invNoController.clear();
                invoiceAutoManualMandatory = false; // keep editable
              } else {
                // New record, follow API auto/manual
                invNoController.clear();
                invoiceAutoManualMandatory = false;
                InvoiceAutoManualFlagMandatory();
              }

              conAddNoController.text = consumerAddressEdit;
            });
          }
        });

        await fetchBank(); // wait for data first
        if (accountNoEdit.isNotEmpty && accountNoEdit != "null") {
          final match = bankModel.firstWhere(
            (item) => item.accountNo?.trim() == accountNoEdit.trim(),
            orElse: () =>
                GetBankMappingDetailsListModel(), // fallback empty object
          );

          // Only set if a valid match found
          if ((match.accountNo ?? '').isNotEmpty) {
            setState(() {
              _selectBankModel = match;
              selectedBankName = match.bankName;
              selectedBankId = match.accountNo;
              selecteBankIDApi = match.bankId?.toInt();
              accMappingId = match.mappingId?.toInt();
            });
          }
        }
        // await getItemMasterList();
        getItemMasterList().whenComplete(() {
          debugPrint("productNameEdit:$productNameEdit");
          if (productNameEdit != "null" &&
              productNameEdit.isNotEmpty &&
              productNameEdit != null) {
            setState(() {
              selectedMaster = masterListModel.firstWhere(
                (item) => item.itemName == productNameEdit,
                orElse: () => GetItemMasterListModel(itemId: 0, itemName: ''),
              );
              selectedTranssvItemName = productNameEdit;
            });
          }
        });
        if (isUndocumentEdit == "true") {
          isSVPending = true;
        } else {
          isSVPending = false;
        }
        debugPrint("isExemptRetiEdit$isExemptRetiEdit");
        if (isExemptRetiEdit == "1") {
          isExemptedReticulated = true;
          debugPrint("isExemptRetiEdittrue");
        } else {
          isExemptedReticulated = false;
          debugPrint("isExemptRetiEditfalse");
        }

        if (getTransacc.contains(sVTypeEdit)) {
          selectedTransacc = sVTypeEdit;
        } else if (sVTypeEdit == "NameChange") {
          selectedTransacc = "Name Change";
          nameChangeAmtChargesController.text = amtChargesEdit;
        } else {
          selectedTransacc = null; // fallback or handle invalid values
        }
        debugPrint("selectedTranqty $cylQtyEdit");
        if (productNameEdit != "14.2 KG" || isExemptRetiEdit == "1") {
          cylinderQtyAddController.text = cylQtyEdit;
          debugPrint("cylinderQtyAddController.text $cylQtyEdit");
        } else {
          if (getTransqty.contains(cylQtyEdit)) {
            selectedTranqty = cylQtyEdit;
            debugPrint("selectedTranqty $cylQtyEdit");
          } else {
            selectedTranqty = null;
            debugPrint(
                "selectedTranqty1 $cylQtyEdit"); // fallback or handle invalid values
          }
        }
        debugPrint("fTLRegulatorEdit $fTLRegulatorEdit");
        if (getSelectedFTLRegulatorQty.contains(fTLRegulatorEdit)) {
          getSelectedFTLRegulatorQtyString = fTLRegulatorEdit;
        } else {
          getSelectedFTLRegulatorQtyString =
              null; // fallback or handle invalid values
        }

        loadDenominationData(psvIdEdit!);
        // _initializeItems(itemsToShow);
        if (itemsToShow.isNotEmpty) {
          _initializeItems(itemsToShow);
        } else {
          // If no initial data, start with an empty list or default values
          _initializeItems([]);
        }
        if (getDenominationLis.isNotEmpty) {
          initializeControllers();
        } else {
          debugPrint("empty");
        }
      }
      _isInitComplete = true;
    });
  }

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // â”€â”€ UI helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  InputDecoration _fDeco(String? label, {String? error}) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.bg,
        errorText: error,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.red)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
      );

  Widget _svSectionHeader(String title, Color dotColor) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Row(children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: dotColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8)),
        ]),
      );

  Widget _svCard(List<Widget> children) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _svLabelRow({required String label, required Widget child}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMid))),
          Expanded(child: child),
        ]),
      );

  Widget _receiptInfoRow(String l1, String v1, String l2, String v2) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(
              child: Row(children: [
            Text('$l1: ',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            Flexible(
                child: Text(v1,
                    style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600))),
          ])),
          Expanded(
              child: Row(children: [
            Text('$l2: ',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            Flexible(
                child: Text(v2,
                    style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600))),
          ])),
        ]),
      );

  @override
  void dispose() {
    for (var node in _discountFocusNodes) {
      node.dispose();
    }
    for (var node in _dropdownFocusNodes) {
      node.dispose();
    }
    _conNoFocusNode.dispose();
    super.dispose();
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
          SnackBar(
              content:
                  Text('Please fill all fields before adding a new item.')),
        );
        return;
      }
    }

    // Add a new item if previous one is valid or if it's the first item
    setState(() {
      int newIndex = items.length;
      items.add({
        'selectItem': TextEditingController(),
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
      calculateGrandTotalAmount();
      // Debugging: Print after removing
      print('Selected Items After: $_selectedItems');
    });
  }

  bool get _isAddNewItemEnabled {
    // Check if there are any available items that haven't been selected yet
    return _items.any((item) => !_selectedItems.values.contains(item.itemName));
  }

  void _initializeItems(List<ItemDetails> itemsToShow) {
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
          'rate': TextEditingController(text: item.rate?.toString() ?? ''),
          'qty': TextEditingController(text: item.itemQty?.toString() ?? ''),
          'discount':
              TextEditingController(text: item.discountAmt?.toString() ?? ''),
          'amt': TextEditingController(text: item.aRBAmount?.toString() ?? ''),
        });

        // Directly assign the selected item name for this index in _selectedItems map
        _selectedItems[items.length - 1] = item.itemName ??
            ''; // Ensure this is added correctly for each index
        _discountFocusNodes.add(FocusNode());
        _dropdownFocusNodes.add(FocusNode());
      }

      // Debugging step to check the number of items
      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final double halfWidth = (MediaQuery.of(context).size.width - 56) / 2;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        appBar: CustomAppBarManagerr(title: 'SV Sale'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _svSectionHeader('Basic Info', AppColors.blueLight),
                _svCard([
                  Row(children: [
                    Expanded(
                        child: Text('SV Date',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMid))),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border)),
                      child: Text(formattedDate,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue)),
                    )),
                  ]),
                  const SizedBox(height: 12),
                  _svLabelRow(
                      label: 'Referred By',
                      child: DropdownButtonFormField<GetStaffDetailsListModel>(
                        key: formKey1,
                        value: staffdetailsmodel.contains(selectedStaff)
                            ? selectedStaff
                            : null,
                        decoration: _fDeco(null),
                        items: staffdetailsmodel
                            .map((s) => DropdownMenuItem(
                                value: s, child: Text(s.staffName ?? '')))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStaff = value;
                            selectedReferredID = value?.staffId!.toInt();
                            selectedReferredName = value?.staffName!.toString();
                          });
                        },
                        isExpanded: true,
                      )),
                  _svLabelRow(
                      label: 'Select Product *',
                      child: DropdownButtonFormField<GetItemMasterListModel>(
                        key: formKey2,
                        value: masterListModel.contains(selectedMaster)
                            ? selectedMaster
                            : null,
                        decoration: _fDeco(null),
                        items: masterListModel
                            .map((s) => DropdownMenuItem(
                                value: s, child: Text(s.itemName ?? '')))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMaster = value!;
                            selectedTranssvItemName = selectedMaster?.itemName;
                            selectedProductID = selectedMaster?.itemId?.toInt();
                            int? itemIds = selectedMaster?.itemId?.toInt();
                            depositAmount =
                                getDepositAmountByItemId(itemIds)?.toDouble();
                            refillAmountCyl =
                                getRefillAmountByItemId(itemIds)?.toDouble();
                            depositCylinderAmountController.text =
                                depositAmount.toString();
                            refillCylinderAmountController.text =
                                refillAmountCyl.toString();
                            if (selectedMaster?.itemSubType == "ND" ||
                                selectedTranssvItemName == "5 KG DOM") {
                              selectedTransacc = "NC";
                            } else {
                              selectedTransacc = null;
                            }
                            items.clear();
                            _selectedItems.clear();
                            _itemStockByIndex.clear();
                            _selectedItemIds.clear();
                            _addNewItem();
                            cylinderQtyAddController.clear();
                            selectedTranqty = null;
                            isSVPending = false;
                            isExemptedReticulated = false;
                            if (modes == "Edit") {
                              getRegulatorDepositAmountFromApi =
                                  getRefillAmountByItemName("SC REGULATOR")
                                      ?.toDouble();
                              calculateBasicAmountSum();
                              calculateGrandTotalAmount();
                            } else {
                              calculateBasicAmountSum();
                              calculateGrandTotalAmount();
                              regulatorDepositAmountController.text =
                                  getRegulatorDepositAmountFromApi.toString();
                            }
                          });
                        },
                        isExpanded: true,
                      )),
                  _svLabelRow(
                      label: 'SV Type *',
                      child: DropdownButtonFormField<String>(
                        key: formKey5,
                        value: selectedTransacc ??
                            ((selectedMaster?.itemSubType == "ND" ||
                                    selectedTranssvItemName == "5 KG DOM")
                                ? "NC"
                                : null),
                        decoration: _fDeco(null),
                        items: getTransacc
                            .map((v) =>
                                DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (selectedMaster?.itemSubType == "ND" ||
                                selectedTranssvItemName == "5 KG DOM")
                            ? null
                            : (value) {
                                setState(() {
                                  if (selectedTransacc != value &&
                                      conNoController.text.isNotEmpty) {
                                    conNoController.clear();
                                    FocusScope.of(context).unfocus();
                                  }
                                  selectedTransacc = value;
                                  calculateBasicAmountSum();
                                  calculateGrandTotalAmount();
                                  if(selectedTransacc == "NC"){
                                    depositCylinderAmountController.text =
                                        depositAmount.toString();
                                    regulatorDepositAmountController.text =
                                        getRegulatorDepositAmountFromApi
                                            .toString();
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                  }else if (selectedTransacc == "RC") {
                                    regulatorDepositAmountController.text = '';
                                    depositCylinderAmountController.text = '';
                                    refillCylinderAmountController.text =
                                        (refillAmountCyl! * 1).toString();
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                    isSVPending = false;
                                    isExemptedReticulated = false;
                                  } else if (selectedTransacc ==
                                      "Name Change") {
                                    regulatorDepositAmountController.text = '';
                                    depositCylinderAmountController.text = '';
                                    refillCylinderAmountController.text = '0';
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                    isSVPending = false;
                                    isExemptedReticulated = false;
                                  } else {
                                    if (selectedTransacc == "DBC") {
                                      depositCylinderAmountController.text =
                                          depositAmount.toString();
                                      regulatorDepositAmountController.text =
                                          '';
                                      selectedTranqty = "1";
                                      cylinderQty = 1;
                                      refillCylinderAmountController.text =
                                          (refillAmountCyl! * 1).toString();
                                      calculateBasicAmountSum();
                                      calculateGrandTotalAmount();
                                      isSVPending = false;
                                      isExemptedReticulated = false;
                                    }
                                    if (modes == "Edit") {
                                      depositAmount = getDepositAmountByItemId(
                                              selectedProductID)
                                          ?.toDouble();
                                      depositCylinderAmountController.text =
                                          depositAmount.toString();
                                      getRegulatorDepositAmountFromApi =
                                          getRefillAmountByItemName(
                                                  "SC REGULATOR")
                                              ?.toDouble();
                                      regulatorDepositAmountController.text =
                                          getRegulatorDepositAmountFromApi
                                              .toString();
                                    }
                                    depositCylinderAmountController.text =
                                        depositAmount.toString();
                                    regulatorDepositAmountController.text =
                                        getRegulatorDepositAmountFromApi
                                            .toString();
                                  }
                                });
                              },
                        isExpanded: true,
                      )),
                ]),
                if (selectedTransacc == "NC" ||
                    selectedTransacc == "RC" ||
                    selectedTransacc == "DBC") ...[
                  _svSectionHeader('Cylinder Details', AppColors.teal),
                  _svCard([
                    if (selectedTransacc != "RC" && selectedTransacc != "DBC")
                      // Row(children: [
                      //   Checkbox(
                      //       value: isSVPending,
                      //       activeColor: AppColors.blue,
                      //       onChanged: (v) {
                      //         setState(() {
                      //           isSVPending = v ?? false;
                      //           if (isSVPending) {
                      //             if (invoiceAutoManualMandatory) {
                      //               conNoController.clear();
                      //               _isConsumerEmpty = false;
                      //             }
                      //           } else {
                      //             if (!invoiceAutoManualMandatory) {
                      //               invNoController.clear();
                      //               _isInvoiceEmpty = false;
                      //             }
                      //           }
                      //         });
                      //       }),
                      //   const Text('SV Pending',
                      //       style: TextStyle(
                      //           color: AppColors.textMid,
                      //           fontWeight: FontWeight.w500)),
                      //   if ((selectedTransacc != "RC" &&
                      //           selectedTransacc != "DBC") &&
                      //       selectedTranssvItemName == "14.2 KG") ...[
                      //     Checkbox(
                      //         value: isExemptedReticulated,
                      //         activeColor: AppColors.blue,
                      //         onChanged: (v) {
                      //           setState(() {
                      //             isExemptedReticulated = v!;
                      //             if (isExemptedReticulated) {
                      //               previousRegulatorDepositAmount =
                      //                   regulatorDepositAmountController.text;
                      //               regulatorDepositAmountController.text = "0";
                      //             } else {
                      //               regulatorDepositAmountController.text =
                      //                   previousRegulatorDepositAmount ?? "0";
                      //             }
                      //           });
                      //         }),
                      //     const Text('Exempted/Reticulated',
                      //         style: TextStyle(
                      //             color: AppColors.textMid,
                      //             fontWeight: FontWeight.w500)),
                      //   ],
                      // ]),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSVPending,
                                activeColor: AppColors.blue,
                                onChanged: (v) {
                                  setState(() {
                                    isSVPending = v ?? false;

                                    if (isSVPending) {
                                      if (invoiceAutoManualMandatory) {
                                        conNoController.clear();
                                        _isConsumerEmpty = false;
                                      }
                                    } else {
                                      if (!invoiceAutoManualMandatory) {
                                        invNoController.clear();
                                        _isInvoiceEmpty = false;
                                      }
                                    }
                                  });
                                },
                              ),

                              Flexible(
                                child: Text(
                                  'SV Pending',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textMid,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if ((selectedTransacc != "RC" &&
                            selectedTransacc != "DBC") &&
                            selectedTranssvItemName == "14.2 KG")
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isExemptedReticulated,
                                  activeColor: AppColors.blue,
                                  onChanged: (v) {
                                    setState(() {
                                      isExemptedReticulated = v!;

                                      if (isExemptedReticulated) {
                                        previousRegulatorDepositAmount =
                                            regulatorDepositAmountController.text;

                                        regulatorDepositAmountController.text = "0";
                                        calculateBasicAmountSum();
                                        calculateGrandTotalAmount();
                                      } else {
                                        regulatorDepositAmountController.text =
                                            previousRegulatorDepositAmount ?? "0";
                                        calculateBasicAmountSum();
                                        calculateGrandTotalAmount();
                                      }
                                    });
                                  },
                                ),

                                Flexible(
                                  child: Text(
                                    'Exempted/\nReticulated',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textMid,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 12, runSpacing: 12, children: [
                      if (selectedTranssvItemName == "14.2 KG" &&
                          !isExemptedReticulated)
                        SizedBox(
                            width: halfWidth,
                            child: DropdownButtonFormField<String>(
                              value: selectedTranqty ??
                                  (selectedTransacc == "DBC" ? "1" : null),
                              decoration: _fDeco('Cyl. Qty *',
                                  error: (selectedTranqty == null ||
                                          selectedTranqty!.isEmpty)
                                      ? 'Cyl. Qty Is Required'
                                      : null),
                              items: getTransqty
                                  .map((v) => DropdownMenuItem(
                                      value: v, child: Text(v)))
                                  .toList(),
                              onChanged: selectedTransacc == "DBC"
                                  ? null
                                  : (value) {
                                      setState(() {
                                        selectedTranqty = value;
                                        cylinderQty =
                                            int.parse(selectedTranqty!);
                                        int qtyV = int.parse(selectedTranqty!);
                                        if (selectedTransacc == "RC") {
                                          refillCylinderAmountController.text =
                                              (refillAmountCyl! * qtyV)
                                                  .toString();
                                        } else {
                                          depositCylinderAmountController.text =
                                              (depositAmount! * qtyV)
                                                  .toString();
                                          refillCylinderAmountController.text =
                                              (refillAmountCyl! * qtyV)
                                                  .toString();
                                        }
                                        calculateBasicAmountSum();
                                        calculateGrandTotalAmount();
                                      });
                                    },
                              isExpanded: true,
                            )),
                      if (selectedTranssvItemName != "14.2 KG" ||
                          isExemptedReticulated)
                        SizedBox(
                            width: halfWidth,
                            child: TextField(
                                controller: cylinderQtyAddController,
                                decoration: _fDeco('Cyl. Qty *'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2)
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    cylinderQty = int.tryParse(value);
                                    int? q = int.tryParse(value);
                                    if (q != null) {
                                      depositCylinderAmountController.text =
                                          (depositAmount! * q).toString();
                                      refillCylinderAmountController.text =
                                          (refillAmountCyl! * q).toString();
                                      calculateBasicAmountSum();
                                      calculateGrandTotalAmount();
                                    }
                                  });
                                })),
                      if ((selectedTransacc != "DBC") &&
                          selectedTranssvItemName == "14.2 KG")
                        SizedBox(
                            width: halfWidth,
                            child: TextField(
                                controller: scRegulatorController,
                                decoration: _fDeco('SC Regulator'),
                                enabled: false)),
                      if (selectedTranssvItemName != "14.2 KG")
                        SizedBox(
                            width: halfWidth,
                            child: DropdownButtonFormField<String>(
                              value: getSelectedFTLRegulatorQtyString,
                              decoration: _fDeco('FTL Regulator *',
                                  error: (getSelectedFTLRegulatorQtyString ==
                                              null ||
                                          getSelectedFTLRegulatorQtyString!
                                              .isEmpty)
                                      ? 'FTL Regulator Is Required'
                                      : null),
                              items: getSelectedFTLRegulatorQty
                                  .map((v) => DropdownMenuItem(
                                      value: v, child: Text(v)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  getSelectedFTLRegulatorQtyString = value;
                                  selectedFTLRegQty = int.parse(
                                      getSelectedFTLRegulatorQtyString!);
                                  if (selectedFTLRegQty == 0) {
                                    calculateBasicAmountSumDepositMinus();
                                    calculateGrandTotalAmountDepositMinus();
                                    regulatorDepositAmountController.text = "0";
                                  } else {
                                    if (modes == "Edit") {
                                      getRegulatorDepositAmountFromApi =
                                          getRefillAmountByItemName(
                                                  "SC REGULATOR")
                                              ?.toDouble();
                                      regulatorDepositAmountController.text =
                                          getRegulatorDepositAmountFromApi
                                              .toString();
                                    } else {
                                      regulatorDepositAmountController.text =
                                          getRegulatorDepositAmountFromApi
                                              .toString();
                                    }
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                  }
                                });
                              },
                              isExpanded: true,
                            )),
                      SizedBox(
                          width: halfWidth,
                          child: TextField(
                              controller: depositCylinderAmountController,
                              decoration: _fDeco('Deposit Cyl. *',
                                  error: depositCylinderAmountController
                                          .text.isEmpty
                                      ? 'Deposit Cyl. is Required'
                                      : null),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                                LengthLimitingTextInputFormatter(7)
                              ],
                              enabled: selectedTranssvItemName == "14.2 KG" &&
                                  selectedTransacc == "RC",
                              onChanged: (v) {
                                calculateBasicAmountSum();
                                calculateGrandTotalAmount();
                              })),
                      SizedBox(
                          width: halfWidth,
                          child: TextField(
                              controller: refillCylinderAmountController,
                              decoration: _fDeco('Cyl Refill Amt.'),
                              enabled: false)),
                      if (selectedTransacc != "DBC")
                        SizedBox(
                            width: halfWidth,
                            child: TextField(
                                controller: regulatorDepositAmountController,
                                decoration: _fDeco('Regulator Deposit *',
                                    error: regulatorDepositAmountController
                                            .text.isEmpty
                                        ? 'Regulator Deposit is Required'
                                        : null),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                  LengthLimitingTextInputFormatter(7)
                                ],
                                enabled: selectedTranssvItemName == "14.2 KG" &&
                                    selectedTransacc == "RC" &&
                                    !isExemptedReticulated,
                                onChanged: (v) {
                                  calculateBasicAmountSum();
                                  calculateGrandTotalAmount();
                                })),
                      SizedBox(
                          width: halfWidth,
                          child: TextField(
                              controller: stampDutyController,
                              decoration: _fDeco('Stamp Duty'),
                              enabled: false)),
                      if (selectedTranssvItemName != "14.2 KG")
                        SizedBox(
                            width: halfWidth,
                            child: TextField(
                                controller: regulatorDiscountAmountController,
                                decoration: _fDeco('Discount Amount'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (v) {
                                  setState(() {
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                  });
                                })),
                      SizedBox(
                          width: halfWidth,
                          child: TextField(
                              controller: regulatorBasicAmountController,
                              decoration: _fDeco('Basic Amount'),
                              enabled: false)),
                    ]),
                  ]),
                ],
                if (selectedTransacc == "Name Change") ...[
                  _svSectionHeader('Name Change', AppColors.orange),
                  _svCard([
                    SizedBox(
                        width: halfWidth,
                        child: TextField(
                            controller: nameChangeAmtChargesController,
                            decoration: _fDeco('Amount Charges *',
                                error:
                                    nameChangeAmtChargesController.text.isEmpty
                                        ? 'Amount Charges is Required'
                                        : null),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                              LengthLimitingTextInputFormatter(7)
                            ],
                            onChanged: (value) {
                              value = value.trim();
                              if (value.isNotEmpty) {
                                try {
                                  calculateBasicAmountSum();
                                  calculateGrandTotalAmount();
                                } catch (e) {
                                  showFlushBar(
                                      context, "Invalid amount format.");
                                }
                              }
                            }))
                  ]),
                ],
                _svSectionHeader('Consumer Details', AppColors.green),
                _svCard([
                  if (!isSVPending) ...[
                    TextField(
                        controller: conNoController,
                        focusNode: _conNoFocusNode,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.deny(
                              RegExp(r'[^\u0000-\u007F]')),
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        decoration: _fDeco('Consumer No. / DC No. *',
                            error: _isConsumerEmpty
                                ? 'Consumer No./DC No. Is Required'
                                : null),
                        onChanged: (v) {
                          setState(() {
                            _isConsumerEmpty = v.isEmpty;
                          });
                        }),
                    const SizedBox(height: 12)
                  ],
                  if (isSVPending && !invoiceAutoManualMandatory ||
                      invoiceAutoManualMandatory) ...[
                    TextField(
                        controller: invNoController,
                        readOnly: invoiceAutoManualMandatory,
                        enabled: true,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: invoiceAutoManualMandatory
                            ? []
                            : [
                                LengthLimitingTextInputFormatter(16),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                        decoration: _fDeco(
                                invoiceAutoManualMandatory
                                    ? 'Invoice No. (Auto)'
                                    : 'Invoice No. / DC No. *',
                                error: _isInvoiceEmpty
                                    ? 'Invoice No. OR DC No. Is Required'
                                    : null)
                            .copyWith(
                                suffixIcon: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: invoiceAutoManualMandatory
                                        ? 'Auto-generated Invoice number'
                                        : 'Manual Invoice Number',
                                    child: const Icon(Icons.info_outline,
                                        color: AppColors.blue))),
                        onChanged: (v) {
                          setState(() {
                            _isInvoiceEmpty = v.isEmpty;
                          });
                        }),
                    const SizedBox(height: 12)
                  ],
                  TextField(
                      controller: conNameController,
                      decoration: _fDeco('Consumer Name'),
                      onChanged: (v) {}),
                  const SizedBox(height: 12),
                  TextField(
                      controller: conContactController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                      decoration: _fDeco('Consumer Contact No.',
                          error: _isConCOntactEmpty
                              ? 'Please Enter A Valid Contact No.'
                              : _isInvalidMobile
                                  ? 'Invalid Mobile Number'
                                  : _isShortLength
                                      ? 'Must be 10 digits'
                                      : null),
                      onChanged: (value) {
                        setState(() {
                          _isConCOntactEmpty = value.isEmpty;
                          if (value.isNotEmpty) {
                            _isInvalidMobile =
                                !RegExp(r'^[6789]').hasMatch(value);
                            _isShortLength = value.length < 10;
                          } else {
                            _isInvalidMobile = false;
                            _isShortLength = false;
                          }
                        });
                      }),
                  const SizedBox(height: 12),
                  TextField(
                      controller: conAddNoController,
                      inputFormatters: [LengthLimitingTextInputFormatter(250)],
                      decoration: _fDeco('Consumer Address'),
                      onChanged: (v) {}),
                ]),
                _svSectionHeader('Items', AppColors.amber),
                Row(children: [
                  const Text('Add Item',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMid)),
                  const SizedBox(width: 12),
                  GestureDetector(
                      onTap: _isAddNewItemEnabled ? _addNewItem : null,
                      child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                              color: _isAddNewItemEnabled
                                  ? AppColors.blue
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20))),
                ]),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x0D1E3A8A),
                              blurRadius: 12,
                              offset: Offset(0, 2))
                        ]),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: _fDeco('Select Item *'),
                          value: _selectedItems[index]?.isEmpty ?? true
                              ? null
                              : _selectedItems[index],
                          items: _items
                              .where((item) =>
                                  !_selectedItems.values
                                      .contains(item.itemName) ||
                                  _selectedItems[index] == item.itemName)
                              .toSet()
                              .map((item) => DropdownMenuItem<String>(
                                  value: item.itemName,
                                  child: Text(item.itemName ?? 'Unknown')))
                              .toList(),
                          onChanged: (selectedItemName) {
                            if (selectedItemName != null) {
                              setState(() {
                                _selectedItems[index] = selectedItemName;
                                final sel = _items.firstWhere(
                                    (item) => item.itemName == selectedItemName,
                                    orElse: () => GetArbItemMasterListModel());
                                _itemStockByIndex[index] =
                                    getArbItemCurrentStock(sel.itemId?.toInt())
                                        ?.toInt();
                                _selectedItemIds[index] = sel.itemId?.toInt();
                                _selectedCategoryName[index] = sel.categoryName;
                                double rate = sel.rate?.toDouble() ?? 0.0;
                                items[index]['rate']?.text = rate.toString();
                                items[index]['amt']?.text = rate.toString();
                                if (sel.categoryName == "Non ARB Item") {
                                  items[index]['qty']?.text = "1";
                                  items[index]['discount']?.clear();
                                  _updateSum(index);
                                  calculateGrandTotalAmount();
                                  if (index == items.length - 1)
                                    Future.delayed(
                                        const Duration(milliseconds: 200),
                                        _addNewItem);
                                } else {
                                  int? stockLimit = _itemStockByIndex[index];
                                  if (stockLimit != null && 1 > stockLimit) {
                                    items[index]['qty']?.clear();
                                    items[index]['discount']?.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Qty exceeds stock: $stockLimit'),
                                            backgroundColor: AppColors.red));
                                    _updateSum(index);
                                    calculateGrandTotalAmount();
                                  } else {
                                    items[index]['qty']?.text = "1";
                                    items[index]['discount']?.clear();
                                    _updateSum(index);
                                    calculateGrandTotalAmount();
                                    if (index == items.length - 1)
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          _addNewItem);
                                  }
                                }
                                calculateGrandTotalAmount();
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  if (_discountFocusNodes.length > index)
                                    FocusScope.of(context).requestFocus(
                                        _discountFocusNodes[index]);
                                });
                              });
                            }
                          },
                        )),
                        const SizedBox(width: 8),
                        GestureDetector(
                            onTap: () => _removeItem(index),
                            child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                    color: AppColors.redXL,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.delete_outline_rounded,
                                    color: AppColors.red, size: 20))),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child: TextField(
                                controller: items[index]['rate'],
                                decoration: _fDeco('Rate'),
                                enabled: false)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                                controller: items[index]['qty'],
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3)
                                ],
                                decoration: _fDeco('Qty *'),
                                onChanged: (value) {
                                  setState(() {
                                    int enteredQty = int.tryParse(value) ?? 0;
                                    int? stockLimit = _itemStockByIndex[index];
                                    String? catCheck =
                                        _selectedCategoryName[index];
                                    if (catCheck != "Non ARB Item" &&
                                        value.isNotEmpty &&
                                        stockLimit != null &&
                                        enteredQty > stockLimit) {
                                      items[index]['qty']?.clear();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Qty exceeds stock: $stockLimit'),
                                              backgroundColor: AppColors.red));
                                    }
                                    _updateSum(index);
                                    calculateGrandTotalAmount();
                                  });
                                })),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                                controller: items[index]['discount'],
                                focusNode: _discountFocusNodes[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(7)
                                ],
                                decoration: _fDeco('Discount'),
                                onChanged: (v) {
                                  setState(() {
                                    _updateSum(index);
                                    calculateGrandTotalAmount();
                                  });
                                })),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                                controller: items[index]['amt'],
                                decoration: _fDeco('Amt.'),
                                enabled: false)),
                      ]),
                    ]),
                  ),
                ),
                _svSectionHeader('Payment', AppColors.orange),
                _svCard([
                  TextField(
                      controller: totalAmountController,
                      decoration: _fDeco('Total Amount'),
                      enabled: false),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                      key: formKey3,
                      value: selectedTransMode,
                      decoration: _fDeco('Payment Mode *'),
                      items: getTransMode
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedTransMode = v;
                        });
                      },
                      isExpanded: true),
                  if (selectedTransMode == 'Partial' ||
                      selectedTransMode == 'Merchant QR') ...[
                    const SizedBox(height: 12),
                    TextField(
                        controller: partialQRController,
                        decoration: _fDeco('QR Receipt Payment *',
                            error: _isQRcode ? 'QR amount is Required' : null),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,10}'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isQRcode = value.isEmpty;
                            isEditingQR = true;
                            isEditingCash = false;
                            double ta =
                                double.tryParse(totalAmountController.text) ??
                                    0.0;
                            double qa = double.tryParse(value) ?? 0.0;
                            if (qa > ta) {
                              partialQRController.clear();
                            } else if (selectedTransMode == 'Partial') {
                              updateRemainingAmount();
                            }
                          });
                        })
                  ],
                  if (selectedTransMode == 'Partial' ||
                      selectedTransMode == 'Cash') ...[
                    const SizedBox(height: 12),
                    TextField(
                        controller: recPaymentController,
                        decoration: _fDeco('Cash Receipt Payment *',
                            error: _iscashcode
                                ? 'Receipt cash is Required'
                                : null),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,10}'))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _iscashcode = value.isEmpty;
                            isEditingCash = true;
                            isEditingQR = false;
                            double ta =
                                double.tryParse(totalAmountController.text) ??
                                    0.0;
                            double ra = double.tryParse(value) ?? 0.0;
                            if (ra > ta) {
                              recPaymentController.clear();
                            } else if (selectedTransMode == 'Partial') {
                              updateRemainingAmount();
                            }
                          });
                        })
                  ],
                  if (selectedTransMode == 'Merchant QR' ||
                      selectedTransMode == 'Partial') ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<GetBankMappingDetailsListModel>(
                    isExpanded: true,
                        decoration: _fDeco('Select Account No. *'),
                        value: bankModel.contains(_selectBankModel)
                            ? _selectBankModel
                            : null,
                        items: bankModel
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                    '${item.bankName ?? ''} - ${item.accountNo ?? ''}')))
                            .toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectBankModel = selectedItem;
                            selectedBankName = selectedItem?.bankName;
                            selectedBankId = selectedItem?.accountNo;
                            selecteBankIDApi = selectedItem?.bankId?.toInt();
                            accMappingId = selectedItem?.mappingId?.toInt();
                          });
                        }),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                          child: TextField(
                              controller: TranCodeController,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[^\u0000-\u007F]')),
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
                              ],
                              decoration: _fDeco('Transaction Code *',
                                  error: _isTranscode
                                      ? 'Transaction code is Required'
                                      : null),
                              onChanged: (v) {
                                setState(() {
                                  _isTranscode = v.isEmpty;
                                });
                              })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextField(
                              controller: timeController,
                              decoration: _fDeco('Time'),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[\d.:]{0,5}$'))
                              ],
                              onChanged: (v) {
                                setState(() {});
                              })),
                    ]),
                    const SizedBox(height: 12),
                    TextField(
                        controller: transReviewController,
                        decoration: _fDeco('Transaction Remark'),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250)
                        ],
                        onChanged: (v) {
                          setState(() {});
                        }),
                  ],
                ]),
                if (selectedTransMode == 'Cash' ||
                    selectedTransMode == 'Partial') ...[
                  Row(children: [
                    Checkbox(
                        value: isCashDenominationChecked,
                        activeColor: AppColors.blue,
                        onChanged: (v) {
                          setState(() {
                            isCashDenominationChecked = v ?? false;
                          });
                        }),
                    const Text('Cash Denomination',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMid)),
                  ]),
                  if (isCashDenominationChecked) ...[
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                            cashDenominationMandatory
                                ? 'Cash Denomination Is Mandatory'
                                : 'Cash Denomination',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold))),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          color: AppColors.blueXXL,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 0;
                                  });
                                },
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 0
                                            ? AppColors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text('Cash Denomination',
                                        style: TextStyle(
                                            color: _selectedIndex == 0
                                                ? Colors.white
                                                : AppColors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13))))),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 1
                                            ? AppColors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text('Cash Return',
                                        style: TextStyle(
                                            color: _selectedIndex == 1
                                                ? Colors.white
                                                : AppColors.blue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13))))),
                      ]),
                    ),
                    Visibility(
                        visible: _selectedIndex == 0,
                        child: _svCard([
                          Row(children: const [
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text('Note Type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)))),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)))),
                            Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13))))
                          ]),
                          const Divider(height: 16),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  getNoteTypeAndIdFroDenominationListModel
                                      .length,
                              itemBuilder: (context, index) {
                                final data =
                                    getNoteTypeAndIdFroDenominationListModel[
                                        index];
                                return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: Text('${data.noteType}',
                                                  style: const TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 1,
                                          child: const Center(
                                              child: Text('X',
                                                  style: TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 3,
                                          child: TextField(
                                              controller: qtyController[index],
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: _fDeco(null),
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  amounts[index] =
                                                      (double.tryParse(value) ??
                                                              0.0) *
                                                          data.noteType!;
                                                  totalAmount = amounts.fold(
                                                      0.0, (s, a) => s + a);
                                                  finalAmountCashDeno =
                                                      totalAmount -
                                                          returnAmount;
                                                });
                                              })),
                                      Expanded(
                                          flex: 1,
                                          child: const Center(
                                              child: Text('=',
                                                  style: TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                              child: Text(
                                                  amounts[index]
                                                      .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontSize: 12))))
                                    ]));
                              }),
                          const Divider(height: 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                        const Text('Collected: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMid)),
                                        Text(totalAmount.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blue))
                                      ]),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        const Text('Final Total: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMid)),
                                        Text(
                                            finalAmountCashDeno
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.green))
                                      ])
                                    ])
                              ]),
                        ])),
                    Visibility(
                        visible: _selectedIndex == 1,
                        child: _svCard([
                          Row(children: const [
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text('Note Type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)))),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('Qty',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)))),
                            Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13))))
                          ]),
                          const Divider(height: 16),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  getNoteTypeAndIdFroDenominationListModel
                                      .length,
                              itemBuilder: (context, index) {
                                final data =
                                    getNoteTypeAndIdFroDenominationListModel[
                                        index];
                                return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: Text('${data.noteType}',
                                                  style: const TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 1,
                                          child: const Center(
                                              child: Text('X',
                                                  style: TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 3,
                                          child: TextField(
                                              controller:
                                                  qtyControllerReturn[index],
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: _fDeco(null),
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                setState(() {
                                                  amountsReturn[index] =
                                                      (double.tryParse(value) ??
                                                              0.0) *
                                                          data.noteType!;
                                                  returnAmount =
                                                      amountsReturn.fold(
                                                          0.0, (s, a) => s + a);
                                                  finalAmountCashDeno =
                                                      totalAmount -
                                                          returnAmount;
                                                });
                                              })),
                                      Expanded(
                                          flex: 1,
                                          child: const Center(
                                              child: Text('=',
                                                  style: TextStyle(
                                                      fontSize: 12)))),
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                              child: Text(
                                                  amountsReturn[index]
                                                      .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontSize: 12))))
                                    ]));
                              }),
                          const Divider(height: 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                        const Text('Return: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMid)),
                                        Text(returnAmount.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.orange))
                                      ]),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        const Text('Final Total: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textMid)),
                                        Text(
                                            finalAmountCashDeno
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.green))
                                      ])
                                    ])
                              ]),
                        ])),
                  ],
                ],
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: cancelAction,
                          style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.blue,
                              side: const BorderSide(
                                  color: AppColors.blue, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              minimumSize: const Size(0, 52)),
                          child: const Text('Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15)))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      if (saveFlag) {
                        showFlushBar(context, Constants.dayEndCompleted);
                      } else {
                        if (modes == "Edit") {
                          updateSVAddEditForMob(context, psvIdEdit!, "EDIT");
                        } else {
                          updateSVAddEditForMob(context, 0, "ADD");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            saveFlag ? AppColors.border : AppColors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        minimumSize: const Size(0, 52),
                        elevation: 0),
                    child: Text(modes == "Edit" ? 'Update' : 'Save',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  )),
                ]),
                const SizedBox(height: 20),
                _svSectionHeader("Today's Records", AppColors.blueLight),
                if (receiptList.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: receiptList.length,
                      itemBuilder: (context, index) {
                        GetAddEditDataSvSaleItemModel? svSale =
                            receiptList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x0D1E3A8A),
                                    blurRadius: 12,
                                    offset: Offset(0, 2))
                              ]),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  svSale.sVDate ?? '')),
                                          style: const TextStyle(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13))),
                                  Expanded(
                                      child: Text(svSale.productName.toString(),
                                          style: const TextStyle(
                                              color: AppColors.textMid,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13))),
                                  Row(children: [
                                    IconButton(
                                        icon: Icon(Icons.edit_outlined,
                                            color: saveFlag
                                                ? AppColors.border2
                                                : AppColors.blue,
                                            size: 20),
                                        onPressed: () {
                                          loadDenominationData(
                                              svSale.pSVId!.toInt());
                                          if (saveFlag) {
                                            showFlushBar(context,
                                                Constants.dayEndCompleted);
                                            return;
                                          }
                                          Navigator.pushNamed(context,
                                              SVSaleReportScreen.screenName,
                                              arguments: {
                                                'psvIDV':
                                                    svSale.pSVId.toString(),
                                                'sVDateV':
                                                    svSale.sVDate.toString(),
                                                'referredByIdV': svSale
                                                    .referredById
                                                    .toString(),
                                                'referredByNameV': svSale
                                                    .referredByName
                                                    .toString(),
                                                'otherNameV':
                                                    svSale.otherName.toString(),
                                                'productIdV':
                                                    svSale.productId.toString(),
                                                'productNameV': svSale
                                                    .productName
                                                    .toString(),
                                                'isUndocumentV': svSale
                                                    .isUndocument
                                                    .toString(),
                                                'sVTypeV':
                                                    svSale.sVType.toString(),
                                                'cylQtyV':
                                                    svSale.cylQty.toString(),
                                                'sCRegulatorV': svSale
                                                    .sCRegulator
                                                    .toString(),
                                                'depositCylV': svSale.depositCyl
                                                    .toString(),
                                                'cylRefillRSPV': svSale
                                                    .cylRefillRSP
                                                    .toString(),
                                                'regulatorDepositV': svSale
                                                    .regulatorDeposit
                                                    .toString(),
                                                'stampDutyV':
                                                    svSale.stampDuty.toString(),
                                                'fTLRegulatorV': svSale
                                                    .fTLRegulator
                                                    .toString(),
                                                'basicAmtV':
                                                    svSale.basicAmt.toString(),
                                                'consuDCNoV':
                                                    svSale.consuDCNo.toString(),
                                                'consumerNameV': svSale
                                                    .consumerName
                                                    .toString(),
                                                'consuContactNoV': svSale
                                                    .consuContactNo
                                                    .toString(),
                                                'totalAmountV': svSale
                                                    .totalAmount
                                                    .toString(),
                                                'receiptAmtV': svSale.receiptAmt
                                                    .toString(),
                                                'partialQRV': svSale
                                                    .qRReceiptAmt
                                                    .toString(),
                                                'paymentModeV': svSale
                                                    .paymentMode
                                                    .toString(),
                                                'transactionCodeV': svSale
                                                    .transactionCode
                                                    .toString(),
                                                'transactionTimeV': svSale
                                                    .transactionTime
                                                    .toString(),
                                                'transactionRemarkV': svSale
                                                    .transactionRemark
                                                    .toString(),
                                                'addedByV':
                                                    svSale.addedBy.toString(),
                                                'actionV':
                                                    svSale.action.toString(),
                                                'itemIdV':
                                                    svSale.itemId.toString(),
                                                'itemNameV':
                                                    svSale.itemName.toString(),
                                                'rateV': svSale.rate.toString(),
                                                'itemQtyV':
                                                    svSale.itemQty.toString(),
                                                'discountAmtV': svSale
                                                    .discountAmt
                                                    .toString(),
                                                'aRBAmountV':
                                                    svSale.aRBAmount.toString(),
                                                'amtChargesV': svSale.amtCharges
                                                    .toString(),
                                                'categoryNameV': svSale
                                                    .categoryName
                                                    .toString(),
                                                'bankIdV':
                                                    svSale.bankId.toString(),
                                                'bankMappingIdV': svSale
                                                    .bankMappingId
                                                    .toString(),
                                                'accountNoV':
                                                    svSale.accountNo.toString(),
                                                'bankNameV':
                                                    svSale.bankName.toString(),
                                                'isExemptRetiV': svSale
                                                    .isExemptReti
                                                    .toString(),
                                                'sVDiscountAmtV': svSale
                                                    .sVDiscountAmt
                                                    .toString(),
                                                'itemsToShow': svSale
                                                    .itemDetails
                                                    ?.toList(),
                                                'consumerAddressV': svSale
                                                    .consuAddress
                                                    .toString(),
                                                'invoiceNumberV':
                                                    svSale.invoiceNo.toString(),
                                                'invoiceTypeV': svSale
                                                    .invoiceType
                                                    .toString(),
                                                'modeChange': 'Edit'
                                              });
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete_outline_rounded,
                                            color: saveFlag
                                                ? AppColors.border2
                                                : AppColors.red,
                                            size: 20),
                                        onPressed: () async {
                                          if (saveFlag) {
                                            showFlushBar(context,
                                                Constants.dayEndCompleted);
                                            return;
                                          }
                                          int? psv = svSale.pSVId?.toInt();
                                          bool? confirmDelete = await showDialog<
                                                  bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18)),
                                                      title: const Text(
                                                          'Confirm Delete'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this record?'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop(false),
                                                            child: const Text(
                                                                'Cancel')),
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .red,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10))),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop(true),
                                                            child: const Text(
                                                                'Delete'))
                                                      ]));
                                          if (confirmDelete == true &&
                                              psv != null)
                                            updateSVAddEditForMob(
                                                context, psv, "DELETE");
                                        }),
                                  ]),
                                ]),
                            const Divider(height: 12),
                            _receiptInfoRow(
                                'SV Type',
                                svSale.sVType.toString(),
                                'SV Pending',
                                svSale.isUndocument == true ? 'Yes' : 'No'),
                            _receiptInfoRow(
                                'DC/Invoice',
                                [
                                  if (svSale.consuDCNo != null &&
                                      svSale.consuDCNo!.isNotEmpty &&
                                      svSale.consuDCNo != '0')
                                    svSale.consuDCNo!,
                                  if (svSale.invoiceNo != null &&
                                      svSale.invoiceNo!.isNotEmpty &&
                                      svSale.invoiceNo != '0')
                                    svSale.invoiceNo!
                                ].join('/'),
                                'Cons. Name',
                                svSale.consumerName.toString()),
                            _receiptInfoRow(
                                'Amount',
                                svSale.totalAmount.toString(),
                                'Mode',
                                svSale.paymentMode == "Bank"
                                    ? 'Merchant QR'
                                    : svSale.paymentMode.toString()),
                            _receiptInfoRow(
                                'Cyl Qty',
                                svSale.cylQty.toString(),
                                'Doc Status',
                                svSale.isUndocument == true
                                    ? 'Pending'
                                    : 'Done'),
                          ]),
                        );
                      })
                else
                  Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x0D1E3A8A),
                                blurRadius: 12,
                                offset: Offset(0, 2))
                          ]),
                      child: const Center(
                          child: Text('No Records Found',
                              style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)))),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateSum(int index) {
    // Get the values from the receivedQty, discount, and rate controllers
    double qtyNew = double.tryParse(items[index]['qty']?.text ?? '') ?? 0;
    double discountNew =
        double.tryParse(items[index]['discount']?.text ?? '') ?? 0;
    double rateNew = double.tryParse(items[index]['rate']?.text ?? '') ?? 0;
    double totalSum = 0.0;
    double newAmt = 0.0;
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
      newAmt = rateNew;
      totalSum = rateNew - discountNew;
      items[index]['amt']?.text = totalSum.toStringAsFixed(2);
      debugPrint("totalSum (qty is empty): $totalSum");
    }
    if (newAmt >= discountNew) {
    } else {
      items[index]['discount']?.clear();
      _updateSum(index);
      calculateGrandTotalAmount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Constants.discountError)),
      );
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
    String? staffStatus = prefs.getString('StaffStatus');
    String? designation = prefs.getString('Designation');
    String? bearerToken =
        prefs.getString('token'); // Assuming the token is stored here

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

  Future<void> getItemMasterList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? isActive = prefs.getString('IsActive');
    String? itemType = prefs.getString('ItemType');
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
    debugPrint("GetItemMasterList : " +
        '${AppUrl.GetItemMasterList}/$distributorId/1/C');
    debugPrint("GetItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        masterListModel = data.map((json) {
          return GetItemMasterListModel.fromJson(json);
        }).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getDistStampDuty() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null || distributorId == null) {
      EasyLoading.dismiss();
      throw Exception('Required token or distributor ID is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetDistStampDuty}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    debugPrint("GetDistStampDuty : ${AppUrl.GetDistStampDuty}/$distributorId");
    debugPrint("Response : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final stampDutyModel = GetDistStampDutyModel.fromJson(data);

      setState(() {
        stampDutyController.text = stampDutyModel.stampDuty?.toString() ?? '';
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load stamp duty data');
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
      Uri.parse('${AppUrl.GetARBItemMasterList}/$distributorId/1/AllARB'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemMasterList : " +
        '${AppUrl.GetARBItemMasterList}/$distributorId/1/AllARB');
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

  Future<void> getRspDetailsListModel() async {
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
      Uri.parse('${AppUrl.GetRSPDetailsList}/$distributorId/ALL'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemMasterList : " +
        '${AppUrl.GetRSPDetailsList}/$distributorId/ALL');
    debugPrint("GetARBItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        getrsplistmodel =
            data.map((json) => GetRspDetailsListModel.fromJson(json)).toList();
        if (modes == "Edit") {
        } else {
          getRegulatorDepositAmountFromApi =
              getRefillAmountByItemName("SC REGULATOR")?.toDouble();
          regulatorDepositAmountController.text =
              getRegulatorDepositAmountFromApi.toString();
        }
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  num? getDepositAmountByItemId(int? itemId) {
    if (itemId == null) return null;

    try {
      return getrsplistmodel
          .firstWhere((element) => element.itemId == itemId)
          .depositAmt;
    } catch (e) {
      // No matching item found
      return null;
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

  num? getRefillAmountByItemName(String? itemName) {
    if (itemName == null) return null;

    try {
      return getrsplistmodel
          .firstWhere((element) => element.itemName == itemName)
          .depositAmt;
    } catch (e) {
      // No matching item found
      return null;
    }
  }

  num? getRefillAmountByItemId(int? itemId) {
    if (itemId == null) return null;

    try {
      return getrsplistmodel
          .firstWhere((element) => element.itemId == itemId)
          .rSPPrice;
    } catch (e) {
      // No matching item found
      return null;
    }
  }

  void calculateBasicAmountSum() {
    double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
    double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
    double regulator =
        double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt =
        double.tryParse(regulatorDiscountAmountController.text) ?? 0;
    double nameChangeAmt =
        double.tryParse(nameChangeAmtChargesController.text) ?? 0;
    double newAmt = 0;
    double total = 0;
    if (selectedTransacc == "Name Change") {
      newAmt = nameChangeAmt;
      total = nameChangeAmt;
    } else {
      newAmt = deposit + refill + regulator + stampDuty;
      total = deposit + refill + regulator + stampDuty - discountAmt;
    }

    debugPrint("total $total");
    debugPrint("newAmt $newAmt");
    regulatorBasicAmountController.text = total.toStringAsFixed(2);
    if (newAmt >= discountAmt) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Constants.discountError)),
      );
      regulatorDiscountAmountController.clear();
      calculateBasicAmountSum();
      calculateGrandTotalAmount();
    }
  }

  void calculateBasicAmountSumDepositMinus() {
    double deposit =
        double.tryParse(depositCylinderAmountController.text.trim()) ?? 0;
    double refill =
        double.tryParse(refillCylinderAmountController.text.trim()) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text.trim()) ?? 0;
    double regulator =
        double.tryParse(regulatorDepositAmountController.text.trim()) ?? 0;
    double discountAmt =
        double.tryParse(regulatorDiscountAmountController.text.trim()) ?? 0;

    debugPrint("Parsed values:");
    debugPrint("Deposit: $deposit");
    debugPrint("Refill: $refill");
    debugPrint("Stamp Duty: $stampDuty");
    debugPrint("Regulator: $regulator");
    debugPrint("Discount: $discountAmt");

    double total =
        deposit + refill + regulator + stampDuty - discountAmt - regulator;

    debugPrint("Total (calculated): $total");

    regulatorBasicAmountController.text = total.toStringAsFixed(2);
  }

  Future<void> fetchItemSvAddEditList() async {
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
          // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
          Uri.parse('${AppUrl.GetPendingSVList_Mob}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URLGetPendingSVList_Mob: ${response.request}");
        print(
            "Request HeadersGetPendingSVList_Mob: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status CodeGetPendingSVList_Mob: ${response.statusCode}");
        print("API Response BodyGetPendingSVList_Mob: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList = data
                .map((json) => GetAddEditDataSvSaleItemModel.fromJson(json))
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

  Future<void> fetchDenominationListAddEditList(int psvId) async {
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
          // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
          Uri.parse(
              '${AppUrl.GetPendingSVCashDenoDtlsById_Mob}/$psvId/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetPendingSVCashDenoDtlsById_Mob: ${response.request}");
        print(
            "Request GetPendingSVCashDenoDtlsById_Mob: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetPendingSVCashDenoDtlsById_Mob: ${response.statusCode}");
        print(
            "API Response GetPendingSVCashDenoDtlsById_Mob: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDenominationLis = data
                .map((json) => GetDenominationListForAddEdit.fromJson(json))
                .toList();
            isLoading = false;
            initializeControllers();
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

  Future<void> loadDenominationData(int psvID) async {
    await fetchDenominationListAddEditList(psvID.toInt());

    // Now call initializeControllers after list is fetched
    initializeControllers();

    // Refresh UI
    setState(() {});
  }

  Future<void> updateSVAddEditForMob(
      BuildContext context, int psvID, String actionMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int scRegulators = 0;
    double cylDeposit = 0.0;
    double cylRefillRSP = 0.0;
    double regDeposit = 0.0;
    double stampD = 0.0;
    double basicAmt = 0.0;
    double discountAmt = 0.0;
    String? conDSNo;
    String? consName;
    String? conCont;
    double totalAmt = 0.0;
    double receiveAmt = 0.0;
    double partialQRAmt = 0.0;
    String? tranCode;
    String? times;
    String? transRemark;
    double nameChangeCharges = 0.0;
    double discountAmount = 0.0;
    List<Map<String, dynamic>> dataCashDenomination = [];
    String? payMode;
    String? conAddress;
    String? invoiceNo;

    if (actionMode != "DELETE") {
      if (scRegulatorController.text.isNotEmpty) {
        scRegulators = int.parse(scRegulatorController.text);
      }

      if (depositCylinderAmountController.text.isNotEmpty) {
        cylDeposit = double.parse(depositCylinderAmountController.text);
      }

      if (refillCylinderAmountController.text.isNotEmpty) {
        cylRefillRSP = double.parse(refillCylinderAmountController.text);
      }
      if (selectedTransacc != "DBC" && selectedTransacc != "Name Change") {
        if (regulatorDepositAmountController.text.isNotEmpty) {
          if (regulatorDepositAmountController.text.isNotEmpty ||
              regulatorDepositAmountController.text != null ||
              regulatorDepositAmountController.text != "null") {
            regDeposit = double.parse(regulatorDepositAmountController.text);
          }
        }
      } else {
        regDeposit = 0;
      }

      if (stampDutyController.text.isNotEmpty) {
        stampD = double.parse(stampDutyController.text);
      }
      if (regulatorBasicAmountController.text.isNotEmpty) {
        basicAmt = double.parse(regulatorBasicAmountController.text);
      }
      if (regulatorDiscountAmountController.text.isNotEmpty) {
        discountAmt = double.parse(regulatorDiscountAmountController.text);
      }
      // if(conNoController.text.isNotEmpty){
      //   conDSNo = conNoController.text;
      // }
      if (!isSVPending && conNoController.text.isNotEmpty) {
        conDSNo = conNoController.text;
      } else {
        conDSNo = "";
      }
      if (conNameController.text.isNotEmpty) {
        consName = conNameController.text;
      }
      if (conContactController.text.isNotEmpty) {
        conCont = conContactController.text;
      }
      // if(invNoController.text.isNotEmpty){
      //   invoiceNo = invNoController.text;
      // }
      if (isSVPending) {
        // Auto Invoice
        invoiceNo = invNoController.text;
      } else {
        // Manual
        invoiceNo = invNoController.text.isNotEmpty ? invNoController.text : "";
      }
      if (conAddNoController.text.isNotEmpty) {
        conAddress = conAddNoController.text;
      }

      if (totalAmountController.text.isNotEmpty) {
        totalAmt = double.parse(totalAmountController.text);
      }
      if (recPaymentController.text.isNotEmpty) {
        receiveAmt = double.parse(recPaymentController.text);
      }
      if (partialQRController.text.isNotEmpty) {
        partialQRAmt = double.parse(partialQRController.text);
      }
      if (TranCodeController.text.isNotEmpty) {
        tranCode = TranCodeController.text;
      }
      if (timeController.text.isNotEmpty) {
        times = timeController.text;
      }
      if (transReviewController.text.isNotEmpty) {
        transRemark = transReviewController.text;
      }
      if (nameChangeAmtChargesController.text.isNotEmpty) {
        nameChangeCharges = double.parse(nameChangeAmtChargesController.text);
      }
      if (regulatorDiscountAmountController.text.isNotEmpty) {
        discountAmount = double.parse(regulatorDiscountAmountController.text);
      }
      if (selectedBankName != null || selectedBankId != null) {
        if (selectedTransMode == null) {
          showFlushBar(context, "Select Transaction Mode.");
          return;
        }
      }

      if (selectedTranssvItemName == null) {
        showFlushBar(context, "Select Product.");
        return;
      }
      if (selectedTransacc == null) {
        showFlushBar(context, "Select SV Type.");
        return;
      }
      if ((selectedTranssvItemName == "14.2 KG" && !isExemptedReticulated) &&
          selectedTransacc != "Name Change") {
        if (selectedTranqty == null) {
          showFlushBar(context, "Select Cylinder Quantity.");
          return;
        }
      }
      if (selectedTranssvItemName != "14.2 KG" || isExemptedReticulated) {
        if (cylinderQtyAddController.text.isEmpty) {
          showFlushBar(context, "Enter Cylinder Quantity.");
          return;
        }
      }
      if (selectedTranssvItemName != "14.2 KG") {
        if (getSelectedFTLRegulatorQtyString == null) {
          showFlushBar(context, "Select FTL Regulator Quantity.");
          return;
        }
      }
      if (selectedTransacc != "Name Change") {
        if (depositCylinderAmountController.text.isEmpty) {
          showFlushBar(context, "Enter Cylinder Deposit Amount.");
          return;
        }
      }

      if (selectedTransacc != "DBC" && selectedTransacc != "Name Change") {
        if (regulatorDepositAmountController.text.isEmpty) {
          showFlushBar(context, "Enter Regulator Deposit Amount.");
          return;
        }
      }

      if (selectedTransacc == "Name Change") {
        if (nameChangeAmtChargesController.text.isEmpty) {
          showFlushBar(context, "Enter Name Change Amount.");
          return;
        }
      }

      // if(!invoiceAutoManualMandatory && invNoController.text.isEmpty){
      // if(isSVPending && !invoiceAutoManualMandatory || invoiceAutoManualMandatory && invNoController.text.isEmpty){
      if (isSVPending &&
          invoiceAutoManualMandatory &&
          invNoController.text.isEmpty) {
        showFlushBar(context, "Enter Invoice No");
        return;
      }

      if (!isSVPending && conNoController.text.isEmpty) {
        showFlushBar(context, "Enter Consumer Number.");
        return;
      }
      // if (conContactController.text.trim().isNotEmpty &&
      //     (_isInvalidMobile || _isShortLength)) {
      //   showFlushBar(context, "Please enter a valid contact number.");
      //   return;
      // }

      if (selectedTransMode == "Cash") {
        if (recPaymentController.text.isEmpty) {
          showFlushBar(context, "Enter Cash Receipt Payment.");
          return;
        }
      }
      if (selectedTransMode == "Merchant QR") {
        if (partialQRController.text.isEmpty) {
          showFlushBar(context, "Enter QR Receipt Payment.");
          return;
        }
      }
      if (selectedTransMode == null) {
        showFlushBar(context, "Select Transaction Mode.");
        return;
      }

      if (selectedTransMode == "Merchant QR" ||
          selectedTransMode == 'Partial') {
        if (partialQRController.text.isNotEmpty) {
          partialQRAmt = double.parse(partialQRController.text);
        }
      } else {
        partialQRAmt = 0.0;
      }

      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') {
        if (recPaymentController.text.isNotEmpty) {
          receiveAmt = double.parse(recPaymentController.text);
          dataCashDenomination = getNoteTypeAndIdFroDenominationListModel
              .asMap()
              .entries
              .map((entry) {
            int index = entry.key;
            var data = entry.value;
            return {
              "NoteId": data.id ?? 0,
              // Use null-aware operator to handle null values
              "NoteQty": qtyController[index].text.isNotEmpty
                  ? int.tryParse(qtyController[index].text)
                  : 0,
              "NoteAmt": amounts[index],
              "RetNoteQty": qtyControllerReturn[index].text.isNotEmpty
                  ? int.tryParse(qtyControllerReturn[index].text)
                  : 0,
              // Replace with actual value if available
              "RetNoteAmt": amountsReturn[index],
              // Replace with actual value if available
            };
          }).toList();
        }
      } else {
        receiveAmt = 0.0;
        dataCashDenomination = getNoteTypeAndIdFroDenominationListModel
            .asMap()
            .entries
            .map((entry) {
          int index = entry.key;
          var data = entry.value;
          return {
            "NoteId": data.id ?? 0,
            // Use null-aware operator to handle null values
            "NoteQty": 0,
            "NoteAmt": 0,
            "RetNoteQty": 0,
            // Replace with actual value if available
            "RetNoteAmt": 0,
            // Replace with actual value if available
          };
        }).toList();
      }

      if (selectedTransMode == "Merchant QR" ||
          selectedTransMode == "Partial") {
        if (selectedBankName == null || selectedBankId == null) {
          showFlushBar(context, "Select Account No");
          return;
        }

        if (TranCodeController.text.isEmpty) {
          showFlushBar(context, "Enter Transaction Code.");
          return;
        }
      }

      if (selectedTransMode == 'Merchant QR') {
        if (totalAmt != partialQRAmt) {
          showFlushBar(
              context, "QR Receipt Amount Should Be Equals To Total Amount.");
          return;
        }
      }

      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') {
        if (finalAmountCashDeno > 0) {
          if (finalAmountCashDeno != receiveAmt) {
            showFlushBar(context,
                "The Entered Cash Denomination Total Should Be Equal To Received Cash Amount.");
            return;
          }
        }
      }

      if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') {
        if (cashDenominationMandatory) {
          if (finalAmountCashDeno != null || finalAmountCashDeno > 0) {
            if (finalAmountCashDeno != receiveAmt) {
              showFlushBar(context, "Cash Denomination Is Mandetory.");
              return;
            }
          } else {
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }
      if (selectedTransMode == 'Cash') {
        tranCode = "";
        times = "";
        transRemark = "";
        selecteBankIDApi = 0;
        selectedBankName = "";
        selectedBankId = "0";
        accMappingId = 0;
      } else if (selectedTransMode == 'Merchant QR') {
        dataCashDenomination = [];
      }

      if (selectedTransMode == "Partial") {
        if (receiveAmt <= 0 ||
            partialQRAmt <= 0 ||
            (receiveAmt + partialQRAmt != totalAmt)) {
          String errorMessage = (receiveAmt <= 0 || partialQRAmt <= 0)
              ? "Both Cash Receipt Amount And QR Amount Should Be Greater Than Zero."
              : "The Entered Receipt Payment Amount Should Be Equal To Total Amount.";

          showFlushBar(context, errorMessage);
          return;
        }
      }

      if (selectedTransMode == "Cash") {
        if (receiveAmt != totalAmt) {
          showFlushBar(context,
              "The Entered Receipt Payment Amount Should Be Equal To Total Amount.");
          return;
        }
      }

      if (selectedTransMode == "Merchant QR") {
        payMode = "Bank";
      } else if (selectedTransMode == "Cash") {
        payMode = "Cash";
      } else if (selectedTransMode == 'Partial') {
        payMode = "Partial";
      } else {
        payMode = "";
      }
    }

    List<Map<String, dynamic>> itemDetails = [];

    for (var item in items) {
      int index = items.indexOf(item);
      String? selectedItemName = _selectedItems[index];

      // Skip empty rows (no item selected or quantity is 0)
      if (selectedItemName == null ||
          selectedItemName.isEmpty ||
          item['qty']?.text == '0') {
        continue; // Skip this iteration and go to the next row
      }

      // Find selected item details from the master list
      GetArbItemMasterListModel selectedItem = _items.firstWhere(
        (model) => model.itemName == selectedItemName,
        orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
      );

      int? currentStock =
          getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
      _itemStockByIndex[index] = currentStock;

      int itemId = selectedItem.itemId?.toInt() ?? 0;
      int qty = int.tryParse(item['qty']?.text ?? '0') ?? 0;

      // Debugging prints
      debugPrint("selectedItem.categoryName: ${selectedItem.categoryName}");
      debugPrint("qty: $qty");
      debugPrint("currentStock: $currentStock");

      // Check if the selected item is not a "Non ARB Item"
      if (selectedItem.categoryName != "Non ARB Item") {
        // Condition 1: Quantity must be greater than 0
        if (qty <= 0) {
          showFlushBar(context,
              "Quantity must be greater than 0 for item ${selectedItem.itemName}");
          return; // Exit the function immediately if the quantity is invalid
        }

        // Condition 2: Quantity must not exceed available stock
        if (qty > currentStock!) {
          showFlushBar(context,
              "Quantity exceeds available stock for item ${selectedItem.itemName}");
          return; // Exit the function immediately if the quantity exceeds stock
        }
      } else {
        if (qty <= 0) {
          showFlushBar(context,
              "Quantity must be greater than 0 for item ${selectedItem.itemName}");
          return; // Exit the function immediately if the quantity is invalid
        }
      }

      // Only add valid items to the list
      if (itemId > 0 && qty > 0) {
        itemDetails.add({
          'ItemId': selectedItem.itemId ?? '',
          'Rate': item['rate']?.text ?? '',
          'ItemQty': item['qty']?.text ?? '',
          'DiscountAmt': item['discount']?.text ?? '',
          'ARBAmount': item['amt']?.text ?? '',
        });
      }
    }

    if (selectedTranssvItemName == "14.2 KG") {
      if (selectedTransacc == "RC" || selectedTransacc == "NC") {
        if (itemDetails.isEmpty) {
          showFlushBar(context, "Add ARB Item.");
          return;
        }
      } else {
        if (itemDetails.isEmpty) {
          itemDetails.add({
            'ItemId': 0 ?? '',
            'Rate': '' ?? '',
            'ItemQty': '' ?? '',
            'DiscountAmt': '' ?? '',
            'ARBAmount': '' ?? '',
          });
        }
      }
    } else {
      if (itemDetails.isEmpty) {
        itemDetails.add({
          'ItemId': 0 ?? '',
          'Rate': '' ?? '',
          'ItemQty': '' ?? '',
          'DiscountAmt': '' ?? '',
          'ARBAmount': '' ?? '',
        });
      }
    }

    int? bankId;
    int? accMappingIds;
    if (selectedBankName != null) {
      bankId = selecteBankIDApi;
      accMappingIds = accMappingId;
    } else {
      bankId = 0;
      accMappingIds = 0;
    }
    int? isExpted;
    if (isExemptedReticulated == true) {
      debugPrint("isExemptedReticulated1 $isExemptedReticulated");
      isExpted = 1;
    } else if (isExemptedReticulated == false) {
      debugPrint("isExemptedReticulated0 $isExemptedReticulated");
      isExpted = 0;
    } else {}
    final Map<String, dynamic> requestBody = {
      "PSVId": psvID,
      "DistributorId": distributorIds,
      "SVDate": formattedDate,
      "ReferredById": selectedReferredID ?? '',
      "OtherName": selectedReferredName ?? '',
      "ProductId": selectedProductID ?? '',
      "ProductName": selectedTranssvItemName ?? '',
      "IsUndocument": isSVPending,
      "SvType": (selectedTransacc == "Name Change"
              ? "NameChange"
              : selectedTransacc) ??
          '',
      "CylQty": cylinderQty ?? '',
      "ScRegulator": scRegulators,
      "DepositCyl": cylDeposit,
      "CylRefillRSP": cylRefillRSP,
      "RegulatorDeposit": regDeposit,
      "StampDuty": stampD,
      "FtlRegulator": selectedFTLRegQty ?? 0,
      "BasicAmt": basicAmt,
      "ConsuDCNo": conDSNo ?? '',
      "ConsumerName": consName ?? '',
      "ConsuContactNo": conCont ?? '',
      "TotalAmount": totalAmt,
      "ReceiptAmt": receiveAmt,
      "QRReceiptAmt": partialQRAmt,
      "PaymentMode": payMode ?? '',
      "TransactionCode": tranCode ?? '',
      "TransactionTime": times ?? '',
      "TransactionRemark": transRemark ?? '',
      "AddedBy": userId,
      "Action": actionMode,
      "ItemId": 0,
      "ItemName": '',
      "Rate": '',
      "ItemQty": '',
      "DiscountAmt": arbTotalDiscount ?? '',
      "SVDiscountAmt": discountAmt ?? '',
      "ConsuAddress": conAddress ?? '',
      "InvoiceType": invoiceAutoManualMandatory ? "Auto" : "Manual",
      "InvoiceNo": invoiceNo ?? '',
      "ArbAmount": arbTotalAmount ?? '',
      "ItemDataList": itemDetails,
      "DenomDtList": dataCashDenomination,
      "AmtCharges": nameChangeCharges,
      "BankId": bankId,
      "BankMappingId": accMappingIds,
      "IsExemptReti": isExpted ?? '',
    };

    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PendingSVAddEdit_Mob}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    print(
        "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    print("Response UpdateSaleAddEditForMob: ${response.body}");
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
        Future.delayed(Duration(milliseconds: 300), () {
          if (actionMode == "DELETE") {
            EasyLoading.showToast(
              Constants.expenseSendMgrDelete,
              duration: const Duration(milliseconds: 3000),
            );
          } else if (actionMode == "EDIT") {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          } else {
            EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
          }
        });
        Navigator.pushNamed(
          context,
          SVSaleReportScreen.screenName,
          //arguments: 3, // This opens the third tab
        );
        setState(() {
          fetchItemSvAddEditList();
        });
      }
    } else {
      // Error response
      print(
          "Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
  }

  void calculateGrandTotalAmount() {
    // 1. Parse the fixed components
    double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
    double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
    double regulator =
        double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt =
        double.tryParse(regulatorDiscountAmountController.text) ?? 0;
    double nameChangeAmt =
        double.tryParse(nameChangeAmtChargesController.text) ?? 0;
    double fixedTotal = 0;
    if (selectedTransacc == "Name Change") {
      fixedTotal = nameChangeAmt;
    } else {
      fixedTotal = deposit + refill + regulator + stampDuty - discountAmt;
      print("Grand Total: $deposit $refill $regulator $stampDuty $discountAmt");
    }
    // 2. Sum up item amounts from the ListView
    double dynamicItemTotal = 0.0;
    double dynamicItemTotalD = 0.0;
    for (int i = 0; i < items.length; i++) {
      final amtText = items[i]['amt']?.text ?? '';
      final amt = double.tryParse(amtText) ?? 0.0;
      dynamicItemTotal += amt;
    }
    for (int i = 0; i < items.length; i++) {
      final amtTextD = items[i]['discount']?.text ?? '';
      final amtD = double.tryParse(amtTextD) ?? 0.0;
      dynamicItemTotalD += amtD;
    }
    // 3. Final total
    double grandTotal = fixedTotal + dynamicItemTotal;
    arbTotalAmount = dynamicItemTotal;
    arbTotalDiscount = dynamicItemTotalD;
    // 4. Update your final total somewhere (optional)
    print("Grand Total: $grandTotal");

    // Example: update a controller if needed
    totalAmountController.text = grandTotal.toStringAsFixed(2);
  }

  void calculateGrandTotalAmountDepositMinus() {
    // 1. Parse the fixed components
    double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
    double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
    double regulator =
        double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt =
        double.tryParse(regulatorDiscountAmountController.text) ?? 0;

    double fixedTotal =
        deposit + refill + regulator + stampDuty - discountAmt - regulator;

    // 2. Sum up item amounts from the ListView
    double dynamicItemTotal = 0.0;
    double dynamicItemTotalD = 0.0;
    for (int i = 0; i < items.length; i++) {
      final amtText = items[i]['amt']?.text ?? '';
      final amt = double.tryParse(amtText) ?? 0.0;
      dynamicItemTotal += amt;
    }

    for (int i = 0; i < items.length; i++) {
      final amtTextD = items[i]['discount']?.text ?? '';
      final amtD = double.tryParse(amtTextD) ?? 0.0;
      dynamicItemTotalD += amtD;
    }

    // 3. Final total
    double grandTotal = fixedTotal + dynamicItemTotal;
    arbTotalAmount = dynamicItemTotal;
    arbTotalDiscount = dynamicItemTotalD;
    // 4. Update your final total somewhere (optional)
    print("Grand Total: $grandTotal");

    // Example: update a controller if needed
    totalAmountController.text = grandTotal.toStringAsFixed(2);
  }

  void cancelAction() {
    selectedStaff = null;
    selectedMaster = null;
    selectedTransacc = null;
    selectedTransMode = null;
    _selectBankModel = null;
    selectedBankName = null;
    selectedBankId = null;
    selecteBankIDApi = 0;
    accMappingId = 0;
    _selectedIndex = 0;
    arbTotalAmount = 0;
    arbTotalDiscount = 0;
    stampDuty = 0;
    selectedTransMode = null;
    selectedTransacc = null;
    selectedTranssvItemName = null;
    selectedProductID = 0;
    selectedTranqty = null;
    cylinderQty = 0;
    depositAmount = 0;
    refillAmountCyl = 0;
    getRegulatorDepositAmountFromApi = 0;
    _isConsumerEmpty = false;
    _isConCOntactEmpty = false;
    _isInvalidMobile = false;
    _isShortLength = false;
    _isTranscode = false;
    amounts = [];
    amountsReturn = [];
    totalAmount = 0.0;
    returnAmount = 0.0;
    finalAmountCashDeno = 0.0;
    isQtyFilled = {};
    getSelectedFTLRegulatorQtyString = null;
    selectedFTLRegQty = 0;
    isCashDenominationListViewVisible = false;
    isSVPending = false;
    isExemptedReticulated = false;
    _selectedIndex = 0;
    arbTotalAmount = 0;
    stampDuty = 0;
    selectedReferredID = 0;
    selectedReferredName = null;
    conNameController.clear();
    conContactController.clear();
    conNoController.clear();
    recPaymentController.clear();
    stampDutyController.clear();
    TranCodeController.clear();
    timeController.clear();
    transReviewController.clear();
    rateController.clear();
    QtyController.clear();
    discountController.clear();
    amtController.clear();
    scRegulatorController.clear();
    depositCylinderAmountController.clear();
    refillCylinderAmountController.clear();
    regulatorDepositAmountController.clear();
    regulatorBasicAmountController.clear();
    regulatorDiscountAmountController.clear();
    cylinderQtyAddController.clear();
    totalAmountController.clear();
    nameChangeAmtChargesController.clear();
    Navigator.pop(context);
    Navigator.pushNamed(
        context, SVSaleReportScreen.screenName // This opens the third tab
        );
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
        debugPrint(
            "Response body GetPageActionPermissionDtls: ${response.body}");
        debugPrint(
            "Request body GetPageActionPermissionDtls: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
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
                print("Flag truet:");
                cashDenominationMandatory = true;
                break; // Exit loop after finding the match
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
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> CheckSVConsumerNoStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    String? conDSNo;

    if (selectedTranssvItemName == null) {
      showFlushBar(context, "Select Product.");
      return;
    }

    if (selectedTransacc == null) {
      showFlushBar(context, "Select SV Type.");
      return;
    }

    if (conNoController.text.isNotEmpty) {
      conDSNo = conNoController.text;
    }

    final Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "ConsumerNo": conDSNo ?? '',
      "ItemId": selectedProductID ?? '',
      "SVType": selectedTransacc ?? '',
    };
    print("CheckSVConsumerNoStatus: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.CheckSVConsumerNoStatus}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody CheckSVConsumerNoStatus: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      if (response.body == '0') {
        print("Success ${response.body}");

        // EasyLoading.showToast("Save Con. No Successfully", duration: const Duration(milliseconds: 3000));
      } else if (response.body == '-1') {
        print(
            "API Response: -1 (Consumer No exists with same SV type and delivered)");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red), // Add the icon here
                  SizedBox(width: 8), // Space between icon and text
                  Text('Consumer/DC No Not Allowed'),
                ],
              ),
              content: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Entered consumer dc no is already exists with same SV type and delivered also, please check and re-enter",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    conNoController.clear();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.body == '-2') {
        print("API Response: -2 (Consumer No exists with same SV type)");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red), // Add the icon here
                  SizedBox(width: 8), // Space between icon and text
                  Text('Consumer DC No Not Allowed'),
                ],
              ),
              content: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Entered consumer dc no is already exists with same SV type, please check and re-enter",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    conNoController.clear();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        EasyLoading.showToast("Something went wrong. Please try again.",
            duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      }
    } else {
      print(
          "Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.",
          duration: const Duration(milliseconds: 3000));
    }
  }

  double remainingAmount = 0.0;

  void updateRemainingAmount() {
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
    double qrAmount = double.tryParse(partialQRController.text) ?? 0.0;
    double cashAmount = double.tryParse(recPaymentController.text) ?? 0.0;

    setState(() {
      if (isEditingQR) {
        remainingAmount = totalAmount - qrAmount;
        if (remainingAmount < 0) remainingAmount = 0.0;
        recPaymentController.text = remainingAmount.toStringAsFixed(2);
      } else if (isEditingCash) {
        remainingAmount = totalAmount - cashAmount;
        if (remainingAmount < 0) remainingAmount = 0.0;
        partialQRController.text = remainingAmount.toStringAsFixed(2);
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

      // setState(() {
      //   isLoading = false;
      //   //
      //   // if (autoInvoiceItem.invoiceType == "Auto" &&
      //   //     autoInvoiceItem.fromInvoiceNo != null) {
      //   //   invoiceAutoManualMandatory = true;
      //   //   invNoController.text =
      //   //       autoInvoiceItem.fromInvoiceNo.toString();
      //   //   _isInvoiceEmpty = false;
      //   // }
      //   if (autoInvoiceItem.invoiceType == "Auto") {
      //     invoiceAutoManualMandatory = true;
      //
      //     // ðŸ”¥ CALL INVOICE GENERATE API HERE
      //     getInvoiceGenerateNewNoForSVSale("Auto");
      //   }else {
      //     invoiceAutoManualMandatory = false;
      //     invNoController.clear();
      //   }
      // });
      setState(() {
        isLoading = false;

        if (autoInvoiceItem.invoiceType == "Auto") {
          invoiceAutoManualMandatory = true;
        } else {
          invoiceAutoManualMandatory = false;
          invNoController.clear();
        }
      });

      if (autoInvoiceItem.invoiceType == "Auto") {
        getInvoiceGenerateNewNoForSVSale("Auto");
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error111: $e");
    }
  }

  // Future<void> getInvoiceGenerateNewNoForSVSale(String invType) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken = prefs.getString('token');
  //
  //     if (bearerToken == null) {
  //       throw Exception("Token missing");
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.InvoiceGenerateNewNoForSVSale}/$distributorId/$invType'),
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
  //     final data = json.decode(response.body);
  //
  //     debugPrint("Generated Invoice: $data");
  //
  //     setState(() {
  //       invNoController.text = data['invoiceNo'].toString();
  //       _isInvoiceEmpty = false;
  //       invoiceAutoManualMandatory = true;
  //     });
  //   } catch (e) {
  //     debugPrint("Invoice Generate Error: $e");
  //     showFlushBar(context, "Unable to generate invoice number");
  //   }
  // }

  Future<void> getInvoiceGenerateNewNoForSVSale(String invType) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null || distributorId == null) {
        throw Exception("Token or DistributorId missing");
      }

      final response = await http.get(
        Uri.parse(
          '${AppUrl.InvoiceGenerateNewNoForSVSale}/$distributorId/$invType',
        ),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate invoice number');
      }

      // âœ… API RETURNS PLAIN VALUE (e.g. 90008)
      final invoiceNo = response.body.replaceAll('"', '');

      debugPrint("Generated Invoice: $invoiceNo");

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
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../newTheam/core/theme/app_colors.dart';
// import '../ConstantScreen/widgets.dart';
// import '../Utils/CustomAppBarManager.dart';
// import '../Utils/Styling.dart';
// import '../Utils/Widget.dart';
// import '../Utils/app_url.dart';
// import '../Utils/constants.dart';
// import 'BootomNavigatinBarManager.dart';
// import 'CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
// import 'CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
// import 'ManagerModelClass/DenomModel.dart';
// import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
// import 'ManagerSingleItemUI/SVSaleReportScreenUI.dart';
// import 'SVSaleModel/GetARBItemMasterListModel.dart';
// import 'SVSaleModel/GetAddEditDataSvSaleItemModel.dart';
// import 'SVSaleModel/GetArbCurrentStockListModel.dart';
// import 'SVSaleModel/GetDenominationListForAddEdit.dart';
// import 'SVSaleModel/GetDistStampDutyModel.dart';
// import 'SVSaleModel/GetItemMasterListModel.dart';
// import 'SVSaleModel/GetRSPDetailsListModel.dart';
// import 'SVSaleModel/GetStaffDetailsListModel.dart';
//
// class SVSaleReportScreen extends StatefulWidget {
//   static const screenName = '/svSaleReportScreen';
//
//   const SVSaleReportScreen({super.key});
//
//   @override
//   State<SVSaleReportScreen> createState() => _SVSaleReportScreen();
// }
//
// class _SVSaleReportScreen extends State<SVSaleReportScreen> {
//   List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
//   List<dynamic> dataCashDenominationList = [];
//   List<TextEditingController> qtyController = [];
//   List<TextEditingController> qtyControllerReturn = [];
//   List<GetStaffDetailsListModel> staffdetailsmodel = [];
//   GetStaffDetailsListModel? selectedStaff;
//   int? selectedReferredID;
//   String? selectedReferredName;
//   List<GetItemMasterListModel> masterListModel = [];
//   GetItemMasterListModel? selectedMaster;
//   List<GetDistStampDutyModel> getDistStampDutyModel = [];
//   List<GetBankMappingDetailsListModel> bankModel = [];
//   GetBankMappingDetailsListModel? _selectBankModel;
//   List<GetArbCurrentStockListModel> svcStock = [];
//   GetArbCurrentStockListModel? _selectStockModel;
//   List<GetArbItemMasterListModel> svstockmaster = [];
//   GetArbItemMasterListModel? _svstockmaster;
//   String? selectedBankName;
//   String? selectedBankId;
//   int? selecteBankIDApi;
//   int? accMappingId;
//   final conNameController = TextEditingController();
//   final conContactController = TextEditingController();
//   final conNoController = TextEditingController();
//   final recPaymentController = TextEditingController();
//   final stampDutyController = TextEditingController();
//   final TranCodeController = TextEditingController();
//   final partialQRController = TextEditingController();
//   final timeController = TextEditingController();
//   final transReviewController = TextEditingController();
//   final rateController = TextEditingController();
//   final QtyController = TextEditingController();
//   final discountController = TextEditingController();
//   final amtController = TextEditingController();
//   final scRegulatorController = TextEditingController(text: "1");
//   final depositCylinderAmountController = TextEditingController();
//   final refillCylinderAmountController = TextEditingController();
//   final regulatorDepositAmountController = TextEditingController();
//   final regulatorBasicAmountController = TextEditingController();
//   final regulatorDiscountAmountController = TextEditingController();
//   final cylinderQtyAddController = TextEditingController();
//   final totalAmountController = TextEditingController();
//   final nameChangeAmtChargesController = TextEditingController();
//   String? previousRegulatorDepositAmount;
//   int _selectedIndex = 0;
//   double? arbTotalAmount;
//   double? arbTotalDiscount;
//   double? stampDuty;
//   final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey7 = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey8 = GlobalKey<FormState>();
//   bool isCashDenominationListViewVisible = false;
//   bool isSVPending = false;
//   bool isExemptedReticulated = false;
//   String? selectedTransMode;
//   String? selectedTransacc;
//   String? selectedTranssvItemName;
//   int? selectedProductID;
//   String? selectedTranqty;
//   int? cylinderQty;
//   double? depositAmount;
//   double? refillAmountCyl;
//   double? getRegulatorDepositAmountFromApi;
//   bool _isConsumerEmpty = false;
//   bool _isConCOntactEmpty = false;
//   bool _isInvalidMobile = false;
//   bool _isShortLength = false;
//   bool _isTranscode = false;
//   bool _iscashcode = false;
//   bool _isQRcode = false;
//   List<double> amounts = [];
//   List<double> amountsReturn = [];
//   bool isLoading = true;
//   double totalAmount = 0.0;
//   double returnAmount = 0.0;
//   double finalAmountCashDeno = 0.0;
//   Map<int, bool> isQtyFilled = {};
//   List<String> getTransMode = ["Cash", "Merchant QR", "Partial"];
//   List<GetAddEditDataSvSaleItemModel> receiptList = [];
//   List<GetDenominationListForAddEdit> getDenominationLis = [];
//   List<String> getTransacc = ["NC", "RC", "DBC", "Name Change"];
//   List<String> getTransqty = ["1", "2"];
//   List<String> getSelectedFTLRegulatorQty = ["0", "1"];
//   String? getSelectedFTLRegulatorQtyString;
//   int? selectedFTLRegQty;
//   List<Map<String, TextEditingController>> items = [];
//   int? arbCurrentStock;
//   Map<int, int?> _itemStockByIndex = {};
//   Map<int, int?> _selectedItemIds = {};
//   Map<int, String?> _selectedCategoryName = {};
//   List<GetArbItemMasterListModel> _items = [];
//   Map<int, String?> _selectedItems = {};
//   List<GetRspDetailsListModel> getrsplistmodel = [];
//   Map<int, String?> _getrsplistitems = {};
//
//   var argValue;
//   String? modes;
//   int? psvIdEdit;
//   bool saveFlag = false;
//   List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
//   bool cashDenominationMandatory = false;
//   List<FocusNode> _discountFocusNodes = [];
//   List<FocusNode> _dropdownFocusNodes = [];
//   late FocusNode _conNoFocusNode;
//   bool _isInitComplete = false; // This avoids API call during initState prefill
//   bool isEditingQR = false;
//   bool isEditingCash = false;
//   List<CahsDenominationMandatoryFlagModel> autoMnualList = [];
//   bool invoiceAutoManualMandatory = false;
//   late final invNoController = TextEditingController();
//   bool _isInvoiceEmpty = false;
//   final conAddNoController = TextEditingController();
//   bool _isEditingExistingConsumerNo = false;
//   bool _isInvoiceEditable = false;
//   bool isCashDenominationChecked = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _conNoFocusNode = FocusNode();
//     _conNoFocusNode.addListener(() {
//       if (!_conNoFocusNode.hasFocus && _isInitComplete) {
//         final value = conNoController.text.trim();
//
//         if (value.isNotEmpty) {
//           if (selectedMaster == null) {
//             conNoController.clear();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Please select product before entering Consumer No./DC No.')),
//             );
//           } else if (selectedTransacc == null) {
//             conNoController.clear();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Please select SV type before entering Consumer No./DC No.')),
//             );
//           } else {
//             // âœ… Only call API if this is a new input, not an existing saved value
//             if (!_isEditingExistingConsumerNo) {
//               CheckSVConsumerNoStatus();
//             }
//           }
//         }
//       }
//     });
//
//
//     checkAndSaveDayEndData();
//     checkCashDenominationFlagMandatory();
//     InvoiceAutoManualFlagMandatory();
//     _addNewItem();
//     getNoteTypeAndIDList();
//     getStaffDetailsList();
//     getItemMasterList();
//     getDistStampDuty();
//     fetchBank();
//     getArbCurrentStockList();
//     getArbItemMasterListModel();
//     getRspDetailsListModel();
//     fetchItemSvAddEditList();
//
//     Future.delayed(Duration.zero, ()  async {
//       argValue = ModalRoute.of(context)?.settings.arguments as Map?;
//       modes = argValue?["modeChange"] ?? '';
//       if (argValue != null) {
//         final itemsToShow = argValue["itemsToShow"] ?? [];
//         psvIdEdit = int.tryParse(argValue["psvIDV"] ?? 0);
//         String sVDateEdit = argValue["sVDateV"] ?? 0;
//         String referredByIdEdit = argValue["referredByIdV"] ?? 0;
//         String referredByNameEdit = argValue["referredByNameV"] ?? 0;
//         String otherNameEdit = argValue["otherNameV"] ?? 0;
//         String productIdEdit = argValue["productIdV"] ?? 0;
//         String productNameEdit = argValue["productNameV"] ?? 0;
//         String isUndocumentEdit = argValue["isUndocumentV"] ?? 0;
//         String sVTypeEdit = argValue["sVTypeV"] ?? 0;
//         String cylQtyEdit = argValue["cylQtyV"] ?? 0;
//         String sCRegulatorEdit = argValue["sCRegulatorV"] ?? 0;
//         String depositCylEdit = argValue["depositCylV"] ?? 0;
//         String cylRefillRSPEdit = argValue["cylRefillRSPV"] ?? 0;
//         String regulatorDepositEdit = argValue["regulatorDepositV"] ?? 0;
//         String stampDutyEdit = argValue["stampDutyV"] ?? 0;
//         String fTLRegulatorEdit = argValue["fTLRegulatorV"] ?? 0;
//         String basicAmtEdit = argValue["basicAmtV"] ?? 0;
//         String consuDCNoEdit = argValue["consuDCNoV"] ?? 0;
//         String consumerNameEdit = argValue["consumerNameV"] ?? 0;
//         String consuContactNoEdit = argValue["consuContactNoV"] ?? 0;
//         String totalAmountEdit = argValue["totalAmountV"] ?? 0;
//         String partialQREdit = argValue["partialQRV"] ?? 0;
//         String receiptAmtEdit = argValue["receiptAmtV"] ?? 0;
//         String paymentModeEdit = argValue["paymentModeV"] ?? 0;
//         String transactionCodeEdit = argValue["transactionCodeV"] ?? 0;
//         String transactionTimeEdit = argValue["transactionTimeV"] ?? 0;
//         String transactionRemarkEdit = argValue["transactionRemarkV"] ?? 0;
//         String addedByEdit = argValue["addedByV"] ?? 0;
//         String actionEdit = argValue["actionV"] ?? 0;
//         String itemIdEdit = argValue["itemIdV"] ?? 0;
//         String itemNameEdit = argValue["itemNameV"] ?? 0;
//         String rateEdit = argValue["rateV"] ?? 0;
//         String itemQtyEdit = argValue["itemQtyV"] ?? 0;
//         String discountAmtEdit = argValue["discountAmtV"] ?? 0;
//         String aRBAmountEdit = argValue["aRBAmountV"] ?? 0;
//         String amtChargesEdit = argValue["amtChargesV"] ?? 0;
//         String categoryNameEdit = argValue["categoryNameV"] ?? 0;
//         String bankIdEdit = argValue["bankIdV"] ?? 0;
//         String bankMappingIdEdit = argValue["bankMappingIdV"] ?? 0;
//         String accountNoEdit = argValue["accountNoV"] ?? 0;
//         String bankNameEdit = argValue["bankNameV"] ?? 0;
//         String isExemptRetiEdit = argValue["isExemptRetiV"] ?? 0;
//         String sVDiscountAmtEdit = argValue["sVDiscountAmtV"] ?? 0;
//         String InvoiceNoEdit = argValue["invoiceNumberV"]?.toString() ?? '';
//         String InvoiceTypeEdit = argValue["invoiceTypeV"] ?? 0;
//         String consumerAddressEdit = argValue["consumerAddressV"] ?? 0;
//
//         // invoiceAutoManualMandatory = InvoiceTypeEdit == "Auto";
//
//         selectedProductID = int.parse(productIdEdit);
//         cylinderQty = int.parse(cylQtyEdit);
//
//         depositCylinderAmountController.text = depositCylEdit;
//         refillCylinderAmountController.text = cylRefillRSPEdit;
//         depositAmount = double.tryParse(depositCylEdit);
//         refillAmountCyl = double.tryParse(cylRefillRSPEdit);
//         debugPrint("regulatorDepositEdit $regulatorDepositEdit");
//         if(regulatorDepositEdit.isEmpty || regulatorDepositEdit == null || regulatorDepositEdit == "null"){
//           regulatorDepositAmountController.text = "0";
//         }else{
//           regulatorDepositAmountController.text = regulatorDepositEdit;
//         }
//
//         stampDutyController.text = stampDutyEdit;
//         regulatorDiscountAmountController.text = sVDiscountAmtEdit;
//         regulatorBasicAmountController.text = basicAmtEdit;
//         // conNoController.text = consuDCNoEdit;
//         if (consuDCNoEdit.isNotEmpty && consuDCNoEdit != "null") {
//           conNoController.text = consuDCNoEdit;
//           _isEditingExistingConsumerNo = true; // mark existing record
//         }
//         conNameController.text = consumerNameEdit;
//         conContactController.text = consuContactNoEdit;
//         recPaymentController.text = receiptAmtEdit;
//         TranCodeController.text = transactionCodeEdit;
//         timeController.text = transactionTimeEdit;
//         transReviewController.text = transactionRemarkEdit;
//         totalAmountController.text = totalAmountEdit;
//         partialQRController.text = partialQREdit;
//
//
//         if (getTransMode.contains(paymentModeEdit)) {
//           selectedTransMode = paymentModeEdit;
//         } else if(paymentModeEdit == "Bank") {
//           selectedTransMode = 'Merchant QR';// fallback or handle invalid values
//         }else{
//           selectedTransMode = null;
//         }
//         await getStaffDetailsList();
//         getStaffDetailsList().whenComplete((){
//           debugPrint("referredByNameEdit:$referredByNameEdit");
//           if(referredByNameEdit != "null" && referredByNameEdit.isNotEmpty && referredByNameEdit != null){
//             setState(() {
//               selectedStaff = staffdetailsmodel.firstWhere(
//                     (item) => item.staffName == referredByNameEdit,
//                 orElse: () => GetStaffDetailsListModel(staffName: ''),
//               );
//               selectedReferredID = int.parse(referredByIdEdit);
//               selectedReferredName = referredByNameEdit;
//               // invNoController.text = InvoiceNoEdit;
//
//
//               final bool isExistingInvoice = InvoiceNoEdit.isNotEmpty &&
//                   InvoiceNoEdit != "0" &&
//                   InvoiceNoEdit != "null";
//
//               if (isExistingInvoice) {
//                 invNoController.text = InvoiceNoEdit;
//                 invoiceAutoManualMandatory = InvoiceTypeEdit == "Auto";
//               } else if (InvoiceTypeEdit == "Manual") {
//                 // Manual record but no invoice saved
//                 invNoController.clear();
//                 invoiceAutoManualMandatory = false; // keep editable
//               } else {
//                 // New record, follow API auto/manual
//                 invNoController.clear();
//                 invoiceAutoManualMandatory = false;
//                 InvoiceAutoManualFlagMandatory();
//               }
//
//
//               conAddNoController.text = consumerAddressEdit;
//             }
//             );
//           }
//         });
//
//         await fetchBank(); // wait for data first
//         if (accountNoEdit.isNotEmpty && accountNoEdit != "null") {
//           final match = bankModel.firstWhere(
//                 (item) => item.accountNo?.trim() == accountNoEdit.trim(),
//             orElse: () => GetBankMappingDetailsListModel(), // fallback empty object
//           );
//
//           // Only set if a valid match found
//           if ((match.accountNo ?? '').isNotEmpty) {
//             setState(() {
//               _selectBankModel = match;
//               selectedBankName = match.bankName;
//               selectedBankId = match.accountNo;
//               selecteBankIDApi = match.bankId?.toInt();
//               accMappingId = match.mappingId?.toInt();
//             });
//           }
//         }
//         // await getItemMasterList();
//         getItemMasterList().whenComplete((){
//           debugPrint("productNameEdit:$productNameEdit");
//           if(productNameEdit != "null" && productNameEdit.isNotEmpty && productNameEdit != null){
//             setState(() {
//               selectedMaster = masterListModel.firstWhere(
//                     (item) => item.itemName == productNameEdit,
//                 orElse: () => GetItemMasterListModel(itemId: 0, itemName: ''),
//               );
//               selectedTranssvItemName = productNameEdit;
//             });
//           }
//         });
//         if(isUndocumentEdit == "true"){
//           isSVPending = true;
//         }else{
//           isSVPending =  false;
//         }
//         debugPrint("isExemptRetiEdit$isExemptRetiEdit");
//         if(isExemptRetiEdit == "1"){
//           isExemptedReticulated = true;
//           debugPrint("isExemptRetiEdittrue");
//         }else{
//           isExemptedReticulated =  false;
//           debugPrint("isExemptRetiEditfalse");
//         }
//
//         if (getTransacc.contains(sVTypeEdit)) {
//           selectedTransacc = sVTypeEdit;
//         } else if(sVTypeEdit == "NameChange"){
//           selectedTransacc = "Name Change";
//           nameChangeAmtChargesController.text = amtChargesEdit;
//         } else {
//           selectedTransacc = null; // fallback or handle invalid values
//         }
//         debugPrint("selectedTranqty $cylQtyEdit");
//         if(productNameEdit != "14.2 KG" || isExemptRetiEdit == "1"){
//           cylinderQtyAddController.text = cylQtyEdit;
//           debugPrint("cylinderQtyAddController.text $cylQtyEdit");
//         }else{
//           if (getTransqty.contains(cylQtyEdit)) {
//             selectedTranqty = cylQtyEdit;
//             debugPrint("selectedTranqty $cylQtyEdit");
//           } else {
//             selectedTranqty = null;
//             debugPrint("selectedTranqty1 $cylQtyEdit");// fallback or handle invalid values
//           }
//         }
//         debugPrint("fTLRegulatorEdit $fTLRegulatorEdit");
//         if (getSelectedFTLRegulatorQty.contains(fTLRegulatorEdit)) {
//           getSelectedFTLRegulatorQtyString = fTLRegulatorEdit;
//         } else {
//           getSelectedFTLRegulatorQtyString = null; // fallback or handle invalid values
//         }
//
//         loadDenominationData(psvIdEdit!);
//         // _initializeItems(itemsToShow);
//         if (itemsToShow.isNotEmpty) {
//           _initializeItems(itemsToShow);
//         } else {
//           // If no initial data, start with an empty list or default values
//           _initializeItems([]);
//         }
//         if(getDenominationLis.isNotEmpty){
//           initializeControllers();
//         }else{
//           debugPrint("empty");
//         }
//       }
//       _isInitComplete = true;
//     });
//   }
//
//   final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//
//   // â”€â”€ UI helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//
//   InputDecoration _fDeco(String? label, {String? error}) => InputDecoration(
//     labelText: label,
//     labelStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
//     filled: true,
//     fillColor: AppColors.bg,
//     errorText: error,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
//     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
//     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blue, width: 1.5)),
//     errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.red)),
//     disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
//   );
//
//   Widget _svSectionHeader(String title, Color dotColor) => Padding(
//     padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
//     child: Row(children: [
//       Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, borderRadius: BorderRadius.circular(2))),
//       const SizedBox(width: 8),
//       Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8)),
//     ]),
//   );
//
//   Widget _svCard(List<Widget> children) => Container(
//     margin: const EdgeInsets.only(bottom: 10),
//     padding: const EdgeInsets.all(18),
//     decoration: BoxDecoration(
//       color: AppColors.white,
//       borderRadius: BorderRadius.circular(18),
//       boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))],
//     ),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
//   );
//
//   Widget _svLabelRow({required String label, required Widget child}) => Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: Row(children: [
//       Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMid))),
//       Expanded(child: child),
//     ]),
//   );
//
//   Widget _receiptInfoRow(String l1, String v1, String l2, String v2) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 3),
//     child: Row(children: [
//       Expanded(child: Row(children: [
//         Text('$l1: ', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
//         Flexible(child: Text(v1, style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600))),
//       ])),
//       Expanded(child: Row(children: [
//         Text('$l2: ', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
//         Flexible(child: Text(v2, style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600))),
//       ])),
//     ]),
//   );
//   @override
//   void dispose() {
//     for (var node in _discountFocusNodes) {
//       node.dispose();
//     }
//     for (var node in _dropdownFocusNodes) {
//       node.dispose();
//     }
//     _conNoFocusNode.dispose();
//     super.dispose();
//   }
//
//   void _addNewItem() {
//     _discountFocusNodes.add(FocusNode());
//     _dropdownFocusNodes.add(FocusNode());
//     // Check if there are existing items
//     if (items.isNotEmpty) {
//       // Get the last added item
//
//       var lastItem = items.last;
//
//       // Extract and validate each controller's value
//       String? rate = lastItem['rate']?.text.trim();
//       String? qty = lastItem['qty']?.text.trim();
//       String? discount = lastItem['discount']?.text.trim();
//       String? amt = lastItem['amt']?.text.trim();
//
//       if (rate!.isEmpty || qty!.isEmpty || amt!.isEmpty) {
//         // Show a warning/toast/snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please fill all fields before adding a new item.')),
//         );
//         return;
//       }
//     }
//
//     // Add a new item if previous one is valid or if it's the first item
//     setState(() {
//       int newIndex = items.length;
//       items.add({
//         'selectItem':TextEditingController(),
//         'rate': TextEditingController(),
//         'qty': TextEditingController(),
//         'discount': TextEditingController(),
//         'amt': TextEditingController(),
//       });
//       _selectedItems[newIndex] = null;
//     });
//   }
//
//   void _removeItem(int index) {
//     setState(() {
//       // Debugging: Print before removing
//       print('Removing item at index: $index');
//       print('Selected Items Before: $_selectedItems');
//
//       // Dispose the TextEditingController instances associated with the index
//       items[index]['rate']?.dispose();
//       items[index]['qty']?.dispose();
//       items[index]['discount']?.dispose();
//       items[index]['amt']?.dispose();
//
//       items.removeAt(index);
//
//       _selectedItems.remove(index);
//       _selectedItems = Map.fromEntries(
//         _selectedItems.entries.map((entry) {
//           return entry.key > index
//               ? MapEntry(entry.key - 1,
//               entry.value) // Shift keys down after the removed index
//               : entry;
//         }),
//       );
//       calculateGrandTotalAmount();
//       // Debugging: Print after removing
//       print('Selected Items After: $_selectedItems');
//     });
//   }
//
//   bool get _isAddNewItemEnabled {
//     // Check if there are any available items that haven't been selected yet
//     return _items.any((item) => !_selectedItems.values.contains(item.itemName));
//   }
//
//   void _initializeItems(List<ItemDetails> itemsToShow) {
//     setState(() {
//       items.clear(); // Clear any existing data
//       _selectedItems.clear(); // Clear previous selections if any
//       _discountFocusNodes.add(FocusNode());
//       _dropdownFocusNodes.add(FocusNode());
//       for (var i = 0; i < itemsToShow.length; i++) {
//         var item = itemsToShow[i];
//
//         // Add the item with controllers for each field
//         items.add({
//           'selectItem': TextEditingController(text: item.itemName ?? ''),
//           'rate':
//           TextEditingController(text: item.rate?.toString() ?? ''),
//           'qty': TextEditingController(text: item.itemQty?.toString() ?? ''),
//           'discount': TextEditingController(text: item.discountAmt?.toString() ?? ''),
//           'amt': TextEditingController(text: item.aRBAmount?.toString() ?? ''),
//         });
//
//         // Directly assign the selected item name for this index in _selectedItems map
//         _selectedItems[items.length - 1] = item.itemName ??
//             ''; // Ensure this is added correctly for each index
//         _discountFocusNodes.add(FocusNode());
//         _dropdownFocusNodes.add(FocusNode());
//       }
//
//       // Debugging step to check the number of items
//       print('Items Count: ${items.length}');
//       print('Selected Items: $_selectedItems');
//     });
//   }
//   @override
//   @override
//   Widget build(BuildContext context) {
//     final double halfWidth = (MediaQuery.of(context).size.width - 56) / 2;
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.bg2,
//         appBar: CustomAppBarManager(title: 'SV Sale'),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _svSectionHeader('Basic Info', AppColors.blueLight),
//                 _svCard([
//                   Row(children: [
//                     Expanded(child: Text('SV Date', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMid))),
//                     Expanded(child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                       decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
//                       child: Text(formattedDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.blue)),
//                     )),
//                   ]),
//                   const SizedBox(height: 12),
//                   _svLabelRow(label: 'Referred By', child: DropdownButtonFormField<GetStaffDetailsListModel>(
//                     key: formKey1,
//                     value: staffdetailsmodel.contains(selectedStaff) ? selectedStaff : null,
//                     decoration: _fDeco(null),
//                     items: staffdetailsmodel.map((s) => DropdownMenuItem(value: s, child: Text(s.staffName ?? ''))).toList(),
//                     onChanged: (value) { setState(() { selectedStaff = value; selectedReferredID = value?.staffId!.toInt(); selectedReferredName = value?.staffName!.toString(); }); },
//                     isExpanded: true,
//                   )),
//                   _svLabelRow(label: 'Select Product *', child: DropdownButtonFormField<GetItemMasterListModel>(
//                     key: formKey2,
//                     value: masterListModel.contains(selectedMaster) ? selectedMaster : null,
//                     decoration: _fDeco(null),
//                     items: masterListModel.map((s) => DropdownMenuItem(value: s, child: Text(s.itemName ?? ''))).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedMaster = value!; selectedTranssvItemName = selectedMaster?.itemName; selectedProductID = selectedMaster?.itemId?.toInt();
//                         int? itemIds = selectedMaster?.itemId?.toInt();
//                         depositAmount = getDepositAmountByItemId(itemIds)?.toDouble(); refillAmountCyl = getRefillAmountByItemId(itemIds)?.toDouble();
//                         depositCylinderAmountController.text = depositAmount.toString(); refillCylinderAmountController.text = refillAmountCyl.toString();
//                         if (selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM") { selectedTransacc = "NC"; } else { selectedTransacc = null; }
//                         items.clear(); _selectedItems.clear(); _itemStockByIndex.clear(); _selectedItemIds.clear();
//                         _addNewItem(); cylinderQtyAddController.clear(); selectedTranqty = null;
//                         if (modes == "Edit") { getRegulatorDepositAmountFromApi = getRefillAmountByItemName("SC REGULATOR")?.toDouble(); calculateBasicAmountSum(); calculateGrandTotalAmount(); }
//                         else { calculateBasicAmountSum(); calculateGrandTotalAmount(); regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString(); }
//                       });
//                     }, isExpanded: true,
//                   )),
//                   _svLabelRow(label: 'SV Type *', child: DropdownButtonFormField<String>(
//                     key: formKey5,
//                     value: selectedTransacc ?? ((selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM") ? "NC" : null),
//                     decoration: _fDeco(null),
//                     items: getTransacc.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
//                     onChanged: (selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM") ? null : (value) {
//                       setState(() {
//                         if (selectedTransacc != value && conNoController.text.isNotEmpty) { conNoController.clear(); FocusScope.of(context).unfocus(); }
//                         selectedTransacc = value; calculateBasicAmountSum(); calculateGrandTotalAmount();
//                         if (selectedTransacc == "RC") { regulatorDepositAmountController.text = ''; depositCylinderAmountController.text = ''; refillCylinderAmountController.text = (refillAmountCyl! * 1).toString(); calculateBasicAmountSum(); calculateGrandTotalAmount(); }
//                         else if (selectedTransacc == "Name Change") { regulatorDepositAmountController.text = ''; depositCylinderAmountController.text = ''; refillCylinderAmountController.text = '0'; calculateBasicAmountSum(); calculateGrandTotalAmount(); }
//                         else {
//                           if (selectedTransacc == "DBC") { depositCylinderAmountController.text = depositAmount.toString(); regulatorDepositAmountController.text = ''; selectedTranqty = "1"; cylinderQty = 1; refillCylinderAmountController.text = (refillAmountCyl! * 1).toString(); calculateBasicAmountSum(); calculateGrandTotalAmount(); }
//                           if (modes == "Edit") { depositAmount = getDepositAmountByItemId(selectedProductID)?.toDouble(); depositCylinderAmountController.text = depositAmount.toString(); getRegulatorDepositAmountFromApi = getRefillAmountByItemName("SC REGULATOR")?.toDouble(); regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString(); }
//                           depositCylinderAmountController.text = depositAmount.toString(); regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
//                         }
//                       });
//                     }, isExpanded: true,
//                   )),
//                 ]),
//                 if (selectedTransacc == "NC" || selectedTransacc == "RC" || selectedTransacc == "DBC") ...[
//                   _svSectionHeader('Cylinder Details', AppColors.teal),
//                   _svCard([
//                     if (selectedTransacc != "RC" && selectedTransacc != "DBC")
//                       Row(children: [
//                         Checkbox(value: isSVPending, activeColor: AppColors.blue, onChanged: (v) { setState(() { isSVPending = v ?? false; if (isSVPending) { if (invoiceAutoManualMandatory) { conNoController.clear(); _isConsumerEmpty = false; } } else { if (!invoiceAutoManualMandatory) { invNoController.clear(); _isInvoiceEmpty = false; } } }); }),
//                         const Text('SV Pending', style: TextStyle(color: AppColors.textMid, fontWeight: FontWeight.w500)),
//                         if ((selectedTransacc != "RC" && selectedTransacc != "DBC") && selectedTranssvItemName == "14.2 KG") ...[
//                           Checkbox(value: isExemptedReticulated, activeColor: AppColors.blue, onChanged: (v) { setState(() { isExemptedReticulated = v!; if (isExemptedReticulated) { previousRegulatorDepositAmount = regulatorDepositAmountController.text; regulatorDepositAmountController.text = "0"; } else { regulatorDepositAmountController.text = previousRegulatorDepositAmount ?? "0"; } }); }),
//                           const Text('Exempted/Reticulated', style: TextStyle(color: AppColors.textMid, fontWeight: FontWeight.w500)),
//                         ],
//                       ]),
//                     const SizedBox(height: 8),
//                     Wrap(spacing: 12, runSpacing: 12, children: [
//                       if (selectedTranssvItemName == "14.2 KG" && !isExemptedReticulated)
//                         SizedBox(width: halfWidth, child: DropdownButtonFormField<String>(
//                           value: selectedTranqty ?? (selectedTransacc == "DBC" ? "1" : null),
//                           decoration: _fDeco('Cyl. Qty *', error: (selectedTranqty == null || selectedTranqty!.isEmpty) ? 'Cyl. Qty Is Required' : null),
//                           items: getTransqty.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
//                           onChanged: selectedTransacc == "DBC" ? null : (value) { setState(() { selectedTranqty = value; cylinderQty = int.parse(selectedTranqty!); int qtyV = int.parse(selectedTranqty!); if (selectedTransacc == "RC") { refillCylinderAmountController.text = (refillAmountCyl! * qtyV).toString(); } else { depositCylinderAmountController.text = (depositAmount! * qtyV).toString(); refillCylinderAmountController.text = (refillAmountCyl! * qtyV).toString(); } calculateBasicAmountSum(); calculateGrandTotalAmount(); }); }, isExpanded: true,
//                         )),
//                       if (selectedTranssvItemName != "14.2 KG" || isExemptedReticulated)
//                         SizedBox(width: halfWidth, child: TextField(controller: cylinderQtyAddController, decoration: _fDeco('Cyl. Qty *'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)], onChanged: (value) { setState(() { cylinderQty = int.tryParse(value); int? q = int.tryParse(value); if (q != null) { depositCylinderAmountController.text = (depositAmount! * q).toString(); refillCylinderAmountController.text = (refillAmountCyl! * q).toString(); calculateBasicAmountSum(); calculateGrandTotalAmount(); } }); })),
//                       if ((selectedTransacc != "DBC") && selectedTranssvItemName == "14.2 KG")
//                         SizedBox(width: halfWidth, child: TextField(controller: scRegulatorController, decoration: _fDeco('SC Regulator'), enabled: false)),
//                       if (selectedTranssvItemName != "14.2 KG")
//                         SizedBox(width: halfWidth, child: DropdownButtonFormField<String>(
//                           value: getSelectedFTLRegulatorQtyString,
//                           decoration: _fDeco('FTL Regulator *', error: (getSelectedFTLRegulatorQtyString == null || getSelectedFTLRegulatorQtyString!.isEmpty) ? 'FTL Regulator Is Required' : null),
//                           items: getSelectedFTLRegulatorQty.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
//                           onChanged: (value) { setState(() { getSelectedFTLRegulatorQtyString = value; selectedFTLRegQty = int.parse(getSelectedFTLRegulatorQtyString!); if (selectedFTLRegQty == 0) { calculateBasicAmountSumDepositMinus(); calculateGrandTotalAmountDepositMinus(); regulatorDepositAmountController.text = "0"; } else { if (modes == "Edit") { getRegulatorDepositAmountFromApi = getRefillAmountByItemName("SC REGULATOR")?.toDouble(); regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString(); } else { regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString(); } calculateBasicAmountSum(); calculateGrandTotalAmount(); } }); }, isExpanded: true,
//                         )),
//                       SizedBox(width: halfWidth, child: TextField(controller: depositCylinderAmountController, decoration: _fDeco('Deposit Cyl. *', error: depositCylinderAmountController.text.isEmpty ? 'Deposit Cyl. is Required' : null), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), LengthLimitingTextInputFormatter(7)], enabled: selectedTranssvItemName == "14.2 KG" && selectedTransacc == "RC", onChanged: (v) { calculateBasicAmountSum(); calculateGrandTotalAmount(); })),
//                       SizedBox(width: halfWidth, child: TextField(controller: refillCylinderAmountController, decoration: _fDeco('Cyl Refill Amt.'), enabled: false)),
//                       if (selectedTransacc != "DBC")
//                         SizedBox(width: halfWidth, child: TextField(controller: regulatorDepositAmountController, decoration: _fDeco('Regulator Deposit *', error: regulatorDepositAmountController.text.isEmpty ? 'Regulator Deposit is Required' : null), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), LengthLimitingTextInputFormatter(7)], enabled: selectedTranssvItemName == "14.2 KG" && selectedTransacc == "RC" && !isExemptedReticulated, onChanged: (v) { calculateBasicAmountSum(); calculateGrandTotalAmount(); })),
//                       SizedBox(width: halfWidth, child: TextField(controller: stampDutyController, decoration: _fDeco('Stamp Duty'), enabled: false)),
//                       if (selectedTranssvItemName != "14.2 KG")
//                         SizedBox(width: halfWidth, child: TextField(controller: regulatorDiscountAmountController, decoration: _fDeco('Discount Amount'), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (v) { setState(() { calculateBasicAmountSum(); calculateGrandTotalAmount(); }); })),
//                       SizedBox(width: halfWidth, child: TextField(controller: regulatorBasicAmountController, decoration: _fDeco('Basic Amount'), enabled: false)),
//                     ]),
//                   ]),
//                 ],
//                 if (selectedTransacc == "Name Change") ...[
//                   _svSectionHeader('Name Change', AppColors.orange),
//                   _svCard([SizedBox(width: halfWidth, child: TextField(controller: nameChangeAmtChargesController, decoration: _fDeco('Amount Charges *', error: nameChangeAmtChargesController.text.isEmpty ? 'Amount Charges is Required' : null), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), LengthLimitingTextInputFormatter(7)], onChanged: (value) { value = value.trim(); if (value.isNotEmpty) { try { calculateBasicAmountSum(); calculateGrandTotalAmount(); } catch (e) { showFlushBar(context, "Invalid amount format."); } } }))]),
//                 ],
//                 _svSectionHeader('Consumer Details', AppColors.green),
//                 _svCard([
//                   if (!isSVPending) ...[TextField(controller: conNoController, focusNode: _conNoFocusNode, maxLengthEnforcement: MaxLengthEnforcement.enforced, inputFormatters: [LengthLimitingTextInputFormatter(6), FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')), FilteringTextInputFormatter.deny(RegExp(r'\s'))], decoration: _fDeco('Consumer No. / DC No. *', error: _isConsumerEmpty ? 'Consumer No./DC No. Is Required' : null), onChanged: (v) { setState(() { _isConsumerEmpty = v.isEmpty; }); }), const SizedBox(height: 12)],
//                   if (isSVPending && !invoiceAutoManualMandatory || invoiceAutoManualMandatory) ...[TextField(controller: invNoController, readOnly: invoiceAutoManualMandatory, enabled: true, maxLengthEnforcement: MaxLengthEnforcement.enforced, inputFormatters: invoiceAutoManualMandatory ? [] : [LengthLimitingTextInputFormatter(16), FilteringTextInputFormatter.digitsOnly], decoration: _fDeco(invoiceAutoManualMandatory ? 'Invoice No. (Auto)' : 'Invoice No. / DC No. *', error: _isInvoiceEmpty ? 'Invoice No. OR DC No. Is Required' : null).copyWith(suffixIcon: Tooltip(triggerMode: TooltipTriggerMode.tap, message: invoiceAutoManualMandatory ? 'Auto-generated Invoice number' : 'Manual Invoice Number', child: const Icon(Icons.info_outline, color: AppColors.blue))), onChanged: (v) { setState(() { _isInvoiceEmpty = v.isEmpty; }); }), const SizedBox(height: 12)],
//                   TextField(controller: conNameController, decoration: _fDeco('Consumer Name'), onChanged: (v) {}),
//                   const SizedBox(height: 12),
//                   TextField(controller: conContactController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], decoration: _fDeco('Consumer Contact No.', error: _isConCOntactEmpty ? 'Please Enter A Valid Contact No.' : _isInvalidMobile ? 'Invalid Mobile Number' : _isShortLength ? 'Must be 10 digits' : null), onChanged: (value) { setState(() { _isConCOntactEmpty = value.isEmpty; if (value.isNotEmpty) { _isInvalidMobile = !RegExp(r'^[6789]').hasMatch(value); _isShortLength = value.length < 10; } else { _isInvalidMobile = false; _isShortLength = false; } }); }),
//                   const SizedBox(height: 12),
//                   TextField(controller: conAddNoController, inputFormatters: [LengthLimitingTextInputFormatter(250)], decoration: _fDeco('Consumer Address'), onChanged: (v) {}),
//                 ]),
//                 _svSectionHeader('Items', AppColors.amber),
//                 Row(children: [
//                   const Text('Add Item', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textMid)),
//                   const SizedBox(width: 12),
//                   GestureDetector(onTap: _isAddNewItemEnabled ? _addNewItem : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: _isAddNewItemEnabled ? AppColors.blue : AppColors.border, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.add_rounded, color: Colors.white, size: 20))),
//                 ]),
//                 const SizedBox(height: 8),
//                 ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: items.length,
//                   itemBuilder: (context, index) => Container(
//                     margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))]),
//                     child: Column(children: [
//                       Row(children: [
//                         Expanded(child: DropdownButtonFormField<String>(
//                           decoration: _fDeco('Select Item *'),
//                           value: _selectedItems[index]?.isEmpty ?? true ? null : _selectedItems[index],
//                           items: _items.where((item) => !_selectedItems.values.contains(item.itemName) || _selectedItems[index] == item.itemName).toSet().map((item) => DropdownMenuItem<String>(value: item.itemName, child: Text(item.itemName ?? 'Unknown'))).toList(),
//                           onChanged: (selectedItemName) {
//                             if (selectedItemName != null) {
//                               setState(() {
//                                 _selectedItems[index] = selectedItemName;
//                                 final sel = _items.firstWhere((item) => item.itemName == selectedItemName, orElse: () => GetArbItemMasterListModel());
//                                 _itemStockByIndex[index] = getArbItemCurrentStock(sel.itemId?.toInt())?.toInt(); _selectedItemIds[index] = sel.itemId?.toInt(); _selectedCategoryName[index] = sel.categoryName;
//                                 double rate = sel.rate?.toDouble() ?? 0.0; items[index]['rate']?.text = rate.toString(); items[index]['amt']?.text = rate.toString();
//                                 if (sel.categoryName == "Non ARB Item") { items[index]['qty']?.text = "1"; items[index]['discount']?.clear(); _updateSum(index); calculateGrandTotalAmount(); if (index == items.length - 1) Future.delayed(const Duration(milliseconds: 200), _addNewItem); }
//                                 else { int? stockLimit = _itemStockByIndex[index]; if (stockLimit != null && 1 > stockLimit) { items[index]['qty']?.clear(); items[index]['discount']?.clear(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Qty exceeds stock: $stockLimit'), backgroundColor: AppColors.red)); _updateSum(index); calculateGrandTotalAmount(); } else { items[index]['qty']?.text = "1"; items[index]['discount']?.clear(); _updateSum(index); calculateGrandTotalAmount(); if (index == items.length - 1) Future.delayed(const Duration(milliseconds: 200), _addNewItem); } }
//                                 calculateGrandTotalAmount();
//                                 Future.delayed(const Duration(milliseconds: 100), () { if (_discountFocusNodes.length > index) FocusScope.of(context).requestFocus(_discountFocusNodes[index]); });
//                               });
//                             }
//                           },
//                         )),
//                         const SizedBox(width: 8),
//                         GestureDetector(onTap: () => _removeItem(index), child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.redXL, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 20))),
//                       ]),
//                       const SizedBox(height: 12),
//                       Row(children: [
//                         Expanded(child: TextField(controller: items[index]['rate'], decoration: _fDeco('Rate'), enabled: false)),
//                         const SizedBox(width: 8),
//                         Expanded(child: TextField(controller: items[index]['qty'], keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)], decoration: _fDeco('Qty *'), onChanged: (value) { setState(() { int enteredQty = int.tryParse(value) ?? 0; int? stockLimit = _itemStockByIndex[index]; String? catCheck = _selectedCategoryName[index]; if (catCheck != "Non ARB Item" && value.isNotEmpty && stockLimit != null && enteredQty > stockLimit) { items[index]['qty']?.clear(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Qty exceeds stock: $stockLimit'), backgroundColor: AppColors.red)); } _updateSum(index); calculateGrandTotalAmount(); }); })),
//                         const SizedBox(width: 8),
//                         Expanded(child: TextField(controller: items[index]['discount'], focusNode: _discountFocusNodes[index], keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(7)], decoration: _fDeco('Discount'), onChanged: (v) { setState(() { _updateSum(index); calculateGrandTotalAmount(); }); })),
//                         const SizedBox(width: 8),
//                         Expanded(child: TextField(controller: items[index]['amt'], decoration: _fDeco('Amt.'), enabled: false)),
//                       ]),
//                     ]),
//                   ),
//                 ),
//                 _svSectionHeader('Payment', AppColors.orange),
//                 _svCard([
//                   TextField(controller: totalAmountController, decoration: _fDeco('Total Amount'), enabled: false),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(key: formKey3, value: selectedTransMode, decoration: _fDeco('Payment Mode *'), items: getTransMode.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) { setState(() { selectedTransMode = v; }); }, isExpanded: true),
//                   if (selectedTransMode == 'Partial' || selectedTransMode == 'Merchant QR') ...[const SizedBox(height: 12), TextField(controller: partialQRController, decoration: _fDeco('QR Receipt Payment *', error: _isQRcode ? 'QR amount is Required' : null), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}'))], onChanged: (value) { setState(() { _isQRcode = value.isEmpty; isEditingQR = true; isEditingCash = false; double ta = double.tryParse(totalAmountController.text) ?? 0.0; double qa = double.tryParse(value) ?? 0.0; if (qa > ta) { partialQRController.clear(); } else if (selectedTransMode == 'Partial') { updateRemainingAmount(); } }); })],
//                   if (selectedTransMode == 'Partial' || selectedTransMode == 'Cash') ...[const SizedBox(height: 12), TextField(controller: recPaymentController, decoration: _fDeco('Cash Receipt Payment *', error: _iscashcode ? 'Receipt cash is Required' : null), keyboardType: const TextInputType.numberWithOptions(decimal: true), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}'))], onChanged: (value) { setState(() { _iscashcode = value.isEmpty; isEditingCash = true; isEditingQR = false; double ta = double.tryParse(totalAmountController.text) ?? 0.0; double ra = double.tryParse(value) ?? 0.0; if (ra > ta) { recPaymentController.clear(); } else if (selectedTransMode == 'Partial') { updateRemainingAmount(); } }); })],
//                   if (selectedTransMode == 'Merchant QR' || selectedTransMode == 'Partial') ...[
//                     const SizedBox(height: 12),
//                     DropdownButtonFormField<GetBankMappingDetailsListModel>(decoration: _fDeco('Select Account No. *'), value: bankModel.contains(_selectBankModel) ? _selectBankModel : null, items: bankModel.map((item) => DropdownMenuItem(value: item, child: Text('${item.bankName ?? ''} - ${item.accountNo ?? ''}'))).toList(), onChanged: (selectedItem) { setState(() { _selectBankModel = selectedItem; selectedBankName = selectedItem?.bankName; selectedBankId = selectedItem?.accountNo; selecteBankIDApi = selectedItem?.bankId?.toInt(); accMappingId = selectedItem?.mappingId?.toInt(); }); }),
//                     const SizedBox(height: 12),
//                     Row(children: [
//                       Expanded(child: TextField(controller: TranCodeController, maxLengthEnforcement: MaxLengthEnforcement.enforced, inputFormatters: [LengthLimitingTextInputFormatter(30), FilteringTextInputFormatter.deny(RegExp(r'[^\u0000-\u007F]')), FilteringTextInputFormatter.deny(RegExp(r'\s'))], decoration: _fDeco('Transaction Code *', error: _isTranscode ? 'Transaction code is Required' : null), onChanged: (v) { setState(() { _isTranscode = v.isEmpty; }); })),
//                       const SizedBox(width: 10),
//                       Expanded(child: TextField(controller: timeController, decoration: _fDeco('Time'), inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\d.:]{0,5}$'))], onChanged: (v) { setState(() {}); })),
//                     ]),
//                     const SizedBox(height: 12),
//                     TextField(controller: transReviewController, decoration: _fDeco('Transaction Remark'), inputFormatters: [LengthLimitingTextInputFormatter(250)], onChanged: (v) { setState(() {}); }),
//                   ],
//                 ]),
//                 if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial') ...[
//                   Row(children: [
//                     Checkbox(value: isCashDenominationChecked, activeColor: AppColors.blue, onChanged: (v) { setState(() { isCashDenominationChecked = v ?? false; }); }),
//                     const Text('Cash Denomination', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMid)),
//                   ]),
//                   if (isCashDenominationChecked) ...[
//                     Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(cashDenominationMandatory ? 'Cash Denomination Is Mandatory' : 'Cash Denomination', style: const TextStyle(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.bold))),
//                     Container(height: 40, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: AppColors.blueXXL, borderRadius: BorderRadius.circular(12)),
//                       child: Row(children: [
//                         Expanded(child: GestureDetector(onTap: () { setState(() { _selectedIndex = 0; }); }, child: AnimatedContainer(duration: const Duration(milliseconds: 200), alignment: Alignment.center, decoration: BoxDecoration(color: _selectedIndex == 0 ? AppColors.blue : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text('Cash Denomination', style: TextStyle(color: _selectedIndex == 0 ? Colors.white : AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13))))),
//                         Expanded(child: GestureDetector(onTap: () { setState(() { _selectedIndex = 1; }); }, child: AnimatedContainer(duration: const Duration(milliseconds: 200), alignment: Alignment.center, decoration: BoxDecoration(color: _selectedIndex == 1 ? AppColors.blue : Colors.transparent, borderRadius: BorderRadius.circular(12)), child: Text('Cash Return', style: TextStyle(color: _selectedIndex == 1 ? Colors.white : AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13))))),
//                       ]),
//                     ),
//                     Visibility(visible: _selectedIndex == 0, child: _svCard([
//                       Row(children: const [Expanded(flex: 2, child: Center(child: Text('Note Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))), Expanded(flex: 3, child: Center(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))), Expanded(flex: 1, child: SizedBox()), Expanded(flex: 3, child: Center(child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))))]),
//                       const Divider(height: 16),
//                       ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: getNoteTypeAndIdFroDenominationListModel.length, itemBuilder: (context, index) { final data = getNoteTypeAndIdFroDenominationListModel[index]; return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Expanded(flex: 2, child: Center(child: Text('${data.noteType}', style: const TextStyle(fontSize: 12)))), Expanded(flex: 1, child: const Center(child: Text('X', style: TextStyle(fontSize: 12)))), Expanded(flex: 3, child: TextField(controller: qtyController[index], keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: _fDeco(null), textAlign: TextAlign.center, onChanged: (value) { setState(() { amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!; totalAmount = amounts.fold(0.0, (s, a) => s + a); finalAmountCashDeno = totalAmount - returnAmount; }); })), Expanded(flex: 1, child: const Center(child: Text('=', style: TextStyle(fontSize: 12)))), Expanded(flex: 3, child: Center(child: Text(amounts[index].toStringAsFixed(2), style: const TextStyle(fontSize: 12))))])); }),
//                       const Divider(height: 16),
//                       Row(mainAxisAlignment: MainAxisAlignment.end, children: [Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Row(children: [const Text('Collected: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMid)), Text(totalAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue))]), const SizedBox(height: 4), Row(children: [const Text('Final Total: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMid)), Text(finalAmountCashDeno.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green))])])]),
//                     ])),
//                     Visibility(visible: _selectedIndex == 1, child: _svCard([
//                       Row(children: const [Expanded(flex: 2, child: Center(child: Text('Note Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))), Expanded(flex: 3, child: Center(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))), Expanded(flex: 1, child: SizedBox()), Expanded(flex: 3, child: Center(child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))))]),
//                       const Divider(height: 16),
//                       ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: getNoteTypeAndIdFroDenominationListModel.length, itemBuilder: (context, index) { final data = getNoteTypeAndIdFroDenominationListModel[index]; return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Expanded(flex: 2, child: Center(child: Text('${data.noteType}', style: const TextStyle(fontSize: 12)))), Expanded(flex: 1, child: const Center(child: Text('X', style: TextStyle(fontSize: 12)))), Expanded(flex: 3, child: TextField(controller: qtyControllerReturn[index], keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: _fDeco(null), textAlign: TextAlign.center, onChanged: (value) { setState(() { amountsReturn[index] = (double.tryParse(value) ?? 0.0) * data.noteType!; returnAmount = amountsReturn.fold(0.0, (s, a) => s + a); finalAmountCashDeno = totalAmount - returnAmount; }); })), Expanded(flex: 1, child: const Center(child: Text('=', style: TextStyle(fontSize: 12)))), Expanded(flex: 3, child: Center(child: Text(amountsReturn[index].toStringAsFixed(2), style: const TextStyle(fontSize: 12))))])); }),
//                       const Divider(height: 16),
//                       Row(mainAxisAlignment: MainAxisAlignment.end, children: [Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Row(children: [const Text('Return: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMid)), Text(returnAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange))]), const SizedBox(height: 4), Row(children: [const Text('Final Total: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMid)), Text(finalAmountCashDeno.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green))])])]),
//                     ])),
//                   ],
//                 ],
//                 const SizedBox(height: 16),
//                 Row(children: [
//                   Expanded(child: OutlinedButton(onPressed: cancelAction, style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue, side: const BorderSide(color: AppColors.blue, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), minimumSize: const Size(0, 52)), child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)))),
//                   const SizedBox(width: 12),
//                   Expanded(child: ElevatedButton(
//                     onPressed: () { if (saveFlag) { showFlushBar(context, Constants.dayEndCompleted); } else { if (modes == "Edit") { updateSVAddEditForMob(context, psvIdEdit!, "EDIT"); } else { updateSVAddEditForMob(context, 0, "ADD"); } } },
//                     style: ElevatedButton.styleFrom(backgroundColor: saveFlag ? AppColors.border : AppColors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), minimumSize: const Size(0, 52), elevation: 0),
//                     child: Text(modes == "Edit" ? 'Update' : 'Save', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
//                   )),
//                 ]),
//                 const SizedBox(height: 20),
//                 _svSectionHeader("Today's Records", AppColors.blueLight),
//                 if (receiptList.isNotEmpty)
//                   ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: receiptList.length,
//                     itemBuilder: (context, index) {
//                       GetAddEditDataSvSaleItemModel? svSale = receiptList[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))]),
//                         child: Column(children: [
//                           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                             Expanded(child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(svSale.sVDate ?? '')), style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 13))),
//                             Expanded(child: Text(svSale.productName.toString(), style: const TextStyle(color: AppColors.textMid, fontWeight: FontWeight.w600, fontSize: 13))),
//                             Row(children: [
//                               IconButton(icon: Icon(Icons.edit_outlined, color: saveFlag ? AppColors.border2 : AppColors.blue, size: 20), onPressed: () {
//                                 loadDenominationData(svSale.pSVId!.toInt());
//                                 if (saveFlag) { showFlushBar(context, Constants.dayEndCompleted); return; }
//                                 Navigator.pushNamed(context, SVSaleReportScreen.screenName, arguments: {'psvIDV': svSale.pSVId.toString(), 'sVDateV': svSale.sVDate.toString(), 'referredByIdV': svSale.referredById.toString(), 'referredByNameV': svSale.referredByName.toString(), 'otherNameV': svSale.otherName.toString(), 'productIdV': svSale.productId.toString(), 'productNameV': svSale.productName.toString(), 'isUndocumentV': svSale.isUndocument.toString(), 'sVTypeV': svSale.sVType.toString(), 'cylQtyV': svSale.cylQty.toString(), 'sCRegulatorV': svSale.sCRegulator.toString(), 'depositCylV': svSale.depositCyl.toString(), 'cylRefillRSPV': svSale.cylRefillRSP.toString(), 'regulatorDepositV': svSale.regulatorDeposit.toString(), 'stampDutyV': svSale.stampDuty.toString(), 'fTLRegulatorV': svSale.fTLRegulator.toString(), 'basicAmtV': svSale.basicAmt.toString(), 'consuDCNoV': svSale.consuDCNo.toString(), 'consumerNameV': svSale.consumerName.toString(), 'consuContactNoV': svSale.consuContactNo.toString(), 'totalAmountV': svSale.totalAmount.toString(), 'receiptAmtV': svSale.receiptAmt.toString(), 'partialQRV': svSale.qRReceiptAmt.toString(), 'paymentModeV': svSale.paymentMode.toString(), 'transactionCodeV': svSale.transactionCode.toString(), 'transactionTimeV': svSale.transactionTime.toString(), 'transactionRemarkV': svSale.transactionRemark.toString(), 'addedByV': svSale.addedBy.toString(), 'actionV': svSale.action.toString(), 'itemIdV': svSale.itemId.toString(), 'itemNameV': svSale.itemName.toString(), 'rateV': svSale.rate.toString(), 'itemQtyV': svSale.itemQty.toString(), 'discountAmtV': svSale.discountAmt.toString(), 'aRBAmountV': svSale.aRBAmount.toString(), 'amtChargesV': svSale.amtCharges.toString(), 'categoryNameV': svSale.categoryName.toString(), 'bankIdV': svSale.bankId.toString(), 'bankMappingIdV': svSale.bankMappingId.toString(), 'accountNoV': svSale.accountNo.toString(), 'bankNameV': svSale.bankName.toString(), 'isExemptRetiV': svSale.isExemptReti.toString(), 'sVDiscountAmtV': svSale.sVDiscountAmt.toString(), 'itemsToShow': svSale.itemDetails?.toList(), 'consumerAddressV': svSale.consuAddress.toString(), 'invoiceNumberV': svSale.invoiceNo.toString(), 'invoiceTypeV': svSale.invoiceType.toString(), 'modeChange': 'Edit'});
//                               }),
//                               IconButton(icon: Icon(Icons.delete_outline_rounded, color: saveFlag ? AppColors.border2 : AppColors.red, size: 20), onPressed: () async {
//                                 if (saveFlag) { showFlushBar(context, Constants.dayEndCompleted); return; }
//                                 int? psv = svSale.pSVId?.toInt();
//                                 bool? confirmDelete = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), title: const Text('Confirm Delete'), content: const Text('Are you sure you want to delete this record?'), actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete'))]));
//                                 if (confirmDelete == true && psv != null) updateSVAddEditForMob(context, psv, "DELETE");
//                               }),
//                             ]),
//                           ]),
//                           const Divider(height: 12),
//                           _receiptInfoRow('SV Type', svSale.sVType.toString(), 'SV Pending', svSale.isUndocument == true ? 'Yes' : 'No'),
//                           _receiptInfoRow('DC/Invoice', [if (svSale.consuDCNo != null && svSale.consuDCNo!.isNotEmpty && svSale.consuDCNo != '0') svSale.consuDCNo!, if (svSale.invoiceNo != null && svSale.invoiceNo!.isNotEmpty && svSale.invoiceNo != '0') svSale.invoiceNo!].join('/'), 'Cons. Name', svSale.consumerName.toString()),
//                           _receiptInfoRow('Amount', svSale.totalAmount.toString(), 'Mode', svSale.paymentMode == "Bank" ? 'Merchant QR' : svSale.paymentMode.toString()),
//                           _receiptInfoRow('Cyl Qty', svSale.cylQty.toString(), 'Doc Status', svSale.isUndocument == true ? 'Pending' : 'Done'),
//                         ]),
//                       );
//                     })
//                 else
//                   Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2))]), child: const Center(child: Text('No Records Found', style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500)))),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   void _updateSum(int index) {
//     // Get the values from the receivedQty, discount, and rate controllers
//     double qtyNew = double.tryParse(items[index]['qty']?.text ?? '') ?? 0;
//     double discountNew =
//         double.tryParse(items[index]['discount']?.text ?? '') ?? 0;
//     double rateNew = double.tryParse(items[index]['rate']?.text ?? '') ?? 0;
//     double totalSum = 0.0;
//     double newAmt = 0.0;
//     // If qtyNew is not null or empty, calculate the sum
//     if (qtyNew != 0) {
//       newAmt = qtyNew * rateNew;
//       if (discountNew != 0) {
//         // If discount is provided, apply the discount
//         totalSum = qtyNew * rateNew - discountNew;
//         items[index]['amt']?.text = totalSum
//             .toStringAsFixed(2); // Update the amount with 2 decimal points
//         debugPrint("totalSum with discount: $totalSum");
//       } else {
//         // If no discount is provided, just multiply qty and rate
//         totalSum = qtyNew * rateNew;
//         items[index]['amt']?.text = totalSum.toStringAsFixed(2);
//         debugPrint("totalSum without discount: $totalSum");
//       }
//     } else {
//       // If qty is 0 or empty, set the amount to 0 regardless of discount
//       newAmt =  rateNew;
//       totalSum = rateNew - discountNew;
//       items[index]['amt']?.text = totalSum.toStringAsFixed(2);
//       debugPrint("totalSum (qty is empty): $totalSum");
//     }
//     if(newAmt >= discountNew){
//
//     }else{
//       items[index]['discount']?.clear();
//       _updateSum(index);
//       calculateGrandTotalAmount();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(Constants.discountError)),
//       );
//     }
//   }
//
//   Future<void> getNoteTypeAndIDList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//
//     if (!Constants.isNetworkAvailable) {
//       showFlushBar(
//           context,  Constants.connectionMessage);
//       isLoading = false;
//     } else {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? distributorId = prefs.getString('DistributorId');
//         String? bearerToken = prefs.getString('token');
//
//         if (bearerToken == null) {
//           isLoading = false;
//           throw Exception('Bearer token is missing');
//         }
//
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetCashDenominationItemList}/0'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         );
//         debugPrint(
//             "Response body GetCashDenominationItemList: ${response.body}");
//         debugPrint(
//             "request body GetCashDenominationItemList: ${response.request}");
//
//         if (response.statusCode == 200) {
//           // Decode the response body as a List
//           final List<dynamic> jsonResponse = jsonDecode(response.body);
//
//           // Filter the data based on the condition (TransCate == 'DailySale')
//           var filteredDataCashDenominationList = jsonResponse
//               .map((item) => DenomModel.fromJson(
//               item)) // Map to model
//               .toList();
//
//           setState(() {
//             // Use filtered data to update the UI
//             getNoteTypeAndIdFroDenominationListModel = filteredDataCashDenominationList;
//             dataCashDenominationList = filteredDataCashDenominationList;
//             isLoading = false;
//
//             qtyController = List.generate(
//               getNoteTypeAndIdFroDenominationListModel.length,
//                   (index) => TextEditingController(),
//             );
//
//             amounts = List.generate(
//               getNoteTypeAndIdFroDenominationListModel.length,
//                   (index) => 0.0,
//             );
//
//             qtyControllerReturn = List.generate(
//               getNoteTypeAndIdFroDenominationListModel.length,
//                   (index) => TextEditingController(),
//             );
//
//             amountsReturn = List.generate(
//               getNoteTypeAndIdFroDenominationListModel.length,
//                   (index) => 0.0,
//             );
//           });
//         } else {
//           isLoading = false;
//           throw Exception('Failed to load sales data');
//         }
//       } catch (error) {
//         isLoading = false;
//         debugPrint("Error: $error");
//         // Return an empty list in case of an error
//       }
//     }
//   }
//
//   Future<void> getStaffDetailsList() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? staffStatus = prefs.getString('StaffStatus');
//     String? designation = prefs.getString('Designation');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//       "StaffStatus": staffStatus,
//       "Designation": designation,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetStaffDetailsList : " +
//         '${AppUrl.GetStaffDetailsList}/$distributorId/1/0');
//     debugPrint("GetStaffDetailsList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         staffdetailsmodel = data.map((json) {
//           return GetStaffDetailsListModel.fromJson(json);
//         }).toList();
//
//         staffdetailsmodel.sort((a, b) {
//           final nameA = a.staffName ?? '';
//           final nameB = b.staffName ?? '';
//           return nameA.toLowerCase().compareTo(nameB.toLowerCase());
//         });
//
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getItemMasterList() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? isActive = prefs.getString('IsActive');
//     String? itemType = prefs.getString('ItemType');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetItemMasterList : " +
//         '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//     debugPrint("GetItemMasterList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         masterListModel = data.map((json) {
//           return GetItemMasterListModel.fromJson(json);
//         }).toList();
//         isLoading = false;
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getDistStampDuty() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//
//     if (bearerToken == null || distributorId == null) {
//       EasyLoading.dismiss();
//       throw Exception('Required token or distributor ID is missing');
//     }
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetDistStampDuty}/$distributorId'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//       },
//     );
//
//     debugPrint("GetDistStampDuty : ${AppUrl.GetDistStampDuty}/$distributorId");
//     debugPrint("Response : ${response.body}");
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       final stampDutyModel = GetDistStampDutyModel.fromJson(data);
//
//       setState(() {
//         stampDutyController.text = stampDutyModel.stampDuty?.toString() ?? '';
//         isLoading = false;
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load stamp duty data');
//     }
//   }
//
//   Future<void> fetchBank() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/0'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetBankMappingDetailsListModel : " +
//         '${AppUrl.GetBankMappingDetailsList}/$distributorId/0');
//     debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         bankModel = data.map((json) {
//           return GetBankMappingDetailsListModel.fromJson(json);
//         }).toList();
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getArbCurrentStockList() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetArbCurrentStockList}/$distributorId/1'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetArbCurrentStockList : " +
//         '${AppUrl.GetArbCurrentStockList}/$distributorId/1');
//     debugPrint("GetArbCurrentStockList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         svcStock = data.map((json) {
//           return GetArbCurrentStockListModel.fromJson(json);
//         }).toList();
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getArbItemMasterListModel() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetARBItemMasterList}/$distributorId/1/AllARB'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetARBItemMasterList : " +
//         '${AppUrl.GetARBItemMasterList}/$distributorId/1/AllARB');
//     debugPrint("GetARBItemMasterList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       setState(() {
//         _items = data
//             .map((json) => GetArbItemMasterListModel.fromJson(json))
//             .toList();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> getRspDetailsListModel() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetRSPDetailsList}/$distributorId/ALL'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetARBItemMasterList : " +
//         '${AppUrl.GetRSPDetailsList}/$distributorId/ALL');
//     debugPrint("GetARBItemMasterList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       setState(() {
//         getrsplistmodel = data.map((json) => GetRspDetailsListModel.fromJson(json)).toList();
//         if(modes == "Edit"){
//
//         }else {
//           getRegulatorDepositAmountFromApi =
//               getRefillAmountByItemName("SC REGULATOR")?.toDouble();
//           regulatorDepositAmountController.text =
//               getRegulatorDepositAmountFromApi.toString();
//         }
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   num? getDepositAmountByItemId(int? itemId) {
//     if (itemId == null) return null;
//
//     try {
//       return getrsplistmodel
//           .firstWhere((element) => element.itemId == itemId)
//           .depositAmt;
//     } catch (e) {
//       // No matching item found
//       return null;
//     }
//   }
//
//   num? getArbItemCurrentStock(int? itemId) {
//     if (itemId == null) return null;
//
//     try {
//       final stockItem = svcStock.firstWhere(
//             (element) => element.itemId?.toInt() == itemId,
//         orElse: () => GetArbCurrentStockListModel(currentStk: 0),
//       );
//
//       print("Selected itemId: $itemId | Stock Found: ${stockItem.currentStk}");
//       return stockItem.currentStk ?? 0;
//     } catch (e) {
//       print("Error: $e");
//       return 0;
//     }
//   }
//
//   num? getRefillAmountByItemName(String? itemName) {
//     if (itemName == null) return null;
//
//     try {
//       return getrsplistmodel
//           .firstWhere((element) => element.itemName == itemName)
//           .depositAmt;
//     } catch (e) {
//       // No matching item found
//       return null;
//     }
//   }
//
//   num? getRefillAmountByItemId(int? itemId) {
//     if (itemId == null) return null;
//
//     try {
//       return getrsplistmodel
//           .firstWhere((element) => element.itemId == itemId)
//           .rSPPrice;
//     } catch (e) {
//       // No matching item found
//       return null;
//     }
//   }
//
//   void calculateBasicAmountSum() {
//     double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
//     double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
//     double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
//     double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
//     double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;
//     double nameChangeAmt = double.tryParse(nameChangeAmtChargesController.text) ?? 0;
//     double newAmt=0;
//     double total=0;
//     if(selectedTransacc == "Name Change"){
//       newAmt = nameChangeAmt;
//       total = nameChangeAmt;
//     }else{
//       newAmt = deposit + refill + regulator + stampDuty;
//       total = deposit + refill + regulator + stampDuty - discountAmt;
//     }
//
//     debugPrint("total $total");
//     debugPrint("newAmt $newAmt");
//     regulatorBasicAmountController.text = total.toStringAsFixed(2);
//     if(newAmt >= discountAmt){
//
//     }else{
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(Constants.discountError)),
//       );
//       regulatorDiscountAmountController.clear();
//       calculateBasicAmountSum();
//       calculateGrandTotalAmount();
//     }
//   }
//
//   void calculateBasicAmountSumDepositMinus() {
//     double deposit = double.tryParse(depositCylinderAmountController.text.trim()) ?? 0;
//     double refill = double.tryParse(refillCylinderAmountController.text.trim()) ?? 0;
//     double stampDuty = double.tryParse(stampDutyController.text.trim()) ?? 0;
//     double regulator = double.tryParse(regulatorDepositAmountController.text.trim()) ?? 0;
//     double discountAmt = double.tryParse(regulatorDiscountAmountController.text.trim()) ?? 0;
//
//     debugPrint("Parsed values:");
//     debugPrint("Deposit: $deposit");
//     debugPrint("Refill: $refill");
//     debugPrint("Stamp Duty: $stampDuty");
//     debugPrint("Regulator: $regulator");
//     debugPrint("Discount: $discountAmt");
//
//     double total = deposit + refill + regulator + stampDuty - discountAmt - regulator;
//
//     debugPrint("Total (calculated): $total");
//
//     regulatorBasicAmountController.text = total.toStringAsFixed(2);
//   }
//
//   Future<void> fetchItemSvAddEditList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if(Constants.isNetworkAvailable){
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       try {
//         final response = await http.get(
//           // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
//           Uri.parse('${AppUrl.GetPendingSVList_Mob}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URLGetPendingSVList_Mob: ${response.request}");
//         print("Request HeadersGetPendingSVList_Mob: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status CodeGetPendingSVList_Mob: ${response.statusCode}");
//         print("API Response BodyGetPendingSVList_Mob: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data.map((json) => GetAddEditDataSvSaleItemModel.fromJson(json)).toList();
//             isLoading = false;
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
//
//   Future<void> fetchDenominationListAddEditList(int psvId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if(Constants.isNetworkAvailable){
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       try {
//         final response = await http.get(
//           // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
//           Uri.parse('${AppUrl.GetPendingSVCashDenoDtlsById_Mob}/$psvId/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request GetPendingSVCashDenoDtlsById_Mob: ${response.request}");
//         print("Request GetPendingSVCashDenoDtlsById_Mob: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status GetPendingSVCashDenoDtlsById_Mob: ${response.statusCode}");
//         print("API Response GetPendingSVCashDenoDtlsById_Mob: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getDenominationLis = data.map((json) => GetDenominationListForAddEdit.fromJson(json)).toList();
//             isLoading = false;
//             initializeControllers();
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
//
//   void initializeControllers() {
//     qtyController = List.generate(getDenominationLis.length, (index) {
//       return TextEditingController(
//         text: getDenominationLis[index].qty?.toString() ?? "0",
//       );
//     });
//
//     amounts = List.generate(getDenominationLis.length, (index) {
//       final qty = getDenominationLis[index].qty?.toDouble() ?? 0.0;
//       final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
//       return qty * noteType; // Now returns double
//     });
//
//
//     totalAmount = amounts.fold(0.0, (sum, item) => sum + item);
//
//
//     isQtyFilled = Map.fromIterable(
//       List.generate(getDenominationLis.length, (index) => index),
//       key: (index) => index,
//       value: (index) => (getDenominationLis[index].qty ?? 0) > 0,
//     );
//
//     qtyControllerReturn = List.generate(getDenominationLis.length, (index) {
//       return TextEditingController(
//         text: getDenominationLis[index].retNoteQty?.toString() ?? "0",
//       );
//     });
//
//     amountsReturn = List.generate(getDenominationLis.length, (index) {
//       final qty = getDenominationLis[index].retNoteQty?.toDouble() ?? 0.0;
//       final noteType = getDenominationLis[index].noteType?.toDouble() ?? 0.0;
//       return qty * noteType; // Now returns double
//     });
//     returnAmount = amountsReturn.fold(0.0, (sum, item) => sum + item);
//     finalAmountCashDeno = totalAmount - returnAmount;
//
//   }
//
//   Future<void> loadDenominationData(int psvID) async {
//     await fetchDenominationListAddEditList(psvID.toInt());
//
//     // Now call initializeControllers after list is fetched
//     initializeControllers();
//
//     // Refresh UI
//     setState(() {});
//   }
//
//   Future<void> updateSVAddEditForMob(BuildContext context,int psvID, String actionMode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? addedBy = prefs.getString('StaffId');
//     String? userId = prefs.getString("UserId");
//     int? addedBys = int.parse(addedBy!);
//     int? distributorIds = int.parse(distributorId!);
//     final DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now); int scRegulators = 0;
//     double cylDeposit = 0.0;
//     double cylRefillRSP = 0.0;
//     double regDeposit = 0.0;
//     double stampD = 0.0;
//     double basicAmt = 0.0;
//     double discountAmt = 0.0;
//     String? conDSNo;
//     String? consName;
//     String? conCont;
//     double totalAmt = 0.0;
//     double receiveAmt = 0.0 ;
//     double partialQRAmt = 0.0 ;
//     String? tranCode;
//     String? times;
//     String? transRemark;
//     double nameChangeCharges = 0.0;
//     double discountAmount = 0.0;
//     List<Map<String, dynamic>> dataCashDenomination = [];
//     String? payMode;
//     String? conAddress;
//     String? invoiceNo;
//
//     if(actionMode != "DELETE"){
//       if(scRegulatorController.text.isNotEmpty){
//         scRegulators = int.parse(scRegulatorController.text);
//       }
//
//       if(depositCylinderAmountController.text.isNotEmpty){
//         cylDeposit = double.parse(depositCylinderAmountController.text);
//       }
//
//       if(refillCylinderAmountController.text.isNotEmpty){
//         cylRefillRSP = double.parse(refillCylinderAmountController.text);
//       }
//       if(selectedTransacc != "DBC" && selectedTransacc != "Name Change"){
//         if(regulatorDepositAmountController.text.isNotEmpty){
//           if(regulatorDepositAmountController.text.isNotEmpty || regulatorDepositAmountController.text != null || regulatorDepositAmountController.text != "null"){
//             regDeposit = double.parse(regulatorDepositAmountController.text);
//           }
//         }
//       }else{
//         regDeposit = 0;
//       }
//
//       if(stampDutyController.text.isNotEmpty){
//         stampD = double.parse(stampDutyController.text);
//       }
//       if(regulatorBasicAmountController.text.isNotEmpty){
//         basicAmt = double.parse(regulatorBasicAmountController.text);
//       }
//       if(regulatorDiscountAmountController.text.isNotEmpty){
//         discountAmt = double.parse(regulatorDiscountAmountController.text);
//       }
//       // if(conNoController.text.isNotEmpty){
//       //   conDSNo = conNoController.text;
//       // }
//       if(!isSVPending && conNoController.text.isNotEmpty){
//         conDSNo = conNoController.text;
//       } else {
//         conDSNo = "";
//       }
//       if(conNameController.text.isNotEmpty){
//         consName = conNameController.text;
//       }
//       if(conContactController.text.isNotEmpty){
//         conCont = conContactController.text;
//       }
//       // if(invNoController.text.isNotEmpty){
//       //   invoiceNo = invNoController.text;
//       // }
//       if (isSVPending) {
//         // Auto Invoice
//         invoiceNo = invNoController.text;
//       } else {
//         // Manual
//         invoiceNo = invNoController.text.isNotEmpty
//             ? invNoController.text
//             : "";
//       }
//       if(conAddNoController.text.isNotEmpty){
//         conAddress = conAddNoController.text;
//       }
//
//       if(totalAmountController.text.isNotEmpty){
//         totalAmt = double.parse(totalAmountController.text);
//       }
//       if(recPaymentController.text.isNotEmpty){
//         receiveAmt = double.parse(recPaymentController.text);
//       }
//       if(partialQRController.text.isNotEmpty){
//         partialQRAmt = double.parse(partialQRController.text);
//       }
//       if(TranCodeController.text.isNotEmpty){
//         tranCode = TranCodeController.text;
//       }
//       if(timeController.text.isNotEmpty){
//         times = timeController.text;
//       }
//       if(transReviewController.text.isNotEmpty){
//         transRemark = transReviewController.text;
//       }
//       if(nameChangeAmtChargesController.text.isNotEmpty){
//         nameChangeCharges = double.parse(nameChangeAmtChargesController.text);
//       }
//       if(regulatorDiscountAmountController.text.isNotEmpty){
//         discountAmount = double.parse( regulatorDiscountAmountController.text);
//       }
//       if(selectedBankName != null || selectedBankId != null){
//         if(selectedTransMode == null){
//           showFlushBar(context, "Select Transaction Mode.");
//           return;
//         }
//       }
//
//       if(selectedTranssvItemName == null){
//         showFlushBar(context, "Select Product.");
//         return;
//       }
//       if(selectedTransacc == null){
//         showFlushBar(context, "Select SV Type.");
//         return;
//       }
//       if((selectedTranssvItemName == "14.2 KG" && !isExemptedReticulated) && selectedTransacc != "Name Change"){
//         if(selectedTranqty == null){
//           showFlushBar(context, "Select Cylinder Quantity.");
//           return;
//         }
//       }
//       if(selectedTranssvItemName != "14.2 KG" || isExemptedReticulated){
//         if(cylinderQtyAddController.text.isEmpty){
//           showFlushBar(context, "Enter Cylinder Quantity.");
//           return;
//         }
//       }
//       if(selectedTranssvItemName != "14.2 KG"){
//         if(getSelectedFTLRegulatorQtyString == null){
//           showFlushBar(context, "Select FTL Regulator Quantity.");
//           return;
//         }
//       }
//       if(selectedTransacc != "Name Change"){
//         if(depositCylinderAmountController.text.isEmpty){
//           showFlushBar(context, "Enter Cylinder Deposit Amount.");
//           return;
//         }
//       }
//
//       if(selectedTransacc != "DBC" && selectedTransacc != "Name Change"){
//         if(regulatorDepositAmountController.text.isEmpty){
//           showFlushBar(context, "Enter Regulator Deposit Amount.");
//           return;
//         }
//       }
//
//       if(selectedTransacc == "Name Change"){
//         if(nameChangeAmtChargesController.text.isEmpty){
//           showFlushBar(context,"Enter Name Change Amount.");
//           return;
//         }
//       }
//
//       // if(!invoiceAutoManualMandatory && invNoController.text.isEmpty){
//       // if(isSVPending && !invoiceAutoManualMandatory || invoiceAutoManualMandatory && invNoController.text.isEmpty){
//       if (isSVPending && invoiceAutoManualMandatory && invNoController.text.isEmpty) {
//         showFlushBar(context,"Enter Invoice No");
//         return;
//       }
//
//       if(!isSVPending && conNoController.text.isEmpty){
//         showFlushBar(context,"Enter Consumer Number.");
//         return;
//       }
//       if(selectedTransMode == "Cash" ) {
//         if (recPaymentController.text.isEmpty) {
//           showFlushBar(context, "Enter Cash Receipt Payment.");
//           return;
//         }
//       }
//       if(selectedTransMode == "Merchant QR" ) {
//         if (partialQRController.text.isEmpty) {
//           showFlushBar(context, "Enter QR Receipt Payment.");
//           return;
//         }
//       }
//       if(selectedTransMode == null){
//         showFlushBar(context, "Select Transaction Mode.");
//         return;
//       }
//
//       if(selectedTransMode == "Merchant QR" || selectedTransMode == 'Partial'){
//         if (partialQRController.text.isNotEmpty) {
//           partialQRAmt = double.parse(partialQRController.text);
//         }
//       }else{
//         partialQRAmt = 0.0;
//       }
//
//       if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
//         if (recPaymentController.text.isNotEmpty) {
//           receiveAmt = double.parse(recPaymentController.text);
//           dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
//             int index = entry.key;
//             var data = entry.value;
//             return {
//               "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
//               "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
//               "NoteAmt": amounts[index],
//               "RetNoteQty": qtyControllerReturn[index].text.isNotEmpty ? int.tryParse(qtyControllerReturn[index].text) : 0, // Replace with actual value if available
//               "RetNoteAmt":amountsReturn[index], // Replace with actual value if available
//             };
//           }).toList();
//         }
//       }else{
//         receiveAmt = 0.0;
//         dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
//           int index = entry.key;
//           var data = entry.value;
//           return {
//             "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
//             "NoteQty": 0,
//             "NoteAmt":0,
//             "RetNoteQty":0, // Replace with actual value if available
//             "RetNoteAmt":0, // Replace with actual value if available
//           };
//         }).toList();
//       }
//
//       if(selectedTransMode == "Merchant QR" || selectedTransMode == "Partial"){
//         if(selectedBankName == null || selectedBankId == null){
//           showFlushBar(context, "Select Account No");
//           return;
//         }
//
//         if(TranCodeController.text.isEmpty){
//           showFlushBar(context, "Enter Transaction Code.");
//           return;
//         }
//       }
//
//       if(selectedTransMode == 'Merchant QR'){
//         if(totalAmt != partialQRAmt){
//           showFlushBar(context, "QR Receipt Amount Should Be Equals To Total Amount.");
//           return;
//         }
//       }
//
//       if(selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
//         if(finalAmountCashDeno > 0){
//           if(finalAmountCashDeno != receiveAmt){
//             showFlushBar(context, "The Entered Cash Denomination Total Should Be Equal To Received Cash Amount.");
//             return;
//           }
//         }
//       }
//
//       if(selectedTransMode == 'Cash' || selectedTransMode == 'Partial'){
//         if(cashDenominationMandatory){
//           if(finalAmountCashDeno != null || finalAmountCashDeno > 0){
//             if(finalAmountCashDeno != receiveAmt){
//               showFlushBar(context, "Cash Denomination Is Mandetory.");
//               return;
//             }
//           }else{
//             showFlushBar(context, Constants.cashDenominationIsMandatory);
//             return;
//           }
//         }
//       }
//       if (selectedTransMode == 'Cash') {
//         tranCode = "";
//         times = "";
//         transRemark = "";
//         selecteBankIDApi = 0;
//         selectedBankName = "";
//         selectedBankId = "0";
//         accMappingId = 0;
//       } else if (selectedTransMode == 'Merchant QR') {
//         dataCashDenomination = [];
//       }
//
//       if (selectedTransMode == "Partial") {
//         if (receiveAmt <= 0 || partialQRAmt <= 0 || (receiveAmt + partialQRAmt != totalAmt)) {
//           String errorMessage = (receiveAmt <= 0 || partialQRAmt <= 0)
//               ? "Both Cash Receipt Amount And QR Amount Should Be Greater Than Zero."
//               : "The Entered Receipt Payment Amount Should Be Equal To Total Amount.";
//
//           showFlushBar(context, errorMessage);
//           return;
//         }
//       }
//
//       if (selectedTransMode == "Cash") {
//         if (receiveAmt != totalAmt) {
//           showFlushBar(context, "The Entered Receipt Payment Amount Should Be Equal To Total Amount.");
//           return;
//         }
//       }
//
//       if(selectedTransMode == "Merchant QR"){
//         payMode = "Bank";
//       }else if(selectedTransMode == "Cash"){
//         payMode = "Cash";
//       }else if(selectedTransMode == 'Partial'){
//         payMode = "Partial";
//       }else{
//         payMode = "";
//       }
//     }
//
//
//     List<Map<String, dynamic>> itemDetails = [];
//
//     for (var item in items) {
//       int index = items.indexOf(item);
//       String? selectedItemName = _selectedItems[index];
//
//       // Skip empty rows (no item selected or quantity is 0)
//       if (selectedItemName == null || selectedItemName.isEmpty || item['qty']?.text == '0') {
//         continue; // Skip this iteration and go to the next row
//       }
//
//       // Find selected item details from the master list
//       GetArbItemMasterListModel selectedItem = _items.firstWhere(
//             (model) => model.itemName == selectedItemName,
//         orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
//       );
//
//       int? currentStock = getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
//       _itemStockByIndex[index] = currentStock;
//
//       int itemId = selectedItem.itemId?.toInt() ?? 0;
//       int qty = int.tryParse(item['qty']?.text ?? '0') ?? 0;
//
//       // Debugging prints
//       debugPrint("selectedItem.categoryName: ${selectedItem.categoryName}");
//       debugPrint("qty: $qty");
//       debugPrint("currentStock: $currentStock");
//
//       // Check if the selected item is not a "Non ARB Item"
//       if (selectedItem.categoryName != "Non ARB Item") {
//         // Condition 1: Quantity must be greater than 0
//         if (qty <= 0) {
//           showFlushBar(context, "Quantity must be greater than 0 for item ${selectedItem.itemName}");
//           return; // Exit the function immediately if the quantity is invalid
//         }
//
//         // Condition 2: Quantity must not exceed available stock
//         if (qty > currentStock!) {
//           showFlushBar(context, "Quantity exceeds available stock for item ${selectedItem.itemName}");
//           return; // Exit the function immediately if the quantity exceeds stock
//         }
//       }else{
//         if (qty <= 0) {
//           showFlushBar(context, "Quantity must be greater than 0 for item ${selectedItem.itemName}");
//           return; // Exit the function immediately if the quantity is invalid
//         }
//       }
//
//       // Only add valid items to the list
//       if (itemId > 0 && qty > 0) {
//         itemDetails.add({
//           'ItemId': selectedItem.itemId ?? '',
//           'Rate': item['rate']?.text ?? '',
//           'ItemQty': item['qty']?.text ?? '',
//           'DiscountAmt': item['discount']?.text ?? '',
//           'ARBAmount': item['amt']?.text ?? '',
//         });
//       }
//     }
//
//     if(selectedTranssvItemName == "14.2 KG"){
//       if(selectedTransacc == "RC" || selectedTransacc == "NC"){
//         if(itemDetails.isEmpty){
//           showFlushBar(context, "Add ARB Item.");
//           return;
//         }
//       }else{
//         if(itemDetails.isEmpty){
//           itemDetails.add({
//             'ItemId': 0 ?? '',
//             'Rate': '' ?? '',
//             'ItemQty': '' ?? '',
//             'DiscountAmt': '' ?? '',
//             'ARBAmount': '' ?? '',
//           });
//         }
//       }
//     }else{
//       if(itemDetails.isEmpty){
//         itemDetails.add({
//           'ItemId': 0 ?? '',
//           'Rate': '' ?? '',
//           'ItemQty': '' ?? '',
//           'DiscountAmt': '' ?? '',
//           'ARBAmount': '' ?? '',
//         });
//       }
//     }
//
//     int? bankId;
//     int? accMappingIds;
//     if(selectedBankName != null) {
//       bankId = selecteBankIDApi;
//       accMappingIds = accMappingId;
//     }else{
//       bankId = 0;
//       accMappingIds = 0;
//     }
//     int? isExpted;
//     if(isExemptedReticulated == true){
//       debugPrint("isExemptedReticulated1 $isExemptedReticulated");
//       isExpted = 1;
//     }else if(isExemptedReticulated == false){
//       debugPrint("isExemptedReticulated0 $isExemptedReticulated");
//       isExpted = 0;
//     }else{
//
//     }
//     final Map<String, dynamic> requestBody = {
//       "PSVId": psvID,
//       "DistributorId":distributorIds,
//       "SVDate": formattedDate,
//       "ReferredById": selectedReferredID ?? '',
//       "OtherName":selectedReferredName ?? '',
//       "ProductId": selectedProductID ?? '',
//       "ProductName":selectedTranssvItemName ?? '' ,
//       "IsUndocument":isSVPending,
//       "SvType":(selectedTransacc == "Name Change"?"NameChange":selectedTransacc) ?? '',
//       "CylQty": cylinderQty ?? '',
//       "ScRegulator":scRegulators,
//       "DepositCyl": cylDeposit,
//       "CylRefillRSP": cylRefillRSP,
//       "RegulatorDeposit": regDeposit,
//       "StampDuty": stampD,
//       "FtlRegulator": selectedFTLRegQty ?? 0,
//       "BasicAmt": basicAmt,
//       "ConsuDCNo": conDSNo ??'',
//       "ConsumerName": consName ?? '',
//       "ConsuContactNo": conCont ??'',
//       "TotalAmount": totalAmt,
//       "ReceiptAmt": receiveAmt,
//       "QRReceiptAmt":partialQRAmt,
//       "PaymentMode": payMode ??'',
//       "TransactionCode": tranCode ?? '',
//       "TransactionTime": times ?? '',
//       "TransactionRemark": transRemark ?? '',
//       "AddedBy": userId,
//       "Action": actionMode,
//       "ItemId": 0,
//       "ItemName": '',
//       "Rate": '',
//       "ItemQty": '',
//       "DiscountAmt": arbTotalDiscount??'',
//       "SVDiscountAmt": discountAmt ??'',
//       "ConsuAddress": conAddress ?? '',
//       "InvoiceType": invoiceAutoManualMandatory ? "Auto" : "Manual",
//       "InvoiceNo": invoiceNo ?? '',
//       "ArbAmount": arbTotalAmount??'',
//       "ItemDataList": itemDetails,
//       "DenomDtList": dataCashDenomination,
//       "AmtCharges": nameChangeCharges,
//       "BankId": bankId,
//       "BankMappingId": accMappingIds,
//       "IsExemptReti": isExpted ??'',
//     };
//
//     print("DepositCashAddEdit: ${requestBody}");
//     requestBody.forEach((key, value) {
//       print('$key: $value');
//     });
//     // try {
//     final response = await http.post(
//       Uri.parse('${AppUrl.PendingSVAddEdit_Mob}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $bearerToken",
//       },
//       body: json.encode(requestBody),
//     );
//     // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
//     print(
//         "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");
//     requestBody.forEach((key, value) {
//       print('$key: $value');
//     });
//     print("Response UpdateSaleAddEditForMob: ${response.body}");
//     // Handling response
//     if (response.statusCode == 200) {
//       if(response == -1 || response.body == -1 || response == "-1" || response.body == "-1"){
//         EasyLoading.showToast(Constants.expenseExistMgr,
//             duration: const Duration(milliseconds: 3000));
//       }else if(response == 0 || response.body == 0 || response == "0" || response.body == "0"){
//         EasyLoading.showToast(Constants.failToInserRecord,
//             duration: const Duration(milliseconds: 3000));
//       }else{
//         Future.delayed(Duration(milliseconds: 300), () {
//           if (actionMode == "DELETE") {
//             EasyLoading.showToast(
//               Constants.expenseSendMgrDelete,
//               duration: const Duration(milliseconds: 3000),
//             );
//           }else if(actionMode == "EDIT") {
//             EasyLoading.showToast(
//               Constants.expenseSendMgrEdit,
//               duration: const Duration(milliseconds: 3000),
//             );
//           }else {
//             EasyLoading.showToast(
//               Constants.expenseSendMgr,
//               duration: const Duration(milliseconds: 3000),
//             );
//           }
//         });
//         Navigator.pushNamed(
//           context,
//           SVSaleReportScreen.screenName,
//           //arguments: 3, // This opens the third tab
//         );
//         setState(() {
//           fetchItemSvAddEditList();
//         });
//       }
//     } else {
//       // Error response
//       print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
//     }
//   }
//
//   void calculateGrandTotalAmount() {
//     // 1. Parse the fixed components
//     double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
//     double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
//     double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
//     double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
//     double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;
//     double nameChangeAmt = double.tryParse(nameChangeAmtChargesController.text) ?? 0;
//     double fixedTotal=0;
//     if(selectedTransacc == "Name Change"){
//       fixedTotal = nameChangeAmt;
//     }else{
//       fixedTotal = deposit + refill + regulator + stampDuty - discountAmt;
//       print("Grand Total: $deposit $refill $regulator $stampDuty $discountAmt");
//     }
//     // 2. Sum up item amounts from the ListView
//     double dynamicItemTotal = 0.0;
//     double dynamicItemTotalD = 0.0;
//     for (int i = 0; i < items.length; i++) {
//       final amtText = items[i]['amt']?.text ?? '';
//       final amt = double.tryParse(amtText) ?? 0.0;
//       dynamicItemTotal += amt;
//     }
//     for (int i = 0; i < items.length; i++) {
//       final amtTextD = items[i]['discount']?.text ?? '';
//       final amtD = double.tryParse(amtTextD) ?? 0.0;
//       dynamicItemTotalD += amtD;
//     }
//     // 3. Final total
//     double grandTotal = fixedTotal + dynamicItemTotal;
//     arbTotalAmount = dynamicItemTotal;
//     arbTotalDiscount = dynamicItemTotalD;
//     // 4. Update your final total somewhere (optional)
//     print("Grand Total: $grandTotal");
//
//     // Example: update a controller if needed
//     totalAmountController.text = grandTotal.toStringAsFixed(2);
//   }
//
//   void calculateGrandTotalAmountDepositMinus() {
//     // 1. Parse the fixed components
//     double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
//     double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
//     double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
//     double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
//     double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;
//
//     double fixedTotal = deposit + refill + regulator + stampDuty - discountAmt - regulator;
//
//     // 2. Sum up item amounts from the ListView
//     double dynamicItemTotal = 0.0;
//     double dynamicItemTotalD = 0.0;
//     for (int i = 0; i < items.length; i++) {
//       final amtText = items[i]['amt']?.text ?? '';
//       final amt = double.tryParse(amtText) ?? 0.0;
//       dynamicItemTotal += amt;
//     }
//
//     for (int i = 0; i < items.length; i++) {
//       final amtTextD = items[i]['discount']?.text ?? '';
//       final amtD = double.tryParse(amtTextD) ?? 0.0;
//       dynamicItemTotalD += amtD;
//     }
//
//     // 3. Final total
//     double grandTotal = fixedTotal + dynamicItemTotal;
//     arbTotalAmount = dynamicItemTotal;
//     arbTotalDiscount = dynamicItemTotalD;
//     // 4. Update your final total somewhere (optional)
//     print("Grand Total: $grandTotal");
//
//     // Example: update a controller if needed
//     totalAmountController.text = grandTotal.toStringAsFixed(2);
//   }
//
//   void cancelAction(){
//     selectedStaff = null;
//     selectedMaster = null;
//     selectedTransacc = null;
//     selectedTransMode = null;
//     _selectBankModel = null;
//     selectedBankName = null;
//     selectedBankId = null;
//     selecteBankIDApi = 0;
//     accMappingId = 0;
//     _selectedIndex = 0;
//     arbTotalAmount = 0;
//     arbTotalDiscount = 0;
//     stampDuty = 0;
//     selectedTransMode = null;
//     selectedTransacc = null;
//     selectedTranssvItemName = null;
//     selectedProductID = 0;
//     selectedTranqty = null;
//     cylinderQty = 0;
//     depositAmount = 0;
//     refillAmountCyl = 0;
//     getRegulatorDepositAmountFromApi = 0;
//     _isConsumerEmpty = false;
//     _isConCOntactEmpty = false;
//     _isInvalidMobile = false;
//     _isShortLength = false;
//     _isTranscode = false;
//     amounts = [];
//     amountsReturn = [];
//     totalAmount = 0.0;
//     returnAmount = 0.0;
//     finalAmountCashDeno = 0.0;
//     isQtyFilled = {};
//     getSelectedFTLRegulatorQtyString = null;
//     selectedFTLRegQty = 0;
//     isCashDenominationListViewVisible = false;
//     isSVPending = false;
//     isExemptedReticulated = false;
//     _selectedIndex = 0;
//     arbTotalAmount = 0;
//     stampDuty = 0;
//     selectedReferredID = 0;
//     selectedReferredName = null;
//     conNameController.clear();
//     conContactController.clear();
//     conNoController.clear();
//     recPaymentController.clear();
//     stampDutyController.clear();
//     TranCodeController.clear();
//     timeController.clear();
//     transReviewController.clear();
//     rateController.clear();
//     QtyController.clear();
//     discountController.clear();
//     amtController.clear();
//     scRegulatorController.clear();
//     depositCylinderAmountController.clear();
//     refillCylinderAmountController.clear();
//     regulatorDepositAmountController.clear();
//     regulatorBasicAmountController.clear();
//     regulatorDiscountAmountController.clear();
//     cylinderQtyAddController.clear();
//     totalAmountController.clear();
//     nameChangeAmtChargesController.clear();
//     Navigator.pop(context);
//     Navigator.pushNamed(
//         context,
//         SVSaleReportScreen.screenName// This opens the third tab
//     );
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     EasyLoading.instance
//       ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
//       ..loadingStyle = EasyLoadingStyle.light
//       ..dismissOnTap = false // Disable dismissing the loader by tapping
//       ..userInteractions = false;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//           // Pass bearer token in headers
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> checkCashDenominationFlagMandatory() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//
//     if (!Constants.isNetworkAvailable) {
//       showFlushBar(context, Constants.connectionMessage);
//       isLoading = false;
//     } else {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? distributorId = prefs.getString('DistributorId');
//         String? bearerToken = prefs.getString('token');
//
//         if (bearerToken == null) {
//           isLoading = false;
//           throw Exception('Bearer token is missing');
//         }
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//           },
//         );
//         debugPrint("Response body GetPageActionPermissionDtls: ${response.body}");
//         debugPrint("Request body GetPageActionPermissionDtls: ${response.request}");
//
//         if (response.statusCode == 200) {
//           // Parse the JSON response
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             cashDenoMandatoryList = data.map((jsonItem) =>
//                 CahsDenominationMandatoryFlagModel.fromJson(jsonItem)).toList();
//             isLoading = false;
//             for (var item in cashDenoMandatoryList) {
//               if (item.distributorId.toString() == distributorId && item.permissionFor == "Cash Denomination" && item.isActive == 1) {
//                 print("Flag truet:");
//                 cashDenominationMandatory = true;
//                 break; // Exit loop after finding the match
//               }else{
//                 cashDenominationMandatory = false;
//               }
//             }
//           });
//         } else {
//           isLoading = false;
//           throw Exception('Failed to load sales data');
//         }
//       } catch (error) {
//         isLoading = false;
//         debugPrint("Error: $error");
//         // Return an empty list in case of an error
//       }
//     }
//   }
//
//   Future<void> CheckSVConsumerNoStatus() async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? staffId = prefs.getString('StaffId');
//     String? userId = prefs.getString("UserId");
//     int? addedBys = int.parse(staffId!);
//     int? distributorIds = int.parse(distributorId!);
//     final DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//     String? conDSNo;
//
//     if(selectedTranssvItemName == null){
//       showFlushBar(context, "Select Product.");
//       return;
//     }
//
//     if(selectedTransacc == null){
//       showFlushBar(context, "Select SV Type.");
//       return;
//     }
//
//     if(conNoController.text.isNotEmpty){
//       conDSNo = conNoController.text;
//     }
//
//     final Map<String, dynamic> requestBody =
//     {
//       "DistributorId": distributorId,
//       "ConsumerNo": conDSNo ?? '',
//       "ItemId": selectedProductID ?? '',
//       "SVType": selectedTransacc ?? '',
//     };
//     print("CheckSVConsumerNoStatus: ${requestBody}");
//     requestBody.forEach((key, value) {
//       print('$key: $value');
//     });
//     // try {
//     final response = await http.post(
//       Uri.parse('${AppUrl.CheckSVConsumerNoStatus}'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $bearerToken",
//       },
//       body: json.encode(requestBody),
//     );
//     print(
//         "requestBody CheckSVConsumerNoStatus: ${response.statusCode} - ${response.request}${requestBody}");
//
//     print("Response Status Code: ${response.statusCode}");
//
//     if (response.statusCode == 200) {
//       if (response.body == '0') {
//
//         print("Success ${response.body}");
//
//         // EasyLoading.showToast("Save Con. No Successfully", duration: const Duration(milliseconds: 3000));
//       } else if (response.body == '-1') {
//         print("API Response: -1 (Consumer No exists with same SV type and delivered)");
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return   AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.red), // Add the icon here
//                   SizedBox(width: 8), // Space between icon and text
//                   Text('Consumer/DC No Not Allowed'),
//                 ],
//               ),
//               content: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Entered consumer dc no is already exists with same SV type and delivered also, please check and re-enter",
//                     ),
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     conNoController.clear();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else if (response.body == '-2') {
//         print("API Response: -2 (Consumer No exists with same SV type)");
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return
//               AlertDialog(
//                 title: Row(
//                   children: [
//                     Icon(Icons.error, color: Colors.red), // Add the icon here
//                     SizedBox(width: 8), // Space between icon and text
//                     Text('Consumer DC No Not Allowed'),
//                   ],
//                 ),
//                 content: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Entered consumer dc no is already exists with same SV type, please check and re-enter",
//                       ),
//                     ),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       conNoController.clear();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//           },
//         );
//       } else {
//         EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
//         print("Error: Response returned 0");
//       }
//     } else {
//       print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
//       EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
//     }
//   }
//
//   double remainingAmount = 0.0;
//
//   void updateRemainingAmount() {
//     double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
//     double qrAmount = double.tryParse(partialQRController.text) ?? 0.0;
//     double cashAmount = double.tryParse(recPaymentController.text) ?? 0.0;
//
//     setState(() {
//       if (isEditingQR) {
//         remainingAmount = totalAmount - qrAmount;
//         if (remainingAmount < 0) remainingAmount = 0.0;
//         recPaymentController.text = remainingAmount.toStringAsFixed(2);
//       } else if (isEditingCash) {
//         remainingAmount = totalAmount - cashAmount;
//         if (remainingAmount < 0) remainingAmount = 0.0;
//         partialQRController.text = remainingAmount.toStringAsFixed(2);
//       }
//     });
//   }
//
//   Future<void> InvoiceAutoManualFlagMandatory() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//
//     if (!Constants.isNetworkAvailable) {
//       showFlushBar(context, Constants.connectionMessage);
//       return;
//     }
//
//     try {
//       setState(() => isLoading = true);
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//
//       if (bearerToken == null || distributorId == null) {
//         throw Exception('Token or DistributorId missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
//         headers: {'Authorization': 'Bearer $bearerToken'},
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to load permission data');
//       }
//
//       final List<dynamic> data = json.decode(response.body);
//
//       autoMnualList = data
//           .map((e) => CahsDenominationMandatoryFlagModel.fromJson(e))
//           .toList();
//
//       // âœ… STRICTLY FIND AUTO
//       final autoInvoiceItem = autoMnualList.firstWhere(
//             (item) =>
//         item.distributorId.toString() == distributorId &&
//             item.permissionFor == "Invoice Number" &&
//             item.invoiceType == "Auto",
//         orElse: () => CahsDenominationMandatoryFlagModel(),
//       );
//
//       debugPrint("InvoiceType: ${autoInvoiceItem.invoiceType}");
//       debugPrint("FromInvoiceNo: ${autoInvoiceItem.fromInvoiceNo}");
//
//       // setState(() {
//       //   isLoading = false;
//       //   //
//       //   // if (autoInvoiceItem.invoiceType == "Auto" &&
//       //   //     autoInvoiceItem.fromInvoiceNo != null) {
//       //   //   invoiceAutoManualMandatory = true;
//       //   //   invNoController.text =
//       //   //       autoInvoiceItem.fromInvoiceNo.toString();
//       //   //   _isInvoiceEmpty = false;
//       //   // }
//       //   if (autoInvoiceItem.invoiceType == "Auto") {
//       //     invoiceAutoManualMandatory = true;
//       //
//       //     // ðŸ”¥ CALL INVOICE GENERATE API HERE
//       //     getInvoiceGenerateNewNoForSVSale("Auto");
//       //   }else {
//       //     invoiceAutoManualMandatory = false;
//       //     invNoController.clear();
//       //   }
//       // });
//       setState(() {
//         isLoading = false;
//
//         if (autoInvoiceItem.invoiceType == "Auto") {
//           invoiceAutoManualMandatory = true;
//         } else {
//           invoiceAutoManualMandatory = false;
//           invNoController.clear();
//         }
//       });
//
//       if (autoInvoiceItem.invoiceType == "Auto") {
//         getInvoiceGenerateNewNoForSVSale("Auto");
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       debugPrint("Error111: $e");
//     }
//   }
//
//   // Future<void> getInvoiceGenerateNewNoForSVSale(String invType) async {
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? bearerToken = prefs.getString('token');
//   //
//   //     if (bearerToken == null) {
//   //       throw Exception("Token missing");
//   //     }
//   //
//   //     final response = await http.get(
//   //       Uri.parse('${AppUrl.InvoiceGenerateNewNoForSVSale}/$distributorId/$invType'),
//   //       headers: {
//   //         'Authorization': 'Bearer $bearerToken',
//   //         'Content-Type': 'application/json',
//   //       },
//   //     );
//   //
//   //     if (response.statusCode != 200) {
//   //       throw Exception('Failed to generate invoice number');
//   //     }
//   //
//   //     final data = json.decode(response.body);
//   //
//   //     debugPrint("Generated Invoice: $data");
//   //
//   //     setState(() {
//   //       invNoController.text = data['invoiceNo'].toString();
//   //       _isInvoiceEmpty = false;
//   //       invoiceAutoManualMandatory = true;
//   //     });
//   //   } catch (e) {
//   //     debugPrint("Invoice Generate Error: $e");
//   //     showFlushBar(context, "Unable to generate invoice number");
//   //   }
//   // }
//
//   Future<void> getInvoiceGenerateNewNoForSVSale(String invType) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//
//       if (bearerToken == null || distributorId == null) {
//         throw Exception("Token or DistributorId missing");
//       }
//
//       final response = await http.get(
//         Uri.parse(
//           '${AppUrl.InvoiceGenerateNewNoForSVSale}/$distributorId/$invType',
//         ),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to generate invoice number');
//       }
//
//       // âœ… API RETURNS PLAIN VALUE (e.g. 90008)
//       final invoiceNo = response.body.replaceAll('"', '');
//
//       debugPrint("Generated Invoice: $invoiceNo");
//
//       setState(() {
//         invNoController.text = invoiceNo;
//         _isInvoiceEmpty = false;
//         invoiceAutoManualMandatory = true;
//       });
//     } catch (e) {
//       debugPrint("Invoice Generate Error: $e");
//       showFlushBar(context, "Unable to generate invoice number");
//     }
//   }
// }
//
//
