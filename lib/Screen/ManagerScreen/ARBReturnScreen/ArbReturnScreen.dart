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

  @override
  void initState() {
    super.initState();
    _addNewItem();
    getVendorMasterList();
    getArbCurrentStockList();
    getArbItemMasterListModel();
    getARBItemPurList();

    Future.delayed(Duration.zero, () async{

      argValue = ModalRoute.of(context)?.settings.arguments as Map;
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
        await getVendorMasterList();
        getVendorMasterList().whenComplete((){
          debugPrint("referredByNameEdit:$vendorName");
          if(vendorName != "null" && vendorName.isNotEmpty && vendorName != null){
            setState(() {
              _selectVendor = vendorModel.firstWhere(
                    (item) => item.vendorName == vendorName,
                orElse: () => GetVendorMasterListModel(vendorName: ''),
              );
            }
            );
          }
        });
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

  // void _removeItem(int index) {
  //   setState(() {
  //     // Debugging: Print before removing
  //     print('Removing item at index: $index');
  //     print('Selected Items Before: $_selectedItems');
  //
  //     // Dispose the TextEditingController instances associated with the index
  //     items[index]['rate']?.dispose();
  //     items[index]['qty']?.dispose();
  //     items[index]['amount']?.dispose();
  //     items[index]['reason']?.dispose();
  //
  //     items.removeAt(index);
  //
  //     _selectedItems.remove(index);
  //     _selectedItems = Map.fromEntries(
  //       _selectedItems.entries.map((entry) {
  //         return entry.key > index
  //             ? MapEntry(entry.key - 1,
  //             entry.value) // Shift keys down after the removed index
  //             : entry;
  //
  //       }),
  //
  //     );
  //     updateTotalAmount();
  //     print('Selected Items After: $_selectedItems');
  //   });
  //   updateTotalAmount();
  // }

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

  // @override
  // void dispose() {
  //   for (var item in items) {
  //     item['amt']!.dispose();
  //   }
  //   totalAmountController.dispose();

  //   super.dispose();
  // }

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override

  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          // Show a confirmation dialog
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } else {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } // In case `null` is returned, return `false`
        },
    child:
      Scaffold(
      appBar: CustomAppBarManager(
        title: 'ARB Purchase Return', // Title or hint text for the text field
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
                  Expanded(child: textWidgetBlueColorWithoutStar('Return Date')),
                  Flexible(flex: 1, child: Text("$formattedDate", style: Styling.itemGreyText,)),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: textWidgetBlueColorWithStar(
                      'Vendor Name',
                      "*",
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child:
                      DropdownButtonFormField<GetVendorMasterListModel>(
                        isExpanded: true,
                        key: formKey1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: vendorModel.contains(_selectVendor)?_selectVendor:null ,
                        items: vendorModel.map((item) {
                          return DropdownMenuItem<GetVendorMasterListModel>(
                            value: item,
                            child: Text(
                              item.vendorName ?? '',
                              style: Styling.itemBlackTest,
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectVendor = selectedItem;
                            _selectedVendor = selectedItem?.vendorName ?? '';
                            vendorId = selectedItem?.vendorId?.toInt();
                          });
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a vendor';
                            }
                            return null;
                          };
                        },
                        hint: Text("Vendor Name",
                        style: Styling.hintTextSmall,),
                      ),

                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: textWidgetBlueColorWithoutStar(
                        'Enter Remark'
                    ),
                  ),
                  Flexible(flex: 1,
                    child:
                    TextField(
                      controller: remarkController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                      ],
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        labelStyle: Styling.itemBlackTestSmall
                      ),
                     // maxLines: 2, // Allows multiline remarks
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Add New Item',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: _isAddNewItemEnabled ? _addNewItem : null,
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
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: DropdownButtonFormField<String>(
                        //         decoration: InputDecoration(
                        //           isDense: true,
                        //           label: Row(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: const [
                        //               Text('Select Item', style: TextStyle(fontSize: 12)),
                        //               SizedBox(width: 4),
                        //               Icon(Icons.star, color: Colors.red, size: 10),
                        //             ],
                        //           ),
                        //         ),
                        //         value: _selectedItems[index]?.isEmpty ?? true
                        //             ? null
                        //             : _selectedItems[index],
                        //         items: _items
                        //             .where((item) =>
                        //         !_selectedItems.values.contains(item.itemName) ||
                        //             _selectedItems[index] == item.itemName)
                        //             .toSet()
                        //             .map((item) {
                        //           return DropdownMenuItem<String>(
                        //             value: item.itemName,
                        //             child: Text(item.itemName ?? 'Unknown'),
                        //           );
                        //         }).toList(),
                        //         onChanged: (selectedItemName) {
                        //           if (selectedItemName != null) {
                        //             setState(() {
                        //               _selectedItems[index] = selectedItemName;
                        //               final selectedItem = _items.firstWhere(
                        //                     (item) => item.itemName == selectedItemName,
                        //                 orElse: () => GetArbItemMasterListModel(),
                        //               );
                        //               int? currentStock =
                        //               getArbItemCurrentStock(selectedItem.itemId?.toInt())
                        //                   ?.toInt();
                        //               _itemStockByIndex[index] = currentStock;
                        //               _selectedItemIds[index] = selectedItem.itemId?.toInt();
                        //               double rate = selectedItem.rate?.toDouble() ?? 0.0;
                        //               items[index]['qty']?.clear();
                        //               items[index]['amount']?.text;
                        //               items[index]['reason']?.text;
                        //             });
                        //           }
                        //         },
                        //       ),
                        //     ),
                        //     SizedBox(width: 8),
                        //     ElevatedButton(
                        //       onPressed: () => _removeItem(index),
                        //       child: Icon(Icons.delete, color: Colors.red),
                        //       style: ElevatedButton.styleFrom(
                        //         shape: CircleBorder(),
                        //         padding: EdgeInsets.all(12),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text('Select Item', style: TextStyle(fontSize: 12)),
                                      SizedBox(width: 4),
                                      Icon(Icons.star, color: Colors.red, size: 10),
                                    ],
                                  ),
                                ),
                                value: _selectedItems[index]?.isEmpty ?? true
                                    ? null
                                    : _selectedItems[index],
                                items: _items.map((item) {
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
                                      double rate = selectedItem.rate?.toDouble() ?? 0.0;

                                      items[index]['qty']?.clear();
                                      items[index]['amount']?.text;
                                      items[index]['reason']?.text;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _removeItem(index),
                              child: Icon(Icons.delete, color: Colors.red),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: items[index]['rate'],
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      countTextWidgetTextStar(context, 'Rate', showAsterisk: true),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    updateTotalAmount();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
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
                                           // backgroundColor: Colors.red,
                                          ),
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
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: items[index]['amount'],
                                enabled: false,
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('Amount',
                                    style: Styling.itemGreyTextSmall,)],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: items[index]['reason'],
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(250),
                                ],
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  isDense: true,
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('Reason',
                                    style: Styling.itemBlackTestSmall,)],
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              if(items.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: textWidgetBlueColorWithoutStar('Total Amount')),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: totalAmountController,
                      enabled: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
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
                      if(saveFlag){
                        showFlushBar(context,
                            Constants.dayEndCompleted);
                      }else {
                        if (modes == "EDIT") {
                          arbItemAddEditForMob(arbPurIdEdit!, "EDIT");
                        } else {
                          arbItemAddEditForMob(0, "ADD");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical:
                          10), // Adjust padding to make button smaller
                    ),
                    child: Text(
                      modes == "EDIT"?'Update':'Save',
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
                child: paymentModel.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: paymentModel.length,
                  itemBuilder: (context, index) {
                    GetArbItemRetListModel? payList = paymentModel[index];
                    return  Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(child: Text(payList.vendorName.toString() ?? '', style: TextStyle(color: Colors.blue),),),
                            Expanded(child: Text(payList.returnDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.returnDate!)) : '', style: TextStyle(color: Colors.blue),),),
                            Expanded(
                              flex: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                children: [
                                  // Edit Icon
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                    onPressed: () async{
                                     if(saveFlag){
                                     showFlushBar(context,
                                     Constants.dayEndCompleted);
                                      }else {
                                       int? pId = (payList.aRBRetId)?.toInt();
                                       print('Edit button pressed ${payList
                                           .aRBRetId}');

                                       // Check what balanceAmount contains
                                       print("balanceAmount: ${payList
                                           .totalAmount}");

                                       // Initialize balance as 0.0 in case parsing fails
                                       double balance = payList.cNAmt
                                           ?.toDouble() ??
                                           0.0; // Safe conversion

                                       // Check if balance is less than or equal to 0
                                       if (balance != 0) {
                                         EasyLoading.showToast(
                                           Constants.creditPayErr,
                                           duration: const Duration(
                                               milliseconds: 3000),
                                         );
                                         return; // Exit early if balance is less than or equal to zero
                                       }
                                       else {
                                         setState(() {
                                           print("Editing ARBPurId: ${payList
                                               .aRBRetId}");

                                           var aRBRetId = payList.aRBRetId
                                               .toString();
                                           var itemsToShow = payList.itemDetails
                                               ?.toList();
                                           var vendorId = payList.vendorId
                                               .toString();
                                           var vendorName = payList.vendorName
                                               .toString();
                                           var totalAmount = payList.totalAmount
                                               .toString();
                                           var remark = payList.remark
                                               .toString();

                                           // Navigate to the target screen and pass the data
                                           Navigator.pushNamed(
                                             context,
                                             ArbReturnScreen.screenName,
                                             arguments: {
                                               'arbPurIdEditV': aRBRetId,
                                               'itemsToShow': itemsToShow,
                                               'vendorIdV': vendorId,
                                               'vendorNameV': vendorName,
                                               'totalAmountV': totalAmount,
                                               'remarkV': remark,
                                               'modeChange': "EDIT"
                                             },
                                           );
                                         });
                                       }
                                     }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red), // Icon for delete
                                    onPressed: () async {
                                  if(saveFlag){
                                  showFlushBar(context,
                                Constants.dayEndCompleted);
                                }else {
                                    int? pId = (payList.aRBRetId)?.toInt();
                                    print('Delete button pressed ${payList
                                        .aRBRetId}');

                                    // Check what balanceAmount contains
                                    print("balanceAmount: ${payList
                                        .totalAmount}");

                                    // Initialize balance as 0.0 in case parsing fails
                                    double balance = payList.cNAmt
                                        ?.toDouble() ?? 0.0; // Safe conversion

                                    // Check if balance is less than or equal to 0
                                    if (balance != 0) {
                                      EasyLoading.showToast(
                                        Constants.creditPayErr1,
                                        duration: const Duration(
                                            milliseconds: 3000),
                                      );
                                      return; // Exit early if balance is less than or equal to zero
                                    } else {
                                      // Show confirmation dialog for deletion
                                      bool? confirmDelete = await showDialog<
                                          bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                                'You want to delete?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // User pressed Cancel
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      true); // User pressed Delete
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      // If user confirmed deletion
                                      if (confirmDelete == true) {
                                        if (pId != null) {
                                          // Call the function to delete the payment
                                          arbItemAddEditForMob(pId, "DELETE");
                                          print(
                                              'Delete button pressed for payment ID: $pId');
                                        } else {
                                          print("Receipt ID is null.");
                                        }
                                      } else {
                                        print('Delete action was canceled');
                                      }
                                    }
                                  }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex:1,child: countTextWidgetText(context,"Credit No", payList.cNNo ?? '')),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex:1,child: countTextWidgetText(context,"Return Qty", payList.retQty.toString() ?? '')),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex:1,child: countTextWidgetText(context,"Total Amount", formatCurrency(payList.totalAmount!.toDouble()))),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex:1,child: countTextWidgetText(context,"Credit Amt", formatCurrency(payList.cNAmt!.toDouble()))),
                    Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          arbRetId = payList.aRBRetId?.toInt();
                          vendorId = payList.vendorId?.toInt();
                          vendorName = payList.vendorName.toString();
                           totalAmt = payList.totalAmount.toString();
                           cnAmt = payList.cNAmt?.toDouble();

                          if (cnAmt == 0.0) {
                            _showAddCustomerPopup();
                            print(
                                'Add Credit Note Clicked - arbRetId: $arbRetId');
                          }
                        });
                      },
                      child: Text(
                        (payList.cNAmt ?? 0.0) == 0.0
                            ? "Add Credit Note"
                            : "Credit Note Added",
                        style: TextStyle(
                          color: (payList.cNAmt ?? 0.0) == 0.0 ? Colors.blue : Colors.grey,
                          decoration: (payList.cNAmt ?? 0.0) == 0.0
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationColor: (payList.cNAmt ?? 0.0) == 0.0 ? Colors.blue : null,
                        ),
                      ),
               ),
             ),
           ],
          ),
         Divider(
          color: Colors.white70, thickness: 3),
        ],
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
        showFlushBar(context, "Please select the item");

        return;
      }
      bool hasValidRate = ItemDetails.any((item) =>
      item['ItemId'] != 0 &&
          item['Rate'].toString().isNotEmpty
      );
      if (!hasValidRate) {
        showFlushBar(context, "Please select the rate");
        return;
      }

      bool hasValidQty = ItemDetails.any((item) =>
      item['ItemId'] != 0 &&
          item['RetQty'].toString().isNotEmpty
      );
      if (!hasValidQty) {
        showFlushBar(context, "Please select the qty");
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
        // totalAmount = totalAmount - discountAmt;

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

  // void calculateAmount(int index) {
  //   final rateText = items[index]['rate']?.text;
  //   final qtyText = items[index]['qty']?.text;
  //
  //   final rate = int.tryParse(rateText!) ?? 0;
  //   final qty = int.tryParse(qtyText!) ?? 0;
  //
  //   final amount = rate * qty;
  //
  //   // Update the amount TextEditingController
  //   items[index]['amount']?.text = amount.toStringAsFixed(2);
  //   totalAmountController.text = amount.toStringAsFixed(2);
  // }

  void _updateSum(int index) {
    // Get the values from the receivedQty and rate controllers
    double qtyNew = double.tryParse(items[index]['qty']?.text ?? '') ?? 0;
    double rateNew = double.tryParse(items[index]['rate']?.text ?? '') ?? 0;
    double totalSum = 0.0;

    // If qtyNew is not 0, calculate the amount
    if (qtyNew != 0) {
      totalSum = qtyNew * rateNew;
      items[index]['amount']?.text = totalSum.toStringAsFixed(2);
      debugPrint("totalSum: $totalSum");
    } else {
      // If qty is 0, just show rate as amount
      totalSum = rateNew;
      items[index]['amount']?.text = totalSum.toStringAsFixed(2);
      debugPrint("totalSum (qty is empty): $totalSum");
    }

    updateTotalAmount(); // Update grand total or related UI
  }


  void updateTotalAmount() {
    double total = 0.0;

    for (var item in items) {
      final amtText = item['amount']?.text.trim() ?? '';
      final amt = double.tryParse(amtText) ?? 0.0;
      total += amt;
    }
    final formattedTotal = total.toStringAsFixed(2);

    totalAmountController.text = formattedTotal;

    debugPrint("formattedTotal $formattedTotal");
  }

  void _showAddCustomerPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Credit Note Details"),
              content: SingleChildScrollView(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left-aligned text (Vendor Name)
                        countTextWidgetTextWithoutHeading(context, vendorName ?? ''),

                        // Right-aligned text (Total Amount)
                        countTextWidgetTextWithoutHeading(context, totalAmt?.toString() ?? ''),
                      ],
                    ),
                    //SizedBox(height: 10),
                    TextField(
                      controller: creditNoController,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                      inputFormatters: <TextInputFormatter>[
                      ],
                      decoration: InputDecoration(
                        errorText: _isCustomerName ? 'Credit No Is Required' : null,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Credit Note No',
                              showAsterisk: true,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isCustomerName = value.isEmpty;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: creditNoteAmtController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        errorText: _isCustomerName ? 'Credit Amt Is Required' : null,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Credit Note Amt',
                              showAsterisk: true,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (value) {
                        // setState(() {
                        //   _isCustomerName = value.isEmpty;
                        // });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: creditRemarkController,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                      inputFormatters: <TextInputFormatter>[
                      ],
                      decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            countTextWidgetTextStar(
                              context,
                              'Remark',
                               showAsterisk: false,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    creditNoController.clear();
                    creditNoteAmtController.clear();
                    creditRemarkController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  // onPressed: () {
            // String creditNo = creditNoController.text.trim();
            // String creditAmt = creditNoteAmtController.text.trim();
            // String creditRemark = creditRemarkController.text.trim();
            //
            // // Check if required fields are empty
            // if (creditNo.isEmpty || creditAmt.isEmpty) {
            // showFlushBar(context, "All fields are required.");
            // return;
            // }
            //
            // arbCreditNoteAddEditForMob();
            // Navigator.of(context).pop();
            // // }
            // },
                  onPressed: () {
                    String creditNo = creditNoController.text.trim();
                    String creditAmt = creditNoteAmtController.text.trim();
                    String creditRemark = creditRemarkController.text.trim();

                    // Check if required fields are empty
                    if (creditNo.isEmpty || creditAmt.isEmpty) {
                      showFlushBar(context, "All fields are required.");
                      return;
                    }

                    // Parse creditAmt safely
                    double? enteredAmt = double.tryParse(creditAmt);
                    double? totalAmounts = double.tryParse(totalAmt!);
                    debugPrint("enteredAmt$enteredAmt");
                    debugPrint("totalAmt$totalAmounts");
                    if (enteredAmt == null) {
                      showFlushBar(context, "Please enter a valid credit amount.");
                      return;
                    }

                    // Check if entered amount matches totalAmt
                    if (enteredAmt != totalAmounts) {
                      debugPrint("enteredAmt1$enteredAmt");
                      debugPrint("totalAmt1$totalAmounts");
                      showFlushBar(context, "The credit note amount cannot be greater than or less than the total amount.");
                      return;
                    }

                    arbCreditNoteAddEditForMob();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
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

