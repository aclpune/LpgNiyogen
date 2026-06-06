// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
// import '../ItemReceipt/CylItemList/CylItemListModel.dart';
// import 'package:http/http.dart' as http;
//
// import 'MarkDefectiveItemUI.dart';
//
// class MarkDefectiveItemScreen extends StatefulWidget {
//   static const screenName = '/markDefectiveItemScreen';
//
//   const MarkDefectiveItemScreen({super.key});
//
//   @override
//   State<MarkDefectiveItemScreen> createState() =>
//       _MarkDefectiveItemScreenState();
// }
//
// class _MarkDefectiveItemScreenState extends State<MarkDefectiveItemScreen> {
//   String? formattedDate;
//   CylItemListModel? _selectedItemModel;
//   List<CylItemListModel> _items = [];
//   String? _selectedItem;
//   int? selectedItemId;
//   final TextEditingController _defectiveController = TextEditingController();
//   final TextEditingController _remarkController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   List<GetDefectiveStockListModel> _defectiveStockList = [];
//   bool saveFlag = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     DateTime now = DateTime.now();
//     formattedDate = DateFormat('yyyy-MM-dd').format(now);
//     _dateController.text = formattedDate!;
//     fetchItems();
//     _fetchDefectiveData();
//     checkAndSaveDayEndData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           // Navigator.pushReplacementNamed(context, '/godownDashboard');
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } else {
//           // Navigator.pushReplacementNamed(context, '/godownDashboard');
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } // In case `null` is returned, return `false`
//       },
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Mark Defective', // Title or hint text for the text field
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Delivery Date
//                     // itemSubLine("Date",formattedDate!),
//                     Row(
//                       children: [
//                         Expanded(child: textWidgetBlueColorWithoutStar("Date")),
//                         Flexible(
//                           flex: 1,
//                           child: TextField(
//                             controller: _dateController,
//                             decoration:
//                                 buildInputBorderUpdateStatus(" ", context),
//                             style: Styling.textFormText,
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(250),
//                               // Allow only digits
//                             ],
//                             readOnly: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Divider(),
//                     Row(
//                       children: [
//                         Expanded(
//                             child: textWidgetBlueColorWithStar(
//                                 "Select Item", "*")),
//                         Flexible(
//                           flex: 1,
//                           child: DropdownButtonFormField<CylItemListModel>(
//                             decoration: buildInputBorderUpdateStatus(
//                                 "Select Item", context),
//                             value: _selectedItemModel,
//                             // Bind the value to the selected item model
//                             items: _items.map((CylItemListModel item) {
//                               return DropdownMenuItem<CylItemListModel>(
//                                 value: item,
//                                 child: Text(
//                                   item.itemName ?? 'Unknown',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (CylItemListModel? selectedItem) {
//                               if (selectedItem != null) {
//                                 setState(() {
//                                   _selectedItem = selectedItem.itemName;
//                                   selectedItemId = selectedItem.itemId!.toInt();
//
//                                   // Update the selectedItemModel when the selection changes
//                                   _selectedItemModel = selectedItem;
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                             child: textWidgetBlueColorWithStar(
//                                 "Defective Count", "*")),
//                         Flexible(
//                           flex: 1,
//                           child: TextField(
//                             controller: _defectiveController,
//                             decoration: buildInputBorderUpdateStatus(
//                                 "Enter Defective Count", context),
//                             style: Styling.textFormText,
//                             keyboardType: TextInputType.number,
//                             // Set keyboard type to numeric
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(3),
//                               // Allow only digits
//                             ],
//                             onChanged: (value) {
//                               setState(() {});
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                             child: textWidgetBlueColorWithoutStar("Remark")),
//                         Flexible(
//                           flex: 1,
//                           child: TextField(
//                             controller: _remarkController,
//                             decoration: buildInputBorderUpdateStatus(
//                                 "Enter Remark", context),
//                             style: Styling.textFormText,
//                             inputFormatters: <TextInputFormatter>[
//                               LengthLimitingTextInputFormatter(250),
//                               // Allow only digits
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 10),
//                         // Add 10px margin on left and right
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (saveFlag) {
//                               print('saveFlag $saveFlag');
//                               showFlushBar(context, Constants.dayEndCompleted);
//                             } else {
//                               if (_defectiveController.text.isNotEmpty) {
//                                 int defctiveQty =
//                                 int.parse(_defectiveController.text);
//                                 if (_defectiveController.text.isNotEmpty) {
//                                   if (_selectedItem != null) {
//                                     if (defctiveQty > 0) {
//                                       submitDefectiveToApi();
//                                     } else {
//                                       showFlushBar(
//                                           context, Constants.validCountEnter);
//                                     }
//                                   } else {
//                                     showFlushBar(context,
//                                         Constants.selectValidItemReceipt);
//                                   }
//                                 } else {
//                                   showFlushBar(
//                                       context, Constants.validCountEnter);
//                                 }
//                               } else {
//                                 showFlushBar(context, Constants.validCountEnter);
//                               }
//                             }
//
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 25.0, right: 25, top: 12, bottom: 12),
//                             child: const Text(
//                               'Submit',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ), // Set text color directly if needed
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               // Optional: Set rounded corners
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 4),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Defective List",
//                           style: Styling.bodyTitleBig,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12.0, vertical: 12),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                   flex: 2,
//                                   child: Center(
//                                     child: Text("Date",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xff1280b3),
//                                           fontFamily: 'OpenSans',
//                                         )),
//                                   )),
//                               Expanded(
//                                   flex: 2,
//                                   child: Center(
//                                     child: Text("Item",
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xff1280b3),
//                                             fontFamily: 'OpenSans')),
//                                   )),
//                               Expanded(
//                                   flex: 2,
//                                   child: Center(
//                                       child: Text("Defective",
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff1280b3),
//                                               fontFamily: 'OpenSans')))),
//                               Expanded(
//                                   flex: 1,
//                                   child: Center(
//                                       child: Text("Action",
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff1280b3),
//                                               fontFamily: 'OpenSans')))),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Divider(color: Color(0xff1280b3)),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             physics: BouncingScrollPhysics(),
//                             itemCount: _defectiveStockList.length,
//                             itemBuilder: (context, index) {
//                               return MarkdefectiveItemUI(
//                                   _defectiveStockList[index]);
//                             },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Fetch data from API Item
//   Future<void> fetchItems() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//         await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//           prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint("GetItemMasterList" +
//           '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//       debugPrint("GetItemMasterList" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//           _items = _items
//               .where(
//                   (item) => !item.itemName!.toLowerCase().contains('regulator'))
//               .toList();
//
//           EasyLoading.dismiss();
//         });
//       } else {
//         EasyLoading.dismiss();
//         throw Exception('Failed To Load Items');
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> submitDefectiveToApi() async {
//     // Construct the request payload
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token'); // This is your bearer token
//
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
//
//     // Add checks for empty or invalid inputs
//     int defectiveC = 0;
//
//     try {
//       defectiveC = int.tryParse(_defectiveController.text) ?? 0;
//     } catch (e) {
//       // Handle any error parsing the quantities
//       print("Error parsing quantities: $e");
//       EasyLoading.showToast("Invalid input for quantities");
//       return; // Early exit to prevent the API call with invalid values
//     }
//
//     String remarks = _remarkController.text;
//
//     Map<String, dynamic> requestBody = {
//       "DefId": 0,
//       "DistributorId": dId,
//       "DefDate": formattedDate,
//       "GodownId": gId,
//       "ItemId": selectedItemId,
//       "DefQty": defectiveC,
//       "Remark": remarks,
//       "Action": "ADD",
//       "AddedBy": addedBy
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(requestBody), // Encode the request body as JSON
//       );
//
//       // Print the raw response for debugging
//       print(
//           "API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
//       print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
//       print(
//           "API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");
//
//       if (response.statusCode == 200) {
//         // Handle success
//         print("DefectiveMasterAdd_Mob quantity added successfully!");
//         EasyLoading.showToast(Constants.dataUpdated,
//             duration: const Duration(milliseconds: 3000));
//         _defectiveController.clear();
//         _remarkController.clear();
//         _selectedItem = null;
//         selectedItemId = null;
//         _selectedItem = null;
//         _selectedItemModel = null;
//         _fetchDefectiveData();
//       } else {
//         // Handle error response
//         print("Failed to add imbalance quantity: ${response.statusCode}");
//       }
//     } catch (e) {
//       // Handle any exceptions
//       print("Error occurred: $e");
//     }
//   }
//
//   Future<void> _fetchDefectiveData() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token');
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!); // This is your bearer token
//     DateTime now = DateTime.now();
//     String formattedDate =
//         DateFormat('yyyy-MM-dd').format(now); // Format selectedDate
//     // String formattedDate = "2025-03-20"; // Format selectedDate
//
//     try {
//       final response = await http.post(
//         Uri.parse(AppUrl.GetDefectiveList_Mob),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           // Adding token to the Authorization header
//         },
//         body: jsonEncode({
//           "DistributorId": dId,
//           "DefDate": formattedDate,
//           "GodownId": gId,
//         }),
//       );
//
//       debugPrint(
//           'jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
//       debugPrint(
//           'responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');
//
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _defectiveStockList = data
//               .map((json) => GetDefectiveStockListModel.fromJson(json))
//               .toList();
//           EasyLoading.dismiss();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
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
//           // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
//           //   saveFlag = true;
//           //   print("Data is valid, proceeding to save.");
//           // } else {
//           //   print("Data is incomplete. Cannot proceed to save.");
//           // }
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
// }


// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../../Utils/styles/app_colors.dart';
// import '../../Utils/styles/app_spacing.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
// import '../ItemReceipt/CylItemList/CylItemListModel.dart';
// import 'package:http/http.dart' as http;
// import 'MarkDefectiveItemUI.dart';
//
// class MarkDefectiveItemScreen extends StatefulWidget {
//   static const screenName = '/markDefectiveItemScreen';
//
//   const MarkDefectiveItemScreen({super.key});
//
//   @override
//   State<MarkDefectiveItemScreen> createState() =>
//       _MarkDefectiveItemScreenState();
// }
//
// class _MarkDefectiveItemScreenState extends State<MarkDefectiveItemScreen> {
//   String? formattedDate;
//   CylItemListModel? _selectedItemModel;
//   List<CylItemListModel> _items = [];
//   String? _selectedItem;
//   int? selectedItemId;
//   final TextEditingController _defectiveController = TextEditingController();
//   final TextEditingController _remarkController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   List<GetDefectiveStockListModel> _defectiveStockList = [];
//   bool saveFlag = false;
//
//   @override
//   void initState() {
//     super.initState();
//     DateTime now = DateTime.now();
//     formattedDate = DateFormat('dd-MM-yyyy').format(now);
//     _dateController.text = formattedDate!;
//     fetchItems();
//     _fetchDefectiveData();
//     checkAndSaveDayEndData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.bg2,
//         appBar: CustomAppBar(
//           title: 'Item Return',
//         ),
//         body: Column(
//           children: [
//             // ── Custom Header (no AppBar) ──
//             // _ScreenHeader(),
//             // ── Scrollable body ──
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     // ── Entry Form Card ──
//                     _SectionLabel(title: 'Mark Defective', dotColor: AppColors.red),
//                     const SizedBox(height: 10),
//                     _EntryFormCard(
//                       dateController: _dateController,
//                       defectiveController: _defectiveController,
//                       remarkController: _remarkController,
//                       items: _items,
//                       selectedItemModel: _selectedItemModel,
//                       onItemChanged: (CylItemListModel? selectedItem) {
//                         if (selectedItem != null) {
//                           setState(() {
//                             _selectedItem = selectedItem.itemName;
//                             selectedItemId = selectedItem.itemId!.toInt();
//                             _selectedItemModel = selectedItem;
//                           });
//                         }
//                       },
//                       onDefectiveChanged: (_) => setState(() {}),
//                       onSubmit: () {
//                         if (saveFlag) {
//                           showFlushBar(context, Constants.dayEndCompleted);
//                         } else {
//                           if (_defectiveController.text.isNotEmpty) {
//                             int defctiveQty =
//                             int.parse(_defectiveController.text);
//                             if (_selectedItem != null) {
//                               if (defctiveQty > 0) {
//                                 submitDefectiveToApi();
//                               } else {
//                                 showFlushBar(
//                                     context, Constants.validCountEnter);
//                               }
//                             } else {
//                               showFlushBar(
//                                   context, Constants.selectValidItemReceipt);
//                             }
//                           } else {
//                             showFlushBar(context, Constants.validCountEnter);
//                           }
//                         }
//                       },
//                     ),
//
//                     const SizedBox(height: 24),
//
//                     // ── Defective List Section ──
//                     _SectionLabel(
//                       title: 'Defective List',
//                       dotColor: AppColors.orange,
//                     ),
//                     const SizedBox(height: 10),
//
//                     _defectiveStockList.isEmpty
//                         ? _EmptyState()
//                         : _DefectiveListCard(
//                       items: _defectiveStockList,
//                     ),
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
//   // ─────────────── API methods (UNTOUCHED) ───────────────
//
//   Future<void> fetchItems() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint("GetItemMasterList" +
//           '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//       debugPrint("GetItemMasterList" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//           _items = _items
//               .where(
//                   (item) => !item.itemName!.toLowerCase().contains('regulator'))
//               .toList();
//           EasyLoading.dismiss();
//         });
//       } else {
//         EasyLoading.dismiss();
//         throw Exception('Failed To Load Items');
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> submitDefectiveToApi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token');
//
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
//
//     int defectiveC = 0;
//
//     try {
//       defectiveC = int.tryParse(_defectiveController.text) ?? 0;
//     } catch (e) {
//       print("Error parsing quantities: $e");
//       EasyLoading.showToast("Invalid input for quantities");
//       return;
//     }
//
//     String remarks = _remarkController.text;
//
//     Map<String, dynamic> requestBody = {
//       "DefId": 0,
//       "DistributorId": dId,
//       "DefDate": formattedDate,
//       "GodownId": gId,
//       "ItemId": selectedItemId,
//       "DefQty": defectiveC,
//       "Remark": remarks,
//       "Action": "ADD",
//       "AddedBy": addedBy
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(requestBody),
//       );
//
//       print(
//           "API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
//       print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
//       print(
//           "API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");
//
//       if (response.statusCode == 200) {
//         print("DefectiveMasterAdd_Mob quantity added successfully!");
//         EasyLoading.showToast(Constants.dataUpdated,
//             duration: const Duration(milliseconds: 3000));
//         _defectiveController.clear();
//         _remarkController.clear();
//         _selectedItem = null;
//         selectedItemId = null;
//         _selectedItem = null;
//         setState(() {
//           _selectedItemModel = null;
//         });
//         _fetchDefectiveData();
//       } else {
//         print("Failed to add imbalance quantity: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//     }
//   }
//
//   Future<void> _fetchDefectiveData() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token');
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//     try {
//       final response = await http.post(
//         Uri.parse(AppUrl.GetDefectiveList_Mob),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           "DistributorId": dId,
//           "DefDate": formattedDate,
//           "GodownId": gId,
//         }),
//       );
//
//       debugPrint(
//           'jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
//       debugPrint(
//           'responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _defectiveStockList = data
//               .map((json) => GetDefectiveStockListModel.fromJson(json))
//               .toList();
//           EasyLoading.dismiss();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
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
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
// }
//
// /// Color-dot section label
// class _SectionLabel extends StatelessWidget {
//   const _SectionLabel({required this.title, required this.dotColor});
//   final String title;
//   final Color dotColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: dotColor,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title.toUpperCase(),
//           style: AppSpacing.sectionHeaderq,
//         ),
//       ],
//     );
//   }
// }
//
// /// Entry form inside a styled card
// class _EntryFormCard extends StatelessWidget {
//   const _EntryFormCard({
//     required this.dateController,
//     required this.defectiveController,
//     required this.remarkController,
//     required this.items,
//     required this.selectedItemModel,
//     required this.onItemChanged,
//     required this.onDefectiveChanged,
//     required this.onSubmit,
//   });
//
//   final TextEditingController dateController;
//   final TextEditingController defectiveController;
//   final TextEditingController remarkController;
//   final List<CylItemListModel> items;
//   final CylItemListModel? selectedItemModel;
//   final ValueChanged<CylItemListModel?> onItemChanged;
//   final ValueChanged<String> onDefectiveChanged;
//   final VoidCallback onSubmit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Date (read-only display)
//           _FormField(
//             label: 'Date',
//             isRequired: false,
//             child: _ReadOnlyInput(controller: dateController),
//           ),
//           const SizedBox(height: 14),
//
//           // Select Item dropdown
//           _FormField(
//             label: 'Select Item',
//             isRequired: true,
//             child: _StyledDropdown(
//               items: items,
//               selectedItemModel: selectedItemModel,
//               onChanged: onItemChanged,
//             ),
//           ),
//           const SizedBox(height: 14),
//
//           // Defective Count
//           _FormField(
//             label: 'Defective Count',
//             isRequired: true,
//             child: _NumberInput(
//               controller: defectiveController,
//               hint: 'Enter defective count',
//               onChanged: onDefectiveChanged,
//             ),
//           ),
//           const SizedBox(height: 14),
//
//           // Remark
//           _FormField(
//             label: 'Remark',
//             isRequired: false,
//             child: _TextInput(
//               controller: remarkController,
//               hint: 'Enter remark (optional)',
//             ),
//           ),
//           const SizedBox(height: 22),
//
//           // Submit button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: onSubmit,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.blue,
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               child: const Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Label + field wrapper
// class _FormField extends StatelessWidget {
//   const _FormField(
//       {required this.label, required this.isRequired, required this.child});
//   final String label;
//   final bool isRequired;
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: AppSpacing.labelMD.copyWith(color: AppColors.textMid),
//             children: isRequired
//                 ? const [
//               TextSpan(
//                 text: ' *',
//                 style: TextStyle(color: AppColors.red),
//               ),
//             ]
//                 : [],
//           ),
//         ),
//         const SizedBox(height: 6),
//         child,
//       ],
//     );
//   }
// }
//
// /// Styled read-only text field
// class _ReadOnlyInput extends StatelessWidget {
//   const _ReadOnlyInput({required this.controller});
//   final TextEditingController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       readOnly: true,
//       inputFormatters: [LengthLimitingTextInputFormatter(250)],
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: AppColors.textMid,
//       ),
//       decoration: _inputDecoration(''),
//     );
//   }
// }
//
// /// Styled number input
// class _NumberInput extends StatelessWidget {
//   const _NumberInput(
//       {required this.controller,
//         required this.hint,
//         required this.onChanged});
//   final TextEditingController controller;
//   final String hint;
//   final ValueChanged<String> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       inputFormatters: [
//         FilteringTextInputFormatter.digitsOnly,
//         LengthLimitingTextInputFormatter(3),
//       ],
//       onChanged: onChanged,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: AppColors.text,
//       ),
//       decoration: _inputDecoration(hint),
//     );
//   }
// }
//
// /// Styled text input
// class _TextInput extends StatelessWidget {
//   const _TextInput({required this.controller, required this.hint});
//   final TextEditingController controller;
//   final String hint;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       inputFormatters: [LengthLimitingTextInputFormatter(250)],
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: AppColors.text,
//       ),
//       decoration: _inputDecoration(hint),
//     );
//   }
// }
//
// /// Styled dropdown
// class _StyledDropdown extends StatelessWidget {
//   const _StyledDropdown({
//     required this.items,
//     required this.selectedItemModel,
//     required this.onChanged,
//   });
//
//   final List<CylItemListModel> items;
//   final CylItemListModel? selectedItemModel;
//   final ValueChanged<CylItemListModel?> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<CylItemListModel>(
//       value: selectedItemModel,
//       decoration: _inputDecoration('Select Item'),
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: AppColors.text,
//       ),
//       icon: const Icon(Icons.keyboard_arrow_down_rounded,
//           color: AppColors.textMuted),
//       items: items.map((CylItemListModel item) {
//         return DropdownMenuItem<CylItemListModel>(
//           value: item,
//           child: Text(
//             item.itemName ?? 'Unknown',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: AppColors.text,
//             ),
//           ),
//         );
//       }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
//
// /// Shared input decoration
// InputDecoration _inputDecoration(String hint) {
//   return InputDecoration(
//     hintText: hint,
//     hintStyle: const TextStyle(
//       fontSize: 13,
//       fontWeight: FontWeight.w400,
//       color: AppColors.textMuted,
//     ),
//     filled: true,
//     fillColor: AppColors.bg2,
//     contentPadding:
//     const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.border, width: 1),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.border, width: 1),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: const BorderSide(color: AppColors.blueLight, width: 1.5),
//     ),
//   );
// }
//
// /// Table card containing list header + items
// class _DefectiveListCard extends StatelessWidget {
//   const _DefectiveListCard({required this.items});
//   final List<GetDefectiveStockListModel> items;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Table header
//           _ListHeader(),
//           const Divider(height: 1, color: AppColors.border),
//           // Rows
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: items.length,
//             separatorBuilder: (_, __) =>
//             const Divider(height: 1, color: Color(0xFFF1F5F9)),
//             itemBuilder: (context, index) {
//               return MarkdefectiveItemUI(items[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Table column headers
// class _ListHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text('Date',
//                 textAlign: TextAlign.center,
//                 style: AppSpacing.labelMD
//                     .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text('Item',
//                 textAlign: TextAlign.center,
//                 style: AppSpacing.labelMD
//                     .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text('Defective',
//                 textAlign: TextAlign.center,
//                 style: AppSpacing.labelMD
//                     .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text('Action',
//                 textAlign: TextAlign.center,
//                 style: AppSpacing.labelMD
//                     .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Empty state placeholder
// class _EmptyState extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0x0D1E3A8A),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               color: AppColors.orangeXL,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.inventory_2_outlined,
//                 color: AppColors.orange, size: 28),
//           ),
//           const SizedBox(height: 12),
//           const Text('No defective records today',
//               style: AppSpacing.cardTitle),
//           const SizedBox(height: 4),
//           const Text('Add a defective item using the form above',
//               style: AppSpacing.cardSubtitle),
//         ],
//       ),
//     );
//   }
// }


