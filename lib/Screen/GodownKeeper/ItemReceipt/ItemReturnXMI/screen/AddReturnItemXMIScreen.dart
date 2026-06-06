// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../ConstantScreen/widgets.dart';
// import '../../../../User/Login/provider/LoginProvider.dart';
// import '../../../../User/splashscreen/page/splash_screen.dart';
// import '../../../../Utils/CustomAppBar.dart';
// import '../../../../Utils/Styling.dart';
// import '../../../../Utils/app_url.dart';
// import '../../../../Utils/constants.dart';
// import '../../../../Utils/shared_preference.dart';
// import '../../../BottomNavigationForGodownKeeper.dart';
// import '../../CylItemList/CylItemListModel.dart';
// import 'package:http/http.dart' as http;
// import '../model/GetEXMIListModel.dart';
// import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// class AddReturnItemXMIScreen extends StatefulWidget {
//   static const screenName = '/addReturnItemXMIScreen';
//   const AddReturnItemXMIScreen({super.key});
//
//   @override
//   State<AddReturnItemXMIScreen> createState() => _AddReturnItemXMIScreenState();
// }
//
// class _AddReturnItemXMIScreenState extends State<AddReturnItemXMIScreen> {
//   final TextEditingController receiptDateController = TextEditingController();
//   final TextEditingController vehicleNoController = TextEditingController();
//   List<CylItemListModel> _items = [];
//   Map<int, String?> _selectedItems = {};
//   String? mobileNo;
//   List<Map<String, TextEditingController>> items = [];
//   bool saveFlag = false;
//   var argValue;
//   List<ItemDetails> itemsToShow = [];
//   String? modes;
//   int? receiptIds;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   Map<int, double> _previousInvoiceQuantities = {};
//   // Function to check if items are available for selection
//   bool get _isAddNewItemEnabled {
//     // Check if there are any available items that haven't been selected yet
//     return _items.any((item) => !_selectedItems.values.contains(item.itemName));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Add the first item by default
//     // Get today's date
//
//     DateTime now = DateTime.now();
//
//     // Format it as 'yyyy-MM-dd', or any format you prefer
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//     // Set the formatted date as the default value in the TextField
//     receiptDateController.text = formattedDate;
//     _addNewItem();
//     fetchItems();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     vehicleNoController.addListener(_updateButtonState);
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         argValue = ModalRoute.of(context)?.settings.arguments as Map;
//         vehicleNoController.text = argValue?["vehicleNo"] ?? '';
//         modes = argValue?["modeChange"]?? '';
//         receiptIds = argValue["receiptID"]?? 0;
//         if (argValue != null) {
//           final itemsToShow = argValue["itemsToShow"] ?? [];
//           // _initializeItems(itemsToShow);
//           if (itemsToShow.isNotEmpty) {
//             _initializeItems(itemsToShow);
//           } else {
//             // If no initial data, start with an empty list or default values
//             _initializeItems([]);
//           }
//         }
//       });
//     });
//   }
//
//   void _updateButtonState() {
//     setState(() {});  // Trigger a rebuild when text changes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName,
//               arguments: "onBack");
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } // In case `null` is returned, return `false`
//       },
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Return EXMI/Rev-EMR', // Title or hint text for the text field
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Receipt Date & Vehicle Number
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: receiptDateController,
//                       decoration: InputDecoration(
//                         labelText: 'Return Date',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.datetime,
//                       enabled: false,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: TextField(
//                       controller: vehicleNoController,
//                       decoration: InputDecoration(
//                         label: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Text(
//                               'Vehicle No.',
//                               style: TextStyle(fontSize: 12),
//                             ),
//
//                             SizedBox(width: 4),
//
//                             Icon(
//                               Icons.star, // Use a star or any other icon
//                               color: Colors.red, // Set the icon color to red
//                               size: 10, // Adjust the size of the icon
//                             ),
//                           ],
//                         ),
//                         border: const OutlineInputBorder(),
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 12.0),
//                       ),
//                       textCapitalization: TextCapitalization.words,
//                       inputFormatters: <TextInputFormatter>[
//                         LengthLimitingTextInputFormatter(11),
//                         // Allow only digits
//                       ],
//
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Add New Item',
//                     style: TextStyle(fontSize: 16),
//                   ),
//
//                   ElevatedButton(
//                     onPressed: _isAddNewItemEnabled ? _addNewItem : null,
//                     // onPressed: _addNewItem,
//                     child: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         shape: CircleBorder(),
//                         padding: EdgeInsets.all(12),
//                         backgroundColor: Colors.blue),
//                   ),
//                   SizedBox(width: 8),
//
//                 ],
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 16.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child:
//                                 DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text('Select Item',
//                                             style: TextStyle(fontSize: 12)),
//                                         SizedBox(width: 4),
//                                         Icon(Icons.star,
//                                             color: Colors.red, size: 10),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   // Filtering out selected items so they are not shown again in the dropdown
//                                   items: _items
//                                       .where((item) =>
//                                   !_selectedItems.values
//                                       .contains(item.itemName) ||
//                                       _selectedItems[index] ==
//                                           item.itemName)
//                                       .toSet() // Removing duplicates if any
//                                       .map((CylItemListModel item) {
//                                     return DropdownMenuItem<String>(
//                                       value: item.itemName,
//                                       child: Text(item.itemName ?? 'Unknown'),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       // Update the selected value for the current dropdown
//                                       _selectedItems[index] = value ?? '';
//                                     });
//                                   },
//                                   // value: _selectedItems[index]!.isEmpty
//                                   //     ? null
//                                   //     : _selectedItems[index],
//                                   value: _selectedItems[index]?.isEmpty ?? true
//                                       ? null // If the value is null or empty, set to null
//                                       : _selectedItems[index],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   _removeItem(index);
//                                 },
//                                 child: Icon(Icons.remove, color: Colors.red),
//                                 style: ElevatedButton.styleFrom(
//                                   shape: CircleBorder(),
//                                   padding: EdgeInsets.all(12),
//                                   // backgroundColor: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           // Received Qty, EMR, Invoice Fields
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['receivedQty'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text(
//                                           'Empty',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   onChanged: (value) {
//                                     // Update the sum when the value changes
//                                     _updateSum(index);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['emr'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text(
//                                           'R-EMR',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   onChanged: (value) {
//                                     // Update the sum when the value changes
//                                     _updateSum(index);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['invoice'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: const [
//                                           Text(
//                                             'Total',
//                                             style: TextStyle(fontSize: 12),
//                                           ),
//                                           SizedBox(width: 4),
//
//                                           Icon(
//                                             Icons.star,
//                                             color: Colors.red,
//                                             size:
//                                             10,
//                                           ),
//                                         ],
//                                       ),
//                                       border: const OutlineInputBorder(),
//                                       contentPadding:
//                                       const EdgeInsets.symmetric(
//                                           vertical: 8.0, horizontal: 12.0),
//                                       enabled: false),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               // Submit Button
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed:
//                         () {
//                       if(saveFlag){
//                         print('saveFlag $saveFlag');
//                         showFlushBar(context,
//                             Constants.dayEndCompleted);
//                       }else{
//                         if (vehicleNoController.text.isNotEmpty) {
//                           setState(() {
//                             _submitData();
//                           });
//                         } else {
//                           print('Invalid vehicle number');
//                         }
//                       }
//
//                     },
//                     child:
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 20.0, right: 20, top: 12, bottom: 12),
//                       child: const Text(
//                         'Submit',
//                         style: TextStyle(
//                             color: Colors
//                                 .white), // Set text color directly if needed
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: saveFlag? Colors.grey:
//                       (vehicleNoController.text.isNotEmpty ? Colors.blue : Colors.grey),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _addNewItem() {
//     setState(() {
//       int newIndex = items.length;
//       items.add({
//         'selectItem': TextEditingController(),
//         'receivedQty': TextEditingController(),
//         'emr': TextEditingController(),
//         'invoice': TextEditingController(),
//
//       });
//       _selectedItems[newIndex] = '';
//     });
//   }
//   // Fetch data from API
//   Future<void> fetchItems() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token Is Missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//       debugPrint("item" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//         });
//       } else {
//         refreshTokens();
//         throw Exception('Unable To Load Data At This Time. Please Try Again');
//       }
//     } else {
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }
//
//   void _removeItem(int index) {
//     setState(() {
//       // Debugging: Print before removing
//       print('Removing item at index: $index');
//       print('Selected Items Before: $_selectedItems');
//       items[index]['receivedQty']?.dispose();
//       items[index]['emr']?.dispose();
//       items[index]['invoice']?.dispose();
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
//
//       print('Selected Items After: $_selectedItems');
//     });
//   }
//   // Function to update the sum
//   void _updateSum(int index) {
//     // Get the values from the receivedQty and emr controllers
//     double receivedQty =
//         double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
//     double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
//     if (receivedQty != "" && receivedQty != null) {
//       if (emr != "" && emr != null) {
//         double totalSum = receivedQty + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         double totalSum = receivedQty + 0;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       }
//     } else {
//       if (emr != "" && emr != null) {
//         double totalSum = 0 + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         showFlushBar(
//             context, Constants.atLeastOneQtyRequired);
//       }
//     }
//   }
//
//   void _initializeItems(List<ItemDetails> itemsToShow) {
//     setState(() {
//       items.clear(); // Clear any existing data
//       _selectedItems.clear(); // Clear previous selections if any
//
//       for (var i = 0; i < itemsToShow.length; i++) {
//         var item = itemsToShow[i];
//         items.add({
//           'selectItem': TextEditingController(text: item.itemName ?? ''),
//           'receivedQty':
//           TextEditingController(text: item.emptyReturnQty?.toString() ?? ''),
//           'emr': TextEditingController(text: item.emptyEMR?.toString() ?? ''),
//           'invoice':
//           TextEditingController(text: item.eXMIQty?.toString() ?? ''),
//         });
//
//         _selectedItems[items.length - 1] = item.itemName ??
//             ''; // Ensure this is added correctly for each index
//         _previousInvoiceQuantities[items.length - 1] = (item.eXMIQty ?? 0).toDouble();
//       }
//
//       // Debugging step to check the number of items
//       print('Items Count: ${items.length}');
//       print('Selected Items: $_selectedItems');
//     });
//   }
//
//   // Future<void> _submitData() async {
//   //   // Fetch shared preference values
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (Constants.isNetworkAvailable) {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? godownId = prefs.getString('godownId');
//   //     String? addedBy = prefs.getString('StaffId');
//   //     String? godownKeeperId = prefs.getString('godownKeeperId');
//   //     String? token = prefs.getString('token');
//   //
//   //     if (vehicleNoController.text.isNotEmpty) {
//   //       // if (isValid) {
//   //       //   print('Valid vehicle number');
//   //
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? invoiceQty = items[i]['invoice']?.text ?? '';
//   //         String? filledQty = items[i]['receivedQty']?.text ?? '';
//   //         String? emrQty = items[i]['emr']?.text ?? '';
//   //         String? selectedItemName = _selectedItems[i];
//   //
//   //         // Check if the selected item is valid (not empty)
//   //         if (selectedItemName == null || selectedItemName.isEmpty) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Check if InvoiceQty is empty or zero
//   //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//   //           showFlushBar(context,Constants.atLeastOneQtyRequired);
//   //           return; // Stop the submission process
//   //         }
//   //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//   //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return;
//   //         }
//   //       }
//   //       String action;
//   //       int? rId;
//   //       if (modes == "Edit") {
//   //         action = "EDIT";
//   //         rId = receiptIds;
//   //       } else {
//   //         action = "ADD";
//   //         rId = 0;
//   //       }
//   //       // Check for duplicate items in the list
//   //       Set<int> itemIds = {};
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? selectedItemName = _selectedItems[i];
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Check if the item ID is valid (not null or zero)
//   //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//   //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//   //           if (itemIds.contains(itemId)) {
//   //             showFlushBar(
//   //                 context,Constants.recordExist);
//   //             return; // Stop the submission process
//   //           }
//   //           itemIds.add(itemId);
//   //         }
//   //       }
//   //
//   //       List<Map<String, dynamic>> itemDetails = items.map((item) {
//   //         String? selectedItemName = _selectedItems[items.indexOf(item)];
//   //
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         return {
//   //           'ItemId': selectedItem.itemId ?? '',
//   //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
//   //           'EXMIQty': item['invoice']?.text ?? '',
//   //
//   //         };
//   //       }).toList();
//   //
//   //       // Build the full JSON object
//   //       Map<String, dynamic> requestBody = {
//   //         'ReturnId': rId,
//   //         'DistributorId': distributorId,
//   //         'GodownId': godownId,
//   //         'ReturnDate': receiptDateController.text,
//   //         'VehicleNo': vehicleNoController.text,
//   //         'GodownKeeperId': godownKeeperId,
//   //         'AddedBy': addedBy,
//   //         'Action': action,
//   //         'ItemList': itemDetails,
//   //       };
//   //
//   //       String jsonRequestBody = jsonEncode(requestBody);
//   //       debugPrint(jsonRequestBody);
//   //
//   //       try {
//   //         final response = await http.post(
//   //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//   //           headers: {
//   //             'Content-Type': 'application/json',
//   //             'Authorization': 'Bearer $token',
//   //           },
//   //           body: jsonRequestBody,
//   //         );
//   //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//   //         if (response.statusCode == 200) {
//   //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//   //           int responseValue = int.tryParse(response.body) ?? 0;
//   //           if (responseValue > 0) {
//   //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
//   //                 duration: const Duration(milliseconds: 3000));
//   //             Navigator.pushReplacementNamed(context, '/godownDashboard');
//   //             setState(() {
//   //               vehicleNoController.clear();
//   //               items.forEach((item) {
//   //                 item['receivedQty']?.clear();
//   //                 item['emr']?.clear();
//   //                 item['invoice']?.clear();
//   //               });
//   //               _selectedItems.clear();
//   //             });
//   //           } else if(responseValue == -1) {
//   //             showFlushBar(
//   //                 context,Constants.vehicleNotIn);
//   //           }else if(responseValue == -2){
//   //             showFlushBar(
//   //                 context,Constants.itemreceiptDataNotInserted);
//   //           }else{
//   //             showFlushBar(
//   //                 context,Constants.failToInserRecord);
//   //           }
//   //         } else {
//   //           refreshTokens();
//   //           showFlushBar(context, Constants.recordExist);
//   //           throw Exception(
//   //               Constants.listGettingFail);
//   //         }
//   //       } catch (e) {
//   //         debugPrint('Error: $e');
//   //         showFlushBar(context, Constants.recordExist);
//   //       }
//   //       // } else {
//   //       //   showFlushBar(context, "Invalid Vehicle Number",
//   //       //       'Please Enter a Valid Vehicle Number!');
//   //       // }
//   //     } else {
//   //       showFlushBar(context, Constants.vehicleValidation);
//   //     }
//   //   } else {
//   //     showFlushBar(
//   //         context, Constants.connectionMessage);
//   //   }
//   // }
//
//   // Future<void> _submitData() async {
//   //   // Fetch shared preference values
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (Constants.isNetworkAvailable) {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? godownId = prefs.getString('godownId');
//   //     String? addedBy = prefs.getString('StaffId');
//   //     String? godownKeeperId = prefs.getString('godownKeeperId');
//   //     String? token = prefs.getString('token');
//   //
//   //     if (vehicleNoController.text.isNotEmpty) {
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? invoiceQty = items[i]['invoice']?.text ?? '';
//   //         String? filledQty = items[i]['receivedQty']?.text ?? '';
//   //         String? emrQty = items[i]['emr']?.text ?? '';
//   //         String? selectedItemName = _selectedItems[i];
//   //
//   //         // Check if the selected item is valid (not empty)
//   //         if (selectedItemName == null || selectedItemName.isEmpty) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Check if InvoiceQty is empty or zero
//   //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//   //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return;
//   //         }
//   //
//   //         // Fetch itemId for the selected item
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Fetch current stock for the itemId
//   //         final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//   //               (stockItem) => stockItem.itemId == selectedItem.itemId,
//   //           orElse: () => GetCurrentStcOfGodownKeeperModel(
//   //             itemId: -1, // Invalid ID to indicate no match found
//   //             itemName: '', // Default value for itemName
//   //             currentStkFilled: 0, // Default value for current stock
//   //             currentStkEmpty: 0,
//   //             currentStkDefective: 0,
//   //           ),
//   //         );
//   //
//   //         // If the current stock is not found (itemId is invalid), show an error
//   //         if (currentStock.itemId == -1) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Compare the invoiceQty with the current stock available
//   //         double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
//   //         if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
//   //           showFlushBar(
//   //               context, 'Invoice qty for item "${selectedItem.itemName}" exceeds current stock');
//   //
//   //           return; // Stop the submission process if invoiceQty is greater than current stock
//   //         }
//   //       }
//   //
//   //       String action;
//   //       int? rId;
//   //       if (modes == "Edit") {
//   //         action = "EDIT";
//   //         rId = receiptIds;
//   //       } else {
//   //         action = "ADD";
//   //         rId = 0;
//   //       }
//   //
//   //       // Check for duplicate items in the list
//   //       Set<int> itemIds = {};
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? selectedItemName = _selectedItems[i];
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Check if the item ID is valid (not null or zero)
//   //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//   //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//   //           if (itemIds.contains(itemId)) {
//   //             showFlushBar(context, Constants.recordExist);
//   //             return; // Stop the submission process
//   //           }
//   //           itemIds.add(itemId);
//   //         }
//   //       }
//   //
//   //       List<Map<String, dynamic>> itemDetails = items.map((item) {
//   //         String? selectedItemName = _selectedItems[items.indexOf(item)];
//   //
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         return {
//   //           'ItemId': selectedItem.itemId ?? '',
//   //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
//   //           'EXMIQty': item['invoice']?.text ?? '',
//   //         };
//   //       }).toList();
//   //
//   //       // Build the full JSON object
//   //       Map<String, dynamic> requestBody = {
//   //         'ReturnId': rId,
//   //         'DistributorId': distributorId,
//   //         'GodownId': godownId,
//   //         'ReturnDate': receiptDateController.text,
//   //         'VehicleNo': vehicleNoController.text,
//   //         'GodownKeeperId': godownKeeperId,
//   //         'AddedBy': addedBy,
//   //         'Action': action,
//   //         'ItemList': itemDetails,
//   //       };
//   //
//   //       String jsonRequestBody = jsonEncode(requestBody);
//   //       debugPrint(jsonRequestBody);
//   //
//   //       try {
//   //         final response = await http.post(
//   //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//   //           headers: {
//   //             'Content-Type': 'application/json',
//   //             'Authorization': 'Bearer $token',
//   //           },
//   //           body: jsonRequestBody,
//   //         );
//   //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//   //         if (response.statusCode == 200) {
//   //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//   //           int responseValue = int.tryParse(response.body) ?? 0;
//   //           if (responseValue > 0) {
//   //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
//   //                 duration: const Duration(milliseconds: 3000));
//   //             Navigator.pushReplacementNamed(context, '/godownDashboard');
//   //             setState(() {
//   //               vehicleNoController.clear();
//   //               items.forEach((item) {
//   //                 item['receivedQty']?.clear();
//   //                 item['emr']?.clear();
//   //                 item['invoice']?.clear();
//   //               });
//   //               _selectedItems.clear();
//   //             });
//   //           } else if (responseValue == -1) {
//   //             showFlushBar(context, Constants.vehicleNotIn);
//   //           } else if (responseValue == -2) {
//   //             showFlushBar(context, Constants.itemreceiptDataNotInserted);
//   //           } else {
//   //             showFlushBar(context, Constants.failToInserRecord);
//   //           }
//   //         } else {
//   //           refreshTokens();
//   //           showFlushBar(context, Constants.failToInserRecord);
//   //           throw Exception(Constants.listGettingFail);
//   //         }
//   //       } catch (e) {
//   //         debugPrint('Error: $e');
//   //         showFlushBar(context, Constants.failToInserRecord);
//   //       }
//   //     } else {
//   //       showFlushBar(context, Constants.vehicleValidation);
//   //     }
//   //   } else {
//   //     showFlushBar(context, Constants.connectionMessage);
//   //   }
//   // }
//
//   Future<void> _submitData() async {
//     // Fetch shared preference values
//     Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       if (vehicleNoController.text.isNotEmpty) {
//         List<String> itemsExceedingLimit = []; // List to track items exceeding stock limit
//
//         for (var i = 0; i < items.length; i++) {
//           String? invoiceQty = items[i]['invoice']?.text ?? '';
//           String? filledQty = items[i]['receivedQty']?.text ?? '';
//           String? emrQty = items[i]['emr']?.text ?? '';
//           String? selectedItemName = _selectedItems[i];
//           double previousInvoiceQuantity = _previousInvoiceQuantities[i] ?? 0;
//
//
//           // Check if the selected item is valid (not empty)
//           if (selectedItemName == null || selectedItemName.isEmpty) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return; // Stop the submission process
//           }
//
//           // Check if InvoiceQty is empty or zero
//           if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return; // Stop the submission process
//           }
//
//           if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//               (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return;
//           }
//
//           // Fetch itemId for the selected item
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           // Fetch current stock for the itemId
//           final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//                 (stockItem) => stockItem.itemId == selectedItem.itemId,
//             orElse: () => GetCurrentStcOfGodownKeeperModel(
//               itemId: -1, // Invalid ID to indicate no match found
//               itemName: '', // Default value for itemName
//               currentStkFilled: 0, // Default value for current stock
//               currentStkEmpty: 0,
//               currentStkDefective: 0,
//             ),
//           );
//
//           // If the current stock is not found (itemId is invalid), show an error
//           if (currentStock.itemId == -1) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return; // Stop the submission process
//           }
//
//           num availableStock = currentStock.currentStkEmpty ?? 0;
//           double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
//           if (modes == "Edit") {
//             if (invoiceQuantity > ((currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity)) {
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint("edit ${(currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity }");
//               debugPrint("edit s${previousInvoiceQuantity }");
//             }
//           }else{
//             if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
//               // Add the item to the list of items exceeding the stock limit
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint("editcheck ${(currentStock.currentStkEmpty ?? 0)}");
//             }
//           }
//         }
//
//         if (itemsExceedingLimit.isNotEmpty) {
//           String itemsList = itemsExceedingLimit.join(', ');
//           // showFlushBar(
//           //   context,
//           //   'Invoice qty for the following items exceeds current stock: $itemsList',
//           //
//           // );
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text(""),
//                 content: Text(
//                   "${Constants.gretaerItemQty}\n\n" +
//                       itemsList,
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog
//                     },
//                     child: Text("OK"),
//                   ),
//                 ],
//               );
//             },
//           );
//
//           return; // Stop the submission process
//         }
//         String action;
//         int? rId;
//         if (modes == "Edit") {
//           action = "EDIT";
//           rId = receiptIds;
//         } else {
//           action = "ADD";
//           rId = 0;
//         }
//
//         // Check for duplicate items in the list
//         Set<int> itemIds = {};
//         for (var i = 0; i < items.length; i++) {
//           String? selectedItemName = _selectedItems[i];
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           // Check if the item ID is valid (not null or zero)
//           if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//             int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//             if (itemIds.contains(itemId)) {
//               showFlushBar(context, Constants.recordExist);
//               return; // Stop the submission process
//             }
//             itemIds.add(itemId);
//           }
//         }
//
//         List<Map<String, dynamic>> itemDetails = items.map((item) {
//           String? selectedItemName = _selectedItems[items.indexOf(item)];
//
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           return {
//             'ItemId': selectedItem.itemId ?? '',
//             'EmptyReturnQty': item['receivedQty']?.text ?? '',
//             'EmptyEMR': item['emr']?.text ?? '',
//             'EXMIQty': item['invoice']?.text ?? '',
//           };
//         }).toList();
//
//         // Build the full JSON object
//         Map<String, dynamic> requestBody = {
//           'ReturnId': rId,
//           'DistributorId': distributorId,
//           'GodownId': godownId,
//           'ReturnDate': receiptDateController.text,
//           'VehicleNo': vehicleNoController.text,
//           'GodownKeeperId': godownKeeperId,
//           'AddedBy': addedBy,
//           'Action': action,
//           'ItemDetails': itemDetails,
//         };
//
//         String jsonRequestBody = jsonEncode(requestBody);
//         debugPrint(jsonRequestBody);
//
//         try {
//           final response = await http.post(
//             Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonRequestBody,
//           );
//           debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//           if (response.statusCode == 200) {
//             debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//             int responseValue = int.tryParse(response.body) ?? 0;
//             if (responseValue > 0) {
//               EasyLoading.showToast(Constants.itemAddedSuccessfully,
//                   duration: const Duration(milliseconds: 3000));
//               // Navigator.pushReplacementNamed(context, '/godownDashboard');
//               Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
//
//               setState(() {
//                 vehicleNoController.clear();
//                 items.forEach((item) {
//                   item['receivedQty']?.clear();
//                   item['emr']?.clear();
//                   item['invoice']?.clear();
//                 });
//                 _selectedItems.clear();
//               });
//             } else if (responseValue == -1) {
//               showFlushBar(context, Constants.vehicleNotIn);
//             } else if (responseValue == -2) {
//               showFlushBar(context, Constants.itemreceiptDataNotInserted);
//             } else {
//               showFlushBar(context, Constants.failToInserRecord);
//             }
//           } else {
//             refreshTokens();
//             showFlushBar(context, Constants.recordExist);
//             throw Exception(Constants.listGettingFail);
//           }
//         } catch (e) {
//           debugPrint('Error: $e');
//           showFlushBar(context, Constants.recordExist);
//         }
//       } else {
//         showFlushBar(context, Constants.vehicleValidation);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
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
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
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
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//         showFlushBar(context,  Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       // Make the GET request
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         // Parse the API response
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         // Check if the response list is empty
//         if (apiResponse.isEmpty) {
//           // If the list is empty, do not save
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           // If there is data in the response, process it and save
//           var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)
//
//           // You can validate the fields in the response as needed
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//
//           // Check if all required fields are saved
//           // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
//           //   saveFlag = true;
//           //   // If the conditions are met, set the flag and save the data
//           //   print("Data is valid, proceeding to save.");
//           // } else {
//           //   // If any condition is not met, print a message
//           //   print("Data is incomplete. Cannot proceed to save.");
//           // }
//         }
//       } else {
//         // Handle API error
//         refreshTokens();
//         print("Error: ${response.statusCode}");
//       }
//     }
//     catch (e) {
//       refreshTokens();
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchItems();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//             // checkAndSaveDayEndData();
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = "Expired";
//         String message = "Your Session Is Expire. Click Ok To Login Again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(
//               title,
//               style: Styling.bodyTitle,
//             ),
//             content: Text(
//               message,
//               style: Styling.bodyTitle,
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(
//                   btnLabel,
//                   style: Styling.blueClrText,
//                 ),
//                 // onPressed: () {},
//                 onPressed: () => logoutUser(context),
//
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           child: AlertDialog(
//             title: Text(title),
//             content: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     ///Save data before logout logic
//     EasyLoading.show(status: 'Loading...');
//
//     try {
//       SharedPref().removeUser();
//
//       // try {
//       //   if (Platform.isAndroid) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
//       //   } else if (Platform.isIOS) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
//       //   }
//       // } on PlatformException {
//       //   debugPrint('###PlatformExc');
//       // }
//
//       EasyLoading.dismiss();
//
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
//
// }


// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../ConstantScreen/widgets.dart';
// import '../../../../User/Login/provider/LoginProvider.dart';
// import '../../../../User/splashscreen/page/splash_screen.dart';
// import '../../../../Utils/CustomAppBar.dart';
// import '../../../../Utils/Styling.dart';
// import '../../../../Utils/app_url.dart';
// import '../../../../Utils/constants.dart';
// import '../../../../Utils/shared_preference.dart';
// import '../../../../Utils/styles/app_colors.dart';
// import '../../../../Utils/styles/app_spacing.dart';
// import '../../../BottomNavigationForGodownKeeper.dart';
// import '../../CylItemList/CylItemListModel.dart';
// import 'package:http/http.dart' as http;
// import '../model/GetEXMIListModel.dart';
// import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
//
// // ── Design tokens (inline — no external import needed) ──
// abstract final class _C {
//   static const Color blue       = Color(0xFF1E3A8A);
//   static const Color blueLight  = Color(0xFF2D52C5);
//   static const Color blueXL     = Color(0xFFEFF6FF);
//   static const Color blueXXL    = Color(0xFFDBEAFE);
//   static const Color teal       = Color(0xFF0F766E);
//   static const Color tealXL     = Color(0xFFF0FDFA);
//   static const Color orange     = Color(0xFFF97316);
//   static const Color orangeXL   = Color(0xFFFFF7ED);
//   static const Color red        = Color(0xFFEF4444);
//   static const Color redXL      = Color(0xFFFEF2F2);
//   static const Color green      = Color(0xFF16A34A);
//   static const Color greenXL    = Color(0xFFF0FDF4);
//   static const Color bg         = Color(0xFFF8FAFC);
//   static const Color bg2        = Color(0xFFF1F5FE);
//   static const Color white      = Color(0xFFFFFFFF);
//   static const Color text       = Color(0xFF111827);
//   static const Color textMid    = Color(0xFF374151);
//   static const Color textMuted  = Color(0xFF6B7280);
//   static const Color border     = Color(0xFFE2E8F0);
//
//   static const LinearGradient gradHero = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     stops: [0.0, 0.6, 1.0],
//     colors: [Color(0xFF1E3A8A), Color(0xFF1D5A72), Color(0xFF0F766E)],
//   );
// }
//
// // ─────────────────────────────────────────────
// // MAIN SCREEN
// // ─────────────────────────────────────────────
// class AddReturnItemXMIScreen extends StatefulWidget {
//   static const screenName = '/addReturnItemXMIScreen';
//   const AddReturnItemXMIScreen({super.key});
//
//   @override
//   State<AddReturnItemXMIScreen> createState() => _AddReturnItemXMIScreenState();
// }
//
// class _AddReturnItemXMIScreenState extends State<AddReturnItemXMIScreen> {
//   final TextEditingController receiptDateController = TextEditingController();
//   final TextEditingController vehicleNoController = TextEditingController();
//   List<CylItemListModel> _items = [];
//   Map<int, String?> _selectedItems = {};
//   String? mobileNo;
//   List<Map<String, TextEditingController>> items = [];
//   bool saveFlag = false;
//   var argValue;
//   List<ItemDetails> itemsToShow = [];
//   String? modes;
//   int? receiptIds;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   Map<int, double> _previousInvoiceQuantities = {};
//
//   bool get _isAddNewItemEnabled {
//     return _items.any((item) => !_selectedItems.values.contains(item.itemName));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('dd-MM-yyyy').format(now);
//     receiptDateController.text = formattedDate;
//     _addNewItem();
//     fetchItems();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     vehicleNoController.addListener(_updateButtonState);
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         argValue = ModalRoute.of(context)?.settings.arguments as Map;
//         vehicleNoController.text = argValue?["vehicleNo"] ?? '';
//         modes = argValue?["modeChange"] ?? '';
//         receiptIds = argValue["receiptID"] ?? 0;
//         if (argValue != null) {
//           final itemsToShow = argValue["itemsToShow"] ?? [];
//           if (itemsToShow.isNotEmpty) {
//             _initializeItems(itemsToShow);
//           } else {
//             _initializeItems([]);
//           }
//         }
//       });
//     });
//   }
//
//   void _updateButtonState() {
//     setState(() {});
//   }
//
//   // ─────────────────────────────────────────────
//   // BUILD
//   // ─────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName,
//               arguments: "onBack");
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         }
//       },
//       child: Scaffold(
//         backgroundColor: _C.bg2,
//         appBar: CustomAppBar(
//           title: 'Return ExMI / Rev-EMR',
//         ),
//         body: Column(
//           children: [
//             // ── Gradient Header (no AppBar) ──
//             // _ScreenHeader(
//             //   title: 'Return EXMI / Rev-EMR',
//             //   subtitle: modes == 'Edit' ? 'Edit Mode' : 'New Entry',
//             //   onBack: () {
//             //     if (argLRAdd == "fromDrawer") {
//             //       Navigator.pushReplacementNamed(
//             //           context, BottomNavigationForGodownKeeper.screenName,
//             //           arguments: "onBack");
//             //     } else {
//             //       Navigator.pushReplacementNamed(
//             //           context, BottomNavigationForGodownKeeper.screenName);
//             //     }
//             //   },
//             // ),
//
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//
//                     // ── Date & Vehicle Card ──
//                     _InfoCard(
//                       child: Row(
//                         children: [
//                           // Return Date (read-only)
//                           Expanded(
//                             child: _FieldLabel(
//                               label: 'Return Date',
//                               child: _StyledTextField(
//                                 controller: receiptDateController,
//                                 enabled: false,
//                                 keyboardType: TextInputType.datetime,
//                                 // prefixIcon: Icons.calendar_today_rounded,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           // Vehicle No (required)
//                           Expanded(
//                             child: _FieldLabel(
//                               label: 'Vehicle No.',
//                               required: true,
//                               child: _StyledTextField(
//                                 controller: vehicleNoController,
//                                 textCapitalization: TextCapitalization.words,
//                                 // prefixIcon: Icons.local_shipping_rounded,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(11),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // ── Items Header ──
//                     Row(
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           margin: const EdgeInsets.only(left: 8),
//                           decoration: BoxDecoration(
//                             color: _C.blueLight,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'ITEMS',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: _C.textMid,
//                             letterSpacing: 0.8,
//                           ),
//                         ),
//
//                         const Spacer(),
//                         // Add Item button
//                         _AddItemButton(
//                           enabled: _isAddNewItemEnabled,
//                           onPressed: _isAddNewItemEnabled ? _addNewItem : null,
//                         ),
//                         // _ItemsSectionHeader(
//                         //   isAddEnabled: _isAddNewItemEnabled,
//                         //   onAdd: _addNewItem,
//                         // ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // ── Item List ──
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           return
//                           //   _ItemEntryCard(
//                           //   index: index,
//                           //   items: items,
//                           //   selectedItems: _selectedItems,
//                           //   availableItems: _items,
//                           //   onRemove: () => _removeItem(index),
//                           //   onDropdownChanged: (value) {
//                           //     setState(() {
//                           //       _selectedItems[index] = value ?? '';
//                           //     });
//                           //   },
//                           //   onQtyChanged: (_) => _updateSum(index),
//                           // );
//                           _ItemEntryCard(
//                             index: index,
//                             items: items,
//                             selectedItems: _selectedItems,
//                             availableItems: _items,
//                             onRemove: () => _removeItem(index),
//                             onItemSelected: (value) {
//                               setState(() {
//                                 _selectedItems[index] = value ?? '';
//                               });
//                             },
//                             onQtyChanged: (_) => _updateSum(index),
//                           );
//                         },
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // ── Submit Button ──
//                     _SubmitButton(
//                       saveFlag: saveFlag,
//                       enabled: vehicleNoController.text.isNotEmpty,
//                       onPressed: () {
//                         if (saveFlag) {
//                           showFlushBar(context, Constants.dayEndCompleted);
//                         } else {
//                           if (vehicleNoController.text.isNotEmpty) {
//                             setState(() {
//                               _submitData();
//                             });
//                           }
//                         }
//                       },
//                     ),
//
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   // LOGIC — UNCHANGED
//   // ─────────────────────────────────────────────
//
//   void _addNewItem() {
//     setState(() {
//       int newIndex = items.length;
//       items.add({
//         'selectItem': TextEditingController(),
//         'receivedQty': TextEditingController(),
//         'emr': TextEditingController(),
//         'invoice': TextEditingController(),
//       });
//       _selectedItems[newIndex] = '';
//     });
//   }
//
//   Future<void> fetchItems() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token Is Missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//       debugPrint("item" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items =
//               data.map((json) => CylItemListModel.fromJson(json)).toList();
//         });
//       } else {
//         refreshTokens();
//         throw Exception('Unable To Load Data At This Time. Please Try Again');
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   void _removeItem(int index) {
//     setState(() {
//       print('Removing item at index: $index');
//       print('Selected Items Before: $_selectedItems');
//
//       items[index]['receivedQty']?.dispose();
//       items[index]['emr']?.dispose();
//       items[index]['invoice']?.dispose();
//
//       items.removeAt(index);
//
//       _selectedItems.remove(index);
//       _selectedItems = Map.fromEntries(
//         _selectedItems.entries.map((entry) {
//           return entry.key > index
//               ? MapEntry(entry.key - 1, entry.value)
//               : entry;
//         }),
//       );
//
//       print('Selected Items After: $_selectedItems');
//     });
//   }
//
//   void _updateSum(int index) {
//     double receivedQty =
//         double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
//     double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
//     if (receivedQty != "" && receivedQty != null) {
//       if (emr != "" && emr != null) {
//         double totalSum = receivedQty + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         double totalSum = receivedQty + 0;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       }
//     } else {
//       if (emr != "" && emr != null) {
//         double totalSum = 0 + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         showFlushBar(context, Constants.atLeastOneQtyRequired);
//       }
//     }
//   }
//
//   void _initializeItems(List<ItemDetails> itemsToShow) {
//     setState(() {
//       items.clear();
//       _selectedItems.clear();
//
//       for (var i = 0; i < itemsToShow.length; i++) {
//         var item = itemsToShow[i];
//
//         items.add({
//           'selectItem': TextEditingController(text: item.itemName ?? ''),
//           'receivedQty':
//           TextEditingController(text: item.emptyReturnQty?.toString() ?? ''),
//           'emr': TextEditingController(text: item.emptyEMR?.toString() ?? ''),
//           'invoice':
//           TextEditingController(text: item.eXMIQty?.toString() ?? ''),
//         });
//
//         _selectedItems[items.length - 1] = item.itemName ?? '';
//         _previousInvoiceQuantities[items.length - 1] =
//             (item.eXMIQty ?? 0).toDouble();
//       }
//
//       print('Items Count: ${items.length}');
//       print('Selected Items: $_selectedItems');
//     });
//   }
//
//   Future<void> _submitData() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       if (vehicleNoController.text.isNotEmpty) {
//         List<String> itemsExceedingLimit = [];
//
//         for (var i = 0; i < items.length; i++) {
//           String? invoiceQty = items[i]['invoice']?.text ?? '';
//           String? filledQty = items[i]['receivedQty']?.text ?? '';
//           String? emrQty = items[i]['emr']?.text ?? '';
//           String? selectedItemName = _selectedItems[i];
//           double previousInvoiceQuantity = _previousInvoiceQuantities[i] ?? 0;
//
//           if (selectedItemName == null || selectedItemName.isEmpty) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return;
//           }
//
//           if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return;
//           }
//
//           if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//               (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return;
//           }
//
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//                 (stockItem) => stockItem.itemId == selectedItem.itemId,
//             orElse: () => GetCurrentStcOfGodownKeeperModel(
//               itemId: -1,
//               itemName: '',
//               currentStkFilled: 0,
//               currentStkEmpty: 0,
//               currentStkDefective: 0,
//             ),
//           );
//
//           if (currentStock.itemId == -1) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return;
//           }
//
//           num availableStock = currentStock.currentStkEmpty ?? 0;
//           double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
//           if (modes == "Edit") {
//             if (invoiceQuantity >
//                 ((currentStock.currentStkEmpty ?? 0) +
//                     previousInvoiceQuantity)) {
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint(
//                   "edit ${(currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity}");
//               debugPrint("edit s${previousInvoiceQuantity}");
//             }
//           } else {
//             if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint(
//                   "editcheck ${(currentStock.currentStkEmpty ?? 0)}");
//             }
//           }
//         }
//
//         if (itemsExceedingLimit.isNotEmpty) {
//           String itemsList = itemsExceedingLimit.join(', ');
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text(""),
//                 content: Text(
//                   "${Constants.gretaerItemQty}\n\n" + itemsList,
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("OK"),
//                   ),
//                 ],
//               );
//             },
//           );
//           return;
//         }
//
//         String action;
//         int? rId;
//         if (modes == "Edit") {
//           action = "EDIT";
//           rId = receiptIds;
//         } else {
//           action = "ADD";
//           rId = 0;
//         }
//
//         Set<int> itemIds = {};
//         for (var i = 0; i < items.length; i++) {
//           String? selectedItemName = _selectedItems[i];
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//             int itemId = selectedItem.itemId!.toInt();
//             if (itemIds.contains(itemId)) {
//               showFlushBar(context, Constants.recordExist);
//               return;
//             }
//             itemIds.add(itemId);
//           }
//         }
//
//         List<Map<String, dynamic>> itemDetails = items.map((item) {
//           String? selectedItemName = _selectedItems[items.indexOf(item)];
//
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           return {
//             'ItemId': selectedItem.itemId ?? '',
//             'EmptyReturnQty': item['receivedQty']?.text ?? '',
//             'EmptyEMR': item['emr']?.text ?? '',
//             'EXMIQty': item['invoice']?.text ?? '',
//           };
//         }).toList();
//
//         Map<String, dynamic> requestBody = {
//           'ReturnId': rId,
//           'DistributorId': distributorId,
//           'GodownId': godownId,
//           'ReturnDate': receiptDateController.text,
//           'VehicleNo': vehicleNoController.text,
//           'GodownKeeperId': godownKeeperId,
//           'AddedBy': addedBy,
//           'Action': action,
//           'ItemDetails': itemDetails,
//         };
//
//         String jsonRequestBody = jsonEncode(requestBody);
//         debugPrint(jsonRequestBody);
//
//         try {
//           final response = await http.post(
//             Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonRequestBody,
//           );
//           debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//           if (response.statusCode == 200) {
//             debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//             int responseValue = int.tryParse(response.body) ?? 0;
//             if (responseValue > 0) {
//               EasyLoading.showToast(Constants.itemAddedSuccessfully,
//                   duration: const Duration(milliseconds: 3000));
//               Navigator.pushReplacementNamed(
//                   context, BottomNavigationForGodownKeeper.screenName);
//
//               setState(() {
//                 vehicleNoController.clear();
//                 items.forEach((item) {
//                   item['receivedQty']?.clear();
//                   item['emr']?.clear();
//                   item['invoice']?.clear();
//                 });
//                 _selectedItems.clear();
//               });
//             } else if (responseValue == -1) {
//               showFlushBar(context, Constants.vehicleNotIn);
//             } else if (responseValue == -2) {
//               showFlushBar(context, Constants.itemreceiptDataNotInserted);
//             } else {
//               showFlushBar(context, Constants.failToInserRecord);
//             }
//           } else {
//             refreshTokens();
//             showFlushBar(context, Constants.recordExist);
//             throw Exception(Constants.listGettingFail);
//           }
//         } catch (e) {
//           debugPrint('Error: $e');
//           showFlushBar(context, Constants.recordExist);
//         }
//       } else {
//         showFlushBar(context, Constants.vehicleValidation);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data
//                 .map((json) =>
//                 GetCurrentStcOfGodownKeeperModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//           });
//         } else {
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
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint(
//           "requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//         }
//       } else {
//         refreshTokens();
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       refreshTokens();
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchItems();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = "Expired";
//         String message =
//             "Your Session Is Expire. Click Ok To Login Again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(title, style: Styling.bodyTitle),
//             content: Text(message, style: Styling.bodyTitle),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel, style: Styling.blueClrText),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           child: AlertDialog(
//             title: Text(title),
//             content: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     EasyLoading.show(status: 'Loading...');
//
//     try {
//       SharedPref().removeUser();
//
//       EasyLoading.dismiss();
//
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
// }
//
// // ─────────────────────────────────────────────
// // EXTRACTED REUSABLE WIDGETS
// // ─────────────────────────────────────────────
//
// /// Gradient header strip — replaces AppBar
// class _ScreenHeader extends StatelessWidget {
//   const _ScreenHeader({
//     required this.title,
//     required this.subtitle,
//     required this.onBack,
//   });
//
//   final String title;
//   final String subtitle;
//   final VoidCallback onBack;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(gradient: _C.gradHero),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
//           child: Row(
//             children: [
//               IconButton(
//                 onPressed: onBack,
//                 icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white, size: 20),
//               ),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Mode badge
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.18),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.3), width: 1),
//                 ),
//                 child: Text(
//                   subtitle.toUpperCase(),
//                   style: const TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Card container used for the date/vehicle section
// class _InfoCard extends StatelessWidget {
//   const _InfoCard({required this.child});
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
//
// /// Label + required star wrapper above a field
// class _FieldLabel extends StatelessWidget {
//   const _FieldLabel({
//     required this.label,
//     required this.child,
//     this.required = false,
//   });
//
//   final String label;
//   final Widget child;
//   final bool required;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//                 color: _C.textMuted,
//                 letterSpacing: 0.4,
//               ),
//             ),
//             if (required) ...[
//               const SizedBox(width: 3),
//               const Text(
//                 '*',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w800,
//                   color: _C.red,
//                 ),
//               ),
//             ],
//           ],
//         ),
//         const SizedBox(height: 6),
//         child,
//       ],
//     );
//   }
// }
//
// /// Styled text field matching the dashboard design
// class _StyledTextField extends StatelessWidget {
//   const _StyledTextField({
//     required this.controller,
//     this.enabled = true,
//     this.keyboardType,
//     this.textCapitalization = TextCapitalization.none,
//     this.inputFormatters,
//     this.prefixIcon,
//     this.onChanged,
//     this.hintText,
//   });
//
//   final TextEditingController controller;
//   final bool enabled;
//   final TextInputType? keyboardType;
//   final TextCapitalization textCapitalization;
//   final List<TextInputFormatter>? inputFormatters;
//   final IconData? prefixIcon;
//   final ValueChanged<String>? onChanged;
//   final String? hintText;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       enabled: enabled,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       inputFormatters: inputFormatters,
//       onChanged: onChanged,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: _C.text,
//       ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: _C.textMuted, fontSize: 13),
//         prefixIcon: prefixIcon != null
//             ? Icon(prefixIcon, size: 18, color: _C.blueLight)
//             : null,
//         filled: true,
//         fillColor: enabled ? _C.blueXL : _C.bg,
//         contentPadding:
//         const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: _C.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: _C.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: _C.blueLight, width: 1.5),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: _C.border),
//         ),
//       ),
//     );
//   }
// }
//
// /// Add Item circular button
// // class _AddItemButton extends StatelessWidget {
// //   const _AddItemButton({
// //     required this.enabled,
// //     required this.onPressed,
// //   });
// //
// //   final bool enabled;
// //   final VoidCallback? onPressed;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       color: enabled ? _C.blueLight : _C.border,
// //       borderRadius: BorderRadius.circular(50),
// //
// //       child:
// //       InkWell(
// //         onTap: onPressed,
// //         borderRadius: BorderRadius.circular(50),
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //           child:
// //           Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Icon(
// //                 Icons.add_rounded,
// //                 size: 16,
// //                 color: enabled
// //                     ? AppColors.blueLight
// //                     : AppColors.textMuted,
// //               ),
// //               const SizedBox(width: 4),
// //               Text(
// //                 'Add Item',
// //                 style: AppTypography.seeAll.copyWith(
// //                   color: enabled
// //                       ? AppColors.blueLight
// //                       : AppColors.textMuted,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// // }
//
// // class _AddItemButton extends StatelessWidget {
// //   const _AddItemButton({
// //     required this.enabled,
// //     required this.onPressed,
// //   });
// //
// //   final bool enabled;
// //   final VoidCallback? onPressed;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       color: Colors.transparent, // ✅ removed background
// //       child: InkWell(
// //         onTap: enabled ? onPressed : null,
// //         borderRadius: BorderRadius.circular(20),
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Icon(
// //                 Icons.add_rounded,
// //                 size: 16,
// //                 color: enabled
// //                     ? AppColors.blueLight
// //                     : AppColors.textMuted,
// //               ),
// //               const SizedBox(width: 4),
// //               Text(
// //                 'Add Item',
// //                 style: AppTypography.seeAll.copyWith(
// //                   color: enabled
// //                       ? AppColors.blueLight
// //                       : AppColors.textMuted,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class _AddItemButton extends StatelessWidget {
//   const _AddItemButton({
//     required this.enabled,
//     required this.onPressed,
//   });
//
//   final bool enabled;
//   final VoidCallback? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: enabled ? onPressed : null, // ✅ original logic preserved
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: enabled ? AppColors.blueXL : AppColors.bg2,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: enabled
//                 ? AppColors.blueXXL
//                 : AppColors.border,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.add_rounded,
//               size: 16,
//               color: enabled
//                   ? AppColors.blueLight
//                   : AppColors.textMuted,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               'Add Item',
//               style: AppSpacing.seeAll.copyWith(
//                 color: enabled
//                     ? AppColors.blueLight
//                     : AppColors.textMuted,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ItemsSectionHeader extends StatelessWidget {
//   const _ItemsSectionHeader(
//       {required this.isAddEnabled, required this.onAdd});
//   final bool isAddEnabled;
//   final VoidCallback onAdd;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: AppColors.teal,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text('ITEMS', style: AppSpacing.sectionHeaderq),
//         const Spacer(),
//         GestureDetector(
//           onTap: isAddEnabled ? onAdd : null,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color:
//               isAddEnabled ? AppColors.blueXL : AppColors.bg2,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: isAddEnabled
//                     ? AppColors.blueXXL
//                     : AppColors.border,
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.add_rounded,
//                   size: 16,
//                   color: isAddEnabled
//                       ? AppColors.blueLight
//                       : AppColors.textMuted,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Add Item',
//                   style: AppSpacing.seeAll.copyWith(
//                     color: isAddEnabled
//                         ? AppColors.blueLight
//                         : AppColors.textMuted,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Single item entry card (dropdown + qty fields + remove button)
// // class _ItemEntryCard extends StatelessWidget {
// //   const _ItemEntryCard({
// //     required this.index,
// //     required this.items,
// //     required this.selectedItems,
// //     required this.availableItems,
// //     required this.onRemove,
// //     required this.onDropdownChanged,
// //     required this.onQtyChanged,
// //   });
// //
// //   final int index;
// //   final List<Map<String, TextEditingController>> items;
// //   final Map<int, String?> selectedItems;
// //   final List<CylItemListModel> availableItems;
// //   final VoidCallback onRemove;
// //   final ValueChanged<String?> onDropdownChanged;
// //   final ValueChanged<String> onQtyChanged;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: _C.white,
// //         borderRadius: BorderRadius.circular(18),
// //         boxShadow: const [
// //           BoxShadow(
// //             color: Color(0x0D1E3A8A),
// //             blurRadius: 12,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // ── Row 1: Item number badge + Remove button ──
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: _C.blueXL,
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Text(
// //                     'Item ${index + 1}',
// //                     style: const TextStyle(
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w700,
// //                       color: _C.blue,
// //                       letterSpacing: 0.3,
// //                     ),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 // Remove button
// //                 InkWell(
// //                   onTap: onRemove,
// //                   borderRadius: BorderRadius.circular(50),
// //                   child: Container(
// //                     padding: const EdgeInsets.all(6),
// //                     decoration: BoxDecoration(
// //                       color: _C.redXL,
// //                       borderRadius: BorderRadius.circular(50),
// //                     ),
// //                     child: const Icon(Icons.remove_rounded,
// //                         color: _C.red, size: 18),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //
// //             // ── Row 2: Select Item Dropdown ──
// //             _FieldLabel(
// //               label: 'Select Item',
// //               required: true,
// //               child: _StyledDropdown(
// //                 value: selectedItems[index]?.isEmpty ?? true
// //                     ? null
// //                     : selectedItems[index],
// //                 availableItems: availableItems,
// //                 selectedItems: selectedItems,
// //                 currentIndex: index,
// //                 onChanged: onDropdownChanged,
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //
// //             // ── Row 3: Empty / R-EMR / Total ──
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'Empty',
// //                     child: _StyledTextField(
// //                       controller: items[index]['receivedQty']!,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       onChanged: onQtyChanged,
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'R-EMR',
// //                     child: _StyledTextField(
// //                       controller: items[index]['emr']!,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       onChanged: onQtyChanged,
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'Total',
// //                     required: true,
// //                     child: _StyledTextField(
// //                       controller: items[index]['invoice']!,
// //                       enabled: false,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // class _ItemEntryCard extends StatelessWidget {
// //   const _ItemEntryCard({
// //     required this.index,
// //     required this.items,
// //     required this.selectedItems,
// //     required this.availableItems,
// //     required this.onRemove,
// //     required this.onDropdownChanged,
// //     required this.onQtyChanged,
// //   });
// //
// //   final int index;
// //   final List<Map<String, TextEditingController>> items;
// //   final Map<int, String?> selectedItems;
// //   final List<CylItemListModel> availableItems;
// //   final VoidCallback onRemove;
// //   final ValueChanged<String?> onDropdownChanged;
// //   final ValueChanged<String> onQtyChanged;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 12),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: _C.white,
// //           borderRadius: BorderRadius.circular(18),
// //           boxShadow: const [
// //             BoxShadow(
// //               color: Color(0x0D1E3A8A),
// //               blurRadius: 12,
// //               offset: Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             /// ── Header Row ──
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.blueXL,
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Text(
// //                     'Item ${index + 1}',
// //                     style: AppTypography.badgeText
// //                         .copyWith(color: AppColors.blue),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //
// //                 /// ✅ Remove button (logic unchanged)
// //                 if (items.length > 1)
// //                   InkWell(
// //                     onTap: onRemove,
// //                     borderRadius: BorderRadius.circular(10),
// //                     child: Container(
// //                       width: 36,
// //                       height: 36,
// //                       decoration: BoxDecoration(
// //                         color: AppColors.redXL,
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: const Icon(
// //                         Icons.remove_rounded,
// //                         color: AppColors.red,
// //                         size: 18,
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //
// //             const SizedBox(height: 14),
// //
// //             /// ── Dropdown ──
// //             _FieldLabel(
// //               label: 'Select Item',
// //               required: true,
// //               child: _StyledDropdown(
// //                 value: selectedItems[index]?.isEmpty ?? true
// //                     ? null
// //                     : selectedItems[index],
// //                 availableItems: availableItems,
// //                 selectedItems: selectedItems,
// //                 currentIndex: index,
// //                 onChanged: onDropdownChanged, // ✅ SAME HANDLER
// //               ),
// //             ),
// //
// //             const SizedBox(height: 14),
// //
// //             /// ── Quantity Fields ──
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'Filled',
// //                     child: _StyledTextField(
// //                       controller: items[index]['receivedQty']!,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       onChanged: onQtyChanged,
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'EMR',
// //                     child: _StyledTextField(
// //                       controller: items[index]['emr']!,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       onChanged: onQtyChanged,
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //
// //                 Expanded(
// //                   child: _FieldLabel(
// //                     label: 'Invoice',
// //                     required: true,
// //                     child: _StyledTextField(
// //                       controller: items[index]['invoice']!,
// //                       enabled: false,
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(3),
// //                       ],
// //                       hintText: '0',
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class _ItemEntryCard extends StatelessWidget {
//   const _ItemEntryCard({
//     required this.index,
//     required this.items,
//     required this.selectedItems,
//     required this.availableItems,
//     required this.onRemove,
//     required this.onItemSelected,
//     required this.onQtyChanged,
//   });
//
//   final int index;
//   final List<Map<String, TextEditingController>> items;
//   final Map<int, String?> selectedItems;
//   final List<CylItemListModel> availableItems;
//   final VoidCallback onRemove;
//   final ValueChanged<String?> onItemSelected;
//   final ValueChanged<String> onQtyChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: _DashCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Row label + remove button ──
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.blueXL,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Item ${index + 1}',
//                     style: AppSpacing.badgeText
//                         .copyWith(color: AppColors.blue),
//                   ),
//                 ),
//                 const Spacer(),
//                 if (items.length > 1)
//                   GestureDetector(
//                     onTap: onRemove,
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: AppColors.redXL,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.remove_rounded,
//                           color: AppColors.red, size: 18),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//
//             // ── Item Dropdown ──
//             // DropdownButtonFormField<String>(
//             //   decoration: InputDecoration(
//             //     labelText: 'Select Item *',
//             //     labelStyle: AppTypography.labelMD,
//             //     prefixIcon: const Icon(Icons.inventory_2_rounded,
//             //         size: 18, color: AppColors.textMuted),
//             //     border: OutlineInputBorder(
//             //       borderRadius: BorderRadius.circular(12),
//             //       borderSide:
//             //       const BorderSide(color: AppColors.border),
//             //     ),
//             //     enabledBorder: OutlineInputBorder(
//             //       borderRadius: BorderRadius.circular(12),
//             //       borderSide:
//             //       const BorderSide(color: AppColors.border),
//             //     ),
//             //     focusedBorder: OutlineInputBorder(
//             //       borderRadius: BorderRadius.circular(12),
//             //       borderSide: const BorderSide(
//             //           color: AppColors.blueLight, width: 1.5),
//             //     ),
//             //     contentPadding: const EdgeInsets.symmetric(
//             //         vertical: 14.0, horizontal: 12.0),
//             //     filled: true,
//             //     fillColor: AppColors.bg,
//             //   ),
//             //   items: availableItems
//             //       .where((item) =>
//             //   !selectedItems.values
//             //       .contains(item.itemName) ||
//             //       selectedItems[index] == item.itemName)
//             //       .toSet()
//             //       .map((CylItemListModel item) {
//             //     return DropdownMenuItem<String>(
//             //       value: item.itemName,
//             //       child: Text(
//             //         item.itemName ?? 'Unknown',
//             //         style: AppTypography.dataRowLabel,
//             //       ),
//             //     );
//             //   }).toList(),
//             //   onChanged: onItemSelected,
//             //   value: selectedItems[index]?.isEmpty ?? true
//             //       ? null
//             //       : selectedItems[index],
//             //   icon: const Icon(Icons.keyboard_arrow_down_rounded,
//             //       color: AppColors.textMuted),
//             //   dropdownColor: AppColors.white,
//             //   style: AppTypography.dataRowLabel,
//             // ),
//
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 label: RichText(
//                   text: TextSpan(
//                     text: 'Select Item ',
//                     style: AppSpacing.labelMD,
//                     children: const [
//                       TextSpan(
//                         text: '*',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ),
//                 prefixIcon: const Icon(
//                   Icons.inventory_2_rounded,
//                   size: 18,
//                   color: AppColors.textMuted,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     color: AppColors.blueLight,
//                     width: 1.5,
//                   ),
//                 ),
//                 contentPadding:
//                 const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
//                 filled: true,
//                 fillColor: AppColors.bg,
//               ),
//               items: availableItems
//                   .where((item) =>
//               !selectedItems.values.contains(item.itemName) ||
//                   selectedItems[index] == item.itemName)
//                   .toSet()
//                   .map((CylItemListModel item) {
//                 return DropdownMenuItem<String>(
//                   value: item.itemName,
//                   child: Text(
//                     item.itemName ?? 'Unknown',
//                     style: AppSpacing.dataRowLabel,
//                   ),
//                 );
//               }).toList(),
//               onChanged: onItemSelected,
//               value: selectedItems[index]?.isEmpty ?? true
//                   ? null
//                   : selectedItems[index],
//               icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                   color: AppColors.textMuted),
//               dropdownColor: AppColors.white,
//               style: AppSpacing.dataRowLabel,
//             ),
//
//             const SizedBox(height: 12),
//
//             // ── Qty Fields: Filled | EMR | Invoice ──
//             Row(
//               children: [
//                 Expanded(
//                   child: _StyledField(
//                     label: 'Filled',
//                     controller: items[index]['receivedQty']!,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                     onChanged: onQtyChanged,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: _StyledField(
//                     label: 'EMR',
//                     controller: items[index]['emr']!,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                     onChanged: onQtyChanged,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child:
//                   _StyledField(
//                     label: 'Invoice',
//                     isRequired: true,
//                     controller: items[index]['invoice']!,
//                     keyboardType: TextInputType.number,
//                     enabled: false,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                   ),
//                   // Expanded(
//                   //   child: _StyledField(
//                   //     label: 'Invoice',
//                   //     isRequired: true,
//                   //     controller: items[index]['invoice']!,
//                   //     keyboardType: TextInputType.number,
//                   //     enabled: false,
//                   //     inputFormatters: [
//                   //       FilteringTextInputFormatter.digitsOnly,
//                   //       LengthLimitingTextInputFormatter(3),
//                   //     ],
//                   //   ),
//                   // ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _DashCard extends StatelessWidget {
//   const _DashCard({required this.child});
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
//
// // class _StyledField extends StatelessWidget {
// //   const _StyledField({
// //     required this.label,
// //     required this.controller,
// //     this.icon,
// //     this.enabled = true,
// //     this.keyboardType,
// //     this.textCapitalization = TextCapitalization.none,
// //     this.inputFormatters,
// //     this.onChanged,
// //   });
// //
// //   final String label;
// //   final TextEditingController controller;
// //   final IconData? icon;
// //   final bool enabled;
// //   final TextInputType? keyboardType;
// //   final TextCapitalization textCapitalization;
// //   final List<TextInputFormatter>? inputFormatters;
// //   final ValueChanged<String>? onChanged;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       controller: controller,
// //       enabled: enabled,
// //       keyboardType: keyboardType,
// //       textCapitalization: textCapitalization,
// //       inputFormatters: inputFormatters,
// //       onChanged: onChanged,
// //       style: AppTypography.dataRowLabel,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: AppTypography.labelMD,
// //         prefixIcon: icon != null
// //             ? Icon(icon, size: 18, color: AppColors.textMuted)
// //             : null,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: AppColors.border),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: AppColors.border),
// //         ),
// //         disabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(
// //               color: AppColors.border.withOpacity(0.5)),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(
// //               color: AppColors.blueLight, width: 1.5),
// //         ),
// //         filled: true,
// //         fillColor: enabled ? AppColors.bg : AppColors.bg2,
// //         contentPadding: const EdgeInsets.symmetric(
// //             vertical: 14.0, horizontal: 12.0),
// //         counterText: '',
// //       ),
// //     );
// //   }
// // }
// class _StyledField extends StatelessWidget {
//   const _StyledField({
//     required this.label,
//     required this.controller,
//     this.keyboardType,
//     this.inputFormatters,
//     this.onChanged,
//     this.enabled = true,
//     this.isRequired = false, // ✅ NEW
//   });
//
//   final String label;
//   final TextEditingController controller;
//   final TextInputType? keyboardType;
//   final List<TextInputFormatter>? inputFormatters;
//   final ValueChanged<String>? onChanged;
//   final bool enabled;
//   final bool isRequired; // ✅ NEW
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       onChanged: onChanged,
//       enabled: enabled,
//       decoration: InputDecoration(
//         label: RichText(
//           text: TextSpan(
//             text: label,
//             style: AppSpacing.labelMD,
//             children: isRequired
//                 ? [
//               const TextSpan(
//                 text: ' *',
//                 style: TextStyle(color: AppColors.red),
//               ),
//             ]
//                 : [],
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(
//             color: AppColors.blueLight,
//             width: 1.5,
//           ),
//         ),
//         filled: true,
//         fillColor: AppColors.bg,
//       ),
//     );
//   }
// }
//
// /// Styled dropdown matching the design system
// class _StyledDropdown extends StatelessWidget {
//   const _StyledDropdown({
//     required this.value,
//     required this.availableItems,
//     required this.selectedItems,
//     required this.currentIndex,
//     required this.onChanged,
//   });
//
//   final String? value;
//   final List<CylItemListModel> availableItems;
//   final Map<int, String?> selectedItems;
//   final int currentIndex;
//   final ValueChanged<String?> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.blueXL,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.border),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               color: _C.blueLight, size: 20),
//           hint: const Text(
//             'Select Item',
//             style: TextStyle(fontSize: 13, color: _C.textMuted),
//           ),
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: _C.text,
//           ),
//           items: availableItems
//               .where((item) =>
//           !selectedItems.values.contains(item.itemName) ||
//               selectedItems[currentIndex] == item.itemName)
//               .toSet()
//               .map((CylItemListModel item) {
//             return DropdownMenuItem<String>(
//               value: item.itemName,
//               child: Text(item.itemName ?? 'Unknown'),
//             );
//           }).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }
//
// /// Full-width submit button
// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton({
//     required this.saveFlag,
//     required this.enabled,
//     required this.onPressed,
//   });
//
//   final bool saveFlag;
//   final bool enabled;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isActive = !saveFlag && enabled;
//
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: Material(
//         borderRadius: BorderRadius.circular(14),
//         color: isActive ? _C.blueLight : _C.textMuted,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(14),
//           splashColor: _C.blueXXL,
//           child: Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isActive
//                       ? Icons.check_circle_outline_rounded
//                       : Icons.block_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Submit',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../ConstantScreen/widgets.dart';
// import '../../../../User/Login/provider/LoginProvider.dart';
// import '../../../../User/splashscreen/page/splash_screen.dart';
// import '../../../../Utils/CustomAppBar.dart';
// import '../../../../Utils/Styling.dart';
// import '../../../../Utils/app_url.dart';
// import '../../../../Utils/constants.dart';
// import '../../../../Utils/shared_preference.dart';
// import '../../../BottomNavigationForGodownKeeper.dart';
// import '../../CylItemList/CylItemListModel.dart';
// import 'package:http/http.dart' as http;
// import '../model/GetEXMIListModel.dart';
// import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// class AddReturnItemXMIScreen extends StatefulWidget {
//   static const screenName = '/addReturnItemXMIScreen';
//   const AddReturnItemXMIScreen({super.key});
//
//   @override
//   State<AddReturnItemXMIScreen> createState() => _AddReturnItemXMIScreenState();
// }
//
// class _AddReturnItemXMIScreenState extends State<AddReturnItemXMIScreen> {
//   final TextEditingController receiptDateController = TextEditingController();
//   final TextEditingController vehicleNoController = TextEditingController();
//   List<CylItemListModel> _items = [];
//   Map<int, String?> _selectedItems = {};
//   String? mobileNo;
//   List<Map<String, TextEditingController>> items = [];
//   bool saveFlag = false;
//   var argValue;
//   List<ItemDetails> itemsToShow = [];
//   String? modes;
//   int? receiptIds;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   Map<int, double> _previousInvoiceQuantities = {};
//   // Function to check if items are available for selection
//   bool get _isAddNewItemEnabled {
//     // Check if there are any available items that haven't been selected yet
//     return _items.any((item) => !_selectedItems.values.contains(item.itemName));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Add the first item by default
//     // Get today's date
//
//     DateTime now = DateTime.now();
//
//     // Format it as 'yyyy-MM-dd', or any format you prefer
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//     // Set the formatted date as the default value in the TextField
//     receiptDateController.text = formattedDate;
//     _addNewItem();
//     fetchItems();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     vehicleNoController.addListener(_updateButtonState);
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         argValue = ModalRoute.of(context)?.settings.arguments as Map;
//         vehicleNoController.text = argValue?["vehicleNo"] ?? '';
//         modes = argValue?["modeChange"]?? '';
//         receiptIds = argValue["receiptID"]?? 0;
//         if (argValue != null) {
//           final itemsToShow = argValue["itemsToShow"] ?? [];
//           // _initializeItems(itemsToShow);
//           if (itemsToShow.isNotEmpty) {
//             _initializeItems(itemsToShow);
//           } else {
//             // If no initial data, start with an empty list or default values
//             _initializeItems([]);
//           }
//         }
//       });
//     });
//   }
//
//   void _updateButtonState() {
//     setState(() {});  // Trigger a rebuild when text changes
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName,
//               arguments: "onBack");
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } // In case `null` is returned, return `false`
//       },
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Return EXMI/Rev-EMR', // Title or hint text for the text field
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Receipt Date & Vehicle Number
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: receiptDateController,
//                       decoration: InputDecoration(
//                         labelText: 'Return Date',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.datetime,
//                       enabled: false,
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: TextField(
//                       controller: vehicleNoController,
//                       decoration: InputDecoration(
//                         label: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Text(
//                               'Vehicle No.',
//                               style: TextStyle(fontSize: 12),
//                             ),
//
//                             SizedBox(width: 4),
//
//                             Icon(
//                               Icons.star, // Use a star or any other icon
//                               color: Colors.red, // Set the icon color to red
//                               size: 10, // Adjust the size of the icon
//                             ),
//                           ],
//                         ),
//                         border: const OutlineInputBorder(),
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 12.0),
//                       ),
//                       textCapitalization: TextCapitalization.words,
//                       inputFormatters: <TextInputFormatter>[
//                         LengthLimitingTextInputFormatter(11),
//                         // Allow only digits
//                       ],
//
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Add New Item',
//                     style: TextStyle(fontSize: 16),
//                   ),
//
//                   ElevatedButton(
//                     onPressed: _isAddNewItemEnabled ? _addNewItem : null,
//                     // onPressed: _addNewItem,
//                     child: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         shape: CircleBorder(),
//                         padding: EdgeInsets.all(12),
//                         backgroundColor: Colors.blue),
//                   ),
//                   SizedBox(width: 8),
//
//                 ],
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 16.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child:
//                                 DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text('Select Item',
//                                             style: TextStyle(fontSize: 12)),
//                                         SizedBox(width: 4),
//                                         Icon(Icons.star,
//                                             color: Colors.red, size: 10),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   // Filtering out selected items so they are not shown again in the dropdown
//                                   items: _items
//                                       .where((item) =>
//                                   !_selectedItems.values
//                                       .contains(item.itemName) ||
//                                       _selectedItems[index] ==
//                                           item.itemName)
//                                       .toSet() // Removing duplicates if any
//                                       .map((CylItemListModel item) {
//                                     return DropdownMenuItem<String>(
//                                       value: item.itemName,
//                                       child: Text(item.itemName ?? 'Unknown'),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       // Update the selected value for the current dropdown
//                                       _selectedItems[index] = value ?? '';
//                                     });
//                                   },
//                                   // value: _selectedItems[index]!.isEmpty
//                                   //     ? null
//                                   //     : _selectedItems[index],
//                                   value: _selectedItems[index]?.isEmpty ?? true
//                                       ? null // If the value is null or empty, set to null
//                                       : _selectedItems[index],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   _removeItem(index);
//                                 },
//                                 child: Icon(Icons.remove, color: Colors.red),
//                                 style: ElevatedButton.styleFrom(
//                                   shape: CircleBorder(),
//                                   padding: EdgeInsets.all(12),
//                                   // backgroundColor: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           // Received Qty, EMR, Invoice Fields
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['receivedQty'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text(
//                                           'Empty',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   onChanged: (value) {
//                                     // Update the sum when the value changes
//                                     _updateSum(index);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['emr'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                     label: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: const [
//                                         Text(
//                                           'R-EMR',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 8.0, horizontal: 12.0),
//                                   ),
//                                   onChanged: (value) {
//                                     // Update the sum when the value changes
//                                     _updateSum(index);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: TextField(
//                                   controller: items[index]['invoice'],
//                                   keyboardType: TextInputType.number,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(3),
//                                     // Allow only digits
//                                   ],
//                                   decoration: InputDecoration(
//                                       label: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: const [
//                                           Text(
//                                             'Total',
//                                             style: TextStyle(fontSize: 12),
//                                           ),
//                                           SizedBox(width: 4),
//
//                                           Icon(
//                                             Icons.star,
//                                             color: Colors.red,
//                                             size:
//                                             10,
//                                           ),
//                                         ],
//                                       ),
//                                       border: const OutlineInputBorder(),
//                                       contentPadding:
//                                       const EdgeInsets.symmetric(
//                                           vertical: 8.0, horizontal: 12.0),
//                                       enabled: false),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               // Submit Button
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed:
//                         () {
//                       if(saveFlag){
//                         print('saveFlag $saveFlag');
//                         showFlushBar(context,
//                             Constants.dayEndCompleted);
//                       }else{
//                         if (vehicleNoController.text.isNotEmpty) {
//                           setState(() {
//                             _submitData();
//                           });
//                         } else {
//                           print('Invalid vehicle number');
//                         }
//                       }
//
//                     },
//                     child:
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 20.0, right: 20, top: 12, bottom: 12),
//                       child: const Text(
//                         'Submit',
//                         style: TextStyle(
//                             color: Colors
//                                 .white), // Set text color directly if needed
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: saveFlag? Colors.grey:
//                       (vehicleNoController.text.isNotEmpty ? Colors.blue : Colors.grey),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _addNewItem() {
//     setState(() {
//       int newIndex = items.length;
//       items.add({
//         'selectItem': TextEditingController(),
//         'receivedQty': TextEditingController(),
//         'emr': TextEditingController(),
//         'invoice': TextEditingController(),
//
//       });
//       _selectedItems[newIndex] = '';
//     });
//   }
//   // Fetch data from API
//   Future<void> fetchItems() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token Is Missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//       debugPrint("item" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//         });
//       } else {
//         refreshTokens();
//         throw Exception('Unable To Load Data At This Time. Please Try Again');
//       }
//     } else {
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }
//
//   void _removeItem(int index) {
//     setState(() {
//       // Debugging: Print before removing
//       print('Removing item at index: $index');
//       print('Selected Items Before: $_selectedItems');
//       items[index]['receivedQty']?.dispose();
//       items[index]['emr']?.dispose();
//       items[index]['invoice']?.dispose();
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
//
//       print('Selected Items After: $_selectedItems');
//     });
//   }
//   // Function to update the sum
//   void _updateSum(int index) {
//     // Get the values from the receivedQty and emr controllers
//     double receivedQty =
//         double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
//     double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
//     if (receivedQty != "" && receivedQty != null) {
//       if (emr != "" && emr != null) {
//         double totalSum = receivedQty + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         double totalSum = receivedQty + 0;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       }
//     } else {
//       if (emr != "" && emr != null) {
//         double totalSum = 0 + emr;
//         items[index]['invoice']?.text = totalSum.toInt().toString();
//       } else {
//         showFlushBar(
//             context, Constants.atLeastOneQtyRequired);
//       }
//     }
//   }
//
//   void _initializeItems(List<ItemDetails> itemsToShow) {
//     setState(() {
//       items.clear(); // Clear any existing data
//       _selectedItems.clear(); // Clear previous selections if any
//
//       for (var i = 0; i < itemsToShow.length; i++) {
//         var item = itemsToShow[i];
//         items.add({
//           'selectItem': TextEditingController(text: item.itemName ?? ''),
//           'receivedQty':
//           TextEditingController(text: item.emptyReturnQty?.toString() ?? ''),
//           'emr': TextEditingController(text: item.emptyEMR?.toString() ?? ''),
//           'invoice':
//           TextEditingController(text: item.eXMIQty?.toString() ?? ''),
//         });
//
//         _selectedItems[items.length - 1] = item.itemName ??
//             ''; // Ensure this is added correctly for each index
//         _previousInvoiceQuantities[items.length - 1] = (item.eXMIQty ?? 0).toDouble();
//       }
//
//       // Debugging step to check the number of items
//       print('Items Count: ${items.length}');
//       print('Selected Items: $_selectedItems');
//     });
//   }
//
//   // Future<void> _submitData() async {
//   //   // Fetch shared preference values
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (Constants.isNetworkAvailable) {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? godownId = prefs.getString('godownId');
//   //     String? addedBy = prefs.getString('StaffId');
//   //     String? godownKeeperId = prefs.getString('godownKeeperId');
//   //     String? token = prefs.getString('token');
//   //
//   //     if (vehicleNoController.text.isNotEmpty) {
//   //       // if (isValid) {
//   //       //   print('Valid vehicle number');
//   //
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? invoiceQty = items[i]['invoice']?.text ?? '';
//   //         String? filledQty = items[i]['receivedQty']?.text ?? '';
//   //         String? emrQty = items[i]['emr']?.text ?? '';
//   //         String? selectedItemName = _selectedItems[i];
//   //
//   //         // Check if the selected item is valid (not empty)
//   //         if (selectedItemName == null || selectedItemName.isEmpty) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Check if InvoiceQty is empty or zero
//   //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//   //           showFlushBar(context,Constants.atLeastOneQtyRequired);
//   //           return; // Stop the submission process
//   //         }
//   //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//   //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return;
//   //         }
//   //       }
//   //       String action;
//   //       int? rId;
//   //       if (modes == "Edit") {
//   //         action = "EDIT";
//   //         rId = receiptIds;
//   //       } else {
//   //         action = "ADD";
//   //         rId = 0;
//   //       }
//   //       // Check for duplicate items in the list
//   //       Set<int> itemIds = {};
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? selectedItemName = _selectedItems[i];
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Check if the item ID is valid (not null or zero)
//   //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//   //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//   //           if (itemIds.contains(itemId)) {
//   //             showFlushBar(
//   //                 context,Constants.recordExist);
//   //             return; // Stop the submission process
//   //           }
//   //           itemIds.add(itemId);
//   //         }
//   //       }
//   //
//   //       List<Map<String, dynamic>> itemDetails = items.map((item) {
//   //         String? selectedItemName = _selectedItems[items.indexOf(item)];
//   //
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         return {
//   //           'ItemId': selectedItem.itemId ?? '',
//   //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
//   //           'EXMIQty': item['invoice']?.text ?? '',
//   //
//   //         };
//   //       }).toList();
//   //
//   //       // Build the full JSON object
//   //       Map<String, dynamic> requestBody = {
//   //         'ReturnId': rId,
//   //         'DistributorId': distributorId,
//   //         'GodownId': godownId,
//   //         'ReturnDate': receiptDateController.text,
//   //         'VehicleNo': vehicleNoController.text,
//   //         'GodownKeeperId': godownKeeperId,
//   //         'AddedBy': addedBy,
//   //         'Action': action,
//   //         'ItemList': itemDetails,
//   //       };
//   //
//   //       String jsonRequestBody = jsonEncode(requestBody);
//   //       debugPrint(jsonRequestBody);
//   //
//   //       try {
//   //         final response = await http.post(
//   //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//   //           headers: {
//   //             'Content-Type': 'application/json',
//   //             'Authorization': 'Bearer $token',
//   //           },
//   //           body: jsonRequestBody,
//   //         );
//   //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//   //         if (response.statusCode == 200) {
//   //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//   //           int responseValue = int.tryParse(response.body) ?? 0;
//   //           if (responseValue > 0) {
//   //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
//   //                 duration: const Duration(milliseconds: 3000));
//   //             Navigator.pushReplacementNamed(context, '/godownDashboard');
//   //             setState(() {
//   //               vehicleNoController.clear();
//   //               items.forEach((item) {
//   //                 item['receivedQty']?.clear();
//   //                 item['emr']?.clear();
//   //                 item['invoice']?.clear();
//   //               });
//   //               _selectedItems.clear();
//   //             });
//   //           } else if(responseValue == -1) {
//   //             showFlushBar(
//   //                 context,Constants.vehicleNotIn);
//   //           }else if(responseValue == -2){
//   //             showFlushBar(
//   //                 context,Constants.itemreceiptDataNotInserted);
//   //           }else{
//   //             showFlushBar(
//   //                 context,Constants.failToInserRecord);
//   //           }
//   //         } else {
//   //           refreshTokens();
//   //           showFlushBar(context, Constants.recordExist);
//   //           throw Exception(
//   //               Constants.listGettingFail);
//   //         }
//   //       } catch (e) {
//   //         debugPrint('Error: $e');
//   //         showFlushBar(context, Constants.recordExist);
//   //       }
//   //       // } else {
//   //       //   showFlushBar(context, "Invalid Vehicle Number",
//   //       //       'Please Enter a Valid Vehicle Number!');
//   //       // }
//   //     } else {
//   //       showFlushBar(context, Constants.vehicleValidation);
//   //     }
//   //   } else {
//   //     showFlushBar(
//   //         context, Constants.connectionMessage);
//   //   }
//   // }
//
//   // Future<void> _submitData() async {
//   //   // Fetch shared preference values
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (Constants.isNetworkAvailable) {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? distributorId = prefs.getString('DistributorId');
//   //     String? godownId = prefs.getString('godownId');
//   //     String? addedBy = prefs.getString('StaffId');
//   //     String? godownKeeperId = prefs.getString('godownKeeperId');
//   //     String? token = prefs.getString('token');
//   //
//   //     if (vehicleNoController.text.isNotEmpty) {
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? invoiceQty = items[i]['invoice']?.text ?? '';
//   //         String? filledQty = items[i]['receivedQty']?.text ?? '';
//   //         String? emrQty = items[i]['emr']?.text ?? '';
//   //         String? selectedItemName = _selectedItems[i];
//   //
//   //         // Check if the selected item is valid (not empty)
//   //         if (selectedItemName == null || selectedItemName.isEmpty) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Check if InvoiceQty is empty or zero
//   //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//   //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//   //           showFlushBar(context, Constants.atLeastOneQtyRequired);
//   //           return;
//   //         }
//   //
//   //         // Fetch itemId for the selected item
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Fetch current stock for the itemId
//   //         final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//   //               (stockItem) => stockItem.itemId == selectedItem.itemId,
//   //           orElse: () => GetCurrentStcOfGodownKeeperModel(
//   //             itemId: -1, // Invalid ID to indicate no match found
//   //             itemName: '', // Default value for itemName
//   //             currentStkFilled: 0, // Default value for current stock
//   //             currentStkEmpty: 0,
//   //             currentStkDefective: 0,
//   //           ),
//   //         );
//   //
//   //         // If the current stock is not found (itemId is invalid), show an error
//   //         if (currentStock.itemId == -1) {
//   //           showFlushBar(context, Constants.selectValidItemReceipt);
//   //           return; // Stop the submission process
//   //         }
//   //
//   //         // Compare the invoiceQty with the current stock available
//   //         double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
//   //         if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
//   //           showFlushBar(
//   //               context, 'Invoice qty for item "${selectedItem.itemName}" exceeds current stock');
//   //
//   //           return; // Stop the submission process if invoiceQty is greater than current stock
//   //         }
//   //       }
//   //
//   //       String action;
//   //       int? rId;
//   //       if (modes == "Edit") {
//   //         action = "EDIT";
//   //         rId = receiptIds;
//   //       } else {
//   //         action = "ADD";
//   //         rId = 0;
//   //       }
//   //
//   //       // Check for duplicate items in the list
//   //       Set<int> itemIds = {};
//   //       for (var i = 0; i < items.length; i++) {
//   //         String? selectedItemName = _selectedItems[i];
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         // Check if the item ID is valid (not null or zero)
//   //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//   //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//   //           if (itemIds.contains(itemId)) {
//   //             showFlushBar(context, Constants.recordExist);
//   //             return; // Stop the submission process
//   //           }
//   //           itemIds.add(itemId);
//   //         }
//   //       }
//   //
//   //       List<Map<String, dynamic>> itemDetails = items.map((item) {
//   //         String? selectedItemName = _selectedItems[items.indexOf(item)];
//   //
//   //         CylItemListModel? selectedItem = _items.firstWhere(
//   //               (model) => model.itemName == selectedItemName,
//   //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//   //         );
//   //
//   //         return {
//   //           'ItemId': selectedItem.itemId ?? '',
//   //           'EmptyReturnQty': item['receivedQty']?.text ?? '',
//   //           'EXMIQty': item['invoice']?.text ?? '',
//   //         };
//   //       }).toList();
//   //
//   //       // Build the full JSON object
//   //       Map<String, dynamic> requestBody = {
//   //         'ReturnId': rId,
//   //         'DistributorId': distributorId,
//   //         'GodownId': godownId,
//   //         'ReturnDate': receiptDateController.text,
//   //         'VehicleNo': vehicleNoController.text,
//   //         'GodownKeeperId': godownKeeperId,
//   //         'AddedBy': addedBy,
//   //         'Action': action,
//   //         'ItemList': itemDetails,
//   //       };
//   //
//   //       String jsonRequestBody = jsonEncode(requestBody);
//   //       debugPrint(jsonRequestBody);
//   //
//   //       try {
//   //         final response = await http.post(
//   //           Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//   //           headers: {
//   //             'Content-Type': 'application/json',
//   //             'Authorization': 'Bearer $token',
//   //           },
//   //           body: jsonRequestBody,
//   //         );
//   //         debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//   //         if (response.statusCode == 200) {
//   //           debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//   //           int responseValue = int.tryParse(response.body) ?? 0;
//   //           if (responseValue > 0) {
//   //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
//   //                 duration: const Duration(milliseconds: 3000));
//   //             Navigator.pushReplacementNamed(context, '/godownDashboard');
//   //             setState(() {
//   //               vehicleNoController.clear();
//   //               items.forEach((item) {
//   //                 item['receivedQty']?.clear();
//   //                 item['emr']?.clear();
//   //                 item['invoice']?.clear();
//   //               });
//   //               _selectedItems.clear();
//   //             });
//   //           } else if (responseValue == -1) {
//   //             showFlushBar(context, Constants.vehicleNotIn);
//   //           } else if (responseValue == -2) {
//   //             showFlushBar(context, Constants.itemreceiptDataNotInserted);
//   //           } else {
//   //             showFlushBar(context, Constants.failToInserRecord);
//   //           }
//   //         } else {
//   //           refreshTokens();
//   //           showFlushBar(context, Constants.failToInserRecord);
//   //           throw Exception(Constants.listGettingFail);
//   //         }
//   //       } catch (e) {
//   //         debugPrint('Error: $e');
//   //         showFlushBar(context, Constants.failToInserRecord);
//   //       }
//   //     } else {
//   //       showFlushBar(context, Constants.vehicleValidation);
//   //     }
//   //   } else {
//   //     showFlushBar(context, Constants.connectionMessage);
//   //   }
//   // }
//
//   Future<void> _submitData() async {
//     // Fetch shared preference values
//     Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       if (vehicleNoController.text.isNotEmpty) {
//         List<String> itemsExceedingLimit = []; // List to track items exceeding stock limit
//
//         for (var i = 0; i < items.length; i++) {
//           String? invoiceQty = items[i]['invoice']?.text ?? '';
//           String? filledQty = items[i]['receivedQty']?.text ?? '';
//           String? emrQty = items[i]['emr']?.text ?? '';
//           String? selectedItemName = _selectedItems[i];
//           double previousInvoiceQuantity = _previousInvoiceQuantities[i] ?? 0;
//
//
//           // Check if the selected item is valid (not empty)
//           if (selectedItemName == null || selectedItemName.isEmpty) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return; // Stop the submission process
//           }
//
//           // Check if InvoiceQty is empty or zero
//           if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return; // Stop the submission process
//           }
//
//           if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//               (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//             showFlushBar(context, Constants.atLeastOneQtyRequired);
//             return;
//           }
//
//           // Fetch itemId for the selected item
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           // Fetch current stock for the itemId
//           final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//                 (stockItem) => stockItem.itemId == selectedItem.itemId,
//             orElse: () => GetCurrentStcOfGodownKeeperModel(
//               itemId: -1, // Invalid ID to indicate no match found
//               itemName: '', // Default value for itemName
//               currentStkFilled: 0, // Default value for current stock
//               currentStkEmpty: 0,
//               currentStkDefective: 0,
//             ),
//           );
//
//           // If the current stock is not found (itemId is invalid), show an error
//           if (currentStock.itemId == -1) {
//             showFlushBar(context, Constants.selectValidItemReceipt);
//             return; // Stop the submission process
//           }
//
//           num availableStock = currentStock.currentStkEmpty ?? 0;
//           double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
//           if (modes == "Edit") {
//             if (invoiceQuantity > ((currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity)) {
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint("edit ${(currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity }");
//               debugPrint("edit s${previousInvoiceQuantity }");
//             }
//           }else{
//             if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
//               // Add the item to the list of items exceeding the stock limit
//               itemsExceedingLimit.add(selectedItem.itemName!);
//               debugPrint("editcheck ${(currentStock.currentStkEmpty ?? 0)}");
//             }
//           }
//         }
//
//         if (itemsExceedingLimit.isNotEmpty) {
//           String itemsList = itemsExceedingLimit.join(', ');
//           // showFlushBar(
//           //   context,
//           //   'Invoice qty for the following items exceeds current stock: $itemsList',
//           //
//           // );
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text(""),
//                 content: Text(
//                   "${Constants.gretaerItemQty}\n\n" +
//                       itemsList,
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog
//                     },
//                     child: Text("OK"),
//                   ),
//                 ],
//               );
//             },
//           );
//
//           return; // Stop the submission process
//         }
//         String action;
//         int? rId;
//         if (modes == "Edit") {
//           action = "EDIT";
//           rId = receiptIds;
//         } else {
//           action = "ADD";
//           rId = 0;
//         }
//
//         // Check for duplicate items in the list
//         Set<int> itemIds = {};
//         for (var i = 0; i < items.length; i++) {
//           String? selectedItemName = _selectedItems[i];
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           // Check if the item ID is valid (not null or zero)
//           if (selectedItem.itemId != null && selectedItem.itemId != 0) {
//             int itemId = selectedItem.itemId!.toInt(); // Convert num to int
//             if (itemIds.contains(itemId)) {
//               showFlushBar(context, Constants.recordExist);
//               return; // Stop the submission process
//             }
//             itemIds.add(itemId);
//           }
//         }
//
//         List<Map<String, dynamic>> itemDetails = items.map((item) {
//           String? selectedItemName = _selectedItems[items.indexOf(item)];
//
//           CylItemListModel? selectedItem = _items.firstWhere(
//                 (model) => model.itemName == selectedItemName,
//             orElse: () => CylItemListModel(itemId: 0, itemName: ''),
//           );
//
//           return {
//             'ItemId': selectedItem.itemId ?? '',
//             'EmptyReturnQty': item['receivedQty']?.text ?? '',
//             'EmptyEMR': item['emr']?.text ?? '',
//             'EXMIQty': item['invoice']?.text ?? '',
//           };
//         }).toList();
//
//         // Build the full JSON object
//         Map<String, dynamic> requestBody = {
//           'ReturnId': rId,
//           'DistributorId': distributorId,
//           'GodownId': godownId,
//           'ReturnDate': receiptDateController.text,
//           'VehicleNo': vehicleNoController.text,
//           'GodownKeeperId': godownKeeperId,
//           'AddedBy': addedBy,
//           'Action': action,
//           'ItemDetails': itemDetails,
//         };
//
//         String jsonRequestBody = jsonEncode(requestBody);
//         debugPrint(jsonRequestBody);
//
//         try {
//           final response = await http.post(
//             Uri.parse(AppUrl.ItemRetEXMIAddEdit),
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//             },
//             body: jsonRequestBody,
//           );
//           debugPrint('jsonRequestBody ItemRetEXMIAddEdit: ${jsonRequestBody}');
//           if (response.statusCode == 200) {
//             debugPrint('Response ItemRetEXMIAddEdit: ${response.body}');
//             int responseValue = int.tryParse(response.body) ?? 0;
//             if (responseValue > 0) {
//               EasyLoading.showToast(Constants.itemAddedSuccessfully,
//                   duration: const Duration(milliseconds: 3000));
//               // Navigator.pushReplacementNamed(context, '/godownDashboard');
//               Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
//
//               setState(() {
//                 vehicleNoController.clear();
//                 items.forEach((item) {
//                   item['receivedQty']?.clear();
//                   item['emr']?.clear();
//                   item['invoice']?.clear();
//                 });
//                 _selectedItems.clear();
//               });
//             } else if (responseValue == -1) {
//               showFlushBar(context, Constants.vehicleNotIn);
//             } else if (responseValue == -2) {
//               showFlushBar(context, Constants.itemreceiptDataNotInserted);
//             } else {
//               showFlushBar(context, Constants.failToInserRecord);
//             }
//           } else {
//             refreshTokens();
//             showFlushBar(context, Constants.recordExist);
//             throw Exception(Constants.listGettingFail);
//           }
//         } catch (e) {
//           debugPrint('Error: $e');
//           showFlushBar(context, Constants.recordExist);
//         }
//       } else {
//         showFlushBar(context, Constants.vehicleValidation);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
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
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
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
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//         showFlushBar(context,  Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       // Make the GET request
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         // Parse the API response
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         // Check if the response list is empty
//         if (apiResponse.isEmpty) {
//           // If the list is empty, do not save
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           // If there is data in the response, process it and save
//           var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)
//
//           // You can validate the fields in the response as needed
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//
//           // Check if all required fields are saved
//           // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
//           //   saveFlag = true;
//           //   // If the conditions are met, set the flag and save the data
//           //   print("Data is valid, proceeding to save.");
//           // } else {
//           //   // If any condition is not met, print a message
//           //   print("Data is incomplete. Cannot proceed to save.");
//           // }
//         }
//       } else {
//         // Handle API error
//         refreshTokens();
//         print("Error: ${response.statusCode}");
//       }
//     }
//     catch (e) {
//       refreshTokens();
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchItems();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//             // checkAndSaveDayEndData();
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = "Expired";
//         String message = "Your Session Is Expire. Click Ok To Login Again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(
//               title,
//               style: Styling.bodyTitle,
//             ),
//             content: Text(
//               message,
//               style: Styling.bodyTitle,
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(
//                   btnLabel,
//                   style: Styling.blueClrText,
//                 ),
//                 // onPressed: () {},
//                 onPressed: () => logoutUser(context),
//
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           child: AlertDialog(
//             title: Text(title),
//             content: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     ///Save data before logout logic
//     EasyLoading.show(status: 'Loading...');
//
//     try {
//       SharedPref().removeUser();
//
//       // try {
//       //   if (Platform.isAndroid) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
//       //   } else if (Platform.isIOS) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
//       //   }
//       // } on PlatformException {
//       //   debugPrint('###PlatformExc');
//       // }
//
//       EasyLoading.dismiss();
//
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
//
// }


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
import '../../../../Utils/CustomeAlertDialog.dart';
import '../../../../Utils/Styling.dart';
import '../../../../Utils/Widget.dart';
import '../../../../Utils/app_url.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/styles/app_colors.dart';
import '../../../../Utils/styles/app_spacing.dart';
import '../../../../Utils/styles/app_text_styles.dart';
import '../../../BottomNavigationForGodownKeeper.dart';
import '../../CylItemList/CylItemListModel.dart';
import 'package:http/http.dart' as http;
import '../model/GetEXMIListModel.dart';
import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';

// Design tokens: all color constants moved to AppColors (app_colors.dart).

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────
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

  bool get _isAddNewItemEnabled {
    return _items.any((item) => !_selectedItems.values.contains(item.itemName));
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    receiptDateController.text = formattedDate;
    _addNewItem();
    fetchItems();
    fetchCurrentStock();
    checkAndSaveDayEndData();
    vehicleNoController.addListener(_updateButtonState);
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map? ;
        vehicleNoController.text = argValue?["vehicleNo"] ?? '';
        modes = argValue?["modeChange"] ?? '';
        receiptIds = argValue?["receiptID"] ?? 0;
        if (argValue != null) {
          final itemsToShow = argValue?["itemsToShow"] ?? [];
          if (itemsToShow.isNotEmpty) {
            _initializeItems(itemsToShow);
          } else {
            _initializeItems([]);
          }
        }
      });
    });
  }

  void _updateButtonState() {
    setState(() {});
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        appBar: CustomGKAppBar(
          title: 'Return ExMI / Rev-EMR',
        ),

        body: Column(
          children: [
            // ── Gradient Header (no AppBar) ──
            // AppGradientHeader(
            //               title: 'Return ExMI / Rev-EMR',
            //               subtitle: 'Manage ExMI returns & EMR reversals',
            //               icon: Icons.receipt_long_rounded,
            //               onBack: () => Navigator.pushReplacementNamed(
            //                 context,
            //                 BottomNavigationForGodownKeeper.screenName,
            //                 arguments: "onBack",
            //               ),
            //             ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Date & Vehicle Card ──
                    _InfoCard(
                      child: Row(
                        children: [
                          // Return Date (read-only)
                          Expanded(
                            child: _FieldLabel(
                              label: 'Return Date',
                              child: _StyledTextField(
                                controller: receiptDateController,
                                enabled: false,
                                keyboardType: TextInputType.datetime,
                                // prefixIcon: Icons.calendar_today_rounded,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Vehicle No (required)
                          Expanded(
                            child: _FieldLabel(
                              label: 'Vehicle No.',
                              required: true,
                              child: _StyledTextField(
                                controller: vehicleNoController,
                                textCapitalization: TextCapitalization.words,
                                // prefixIcon: Icons.local_shipping_rounded,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11),

                                  // Allow only A-Z, a-z, 0-9, space and hyphen
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Za-z0-9\s-]'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Items Header ──
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: AppColors.blueLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ITEMS',
                          style: AppSpacing.sectionHeaderq,
                        ),

                        const Spacer(),
                        // Add Item button
                        _AddItemButton(
                          enabled: _isAddNewItemEnabled,
                          onPressed: _isAddNewItemEnabled ? _addNewItem : null,
                        ),
                        // _ItemsSectionHeader(
                        //   isAddEnabled: _isAddNewItemEnabled,
                        //   onAdd: _addNewItem,
                        // ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Item List ──
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return
                            //   _ItemEntryCard(
                            //   index: index,
                            //   items: items,
                            //   selectedItems: _selectedItems,
                            //   availableItems: _items,
                            //   onRemove: () => _removeItem(index),
                            //   onDropdownChanged: (value) {
                            //     setState(() {
                            //       _selectedItems[index] = value ?? '';
                            //     });
                            //   },
                            //   onQtyChanged: (_) => _updateSum(index),
                            // );
                            _ItemEntryCard(
                              index: index,
                              items: items,
                              selectedItems: _selectedItems,
                              availableItems: _items,
                              onRemove: () => _removeItem(index),
                              onItemSelected: (value) {
                                setState(() {
                                  _selectedItems[index] = value ?? '';
                                });
                              },
                              onQtyChanged: (_) => _updateSum(index),
                            );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Submit Button ──
                    _SubmitButton(
                      saveFlag: saveFlag,
                      enabled: vehicleNoController.text.isNotEmpty,
                      onPressed: () {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (vehicleNoController.text.isNotEmpty) {
                            setState(() {
                              _submitData();
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // LOGIC — UNCHANGED
  // ─────────────────────────────────────────────

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

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
      debugPrint("item" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items =
              data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {
        refreshTokens();
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  void _removeItem(int index) {
    setState(() {
      print('Removing item at index: $index');
      print('Selected Items Before: $_selectedItems');

      items[index]['receivedQty']?.dispose();
      items[index]['emr']?.dispose();
      items[index]['invoice']?.dispose();

      items.removeAt(index);

      _selectedItems.remove(index);
      _selectedItems = Map.fromEntries(
        _selectedItems.entries.map((entry) {
          return entry.key > index
              ? MapEntry(entry.key - 1, entry.value)
              : entry;
        }),
      );

      print('Selected Items After: $_selectedItems');
    });
  }

  void _updateSum(int index) {
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
        showFlushBar(context, Constants.atLeastOneQtyRequired);
      }
    }
  }

  void _initializeItems(List<ItemDetails> itemsToShow) {
    setState(() {
      items.clear();
      _selectedItems.clear();

      for (var i = 0; i < itemsToShow.length; i++) {
        var item = itemsToShow[i];

        items.add({
          'selectItem': TextEditingController(text: item.itemName ?? ''),
          'receivedQty':
          TextEditingController(text: item.emptyReturnQty?.toString() ?? ''),
          'emr': TextEditingController(text: item.emptyEMR?.toString() ?? ''),
          'invoice':
          TextEditingController(text: item.eXMIQty?.toString() ?? ''),
        });

        _selectedItems[items.length - 1] = item.itemName ?? '';
        _previousInvoiceQuantities[items.length - 1] =
            (item.eXMIQty ?? 0).toDouble();
      }

      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }

  Future<void> _submitData() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      if (vehicleNoController.text.isNotEmpty) {
        List<String> itemsExceedingLimit = [];

        for (var i = 0; i < items.length; i++) {
          String? invoiceQty = items[i]['invoice']?.text ?? '';
          String? filledQty = items[i]['receivedQty']?.text ?? '';
          String? emrQty = items[i]['emr']?.text ?? '';
          String? selectedItemName = _selectedItems[i];
          double previousInvoiceQuantity = _previousInvoiceQuantities[i] ?? 0;

          if (selectedItemName == null || selectedItemName.isEmpty) {
            showFlushBar(context, Constants.selectValidItemReceipt);
            return;
          }

          if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return;
          }

          if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
              (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return;
          }

          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );

          final currentStock = getCurrentStcOfGodownKeeper.firstWhere(
                (stockItem) => stockItem.itemId == selectedItem.itemId,
            orElse: () => GetCurrentStcOfGodownKeeperModel(
              itemId: -1,
              itemName: '',
              currentStkFilled: 0,
              currentStkEmpty: 0,
              currentStkDefective: 0,
            ),
          );

          if (currentStock.itemId == -1) {
            showFlushBar(context, Constants.selectValidItemReceipt);
            return;
          }

          num availableStock = currentStock.currentStkEmpty ?? 0;
          double invoiceQuantity = double.tryParse(invoiceQty) ?? 0;
          if (modes == "Edit") {
            if (invoiceQuantity >
                ((currentStock.currentStkEmpty ?? 0) +
                    previousInvoiceQuantity)) {
              itemsExceedingLimit.add(selectedItem.itemName!);
              debugPrint(
                  "edit ${(currentStock.currentStkEmpty ?? 0) + previousInvoiceQuantity}");
              debugPrint("edit s${previousInvoiceQuantity}");
            }
          } else {
            if (invoiceQuantity > (currentStock.currentStkEmpty ?? 0)) {
              itemsExceedingLimit.add(selectedItem.itemName!);
              debugPrint(
                  "editcheck ${(currentStock.currentStkEmpty ?? 0)}");
            }
          }
        }

        if (itemsExceedingLimit.isNotEmpty) {
          String itemsList = itemsExceedingLimit.join(', ');
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: const Text(""),
          //       content: Text(
          //         "${Constants.gretaerItemQty}\n\n" + itemsList,
          //       ),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: const Text("OK"),
          //         ),
          //       ],
          //     );
          //   },
          // );
          CustomAlertDialog.showCustomAlert(
            context,
            "${Constants.gretaerItemQty}\n\n$itemsList",
          );
          return;
        }

        String action;
        int? rId;
        if (modes == "Edit") {
          action = "EDIT";
          rId = receiptIds;
        } else {
          action = "ADD";
          rId = 0;
        }

        Set<int> itemIds = {};
        for (var i = 0; i < items.length; i++) {
          String? selectedItemName = _selectedItems[i];
          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );

          if (selectedItem.itemId != null && selectedItem.itemId != 0) {
            int itemId = selectedItem.itemId!.toInt();
            if (itemIds.contains(itemId)) {
              showFlushBar(context, Constants.recordExist);
              return;
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

              await Future.delayed(const Duration(milliseconds: 1500));

              Navigator.pushReplacementNamed(
                  context, BottomNavigationForGodownKeeper.screenName);

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
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data
                .map((json) =>
                GetCurrentStcOfGodownKeeperModel.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
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

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint(
          "requesr bodyCheckDayEndConfirmation: ${response.request}");
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
        refreshTokens();
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      refreshTokens();
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
        String message =
            "Your Session Is Expire. Click Ok To Login Again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(title, style: Styling.bodyTitle),
            content: Text(message, style: Styling.bodyTitle),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel, style: Styling.blueClrText),
                onPressed: () => logoutUser(context),
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
    EasyLoading.show(status: 'Loading...');

    try {
      SharedPref().removeUser();

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

// ─────────────────────────────────────────────
// EXTRACTED REUSABLE WIDGETS
// ─────────────────────────────────────────────

/// Gradient header strip — replaces AppBar
class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.screenHeaderTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.screenHeaderSubtitle,
                    ),
                  ],
                ),
              ),
              // Mode badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  subtitle.toUpperCase(),
                  style: AppTextStyles.heroBadgeLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card container used for the date/vehicle section
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1E3A8A),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Label + required star wrapper above a field
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.fieldLabel,
            ),
            if (required) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: AppTextStyles.requiredStar,
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Styled text field matching the dashboard design
class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    this.enabled = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.onChanged,
    this.hintText,
  });

  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: AppTextStyles.fieldInputText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.fieldHintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppColors.blueLight)
            : null,
        filled: true,
        fillColor: enabled ? AppColors.blueXL : AppColors.bg,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blueLight, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

/// Add Item circular button
// class _AddItemButton extends StatelessWidget {
//   const _AddItemButton({
//     required this.enabled,
//     required this.onPressed,
//   });
//
//   final bool enabled;
//   final VoidCallback? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: enabled ? AppColors.blueLight : AppColors.border,
//       borderRadius: BorderRadius.circular(50),
//
//       child:
//       InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(50),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           child:
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.add_rounded,
//                 size: 16,
//                 color: enabled
//                     ? AppColors.blueLight
//                     : AppColors.textMuted,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 'Add Item',
//                 style: AppTypography.seeAll.copyWith(
//                   color: enabled
//                       ? AppColors.blueLight
//                       : AppColors.textMuted,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }

// class _AddItemButton extends StatelessWidget {
//   const _AddItemButton({
//     required this.enabled,
//     required this.onPressed,
//   });
//
//   final bool enabled;
//   final VoidCallback? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent, // ✅ removed background
//       child: InkWell(
//         onTap: enabled ? onPressed : null,
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.add_rounded,
//                 size: 16,
//                 color: enabled
//                     ? AppColors.blueLight
//                     : AppColors.textMuted,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 'Add Item',
//                 style: AppTypography.seeAll.copyWith(
//                   color: enabled
//                       ? AppColors.blueLight
//                       : AppColors.textMuted,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null, // ✅ original logic preserved
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? AppColors.blueXL : AppColors.bg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled
                ? AppColors.blueXXL
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 16,
              color: enabled
                  ? AppColors.blueLight
                  : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              'Add Item',
              style: AppSpacing.seeAll.copyWith(
                color: enabled
                    ? AppColors.blueLight
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsSectionHeader extends StatelessWidget {
  const _ItemsSectionHeader(
      {required this.isAddEnabled, required this.onAdd});
  final bool isAddEnabled;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.teal,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text('ITEMS', style: AppSpacing.sectionHeaderq),
        const Spacer(),
        GestureDetector(
          onTap: isAddEnabled ? onAdd : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color:
              isAddEnabled ? AppColors.blueXL : AppColors.bg2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAddEnabled
                    ? AppColors.blueXXL
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 16,
                  color: isAddEnabled
                      ? AppColors.blueLight
                      : AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Add Item',
                  style: AppSpacing.seeAll.copyWith(
                    color: isAddEnabled
                        ? AppColors.blueLight
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Single item entry card (dropdown + qty fields + remove button)
// class _ItemEntryCard extends StatelessWidget {
//   const _ItemEntryCard({
//     required this.index,
//     required this.items,
//     required this.selectedItems,
//     required this.availableItems,
//     required this.onRemove,
//     required this.onDropdownChanged,
//     required this.onQtyChanged,
//   });
//
//   final int index;
//   final List<Map<String, TextEditingController>> items;
//   final Map<int, String?> selectedItems;
//   final List<CylItemListModel> availableItems;
//   final VoidCallback onRemove;
//   final ValueChanged<String?> onDropdownChanged;
//   final ValueChanged<String> onQtyChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Row 1: Item number badge + Remove button ──
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.blueXL,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Item ${index + 1}',
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.blue,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 // Remove button
//                 InkWell(
//                   onTap: onRemove,
//                   borderRadius: BorderRadius.circular(50),
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: AppColors.redXL,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: const Icon(Icons.remove_rounded,
//                         color: AppColors.red, size: 18),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//
//             // ── Row 2: Select Item Dropdown ──
//             _FieldLabel(
//               label: 'Select Item',
//               required: true,
//               child: _StyledDropdown(
//                 value: selectedItems[index]?.isEmpty ?? true
//                     ? null
//                     : selectedItems[index],
//                 availableItems: availableItems,
//                 selectedItems: selectedItems,
//                 currentIndex: index,
//                 onChanged: onDropdownChanged,
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // ── Row 3: Empty / R-EMR / Total ──
//             Row(
//               children: [
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'Empty',
//                     child: _StyledTextField(
//                       controller: items[index]['receivedQty']!,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       onChanged: onQtyChanged,
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'R-EMR',
//                     child: _StyledTextField(
//                       controller: items[index]['emr']!,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       onChanged: onQtyChanged,
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'Total',
//                     required: true,
//                     child: _StyledTextField(
//                       controller: items[index]['invoice']!,
//                       enabled: false,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ItemEntryCard extends StatelessWidget {
//   const _ItemEntryCard({
//     required this.index,
//     required this.items,
//     required this.selectedItems,
//     required this.availableItems,
//     required this.onRemove,
//     required this.onDropdownChanged,
//     required this.onQtyChanged,
//   });
//
//   final int index;
//   final List<Map<String, TextEditingController>> items;
//   final Map<int, String?> selectedItems;
//   final List<CylItemListModel> availableItems;
//   final VoidCallback onRemove;
//   final ValueChanged<String?> onDropdownChanged;
//   final ValueChanged<String> onQtyChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x0D1E3A8A),
//               blurRadius: 12,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ── Header Row ──
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.blueXL,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Item ${index + 1}',
//                     style: AppTypography.badgeText
//                         .copyWith(color: AppColors.blue),
//                   ),
//                 ),
//                 const Spacer(),
//
//                 /// ✅ Remove button (logic unchanged)
//                 if (items.length > 1)
//                   InkWell(
//                     onTap: onRemove,
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: AppColors.redXL,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(
//                         Icons.remove_rounded,
//                         color: AppColors.red,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//
//             const SizedBox(height: 14),
//
//             /// ── Dropdown ──
//             _FieldLabel(
//               label: 'Select Item',
//               required: true,
//               child: _StyledDropdown(
//                 value: selectedItems[index]?.isEmpty ?? true
//                     ? null
//                     : selectedItems[index],
//                 availableItems: availableItems,
//                 selectedItems: selectedItems,
//                 currentIndex: index,
//                 onChanged: onDropdownChanged, // ✅ SAME HANDLER
//               ),
//             ),
//
//             const SizedBox(height: 14),
//
//             /// ── Quantity Fields ──
//             Row(
//               children: [
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'Filled',
//                     child: _StyledTextField(
//                       controller: items[index]['receivedQty']!,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       onChanged: onQtyChanged,
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'EMR',
//                     child: _StyledTextField(
//                       controller: items[index]['emr']!,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       onChanged: onQtyChanged,
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//
//                 Expanded(
//                   child: _FieldLabel(
//                     label: 'Invoice',
//                     required: true,
//                     child: _StyledTextField(
//                       controller: items[index]['invoice']!,
//                       enabled: false,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(3),
//                       ],
//                       hintText: '0',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ItemEntryCard extends StatelessWidget {
  const _ItemEntryCard({
    required this.index,
    required this.items,
    required this.selectedItems,
    required this.availableItems,
    required this.onRemove,
    required this.onItemSelected,
    required this.onQtyChanged,
  });

  final int index;
  final List<Map<String, TextEditingController>> items;
  final Map<int, String?> selectedItems;
  final List<CylItemListModel> availableItems;
  final VoidCallback onRemove;
  final ValueChanged<String?> onItemSelected;
  final ValueChanged<String> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _DashCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row label + remove button ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blueXL,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Item ${index + 1}',
                    style: AppSpacing.badgeText
                        .copyWith(color: AppColors.blue),
                  ),
                ),
                const Spacer(),
                if (items.length > 1)
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.redXL,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.remove_rounded,
                          color: AppColors.red, size: 18),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Item Dropdown ──
            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     labelText: 'Select Item *',
            //     labelStyle: AppTypography.labelMD,
            //     prefixIcon: const Icon(Icons.inventory_2_rounded,
            //         size: 18, color: AppColors.textMuted),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       borderSide:
            //       const BorderSide(color: AppColors.border),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       borderSide:
            //       const BorderSide(color: AppColors.border),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       borderSide: const BorderSide(
            //           color: AppColors.blueLight, width: 1.5),
            //     ),
            //     contentPadding: const EdgeInsets.symmetric(
            //         vertical: 14.0, horizontal: 12.0),
            //     filled: true,
            //     fillColor: AppColors.bg,
            //   ),
            //   items: availableItems
            //       .where((item) =>
            //   !selectedItems.values
            //       .contains(item.itemName) ||
            //       selectedItems[index] == item.itemName)
            //       .toSet()
            //       .map((CylItemListModel item) {
            //     return DropdownMenuItem<String>(
            //       value: item.itemName,
            //       child: Text(
            //         item.itemName ?? 'Unknown',
            //         style: AppTypography.dataRowLabel,
            //       ),
            //     );
            //   }).toList(),
            //   onChanged: onItemSelected,
            //   value: selectedItems[index]?.isEmpty ?? true
            //       ? null
            //       : selectedItems[index],
            //   icon: const Icon(Icons.keyboard_arrow_down_rounded,
            //       color: AppColors.textMuted),
            //   dropdownColor: AppColors.white,
            //   style: AppTypography.dataRowLabel,
            // ),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: 'Select Item ',
                    style: AppSpacing.labelMD,
                    children: const [
                      TextSpan(
                        text: '*',
                        style: AppTextStyles.requiredStar,
                      ),
                    ],
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.inventory_2_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.blueLight,
                    width: 1.5,
                  ),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                filled: true,
                fillColor: AppColors.bg,
              ),
              items: availableItems
                  .where((item) =>
              !selectedItems.values.contains(item.itemName) ||
                  selectedItems[index] == item.itemName)
                  .toSet()
                  .map((CylItemListModel item) {
                return DropdownMenuItem<String>(
                  value: item.itemName,
                  child: Text(
                    item.itemName ?? 'Unknown',
                    style: AppSpacing.dataRowLabel,
                  ),
                );
              }).toList(),
              onChanged: onItemSelected,
              value: selectedItems[index]?.isEmpty ?? true
                  ? null
                  : selectedItems[index],
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted),
              dropdownColor: AppColors.white,
              style: AppSpacing.dataRowLabel,
            ),

            const SizedBox(height: 12),

            // ── Qty Fields: Filled | EMR | Invoice ──
            Row(
              children: [
                Expanded(
                  child: _StyledField(
                    label: 'Filled',
                    controller: items[index]['receivedQty']!,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: onQtyChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StyledField(
                    label: 'EMR',
                    controller: items[index]['emr']!,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: onQtyChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child:
                  _StyledField(
                    label: 'Invoice',
                    isRequired: true,
                    controller: items[index]['invoice']!,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                  // Expanded(
                  //   child: _StyledField(
                  //     label: 'Invoice',
                  //     isRequired: true,
                  //     controller: items[index]['invoice']!,
                  //     keyboardType: TextInputType.number,
                  //     enabled: false,
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.digitsOnly,
                  //       LengthLimitingTextInputFormatter(3),
                  //     ],
                  //   ),
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1E3A8A),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// class _StyledField extends StatelessWidget {
//   const _StyledField({
//     required this.label,
//     required this.controller,
//     this.icon,
//     this.enabled = true,
//     this.keyboardType,
//     this.textCapitalization = TextCapitalization.none,
//     this.inputFormatters,
//     this.onChanged,
//   });
//
//   final String label;
//   final TextEditingController controller;
//   final IconData? icon;
//   final bool enabled;
//   final TextInputType? keyboardType;
//   final TextCapitalization textCapitalization;
//   final List<TextInputFormatter>? inputFormatters;
//   final ValueChanged<String>? onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       enabled: enabled,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       inputFormatters: inputFormatters,
//       onChanged: onChanged,
//       style: AppTypography.dataRowLabel,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: AppTypography.labelMD,
//         prefixIcon: icon != null
//             ? Icon(icon, size: 18, color: AppColors.textMuted)
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//               color: AppColors.border.withOpacity(0.5)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(
//               color: AppColors.blueLight, width: 1.5),
//         ),
//         filled: true,
//         fillColor: enabled ? AppColors.bg : AppColors.bg2,
//         contentPadding: const EdgeInsets.symmetric(
//             vertical: 14.0, horizontal: 12.0),
//         counterText: '',
//       ),
//     );
//   }
// }
class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false, // ✅ NEW
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool isRequired; // ✅ NEW

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: AppSpacing.labelMD,
            children: isRequired
                ? [
              const TextSpan(
                text: ' *',
                style: AppTextStyles.requiredStar,
              ),
            ]
                : [],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.blueLight,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: AppColors.bg,
      ),
    );
  }
}

/// Styled dropdown matching the design system
class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.availableItems,
    required this.selectedItems,
    required this.currentIndex,
    required this.onChanged,
  });

  final String? value;
  final List<CylItemListModel> availableItems;
  final Map<int, String?> selectedItems;
  final int currentIndex;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueXL,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.blueLight, size: 20),
          hint: const Text(
            'Select Item',
            style: AppTextStyles.fieldHintText,
          ),
          style: AppTextStyles.dropdownInputText,
          items: availableItems
              .where((item) =>
          !selectedItems.values.contains(item.itemName) ||
              selectedItems[currentIndex] == item.itemName)
              .toSet()
              .map((CylItemListModel item) {
            return DropdownMenuItem<String>(
              value: item.itemName,
              child: Text(item.itemName ?? 'Unknown'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Full-width submit button
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.saveFlag,
    required this.enabled,
    required this.onPressed,
  });

  final bool saveFlag;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isActive = !saveFlag && enabled;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: isActive ? AppColors.blueLight : AppColors.textMuted,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.blueXXL,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.block_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Submit',
                  style: AppTextStyles.submitBtnLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}