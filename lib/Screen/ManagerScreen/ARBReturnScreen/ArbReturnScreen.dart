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
// import '../../GodownKeeper/ItemReceipt/EditItem/Model/GetItemReceiptListModel.dart';
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../SVSaleModel/GetARBItemMasterListModel.dart';
import '../SVSaleModel/GetAddEditDataSVSaleItemModel.dart' hide ItemDetails;
import '../SVSaleModel/GetArbCurrentStockListModel.dart';
import '../SVSaleModel/GetDenominationListForAddEdit.dart';
import '../UpdatePaymentsScreen/GetVendorMasterListModel.dart';
import 'GetARBItemRetListModel.dart';

class ArbReturnScreen extends StatefulWidget {
  static const screenName = '/arbReturnScreen';

  const ArbReturnScreen({super.key});

  @override
  State<ArbReturnScreen> createState() => _ArbReturnScreen();
}

class _ArbReturnScreen extends State<ArbReturnScreen> {

  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<TextEditingController> qtyControllerReturn = [];
  int? selectedReferredID;
  String? selectedReferredName;
  List<GetDenominationListForAddEdit> getDenominationLis = [];
  List<GetArbItemRetListModel> paymentModel = [];
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  String? _selectedVendor;
  int? vendorId;
  String? vendorName;
  int? arbRetId;
  String? totalAmt;
  int? cnNo;
  double? cnAmt;
  String? cnRemark;
  bool saveFlag = false;
  int _selectedIndex = 0;
  final conNoController = TextEditingController();
  final remarkController = TextEditingController();
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
  final rateController = TextEditingController();

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  bool _isConsumerEmpty = false;
  bool isLoading = true;
  double totalAmount = 0.0;
  double returnAmount = 0.0;
  double finalAmountCashDeno = 0.0;
  Map<int, bool> isQtyFilled = {};
  List<GetAddEditDataSvSaleItemModel> receiptList = [];
  String? getSelectedFTLRegulatorQtyString;
  int? selectedFTLRegQty;
  List<Map<String, TextEditingController>> items = [];
  int? arbCurrentStock;
  Map<int, int?> _itemStockByIndex = {};
  Map<int, int?> _selectedItemIds = {};
  List<GetArbItemMasterListModel> _items = [];
  List<GetArbCurrentStockListModel> svcStock = [];
  Map<int, String?> _selectedItems = {};
  List<GetVendorMasterListModel> vendorModel = [];
  GetVendorMasterListModel? _selectVendor;
  var argValue;
  String? modes;
  int? psvIdEdit;
  int? arbPurIdEdit;
  // String? aRBRetId;
  final creditNoController = TextEditingController();
  final creditNoteAmtController = TextEditingController();
  final creditRemarkController = TextEditingController();
  bool _isCustomerName = false;
  double? netAmount;
  double? basicAmount;

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    _addNewItem();
    getVendorMasterList();
    getArbCurrentStockList();
    getArbItemMasterListModel();
    getARBItemPurList();

