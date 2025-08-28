import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../SVSaleModel/GetARBItemMasterListModel.dart';
import '../SVSaleModel/GetArbCurrentStockListModel.dart';
import '../UpdatePaymentsScreen/GetCashHandOverDtlsListModel.dart';
import '../UpdatePaymentsScreen/GetPaymentDetailListModel.dart';
import '../UpdatePaymentsScreen/GetVendorMasterListModel.dart';
import 'AddPaymentPopupScreen.dart';
import 'GetARBItemPurListModel.dart';

class ArbScreen extends StatefulWidget {
  static const screenName = '/arbScreen';

  const ArbScreen({super.key});

  @override
  State<ArbScreen> createState() => _ArbScreenState();
}
class _ArbScreenState extends State<ArbScreen> {

  List<DenomModel> getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<TextEditingController> qtyController = [];
  List<double> amounts = [];
  List<GetArbItemPurListModel> paymentModel = [];
  double? totalamt;
  bool isLoading = true;
  bool _isInvoiceEmpty = false;
  bool _isVendorName = false;
  bool _isConCOntactEmpty = false;
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  String balanceAmount = '';
  String? _selectedVendor;
  int? vendorId;
  double? basicAmt;
  double? taxAmt;
  double? netAmount;
  double? basicAmount;
  String? selectedTransMode;
  List<String> getTransMode = ["Cash", "Online"];
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  bool _isTranscode = false;
  int _selectedIndex = 0;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  DateTime selectedDate = DateTime.now();
  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late final _invoiceController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  final remarkController = TextEditingController();
  late var finalAmountController = TextEditingController();
  final TranCodeController = TextEditingController();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  Map<int, String?> _selectedItems = {};
  List<Map<String, TextEditingController>> items = [];
  List<GetVendorMasterListModel> vendorModel = [];
  GetVendorMasterListModel? _selectVendor;
  List<GetArbItemMasterListModel> _items = [];
  List<GetArbCurrentStockListModel> svcStock = [];
  Map<int, int?> _itemStockByIndex = {};
  Map<int, int?> _selectedItemIds = {};
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  var argValue;
  String? modes;
  int? arbPurIdEdit;
  bool saveFlag = false;


  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();

    _addNewItem();
    getCashHandOverDtlsList(selectedDate);
    getVendorMasterList();
    //getArbCurrentStockList();
    getArbItemMasterListModel();
    fetchBank();
    getNoteTypeAndIDList();
    getARBItemPurList();
    // checkAndSaveDayEndData();


