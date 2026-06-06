// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../ConstantScreen/widgets.dart';
// import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
// import '../ManagerScreen/BootomNavigatinBarManager.dart';
// import '../ManagerScreen/ManagerModelClass/GetUndocSVStockMovementList.dart';
// import '../Utils/Styling.dart';
// import '../Utils/Widget.dart';
// import '../Utils/app_url.dart';
// import '../Utils/constants.dart';
//
// class DashboardUndocumentedDetails extends StatefulWidget {
//   static const screenName = '/dashboardUndocumentedDetails';
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardUndocumentedDetails();
//   }
// }
//
// class _DashboardUndocumentedDetails extends State<DashboardUndocumentedDetails>{
//   String? formattedDate;
//   bool isLoading = true;
//   List<CylItemListModel> _items = [];
//   CylItemListModel? _selectedItemModel;
//   String? _selectedItem;
//   int? selectedItemId;
//   final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: "ALL");
//   List<GetUndocSvStockMovementList> undocumentedSVModel = [];
//   double? totalAmount;
//   // TextEditingController _consumerNoController = TextEditingController();
//   bool isChecked = false;
//   bool isTextEntered = false;
//   String? errorMessage;
//   late List<String> selectedConsumerNos;
//   bool isCheckboxEnabled = true; // Default to true, enabling checkboxes
//   List<TextEditingController> _consumerNoControllers = [];
//   List<bool> isCheckedList = [];
//   List<bool> isTextEnteredList = [];
//
//   @override
//   void dispose() {
//     // Dispose of each controller when the widget is disposed
//     for (var controller in _consumerNoControllers) {
//       controller.dispose();
//     }
//     super.dispose();  // Don't forget to call the superclass's dispose method
//   }
//   void addItem() {
//     setState(() {
//       // Add a new TextEditingController to the list
//       _consumerNoControllers.add(TextEditingController());
//
//       // Add corresponding states for Checkbox and TextField
//       isCheckedList.add(false);  // Default state for checkbox
//       isTextEnteredList.add(false);  // Default state for text entered
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItems();
//     _selectedItemModel = allItem;
//     getUndocSVStockMovementList(0);
//     _calculateTotalAmount();
//     DateTime now = DateTime.now().toUtc();
//     formattedDate = now.toIso8601String();
//     addItem();
//   }
//   String nullToDash(String? value) {
//     if (value == null || value.toLowerCase() == "null") {
//       return "-";  // If value is null or the string "null", replace with '-'
//     }
//     return value;  // If not null or "null", return the original value
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//     var itemCount = undocumentedSVModel.length;
//     return
//       WillPopScope(
//         onWillPop: () async {
//       // Show a confirmation dialog
//       if (argLRAdd == "fromDrawer") {
//         Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//         return false;
//       } else {
//         Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//         return false;
//       } // In case `null` is returned, return `false`
//     },
//     child:
//     Scaffold(
//       appBar:
//       AppBar(
//         automaticallyImplyLeading: false,
//         surfaceTintColor: Color(0xFFECEFFF),
//         backgroundColor: Color(0xFFECEFFF),
//         flexibleSpace: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.black),
//                   onPressed: () {
//                    // Navigator.pop(context);
//                     Navigator.pushNamed(context, BottomNavBarExample.screenName);
//                   },
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Undocumented SV',
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Total: ${formatCurrency(totalAmount!)}',
//                               style: TextStyle(fontSize: 14, color: Colors.black),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             'Count: $itemCount',
//                             style: TextStyle(fontSize: 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body:
//         Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child:
//             Row(
//               children: [
//                 Text("Select Item:",style: Styling.blueClrText),
//                 Expanded(
//                   child:
//                   DropdownButtonFormField<CylItemListModel>(
//                     decoration: buildInputBorderUpdateStatus("ALL", context),
//                     value: _selectedItemModel,
//                     items: [
//                       DropdownMenuItem<CylItemListModel>(
//                         value: allItem,
//                         child: Text(
//                           "ALL",
//                           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                         ),
//                       ),
//                       ..._items.map((CylItemListModel item) {
//                         return DropdownMenuItem<CylItemListModel>(
//                           value: item,
//                           child: Text(
//                             item.itemName ?? '',
//                             style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                       onChanged: (CylItemListModel? selectedItem) {
//                         if (selectedItem != null) {
//                           setState(() {
//                             _selectedItemModel = selectedItem;
//
//                             // Ensure lists have the same length
//                             if (_consumerNoControllers.length == isCheckedList.length &&
//                                 isCheckedList.length == isTextEnteredList.length) {
//
//                               if (selectedItem.itemId == -1) {
//                                 // "ALL" is selected, disable checkboxes and reset all states
//                                 isCheckboxEnabled = false;
//
//                                 // Clear all TextEditingControllers
//                                 for (var controller in _consumerNoControllers) {
//                                   controller.clear();
//                                 }
//
//                                 // Reset all checkboxes to false
//                                 for (int i = 0; i < isCheckedList.length; i++) {
//                                   isCheckedList[i] = false;
//                                 }
//
//                                 // Reset text field states as well
//                                 for (int i = 0; i < isTextEnteredList.length; i++) {
//                                   isTextEnteredList[i] = false;
//                                 }
//
//                                 // Fetch the list for "ALL" selection
//                                 getUndocSVStockMovementList(0);
//
//                               } else {
//                                 // Specific item is selected, enable checkboxes
//                                 isCheckboxEnabled = true;
//
//                                 // Clear all TextEditingControllers
//                                 for (var controller in _consumerNoControllers) {
//                                   controller.clear();
//                                 }
//
//                                 // Reset all checkboxes to false
//                                 for (int i = 0; i < isCheckedList.length; i++) {
//                                   isCheckedList[i] = false;
//                                 }
//
//                                 // Reset all text field states for all items
//                                 for (int i = 0; i < isTextEnteredList.length; i++) {
//                                   isTextEnteredList[i] = false;
//                                 }
//
//                                 // Find the index for the selected item and reset only its state if necessary
//                                 int selectedIndex = _items.indexWhere((item) => item.itemId == selectedItem.itemId);
//                                 if (selectedIndex != -1 && selectedIndex < isTextEnteredList.length) {
//                                   // Reset selected item's text entry state
//                                   isTextEnteredList[selectedIndex] = false;
//                                 }
//
//                                 // Fetch the list for the selected item
//                                 getUndocSVStockMovementList(selectedItem.itemId?.toInt() ?? 0);
//                               }
//                             } else {
//                               print("Error: Lists have mismatched lengths!");
//                             }
//                           });
//                           print("Selected item: ${selectedItem.itemName}");
//                           print("Item ID: ${selectedItem.itemId}");
//                           print("Text field controllers: $_consumerNoControllers");
//                           print("Checkbox state: $isCheckedList");
//                         }
//                       },
//                       hint: Text('ALL'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child:isLoading
//                 ? Center(child: CircularProgressIndicator()) // Show loader when isLoading is true
//                 : undocumentedSVModel.isNotEmpty
//                 ?
//             ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               itemCount: undocumentedSVModel.length,
//               itemBuilder: (context, index) {
//                 debugPrint("Rendering Expense Item: ${undocumentedSVModel[index]}");
//                 GetUndocSvStockMovementList? sale = undocumentedSVModel[index];
//
//                 // Ensure consumer controllers have the right number of elements
//                 if (_consumerNoControllers.length <= index) {
//                   _consumerNoControllers.add(TextEditingController());
//                   isCheckedList.add(false); // Default checkbox state
//                   isTextEnteredList.add(false); // Default text state
//                 }
//                 return Card(
//                     elevation: 4.0, // Add elevation for shadow
//                     margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2.0), // Margin around the card
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.0), // Rounded corners for card
//                     ),
//                     child: Padding(
//                     padding: EdgeInsets.all(12.0), // Padding inside the card
//                 child:
//                   Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                             flex: 0,
//                             child: countTextWidgetTextWithoutHeading(
//                                 context, DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? '')))),
//                         Expanded(flex: 0, child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.itemName))),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         // Expanded( child: countTextWidgetTextOnAccount(context, "DC.No/Challan No.", nullToDash(sale.consuDCNo))),
//                         Expanded(
//                           child: countTextWidgetTextOnAccount(
//                             context,
//                             "DC.No/Invoice No",
//                             // Show ConsuDCNo if not empty, else show InvoiceNo, else "-"
//                             (sale.consuDCNo?.isNotEmpty == true)
//                                 ? sale.consuDCNo
//                                 : (sale.invoiceNo?.isNotEmpty == true ? sale.invoiceNo : "-"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: countTextWidgetText(context, "Doc. Status", nullToDash(sale.isUndocument == true ? "Pending" : (sale.isUndocument == false ? "Received" : ""))),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "SV Type", nullToDash(sale.sVType))),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Total Amount", nullToDash(formatCurrency((sale.totalAmount ?? 0.0).toDouble())))),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Cyl. Qty.", nullToDash(sale.cylQty.toString()))),
//                         Expanded(
//                           flex: 1,
//                           child:
//                           TextField(
//                             controller: _consumerNoControllers[index],
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(6),
//                               FilteringTextInputFormatter.digitsOnly, // Allow only digits
//                             ],
//                             decoration: InputDecoration(
//                               labelText: 'Consumer No.',  // Dynamic label for each index
//                               labelStyle: TextStyle(
//                                 fontSize: 10.0,
//                               ),
//                               isDense: true, // Reduces the height of the TextField
//                               contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Reduce vertical space
//                             ),
//                             keyboardType: TextInputType.text,
//                             onChanged: (value) {
//                               setState(() {
//                                 isTextEnteredList[index] = value.isNotEmpty;
//                                 // If text is cleared, optionally reset checkbox for this index
//                                 if (!isTextEnteredList[index]) {
//                                   isCheckedList[index] = false;
//                                 }
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: countTextWidgetText(
//                             context,
//                             "Con Name",
//                             nullToDash(sale.consumerName),
//                           ),
//                         ),
//                         Checkbox(
//                           value: isCheckedList[index], // Bind checkbox value to the list
//                           onChanged: isTextEnteredList[index] && isCheckboxEnabled
//                               ? (bool? value) {
//                             setState(() {
//                               isCheckedList[index] = value ?? false;  // Update checkbox state
//                             });
//                           }
//                               : null, // Disable the checkbox if the text field is empty or checkboxes are disabled
//                           fillColor: MaterialStateProperty.resolveWith<Color>((states) {
//                             return states.contains(MaterialState.selected)
//                                 ? Colors.pink
//                                 : Colors.white;
//                           }),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               );
//                },
//             )
//                 : Center(
//               child: Text('No Records Found'),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(right: 15.0,bottom: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     cancelAction();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   ),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 // Adds space between buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     verifyUnDocSVDetailsMob();
//                     },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 10, // Adjust padding to make button smaller
//                     ),
//                   ),
//                   child: Text(
//                     "Submit",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     //  ),
//     ),
//    );
//   }
//
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
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/c');
//       debugPrint("item" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//         });
//       } else {
//         throw Exception('Unable To Load Data At This Time. Please Try Again');
//       }
//     } else {
//       showFlushBar(
//           context,Constants.connectionMessage);
//     }
//   }
//
//   Future<void> getUndocSVStockMovementList(int itemId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//
//     if (!Constants.isNetworkAvailable) {
//       // Return an empty list if there is no network connection
//       showFlushBar(context, Constants.connectionMessage);
//       isLoading = false;
//     } else {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? distributorId = prefs.getString('DistributorId');
//         String? bearerToken = prefs.getString('token');
//         String? userId = prefs.getString("UserId");
//         String? addedBy = prefs.getString('StaffId');
//
//
//         if (bearerToken == null) {
//           isLoading = false;
//           throw Exception('Bearer token is missing');
//         }
//
//         Map<String, dynamic> requestBody = {
//           "DistributorId": distributorId,
//           "ItemId": itemId,
//         };
//
//         final response = await http.post(
//           Uri.parse('${AppUrl.GetUndocSVStockMovementList}'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//             'Content-Type': 'application/json',
//             // Ensure the request body is JSON
//           },
//           body: json.encode(requestBody), // Encode the request body as JSON
//         );
//
//         debugPrint("Response body GetUndocSVStockMovementList: ${response.body}");
//         debugPrint("Request body GetUndocSVStockMovementList: ${response.request}${requestBody}");
//
//         if (response.statusCode == 200) {
//           // Parse the JSON response
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             undocumentedSVModel = data.map((jsonItem) =>
//                 GetUndocSvStockMovementList.fromJson(jsonItem)).toList();
//             _calculateTotalAmount();
//             isLoading = false;
//           });
//         } else {
//           isLoading = false;
//           throw Exception('Failed to load sales data');
//         }
//       } catch (error) {
//         isLoading = false;
//         debugPrint("Error: $error");
//       }
//     }
//   }
//
//   void _calculateTotalAmount() {
//     // Calculate total amount from all items in undocumentedSVModel
//     totalAmount = undocumentedSVModel.fold(
//       0.0,
//           (sum, report) => sum! + (report.totalAmount ?? 0.0),
//     );
//     // Debug print
//     print("Total Amount: $totalAmount");
//   }
//
//
//   Future<void> verifyUnDocSVDetailsMob() async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? staffId = prefs.getString('StaffId');
//     String? userId = prefs.getString("UserId");
//     int? addedBys = int.parse(staffId!);
//     int? distributorIds = int.parse(distributorId!);
//
//
//     List<Map<String, dynamic>> UndocSVDetails = [];
//     // Check if all controllers are empty and all checkboxes are unchecked
//     bool allControllersEmpty = _consumerNoControllers.every((controller) => controller.text.isEmpty);
//     bool allCheckboxesUnchecked = isCheckedList.every((isChecked) => !isChecked);
//
//     if (allControllersEmpty || allCheckboxesUnchecked) {
//       print("No Consumer No. entered and no checkboxes checked. Stopping execution.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please Select Check Box.')),
//       );
//       return;  // Exit the function early
//     }
//     for (var item in undocumentedSVModel) {
//       int index = undocumentedSVModel.indexOf(item);
//       String consumerNo = _consumerNoControllers.length > index
//           ? _consumerNoControllers[index].text
//           : ""; // Default to empty string if there's no controller for this index
//
//       // Ensure the index is within bounds for both _consumerNoControllers and isCheckedList
//       if (index >= _consumerNoControllers.length || index >= isCheckedList.length) {
//         // Skip this item if the index is out of bounds for either list
//         continue;
//       }
//       bool isConsumerNoEntered = consumerNo.isNotEmpty;
//       bool isChecked = isCheckedList[index] ?? false; // Ensure the checkbox state is checked
//
//       // Add the item to the list (including duplicates)
//       if (isConsumerNoEntered && isChecked){
//         UndocSVDetails.add({
//           "PSVId": item.pSVId,
//           // Example static value
//           "DistributorId": distributorId,
//           // Dynamically set from your app's state
//           "ProductId": item.productId,
//           // Assuming productId is part of the item
//           "ConsumerNo": consumerNo,
//           // Get the text from the controller
//           "ConsuDCNo": item.consuDCNo,
//           // Static value, or dynamically set if required
//         });
//      }
//     }
//     final Map<String, dynamic> requestBody =
//     {
//       "DistributorId":distributorId,
//       "FromDate":formattedDate,
//       "ItemName":"",
//       "PSVId":0,
//       "ProductId":0,
//       "ReferredBy":"",
//       "SVDate":formattedDate,
//       "SVType":'',
//       "StaffId":0,
//       "ToDate":formattedDate,
//       "UndocSVDetails":UndocSVDetails,
//     };
//     print("StaffLedgerAddEdit: ${requestBody}");
//     requestBody.forEach((key, value) {
//       print('$key: $value'); // Log the request body for debugging
//     });
//
//     try {
//       // Sending HTTP POST request
//       final response = await http.post(
//         Uri.parse('${AppUrl.VerifyUnDocSVDetails}'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken", // Add Bearer token for authorization
//         },
//         body: json.encode(requestBody), // Send the request body as JSON
//       );
//
//       print("requestBody VerifyUnDocSVDetails: ${response.statusCode} - ${response.request}${requestBody}");
//       print("Response Status Code: ${response.statusCode}");
//
//       // Check if the response is successful (statusCode 200)
//       if (response.statusCode == 200) {
//         // Print the full response body for debugging purposes
//         print("Response VerifyUnDocSVDetails: ${response.body}");
//         var jsonResponse = json.decode(response.body); // if it's JSON
//         print("Decoded Response: $jsonResponse");
//         // Make sure we are comparing the string value of the response body correctly
//         String conNumber = response.body.trim(); // Trim any extra spaces
//         print("Raw Response Body: ${response.body}");
//         // Check if the response body is "Success"
//         if (jsonResponse == "Success") {
//           // If the response is "Success", handle the success case
//           print("Response true : ${response.body}");
//
//           // Navigate to the dashboard screen
//           Navigator.pushNamed(
//             context,
//             DashboardUndocumentedDetails.screenName,
//           );
//
//           // Show a success toast after a small delay (300ms)
//           Future.delayed(Duration(milliseconds: 300), () {
//             EasyLoading.showToast(
//               Constants.expenseSendMgrEdit,
//               duration: const Duration(milliseconds: 3000),
//             );
//           });
//         } else {
//           // If the response body is not "Success", show the duplicate alert
//           print("Response false : ${response.body}");
//           Navigator.pushNamed(
//             context,
//             DashboardUndocumentedDetails.screenName,
//           );
//           _showDuplicateConsumerAlert(conNumber); // Show the duplicate alert with the response value
//         }
//       } else {
//         // If the response status code is not 200, handle it as an error
//         print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
//
//         EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
//       }
//     } catch (e) {
//       // Catch any unexpected errors, such as network issues
//       print("Exception occurred: $e");
//       EasyLoading.showToast("An error occurred. Please try again later.", duration: const Duration(milliseconds: 3000));
//     }
//   }
//
//   void cancelAction() {
//     setState(() {
//         Navigator.pop(context);
//         Navigator.pushNamed(
//             context,
//             DashboardUndocumentedDetails.screenName// This opens the third tab
//         );
//     });
//
//   }
//
//   String formatCurrency(double amount) {
//     if (amount == 0) {
//       return '0.00'; // Return "0.00" if the amount is zero
//     }
//     final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator
//
//     // Ensure the result always shows a leading zero before the decimal point
//     String formattedAmount = format.format(amount);
//
//     // If there's no integer part, it ensures that a leading zero is added before decimal
//     if (amount < 1 && formattedAmount.startsWith('.')) {
//       formattedAmount = '0' + formattedAmount;
//     }
//     return formattedAmount;
//   }
//
//   void _showDuplicateConsumerAlert(String consumerNo) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Icon(
//                 Icons.close, // You can change the icon to any you prefer
//                 color: Colors.red, // Optional: color for the icon
//               ),
//               SizedBox(width: 10), // Adds space between icon and text
//               Text('Oops'),
//             ],
//           ),
//           content: Text('$consumerNo Consumer No.Record already exists.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 //Navigator.of(context).pop();
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../ManagerScreen/BootomNavigatinBarManager.dart';
import '../ManagerScreen/ManagerModelClass/GetUndocSVStockMovementList.dart';
import '../Utils/BoxShadow/app_typography.dart';
import '../Utils/styles/app_colors.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UNDOCUMENTED SV — DETAILS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class DashboardUndocumentedDetails extends StatefulWidget {
  static const screenName = '/dashboardUndocumentedDetails';

  @override
  State<DashboardUndocumentedDetails> createState() =>
      _DashboardUndocumentedDetailsState();
}

class _DashboardUndocumentedDetailsState
    extends State<DashboardUndocumentedDetails> {
  // ── State ──────────────────────────────────────────────────────────────────
  String? formattedDate;
  bool isLoading = true;

  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;

  final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: 'ALL');

  List<GetUndocSvStockMovementList> undocumentedSVModel = [];
  double? totalAmount;

  bool isChecked = false;
  bool isTextEntered = false;
  String? errorMessage;
  late List<String> selectedConsumerNos;
  bool isCheckboxEnabled = true;

  List<TextEditingController> _consumerNoControllers = [];
  List<bool> isCheckedList = [];
  List<bool> isTextEnteredList = [];

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    for (var controller in _consumerNoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addItem() {
    setState(() {
      _consumerNoControllers.add(TextEditingController());
      isCheckedList.add(false);
      isTextEnteredList.add(false);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    _selectedItemModel = allItem;
    getUndocSVStockMovementList(0);
    _calculateTotalAmount();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    addItem();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == 'null') return '–';
    return value;
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0$formattedAmount';
    }
    return formattedAmount;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _ItemFilterBar(),
            Expanded(child: _buildBody()),
            _BottomActionBar(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradHero),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    BottomNavBarExample.screenName,
                  ),
                ),
                const SizedBox(width: 4),

                // Title + stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Undocumented SV',
                        style: AppTypography.heroTitle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total: ₹${formatCurrency(totalAmount ?? 0.0)}',
                              style: AppTypography.heroSubtitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Count: ${undocumentedSVModel.length}',
                            style: AppTypography.heroSubtitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter bar ─────────────────────────────────────────────────────────────
  Widget _ItemFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          const Text(
            'Item:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryXXLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CylItemListModel>(
                  isExpanded: true,
                  value: _selectedItemModel,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  items: [
                    DropdownMenuItem<CylItemListModel>(
                      value: allItem,
                      child: const Text('ALL'),
                    ),
                    ..._items.map((CylItemListModel item) {
                      return DropdownMenuItem<CylItemListModel>(
                        value: item,
                        child: Text(item.itemName ?? ''),
                      );
                    }).toList(),
                  ],
                  onChanged: (CylItemListModel? selectedItem) {
                    if (selectedItem != null) {
                      setState(() {
                        _selectedItemModel = selectedItem;

                        if (_consumerNoControllers.length ==
                            isCheckedList.length &&
                            isCheckedList.length == isTextEnteredList.length) {
                          if (selectedItem.itemId == -1) {
                            isCheckboxEnabled = false;
                            for (var c in _consumerNoControllers) {
                              c.clear();
                            }
                            for (int i = 0; i < isCheckedList.length; i++) {
                              isCheckedList[i] = false;
                            }
                            for (int i = 0; i < isTextEnteredList.length; i++) {
                              isTextEnteredList[i] = false;
                            }
                            getUndocSVStockMovementList(0);
                          } else {
                            isCheckboxEnabled = true;
                            for (var c in _consumerNoControllers) {
                              c.clear();
                            }
                            for (int i = 0; i < isCheckedList.length; i++) {
                              isCheckedList[i] = false;
                            }
                            for (int i = 0; i < isTextEnteredList.length; i++) {
                              isTextEnteredList[i] = false;
                            }
                            int selectedIndex = _items.indexWhere(
                                    (item) => item.itemId == selectedItem.itemId);
                            if (selectedIndex != -1 &&
                                selectedIndex < isTextEnteredList.length) {
                              isTextEnteredList[selectedIndex] = false;
                            }
                            getUndocSVStockMovementList(
                                selectedItem.itemId?.toInt() ?? 0);
                          }
                        } else {
                          debugPrint('Error: Lists have mismatched lengths!');
                        }
                      });
                      debugPrint('Selected item: ${selectedItem.itemName}');
                      debugPrint('Item ID: ${selectedItem.itemId}');
                    }
                  },
                  hint: const Text('ALL'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── List body ──────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (undocumentedSVModel.isEmpty) {
      return _EmptyState();
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      itemCount: undocumentedSVModel.length,
      itemBuilder: (context, index) {
        final sale = undocumentedSVModel[index];

        // Ensure parallel lists stay in sync
        if (_consumerNoControllers.length <= index) {
          _consumerNoControllers.add(TextEditingController());
          isCheckedList.add(false);
          isTextEnteredList.add(false);
        }

        return _UndocCard(
          sale: sale,
          index: index,
          controller: _consumerNoControllers[index],
          isChecked: isCheckedList[index],
          isTextEntered: isTextEnteredList[index],
          isCheckboxEnabled: isCheckboxEnabled,
          onTextChanged: (value) {
            setState(() {
              isTextEnteredList[index] = value.isNotEmpty;
              if (!isTextEnteredList[index]) {
                isCheckedList[index] = false;
              }
            });
          },
          onCheckboxChanged: (value) {
            setState(() {
              isCheckedList[index] = value ?? false;
            });
          },
          nullToDash: nullToDash,
          formatCurrency: formatCurrency,
        );
      },
    );
  }

  // ── Bottom action bar ──────────────────────────────────────────────────────
  Widget _BottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Cancel
          OutlinedButton(
            onPressed: cancelAction,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              shape: const StadiumBorder(),
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Submit
          ElevatedButton(
            onPressed: verifyUnDocSVDetailsMob,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── API calls (unchanged) ──────────────────────────────────────────────────
  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) throw Exception('Bearer Token Is Missing');

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint('item${AppUrl.GetItemMasterList}/$distributorId/1/c');
      debugPrint('item${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items =
              data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> getUndocSVStockMovementList(int itemId) async {
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

        final response = await http.post(
          Uri.parse('${AppUrl.GetUndocSVStockMovementList}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({'DistributorId': distributorId, 'ItemId': itemId}),
        );

        debugPrint(
            'Response body GetUndocSVStockMovementList: ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            undocumentedSVModel = data
                .map((jsonItem) =>
                GetUndocSvStockMovementList.fromJson(jsonItem))
                .toList();
            _calculateTotalAmount();
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint('Error: $error');
      }
    }
  }

  void _calculateTotalAmount() {
    totalAmount = undocumentedSVModel.fold(
      0.0,
          (sum, report) => sum! + (report.totalAmount ?? 0.0),
    );
    debugPrint('Total Amount: $totalAmount');
  }

  Future<void> verifyUnDocSVDetailsMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString('UserId');
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);

    List<Map<String, dynamic>> UndocSVDetails = [];
    bool allControllersEmpty = _consumerNoControllers
        .every((controller) => controller.text.isEmpty);
    bool allCheckboxesUnchecked =
    isCheckedList.every((isChecked) => !isChecked);

    if (allControllersEmpty || allCheckboxesUnchecked) {
      debugPrint(
          'No Consumer No. entered and no checkboxes checked. Stopping execution.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Select Check Box.')),
      );
      return;
    }

    for (var item in undocumentedSVModel) {
      int index = undocumentedSVModel.indexOf(item);
      String consumerNo = _consumerNoControllers.length > index
          ? _consumerNoControllers[index].text
          : '';

      if (index >= _consumerNoControllers.length ||
          index >= isCheckedList.length) continue;

      bool isConsumerNoEntered = consumerNo.isNotEmpty;
      bool isChecked = isCheckedList[index] ?? false;

      if (isConsumerNoEntered && isChecked) {
        UndocSVDetails.add({
          'PSVId': item.pSVId,
          'DistributorId': distributorId,
          'ProductId': item.productId,
          'ConsumerNo': consumerNo,
          'ConsuDCNo': item.consuDCNo,
        });
      }
    }

    final Map<String, dynamic> requestBody = {
      'DistributorId': distributorId,
      'FromDate': formattedDate,
      'ItemName': '',
      'PSVId': 0,
      'ProductId': 0,
      'ReferredBy': '',
      'SVDate': formattedDate,
      'SVType': '',
      'StaffId': 0,
      'ToDate': formattedDate,
      'UndocSVDetails': UndocSVDetails,
    };
    debugPrint('StaffLedgerAddEdit: $requestBody');

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.VerifyUnDocSVDetails}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode(requestBody),
      );

      debugPrint(
          'requestBody VerifyUnDocSVDetails: ${response.statusCode} - ${response.request}$requestBody');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String conNumber = response.body.trim();

        if (jsonResponse == 'Success') {
          Navigator.pushNamed(context, DashboardUndocumentedDetails.screenName);
          Future.delayed(const Duration(milliseconds: 300), () {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          });
        } else {
          Navigator.pushNamed(context, DashboardUndocumentedDetails.screenName);
          _showDuplicateConsumerAlert(conNumber);
        }
      } else {
        EasyLoading.showToast('Request failed. Please try again.',
            duration: const Duration(milliseconds: 3000));
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      EasyLoading.showToast('An error occurred. Please try again later.',
          duration: const Duration(milliseconds: 3000));
    }
  }

  void cancelAction() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, DashboardUndocumentedDetails.screenName);
    });
  }

  void _showDuplicateConsumerAlert(String consumerNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.redXLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.error_outline_rounded,
                    color: AppColors.red, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Duplicate Entry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            '$consumerNo — Consumer No. record already exists.',
            style: AppTypography.cardSubtitle,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: const Text('OK',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UNDOC CARD — single list item
// ─────────────────────────────────────────────────────────────────────────────

class _UndocCard extends StatelessWidget {
  const _UndocCard({
    required this.sale,
    required this.index,
    required this.controller,
    required this.isChecked,
    required this.isTextEntered,
    required this.isCheckboxEnabled,
    required this.onTextChanged,
    required this.onCheckboxChanged,
    required this.nullToDash,
    required this.formatCurrency,
  });

  final GetUndocSvStockMovementList sale;
  final int index;
  final TextEditingController controller;
  final bool isChecked;
  final bool isTextEntered;
  final bool isCheckboxEnabled;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<bool?> onCheckboxChanged;
  final String Function(String?) nullToDash;
  final String Function(double) formatCurrency;

  // Doc status helpers
  Color get _statusColor => sale.isUndocument == true
      ? AppColors.orange
      : AppColors.green;

  Color get _statusBg => sale.isUndocument == true
      ? AppColors.orangeXLight
      : AppColors.greenXLight;

  String get _statusLabel => sale.isUndocument == true
      ? 'Pending'
      : (sale.isUndocument == false ? 'Received' : '–');

  String get _dcOrInvoice =>
      (sale.consuDCNo?.isNotEmpty == true)
          ? sale.consuDCNo!
          : (sale.invoiceNo?.isNotEmpty == true ? sale.invoiceNo! : '–');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header: date + item name + status badge ───
          _CardHeader(
            date: _formatDate(sale.sVDate),
            itemName: nullToDash(sale.itemName),
            statusLabel: _statusLabel,
            statusColor: _statusColor,
            statusBg: _statusBg,
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.divider),

          // ── Info rows ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Column(
              children: [
                _InfoRow(
                  label: 'DC / Invoice No.',
                  value: _dcOrInvoice,
                  icon: Icons.receipt_long_rounded,
                ),
                _InfoRow(
                  label: 'SV Type',
                  value: nullToDash(sale.sVType),
                  icon: Icons.swap_horiz_rounded,
                ),
                _InfoRow(
                  label: 'Total Amount',
                  value: '₹${formatCurrency((sale.totalAmount ?? 0.0).toDouble())}',
                  icon: Icons.currency_rupee_rounded,
                  valueColor: AppColors.teal,
                ),
              ],
            ),
          ),

          // ── Consumer entry row: Cyl.Qty + Consumer No. text field ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Cyl Qty chip
                _CylQtyChip(qty: nullToDash(sale.cylQty.toString())),
                const SizedBox(width: 12),

                // Consumer No. text field
                Expanded(
                  child: _ConsumerTextField(
                    controller: controller,
                    onChanged: onTextChanged,
                  ),
                ),
              ],
            ),
          ),

          // ── Con name + checkbox ────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 10, 10),
            decoration: const BoxDecoration(
              color: AppColors.background2,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONSUMER NAME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nullToDash(sale.consumerName),
                        style: AppTypography.dataRowLabel.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkbox
                _VerifyCheckbox(
                  value: isChecked,
                  enabled: isTextEntered && isCheckboxEnabled,
                  onChanged: onCheckboxChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '–';
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE COMPONENT WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Card top bar: date on the left, item name centre, doc-status badge right.
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.date,
    required this.itemName,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBg,
  });

  final String date;
  final String itemName;
  final String statusLabel;
  final Color statusColor;
  final Color statusBg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          // Date pill
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.primaryXXLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 11, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Item name
          Expanded(
            child: Text(
              itemName,
              style: AppTypography.cardTitle.copyWith(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          // Doc status badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Label + value info row with a leading icon badge.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.background2,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 14, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.labelMD.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.dataRowValue.copyWith(
                fontSize: 13,
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cylinder quantity chip — compact pill display.
class _CylQtyChip extends StatelessWidget {
  const _CylQtyChip({required this.qty});

  final String qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tealXLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'CYL QTY',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.teal,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            qty,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.teal,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Consumer No. text field — styled with design-system tokens.
class _ConsumerTextField extends StatelessWidget {
  const _ConsumerTextField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: 'Consumer No.',
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
        isDense: true,
        filled: true,
        fillColor: AppColors.background2,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
          const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

/// Themed verify checkbox — primary color when enabled, grey when not.
class _VerifyCheckbox extends StatelessWidget {
  const _VerifyCheckbox({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final bool value;
  final bool enabled;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'VERIFY',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!enabled) return AppColors.textDisabled;
            return states.contains(MaterialState.selected)
                ? AppColors.primary
                : Colors.white;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: BorderSide(
            color: enabled ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Records Found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No undocumented SV transactions available.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}