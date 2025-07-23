import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'SVSaleModel/GetAddEditDataSVSaleItemModel.dart';
import 'SVSaleModel/GetArbCurrentStockListModel.dart';
import 'SVSaleModel/GetDenominationListForAddEdit.dart';
import 'SVSaleModel/GetDistStampDutyModel.dart';
import 'SVSaleModel/GetItemMasterListModel.dart';
import 'SVSaleModel/GetRSPDetailsListModel.dart';
import 'SVSaleModel/GetStaffDetailsListModel.dart';

class SVSaleReportScreen extends StatefulWidget {
  static const screenName = '/svSaleReportScreen';

  const SVSaleReportScreen({super.key});

  @override
  State<SVSaleReportScreen> createState() => _SVSaleReportScreen();
}

class _SVSaleReportScreen extends State<SVSaleReportScreen> {
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
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
  List<double> amounts = [];
  List<double> amountsReturn = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<String> getTransMode = ["Cash", "Online"];
  List<GetAddEditDataSvSaleItemModel> receiptList = [];
  List<GetDenominationListForAddEdit> getDenominationLis = [];

  // List<String> getTransacc = ["NC", "RC", "DBC", "Name Change"];
  List<String> getTransacc = ["NC", "RC", "DBC", "Name Change"];
  List<String> getTransqty = ["1", "2"];
  List<String> getSelectedFTLRegulatorQty = ["0", "1"];
  String? getSelectedFTLRegulatorQtyString;
  int? selectedFTLRegQty;
  List<Map<String, TextEditingController>> items = [];
  int? arbCurrentStock;
  Map<int, int?> _itemStockByIndex = {};
  Map<int, int?> _selectedItemIds = {};
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
  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
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

    Future.delayed(Duration.zero, ()  async {
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
        selectedProductID = int.parse(productIdEdit);
        cylinderQty = int.parse(cylQtyEdit);

        depositCylinderAmountController.text = depositCylEdit;
        refillCylinderAmountController.text = cylRefillRSPEdit;
        debugPrint("regulatorDepositEdit $regulatorDepositEdit");
        if(regulatorDepositEdit.isEmpty || regulatorDepositEdit == null || regulatorDepositEdit == "null"){
          regulatorDepositAmountController.text = "0";
        }else{
          regulatorDepositAmountController.text = regulatorDepositEdit;
        }

        stampDutyController.text = stampDutyEdit;
        regulatorDiscountAmountController.text = sVDiscountAmtEdit;
        regulatorBasicAmountController.text = basicAmtEdit;
        conNoController.text = consuDCNoEdit;
        conNameController.text = consumerNameEdit;
        conContactController.text = consuContactNoEdit;
        recPaymentController.text = receiptAmtEdit;
        TranCodeController.text = transactionCodeEdit;
        timeController.text = transactionTimeEdit;
        transReviewController.text = transactionRemarkEdit;
        totalAmountController.text = totalAmountEdit;

        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if(paymentModeEdit == "Bank") {
          selectedTransMode = 'Online';// fallback or handle invalid values
        }else{
          selectedTransMode = null;
        }
        await getStaffDetailsList();
        getStaffDetailsList().whenComplete((){
          debugPrint("referredByNameEdit:$referredByNameEdit");
          if(referredByNameEdit != "null" && referredByNameEdit.isNotEmpty && referredByNameEdit != null){
            setState(() {
              selectedStaff = staffdetailsmodel.firstWhere(
                    (item) => item.staffName == referredByNameEdit,
                orElse: () => GetStaffDetailsListModel(staffName: ''),
              );
              selectedReferredID = int.parse(referredByIdEdit);
              selectedReferredName = referredByNameEdit;
            }
            );
          }
        });

        // fetchBank().whenComplete((){
        //   debugPrint("empty:$accountNoEdit");
        //   if(accountNoEdit != "null" && accountNoEdit.isNotEmpty && accountNoEdit != null){
        //     setState(() {
        //       _selectBankModel = bankModel.firstWhere(
        //             (item) => item.accountNo == accountNoEdit,
        //         orElse: () => GetBankMappingDetailsListModel(accountNo:'', ),
        //       );
        //     });
        //   }
        // });
        await fetchBank(); // wait for data first
        if (accountNoEdit.isNotEmpty && accountNoEdit != "null") {
          final match = bankModel.firstWhere(
                (item) => item.accountNo?.trim() == accountNoEdit.trim(),
            orElse: () => GetBankMappingDetailsListModel(), // fallback empty object
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
        getItemMasterList().whenComplete((){
          debugPrint("productNameEdit:$productNameEdit");
          if(productNameEdit != "null" && productNameEdit.isNotEmpty && productNameEdit != null){
            setState(() {
              selectedMaster = masterListModel.firstWhere(
                    (item) => item.itemName == productNameEdit,
                orElse: () => GetItemMasterListModel(itemId: 0, itemName: ''),
              );
              selectedTranssvItemName = productNameEdit;
            });
          }
        });
        if(isUndocumentEdit == "true"){
          isSVPending = true;
        }else{
          isSVPending =  false;
        }
        debugPrint("isExemptRetiEdit$isExemptRetiEdit");
        if(isExemptRetiEdit == "1"){
          isExemptedReticulated = true;
          debugPrint("isExemptRetiEdittrue");
        }else{
          isExemptedReticulated =  false;
          debugPrint("isExemptRetiEditfalse");
        }

        if (getTransacc.contains(sVTypeEdit)) {
          selectedTransacc = sVTypeEdit;
        } else {
          selectedTransacc = null; // fallback or handle invalid values
        }
        if(productNameEdit != "14.2 KG" || isExemptRetiEdit == "1"){
          cylinderQtyAddController.text = cylQtyEdit;
        }else{
          if (getTransqty.contains(cylQtyEdit)) {
            selectedTranqty = cylQtyEdit;
          } else {
            selectedTranqty = null; // fallback or handle invalid values
          }
        }
          debugPrint("fTLRegulatorEdit $fTLRegulatorEdit");
        if (getSelectedFTLRegulatorQty.contains(fTLRegulatorEdit)) {
          getSelectedFTLRegulatorQtyString = fTLRegulatorEdit;
        } else {
          getSelectedFTLRegulatorQtyString = null; // fallback or handle invalid values
        }

        loadDenominationData(psvIdEdit!);
        // _initializeItems(itemsToShow);
        if (itemsToShow.isNotEmpty) {
          _initializeItems(itemsToShow);
        } else {
          // If no initial data, start with an empty list or default values
          _initializeItems([]);
        }
        if(getDenominationLis.isNotEmpty){
          initializeControllers();
        }else{
          debugPrint("empty");
        }
      }
    });
  }

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
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