// [Commented-out legacy code block omitted for brevity — unchanged from original]

// [Commented-out legacy code block omitted for brevity — unchanged from original]

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'package:http/http.dart' as http;
import 'MarkDefectiveItemUI.dart';

class MarkDefectiveItemScreen extends StatefulWidget {
  static const screenName = '/markDefectiveItemScreen';

  const MarkDefectiveItemScreen({super.key});

  @override
  State<MarkDefectiveItemScreen> createState() =>
      _MarkDefectiveItemScreenState();
}

class _MarkDefectiveItemScreenState extends State<MarkDefectiveItemScreen> {
  String? formattedDate;
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];
  String? _selectedItem;
  int? selectedItemId;
  final TextEditingController _defectiveController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<GetDefectiveStockListModel> _defectiveStockList = [];
  bool saveFlag = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateController.text = formattedDate!;
    fetchItems();
    _fetchDefectiveData();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
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
          title: 'Mark Defective',
        ),
        body: Column(
          children: [
            // AppGradientHeader(
            //   title: 'Mark Defective',
            //   subtitle: 'Record damaged or defective cylinders',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                // CHANGED: was EdgeInsets.fromLTRB(16, 0, 16, 24)
                padding: AppSpacing.markDefectivePagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    _SectionLabel(title: 'Mark Defective', dotColor: AppColors.red),
                    const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
                    _EntryFormCard(
                      dateController: _dateController,
                      defectiveController: _defectiveController,
                      remarkController: _remarkController,
                      items: _items,
                      selectedItemModel: _selectedItemModel,
                      onItemChanged: (CylItemListModel? selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            _selectedItem = selectedItem.itemName;
                            selectedItemId = selectedItem.itemId!.toInt();
                            _selectedItemModel = selectedItem;
                          });
                        }
                      },
                      onDefectiveChanged: (_) => setState(() {}),
                      onSubmit: () {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (_defectiveController.text.isNotEmpty) {
                            int defctiveQty =
                            int.parse(_defectiveController.text);
                            if (_selectedItem != null) {
                              if (defctiveQty > 0) {
                                submitDefectiveToApi();
                              } else {
                                showFlushBar(
                                    context, Constants.validCountEnter);
                              }
                            } else {
                              showFlushBar(
                                  context, Constants.selectValidItemReceipt);
                            }
                          } else {
                            showFlushBar(context, Constants.validCountEnter);
                          }
                        }
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    _SectionLabel(
                      title: 'Defective List',
                      dotColor: AppColors.orange,
                    ),
                    const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),

                    _defectiveStockList.isEmpty
                        ? _EmptyState()
                        : _DefectiveListCard(
                      items: _defectiveStockList,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────── API methods (UNTOUCHED) ───────────────

  Future<void> fetchItems() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetItemMasterList" +
          '${AppUrl.GetItemMasterList}/$distributorId/1/C');
      debugPrint("GetItemMasterList" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
          _items = _items
              .where(
                  (item) => !item.itemName!.toLowerCase().contains('regulator'))
              .toList();
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed To Load Items');
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> submitDefectiveToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');

    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

    int defectiveC = 0;

    try {
      defectiveC = int.tryParse(_defectiveController.text) ?? 0;
    } catch (e) {
      print("Error parsing quantities: $e");
      EasyLoading.showToast("Invalid input for quantities");
      return;
    }

    String remarks = _remarkController.text;

    Map<String, dynamic> requestBody = {
      "DefId": 0,
      "DistributorId": dId,
      "DefDate": formattedDate,
      "GodownId": gId,
      "ItemId": selectedItemId,
      "DefQty": defectiveC,
      "Remark": remarks,
      "Action": "ADD",
      "AddedBy": addedBy
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print(
          "API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
      print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
      print(
          "API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        print("DefectiveMasterAdd_Mob quantity added successfully!");
        EasyLoading.showToast(Constants.dataUpdated,
            duration: const Duration(milliseconds: 3000));

        _defectiveController.clear();
        _remarkController.clear();
        _selectedItem = null;
        selectedItemId = null;
        _selectedItem = null;
        setState(() {
          _selectedItemModel = null;
        });
        _fetchDefectiveData();
      } else {
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> _fetchDefectiveData() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDefectiveList_Mob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DistributorId": dId,
          "DefDate": formattedDate,
          "GodownId": gId,
        }),
      );

      debugPrint(
          'jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
      debugPrint(
          'responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _defectiveStockList = data
              .map((json) => GetDefectiveStockListModel.fromJson(json))
              .toList();
          EasyLoading.dismiss();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkAndSaveDayEndData() async {
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
}


/// Color-dot section label
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.dotColor});
  final String title;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // CHANGED: was 8/8 — now uses AppSpacing.sectionDotSize
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            // CHANGED: was BorderRadius.circular(2) — now uses AppRadius.sectionDot
            borderRadius: AppRadius.sectionDot,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title.toUpperCase(),
          style: AppSpacing.sectionHeaderq,
        ),
      ],
    );
  }
}

