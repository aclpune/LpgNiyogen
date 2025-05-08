import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ConstantScreen/widgets.dart';
import '../../../../User/Login/provider/LoginProvider.dart';
import '../../../../User/splashscreen/page/splash_screen.dart';
import '../../../../Utils/CustomAppBar.dart';
import '../../../../Utils/Styling.dart';
import '../../../../Utils/app_url.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../BottomNavigationForGodownKeeper.dart';
import '../../CylItemList/CylItemListModel.dart';
import 'package:http/http.dart' as http;
import '../model/GetEXMIListModel.dart';
import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
class AddReturnItemXMIScreen extends StatefulWidget {
  static const screenName = '/addReturnItemXMIScreen';
  const AddReturnItemXMIScreen({super.key});

  @override
  State<AddReturnItemXMIScreen> createState() => _AddReturnItemXMIScreenState();
}

class _AddReturnItemXMIScreenState extends State<AddReturnItemXMIScreen> {
  final TextEditingController receiptDateController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  List<CylItemListModel> _items = [];
  Map<int, String?> _selectedItems = {};
  String? mobileNo;
  List<Map<String, TextEditingController>> items = [];
  bool saveFlag = false;
  var argValue;
  List<ItemDetails> itemsToShow = [];
  String? modes;
  int? receiptIds;
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  bool isLoading = true;
  Map<int, double> _previousInvoiceQuantities = {};
  // Function to check if items are available for selection
  bool get _isAddNewItemEnabled {
    // Check if there are any available items that haven't been selected yet
    return _items.any((item) => !_selectedItems.values.contains(item.itemName));
  }