  // void _addNewItem() {
  //   setState(() {
  //     int newIndex = items.length;
  //     items.add({
  //       'rate': TextEditingController(),
  //       'qty': TextEditingController(),
  //       'discount': TextEditingController(),
  //       'amt': TextEditingController(),
  //     });
  //     _selectedItems[newIndex] = null; // Initializing the new index
  //   });
  // }
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
          'rate':
          TextEditingController(text: item.rate?.toString() ?? ''),
          'qty': TextEditingController(text: item.itemQty?.toString() ?? ''),
          'discount': TextEditingController(text: item.discountAmt?.toString() ?? ''),
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
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
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
        appBar: CustomAppBarManager(
          title: 'SV Sale', // Title or hint text for the text field
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5.0, right: 5, top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: countTextWidgetTextcash(context, 'SV Date')),
                    Flexible(flex: 1, child: Text("$formattedDate")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: countTextWidgetTextcash(context, 'Referred By')),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<GetStaffDetailsListModel>(
                        key: formKey1,
                        // value: selectedStaff,
                        value: staffdetailsmodel.contains(selectedStaff) ? selectedStaff : null,
                        // This should be a GetStaffDetailsListModel? variable
                        items: staffdetailsmodel
                            .map((GetStaffDetailsListModel staff) {
                          return DropdownMenuItem<GetStaffDetailsListModel>(
                            value: staff,
                            child: Text(
                                staff.staffName ?? ''), // Use a default if null
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStaff = value;
                            selectedReferredID = value?.staffId!.toInt();// value is of type GetStaffDetailsListModel?
                            selectedReferredName = value?.staffName!.toString();// value is of type GetStaffDetailsListModel?
                         debugPrint("selectedReferredID $selectedReferredID");
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: countTextWidgetTextStar(
                        context,
                        'Select Product',
                        showAsterisk:
                            true, // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child:
                          // DropdownButtonFormField<GetItemMasterListModel>(
                          //   key: formKey2,
                          //   value: selectedMaster,
                          //   // This should be a GetStaffDetailsListModel? variable
                          //   items:
                          //   masterListModel.map((GetItemMasterListModel staff) {
                          //     return DropdownMenuItem<GetItemMasterListModel>(
                          //       value: staff,
                          //       child: Text(
                          //           staff.itemName ?? ''), // Use a default if null
                          //     );
                          //   }).toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectedMaster = value!;
                          //       debugPrint("selectedMasteritemType: ${selectedMaster?.itemSubType}");// value is of type GetStaffDetailsListModel?
                          //     });
                          //   },
                          //   isExpanded: true,
                          // )
                          // Dropdown 1 - for selectedMaster
                          DropdownButtonFormField<GetItemMasterListModel>(
                        key: formKey2,
                        value: masterListModel.contains(selectedMaster) ? selectedMaster : null,

                        items:
                            masterListModel.map((GetItemMasterListModel staff) {
                          return DropdownMenuItem<GetItemMasterListModel>(
                            value: staff,
                            child: Text(staff.itemName ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMaster = value!;
                            selectedTranssvItemName = selectedMaster?.itemName;
                            selectedProductID = selectedMaster?.itemId?.toInt();
                            int? itemIds = selectedMaster?.itemId?.toInt();
                            depositAmount = getDepositAmountByItemId(itemIds)?.toDouble();
                            refillAmountCyl = getRefillAmountByItemId(itemIds)?.toDouble();
                            debugPrint(
                                "selectedMaster itemSubType: ${selectedMaster?.itemSubType}");
                            debugPrint("depositAmount: ${depositAmount}");
                            depositCylinderAmountController.text = depositAmount.toString();
                            refillCylinderAmountController.text = refillAmountCyl.toString();
                            // Based on selectedMaster's itemSubType, adjust the value of selectedTransacc
                            if (selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM") {
                              selectedTransacc =
                                  "NC"; // Automatically set "NC" when "ND" is selected
                            } else {
                              selectedTransacc =
                                  null; // Clear the selected value in selectedTransacc for other itemSubType
                            }
                            // ✅ Clear list view data
                            items.clear();
                            _selectedItems.clear();
                            _itemStockByIndex.clear();
                            _selectedItemIds.clear();
                            _addNewItem();
                            cylinderQtyAddController.clear();
                            selectedTranqty = null;
                            debugPrint("getRegulatorDepositAmountFromApi.toString()${getRegulatorDepositAmountFromApi.toString()}");
                            if(modes == "Edit"){
                              getRegulatorDepositAmountFromApi =
                                  getRefillAmountByItemName("SC REGULATOR")?.toDouble();
                              calculateBasicAmountSum();
                              calculateGrandTotalAmount();
                            }else{
                              calculateBasicAmountSum();
                              calculateGrandTotalAmount();
                              regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                            }
                            // if(selectedTranssvItemName == "19 KG"){
                            //   regulatorDepositAmountController.text = "0.0";
                            //   calculateBasicAmountSum();
                            //   calculateGrandTotalAmount();
                            // }else{
                            //   calculateBasicAmountSum();
                            //   calculateGrandTotalAmount();
                            //   regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                            // }
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // You can adjust this to fit your layout
                  children: [
                    Expanded(
                      child: countTextWidgetTextStar(
                        context,
                        'Select SV Type',
                        showAsterisk:
                            true, // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child:
                          // DropdownButtonFormField<String>(
                          //   key: formKey5,
                          //   value: selectedTransacc,
                          //   // Bind the selected value
                          //   items: getTransacc
                          //       .map((String value) => DropdownMenuItem<String>(
                          //     value: value,
                          //     child: Text(value),
                          //   ))
                          //       .toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectedTransacc =
                          //           value;
                          //       debugPrint("selectedTransacc: $selectedTransacc");// Update the selected value
                          //     });
                          //   },
                          //   isExpanded: true,
                          // ),
                          DropdownButtonFormField<String>(
                        key: formKey5,
                        value: selectedTransacc ??
                            ((selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM") ? "NC" : null),
                        items: getTransacc
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (selectedMaster?.itemSubType == "ND" || selectedTranssvItemName == "5 KG DOM")
                            ? null // disables dropdown when itemSubType is "ND"
                            : (value) {
                                setState(() {
                                  selectedTransacc = value;
                                  debugPrint(
                                      "selectedTransacc: $selectedTransacc");
                                  calculateBasicAmountSum();
                                  calculateGrandTotalAmount();

                                  if(selectedTransacc == "RC"){
                                    regulatorDepositAmountController.text = '';
                                    depositCylinderAmountController.text = '';
                                    double refillamount = refillAmountCyl! * 1;
                                    refillCylinderAmountController.text = refillamount.toString();
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();

                                  }else{
                                    if(selectedTransacc == "DBC"){
                                      depositCylinderAmountController.text = depositAmount.toString();
                                      regulatorDepositAmountController.text = '';
                                      selectedTranqty = "1";
                                      double refillamount = refillAmountCyl! * 1;
                                      refillCylinderAmountController.text = refillamount.toString();
                                      calculateBasicAmountSum();
                                      calculateGrandTotalAmount();
                                    }
                                    if(modes == "Edit"){
                                      depositAmount = getDepositAmountByItemId(selectedProductID)?.toDouble();
                                      depositCylinderAmountController.text = depositAmount.toString();
                                      getRegulatorDepositAmountFromApi = getRefillAmountByItemName("SC REGULATOR")?.toDouble();
                                      regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                                    }
                                    depositCylinderAmountController.text = depositAmount.toString();
                                    regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                                  }
                                });
                              },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                if ((selectedTransacc == "NC" ||
                    selectedTransacc == "RC" ||
                    selectedTransacc == "DBC")) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Form(
                      key: formKey7,
                      child: Wrap(
                        spacing: 0.0, // Horizontal spacing between fields
                        runSpacing: 0.0, // Vertical spacing between rows
                        children: [
                          if (selectedTransacc != "RC" &&
                              selectedTransacc != "DBC") ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // Align children to the left
                              children: [
                                Checkbox(
                                  value: isSVPending,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isSVPending = value!;
                                      debugPrint("isSVPending$isSVPending");
                                    });
                                  },
                                ),
                                Text('SV Pending'),
                                if ((selectedTransacc != "RC" &&
                                        selectedTransacc != "DBC") &&
                                    (selectedTranssvItemName == "14.2 KG")) ...[
                                  Checkbox(
                                    value: isExemptedReticulated,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isExemptedReticulated = value!;
                                        regulatorDepositAmountController.text = "0";
                                      });
                                    },
                                  ),
                                  // ),
                                  Text('Exempted/Reticulated'),
                                ]
                              ],
                            ),
                          ],
                          SizedBox(
                            width: 5,
                          ),
                          if(selectedTranssvItemName == "14.2 KG" && !isExemptedReticulated) ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child:
                              DropdownButtonFormField<String>(
                                // value: selectedTranqty,
                                value: selectedTranqty ??
                                    (selectedTransacc == "DBC" ? "1" : selectedTranqty),
                                items: getTransqty.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                // onChanged: (value)
                                onChanged: selectedTransacc == "DBC"
                                    ? null // disables dropdown when itemSubType is "ND"
                                    : (value) {
                                  setState(() {
                                    selectedTranqty = value;// Update the selected value
                                    cylinderQty = int.parse(selectedTranqty!);
                                    int? qtyV = int.parse(selectedTranqty!);
                                    double depositamount = depositAmount! * qtyV!;
                                    double refillamount = refillAmountCyl! * qtyV!;
                                    if(selectedTransacc == "RC"){
                                      refillCylinderAmountController.text = refillamount.toString();
                                      calculateBasicAmountSum();
                                      calculateGrandTotalAmount();
                                    }else{
                                      depositCylinderAmountController.text = depositamount.toString();
                                      refillCylinderAmountController.text = refillamount.toString();
                                      calculateBasicAmountSum();
                                      calculateGrandTotalAmount();
                                    }
                                  }
                                  );
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  //errorText: selectedTranqty ? 'Deposit Amt. is Required' : null, // Show error if required
                                  errorText: (selectedTranqty == null ||
                                      selectedTranqty!.isEmpty)
                                      ? 'Cyl. Qty Is Required'
                                      : null,
                                  label: countTextWidgetTextStarverysmall(
                                    context,
                                    'Select Cyl. Qty',
                                    showAsterisk:
                                    true, // Add a parameter to conditionally show the asterisk
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if(selectedTranssvItemName != "14.2 KG" || isExemptedReticulated) ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child: TextField(
                                controller: cylinderQtyAddController,
                                decoration: InputDecoration(
                                  // labelText: 'Cyl.Qty',
                                  // labelStyle: TextStyle(fontSize: 12),
                                  label: countTextWidgetTextStarverysmall(
                                    context,
                                    'Cyl.Qty',
                                    showAsterisk:
                                    true, // Add a parameter to conditionally show the asterisk
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Only digits allowed
                                  LengthLimitingTextInputFormatter(2),
                                  // Limit to 6 characters
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    String? valueQty = value;
                                    cylinderQty = int.tryParse(valueQty);
                                    int? qtyVs= int.tryParse(valueQty);
                                    double depositamounts = depositAmount! * qtyVs!;
                                    depositCylinderAmountController.text =
                                        depositamounts.toString();
                                    double refillamounts = refillAmountCyl! * qtyVs!;
                                    refillCylinderAmountController.text = refillamounts.toString();
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                  });
                                },
                              ),
                            ),
                          ],
                            if ((selectedTransacc != "DBC") &&
                              (selectedTranssvItemName == "14.2 KG")) ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child: TextField(
                                controller: scRegulatorController,
                                decoration: InputDecoration(
                                  labelText: 'SC Regulator',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                enabled: false,
                              ),
                            ),
                          ],
                          if ((selectedTranssvItemName != "14.2 KG")) ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child: DropdownButtonFormField<String>(
                                value: getSelectedFTLRegulatorQtyString,
                                items: getSelectedFTLRegulatorQty
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    getSelectedFTLRegulatorQtyString = value;// Update the selected value
                                    selectedFTLRegQty = int.parse(getSelectedFTLRegulatorQtyString!);
                                    if(selectedFTLRegQty == 0 || selectedFTLRegQty == "0"){
                                      debugPrint("selectedFTLRegQty 0");
                                      calculateBasicAmountSumDepositMinus();
                                      calculateGrandTotalAmountDepositMinus();
                                      regulatorDepositAmountController.text = "0";
                                    }else{
                                      debugPrint("selectedFTLRegQty 1");
                                      if(modes == "Edit"){
                                        getRegulatorDepositAmountFromApi = getRefillAmountByItemName("SC REGULATOR")?.toDouble();
                                        regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                                        debugPrint("selectedFTLRegQty ${getRefillAmountByItemName("SC REGULATOR")?.toDouble()}");
                                        calculateBasicAmountSum();
                                        calculateGrandTotalAmount();
                                      }else{
                                        regulatorDepositAmountController.text = getRegulatorDepositAmountFromApi.toString();
                                        calculateBasicAmountSum();
                                        calculateGrandTotalAmount();
                                      }
                                    }

                                  });
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  //errorText: selectedTranqty ? 'Deposit Amt. is Required' : null, // Show error if required
                                  errorText:
                                      (getSelectedFTLRegulatorQtyString == null ||
                                              getSelectedFTLRegulatorQtyString!
                                                  .isEmpty)
                                          ? 'FTL Regulator Is Required'
                                          : null,
                                  label: countTextWidgetTextStarverysmall(
                                    context,
                                    'Select FTL Regulator',
                                    showAsterisk:
                                        true, // Add a parameter to conditionally show the asterisk
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 32) / 2,
                            child: TextField(
                              controller: depositCylinderAmountController,
                              decoration: InputDecoration(
                                errorText:
                                    (depositCylinderAmountController.text.isEmpty)
                                        ? 'Deposit Cyl. is Required'
                                        : null,
                                label: countTextWidgetTextStarverysmall(
                                  context,
                                  'Deposit Cyl.',
                                  showAsterisk:
                                      true, // Add a parameter to conditionally show the asterisk
                                ),
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true), // Ensure numeric keyboard
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                                LengthLimitingTextInputFormatter(7),
                              ],
                              enabled:selectedTranssvItemName == "14.2 KG" && selectedTransacc == "RC"
                                  ? true
                                  : false,
                              onChanged: (value){
                                calculateBasicAmountSum();
                                calculateGrandTotalAmount();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),

        // Cyl Refill Amt.
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 32) / 2,
                            child: TextField(
                              controller: refillCylinderAmountController,
                              decoration: InputDecoration(
                                labelText: 'Cyl Refill Amt.',
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              enabled: false,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),

        // Regulator Deposit (Read-only)
                          if (selectedTransacc != "DBC") ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child: TextField(
                                // readOnly: true,
                                controller: regulatorDepositAmountController,
                                decoration: InputDecoration(
                                  errorText: (regulatorDepositAmountController
                                          .text.isEmpty)
                                      ? 'Regulator Deposit is Required'
                                      : null,
                                  label: countTextWidgetTextStarverysmall(
                                    context,
                                    'Regulator Deposit',
                                    showAsterisk:
                                        true, // Add a parameter to conditionally show the asterisk
                                  ),
                                ),
                                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                                keyboardType: TextInputType.numberWithOptions(decimal: true), // Ensure numeric keyboard
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                  LengthLimitingTextInputFormatter(7),
                                ],
                                enabled:selectedTranssvItemName == "14.2 KG" && selectedTransacc == "RC" && !isExemptedReticulated
                                    ? true
                                    : false,

                                onChanged: (value){
                                  calculateBasicAmountSum();
                                  calculateGrandTotalAmount();
                                },
                              ),
                            ),
                          ],
                          SizedBox(
                            width: 5,
                          ),
        // Stamp Duty
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 32) / 2,
                            child: TextField(
                              controller: stampDutyController,
                              // readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Stamp Duty',
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              enabled: false,
                              onChanged: (value) {
        // Handle on change
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
        // Discount Amount
                          if(selectedTranssvItemName != "14.2 KG") ...[
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 32) / 2,
                              child: TextField(
                                controller: regulatorDiscountAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Discount Amount',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    calculateBasicAmountSum();
                                    calculateGrandTotalAmount();
                                  });
                                },
                              ),
                            ),
                          ],
        // Basic Amount
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 32) / 2,
                            child: TextField(
                              controller: regulatorBasicAmountController,
                              decoration: InputDecoration(
                                labelText: 'Basic Amount',
                                labelStyle: TextStyle(fontSize: 12),
                              ),
                              enabled: false,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
                if (selectedTransacc == "Name Change") ...[
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 32) / 2,
                    child: TextField(
                      controller: nameChangeAmtChargesController,
                      decoration: InputDecoration(
                        errorText: (nameChangeAmtChargesController.text.isEmpty)
                            ? 'Amount Charges is Required'
                            : null,
                        label: countTextWidgetTextStarverysmall(
                          context,
                          'Amount Charges',
                          showAsterisk:
                              true, // Add a parameter to conditionally show the asterisk
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true), // Ensure numeric keyboard
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ],
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: countTextWidgetTextStar(
                        context,
                        'Cons No/DC No.',
                        showAsterisk: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: conNoController,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          // Allow only digits
                          FilteringTextInputFormatter.deny(
                            RegExp(r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                          ),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'\s'), // Block all whitespace including space, tab, etc.
                          ),
                        ],

                        decoration: InputDecoration(
                          labelText: 'Enter Consumer No./DC No.',
                          errorText: _isConsumerEmpty
                              ? 'Consumer No./DC No. Is Required'
                              : null, // Show error if required
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isConsumerEmpty = value.isEmpty;
                            //Please Enter A Valid Consumer Contact No.
                          });
                        },
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: countTextWidgetTextcash(context, 'Consumer Name')),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: conNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Consumer Name',
                          //  errorText: _isDepositEmpty ? 'Deposit Amt. is Required' : null, // Show error if required
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    // SizedBox(width: 8),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: countTextWidgetTextcash(
                            context, 'Consumer Contact No')),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: conContactController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Enter Consumer Contact No',
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
                              _isInvalidMobile = !RegExp(r'^[6789]')
                                  .hasMatch(value); // Check first digit
                              _isShortLength = value.length < 10;
                            } else {
                              _isInvalidMobile =
                                  false; // Reset the error if the input is empty
                              _isShortLength = false;
                            }
                          });
                          //_validateInput();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Item',
                      style: TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: _isAddNewItemEnabled ? _addNewItem : null,
                      // onPressed: _addNewItem,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          backgroundColor: Colors.blue),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text('Select Item', style: TextStyle(fontSize: 12)),
                                        SizedBox(width: 4),
                                        Icon(Icons.star, color: Colors.red, size: 10),
                                      ],
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
                                            orElse: () => GetArbItemMasterListModel());
                                        int? currentStock = getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
                                        _itemStockByIndex[index] = currentStock; // Store current stock per index
                                        _selectedItemIds[index] = selectedItem.itemId?.toInt(); // Optional if needed
                                        debugPrint("usfds ${_itemStockByIndex[index]}");
                                        double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                        double amount = rate * 0; // Replace 0 with actual quantity if available
                                        items[index]['rate']?.text = rate.toString();
                                        items[index]['amt']?.text = rate.toString();
                                        if(selectedItem.categoryName == "Non ARB Item" || selectedItem.categoryName == "Other"){
                                          items[index]['qty']?.text = "0";
                                          items[index]['discount']?.clear();
                                          print("Rate3:");
                                          _updateSum(index);
                                          calculateGrandTotalAmount();
                                          if (index == items.length - 1) {
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              _addNewItem();
                                            });
                                          }
                                        }else{
                                          int? stockLimit = _itemStockByIndex[index];
                                          if (stockLimit != null && 1 > stockLimit) {
                                            items[index]['qty']?.clear();
                                            items[index]['discount']?.clear();// Or retain but show error
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Entered quantity exceeds current stock: $stockLimit'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            print("Rate2:");
                                            _updateSum(index);
                                            calculateGrandTotalAmount();
                                            return;
                                          }else{
                                            print("Rate1:");
                                            items[index]['qty']?.text = "1";
                                            items[index]['discount']?.clear();
                                            // _addNewItem();
                                            _updateSum(index);
                                            calculateGrandTotalAmount();
                                            if (index == items.length - 1) {
                                              Future.delayed(Duration(milliseconds: 200), () {
                                                _addNewItem();
                                              });
                                            }
                                          }
                                        }
                                        print("Selected item: ${selectedItem.itemName}");
                                        print("Rate: $rate");
                                        print("Amount: $amount");
                                        calculateGrandTotalAmount();
                                        // Move focus to Discount field after short delay
                                        Future.delayed(Duration(milliseconds: 100), () {
                                          if (_discountFocusNodes.length > index) {
                                            FocusScope.of(context).requestFocus(_discountFocusNodes[index]);
                                          }
                                        });
                                      });
                                    }
                                  },
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  _removeItem(index);
                                },
                                child: Icon(Icons.delete, color: Colors.red),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Received Qty, EMR, Invoice Fields
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: items[index]['rate'],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('Rate')],
                                    ),
                                  ),
                                  enabled: false,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: items[index]['qty'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        countTextWidgetTextStar(context, 'Qty',
                                            showAsterisk: true),
                                      ],
                                    ),
                                    //errorText: items[index]['qty']?.text.isEmpty ?? true ? 'Qty is required' : null, // Error text check
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      bool isNotNull = value.isNotEmpty;
                                      int enteredQty = int.tryParse(value) ?? 0;
                                      int? stockLimit = _itemStockByIndex[index];
                                      debugPrint("stockLimit $stockLimit");
                                      if (isNotNull) {
                                        if (stockLimit != null && enteredQty > stockLimit) {
                                          items[index]['qty']?.clear(); // Or retain but show error
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Entered quantity exceeds current stock: $stockLimit'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          _updateSum(index);
                                          calculateGrandTotalAmount();
                                          return;
                                        }else{
                                          _updateSum(index);
                                          calculateGrandTotalAmount();
                                        }
                                      } else {
                                        _updateSum(index);
                                        calculateGrandTotalAmount();
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: items[index]['discount'],
                                  focusNode: _discountFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(7),
                                  ],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('Discount')],
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _updateSum(index);
                                      calculateGrandTotalAmount();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: items[index]['amt'],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Text('Amt.')],
                                    ),
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: countTextWidgetTextcash(context, 'Total Amount')),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: totalAmountController,
                        enabled: false,
                        onChanged: (value) {},
                      ),
                    ),
                    // SizedBox(width: 8),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child:
                        countTextWidgetTextStar(context, 'Receipt Payment',showAsterisk: true)),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: recPaymentController,
                        decoration: InputDecoration(
                          labelText: 'Enter Receipt Payment',
                          errorText: _isConsumerEmpty
                              ? 'Receipt Payment is Required'
                              : null, // Show error if required
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,10}')),
                        ],
                        onChanged: (value) {
                          double amt = double.parse(totalAmountController.text);
                          setState(() {
                            _isConsumerEmpty = value.isEmpty;
                            // double val = double.parse(value);
                            // if(val > amt){
                            //
                            // }
                            //Please Enter A Valid Consumer Contact No.
                          });
                        },
                      ),
                    ),
                    // SizedBox(width: 8),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: countTextWidgetTextStar(
                        context,
                        'Select Payment Mode',
                        showAsterisk:
                            true, // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        key: formKey3,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: selectedTransMode,
                        // Bind the selected value
                        items: getTransMode
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTransMode =
                                value; // Update the selected value
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      if (selectedTransMode == 'Online')
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child:
                                  DropdownButtonFormField<
                                      GetBankMappingDetailsListModel>(
                                    decoration: InputDecoration(
                                      label: countTextWidgetTextStarverysmall(
                                        context,
                                        'Select Acc No',
                                        showAsterisk:
                                        true, // Add a parameter to conditionally show the asterisk
                                      ),
                                    ),
                                    value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,

                                    items: bankModel.map((item) {
                                      return
                                        DropdownMenuItem<GetBankMappingDetailsListModel>(
                                        value: item,
                                        child: Text(
                                          '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
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
                                    // hint: Text('Select Acc No'),

                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: TranCodeController,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    // Enforce max length
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(30), // Limit to 30 characters
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                                      ),
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'\s'), // Block all whitespace including space, tab, etc.
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      errorText: _isTranscode
                                          ? 'Transaction code is Required'
                                          : null,
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          countTextWidgetTextStar(
                                            context,
                                            'Transaction Code',
                                            showAsterisk: true,
                                          ),
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _isTranscode = value.isEmpty;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: timeController,
                                    decoration: InputDecoration(
                                      labelText: 'Time',
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^[\d.:]{0,5}$'),
                                      ),
                                      // FilteringTextInputFormatter.allow(
                                      //   RegExp(r'^\d{0,5}:?$'), // up to 5 digits, optional 1 colon at end
                                      // ),
                                    ],

                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: transReviewController,
                                    decoration: InputDecoration(
                                      labelText: 'Transaction Remark',
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(250),
                                      // Limit the length to 30 characters
                                    ],
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: 10,),
                      if (selectedTransMode == 'Cash')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cashDenominationMandatory?"Cash Denomination Is Mandatory":
                              "Cash denomination",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                      if (selectedTransMode == 'Cash')
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Row(
                            children: [
                              // First Half (Cash Denomination)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 0; // Show Container 1
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 0
                                          ? Colors.blue
                                          : Colors.blue[200],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(2),
                                        bottomLeft: Radius.circular(2),
                                      ),
                                    ),
                                    child: Text(
                                      "Cash Denomination",
                                      style: Styling.buttonTextBlack.copyWith(
                                        color: _selectedIndex == 0
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Second Half (Cash Return)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = 1; // Show Container 2
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 1
                                          ? Colors.blue
                                          : Colors.blue[200],
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(2),
                                        bottomRight: Radius.circular(2),
                                      ),
                                    ),
                                    child: Text(
                                      "Cash Return",
                                      style: Styling.buttonTextBlack.copyWith(
                                        color: _selectedIndex == 1
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedTransMode == 'Cash')
                        Visibility(
                          visible: _selectedIndex == 0,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // Background color of the box
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width:
                                              1), // Optional: Add rounded corners
                                    ),
                                    child: Column(
                                      children: [
                                        // First Row with Vertical Divider
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // Center the row content
                                            children: [
                                              // First Text and Divider inside Expanded to ensure equal size
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                    child: Text(
                                                  "Note Type",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                )), // Centering the text
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                    child: Text(
                                                  "Qty",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                )), // Centering the text
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                    child: Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                )), // Centering the text
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              getNoteTypeAndIdFroDenominationListModel
                                                  .length,
                                          itemBuilder: (context, index) {
                                            final data =
                                                getNoteTypeAndIdFroDenominationListModel[
                                                    index];
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Center(
                                                        child: Text(
                                                          "${data.noteType}",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(
                                                          "X",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Center(
                                                        child: TextField(
                                                          controller:
                                                              qtyController[
                                                                  index],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              amounts[
                                                                  index] = (double
                                                                          .tryParse(
                                                                              value) ??
                                                                      0.0) *
                                                                  data.noteType!;
                                                              totalAmount =
                                                                  amounts.fold(
                                                                      0.0,
                                                                      (sum, amount) =>
                                                                          sum +
                                                                          amount);
                                                              finalAmountCashDeno =
                                                                  totalAmount -
                                                                      returnAmount;
                                                              isQtyFilled[index] =
                                                                  value
                                                                      .isNotEmpty; // Mark index as filled
                                                              debugPrint(
                                                                  "Collected$totalAmount");
                                                            });
                                                          },
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(
                                                          "=",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Center(
                                                        child: Text(
                                                          "${amounts[index].toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: Text(
                                                          "Collected:",
                                                          style: Styling
                                                              .itemBlackTestBold,
                                                          //textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 0,
                                                        child: Text(
                                                          totalAmount
                                                              .toStringAsFixed(2),
                                                          style: Styling
                                                              .itemBlackTestBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: Text(
                                                          "Final Total:",
                                                          style: Styling
                                                              .itemBlackTestBold,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 0,
                                                        child: Text(
                                                          finalAmountCashDeno
                                                              .toStringAsFixed(2),
                                                          style: Styling
                                                              .itemBlackTestBold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible: _selectedIndex == 1,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    // Background color of the box
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width:
                                            1), // Optional: Add rounded corners
                                  ),
                                  child: Column(
                                    children: [
                                      // First Row with Vertical Divider
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // Center the row content
                                          children: [
                                            // First Text and Divider inside Expanded to ensure equal size
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                  child: Text(
                                                "Note Type",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )), // Centering the text
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                  child: Text(
                                                "Qty",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )), // Centering the text
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                  child: Text(
                                                "Amount",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )), // Centering the text
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            getNoteTypeAndIdFroDenominationListModel
                                                .length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              getNoteTypeAndIdFroDenominationListModel[
                                                  index];
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        "${data.noteType}",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "X",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: TextField(
                                                        controller:
                                                            qtyControllerReturn[
                                                                index],
                                                        keyboardType:
                                                            TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            amountsReturn[
                                                                index] = (double
                                                                        .tryParse(
                                                                            value) ??
                                                                    0.0) *
                                                                data.noteType!;
                                                            returnAmount =
                                                                amountsReturn.fold(
                                                                    0.0,
                                                                    (sum, amount) =>
                                                                        sum +
                                                                        amount);
                                                            finalAmountCashDeno =
                                                                totalAmount -
                                                                    returnAmount;
                                                            debugPrint(
                                                                "return$returnAmount");
                                                          });
                                                        },
                                                        textAlign:
                                                            TextAlign.center,
                                                        enabled: !isQtyFilled
                                                                .containsKey(
                                                                    index) ||
                                                            !isQtyFilled[index]!,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "=",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: Text(
                                                        "${amountsReturn[index].toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 0,
                                                      child: Text(
                                                        "Return:",
                                                        style: Styling
                                                            .itemBlackTestBold,
                                                        //textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 0,
                                                      child: Text(
                                                        returnAmount
                                                            .toStringAsFixed(2),
                                                        style: Styling
                                                            .itemBlackTestBold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Final Total section
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 0,
                                                      child: Text(
                                                        "Final Total:",
                                                        style: Styling
                                                            .itemBlackTestBold,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 0,
                                                      child: Text(
                                                        finalAmountCashDeno
                                                            .toStringAsFixed(2),
                                                        style: Styling
                                                            .itemBlackTestBold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Cancel action
                        cancelAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical:
                                10), // Adjust padding to make button smaller
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Adds space between buttons
                    ElevatedButton(
                      onPressed: () {
                        // cancelAction();
                        if (saveFlag) {
                        print('saveFlag $saveFlag');
                        showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if(modes == "Edit"){
                            updateSVAddEditForMob(psvIdEdit!,"EDIT");
                          }else{
                            updateSVAddEditForMob(0,"ADD");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:saveFlag?Colors.grey:Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical:
                                10), // Adjust padding to make button smaller
                      ),
                      child: Text(
                        modes == "Edit"?'Update':'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Card(
                  child: receiptList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: receiptList.length,
                          itemBuilder: (context, index) {
                            GetAddEditDataSvSaleItemModel? svSale = receiptList[index];
                            return
                              Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex:1,child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(svSale.sVDate ?? '')),style: Styling.blueClrText,),),
                                      Expanded(flex:1,child: Text(svSale.productName.toString(),style: Styling.blueClrText,),),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                          children: [
                                            // Edit Icon
                                            IconButton(
                                              icon: Icon(Icons.edit, color:saveFlag?Colors.blueGrey:Colors.blue),  // Icon for edit
                                              onPressed: () {
                                                loadDenominationData(svSale.pSVId!.toInt());
                                                var itemsToShow = svSale.itemDetails?.toList();
                                                var psvID = svSale.pSVId.toString();
                                                var sVDate = svSale.sVDate.toString();
                                                var referredById = svSale.referredById.toString();
                                                var referredByName = svSale.referredByName.toString();
                                                var otherName = svSale.otherName.toString();
                                                var productId = svSale.productId.toString();
                                                var productName = svSale.productName.toString();
                                                var isUndocument = svSale.isUndocument.toString();
                                                var sVType = svSale.sVType.toString();
                                                var cylQty = svSale.cylQty.toString();
                                                var sCRegulator = svSale.sCRegulator.toString();
                                                var depositCyl = svSale.depositCyl.toString();
                                                var cylRefillRSP = svSale.cylRefillRSP.toString();
                                                var regulatorDeposit = svSale.regulatorDeposit.toString();
                                                var stampDuty = svSale.stampDuty.toString();
                                                var fTLRegulator = svSale.fTLRegulator.toString();
                                                var basicAmt = svSale.basicAmt.toString();
                                                var consuDCNo = svSale.consuDCNo.toString();
                                                var consumerName = svSale.consumerName.toString();
                                                var consuContactNo = svSale.consuContactNo.toString();
                                                var totalAmount = svSale.totalAmount.toString();
                                                var receiptAmt = svSale.receiptAmt.toString();
                                                var paymentMode = svSale.paymentMode.toString();
                                                var transactionCode = svSale.transactionCode.toString();
                                                var transactionTime = svSale.transactionTime.toString();
                                                var transactionRemark = svSale.transactionRemark.toString();
                                                var addedBy = svSale.addedBy.toString();
                                                var action = svSale.action.toString();
                                                var itemId = svSale.itemId.toString();
                                                var itemName = svSale.itemName.toString();
                                                var rate = svSale.rate.toString();
                                                var itemQty = svSale.itemQty.toString();
                                                var discountAmt = svSale.discountAmt.toString();
                                                var aRBAmount = svSale.aRBAmount.toString();
                                                var amtCharges = svSale.amtCharges.toString();
                                                var categoryName = svSale.categoryName.toString();
                                                var bankId = svSale.bankId.toString();
                                                var bankMappingId = svSale.bankMappingId.toString();
                                                var accountNo = svSale.accountNo.toString();
                                                var bankName = svSale.bankName.toString();
                                                var isExemptReti = svSale.isExemptReti.toString();
                                                var sVDiscountAmt = svSale.sVDiscountAmt.toString();
                                                  // Navigate to the target screen and pass the data
                                                if (saveFlag) {
                                                  print('saveFlag $saveFlag');
                                                  showFlushBar(context, Constants.dayEndCompleted);
                                                } else {
                                                  debugPrint("sCRegulator $sCRegulator");
                                                  Navigator.pushNamed(
                                                    context,
                                                    SVSaleReportScreen.screenName,
                                                    arguments: {
                                                      'psvIDV' : psvID,
                                                      'sVDateV' : sVDate,
                                                      'referredByIdV' : referredById,
                                                      'referredByNameV' : referredByName,
                                                      'otherNameV' : otherName,
                                                      'productIdV' : productId,
                                                      'productNameV' : productName,
                                                      'isUndocumentV' : isUndocument,
                                                      'sVTypeV' : sVType,
                                                      'cylQtyV' : cylQty,
                                                      'sCRegulatorV' : sCRegulator,
                                                      'depositCylV' : depositCyl,
                                                      'cylRefillRSPV' : cylRefillRSP,
                                                      'regulatorDepositV' : regulatorDeposit,
                                                      'stampDutyV' : stampDuty,
                                                      'fTLRegulatorV' : fTLRegulator,
                                                      'basicAmtV' : basicAmt,
                                                      'consuDCNoV' : consuDCNo,
                                                      'consumerNameV' : consumerName,
                                                      'consuContactNoV' : consuContactNo,
                                                      'totalAmountV' : totalAmount,
                                                      'receiptAmtV' : receiptAmt,
                                                      'paymentModeV' : paymentMode,
                                                      'transactionCodeV' : transactionCode,
                                                      'transactionTimeV' : transactionTime,
                                                      'transactionRemarkV' : transactionRemark,
                                                      'addedByV' : addedBy,
                                                      'actionV' : action,
                                                      'itemIdV' : itemId,
                                                      'itemNameV' : itemName,
                                                      'rateV' : rate,
                                                      'itemQtyV' : itemQty,
                                                      'discountAmtV' : discountAmt,
                                                      'aRBAmountV' : aRBAmount,
                                                      'amtChargesV' : amtCharges,
                                                      'categoryNameV' : categoryName,
                                                      'bankIdV' : bankId,
                                                      'bankMappingIdV' : bankMappingId,
                                                      'accountNoV' : accountNo,
                                                      'bankNameV' : bankName,
                                                      'isExemptRetiV' : isExemptReti,
                                                      'sVDiscountAmtV' : sVDiscountAmt,
                                                      'itemsToShow': itemsToShow,
                                                      'modeChange': "Edit"
                                                    },
                                                  );
                                                }

                                              },
                                            ),
                                            // Delete Icon
                                            IconButton(
                                              icon: Icon(Icons.delete, color:saveFlag?Colors.redAccent: Colors.red),  // Icon for delete
                                              onPressed: () async {
                                                if (saveFlag) {
                                                  print('saveFlag $saveFlag');
                                                  showFlushBar(context, Constants.dayEndCompleted);
                                                } else {
                                                  int? psv = svSale.pSVId?.toInt();
                                                  bool? confirmDelete = await showDialog<bool>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Are you sure?'),
                                                        content: const Text('You want to delete?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(false); // User pressed Cancel
                                                            },
                                                            child: const Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(true); // User pressed Delete
                                                            },
                                                            child: const Text('Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  // If user confirmed deletion
                                                  if (confirmDelete == true) {
                                                    // Check if receiptId is not null
                                                    // int? pId = payList.receiptId;
                                                    if (psv != null) {
                                                      updateSVAddEditForMob(psv!,"DELETE");
                                                      print('Delete button pressed$psv');
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
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                   Expanded(
                                     child: Row(
                                       children: [
                                         Text("SV Type : ",style: Styling.itemGreyTextSmall,),
                                            Text(svSale.sVType.toString(),style: Styling.itemBlackTestSmall,),
                                       ],
                                     ),
                                   ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text("SV Pending : ",style: Styling.itemGreyTextSmall,),
                                            Text(svSale.sVType.toString(),style: Styling.itemBlackTestSmall,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text("Cons. No./DC No. : ",style: Styling.itemGreyTextSmall,),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(svSale.consuDCNo.toString(),style: Styling.itemBlackTestSmall,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text("Cons. Name : ",style: Styling.itemGreyTextSmall,),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(svSale.consumerName.toString(),style: Styling.itemBlackTestSmall,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text("Amt. : ",style: Styling.itemGreyTextSmall,),
                                            Text(svSale.totalAmount.toString(),style: Styling.itemBlackTestSmall,),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text("Mode : ",style: Styling.itemGreyTextSmall,),
                                            Text(svSale.paymentMode == "Bank"?"Online":svSale.paymentMode.toString(),style: Styling.itemBlackTestSmall,),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  // if (widget.serialNumber != widget.listLength)
                                  //   Divider(),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No Records Found'),
                        ),
                ),
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
      newAmt =  rateNew;
      totalSum = rateNew - discountNew;
      items[index]['amt']?.text = totalSum.toStringAsFixed(2);
      debugPrint("totalSum (qty is empty): $totalSum");
    }
    if(newAmt >= discountNew){

    }else{
      items[index]['discount']?.clear();
      _updateSum(index);
      calculateGrandTotalAmount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Constants.discountError)),
      );
    }
  }

  // Future<void> fetchItems() async {
  //   Constants.isNetworkAvailable =
  //       await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken =
  //         prefs.getString('token'); // Assuming the token is stored here
  //
  //     if (bearerToken == null) {
  //       throw Exception('Bearer Token Is Missing');
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.GetARBItemMasterList}/$distributorId/1/C'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //       },
  //     );
  //     debugPrint("itemGetARBItemMasterList" + '${AppUrl.GetARBItemMasterList}/$distributorId/1/C');
  //     debugPrint("itemGetARBItemMasterList" + response.body);
  //     if (response.statusCode == 200) {
  //       // Parse the response
  //       List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         svcStock = data
  //             .map((json) => GetArbCurrentStockListModel.fromJson(json))
  //             .toList();
  //       });
  //     } else {
  //       // refreshTokens();
  //       throw Exception('Unable To Load Data At This Time. Please Try Again');
  //     }
  //   } else {
  //     showFlushBar(context, Constants.connectionMessage);
  //   }
  // }

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

      // setState(() {
      //   staffdetailsmodel = data.map((json) {
      //     // String dateString = json['TransDate'];
      //     // DateTime date = DateTime.parse(dateString);
      //     // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      //     // json['TransDate'] = formattedDate;
      //
      //     return GetStaffDetailsListModel.fromJson(json);
      //   }).toList();
      //   isLoading = false;
      //   EasyLoading.dismiss();
      // });
      setState(() {
        staffdetailsmodel = data.map((json) {
          return GetStaffDetailsListModel.fromJson(json);
        }).toList();

        // 🔤 Sort alphabetically by a string field like "staffName"
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

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "IsActive": isActive,
      "ItemType": itemType,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetItemMasterList : " +
        '${AppUrl.GetItemMasterList}/$distributorId/0/C');
    debugPrint("GetItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        masterListModel = data.map((json) {
          // String dateString = json['TransDate'];
          // DateTime date = DateTime.parse(dateString);
          // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // json['TransDate'] = formattedDate;

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
        getrsplistmodel = data.map((json) => GetRspDetailsListModel.fromJson(json)).toList();
        if(modes == "Edit"){

        }else {
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

  // num? getArbItemCurrentStock(int? itemId) {
  //   if (itemId == null) return null;
  //
  //   try {
  //     return svcStock
  //         .firstWhere((element) => element.itemId == itemId)
  //         .currentStk;
  //   } catch (e) {
  //     // No matching item found
  //     return null;
  //   }
  // }
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
    double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;
    double newAmt = deposit + refill + regulator + stampDuty;
    double total = deposit + refill + regulator + stampDuty - discountAmt;
      debugPrint("total $total");
      debugPrint("newAmt $newAmt");
    regulatorBasicAmountController.text = total.toStringAsFixed(2);
    if(newAmt >= discountAmt){

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Constants.discountError)),
      );
      regulatorDiscountAmountController.clear();
      calculateBasicAmountSum();
      calculateGrandTotalAmount();
    }
  }

  void calculateBasicAmountSumDepositMinus() {
    double deposit = double.tryParse(depositCylinderAmountController.text.trim()) ?? 0;
    double refill = double.tryParse(refillCylinderAmountController.text.trim()) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text.trim()) ?? 0;
    double regulator = double.tryParse(regulatorDepositAmountController.text.trim()) ?? 0;
    double discountAmt = double.tryParse(regulatorDiscountAmountController.text.trim()) ?? 0;

    debugPrint("Parsed values:");
    debugPrint("Deposit: $deposit");
    debugPrint("Refill: $refill");
    debugPrint("Stamp Duty: $stampDuty");
    debugPrint("Regulator: $regulator");
    debugPrint("Discount: $discountAmt");

    double total = deposit + refill + regulator + stampDuty - discountAmt - regulator;

    debugPrint("Total (calculated): $total");

    regulatorBasicAmountController.text = total.toStringAsFixed(2);
  }

  Future<void> fetchItemSvAddEditList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
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
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URLGetPendingSVList_Mob: ${response.request}");
        print("Request HeadersGetPendingSVList_Mob: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status CodeGetPendingSVList_Mob: ${response.statusCode}");
        print("API Response BodyGetPendingSVList_Mob: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList = data.map((json) => GetAddEditDataSvSaleItemModel.fromJson(json)).toList();
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  Future<void> fetchDenominationListAddEditList(int psvId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
          Uri.parse('${AppUrl.GetPendingSVCashDenoDtlsById_Mob}/$psvId/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request GetPendingSVCashDenoDtlsById_Mob: ${response.request}");
        print("Request GetPendingSVCashDenoDtlsById_Mob: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status GetPendingSVCashDenoDtlsById_Mob: ${response.statusCode}");
        print("API Response GetPendingSVCashDenoDtlsById_Mob: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDenominationLis = data.map((json) => GetDenominationListForAddEdit.fromJson(json)).toList();
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
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

  Future<void> updateSVAddEditForMob(int psvID, String actionMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now); int scRegulators = 0;
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
    double receiveAmt = 0.0 ;


    String? tranCode;
    String? times;
    String? transRemark;

    double nameChangeCharges = 0.0;

    double discountAmount = 0.0;

    String? payMode;

    if(actionMode != "DELETE"){
      if(scRegulatorController.text.isNotEmpty){
        scRegulators = int.parse(scRegulatorController.text);
      }

      if(depositCylinderAmountController.text.isNotEmpty){
        cylDeposit = double.parse(depositCylinderAmountController.text);
      }

      if(refillCylinderAmountController.text.isNotEmpty){
        cylRefillRSP = double.parse(refillCylinderAmountController.text);
      }

      if(regulatorDepositAmountController.text.isNotEmpty || regulatorDepositAmountController.text != null || regulatorDepositAmountController.text != "null"){
        regDeposit = double.parse(regulatorDepositAmountController.text);
      }

      if(stampDutyController.text.isNotEmpty){
        stampD = double.parse(stampDutyController.text);
      }
      if(regulatorBasicAmountController.text.isNotEmpty){
        basicAmt = double.parse(regulatorBasicAmountController.text);
      }
      if(regulatorDiscountAmountController.text.isNotEmpty){
        discountAmt = double.parse(regulatorDiscountAmountController.text);
      }
      if(conNoController.text.isNotEmpty){
        conDSNo = conNoController.text;
      }
      if(conNameController.text.isNotEmpty){
        consName = conNameController.text;
      }
      if(conContactController.text.isNotEmpty){
        conCont = conContactController.text;
      }

      if(totalAmountController.text.isNotEmpty){
        totalAmt = double.parse(totalAmountController.text);
      }
      if(recPaymentController.text.isNotEmpty){
        receiveAmt = double.parse(recPaymentController.text);
      }
      if(TranCodeController.text.isNotEmpty){
        tranCode = TranCodeController.text;
      }
      if(timeController.text.isNotEmpty){
        times = timeController.text;
      }
      if(transReviewController.text.isNotEmpty){
        transRemark = transReviewController.text;
      }
      if(nameChangeAmtChargesController.text.isNotEmpty){
        nameChangeCharges = double.parse(nameChangeAmtChargesController.text);
      }
      if(regulatorDiscountAmountController.text.isNotEmpty){
        discountAmount = double.parse( regulatorDiscountAmountController.text);
      }
      if(selectedBankName != null || selectedBankId != null){
        if(selectedTransMode == null){
          showFlushBar(context, "Select Transaction Mode.");
          return;
        }
      }

      if(selectedTranssvItemName == null){
        showFlushBar(context, "Select Product.");
        return;
      }
      if(selectedTransacc == null){
        showFlushBar(context, "Select SV Type.");
        return;
      }
      if(selectedTranssvItemName == "14.2 KG" && !isExemptedReticulated){
        if(selectedTranqty == null){
          showFlushBar(context, "Select Cylinder Quantity.");
          return;
        }
      }
      if(selectedTranssvItemName != "14.2 KG" || isExemptedReticulated){
        if(cylinderQtyAddController.text.isEmpty){
          showFlushBar(context, "Enter Cylinder Quantity.");
          return;
        }
      }
      if(selectedTranssvItemName != "14.2 KG"){
        if(getSelectedFTLRegulatorQtyString == null){
          showFlushBar(context, "Select FTL Regulator Quantity.");
          return;
        }
      }

      if(depositCylinderAmountController.text.isEmpty){
        showFlushBar(context, "Enter Cylinder Deposit Amount.");
        return;
      }

      if(selectedTransacc != "DBC"){
        if(regulatorDepositAmountController.text.isEmpty){
          showFlushBar(context, "Enter Regulator Deposit Amount.");
          return;
        }
      }

      if(selectedTransacc == "Name Change"){
        if(nameChangeAmtChargesController.text.isEmpty){
          showFlushBar(context,"Enter Name Change Amount.");
          return;
        }
      }

      if(conNoController.text.isEmpty){
        showFlushBar(context,"Enter Consumer Number.");
        return;
      }

      if(recPaymentController.text.isEmpty){
        showFlushBar(context, "Enter Receipt payment amount.");
        return;
      }

      if(selectedTransMode == null){
        showFlushBar(context, "Select Transaction Mode.");
        return;
      }


      if(selectedTransMode == "Online"){
        if(selectedBankName == null || selectedBankId == null){
          showFlushBar(context, "Select Bank.");
          return;
        }
        if(TranCodeController.text.isEmpty){
          showFlushBar(context, "Enter Transaction Code.");
          return;
        }
      }

      if(selectedTransMode == 'Cash'){
        if(finalAmountCashDeno > 0){
          if(finalAmountCashDeno != receiveAmt){
            showFlushBar(context, "The Entered Cash Denomination Total Should Be Equal To Received Cash Amount.");
            return;
          }
        }
      }
      if(selectedTransMode == 'Cash'){
        if(cashDenominationMandatory){
          if(finalAmountCashDeno != null || finalAmountCashDeno > 0){
            if(finalAmountCashDeno != receiveAmt){
              showFlushBar(context, "The Entered Cash Denomination Total Should Be Equal To Received Cash Amount.");
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }

      if(receiveAmt != totalAmt){
        showFlushBar(context, "The Entered Receipt Payment Amount Should Be Equal To Total Amount.");
        return;
      }
      if(selectedTransMode == "Online"){
        payMode = "Bank";
      }else if(selectedTransMode == "Cash"){
        payMode = "Cash";
      }else{
        payMode = "";
      }
    }






      //   int cylQty;
    // if(selectedTranssvItemName != "14.2 KG" || isExemptedReticulated){
    //   cylQty = int.parse(cylinderQtyAddController.text);
    // }else{
    //     cylQty = int.parse(selectedTranqty!);
    // }

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

    // List<Map<String, dynamic>> itemDetails = items.map((item) {
    //   String? selectedItemName = _selectedItems[items.indexOf(item)];
    //
    //   GetArbItemMasterListModel? selectedItem = _items.firstWhere(
    //         (model) => model.itemName == selectedItemName,
    //     orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
    //   );
    //   return {
    //     'ItemId': selectedItem.itemId ?? '',
    //     'Rate': item['rate']?.text ?? '',
    //     'ItemQty': item['qty']?.text ?? '',
    //     'DiscountAmt': item['discount']?.text ?? '',
    //     'ARBAmount': item['amt']?.text ?? '',
    //   };
    // }).toList();

    List<Map<String, dynamic>> itemDetails = items.where((item) {
      int index = items.indexOf(item);
      String? selectedItemName = _selectedItems[index];

      GetArbItemMasterListModel selectedItem = _items.firstWhere(
            (model) => model.itemName == selectedItemName,
        orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
      );

      int? currentStock = getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
      _itemStockByIndex[index] = currentStock;

      int itemId = selectedItem.itemId?.toInt() ?? 0;
      int qty = int.tryParse(item['qty']?.text ?? '0') ?? 0;

      if (selectedItem.categoryName != "Non ARB Item" && selectedItem.categoryName != "Other") {
        if (qty > currentStock!) {
          // Show a message and return early to stop further processing
          showFlushBar(context,"Quantity exceeds available stock for item ${selectedItem.itemName}");
          throw Exception("Quantity exceeds available stock for item ${selectedItem.itemName}"); // <-- Stop process here

        }
      }
      // Filter condition: only include if both > 0
      return itemId > 0;
    }).map((item) {
      int index = items.indexOf(item);
      String? selectedItemName = _selectedItems[index];

      GetArbItemMasterListModel selectedItem = _items.firstWhere(
            (model) => model.itemName == selectedItemName,
        orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
      );

      return {
        'ItemId': selectedItem.itemId ?? '',
        'Rate': item['rate']?.text ?? '',
        'ItemQty': item['qty']?.text ?? '',
        'DiscountAmt': item['discount']?.text ?? '',
        'ARBAmount': item['amt']?.text ?? '',
      };
    }).toList();


    if(selectedTranssvItemName == "14.2 KG"){
      if(itemDetails.isEmpty){
        showFlushBar(context, "Add ARB Item.");
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
    int? isExpted;
    if(isExemptedReticulated == true){
      debugPrint("isExemptedReticulated1 $isExemptedReticulated");
      isExpted = 1;
    }else if(isExemptedReticulated == false){
      debugPrint("isExemptedReticulated0 $isExemptedReticulated");
      isExpted = 0;
    }else{

    }
    final Map<String, dynamic> requestBody = {
      "PSVId": psvID,
      "DistributorId":distributorIds,
      "SVDate": formattedDate,
      "ReferredById": selectedReferredID ?? '',
      "OtherName":selectedReferredName ?? '',
      "ProductId": selectedProductID ?? '',
      "ProductName":selectedTranssvItemName ?? '' ,
      "IsUndocument":isSVPending,
      "SvType":selectedTransacc ?? '',
      "CylQty": cylinderQty ?? '',
      "ScRegulator":scRegulators,
      "DepositCyl": cylDeposit,
      "CylRefillRSP": cylRefillRSP,
      "RegulatorDeposit": regDeposit,
      "StampDuty": stampD,
      "FtlRegulator": selectedFTLRegQty ?? 0,
      "BasicAmt": basicAmt,
      "ConsuDCNo": conDSNo ??'',
      "ConsumerName": consName ?? '',
      "ConsuContactNo": conCont ??'',
      "TotalAmount": totalAmt,
      "ReceiptAmt": receiveAmt,
      "PaymentMode": payMode ??'',
      "TransactionCode": tranCode ?? '',
      "TransactionTime": times ?? '',
      "TransactionRemark": transRemark ?? '',
      "AddedBy": userId,
      "Action": actionMode,
      "ItemId": 0,
      "ItemName": '',
      "Rate": '',
      "ItemQty": '',
      "DiscountAmt": arbTotalDiscount??'',
      "SVDiscountAmt": discountAmt ??'',
      "ArbAmount": arbTotalAmount??'',
      "ItemDataList": itemDetails,
      "DenomDtList": dataCashDenomination,
      "AmtCharges": nameChangeCharges,
      "BankId": bankId,
      "BankMappingId": accMappingIds,
      "IsExemptReti": isExpted ??'',
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
    // Handling response
    if (response.statusCode == 200) {
      if(response == -1 || response.body == -1 || response == "-1" || response.body == "-1"){
        EasyLoading.showToast(Constants.expenseExistMgr,
            duration: const Duration(milliseconds: 3000));
      }else if(response == 0 || response.body == 0 || response == "0" || response.body == "0"){
        EasyLoading.showToast(Constants.failToInserRecord,
            duration: const Duration(milliseconds: 3000));
      }else{
        // Successful response
        print("Response UpdateSaleAddEditForMob: ${response.body}");
          if(actionMode != "DELETE"){
            EasyLoading.showToast(Constants.expenseSendMgr,
                duration: const Duration(milliseconds: 3000));
          }else{
            EasyLoading.showToast(Constants.dataDeleted,
                duration: const Duration(milliseconds: 3000));
          }
        Navigator.pushNamed(
          context,
          BottomNavBarExample.screenName,
          arguments: 3, // This opens the third tab
        );
        setState(() {
          fetchItemSvAddEditList();
        });
      }
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
    // } catch (e) {
    //   // Exception handling
    //   print("Exception UpdateSaleAddEditForMob: $e");
    // }
  }

  void calculateGrandTotalAmount() {
    // 1. Parse the fixed components
    double deposit = double.tryParse(depositCylinderAmountController.text) ?? 0;
    double refill = double.tryParse(refillCylinderAmountController.text) ?? 0;
    double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;

    double fixedTotal = deposit + refill + regulator + stampDuty - discountAmt;
    print("Grand Total: $deposit $refill $regulator $stampDuty $discountAmt");
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
    double regulator = double.tryParse(regulatorDepositAmountController.text) ?? 0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0;
    double discountAmt = double.tryParse(regulatorDiscountAmountController.text) ?? 0;

    double fixedTotal = deposit + refill + regulator + stampDuty - discountAmt - regulator;

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

  void cancelAction(){
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
      context,
      SVSaleReportScreen.screenName// This opens the third tab
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
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            print("Data is valid, proceeding to save.");
          } else {
            print("Data is incomplete. Cannot proceed to save.");
          }
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