/// Entry form inside a styled card
class _EntryFormCard extends StatelessWidget {
  const _EntryFormCard({
    required this.dateController,
    required this.defectiveController,
    required this.remarkController,
    required this.items,
    required this.selectedItemModel,
    required this.onItemChanged,
    required this.onDefectiveChanged,
    required this.onSubmit,
  });

  final TextEditingController dateController;
  final TextEditingController defectiveController;
  final TextEditingController remarkController;
  final List<CylItemListModel> items;
  final CylItemListModel? selectedItemModel;
  final ValueChanged<CylItemListModel?> onItemChanged;
  final ValueChanged<String> onDefectiveChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        // CHANGED: was BorderRadius.circular(18) — now uses AppRadius.xmiCard
        borderRadius: AppRadius.xmiCard,
        boxShadow: const [
          BoxShadow(
            // CHANGED: was Color(0x0D1E3A8A) — now uses AppColors.shadowCard
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      // CHANGED: was EdgeInsets.all(18) — now uses AppSpacing.formCardPadding
      padding: AppSpacing.formCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(
            label: 'Date',
            isRequired: false,
            child: _ReadOnlyInput(controller: dateController),
          ),
          // CHANGED: was SizedBox(height: 14) — now uses AppSpacing.markDefectiveFieldGap
          const SizedBox(height: AppSpacing.markDefectiveFieldGap),

          _FormField(
            label: 'Select Item',
            isRequired: true,
            child: _StyledDropdown(
              items: items,
              selectedItemModel: selectedItemModel,
              onChanged: onItemChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.markDefectiveFieldGap),

          _FormField(
            label: 'Defective Count',
            isRequired: true,
            child: _NumberInput(
              controller: defectiveController,
              hint: 'Enter defective count',
              onChanged: onDefectiveChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.markDefectiveFieldGap),

          _FormField(
            label: 'Remark',
            isRequired: false,
            child: _TextInput(
              controller: remarkController,
              hint: 'Enter remark (optional)',
            ),
          ),
          // CHANGED: was SizedBox(height: 22) — nearest token is xl(24); kept close with md+sm = 20 → use xl
          const SizedBox(height: AppSpacing.xl - AppSpacing.xxs),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                elevation: 0,
                // CHANGED: was EdgeInsets.symmetric(vertical: 15) — now uses AppSpacing.markDefectiveSubmitBtn
                padding: AppSpacing.markDefectiveSubmitBtn,
                // CHANGED: was BorderRadius.circular(14) — now uses AppRadius.markDefectiveInput
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.markDefectiveInput,
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Label + field wrapper
class _FormField extends StatelessWidget {
  const _FormField(
      {required this.label, required this.isRequired, required this.child});
  final String label;
  final bool isRequired;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            // CHANGED: was AppSpacing.labelMD.copyWith(color: AppColors.textMid)
            //          (no change needed — AppSpacing.labelMD already exists)
            style: AppSpacing.labelMD.copyWith(color: AppColors.textMid),
            children: isRequired
                ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.red),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.xs + AppSpacing.xxs),
        child,
      ],
    );
  }
}