  @override
  void initState() {
    super.initState();
    // Add the first item by default
    // Get today's date

    DateTime now = DateTime.now();

    // Format it as 'yyyy-MM-dd', or any format you prefer
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Set the formatted date as the default value in the TextField
    receiptDateController.text = formattedDate;
    _addNewItem();
    fetchItems();
    fetchCurrentStock();
    checkAndSaveDayEndData();
    vehicleNoController.addListener(_updateButtonState);
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        vehicleNoController.text = argValue?["vehicleNo"] ?? '';
        modes = argValue?["modeChange"]?? '';
        receiptIds = argValue["receiptID"]?? 0;
        if (argValue != null) {
          final itemsToShow = argValue["itemsToShow"] ?? [];
          // _initializeItems(itemsToShow);
          if (itemsToShow.isNotEmpty) {
            _initializeItems(itemsToShow);
          } else {
            // If no initial data, start with an empty list or default values
            _initializeItems([]);
          }
        }
      });
    });
  }

  void _updateButtonState() {
    setState(() {});  // Trigger a rebuild when text changes
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Return EXMI/Rev-EMR', // Title or hint text for the text field
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receipt Date & Vehicle Number
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: receiptDateController,
                      decoration: InputDecoration(
                        labelText: 'Return Date',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      enabled: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: vehicleNoController,
                      decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Vehicle No.',
                              style: TextStyle(fontSize: 12),
                            ),

                            SizedBox(width: 4),
                            // Add some space between the text and the icon
                            Icon(
                              Icons.star, // Use a star or any other icon
                              color: Colors.red, // Set the icon color to red
                              size: 10, // Adjust the size of the icon
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        // errorText: isValid ? null : 'Invalid Vehicle Number.',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11),
                        // Allow only digits
                      ],

                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Add New Item and Clear Item Buttons
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
              SizedBox(height: 16),

              // Dynamically added sections
              Expanded(
                child: ListView.builder(
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
                                ///working
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text('Select Item',
                                            style: TextStyle(fontSize: 12)),
                                        SizedBox(width: 4),
                                        Icon(Icons.star,
                                            color: Colors.red, size: 10),
                                      ],
                                    ),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                  ),
                                  // Filtering out selected items so they are not shown again in the dropdown
                                  items: _items
                                      .where((item) =>
                                  !_selectedItems.values
                                      .contains(item.itemName) ||
                                      _selectedItems[index] ==
                                          item.itemName)
                                      .toSet() // Removing duplicates if any
                                      .map((CylItemListModel item) {
                                    return DropdownMenuItem<String>(
                                      value: item.itemName,
                                      child: Text(item.itemName ?? 'Unknown'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      // Update the selected value for the current dropdown
                                      _selectedItems[index] = value ?? '';
                                    });
                                  },
                                  // value: _selectedItems[index]!.isEmpty
                                  //     ? null
                                  //     : _selectedItems[index],
                                  value: _selectedItems[index]?.isEmpty ?? true
                                      ? null // If the value is null or empty, set to null
                                      : _selectedItems[index],
                                ),
                              ),

                              SizedBox(
                                width: 20,
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  _removeItem(index);
                                },
                                child: Icon(Icons.remove, color: Colors.red),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(12),
                                  // backgroundColor: Colors.red,
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
                                  controller: items[index]['receivedQty'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                    // Allow only digits
                                  ],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'Empty',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                  ),
                                  onChanged: (value) {
                                    // Update the sum when the value changes
                                    _updateSum(index);
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: items[index]['emr'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                    // Allow only digits
                                  ],
                                  decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'R-EMR',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                  ),
                                  onChanged: (value) {
                                    // Update the sum when the value changes
                                    _updateSum(index);
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: items[index]['invoice'],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                    // Allow only digits
                                  ],
                                  decoration: InputDecoration(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'Total',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(width: 4),
                                          // Add some space between the text and the icon
                                          Icon(
                                            Icons.star,
                                            // Use a star or any other icon
                                            color: Colors.red,
                                            // Set the icon color to red
                                            size:
                                            10, // Adjust the size of the icon
                                          ),
                                        ],
                                      ),
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                      enabled: false),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Submit Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // Add 10px margin on left and right
                child: Center(
                  child: ElevatedButton(
                    onPressed:
                    // _submitData,

                        () {
                      if(saveFlag){
                        print('saveFlag $saveFlag');
                        showFlushBar(context,
                            Constants.dayEndCompleted);
                      }else{
                        if (vehicleNoController.text.isNotEmpty) {
                          setState(() {
                            _submitData();
                          });
                        } else {
                          print('Invalid vehicle number');
                        }
                      }

                    },
                    child:
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 12, bottom: 12),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors
                                .white), // Set text color directly if needed
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: saveFlag? Colors.grey:
                      (vehicleNoController.text.isNotEmpty ? Colors.blue : Colors.grey),
                      // : (vehicleNoController.text.isNotEmpty ? Colors.blue : Colors.grey),
                      // Button expands to fill available width// Text color of the button
                      shape: RoundedRectangleBorder(
                        // Optional: Set rounded corners
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewItem() {
    setState(() {
      int newIndex = items.length;
      items.add({
        'selectItem': TextEditingController(),
        'receivedQty': TextEditingController(),
        'emr': TextEditingController(),
        'invoice': TextEditingController(),

      });
      _selectedItems[newIndex] = '';
    });
  }
  // Fetch data from API
  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
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
        refreshTokens();
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  void _removeItem(int index) {
    setState(() {
      // Debugging: Print before removing
      print('Removing item at index: $index');
      print('Selected Items Before: $_selectedItems');

      // Dispose the TextEditingController instances associated with the index
      items[index]['receivedQty']?.dispose();
      items[index]['emr']?.dispose();
      items[index]['invoice']?.dispose();

      // Remove the item from the items list
      items.removeAt(index);

      // Remove the corresponding entry from the _selectedItems map and reassign keys
      _selectedItems.remove(index);
      _selectedItems = Map.fromEntries(
        _selectedItems.entries.map((entry) {
          return entry.key > index
              ? MapEntry(entry.key - 1,
              entry.value) // Shift keys down after the removed index
              : entry;
        }),
      );

      // Debugging: Print after removing
      print('Selected Items After: $_selectedItems');
    });
  }
  // Function to update the sum
  void _updateSum(int index) {
    // Get the values from the receivedQty and emr controllers
    double receivedQty =
        double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
    double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
    if (receivedQty != "" && receivedQty != null) {
      if (emr != "" && emr != null) {
        double totalSum = receivedQty + emr;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      } else {
        double totalSum = receivedQty + 0;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      }
    } else {
      if (emr != "" && emr != null) {
        double totalSum = 0 + emr;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      } else {
        showFlushBar(
            context, Constants.atLeastOneQtyRequired);
      }
    }
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
          'receivedQty':
          TextEditingController(text: item.emptyReturnQty?.toString() ?? ''),
          'emr': TextEditingController(text: item.emptyEMR?.toString() ?? ''),
          'invoice':
          TextEditingController(text: item.eXMIQty?.toString() ?? ''),
        });

        // Directly assign the selected item name for this index in _selectedItems map
        _selectedItems[items.length - 1] = item.itemName ??
            ''; // Ensure this is added correctly for each index
        // Store the previous invoice quantity as a double for validation
        _previousInvoiceQuantities[items.length - 1] = (item.eXMIQty ?? 0).toDouble();
      }

      // Debugging step to check the number of items
      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }

  // Future<void> _submitData() async {
  //   // Fetch shared preference values
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token');
  //
  //     if (vehicleNoController.text.isNotEmpty) {
  //       // if (isValid) {
  //       //   print('Valid vehicle number');
  //
  //       for (var i = 0; i < items.length; i++) {
  //         String? invoiceQty = items[i]['invoice']?.text ?? '';
  //         String? filledQty = items[i]['receivedQty']?.text ?? '';
  //         String? emrQty = items[i]['emr']?.text ?? '';
  //         String? selectedItemName = _selectedItems[i];
  //
  //         // Check if the selected item is valid (not empty)
  //         if (selectedItemName == null || selectedItemName.isEmpty) {
  //           showFlushBar(context, Constants.selectValidItemReceipt);
  //           return; // Stop the submission process
  //         }
  //
  //         // Check if InvoiceQty is empty or zero
  //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
  //           showFlushBar(context,Constants.atLeastOneQtyRequired);
  //           return; // Stop the submission process
  //         }
  //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
  //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
  //           showFlushBar(context, Constants.atLeastOneQtyRequired);
  //           return;
  //         }
  //       }
  //       String action;
  //       int? rId;
  //       if (modes == "Edit") {
  //         action = "EDIT";
  //         rId = receiptIds;
  //       } else {
  //         action = "ADD";
  //         rId = 0;
  //       }
  //       // Check for duplicate items in the list
  //       Set<int> itemIds = {};
  //       for (var i = 0; i < items.length; i++) {
  //         String? selectedItemName = _selectedItems[i];
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         // Check if the item ID is valid (not null or zero)
  //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
  //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
  //           if (itemIds.contains(itemId)) {
  //             showFlushBar(
  //                 context,Constants.recordExist);
  //             return; // Stop the submission process
  //           }
  //           itemIds.add(itemId);
  //         }
  //       }
  //
  //       List<Map<String, dynamic>> itemDetails = items.map((item) {
  //         String? selectedItemName = _selectedItems[items.indexOf(item)];
  //
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         return {
  //           'ItemId': selectedItem.itemId ?? '',
  //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
  //           'EXMIQty': item['invoice']?.text ?? '',
  //
  //         };
  //       }).toList();
  //
  //       // Build the full JSON object
  //       Map<String, dynamic> requestBody = {
  //         'ReturnId': rId,
  //         'DistributorId': distributorId,
  //         'GodownId': godownId,
  //         'ReturnDate': receiptDateController.text,
  //         'VehicleNo': vehicleNoController.text,
  //         'GodownKeeperId': godownKeeperId,
  //         'AddedBy': addedBy,
  //         'Action': action,
  //         'ItemList': itemDetails,
  //       };
  //
  //       String jsonRequestBody = jsonEncode(requestBody);
  //       debugPrint(jsonRequestBody);
  //
  //       try {
  //         final response = await http.post(
  //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //           body: jsonRequestBody,
  //         );
  //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
  //         if (response.statusCode == 200) {
  //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
  //           int responseValue = int.tryParse(response.body) ?? 0;
  //           if (responseValue > 0) {
  //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
  //                 duration: const Duration(milliseconds: 3000));
  //             Navigator.pushReplacementNamed(context, '/godownDashboard');
  //             setState(() {
  //               vehicleNoController.clear();
  //               items.forEach((item) {
  //                 item['receivedQty']?.clear();
  //                 item['emr']?.clear();
  //                 item['invoice']?.clear();
  //               });
  //               _selectedItems.clear();
  //             });
  //           } else if(responseValue == -1) {
  //             showFlushBar(
  //                 context,Constants.vehicleNotIn);
  //           }else if(responseValue == -2){
  //             showFlushBar(
  //                 context,Constants.itemreceiptDataNotInserted);
  //           }else{
  //             showFlushBar(
  //                 context,Constants.failToInserRecord);
  //           }
  //         } else {
  //           refreshTokens();
  //           showFlushBar(context, Constants.recordExist);
  //           throw Exception(
  //               Constants.listGettingFail);
  //         }
  //       } catch (e) {
  //         debugPrint('Error: $e');
  //         showFlushBar(context, Constants.recordExist);
  //       }
  //       // } else {
  //       //   showFlushBar(context, "Invalid Vehicle Number",
  //       //       'Please Enter a Valid Vehicle Number!');
  //       // }
  //     } else {
  //       showFlushBar(context, Constants.vehicleValidation);
  //     }
  //   } else {
  //     showFlushBar(
  //         context, Constants.connectionMessage);
  //   }
  // }

  // Future<void> _submitData() async {
  //   // Fetch shared preference values
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token');
  //
  //     if (vehicleNoController.text.isNotEmpty) {
  //       for (var i = 0; i < items.length; i++) {
  //         String? invoiceQty = items[i]['invoice']?.text ?? '';
  //         String? filledQty = items[i]['receivedQty']?.text ?? '';
  //         String? emrQty = items[i]['emr']?.text ?? '';
  //         String? selectedItemName = _selectedItems[i];
  //
  //         // Check if the selected item is valid (not empty)
  //         if (selectedItemName == null || selectedItemName.isEmpty) {
  //           showFlushBar(context, Constants.selectValidItemReceipt);
  //           return; // Stop the submission process
  //         }
  //
  //         // Check if InvoiceQty is empty or zero
  //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
  //           showFlushBar(context, Constants.atLeastOneQtyRequired);
  //           return; // Stop the submission process
  //         }
  //
  //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
  //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
  //           showFlushBar(context, Constants.atLeastOneQtyRequired);
  //           return;
  //         }
  //
  //         // Fetch itemId for the selected item
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         // Fetch current stock for the itemId
  //         final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
  //               (stockItem) => stockItem.itemId == selectedItem.itemId,
  //           orElse: () => GetCurrentStcOfGodownKeeperModel(
  //             itemId: -1, // Invalid ID to indicate no match found
  //             itemName: '', // Default value for itemName
  //             currentStkFilled: 0, // Default value for current stock
  //             currentStkEmpty: 0,
  //             currentStkDefective: 0,
  //           ),
  //         );
  //
  //         // If the current stock is not found (itemId is invalid), show an error
  //         if (currentStock.itemId == -1) {
  //           showFlushBar(context, Constants.selectValidItemReceipt);
  //           return; // Stop the submission process
  //         }
  //
  //         // Compare the invoiceQty with the current stock available
  //         double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
  //         if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
  //           showFlushBar(
  //               context, 'Invoice qty for item "${selectedItem.itemName}" exceeds current stock');
  //
  //           return; // Stop the submission process if invoiceQty is greater than current stock
  //         }
  //       }
  //
  //       String action;
  //       int? rId;
  //       if (modes == "Edit") {
  //         action = "EDIT";
  //         rId = receiptIds;
  //       } else {
  //         action = "ADD";
  //         rId = 0;
  //       }
  //
  //       // Check for duplicate items in the list
  //       Set<int> itemIds = {};
  //       for (var i = 0; i < items.length; i++) {
  //         String? selectedItemName = _selectedItems[i];
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         // Check if the item ID is valid (not null or zero)
  //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
  //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
  //           if (itemIds.contains(itemId)) {
  //             showFlushBar(context, Constants.recordExist);
  //             return; // Stop the submission process
  //           }
  //           itemIds.add(itemId);
  //         }
  //       }
  //
  //       List<Map<String, dynamic>> itemDetails = items.map((item) {
  //         String? selectedItemName = _selectedItems[items.indexOf(item)];
  //
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         return {
  //           'ItemId': selectedItem.itemId ?? '',
  //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
  //           'EXMIQty': item['invoice']?.text ?? '',
  //         };
  //       }).toList();
  //
  //       // Build the full JSON object
  //       Map<String, dynamic> requestBody = {
  //         'ReturnId': rId,
  //         'DistributorId': distributorId,
  //         'GodownId': godownId,
  //         'ReturnDate': receiptDateController.text,
  //         'VehicleNo': vehicleNoController.text,
  //         'GodownKeeperId': godownKeeperId,
  //         'AddedBy': addedBy,
  //         'Action': action,
  //         'ItemList': itemDetails,
  //       };
  //
  //       String jsonRequestBody = jsonEncode(requestBody);
  //       debugPrint(jsonRequestBody);
  //
  //       try {
  //         final response = await http.post(
  //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //           body: jsonRequestBody,
  //         );
  //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
  //         if (response.statusCode == 200) {
  //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
  //           int responseValue = int.tryParse(response.body) ?? 0;
  //           if (responseValue > 0) {
  //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
  //                 duration: const Duration(milliseconds: 3000));
  //             Navigator.pushReplacementNamed(context, '/godownDashboard');
  //             setState(() {
  //               vehicleNoController.clear();
  //               items.forEach((item) {
  //                 item['receivedQty']?.clear();
  //                 item['emr']?.clear();
  //                 item['invoice']?.clear();
  //               });
  //               _selectedItems.clear();
  //             });
  //           } else if (responseValue == -1) {
  //             showFlushBar(context, Constants.vehicleNotIn);
  //           } else if (responseValue == -2) {
  //             showFlushBar(context, Constants.itemreceiptDataNotInserted);
  //           } else {
  //             showFlushBar(context, Constants.failToInserRecord);
  //           }
  //         } else {
  //           refreshTokens();
  //           showFlushBar(context, Constants.failToInserRecord);
  //           throw Exception(Constants.listGettingFail);
  //         }
  //       } catch (e) {
  //         debugPrint('Error: $e');
  //         showFlushBar(context, Constants.failToInserRecord);
  //       }
  //     } else {
  //       showFlushBar(context, Constants.vehicleValidation);
  //     }
  //   } else {
  //     showFlushBar(context, Constants.connectionMessage);
  //   }
  // }

  Future<void> _submitData() async {
    // Fetch shared preference values
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      if (vehicleNoController.text.isNotEmpty) {
        List<String> itemsExceedingLimit = []; // List to track items exceeding stock limit

        for (var i = 0; i < items.length; i++) {
          String? invoiceQty = items[i]['invoice']?.text ?? '';
          String? filledQty = items[i]['receivedQty']?.text ?? '';
          String? emrQty = items[i]['emr']?.text ?? '';
          String? selectedItemName = _selectedItems[i];
          double previousInvoiceQuantity = _previousInvoiceQuantities[i] ?? 0;


          // Check if the selected item is valid (not empty)
          if (selectedItemName == null || selectedItemName.isEmpty) {
            showFlushBar(context, Constants.selectValidItemReceipt);
            return; // Stop the submission process
          }

          // Check if InvoiceQty is empty or zero
          if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return; // Stop the submission process
          }

          if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
              (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return;
          }

          // Fetch itemId for the selected item
          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );

          // Fetch current stock for the itemId
          final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
                (stockItem) => stockItem.itemId == selectedItem.itemId,
            orElse: () => GetCurrentStcOfGodownKeeperModel(
              itemId: -1, // Invalid ID to indicate no match found
              itemName: '', // Default value for itemName
              currentStkFilled: 0, // Default value for current stock
              currentStkEmpty: 0,
              currentStkDefective: 0,
            ),
          );

          // If the current stock is not found (itemId is invalid), show an error
          if (currentStock.itemId == -1) {
            showFlushBar(context, Constants.selectValidItemReceipt);
            return; // Stop the submission process
          }

          // Calculate the stock available for the item in edit mode
          num availableStock = currentStock.currentStkEmpty ?? 0;
          // Compare the invoiceQty with the current stock available
          double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
// If in edit mode, add the previous invoice quantity (already invoiced quantity)
          if (modes == "Edit") {
            if (invoiceQuantity > ((currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity)) {
              // Add the item to the list of items exceeding the stock limit
              itemsExceedingLimit.add(selectedItem.itemName!);
              debugPrint("edit ${(currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity }");
              debugPrint("edit s${previousInvoiceQuantity }");
            }
          }else{
            if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
              // Add the item to the list of items exceeding the stock limit
              itemsExceedingLimit.add(selectedItem.itemName!);
              debugPrint("editcheck ${(currentStock.currentStkEmpty ?? 0)}");
            }
          }
        }

        // If any items exceed the stock limit, show a combined error message
        if (itemsExceedingLimit.isNotEmpty) {
          String itemsList = itemsExceedingLimit.join(', ');
          // showFlushBar(
          //   context,
          //   'Invoice qty for the following items exceeds current stock: $itemsList',
          //
          // );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(""),
                content: Text(
                  "${Constants.gretaerItemQty}\n\n" +
                      itemsList,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );

          return; // Stop the submission process
        }

        // If no item exceeded the stock limit, proceed with the submission
        String action;
        int? rId;
        if (modes == "Edit") {
          action = "EDIT";
          rId = receiptIds;
        } else {
          action = "ADD";
          rId = 0;
        }

        // Check for duplicate items in the list
        Set<int> itemIds = {};
        for (var i = 0; i < items.length; i++) {
          String? selectedItemName = _selectedItems[i];
          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );

          // Check if the item ID is valid (not null or zero)
          if (selectedItem.itemId != null && selectedItem.itemId != 0) {
            int itemId = selectedItem.itemId!.toInt(); // Convert num to int
            if (itemIds.contains(itemId)) {
              showFlushBar(context, Constants.recordExist);
              return; // Stop the submission process
            }
            itemIds.add(itemId);
          }
        }

        List<Map<String, dynamic>> itemDetails = items.map((item) {
          String? selectedItemName = _selectedItems[items.indexOf(item)];

          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );

          return {
            'ItemId': selectedItem.itemId ?? '',
            'EmptyReturnQty': item['receivedQty']?.text ?? '',
            'EmptyEMR': item['emr']?.text ?? '',
            'EXMIQty': item['invoice']?.text ?? '',
          };
        }).toList();

        // Build the full JSON object
        Map<String, dynamic> requestBody = {
          'ReturnId': rId,
          'DistributorId': distributorId,
          'GodownId': godownId,
          'ReturnDate': receiptDateController.text,
          'VehicleNo': vehicleNoController.text,
          'GodownKeeperId': godownKeeperId,
          'AddedBy': addedBy,
          'Action': action,
          'ItemDetails': itemDetails,
        };

        String jsonRequestBody = jsonEncode(requestBody);
        debugPrint(jsonRequestBody);

        try {
          final response = await http.post(
            Uri.parse(AppUrl.ItemRetEXMIAddEdit),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonRequestBody,
          );
          debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
          if (response.statusCode == 200) {
            debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
            int responseValue = int.tryParse(response.body) ?? 0;
            if (responseValue > 0) {
              EasyLoading.showToast(Constants.itemAddedSuccessfully,
                  duration: const Duration(milliseconds: 3000));
              // Navigator.pushReplacementNamed(context, '/godownDashboard');
              Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);

              setState(() {
                vehicleNoController.clear();
                items.forEach((item) {
                  item['receivedQty']?.clear();
                  item['emr']?.clear();
                  item['invoice']?.clear();
                });
                _selectedItems.clear();
              });
            } else if (responseValue == -1) {
              showFlushBar(context, Constants.vehicleNotIn);
            } else if (responseValue == -2) {
              showFlushBar(context, Constants.itemreceiptDataNotInserted);
            } else {
              showFlushBar(context, Constants.failToInserRecord);
            }
          } else {
            refreshTokens();
            showFlushBar(context, Constants.recordExist);
            throw Exception(Constants.listGettingFail);
          }
        } catch (e) {
          debugPrint('Error: $e');
          showFlushBar(context, Constants.recordExist);
        }
      } else {
        showFlushBar(context, Constants.vehicleValidation);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchCurrentStock() async {
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
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
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
        showFlushBar(context,  Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
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
        refreshTokens();
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      refreshTokens();
      // Exception handling
      print("Exception: $e");
    }
  }

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();

      final Future<Map<String, dynamic>> respose =
      auth.refreshToken(mobileNo!, context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchItems();
          } else if (response['message'] == "UnSuccessful") {
            debugPrint('RefreshTokenExc401 - true');
            // checkAndSaveDayEndData();
            showDialogToExpireSession(context);
          } else {
            debugPrint('RefreshTokenStatus - false');
          }
        }).catchError((error) {
          EasyLoading.dismiss();
          debugPrint('RefreshTokenError1: $error');
        });
      } on HttpException catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenHttpExc: $error');
      } catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenError2: $error');
      }
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint('RefreshTokenError3: $error');
    }
  }

  showDialogToExpireSession(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Expired";
        String message = "Your Session Is Expire. Click Ok To Login Again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: Styling.bodyTitle,
            ),
            content: Text(
              message,
              style: Styling.bodyTitle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: Styling.blueClrText,
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
            : WillPopScope(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel),
                onPressed: () => logoutUser(context),
              ),
            ],
          ),
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
        );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {
      SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

      EasyLoading.dismiss();

      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);

      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

}
