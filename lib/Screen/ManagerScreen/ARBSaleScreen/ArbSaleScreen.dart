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
            title: 'ARB Sale', // Title or hint text for the text field
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.only(left: 5.0, right: 5, top: 15, bottom: 15),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar('Sale Date')),
                      Flexible(flex: 1, child: Text(formattedDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(formattedDate!)) : '', style: Styling.itemGreyText,),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar('Referred By')),
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
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                        // textWidgetBlueColorWithStar(
                        //   'Consumer No.',
                        //   '*',
                        // ),
                        textWidgetBlueColorWithoutStar(
                          'Consumer No.',
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: conNoController,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly,// Allow only digits
                          ],
                          decoration: InputDecoration(
                            labelText: 'Enter Consumer No.',
                            labelStyle: Styling.hintTextVerySmall,
                            // Show error if required
                          ),
                          onChanged: (value) {
                            setState(() {
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                        // textWidgetBlueColorWithStar(
                        //   'Consumer No.',
                        //   '*',
                        // ),
                        textWidgetBlueColorWithStar(
                          'Invoice No. OR DC No.',
                          "*",
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child:
                        TextField(
                          controller: invNoController,
                          readOnly: invoiceAutoManualMandatory, // ✅ change here
                          enabled: true,
                          //enabled: !invoiceAutoManualMandatory, // Disable if Auto
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          inputFormatters: invoiceAutoManualMandatory
                              ? []
                              : <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(16),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: invoiceAutoManualMandatory
                                ? 'Invoice No. (Auto)'
                                : 'Enter Invoice No.',
                            labelStyle: Styling.hintTextVerySmall,
                            suffixIcon: Tooltip(
                              triggerMode: TooltipTriggerMode.tap, // 👈 IMPORTANT
                              message: invoiceAutoManualMandatory
                                  ? 'auto-generated Invoice number'
                                  : 'Manual Invoice Number',
                              child: Icon(
                                Icons.error_outline,
                                color: invoiceAutoManualMandatory
                                    ? Colors.blue
                                    : Colors.blue,
                              ),
                            ),
                            errorText: _isInvoiceEmpty
                                ? 'Invoice No. OR DC No. Is Required'
                                : null,
                          ),
                          //onChanged: invoiceAutoManualMandatory ? null : (value) {},
                          onChanged: (value) {
                            setState(() {
                              _isInvoiceEmpty = value.isEmpty;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar('Consumer Name',
                            "*"),
                        // textWidgetBlueColorWithoutStar(
                        //   'Consumer Name',
                        // ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: conNameController,
                          decoration: InputDecoration(
                            labelText: 'Enter Consumer Name',
                            labelStyle: Styling.hintTextVerySmall,
                            errorText: _isconNoEmpty
                                ? 'Consumer Name Is Required'
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isconNoEmpty = value.isEmpty;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar('Consumer Contact No.'),
                        // textWidgetBlueColorWithoutStar(
                        //   'Consumer Name',
                        // ),
                      ),
                      Flexible(
                        flex: 1,
                        child:
                        TextField(
                          controller: conContNoController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Enter Consumer Contact No',
                            labelStyle: Styling.hintTextVerySmall,
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
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar('Consumer Address'),
                        // textWidgetBlueColorWithoutStar(
                        //   'Consumer Name',
                        // ),
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: conAddNoController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(250),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Enter Consumer Address',
                            labelStyle: Styling.hintTextVerySmall,
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
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
                                            orElse: () => GetArbItemMasterListModel(), // Default item in case not found
                                          );

                                          int? currentStock = getArbItemCurrentStock(selectedItem.itemId?.toInt())?.toInt();
                                          _itemStockByIndex[index] = currentStock;
                                          _selectedItemIds[index] = selectedItem.itemId?.toInt();

                                          String? category = selectedItem.categoryName;

                                          // Check if stock is available
                                          if (category != "Non ARB Item" && currentStock == 0 || currentStock == null) {
                                            // Stock is not available, set amt to 0 and default qty to 1
                                            items[index]['amt']?.clear();
                                            items[index]['qty']?.clear();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('The Item Quantity Cannot Exceed The Available Stock: $currentStock')),
                                            );

                                            // Set rate, amt to 0, and qty to 1
                                            double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                            double amount = 0; // Explicitly set amount to 0 when stock is unavailable

                                            // Update the form fields with rate, amt (0), and qty (1)
                                            items[index]['rate']?.text = rate.toString();
                                            items[index]['amt']?.text = amount.toString(); // Set amt to 0
                                            items[index]['qty']?.text = '1'; // Default quantity to 1
                                            items[index]['discount']?.clear(); // Optionally clear discount

                                            // Log output for debugging
                                            print("Selected item: ${selectedItem.itemName}");
                                            print("Rate: $rate");
                                            print("Amount: $amount");

                                          } else {
                                            // Stock is available, proceed with normal amount calculation
                                            double rate = selectedItem.rate?.toDouble() ?? 0.0;
                                            double amount = rate * 1; // Set amount to rate * 1 (default qty)

                                            // Update the form fields with rate, amt, and qty
                                            items[index]['rate']?.text = rate.toString();
                                            items[index]['amt']?.text = amount.toString(); // Set amt based on rate * 1 (default qty)
                                            items[index]['qty']?.clear(); // Clear previous quantity input
                                            items[index]['discount']?.clear(); // Optionally clear discount

                                            // Log output for debugging
                                            print("Selected item: ${selectedItem.itemName}");
                                            print("Rate: $rate");
                                            print("Amount: $amount");

                                            // Set default qty = 1 if stock is available
                                            items[index]['qty']?.text = '1'; // Default quantity to 1
                                          }

                                          // Update the total amount and other logic
                                          _updateSum(index);
                                          updateTotalAmount();

                                          // Move focus to the discount field after a slight delay
                                          Future.delayed(Duration(milliseconds: 100), () {
                                            if (_discountFocusNodes.length > index) {
                                              FocusScope.of(context).requestFocus(_discountFocusNodes[index]);
                                            }
                                          });

                                          // If it's the last item, add a new item (you can adjust this condition as needed)
                                          if (index == items.length - 1) {
                                            _addNewItem();
                                          }
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
                                        children: [Text('Rate' ?? '0',style: Styling.itemGreyTextSmall,)],
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
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        bool isNotNull = value.isNotEmpty;
                                        int enteredQty = int.tryParse(value) ?? 0;
                                        int? stockLimit = _itemStockByIndex[index];

                                        // Get the selected item category
                                        final selectedItem = _items.firstWhere(
                                              (item) => item.itemName == _selectedItems[index],
                                          orElse: () => GetArbItemMasterListModel(),
                                        );

                                        String? category = selectedItem.categoryName;

                                        debugPrint("Category: $category | stockLimit: $stockLimit");

                                        if (isNotNull) {
                                          //Check stock only for allowed categories
                                          if (category != "Non ARB Item") {
                                            if (stockLimit != null && enteredQty > stockLimit) {
                                              items[index]['amt']?.clear();
                                              items[index]['qty']?.clear();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('The Item Quantity Cannot Exceed The Available Stock: $stockLimit'),
                                                ),

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
                                ),
                                //i dont want to show error content: Text('Entered quantity exceeds current stock: $stockLimit'), msg for non ARB items and other category
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
                                        children: [Text('Discount',style: Styling.itemBlackTestSmall,)],
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _updateSum(index);
                                        updateTotalAmount();
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
                                        children: [Text('Amt.',style: Styling.itemGreyTextSmall,)],
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
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                        textWidgetBlueColorWithStar(
                          'Payment Mode',
                          "*", // Add a parameter to conditionally show the asterisk
                        ),
                      ),
                      Flexible(flex: 1,
                        child:
                        DropdownButtonFormField<String>(
                          key: formKey2,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                          ),
                          //value: selectedTransMode,
                          value:getTransMode.contains(selectedTransMode) ? selectedTransMode : null,
                          // Bind the selected value
                          items: getTransMode.map((String value) =>
                              DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTransMode =
                                  value;

                              if (selectedTransMode != 'Cash' &&
                                  selectedTransMode != 'Partial') {
                                isCashDenominationChecked = false;
                              }
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar('Receipt Amount','*')),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: cashTotalReceiptAmount,
                            keyboardType:
                            TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,10}')),
                            ],
                            onChanged: (value){
                              setState(() {
                                var _isCash = value.isEmpty;
                                isEditingQR = false;
                                isEditingCash = true;

                                double totalAmount = double.tryParse(
                                    totalAmountController.text) ??
                                    0.0;
                                double qrAmount =
                                    double.tryParse(value) ?? 0.0;

                                if (qrAmount > totalAmount) {
                                  cashTotalReceiptAmount.clear();
                                } else {
                                  if(selectedTransMode == 'Partial'){
                                    updateRemainingAmount();
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  if (selectedTransMode == 'Merchant QR' || selectedTransMode == 'Partial')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar('Merchant Qr Amount','*')),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: merchantQrTotalReceiptAmount,
                            keyboardType:
                            TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,10}')),
                            ],
                            onChanged: (value){
                              setState(() {
                                var _isQRcode = value.isEmpty;
                                isEditingQR = true;
                                isEditingCash = false;
                                double totalAmount = double.tryParse(
                                    totalAmountController.text) ??
                                    0.0;
                                double qrAmount =
                                    double.tryParse(value) ?? 0.0;

                                if (qrAmount > totalAmount) {
                                  merchantQrTotalReceiptAmount.clear();
                                } else {
                                  if(selectedTransMode == 'Partial'){
                                    updateRemainingAmount();
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (selectedTransMode == 'Merchant QR' || selectedTransMode == 'Partial')
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child:
                              DropdownButtonFormField<
                                  GetBankMappingDetailsListModel>(
                                value:bankModel.contains(_selectBankModel)?_selectBankModel:null ,
                                items: bankModel.map((item) {
                                  return DropdownMenuItem<
                                      GetBankMappingDetailsListModel>(
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
                                hint: Text('Select Acc No'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                              TextField(
                                controller: TranCodeController,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Time',
                                  labelStyle: Styling.itemBlackTestSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                              TextField(
                                controller: transReviewController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Transaction Remark',
                                  labelStyle: Styling.itemBlackTestSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial')
                    CheckboxListTile(
                      title: const Text(
                        "Cash Denomination",
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: isCashDenominationChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isCashDenominationChecked = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  SizedBox(height: 10),
                  // if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial')
                    if ((selectedTransMode == 'Cash' || selectedTransMode == 'Partial')&& isCashDenominationChecked)
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
                  // if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial')
                    if ((selectedTransMode == 'Cash' || selectedTransMode == 'Partial')&& isCashDenominationChecked)
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
                  // if (selectedTransMode == 'Cash' || selectedTransMode == 'Partial')
                    if ((selectedTransMode == 'Cash' || selectedTransMode == 'Partial')&& isCashDenominationChecked)
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
                                                          index] = (double.tryParse(
                                                              value) ?? 0.0) *
                                                              data.noteType!;
                                                          totalAmount = amounts.fold(
                                                              0.0, (sum, amount) => sum + amount);
                                                          finalAmountCashDeno = totalAmount - returnAmount;
                                                          isQtyFilled[index] = value.isNotEmpty; // Mark index as filled
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
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 0,
                                                    child: Text(
                                                      totalAmount
                                                          .toStringAsFixed(
                                                          2),
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
                                                    qtyControllerReturn[
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
                                                        amountsReturn[index] = (double.tryParse(value) ?? 0.0) *
                                                            data.noteType!;
                                                        returnAmount = amountsReturn.fold(0.0, (sum, amount) =>
                                                        sum + amount);
                                                        finalAmountCashDeno = totalAmount - returnAmount;
                                                        debugPrint("return$returnAmount");
                                                      });
                                                    },
                                                    textAlign: TextAlign.center,
                                                    enabled: !isQtyFilled.containsKey(index) ||
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
                                                        .toStringAsFixed(
                                                        2),
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
                  SizedBox(height: 5),
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
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          if (saveFlag) {
                            print('saveFlag $saveFlag');
                            showFlushBar(context, Constants.dayEndCompleted);
                          } else {
                            if (modes == "EDIT") {
                              // Null check for paymentIdEdit
                              arbSalesAddEditForMob(arbSalesIdEdit!, "EDIT");
                            } else {
                              arbSalesAddEditForMob(0, "ADD");
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
                            vertical: 10, // Adjust padding to make button smaller
                          ),
                        ),
                        child: Text(
                          modes == "EDIT" ? 'Update' : 'Save',
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
                    child: arbSalesModel.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: arbSalesModel.length,
                      itemBuilder: (context, index) {
                        GetArbSalesListModel? payList = arbSalesModel[index];

                        return  Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: Text(payList.staffName ?? '', style: TextStyle(color: Colors.blue),),),
                                Expanded(child: Text(payList.saleDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.saleDate!)) : '', style: TextStyle(color: Colors.blue),),),
                                Expanded(
                                  flex: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                    children: [
                                      // Edit Icon
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                        onPressed: () {
                                          setState(() {
                                            loadDenominationData(payList.aRBSalesId!.toInt());
                                            var itemsToShow = payList.itemDataList?.toList();
                                            var saleDate= payList.saleDate.toString();
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
                                                  'referredByNameV' : referredByName,
                                                  'referredByIdV' : referredById,
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
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red), // Icon for delete
                                        onPressed: () async {
                                          if (saveFlag) {
                                            print('saveFlag $saveFlag');
                                            showFlushBar(context, Constants.dayEndCompleted);
                                          } else {
                                            // double? parsedBalance = double.tryParse(balanceAmt!); // Try parsing balanceAmt to double
                                            int? pId = (payList.aRBSalesId)?.toInt();
                                            print('Delete button pressed ${payList.aRBSalesId}');

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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 2),
                            Row(
                              children: [
                                // Expanded(
                                //   flex: 1,
                                //   child: countTextWidgetText(
                                //     context,
                                //     "Consumer No/Invoice No",
                                //     '${payList.consumerNo ?? ''}/${payList.invoiceNo ?? ''}',
                                //   ),
                                // ),
                                Expanded(
                                  flex: 1,
                                  child: countTextWidgetText(
                                    context,
                                    "Consumer No/Invoice No",
                                    (payList.consumerNo != null && payList.consumerNo!.isNotEmpty
                                        ? payList.consumerNo!
                                        : '') +
                                        ((payList.consumerNo != null && payList.consumerNo!.isNotEmpty) &&
                                            (payList.invoiceNo != null && payList.invoiceNo!.isNotEmpty)
                                            ? '/'
                                            : '') +
                                        (payList.invoiceNo != null && payList.invoiceNo!.isNotEmpty
                                            ? payList.invoiceNo!
                                            : ''),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(flex:1,child: countTextWidgetText(context,"Consumer Name", payList.consumerName ?? '')),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Row(
                            //         children: [
                            //           Text("Consumer Name : ",style: Styling.itemGreyTextSmall,),
                            //           Text(payList.consumerName.toString(),style: Styling.itemBlackTestSmall,),
                            //         ],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Row(
                            //         children: [
                            //           Text("Payment Mode : ",style: Styling.itemGreyTextSmall,),
                            //           Text((payList.paymentMode == 'Bank') ? 'Merchant QR' : (payList.paymentMode ?? ''),style: Styling.itemBlackTestSmall,),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            // ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: countTextWidgetText(context, "Payment Mode", (payList.paymentMode == 'Bank') ? 'Merchant QR' : (payList.paymentMode ?? '')
                                  ),
                                ),
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
                                Expanded(flex:1,child: countTextWidgetText(context,"Cash Rec. Amount", formatCurrency(payList.receiptAmt!.toDouble()))),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(flex:1,child: countTextWidgetText(context,"QR Rec. Amount", formatCurrency(payList.qRReceiptAmt!.toDouble()))),
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
  //     // 🔹 Find Invoice Auto configuration
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
  //         // 👇 Set auto invoice number
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

      // ✅ STRICTLY FIND AUTO
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
  //     // ✅ API RETURNS PLAIN VALUE (e.g. 90008)
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

      // ✅ API RETURNS PLAIN VALUE (e.g. 90008) OR QUOTED STRING
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


}