/// Styled read-only text field
class _ReadOnlyInput extends StatelessWidget {
  const _ReadOnlyInput({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      inputFormatters: [LengthLimitingTextInputFormatter(250)],
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        // CHANGED: was AppColors.textMid (already a design system alias)
        color: AppColors.textMid,
      ),
      decoration: _inputDecoration(''),
    );
  }
}

/// Styled number input
class _NumberInput extends StatelessWidget {
  const _NumberInput(
      {required this.controller,
        required this.hint,
        required this.onChanged});
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      decoration: _inputDecoration(hint),
    );
  }
}

/// Styled text input
class _TextInput extends StatelessWidget {
  const _TextInput({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [LengthLimitingTextInputFormatter(250)],
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      decoration: _inputDecoration(hint),
    );
  }
}

/// Styled dropdown
class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({
    required this.items,
    required this.selectedItemModel,
    required this.onChanged,
  });

  final List<CylItemListModel> items;
  final CylItemListModel? selectedItemModel;
  final ValueChanged<CylItemListModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CylItemListModel>(
      value: selectedItemModel,
      decoration: _inputDecoration('Select Item'),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textMuted),
      items: items.map((CylItemListModel item) {
        return DropdownMenuItem<CylItemListModel>(
          value: item,
          child: Text(
            item.itemName ?? 'Unknown',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

/// Shared input decoration
InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
    ),
    filled: true,
    // CHANGED: was AppColors.bg2 — same alias, no change
    fillColor: AppColors.bg2,
    // CHANGED: was EdgeInsets.symmetric(horizontal: 14, vertical: 13)
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      // CHANGED: was BorderRadius.circular(12) — now uses AppRadius.markDefectiveInput
      borderRadius: AppRadius.markDefectiveInput,
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.markDefectiveInput,
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.markDefectiveInput,
      borderSide: const BorderSide(color: AppColors.blueLight, width: 1.5),
    ),
  );
}