    Future.delayed(Duration.zero, () async{

      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"]?? '';

      if (argValue != null) {
        final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

        final itemsToShow = argValue["itemsToShow"] ?? [];
        arbPurIdEdit = int.tryParse(argValue["arbPurIdEditV"] ?? 0);
        vendorId = int.tryParse(argValue["vendorIdV"] ?? '') ?? 0;
        String vendorName = argValue["vendorNameV"] ?? 0;
        String totalAmountEdit = argValue["totalAmountV"] ?? 0;
        String remarkEdit = argValue["remarkV"] ?? 0;

        totalAmountController.text = totalAmountEdit;
        remarkController.text = remarkEdit;

        if (itemsToShow.isNotEmpty) {
          _initializeItems(itemsToShow);
        } else {
          // If no initial data, start with an empty list or default values
          _initializeItems([]);
        }
        // await getVendorMasterList();
        // getVendorMasterList().whenComplete((){
        // debugPrint("vendorModel names: ${vendorModel.map((e) => e.vendorName).toList()}");
        //

        // await getVendorMasterList();
        // debugPrint("vendorModel count: ${vendorModel.length}");
        // debugPrint("vendorModel names: ${vendorModel.map((e) => e.vendorName).toList()}");
        // debugPrint("referredByNameEdit:$vendorName");
        //   // if(vendorName != "null" && vendorName.isNotEmpty && vendorName != null){
        //   //   setState(() {
        //   //     // _selectVendor = vendorModel.firstWhere(
        //   //     //       (item) => item.vendorName == vendorName,
        //   //     //   orElse: () => GetVendorMasterListModel(vendorName: ''),
        //   //     // );
        //   //     _selectVendor = vendorModel.firstWhere(
        //   //           (item) => item.vendorName?.trim().toLowerCase() == vendorName.trim().toLowerCase(), // ✅ case-insensitive
        //   //       orElse: () => GetVendorMasterListModel(vendorName: ''),
        //   //     );
        //   //   }
        //   //   );
        //   // }
        // if (vendorId != 0 && vendorId != null) {
        //   setState(() {
        //     _selectVendor = vendorModel.cast<GetVendorMasterListModel?>().firstWhere(
        //           (item) => item?.vendorId == vendorId,
        //       orElse: () => null,
        //     );
        //   });
        // }
        // });

        await getVendorMasterList();

        debugPrint("vendorId to match: $vendorId");
        debugPrint("vendorModel ids: ${vendorModel.map((e) => e.vendorId).toList()}");

        if (vendorId != 0 && vendorId != null) {
          final match = vendorModel.where((item) => item.vendorId == vendorId);
          debugPrint("match found: ${match.isNotEmpty} → ${match.isNotEmpty ? match.first.vendorName : 'none'}");
          setState(() {
            _selectVendor = match.isNotEmpty ? match.first : null;
          });
        }
      }
    });
  }

  void _initializeItems(List<ItemDetails> itemsToShow) {
    setState(() {
      items.clear(); // Clear any existing data
      _selectedItems.clear(); // Clear previous selections if any

      for (var i = 0; i < itemsToShow.length; i++) {
        var item = itemsToShow[i];

        // Add the item with controllers for each field
        items.add({
          'selectItem': TextEditingController(text: item.itemName ?? ''),
          'rate': TextEditingController(text: item.rate?.toString() ?? '0'),
          'qty': TextEditingController(text: item.retQty?.toString() ?? '0'),
          'amount': TextEditingController(text: item.amount?.toString() ?? '0'),
          'reason': TextEditingController(text: item.reason?.toString() ?? '0'),
        });

        // Directly assign the selected item name for this index in _selectedItems map
        _selectedItems[items.length - 1] = item.itemName ??
            ''; // Ensure this is added correctly for each index

      }

      // Debugging step to check the number of items
      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }


  bool get _isAddNewItemEnabled {
    // Check if there are any available items that haven't been selected yet
    return _items.any((item) => !_selectedItems.values.contains(item.itemName));
  }
  void _addNewItem() {
    // Check if there are existing items
    if (items.isNotEmpty) {
      // Get the last added item
      var lastItem = items.last;

      // Extract and validate each controller's value
      String? rate = lastItem['rate']?.text.trim();
      String? qty = lastItem['qty']?.text.trim();
      //String? discount = lastItem['discount']?.text.trim();
      String? amount = lastItem['amount']?.text.trim();
      String? reason = lastItem['reason']?.text.trim();


      if (rate!.isEmpty || qty!.isEmpty) {
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
        'amount': TextEditingController(),
        'reason': TextEditingController(),
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
      items[index]['amount']?.dispose();
      items[index]['reason']?.dispose();

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
    //_updateSum(index);

  }

   final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

   // ── UI Helpers ─────────────────────────────────────────────────────────────
   Widget _buildFieldLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: AppTypography.labelMD),
        if (required) ...[
          const SizedBox(width: 3),
          Text('*', style: AppTypography.labelMD.copyWith(color: AppColors.red)),
        ],
      ]),
    );
   }

   InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.cardSubtitle,
        filled: true,
        fillColor: AppColors.bg2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.blue, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );

   Widget _cardBox({required Widget child, EdgeInsets? padding}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: child,
      );

   Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(label, style: AppTypography.dataRowLabel)),
          Text(value, style: AppTypography.dataRowValue),
        ]),
      );

   // ── build ──────────────────────────────────────────────────────────────────
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
        appBar: CustomAppBarManagerr(title: 'ARB Purchase Return'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Strip ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.gradHero,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ARB Purchase Return', style: AppTypography.heroTitle),
                      const SizedBox(height: 4),
                      Text('Manage return entry and credit details', style: AppTypography.heroSubtitle),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                    ),
                    child: Text(formattedDate, style: AppTypography.labelSM.copyWith(color: AppColors.white)),
                  ),
                ]),
              ),

              // ── Form Card ─────────────────────────────────────────────
              _cardBox(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Vendor
                  _buildFieldLabel('Vendor Name', required: true),
                  DropdownButtonFormField<GetVendorMasterListModel>(
                    isExpanded: true,
                    key: formKey1,
                    decoration: _inputDecoration(hint: 'Select Vendor'),
                    value: vendorModel.contains(_selectVendor) ? _selectVendor : null,
                    items: vendorModel
                        .map((item) => DropdownMenuItem<GetVendorMasterListModel>(
                              value: item,
                              child: Text(item.vendorName ?? '', style: AppTypography.dataRowValue),
                            ))
                        .toList(),
                    onChanged: (selectedItem) {
                      setState(() {
                        _selectVendor = selectedItem;
                        _selectedVendor = selectedItem?.vendorName ?? '';
                        vendorId = selectedItem?.vendorId?.toInt();
                      });
                      validator: (value) {
                        if (value == null) return 'Please select a vendor';
                        return null;
                      };
                    },
                  ),
                  const SizedBox(height: 14),

                  // Remark
                  _buildFieldLabel('Remark'),
                  TextField(
                    controller: remarkController,
                    inputFormatters: [LengthLimitingTextInputFormatter(250)],
                    decoration: _inputDecoration(hint: 'Enter remark'),
                  ),
                  const SizedBox(height: 14),

                  // Items header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items', style: AppTypography.cardTitle),
                      TextButton.icon(
                        onPressed: _isAddNewItemEnabled ? _addNewItem : null,
                        icon: Icon(Icons.add_circle_outline, size: 18, color: AppColors.blue),
                        label: Text('Add Item', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.blueXXL,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Item rows
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.bg2,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          // Select item + delete
                          _buildFieldLabel('Select Item', required: true),
                          Row(children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded:true,
                                decoration: _inputDecoration(hint: 'Select Item *'),
                                value: _selectedItems[index]?.isEmpty ?? true ? null : _selectedItems[index],
                                items: _items
                                    .where((item) =>
                                        !_selectedItems.values.contains(item.itemName) ||
                                        _selectedItems[index] == item.itemName)
                                    .toSet()
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.itemName,
                                          child: Text(item.itemName ?? 'Unknown', style: AppTypography.dataRowValue),
                                        ))
                                    .toList(),
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
                                      double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                      items[index]['qty']?.clear();
                                      items[index]['amount']?.text;
                                      items[index]['reason']?.text;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _removeItem(index),
                              icon: Icon(Icons.delete_outline, color: AppColors.red),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.redXL,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),

                          // Rate / Qty / Amount
                          Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                _buildFieldLabel('Rate', required: true),
                                TextField(
                                  controller: items[index]['rate'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(8),
                                  ],
                                  style: AppTypography.dataRowValue,
                                  decoration: _inputDecoration(hint: '0'),
                                  onChanged: (value) {
                                    setState(() {
                                      basicAmount = _updateSum(index);
                                      items[index]['amount']?.text = basicAmount!.toStringAsFixed(2);
                                    });
                                  },
                                ),
                              ]),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                _buildFieldLabel('Qty', required: true),
                                TextField(
                                  controller: items[index]['qty'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  style: AppTypography.dataRowValue,
                                  decoration: _inputDecoration(hint: '0'),
                                  onChanged: (value) {
                                    setState(() {
                                      bool isNotNull = value.isNotEmpty;
                                      int enteredQty = int.tryParse(value) ?? 0;
                                      int? stockLimit = _itemStockByIndex[index];
                                      debugPrint("stockLimit $stockLimit");
                                      if (isNotNull && enteredQty > 0) {
                                        if (stockLimit != null && enteredQty > stockLimit) {
                                          items[index]['qty']?.clear();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Entered Quantity Exceeds Current Stock: $stockLimit')),
                                          );
                                          _updateSum(index);
                                          updateTotalAmount();
                                          return;
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
                              ]),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                _buildFieldLabel('Amount'),
                                TextField(
                                  controller: items[index]['amount'],
                                  enabled: false,
                                  style: AppTypography.dataRowValue.copyWith(color: AppColors.textMuted),
                                  decoration: _inputDecoration(hint: '0.00'),
                                ),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 10),

                          // Reason
                          _buildFieldLabel('Reason'),
                          TextField(
                            controller: items[index]['reason'],
                            inputFormatters: [LengthLimitingTextInputFormatter(250)],
                            style: AppTypography.dataRowValue,
                            decoration: _inputDecoration(hint: 'Enter reason'),
                            onChanged: (value) => setState(() {}),
                          ),
                        ]),
                      );
                    },
                  ),

                  // Total
                  if (items.isNotEmpty) ...[
                    const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: AppTypography.cardTitle),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(color: AppColors.blueXXL, borderRadius: BorderRadius.circular(8)),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: totalAmountController,
                            builder: (_, v, __) => Text(v.text, style: AppTypography.cardTitle.copyWith(color: AppColors.blue)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Buttons
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    OutlinedButton(
                      onPressed: cancelAction,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.blue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text('Cancel', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (modes == "EDIT") {
                            arbItemAddEditForMob(arbPurIdEdit!, "EDIT");
                          } else {
                            arbItemAddEditForMob(0, "ADD");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        modes == "EDIT" ? 'Update' : 'Save',
                        style: AppTypography.labelMD.copyWith(color: AppColors.white),
                      ),
                    ),
                  ]),
                ]),
              ),

              // ── Records Card ──────────────────────────────────────────
              _cardBox(
                padding: EdgeInsets.zero,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.blueXXL,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(children: [
                      Expanded(child: Text('Vendor', style: AppTypography.labelMD.copyWith(color: AppColors.blue))),
                      Expanded(child: Text('Date', style: AppTypography.labelMD.copyWith(color: AppColors.blue))),
                      Text('Actions', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                    ]),
                  ),
                  paymentModel.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentModel.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFFF1F5F9), height: 1),
                          itemBuilder: (context, index) {
                            final payList = paymentModel[index];
                            final bool creditAdded = (payList.cNAmt ?? 0.0) != 0.0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        payList.vendorName?.toString() ?? '',
                                        style: AppTypography.dataRowValue.copyWith(color: AppColors.blue, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        payList.returnDate != null
                                            ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.returnDate!))
                                            : '',
                                        style: AppTypography.cardSubtitle,
                                      ),
                                    ]),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, color: AppColors.blue, size: 20),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.blueXXL,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () async {
                                      if (saveFlag) {
                                        showFlushBar(context, Constants.dayEndCompleted);
                                      } else {
                                        double balance = payList.cNAmt?.toDouble() ?? 0.0;
                                        if (balance != 0) {
                                          EasyLoading.showToast(Constants.creditPayErr, duration: const Duration(milliseconds: 3000));
                                          return;
                                        }
                                        setState(() {
                                          Navigator.pushNamed(context, ArbReturnScreen.screenName, arguments: {
                                            'arbPurIdEditV': payList.aRBRetId.toString(),
                                            'itemsToShow': payList.itemDetails?.toList(),
                                            'vendorIdV': payList.vendorId.toString(),
                                            'vendorNameV': payList.vendorName.toString(),
                                            'totalAmountV': payList.totalAmount.toString(),
                                            'remarkV': payList.remark.toString(),
                                            'modeChange': "EDIT",
                                          });
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: AppColors.red, size: 20),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.redXL,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () async {
                                      if (saveFlag) {
                                        showFlushBar(context, Constants.dayEndCompleted);
                                      } else {
                                        int? pId = payList.aRBRetId?.toInt();
                                        double balance = payList.cNAmt?.toDouble() ?? 0.0;
                                        if (balance != 0) {
                                          EasyLoading.showToast(Constants.creditPayErr1, duration: const Duration(milliseconds: 3000));
                                          return;
                                        }
                                        bool? confirmDelete = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                Container(
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(color: AppColors.redXL, shape: BoxShape.circle),
                                                  child: Icon(Icons.delete_outline, color: AppColors.red, size: 28),
                                                ),
                                                const SizedBox(height: 12),
                                                Text('Delete Record?', style: AppTypography.cardTitle),
                                                const SizedBox(height: 6),
                                                Text('Are you sure you want to delete this return?', style: AppTypography.cardSubtitle, textAlign: TextAlign.center),
                                                const SizedBox(height: 20),
                                                Row(children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.of(ctx).pop(false),
                                                      style: OutlinedButton.styleFrom(
                                                        side: BorderSide(color: AppColors.blue),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      child: Text('Cancel', style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () => Navigator.of(ctx).pop(true),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColors.red,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      child: Text('Delete', style: AppTypography.labelMD.copyWith(color: AppColors.white)),
                                                    ),
                                                  ),
                                                ]),
                                              ]),
                                            ),
                                          ),
                                        );
                                        if (confirmDelete == true && pId != null) {
                                          arbItemAddEditForMob(pId, "DELETE");
                                        }
                                      }
                                    },
                                  ),
                                ]),
                                const SizedBox(height: 8),
                                _infoRow('Credit No', payList.cNNo ?? '-'),
                                _infoRow('Return Qty', payList.retQty?.toString() ?? '-'),
                                _infoRow('Total Amount', formatCurrency(payList.totalAmount?.toDouble() ?? 0)),
                                _infoRow('Credit Amt', formatCurrency(payList.cNAmt?.toDouble() ?? 0)),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      arbRetId = payList.aRBRetId?.toInt();
                                      vendorId = payList.vendorId?.toInt();
                                      vendorName = payList.vendorName.toString();
                                      totalAmt = payList.totalAmount.toString();
                                      cnAmt = payList.cNAmt?.toDouble();
                                      if (cnAmt == 0.0) _showAddCustomerPopup();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: creditAdded ? const Color(0xFFF1F5F9) : AppColors.blueXXL,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: creditAdded ? const Color(0xFFCBD5E1) : AppColors.blue),
                                    ),
                                    child: Text(
                                      creditAdded ? 'Credit Note Added' : 'Add Credit Note',
                                      style: AppTypography.labelSM.copyWith(color: creditAdded ? AppColors.textMuted : AppColors.blue),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(child: Text('No Records Found', style: AppTypography.cardSubtitle)),
                        ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> arbItemAddEditForMob(int arbRetId ,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    double totalAmt = 0.0;
    String invoiceNo = '';
    String remark = '';
    double basicAmt = 0.0;
    double taxAmt = 0.0;
    double netAmt = 0.0;

    List<Map<String, dynamic>> ItemDetails = items.map((item) {
      String? selectedItemName = _selectedItems[items.indexOf(item)];

      GetArbItemMasterListModel? selectedItem = _items.firstWhere(
            (model) => model.itemName == selectedItemName,
        orElse: () => GetArbItemMasterListModel(itemId: 0, itemName: ''),
      );
      return {
        'pkId': 0,
        'ItemId': selectedItem.itemId ?? '',
        'ItemName': selectedItem.itemName ?? '',
        'Rate': item['rate']?.text ?? '',
        'RetQty': item['qty']?.text ?? '',
        'Reason': item['reason']?.text ?? '',
        'Amount': item['amount']?.text ?? '',

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

      // bool hasValidQty = ItemDetails.any((item) =>
      // item['ItemId'] != 0 &&
      //     item['RetQty'].toString().isNotEmpty
      // );
      // if (!hasValidQty) {
      //   showFlushBar(context, "Please Select The Qty");
      //   return;
      // }

      // bool hasValidQty = ItemDetails.any((item) =>
      // item['ItemId'] != 0 &&
      //     item['ItemQty'].toString().isNotEmpty &&
      //     num.tryParse(item['RetQty'].toString()) != null &&
      //     num.parse(item['RetQty'].toString()) > 0
      // );
      // if (!hasValidQty) {
      //   showFlushBar(context, "Please Select a Valid Qty");
      //   return;
      // }

      bool allItemsHaveValidQty = ItemDetails.every((item) =>
      item['ItemId'] == 0 ||
          (item['ItemQty'].toString().isNotEmpty &&
              num.tryParse(item['RetQty'].toString()) != null &&
              num.parse(item['RetQty'].toString()) > 0));
      if (!allItemsHaveValidQty) {
        int badIndex = ItemDetails.indexWhere((item) =>
        item['ItemId'] != 0 &&
            (item['ItemQty'].toString().isEmpty ||
                num.tryParse(item['RetQty'].toString()) == null ||
                num.parse(item['RetQty'].toString()) <= 0));
        showFlushBar(context, "Please enter a valid Qty for Item ${badIndex + 1}");
        return;
      }

      if (totalAmountController.text.isNotEmpty) {
        totalAmt = double.parse(totalAmountController.text);
      }

      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      }

      if (_selectVendor == null) {
        showFlushBar(context, Constants.reqfield);
        return;
      }
      if (_selectedItems.isEmpty) {
        showFlushBar(context, Constants.reqfield);
        return;
      }
    }
    final Map<String, dynamic> requestBody =
    {
      "ARBRetId": arbRetId,
      "pkId": 0,
      "ItemId":0,
      "Rate": 0,
      "RetQty": 0,
      "Reason": "",
      "DistributorId": distributorId,
      "VendorId": vendorId ?? '',
      "ReturnDate":formattedDate,
      "Amount": 0,
      "CNNo": "",
      "TotalAmount": totalAmt ?? '',
      "Remark": remark,
      "UpdatedFrom":'MOB',
      "Action": action,
      "AddedBy": userId ?? '',
      "ItemDetails": ItemDetails,

    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.AddEditARBItemReturn}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody AddEditARBItemPurchase: ${response.statusCode} - ${response.request}${requestBody}");

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
          ArbReturnScreen.screenName,
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
          getARBItemPurList();
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> arbCreditNoteAddEditForMob() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    double? totalAmounts = double.tryParse(totalAmt!);

    String remark = '';
    String creditNo = '';
    double creditAmt = 0.0;

     if (creditNoController.text.isNotEmpty) {
        creditNo = creditNoController.text;
      }

    if (creditRemarkController.text.isNotEmpty) {
      remark = creditRemarkController.text;
    }

    if (creditNoteAmtController.text.isNotEmpty) {
        creditAmt = double.parse(creditNoteAmtController.text);
      }

    if(creditAmt != totalAmounts){
      showFlushBar(context, Constants.creditCheck);
      return;
    }

    final Map<String, dynamic> requestBody =
    {
      "ARBRetId": arbRetId,
      "DistributorId": distributorId,
      "CNNo": creditNo,
      "CNAmt":creditAmt,
      "CNRemark": remark,
      "CNUpdatedFrom": "MOB",

  };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.AddCreditNoteDetails}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody AddCreditNoteDetails: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        // Process the valid response (JSON or data)
        print("Response AddCreditNoteDetails: ${response.body}");

        Navigator.pushNamed(
          context,
          ArbReturnScreen.screenName,
        );

        Future.delayed(Duration(milliseconds: 300), () {
          EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
        });
        setState(() {
          getARBItemPurList();
        });
        EasyLoading.dismiss();
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> getARBItemPurList() async {
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
      Uri.parse('${AppUrl.GetARBItemRetList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemRetList : " +
        '${AppUrl.GetARBItemRetList}/$distributorId');
    debugPrint("GetARBItemRetList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) {
          return GetArbItemRetListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
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
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   // If the conditions are met, set the flag and save the data
          //   print("Data is valid, proceeding to save.");
          // } else {
          //   // If any condition is not met, print a message
          //   print("Data is incomplete. Cannot proceed to save.");
          // }
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

  double _updateSum(int index) {
    var rateController = items[index]['rate'];
    var qtyController = items[index]['qty'];
    var amountController = items[index]['amount']; // 🔧 Add this

    double rate = double.tryParse(rateController?.text.trim() ?? '0') ?? 0.0;
    double qty = double.tryParse(qtyController?.text.trim() ?? '0') ?? 0.0;

    double total = rate * qty;

    // 🔧 Set the value to amount controller
    amountController?.text = total.toStringAsFixed(2);

    debugPrint("Rate: $rate, Qty: $qty, Total: $total");

    return total;
  }

  double updateTotalAmount() {
    double total = 0.0;

    for (var item in items) {
      final amtText = item['amount']?.text.trim() ?? '';
      final amt = double.tryParse(amtText) ?? 0.0;
      total += amt;
    }

    final formattedTotal = total.toStringAsFixed(2);
    totalAmountController.text = formattedTotal;

    debugPrint("formattedTotal $formattedTotal");

    return total; // Ensure a non-null double is returned
  }

  void _showAddCustomerPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.gradHero,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit Note Details',
                              style: AppTypography.heroTitle,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    vendorName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.heroSubtitle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  totalAmt?.toString() ?? '',
                                  style: AppTypography.heroSubtitle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Body
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFieldLabel(
                              'Credit Note No',
                              required: true,
                            ),

                            TextField(
                              controller: creditNoController,
                              maxLengthEnforcement:
                              MaxLengthEnforcement.enforced,
                              decoration: _inputDecoration(
                                hint: 'Enter credit note no',
                              ).copyWith(
                                errorText: _isCustomerName
                                    ? 'Credit No Is Required'
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _isCustomerName = value.isEmpty;
                                });

                                setDialogState(() {
                                  _isCustomerName = value.isEmpty;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            _buildFieldLabel(
                              'Credit Note Amount',
                              required: true,
                            ),

                            TextField(
                              controller: creditNoteAmtController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              maxLengthEnforcement:
                              MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                              decoration: _inputDecoration(
                                hint: '0.00',
                              ).copyWith(
                                errorText: _isCustomerName
                                    ? 'Credit Amt Is Required'
                                    : null,
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildFieldLabel('Remark'),

                            TextField(
                              controller: creditRemarkController,
                              maxLines: 3,
                              maxLengthEnforcement:
                              MaxLengthEnforcement.enforced,
                              decoration: _inputDecoration(
                                hint: 'Enter remark',
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      creditNoController.clear();
                                      creditNoteAmtController.clear();
                                      creditRemarkController.clear();

                                      Navigator.of(context).pop();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.blue,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: AppTypography.labelMD.copyWith(
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String creditNo =
                                      creditNoController.text.trim();

                                      String creditAmt =
                                      creditNoteAmtController.text
                                          .trim();

                                      String creditRemark =
                                      creditRemarkController.text
                                          .trim();

                                      if (creditNo.isEmpty ||
                                          creditAmt.isEmpty) {
                                        showFlushBar(
                                          context,
                                          "All fields are required.",
                                        );
                                        return;
                                      }

                                      double? enteredAmt =
                                      double.tryParse(creditAmt);

                                      double? totalAmounts =
                                      double.tryParse(totalAmt!);

                                      if (enteredAmt == null) {
                                        showFlushBar(
                                          context,
                                          "Please enter a valid credit amount.",
                                        );
                                        return;
                                      }

                                      if (enteredAmt != totalAmounts) {
                                        showFlushBar(
                                          context,
                                          "The credit note amount cannot be greater than or less than the total amount.",
                                        );
                                        return;
                                      }

                                      arbCreditNoteAddEditForMob();

                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Save',
                                      style: AppTypography.labelMD.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void cancelAction() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(
          context,
          ArbReturnScreen.screenName // This opens the third tab
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
}