    Future.delayed(Duration.zero, () async{

        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        modes = argValue?["modeChange"]?? '';

        if (argValue != null) {
          final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

          final itemsToShow = argValue["itemsToShow"] ?? [];
          arbPurIdEdit = int.tryParse(argValue["arbPurIdEditV"] ?? 0);
          //String basicAmountEdit = argValue["basicAmountV"] ?? 0;
         // String taxAmountEdit = argValue["taxAmountV"] ?? 0;
          String netAmountEdit = argValue["netAmountV"] ?? 0;
          String invoiceNoEdit = argValue["invoiceNoV"] ?? 0;
          vendorId = int.tryParse(argValue["vendorIdV"] ?? '') ?? 0;
          String vendorName = argValue["vendorNameV"] ?? 0;
          String totalAmountEdit = argValue["totalAmountV"] ?? 0;
          String remarkEdit = argValue["remarkV"] ?? 0;

          finalAmountController.text = totalAmountEdit;
          remarkController.text = remarkEdit;
          _invoiceController.text = invoiceNoEdit;
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
      String? Basicamt = lastItem['bamt']?.text.trim();
      String? taxamt = lastItem['tamt']?.text.trim();
      String? netamt = lastItem['namt']?.text.trim();
      //String? totalamt = lastItem['famt']?.text.trim();

      if (rate!.isEmpty || qty!.isEmpty || netamt!.isEmpty) {
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
        'bamt': TextEditingController(),
        'tamt': TextEditingController(),
        'namt': TextEditingController(),

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
      items[index]['bamt']?.dispose();
      items[index]['tamt']?.dispose();
      items[index]['namt']?.dispose();


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
    for (var item in items) {
      item['namt']!.dispose();
    }
    finalAmountController.dispose();
    super.dispose();
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
          'qty': TextEditingController(text: item.purQty?.toString() ?? '0'),
          'bamt': TextEditingController(text: item.basicAmount?.toString() ?? '0'),
          'tamt': TextEditingController(text: item.taxAmount?.toString() ?? '0'),
          'namt': TextEditingController(text: item.netAmount?.toString() ?? '0'),
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
    child:Scaffold(
      appBar: CustomAppBarManager(
        title: 'ARB Purchase', // Title or hint text for the text field
      ),
    body:
    Padding(
    padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: textWidgetBlueColorWithoutStar(
                'Cash In Hand'),
          ),
          Flexible(flex: 1,
            child:
            Text('${formatCurrency(totalamt ?? 0)}',
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: textWidgetBlueColorWithoutStar('Invoice Date'),
          ),
          Flexible(flex: 1,
            child: Text("$formattedDate",
              style: Styling.itemGreyText,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: textWidgetBlueColorWithStar(
              'Invoice No',
              "*",
            ),
          ),
          Flexible(
            flex: 1,
            child: TextField(
              controller: _invoiceController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20), // Limit to 9 characters total
              ],
              onChanged: (value) {
                setState(() {
                  _isInvoiceEmpty = value.isEmpty;
                  double val = double.tryParse(value.replaceAll(',', '')) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: 'Invoice No',
                hintStyle: Styling.itemBlackTestSmall,
                // labelStyle: Styling.itemBlackTestSmall,
                errorText: _isInvoiceEmpty ? 'Invoice No. is Required' : null,
                errorStyle: TextStyle(color: Colors.red),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidgetBlueColorWithStar(
            'Vendor Name',
            "*",
          ),
          SizedBox(width: 10,),
          ElevatedButton(
            onPressed: (){
              setState(() {
                 _showAddVendorPopup();
              });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                backgroundColor: Colors.blue),
          ),
          SizedBox(width: 20,),
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
                  style: Styling.hintTextSmall),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
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
                // border: OutlineInputBorder(),
              ),
             // maxLines: 2, // Allows multiline remarks
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
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
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Item Name', style: TextStyle(fontSize: 12)),
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
                              _selectedItemIds[index] = selectedItem.itemId?.toInt();

                              items[index]['qty']?.clear();
                              items[index]['bamt']?.text;
                              items[index]['tamt']?.text;
                              items[index]['namt']?.text;

                              print("Selected item: ${selectedItem.itemName}");
                            });
                          }
                        },
                      ),
                    ),
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
                SizedBox(height: 10),
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
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [countTextWidgetTextStar(context, 'Rate', showAsterisk: true)],
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            basicAmount = calculateBasicAmount(index);
                            items[index]['bamt']?.text = basicAmount!.toStringAsFixed(2);
                            netAmount = calculateNetAmount(index);
                            items[index]['namt']?.text = netAmount!.toStringAsFixed(2);
                            // finalAmountController.text = netAmount!.toStringAsFixed(2);
                            debugPrint("netAmount $netAmount");
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: items[index]['qty'],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [countTextWidgetTextStar(context, 'Qty', showAsterisk: true)],
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            basicAmount = calculateBasicAmount(index);
                            items[index]['bamt']?.text = basicAmount!.toStringAsFixed(2);
                            netAmount = calculateNetAmount(index);
                            items[index]['namt']?.text = netAmount!.toStringAsFixed(2);
                           updateTotalAmount();
                            // finalAmountController.text = netAmount!.toStringAsFixed(2);
                            debugPrint("netAmount $netAmount");
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: items[index]['bamt'],
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text('Basic Amt.',
                               style: Styling.itemGreyTextSmall)],
                          ),
                        ),
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: items[index]['tamt'],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text('Tax Amt', style: Styling.itemBlackTestSmall,)],
                          ),
                          errorText: (items[index]['tamt']?.text.isNotEmpty ?? false) &&
                              double.tryParse(items[index]['tamt']?.text ?? '') != null &&
                              double.parse(items[index]['tamt']?.text ?? '0') >
                                  double.parse(items[index]['bamt']?.text ?? '0')
                              ? 'Tax amount cannot exceed basic amount'
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            basicAmt = double.tryParse(items[index]['bamt']?.text ?? '0');
                            taxAmt = double.tryParse(items[index]['tamt']?.text ?? '0');

                            if (basicAmt != null && taxAmt != null) {
                              if (taxAmt! > basicAmt!) {
                                items[index]['tamt']?.text = '';
                                taxAmt = 0.0;
                              }

                              netAmount = calculateNetAmount(index);
                              items[index]['namt']?.text = netAmount!.toStringAsFixed(2);
                              updateTotalAmount();
                              // finalAmountController.text = netAmount!.toStringAsFixed(2);
                              debugPrint("netAmount $netAmount");
                            }else{
                              updateTotalAmount();
                              debugPrint("netAmount1 $netAmount");
                              netAmount = calculateNetAmount(index);
                              items[index]['namt']?.text = netAmount!.toStringAsFixed(2);
                              // finalAmountController.text = netAmount!.toStringAsFixed(2);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: items[index]['namt'],
                        decoration: InputDecoration(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text('Net Amt.',
                                style: Styling.itemGreyTextSmall)],
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
     if(items.isNotEmpty)
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: textWidgetBlueColorWithoutStar(
                'Total Amount'),
          ),
          Flexible(
            child:
            TextField(
              controller: finalAmountController,
              decoration: InputDecoration(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   // Text('Total Amount'),
                  ],
                ),
              ),
              enabled: false,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
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
              if(saveFlag){
                showFlushBar(context,
                    Constants.dayEndCompleted);
              }else{
                if(modes == "EDIT"){
                  paymentDetailAddEditForMob(arbPurIdEdit!, "EDIT");
                }else{
                  paymentDetailAddEditForMob(0, "ADD");
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

      Card(
        child: paymentModel.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: paymentModel.length,
          itemBuilder: (context, index) {
            GetArbItemPurListModel? payList = paymentModel[index];
            return  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Text(payList.invoiceNo ?? '', style: TextStyle(color: Colors.blue),),),
                    Expanded(child: Text(payList.invoiceDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.invoiceDate!)) : '', style: TextStyle(color: Colors.blue),),),
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
                              }else{
                                int? pId = (payList.aRBPurId)?.toInt();
                                print('Edit button pressed ${payList.aRBPurId}');

                                // Check what balanceAmount contains
                                print("balanceAmount: ${payList.paidAmount}");

                                // Initialize balance as 0.0 in case parsing fails
                                double balance = payList.paidAmount?.toDouble() ?? 0.0;  // Safe conversion

                                // Check if balance is less than or equal to 0
                                if (balance > 0) {
                                  EasyLoading.showToast(
                                    Constants.partialPayErr1,
                                    duration: const Duration(milliseconds: 3000),
                                  );
                                  return; // Exit early if balance is less than or equal to zero
                                }
                                else {
                                  setState(() {
                                    print("Editing ARBPurId: ${payList.aRBPurId}");

                                    var arbPurId = payList.aRBPurId.toString();
                                    var itemsToShow = payList.itemDetails?.toList();
                                    var invoiceNo = payList.invoiceNo.toString();
                                    var itemName = payList.invoiceNo.toString();
                                    var vendorId = payList.vendorId.toString();
                                    var vendorName = payList.vendorName.toString();
                                    var totalAmount = payList.totalAmount.toString();
                                    var remark = payList.remark.toString();
                                    var netAmt = payList.netAmount.toString();

                                    // Navigate to the target screen and pass the data
                                    Navigator.pushNamed(
                                      context,
                                      ArbScreen.screenName,
                                      arguments: {
                                        'arbPurIdEditV': arbPurId,
                                        'itemsToShow': itemsToShow,
                                        'netAmountV': netAmt,
                                        'invoiceNoV': invoiceNo,
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
                              }else{
                                int? pId = (payList.aRBPurId)?.toInt();
                                print('Delete button pressed ${payList.aRBPurId}');

                                // Check what balanceAmount contains
                                print("balanceAmount: ${payList.paidAmount}");

                                // Initialize balance as 0.0 in case parsing fails
                                double balance = payList.paidAmount?.toDouble() ?? 0.0;  // Safe conversion

                                // Check if balance is less than or equal to 0
                                if (balance > 0) {
                                  EasyLoading.showToast(
                                    Constants.partialPayErr,
                                    duration: const Duration(milliseconds: 3000),
                                  );
                                  return; // Exit early if balance is less than or equal to zero
                                } else {
                                  // Show confirmation dialog for deletion
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
                                    if (pId != null) {
                                      // Call the function to delete the payment
                                      paymentDetailAddEditForMob(pId, "DELETE");
                                      print('Delete button pressed for payment ID: $pId');
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
                    Expanded(flex:1,child: countTextWidgetText(context,"Vendor Name", payList.vendorName ?? '')),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Total Amt", formatCurrency(payList.totalAmount!.toDouble()))),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Paid Amt", formatCurrency(payList.paidAmount!.toDouble()))),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Balance Amount", formatCurrency(payList.balanceAmount!.toDouble()))),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (payList.balanceAmount! >= 0) { // Only proceed if balanceAmount is non-negative
                            setState(() {
                              var invoiceNo = payList.invoiceNo.toString();
                              var vendorId = payList.vendorId.toString();
                              var vendorName = payList.vendorName.toString();
                              var totalBillAmt = payList.totalAmount.toString();
                              var balanceAmt = payList.balanceAmount.toString();
                              var arbPurId = payList.aRBPurId.toString();

                              Navigator.pushNamed(
                                context,
                                AddPaymentPopupScreen.screenName,
                                arguments: {
                                  'invoiceNoEdit': invoiceNo,
                                  'VendorNameEdit': vendorName,
                                  'VendorIdEdit': vendorId,
                                  'totalBillAmtEdit': totalBillAmt,
                                  'balanceAmt': balanceAmt,
                                  'arbPurIdEdit': arbPurId,
                                },
                              );
                              print('Add Payment Clicked$invoiceNo');
                            });
                          } else {
                            print('Balance is negative, action disabled');
                          }
                        },
                        child:
                          (payList.balanceAmount ?? 0.0) < 0
                              ? SizedBox.shrink() // renders nothing
                              : Text(
                              (payList.balanceAmount == 0 || payList.balanceAmount == 0.0)
                              ? "Payment Done"
                              : 'Add Payment',
                            style: TextStyle(
                              color: (payList.balanceAmount == 0 || payList.balanceAmount == 0.0)
                                  ? Colors.blue
                                  : Colors.red,
                              decoration: TextDecoration.underline,
                              decorationColor: (payList.balanceAmount == 0 || payList.balanceAmount == 0.0)
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          )
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

      Navigator.pushNamed(
        context,
        BottomNavBarExample.screenName,
        arguments: 3, // This opens the third tab
      );
      EasyLoading.showToast(Constants.expenseSendMgr,
          duration: const Duration(milliseconds: 3000));
      setState(() {
        getCashHandOverDtlsList(selectedDate);
      });
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
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

  Future<void> paymentDetailAddEditForMob(int arbPurId ,String action) async {

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
        'PurQty': item['qty']?.text ?? '',
        'BasicAmount': item['bamt']?.text ?? '',
        'TaxAmount': item['tamt']?.text ?? '',
        'NetAmount': item['namt']?.text ?? '',
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
      //     item['PurQty'].toString().isNotEmpty
      // );
      // if (!hasValidQty) {
      //   showFlushBar(context, "Please Select The Qty");
      //   return;
      // }
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

      if (finalAmountController.text.isNotEmpty) {
        totalAmt = double.parse(finalAmountController.text);
      }

      if (_invoiceController.text.isNotEmpty) {
        invoiceNo = _invoiceController.text;
      }
      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      }

      if (!_invoiceController.text.isNotEmpty) {
        showFlushBar(context, Constants.reqfield);
        return;
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
      "ARBPurId": arbPurId,
      "pkId":0,
      "ItemId": 0,
      "Rate": 0,
      "PurQty": 0,
      "BasicAmt": basicAmt ?? 0,
      "TaxAmount": taxAmt ?? 0,
      "NetAmount": netAmt ?? 0,
      "DistributorId":distributorId,
      "InvoiceNo": invoiceNo ?? '',
      "VendorId": vendorId ?? '',
      "InvoiceDate": formattedDate,
      "TotalAmount": totalAmt,
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
      Uri.parse('${AppUrl.AddEditARBItemPurchase}'),
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
          ArbScreen.screenName,
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
      Uri.parse('${AppUrl.GetARBItemPurList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemPurList : " +
        '${AppUrl.GetARBItemPurList}/$distributorId');
    debugPrint("GetARBItemPurList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) {
          return GetArbItemPurListModel.fromJson(json);
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

  void cancelAction(){
    setState(() {
      _invoiceController.clear();
      finalAmountController.clear();
      selectedBankName = '';
      balanceAmount = '0.0';
      selectedTransMode = null;
      selectedBankId = null;
      selectedTransMode = null;
      _selectBankModel = null;
      selectedTransMode = null;
      _selectVendor = null;
      TranCodeController.clear();
      timeController.clear();
      remarkController.clear();
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      modes = "Save";
      Navigator.pop(context);
      Navigator.pushNamed(
          context,
          ArbScreen.screenName// This opens the third tab
      );
    });
  }

  void _showAddVendorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Vendor Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: vendorNameController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                    inputFormatters: <TextInputFormatter>[
                    ],
                    decoration: InputDecoration(
                      errorText: _isVendorName ? 'Vendor Name Is Required' : null,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          countTextWidgetTextStar(
                            context,
                            'Vendor Name',
                            showAsterisk: true,
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isVendorName = value.isEmpty;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      errorText: _isConCOntactEmpty
                          ? 'Mobile No Is Required'
                          : _isInvalidMobile
                          ? 'Please Enter A Valid Consumer Contact No.'
                          : _isShortLength
                          ? 'Consumer Contact No. must be 10 digits'
                          : null,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          countTextWidgetTextStar(
                            context,
                            'Contact No',
                            showAsterisk: true,
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isConCOntactEmpty = value.isEmpty;
                        if (value.isNotEmpty) {
                          _isInvalidMobile = !RegExp(r'^[6789]').hasMatch(value); // Check first digit
                          _isShortLength = value.length < 10;
                        } else {
                          _isInvalidMobile = false; // Reset the error if the input is empty
                          _isShortLength = false;
                        }
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    vendorNameController.clear();
                    mobileNumberController.clear();
                    //Navigator.of(context).pop(); // Close popup
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String vendorName = vendorNameController.text.trim();
                    String mobileNumber = mobileNumberController.text.trim();

                    // Check if the mobile number is valid
                    if (_isConCOntactEmpty || _isInvalidMobile || _isShortLength) {
                      showFlushBar(context, "Invalid mobile number.");
                      return;
                    }
                    // Check if both fields are empty
                    if (vendorName.isEmpty || mobileNumber.isEmpty) {
                      showFlushBar(context, "Both fields are required.");
                      return;
                    }
                    // Proceed with saving
                    saveVendorPopupForMob();
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

  double calculateBasicAmount(int index) {
    // Get the rate and quantity controllers safely
    var rateController = items[index]['rate'];
    var qtyController = items[index]['qty'];

    // Parse the values, ensuring they are not null or empty
    double rate = double.tryParse(rateController?.text.trim() ?? '0') ?? 0.0;
    double qty = double.tryParse(qtyController?.text.trim() ?? '0') ?? 0.0;

    // Log the values for debugging purposes
    print("Rate: $rate, Qty: $qty");

    // Return the calculated basic amount (rate * qty)
    return rate * qty;
  }

  double calculateNetAmount(int index) {
    // Get the values from the controllers
    double qty = double.tryParse(items[index]['qty']?.text ?? '0') ?? 0;
    double rate = double.tryParse(items[index]['rate']?.text ?? '0') ?? 0;
    double tamt = double.tryParse(items[index]['tamt']?.text ?? '0') ?? 0;

    // Calculate the basic amount
    double basicAmount = qty * rate;
    debugPrint("basicAmount $basicAmount");

    // The net amount is the sum of the basic amount and the tax amount
    double netAmount = basicAmount + tamt;
    debugPrint("netAmount $netAmount");

    final formattedTotal = netAmount.toStringAsFixed(2);
    finalAmountController.text = formattedTotal;

    debugPrint("formattedTotal $formattedTotal");
    // Return the net amount
    return netAmount;
  }

  void updateTotalAmount() {
    double total = 0.0;

    for (var item in items) {
      final netAmtText = item['namt']?.text.trim() ?? '';
      final netAmt = double.tryParse(netAmtText) ?? 0.0;
      total += netAmt;
    }
    final formattedTotal = total.toStringAsFixed(2);

      finalAmountController.text = formattedTotal;

    debugPrint("formattedTotal $formattedTotal");
  }

}