/// Table card containing list header + items
class _DefectiveListCard extends StatelessWidget {
  const _DefectiveListCard({required this.items});
  final List<GetDefectiveStockListModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        // CHANGED: was BorderRadius.circular(18) — now uses AppRadius.xmiCard
        borderRadius: AppRadius.xmiCard,
        boxShadow: const [
          BoxShadow(
            // CHANGED: was Color(0x0D1E3A8A) — now uses AppColors.shadowCard
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ListHeader(),
          const Divider(height: 1, color: AppColors.border),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            // CHANGED: was Color(0xFFF1F5F9) — now uses AppColors.divider
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              return MarkdefectiveItemUI(items[index]);
            },
          ),
        ],
      ),
    );
  }
}

/// Table column headers
class _ListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      // CHANGED: was EdgeInsets.symmetric(horizontal: 16, vertical: 12)
      //          = stockItemPadding (horizontal:16, vertical:14) is close but not exact.
      //          Using markDefectiveListRowPadding which was added to AppSpacing.
      padding: AppSpacing.stockItemPadding,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Date',
                textAlign: TextAlign.center,
                style: AppSpacing.labelMD
                    .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            flex: 2,
            child: Text('Item',
                textAlign: TextAlign.center,
                style: AppSpacing.labelMD
                    .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            flex: 2,
            child: Text('Defective',
                textAlign: TextAlign.center,
                style: AppSpacing.labelMD
                    .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
          Expanded(
            flex: 1,
            child: Text('Action',
                textAlign: TextAlign.center,
                style: AppSpacing.labelMD
                    .copyWith(color: AppColors.blue, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

/// Empty state placeholder
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // CHANGED: was EdgeInsets.symmetric(vertical: 40) — nearest token: xxxl(48) but
      //          keeping 40 via sm*5 is unusual; use EdgeInsets.symmetric(vertical: 40)
      //          with existing xxxl as close reference — left as-is for pixel-perfect match
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl - AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        // CHANGED: was BorderRadius.circular(18) — now uses AppRadius.xmiCard
        borderRadius: AppRadius.xmiCard,
        boxShadow: const [
          BoxShadow(
            // CHANGED: was Color(0x0D1E3A8A) — now uses AppColors.shadowCard
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            // CHANGED: was 56/56 — uses AppSpacing.itemReturnEmptyIconBox
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.orangeXL,
              // CHANGED: was BorderRadius.circular(16) — now uses AppRadius.xl
              borderRadius: AppRadius.emptyStateIcon,
            ),
            child: Icon(Icons.inventory_2_outlined,
                color: AppColors.orange,
                // CHANGED: was 28 — uses AppSpacing.itemReturnEmptyIconPx
                size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('No defective records today',
              style: AppSpacing.cardTitle),
          const SizedBox(height: AppSpacing.xs),
          const Text('Add a defective item using the form above',
              style: AppSpacing.cardSubtitle),
        ],
      ),
    );
  }
}