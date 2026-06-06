// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../BootomNavigatinBarManager.dart';
// import '../ClickModelClass/GetCreditSaleLedgerDtlsListModel.dart';
// import '../ClickModelClass/GetTopFiveCreditorsModel.dart';
// import '../PaymentReceiptScreen/GetCustomerListModel.dart';
//
//
// class CreditSaleCountDetailListUI extends StatefulWidget {
//   static const screenName = '/creditSaleCountDetailListUI';
//   @override
//   State<StatefulWidget> createState() {
//     return _CreditSaleCountDetailListUI();
//   }
// }
//
// class _CreditSaleCountDetailListUI extends State<CreditSaleCountDetailListUI>{
//   String? formattedDate;
//   bool isLoading = true;
//   List<GetCreditSaleLedgerDtlsListModel> _items = [];
//   List<GetTopFiveCreditorsModel> _topFiveItems = [];
//   List<GetCreditSaleLedgerDtlsListModel> displayList = [];
//   List<GetTopFiveCreditorsModel> topFivedisplayList = [];
//   List<GetCustomerListModel> customerModel = [];
//   GetCustomerListModel? _selectedItemModel;
//   final GetCustomerListModel allItem = GetCustomerListModel(customerId: -1, customerName: "ALL");
//   final top5Item = GetCustomerListModel(customerId: -2, customerName: 'Top 5');
//   final oldestItem = GetCustomerListModel(customerId: -3, customerName: 'Oldest');
//   String? _selectedItem;
//   int? selectedItemId;
//   double? totalOutstandingAmount;
//   double? totalOutstandingAmountForFive;
//   bool isChecked = false;
//   bool isTextEntered = false;
//   String? errorMessage;
//   late List<String> selectedConsumerNos;
//   bool isCheckboxEnabled = true; // Default to true, enabling checkboxes
//   List<TextEditingController> _consumerNoControllers = [];
//   List<bool> isCheckedList = [];
//   List<bool> isTextEnteredList = [];
//   //String label = '';
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
//
//       _consumerNoControllers.add(TextEditingController());
//
//       isCheckedList.add(false);  // Default state for checkbox
//       isTextEnteredList.add(false);  // Default state for text entered
//     });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedItemModel = allItem;
//     getCreditSaleLedgerDtls(0);
//     getTopFiveCreditors(0);
//     getCustomerList();
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
//
//     String formattedAmount = formatCurrency(totalOutstandingAmount ?? 0.0);
//     String formattedAmountForFiveDist = formatCurrency(totalOutstandingAmountForFive ?? 0.0);
//
//     String label = _selectedItem == "Top 5 outstanding"
//         ? 'Total Outstanding Amount: $formattedAmountForFiveDist'
//         : 'Total Outstanding Amount: $formattedAmount';
//
//     print(label);
//     print('Total Outstanding Amount Data: $label');
//
//     final currentList = (_selectedItem == "Top 5 outstanding")
//         ? topFivedisplayList
//         : displayList;
//     return
//       WillPopScope(
//         onWillPop: () async {
//           if (argLRAdd == "fromDrawer") {
//             Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//             return false;
//           } else {
//             Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
//             return false;
//           }
//         },
//         child:
//         Scaffold(
//           appBar:
//           PreferredSize(
//             preferredSize: Size.fromHeight(60.0),
//             child:
//             AppBar(
//               automaticallyImplyLeading: false,
//               surfaceTintColor: Color(0xFFECEFFF),
//               backgroundColor: Color(0xFFECEFFF),
//               flexibleSpace: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.black),
//                         onPressed: () {
//                          Navigator.pushNamed(context, BottomNavBarExample.screenName);
//                           // Navigator.pop(context);
//
//                         },
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Credit Sale Ledger',
//                               style: TextStyle(fontSize: 16, color: Colors.black),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     '${label}',
//                                     style: TextStyle(fontSize: 12, color: Colors.black),
//                                     overflow: TextOverflow.ellipsis,
//                                     textScaler: TextScaler.noScaling,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           body:
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child:
//                 Row(
//                   children: [
//                     Text("Select Customer:",style: Styling.blueClrText,textScaler: TextScaler.noScaling,),
//                     // Expanded(
//                     //   child: DropdownButtonFormField<GetCustomerListModel>(
//                     //     isExpanded: true,
//                     //     decoration: buildInputBorderUpdateStatus("ALL", context),
//                     //     value: _selectedItemModel,
//                     //     items: [
//                     //       DropdownMenuItem<GetCustomerListModel>(
//                     //         value: allItem,
//                     //         child: Text(
//                     //           "ALL",
//                     //           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                     //           textScaler:
//                     //           TextScaler.noScaling,
//                     //         ),
//                     //       ),
//                     //       ...customerModel.map((GetCustomerListModel item) {
//                     //         return DropdownMenuItem<GetCustomerListModel>(
//                     //           value: item,
//                     //           child: Text(
//                     //             item.customerName ?? '',
//                     //             style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                     //             textScaler:
//                     //             TextScaler.noScaling,
//                     //           ),
//                     //         );
//                     //       }).toList(),
//                     //     ],
//                     //     onChanged: (GetCustomerListModel? selectedItem) {
//                     //       if (selectedItem != null) {
//                     //         setState(() {
//                     //           _selectedItemModel = selectedItem;
//                     //
//                     //           if (selectedItem.customerId == -1) {
//                     //             _selectedItem = "ALL";
//                     //             selectedItemId = -1;
//                     //             showTop5ByOutstanding();
//                     //             // getCreditSaleLedgerDtls(0);
//                     //           } else {
//                     //             _selectedItem = selectedItem.customerName!;
//                     //             selectedItemId = selectedItem.customerId?.toInt();
//                     //             getCreditSaleLedgerDtls(selectedItemId!);
//                     //           }
//                     //         });
//                     //       }
//                     //     },
//                     //     hint: Text('ALL',
//                     //       textScaler:
//                     //       TextScaler.noScaling,),
//                     //   ),
//                     // ),
//
//                     ///top 5
//                     Expanded(
//                       child:
//                       DropdownButtonFormField<GetCustomerListModel>(
//                         isExpanded: true,
//                         decoration: buildInputBorderUpdateStatus("ALL", context),
//                         value: _selectedItemModel,
//                         items: [
//                           DropdownMenuItem<GetCustomerListModel>(
//                             value: allItem,
//                             child: Text(
//                               "ALL",
//                               style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                           ),
//                           DropdownMenuItem<GetCustomerListModel>(
//                             value: top5Item,
//                             child: Text(
//                               "Top 5",
//                               style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                           ),
//                           DropdownMenuItem<GetCustomerListModel>(
//                             value: oldestItem,
//                             child: Text(
//                               "Oldest",
//                               style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                               textScaler: TextScaler.noScaling,
//                             ),
//                           ),
//                           ...customerModel.map((GetCustomerListModel item) {
//                             return DropdownMenuItem<GetCustomerListModel>(
//                               value: item,
//                               child: Text(
//                                 item.customerName ?? '',
//                                 style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                                 textScaler: TextScaler.noScaling,
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                         onChanged: (GetCustomerListModel? selectedItem) {
//                           if (selectedItem != null) {
//                             setState(() {
//                               _selectedItemModel = selectedItem;
//
//                               if (selectedItem.customerId == -1) {
//                                 _selectedItem = "ALL";
//                                 selectedItemId = -1;
//                                 getCreditSaleLedgerDtls(0);
//                                 // Fetch all data
//                               } else if (selectedItem.customerId == -2) {
//                                 _selectedItem = "Top 5 outstanding";
//                                 selectedItemId = -2;
//                                 getTopFiveCreditors(0);  // Your function to get top 5
//                               } else if (selectedItem.customerId == -3) {
//                                 _selectedItem = "Oldest by day's";
//                                 selectedItemId = -3;
//                                 showOldestRecords();       // Function to get oldest 5 by date
//                               } else {
//                                 _selectedItem = selectedItem.customerName!;
//                                 selectedItemId = selectedItem.customerId?.toInt();
//                                 getCreditSaleLedgerDtls(selectedItemId!);  // Fetch for selected customer
//                               }
//                             });
//                           }
//                         },
//                         hint: Text(
//                           'ALL',
//                           textScaler: TextScaler.noScaling,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     Expanded(
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : currentList.isNotEmpty
//           ? ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         itemCount: currentList.length,
//         itemBuilder: (context, index) {
//           final isTopFive = _selectedItem == "Top 5 outstanding";
//
//           final collRcptDate = isTopFive
//               ? (currentList[index] as GetTopFiveCreditorsModel?)?.collRcptDate
//               : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.collRcptDate;
//
//           final customerName = isTopFive
//               ? (currentList[index] as GetTopFiveCreditorsModel?)?.customerName
//               : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.customerName;
//
//           final totalOutstanding = isTopFive
//               ? (currentList[index] as GetTopFiveCreditorsModel?)?.totalOutstanding
//               : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.totalOutstanding;
//
//           final pendingSinceDays = isTopFive
//               ? (currentList[index] as GetTopFiveCreditorsModel?)?.pendingSinceDays
//               : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.pendingSinceDays;
//
//           final customerType = isTopFive
//               ? (currentList[index] as GetTopFiveCreditorsModel?)?.customerType
//               : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.customerType;
//
//           return Card(
//             elevation: 2.0,
//             margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 0,
//                         child: countTextWidgetTextWithoutHeading(
//                           context,
//                           DateFormat('dd-MM-yyyy').format(
//                             DateTime.tryParse(collRcptDate ?? '') ?? DateTime.now(),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 0,
//                         child: countTextWidgetTextWithoutHeading(
//                           context,
//                           nullToDash(customerName),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                   Row(children: [
//                     Text(
//                       "Total Outstanding Bal.",
//                       style: Styling.itemGreyText,
//                       maxLines: 2,
//                       textScaler: TextScaler.noScaling,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     // Text(
//                     //   ": ${nullToDash(
//                     //     totalOutstanding == null
//                     //         ? null
//                     //         : totalOutstanding! % 1 == 0
//                     //         ? totalOutstanding.toStringAsFixed(0)
//                     //         : totalOutstanding.toString(),
//                     //   )}",
//                     //   style: Styling.itemBlackTest,
//                     //   textScaler: TextScaler.noScaling,
//                     // ),
//                     Text(
//                       ": ${nullToDash(
//                         totalOutstanding == null
//                             ? null
//                             : formatCurrency(totalOutstanding.toDouble()),
//                       )}",
//                       style: Styling.itemBlackTest,
//                       textScaler: TextScaler.noScaling,
//                     ),
//                   ]),
//                   const SizedBox(height: 2),
//                   Row(children: [
//                     Text(
//                       "Pending Since No. of Days",
//                       style: Styling.itemGreyText,
//                       maxLines: 2,
//                       textScaler: TextScaler.noScaling,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(
//                       width: 100,
//                       child: Text(
//                         "  : ${nullToDash(pendingSinceDays?.toStringAsFixed(0))}",
//                         style: Styling.itemBlackTest,
//                         textScaler: TextScaler.noScaling,
//                       ),
//                     ),
//                   ]),
//                   const SizedBox(height: 2),
//                   Row(children: [
//                     Text(
//                       "Customer Type",
//                       style: Styling.itemGreyText,
//                       maxLines: 2,
//                       textScaler: TextScaler.noScaling,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(
//                       width: 100,
//                       child: Text(
//                         "  : ${nullToDash(customerType)}",
//                         style: Styling.itemBlackTest,
//                         textScaler: TextScaler.noScaling,
//                       ),
//                     ),
//                   ]),
//                   if(_selectedItem != "Top 5 outstanding")...[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         flex: 0,
//                         child: countTextWidgetTextWithoutHeadingGrey(
//                           context,
//                           "Pay Now",
//                         ),
//                       ),
//                     ],
//                   ),
//                  ],
//                 ],
//               ),
//             ),
//           );
//         },
//       )
//           : const Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.search_off, size: 40, color: Colors.grey),
//               SizedBox(height: 8),
//               Text(
//                 'No Records Found',
//                 style: TextStyle(color: Colors.grey),
//                 textScaler: TextScaler.noScaling,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//    ],
//    ),
//   ),
//   );
//   }
//
//   Future<void> getCreditSaleLedgerDtls(int consumorId) async {
//     setState(() {
//       isLoading = true; // Show loading indicator
//     });
//
//     try {
//       Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
//
//       if (!Constants.isNetworkAvailable) {
//         showFlushBar(context, Constants.connectionMessage);
//         setState(() {
//           isLoading = false; // Hide loading indicator
//         });
//         return;
//       }
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token is missing. Please log in again.');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//
//       debugPrint("GetCreditSaleLedgerDtls: ${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId");
//       debugPrint("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => GetCreditSaleLedgerDtlsListModel.fromJson(json)).toList();
//           displayList = _items;
//           isLoading = false; // Hide loading indicator after data is fetched
//         });
//
//         _calculateTotalAmount();
//       } else {
//         throw Exception('Unable to load data at this time. Please try again later.');
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() {
//         isLoading = false; // Hide loading indicator if there's an error
//       });
//       showFlushBar(context, 'An error occurred. Please try again.');
//     }
//   }
//
//   Future<void> getTopFiveCreditors(int customerId) async {
//     setState(() {
//       isLoading = true; // Show loading indicator
//     });
//
//     try {
//       Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
//
//       if (!Constants.isNetworkAvailable) {
//         showFlushBar(context, Constants.connectionMessage);
//         setState(() {
//           isLoading = false; // Hide loading indicator
//         });
//         return;
//       }
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token is missing. Please log in again.');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//
//       debugPrint("GetTopFiveCreditors: ${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId");
//       debugPrint("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _topFiveItems = data.map((json) => GetTopFiveCreditorsModel.fromJson(json)).toList();
//           topFivedisplayList = _topFiveItems;
//           isLoading = false; // Hide loading indicator after data is fetched
//         });
//
//
//         _calculateTotalAmount();
//       } else {
//         throw Exception('Unable to load data at this time. Please try again later.');
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() {
//         isLoading = false; // Hide loading indicator if there's an error
//       });
//       showFlushBar(context, 'An error occurred. Please try again.');
//     }
//   }
//
//   Future<void> getCustomerList() async {
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
//       Uri.parse('${AppUrl.GetCustomerList}/$distributorId/1'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetCustomerListModel : " +
//         '${AppUrl.GetCustomerList}/$distributorId/1');
//     debugPrint("GetCustomerList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         customerModel = data.map((json) {
//           return GetCustomerListModel.fromJson(json);
//         }).toList();
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   String formatCurrency(double amount) {
//     if (amount == 0) {
//       return '0.00';
//     }
//     final format = NumberFormat('#,##,###.00', 'en_IN');
//
//     String formattedAmount = format.format(amount);
//
//     if (amount < 1 && formattedAmount.startsWith('.')) {
//       formattedAmount = '0' + formattedAmount;
//     }
//     return formattedAmount;
//   }
//
//   void _calculateTotalAmount() {
//     print("Items: $displayList");
//     totalOutstandingAmount = displayList.fold(
//       0.0,
//           (sum, report) {
//             double pendingDays = (report.totalOutstanding ?? 0.0).toDouble();
//         return sum! + pendingDays;
//       },
//     );
//     totalOutstandingAmountForFive = topFivedisplayList.fold(
//       0.0,
//           (sum, report) {
//         double pendingDays = (report.totalOutstanding ?? 0.0).toDouble();
//         return sum! + pendingDays;
//       },
//     );
//     print("Total Amount: $totalOutstandingAmount");
//     print("totalOutstandingAmountForFive: $totalOutstandingAmountForFive");
//
//   }
//   // void showTop5ByOutstanding() {
//   //   // Step 1: Sort descending by totalOutstanding
//   //   List<GetCreditSaleLedgerDtlsListModel> sortedList = List.from(_items);
//   //   sortedList.sort((a, b) => (b.totalOutstanding ?? 0).compareTo(a.totalOutstanding ?? 0));
//   //
//   //   // Step 2: Take top 5 (or fewer if list is small)
//   //   List<GetCreditSaleLedgerDtlsListModel> top5 = sortedList.take(5).toList();
//   //
//   //   // Step 3: Use these top 5 items (for example, print or update UI)
//   //   for (var item in top5) {
//   //     print('Customer: ${item.customerName}, Outstanding: ${item.totalOutstanding}');
//   //   }
//   //
//   //   // You can also update state here to show the list in UI
//   //   setState(() {
//   //     _items = top5;
//   //   });
//   // }
//   void showTop5ByOutstanding() {
//     List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
//     sorted.sort((a, b) => (b.totalOutstanding ?? 0).compareTo(a.totalOutstanding ?? 0));
//     setState(() {
//       displayList = sorted.take(5).toList();
//       _calculateTotalAmount();
//     });
//   }
//
//   void showOldestRecords() {
//     List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
//     sorted.sort((a, b) {
//       // Parse date strings or handle nulls
//       DateTime dateA = a.collRcptDate != null
//           ? DateTime.tryParse(a.collRcptDate!) ?? DateTime(1970)
//           : DateTime(1970);
//       DateTime dateB = b.collRcptDate != null
//           ? DateTime.tryParse(b.collRcptDate!) ?? DateTime(1970)
//           : DateTime(1970);
//       return dateA.compareTo(dateB);
//     });
//     setState(() {
//       displayList = sorted;
//       _calculateTotalAmount();
//     });
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

import '../../ConstantScreen/widgets.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/BoxShadow/section_header.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/GetCreditSaleLedgerDtlsListModel.dart';
import '../ClickModelClass/GetTopFiveCreditorsModel.dart';
import '../PaymentReceiptScreen/GetCustomerListModel.dart';


// =============================================================================
// CreditSaleCountDetailListUI
// Refactored to match the dashboard design system:
//   • Gradient AppBar with KPI badge
//   • Themed filter bar with pill-style dropdown
//   • Dashboard-style ledger item cards (left-border accent + stagger animation)
//   • Consistent AppColors, AppTypography, AppSpacing, SectionHeader
// =============================================================================

class CreditSaleCountDetailListUI extends StatefulWidget {
  static const screenName = '/creditSaleCountDetailListUI';

  @override
  State<StatefulWidget> createState() => _CreditSaleCountDetailListUIState();
}

class _CreditSaleCountDetailListUIState
    extends State<CreditSaleCountDetailListUI> {
  // ── State ──────────────────────────────────────────────────────────────────
  String? formattedDate;
  bool isLoading = true;

  List<GetCreditSaleLedgerDtlsListModel> _items = [];
  List<GetTopFiveCreditorsModel> _topFiveItems = [];
  List<GetCreditSaleLedgerDtlsListModel> displayList = [];
  List<GetTopFiveCreditorsModel> topFivedisplayList = [];
  List<GetCustomerListModel> customerModel = [];

  GetCustomerListModel? _selectedItemModel;
  final GetCustomerListModel allItem =
  GetCustomerListModel(customerId: -1, customerName: "ALL");
  final top5Item =
  GetCustomerListModel(customerId: -2, customerName: 'Top 5');
  final oldestItem =
  GetCustomerListModel(customerId: -3, customerName: 'Oldest');

  String? _selectedItem;
  int? selectedItemId;
  double? totalOutstandingAmount;
  double? totalOutstandingAmountForFive;
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
    _selectedItemModel = allItem;
    getCreditSaleLedgerDtls(0);
    getTopFiveCreditors(0);
    getCustomerList();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    addItem();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") return "-";
    return value;
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

  String get _shortTotalLabel {
    final amount = _selectedItem == "Top 5 outstanding"
        ? (totalOutstandingAmountForFive ?? 0.0)
        : (totalOutstandingAmount ?? 0.0);
    return '₹${formatCurrency(amount)}';
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    final currentList = (_selectedItem == "Top 5 outstanding")
        ? topFivedisplayList
        : displayList;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        // appBar: _buildAppBar(argLRAdd),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppGradientHeader(
            title: 'Credit Sale Ledger',
            subtitle: _selectedItem != null
                ?  '$_selectedItem'
                : 'All Customers',
            icon: Icons.receipt_long_rounded,
            // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
            onBack: () => Navigator.pop(context)
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Filter bar ──────────────────────────────────────────
            _buildFilterBar(),

            // ── Section header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SectionHeader(
                title: _selectedItem == "Top 5 outstanding"
                    ? 'Top 5 Outstanding'
                    : _selectedItem == "Oldest by day's"
                    ? 'Oldest Records'
                    : 'Credit Ledger',
                dotColor: AppColors.orange,
              ),
            ),

            // ── List ────────────────────────────────────────────────
            Expanded(child: _buildBody(currentList)),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(dynamic argLRAdd) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradPrimary),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pushNamed(
                      context, BottomNavBarExample.screenName),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit Sale Ledger',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      Text(
                        _selectedItem != null
                            ?  '$_selectedItem'
                            : 'All Customers',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                // ── Total outstanding KPI badge ─────────────────────
                _KpiBadge(
                  icon: Icons.account_balance_wallet_rounded,
                  label: _shortTotalLabel,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter bar ─────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_search_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Customer',
                  style: AppTypography.labelMD
                      .copyWith(color: AppColors.primary),
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowCard,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<GetCustomerListModel>(
                  isExpanded: true,
                  value: _selectedItemModel,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary, size: 22),
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  items: [
                    _dropdownItem(allItem, "ALL"),
                    _dropdownItem(top5Item, "Top 5"),
                    _dropdownItem(oldestItem, "Oldest"),
                    ...customerModel.map((item) =>
                        _dropdownItem(item, item.customerName ?? '')),
                  ],
                  onChanged: (GetCustomerListModel? selectedItem) {
                    if (selectedItem != null) {
                      setState(() {
                        _selectedItemModel = selectedItem;
                        if (selectedItem.customerId == -1) {
                          _selectedItem = "ALL";
                          selectedItemId = -1;
                          getCreditSaleLedgerDtls(0);
                        } else if (selectedItem.customerId == -2) {
                          _selectedItem = "Top 5 outstanding";
                          selectedItemId = -2;
                          getTopFiveCreditors(0);
                        } else if (selectedItem.customerId == -3) {
                          _selectedItem = "Oldest by day's";
                          selectedItemId = -3;
                          showOldestRecords();
                        } else {
                          _selectedItem = selectedItem.customerName!;
                          selectedItemId =
                              selectedItem.customerId?.toInt();
                          getCreditSaleLedgerDtls(selectedItemId!);
                        }
                      });
                    }
                  },
                  hint: Text(
                    'ALL',
                    style: AppTypography.labelMD,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<GetCustomerListModel> _dropdownItem(
      GetCustomerListModel item, String label) {
    return DropdownMenuItem<GetCustomerListModel>(
      value: item,
      child: Text(
        label,
        style: AppTypography.cardTitle.copyWith(fontSize: 14),
        textScaler: TextScaler.noScaling,
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody(List currentList) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (currentList.isEmpty) {
      return _EmptyState(
        icon: Icons.receipt_long_rounded,
        message: 'No credit sale records found\nfor the selected filter.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final isTopFive = _selectedItem == "Top 5 outstanding";

        final collRcptDate = isTopFive
            ? (currentList[index] as GetTopFiveCreditorsModel?)
            ?.collRcptDate
            : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)
            ?.collRcptDate;

        final customerName = isTopFive
            ? (currentList[index] as GetTopFiveCreditorsModel?)
            ?.customerName
            : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)
            ?.customerName;

        final totalOutstanding = isTopFive
            ? (currentList[index] as GetTopFiveCreditorsModel?)
            ?.totalOutstanding
            : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)
            ?.totalOutstanding;

        final pendingSinceDays = isTopFive
            ? (currentList[index] as GetTopFiveCreditorsModel?)
            ?.pendingSinceDays
            : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)
            ?.pendingSinceDays;

        final customerType = isTopFive
            ? (currentList[index] as GetTopFiveCreditorsModel?)
            ?.customerType
            : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)
            ?.customerType;

        final parsedDate = DateTime.tryParse(collRcptDate ?? '') ??
            DateTime.now();
        final formattedDate =
        DateFormat('dd MMM yyyy').format(parsedDate);

        // Accent color cycles across cards
        final accentColors = [
          AppColors.primary,
          AppColors.teal,
          AppColors.orange,
          AppColors.red,
          const Color(0xFF6e69e2),
        ];
        final accent = accentColors[index % accentColors.length];
        final accentBg = accent.withOpacity(0.08);

        // Urgency severity: > 60 days = red, > 30 = orange, else teal
        final days = (pendingSinceDays ?? 0).toInt();
        final urgencyColor = days > 60
            ? AppColors.red
            : days > 30
            ? AppColors.orange
            : AppColors.teal;
        final urgencyBg = days > 60
            ? AppColors.redXLight
            : days > 30
            ? AppColors.orangeXLight
            : AppColors.tealXLight;

        return _LedgerItemCard(
          index: index,
          accentColor: accent,
          accentBg: accentBg,
          formattedDate: formattedDate,
          customerName: nullToDash(customerName),
          totalOutstanding: totalOutstanding != null
              ? formatCurrency(totalOutstanding.toDouble())
              : '—',
          pendingDays: nullToDash(pendingSinceDays?.toStringAsFixed(0)),
          customerType: nullToDash(customerType),
          urgencyColor: urgencyColor,
          urgencyBg: urgencyBg,
          showPayNow: !isTopFive,
        );
      },
    );
  }

  // ── API calls (UNCHANGED) ──────────────────────────────────────────────────
  Future<void> getCreditSaleLedgerDtls(int consumorId) async {
    setState(() => isLoading = true);
    try {
      Constants.isNetworkAvailable =
      await InternetConnectionChecker().hasConnection;
      if (!Constants.isNetworkAvailable) {
        showFlushBar(context, Constants.connectionMessage);
        setState(() => isLoading = false);
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) {
        throw Exception('Bearer Token is missing. Please log in again.');
      }
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          "GetCreditSaleLedgerDtls: ${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId");
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data
              .map((json) =>
              GetCreditSaleLedgerDtlsListModel.fromJson(json))
              .toList();
          displayList = _items;
          isLoading = false;
        });
        _calculateTotalAmount();
      } else {
        throw Exception(
            'Unable to load data at this time. Please try again later.');
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
      showFlushBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> getTopFiveCreditors(int customerId) async {
    setState(() => isLoading = true);
    try {
      Constants.isNetworkAvailable =
      await InternetConnectionChecker().hasConnection;
      if (!Constants.isNetworkAvailable) {
        showFlushBar(context, Constants.connectionMessage);
        setState(() => isLoading = false);
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) {
        throw Exception('Bearer Token is missing. Please log in again.');
      }
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          "GetTopFiveCreditors: ${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId");
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _topFiveItems = data
              .map((json) =>
              GetTopFiveCreditorsModel.fromJson(json))
              .toList();
          topFivedisplayList = _topFiveItems;
          isLoading = false;
        });
        _calculateTotalAmount();
      } else {
        throw Exception(
            'Unable to load data at this time. Please try again later.');
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
      showFlushBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> getCustomerList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (bearerToken == null) throw Exception('Bearer token is missing');

    Map<String, dynamic> requestBody = {"DistributorId": distributorId};

    final response = await http.get(
      Uri.parse('${AppUrl.GetCustomerList}/$distributorId/1'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        "GetCustomerListModel : ${AppUrl.GetCustomerList}/$distributorId/1");
    debugPrint("GetCustomerList : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        customerModel = data
            .map((json) => GetCustomerListModel.fromJson(json))
            .toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  void _calculateTotalAmount() {
    totalOutstandingAmount = displayList.fold(0.0, (sum, report) {
      return sum! + (report.totalOutstanding ?? 0.0).toDouble();
    });
    totalOutstandingAmountForFive =
        topFivedisplayList.fold(0.0, (sum, report) {
          return sum! + (report.totalOutstanding ?? 0.0).toDouble();
        });
    debugPrint("Total Amount: $totalOutstandingAmount");
    debugPrint(
        "totalOutstandingAmountForFive: $totalOutstandingAmountForFive");
  }

  void showTop5ByOutstanding() {
    List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
    sorted.sort((a, b) =>
        (b.totalOutstanding ?? 0).compareTo(a.totalOutstanding ?? 0));
    setState(() {
      displayList = sorted.take(5).toList();
      _calculateTotalAmount();
    });
  }

  void showOldestRecords() {
    List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
    sorted.sort((a, b) {
      DateTime dateA = a.collRcptDate != null
          ? DateTime.tryParse(a.collRcptDate!) ?? DateTime(1970)
          : DateTime(1970);
      DateTime dateB = b.collRcptDate != null
          ? DateTime.tryParse(b.collRcptDate!) ?? DateTime(1970)
          : DateTime(1970);
      return dateA.compareTo(dateB);
    });
    setState(() {
      displayList = sorted;
      _calculateTotalAmount();
    });
  }
}

// =============================================================================
// _LedgerItemCard
// Dashboard-style card for each credit sale ledger entry.
//   • Left-border accent (cycles through dashboard palette)
//   • Pending days urgency badge (color-coded: red/orange/teal)
//   • Staggered slide+fade animation (matches AlertActionCard pattern)
//   • "Pay Now" chip shown only for non-Top-5 mode
// =============================================================================
class _LedgerItemCard extends StatefulWidget {
  const _LedgerItemCard({
    required this.index,
    required this.accentColor,
    required this.accentBg,
    required this.formattedDate,
    required this.customerName,
    required this.totalOutstanding,
    required this.pendingDays,
    required this.customerType,
    required this.urgencyColor,
    required this.urgencyBg,
    required this.showPayNow,
  });

  final int index;
  final Color accentColor;
  final Color accentBg;
  final String formattedDate;
  final String customerName;
  final String totalOutstanding;
  final String pendingDays;
  final String customerType;
  final Color urgencyColor;
  final Color urgencyBg;
  final bool showPayNow;

  @override
  State<_LedgerItemCard> createState() => _LedgerItemCardState();
}

class _LedgerItemCardState extends State<_LedgerItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(
        Duration(milliseconds: 55 * widget.index),
            () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child:
      SlideTransition(position: _slide, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
              left: BorderSide(color: widget.accentColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row: date + customer name ──────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.person_rounded,
                        color: widget.accentColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customerName,
                          style: AppTypography.cardTitle,
                          textScaler: TextScaler.noScaling,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 11,
                                color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              widget.formattedDate,
                              style: AppTypography.cardSubtitle
                                  .copyWith(fontSize: 11),
                              textScaler: TextScaler.noScaling,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Outstanding amount badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${widget.totalOutstanding}',
                        style: AppTypography.alertValue
                            .copyWith(color: widget.accentColor),
                        textScaler: TextScaler.noScaling,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Outstanding',
                        style: AppTypography.labelSM,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 10),

              // ── Info row: pending days + customer type ─────────
              Row(
                children: [
                  // Pending days urgency badge
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.hourglass_bottom_rounded,
                      label: 'Pending Days',
                      value: widget.pendingDays,
                      valueColor: widget.urgencyColor,
                      bgColor: widget.urgencyBg,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Customer type badge
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.business_center_rounded,
                      label: 'Customer Type',
                      value: widget.customerType,
                      valueColor: AppColors.primary,
                      bgColor: AppColors.primaryXLight,
                    ),
                  ),
                ],
              ),

              // ── Pay Now action (non-Top5 mode only) ───────────
              if (widget.showPayNow) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.teal,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.payments_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            'Pay Now',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _InfoChip
// Compact info pill used inside the ledger card for pending days
// and customer type — consistent icon + label + value layout.
// =============================================================================
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: valueColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSM,
                  textScaler: TextScaler.noScaling,
                ),
                Text(
                  value,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 13,
                    color: valueColor,
                  ),
                  textScaler: TextScaler.noScaling,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _KpiBadge
// Frosted-glass KPI pill in the AppBar showing total outstanding amount.
// Matches the pattern from ExpensesScreenUI and other dashboard screens.
// =============================================================================
class _KpiBadge extends StatelessWidget {
  const _KpiBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.white.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _EmptyState
// Shown when no ledger records are returned for the selected filter.
// Matches the empty state pattern used across dashboard screens.
// =============================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No Records Found',
              style: AppTypography.cardTitle,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: AppTypography.cardSubtitle,
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}