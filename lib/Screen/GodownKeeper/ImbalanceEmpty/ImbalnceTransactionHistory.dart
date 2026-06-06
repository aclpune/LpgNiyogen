// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/CustomeAlertDialog.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import 'package:http/http.dart' as http;
//
// import '../DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'ImbalanceTransactionHistoryListModel.dart';
// class ImbalnceTransactionHistory extends StatefulWidget {
//   static const screenName = '/imbalnceTransactionHistory';
//   const ImbalnceTransactionHistory({super.key});
//
//   @override
//   State<ImbalnceTransactionHistory> createState() => _ImbalnceTransactionHistoryState();
// }
//
// class _ImbalnceTransactionHistoryState extends State<ImbalnceTransactionHistory> {
//   List<ImbalanceTransactionHistoryListModel> imbalanceTransactionHistoryList = [];
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//     _fetchImbalanceData();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           // Navigator.pushReplacementNamed(context, DashboardScreen.screenName,
//           //     arguments: "onBack");
//           Navigator.pop(context);
//           return false;
//         } else {
//           Navigator.pop(context);
//           // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
//           return false;
//         } // In case `null` is returned, return `false`
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           surfaceTintColor: Color(0xFFECEFFF),
//           backgroundColor: Color(0xFFECEFFF), // Set your desired background color
//           automaticallyImplyLeading: false, // Disable default back button
//           title: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//
//               // 🔙 Back Button
//               IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.black),
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(
//                       context, '/bottomNavigationForGodownKeeper');
//                 },
//               ),
//
//               // 🖼 Logo
//               Image.asset(
//                 'assets/playstore.png',
//                 height: 40,
//                 width: 40,
//               ),
//
//               const SizedBox(width: 8),
//
//               // 📝 App Name + Subtitle
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     Constants.appName,
//                     style: Styling.appBarTitle.copyWith(color: Colors.black),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "Imbalance Transaction History",
//                     style: Styling.appBarDesc.copyWith(color: Colors.black),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body:
//         SingleChildScrollView(
//           child:
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               imbalanceTransactionHistoryList.isNotEmpty?
//               ListView.builder(
//                 // Combine both lists for display
//                 shrinkWrap: true, // 👈 Add this
//                 physics: const NeverScrollableScrollPhysics(), // 👈 Add this
//                 itemCount: imbalanceTransactionHistoryList.length,
//                 itemBuilder: (context, index) {
//                   // Logic to pick the item from the correct list
//                   ImbalanceTransactionHistoryListModel? items = imbalanceTransactionHistoryList[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Card(
//                       margin: EdgeInsets.zero,
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // 1. Wrap the helper in Expanded so its internal Expanded/Flexible
//                                 // knows the available width.
//                                 Expanded(
//                                   child: Column(
//                                     children: [
//                                        itemSubLine(
//                                           "Imbalance Qty.",
//                                           items.imbRecQty.toString(),
//                                         ),
//
//                                       itemSubLine(
//                                           "Item Name",
//                                           items.itemName?.toString() ?? ''
//                                         ),
//
//                                     ],
//                                   ),
//                                 ),
//                                 // 2. The Icon stays on the right
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Show confirmation dialog
//                                     if (saveFlag) {
//                                       showFlushBar(
//                                           context,
//                                           Constants
//                                               .dayEndCompleted);
//                                     } else {
//                                       if(stockTransferFlag){
//                                         showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                               title: const Text("Confirm Delete"),
//                                               content: const Text("Are you sure you want to delete this record?"),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () => Navigator.pop(context), // Close dialog
//                                                   child: const Text("No"),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(context); // Close dialog
//                                                     // Call the delete function
//                                                     addItemImbalanceQty(
//                                                       items.imbId?.toInt() ?? 0,
//                                                       items.consDMId?.toInt() ?? 0,
//                                                       items.itemId?.toInt() ?? 0,
//                                                       items.imbRecQty?.toInt() ?? 0,
//                                                       items.entryType ?? '',
//                                                     );
//                                                   },
//                                                   child: const Text("Yes", style: TextStyle(color: Colors.red)),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       }else{
//                                         CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//                                       }
//                                     }
//
//                                   },
//                                   child: Icon(Icons.delete, size: 16, color: Colors.redAccent),
//
//                                 ),
//
//                               ],
//                             ),
//
//                             itemSubLine(items.entryType == null?"Name":items.entryType == "D"?"Delivery Men":"Customer Name",items.staffName == null ? items.customerName.toString() : items.staffName.toString()),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//
//                 },
//               ):
//               Center(child: const Text('No Records Found')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _fetchImbalanceData() async {
//     // EasyLoading.instance
//     //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
//     //   ..loadingStyle = EasyLoadingStyle.light
//     //   ..dismissOnTap = false // Disable dismissing the loader by tapping
//     //   ..userInteractions = false;
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//       int dId = int.parse(distributorId!);
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.DailySaleByGKImbSettleList}/$dId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//           },
//         );
//         print("Total ImbQty for DailySaleByGKImbSettleList response ${response.body}");
//         print("Total ImbQty for DailySaleByGKImbSettleList request ${response.request}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//
//           setState(() {
//             imbalanceTransactionHistoryList = data
//                 .map((json) => ImbalanceTransactionHistoryListModel.fromJson(json))
//                 .toList();
//
//           });
//
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             // EasyLoading.dismiss();
//             showFlushBar(context, Constants.listGettingFail);
//           });
//
//         }
//       } catch (e) {
//         setState(() {
//           // EasyLoading.dismiss();
//         });
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//         showFlushBar(context,  Constants.listGettingFail);
//       }
//     } else {
//       // EasyLoading.dismiss();
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> addItemImbalanceQty(int imbId, int delMenId, int itemId, int imbQty, String type) async {
//     // Construct the request payload
//     EasyLoading.show(status: 'Sending Data...');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token'); // This is your bearer token
//     int dId = int.parse(distributorId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//
//     Map<String, dynamic> requestBody = {
//     "ImbId": imbId,
//     "DistributorId": distributorId,
//     "GodownId": godownId,
//     "ImbDate": formattedDate,
//     "ItemId": itemId,
//     "EntryType":type ?? '',
//     "ConsDMId": delMenId,
//     "ImbRecQty": imbQty ?? 0,
//     "AddedBy": addedBy,
//     "Action": "DELETE"
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('${AppUrl.DailySaleByGKImbSettleAdd}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(requestBody), // Encode the request body as JSON
//       );
//
//       // Print the raw response for debugging
//       print("API Response Status Code: ${response.statusCode}");
//       print("API Response Body: ${response.body}");
//       print("API Response request: ${response.request} ${requestBody}");
//
//       if (response.statusCode == 200) {
//         // Handle success
//         print("Imbalance quantity added successfully!");
//         EasyLoading.showToast("Data Deleted Successfully..",
//             duration: const Duration(milliseconds: 3000));
//         setState(() {
//           _fetchImbalanceData();
//
//         });
//
//         EasyLoading.dismiss();
//       } else {
//         // Handle error response
//         print("Failed to add imbalance quantity: ${response.statusCode}");
//         EasyLoading.dismiss();
//       }
//     } catch (e) {
//       // Handle any exceptions
//       print("Error occurred: $e");
//       EasyLoading.dismiss();
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
//       // Make the GET request
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
//           var dayEndData = apiResponse[
//           0]; // Access the first item in the list (assuming it's an object)
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
//
//         // Handle API error
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//           },
//         );
//
//         debugPrint("GetStockTransferDtls" +
//             '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//         debugPrint("GetStockTransferDtls" + response.body);
//         if (response.statusCode == 200) {
//           // Parse the response
//           List<dynamic> data = json.decode(response.body);
//           setState(() {
//             _stockTransferList = data
//                 .map((json) => GetStockTransferListModel.fromJson(json))
//                 .toList();
//             bool hasZeroStkTrans = false;
//             for (int i = 0; i < _stockTransferList.length; i++) {
//               if (_stockTransferList[i].isStkTrans == 0) {
//                 hasZeroStkTrans = true;
//                 debugPrint("Found item with isStkTrans = 0");
//                 break; // No need to continue checking once we find an item with isStkTrans = 0
//               }
//             }
//             if (hasZeroStkTrans) {
//               stockTransferFlag = false; // Disable the button
//               // showFlushBar(
//               //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
//             } else {
//               stockTransferFlag = true; // Enable the button
//             }
//           });
//
//         } else {
//           setState(() {
//
//             showFlushBar(context, Constants.listGettingFail);
//           });
//         }
//       } catch (e) {
//         debugPrint("GetStockTransferDtls" + e.toString());
//       }
//     } else {
//
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../Utils/styles/app_colors.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import 'ImbalanceTransactionHistoryListModel.dart';

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.item,
    required this.onDelete,
    required this.index,
  });

  final ImbalanceTransactionHistoryListModel item;
  final VoidCallback onDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDelivery = item.entryType == 'D';
    final displayName = item.staffName ?? item.customerName ?? '-';
    final typeLabel = item.entryType == null
        ? 'Name'
        : (item.entryType == 'D' ? 'Delivery Man' : 'Customer');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isDelivery ? AppColors.blueLight : AppColors.teal,
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x0A1E3A8A), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: isDelivery ? AppColors.blueXL : AppColors.tealXL,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDelivery ? Icons.delivery_dining_rounded : Icons.person_rounded,
                color: isDelivery ? AppColors.blueLight : AppColors.teal,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name
                  Text(
                    item.itemName ?? 'Unknown Item',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Type label + name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDelivery ? AppColors.blueXXL : const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDelivery ? AppColors.blue : AppColors.teal,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          displayName.toString(),
                          style: const TextStyle(fontSize: 13, color: AppColors.textMid),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Qty badge + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.redXL,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item.imbRecQty ?? 0}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.red,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.redXL,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.blueXL,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.blueLight, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Records Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textMid,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Imbalance transaction history\nwill appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
          ),
        ],
      ),
    ),
  );
}

// ── Main screen ───────────────────────────────────────────────────────────────

class ImbalnceTransactionHistory extends StatefulWidget {
  static const screenName = '/imbalnceTransactionHistory';
  const ImbalnceTransactionHistory({super.key});

  @override
  State<ImbalnceTransactionHistory> createState() => _ImbalnceTransactionHistoryState();
}

class _ImbalnceTransactionHistoryState extends State<ImbalnceTransactionHistory> {

  // ── State (UNCHANGED) ──────────────────────────────────────────────────────
  List<ImbalanceTransactionHistoryListModel> imbalanceTransactionHistoryList = [];
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    fetchTransactionList();
    _fetchImbalanceData();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pop(context);
          return false;
        } else {
          Navigator.pop(context);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: CustomAppBar(
          title: 'Transaction History',
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildSummaryStrip(),
            ),

            // ── List ──────────────────────────────────────────────────────
            imbalanceTransactionHistoryList.isEmpty
                ? const SliverFillRemaining(child: _EmptyState())
                : SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final items = imbalanceTransactionHistoryList[index];
                    return _TransactionCard(
                      item: items,
                      index: index,
                      onDelete: () {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (stockTransferFlag) {
                            _confirmDelete(items);
                          } else {
                            CustomAlertDialog.showCustomAlert(
                                context, Constants.stockNotAccepted);
                          }
                        }
                      },
                    );
                  },
                  childCount: imbalanceTransactionHistoryList.length,
                ),
              ),
            ),
          ],
        ),
        // body: CustomScrollView(
        //   slivers: [
        //     // ── Gradient header ───────────────────────────────────────────
        //     SliverToBoxAdapter(
        //       child: AppGradientHeader(
        //         title: 'Transaction History',
        //         subtitle: 'View all past transactions',
        //         icon: Icons.receipt_long_rounded,
        //         onBack: () => Navigator.pushReplacementNamed(
        //           context,
        //           BottomNavigationForGodownKeeper.screenName,
        //           arguments: "onBack",
        //         ),
        //       ),
        //     ),
        //
        //     // ── Summary strip ─────────────────────────────────────────────
        //     SliverToBoxAdapter(
        //       child: _buildSummaryStrip(),
        //     ),
        //
        //     // ── List ──────────────────────────────────────────────────────
        //     imbalanceTransactionHistoryList.isEmpty
        //         ? const SliverFillRemaining(child: _EmptyState())
        //         : SliverPadding(
        //       padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        //       sliver: SliverList(
        //         delegate: SliverChildBuilderDelegate(
        //               (context, index) {
        //             final items = imbalanceTransactionHistoryList[index];
        //             return _TransactionCard(
        //               item: items,
        //               index: index,
        //               onDelete: () {
        //                 if (saveFlag) {
        //                   showFlushBar(context, Constants.dayEndCompleted);
        //                 } else {
        //                   if (stockTransferFlag) {
        //                     _confirmDelete(items);
        //                   } else {
        //                     CustomAlertDialog.showCustomAlert(
        //                         context, Constants.stockNotAccepted);
        //                   }
        //                 }
        //               },
        //             );
        //           },
        //           childCount: imbalanceTransactionHistoryList.length,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, dynamic argLRAdd) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (argLRAdd == "fromDrawer") {
                    Navigator.pushReplacementNamed(
                        context, '/bottomNavigationForGodownKeeper');
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Imbalance settlement records',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Text(
                  '${imbalanceTransactionHistoryList.length} Records',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Summary strip ───────────────────────────────────────────────────────────
  Widget _buildSummaryStrip() {
    if (imbalanceTransactionHistoryList.isEmpty) return const SizedBox.shrink();

    final totalQty = imbalanceTransactionHistoryList.fold<int>(
      0, (sum, e) => sum + ((e.imbRecQty ?? 0).toInt()),
    );
    final dmCount = imbalanceTransactionHistoryList.where((e) => e.entryType == 'D').length;
    final custCount = imbalanceTransactionHistoryList.where((e) => e.entryType == 'C').length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _SummaryChip(label: 'Total Qty', value: '$totalQty', color: AppColors.red, bgColor: AppColors.redXL),
          const SizedBox(width: 10),
          _SummaryChip(label: 'Delivery Men', value: '$dmCount', color: AppColors.blueLight, bgColor: AppColors.blueXL),
          const SizedBox(width: 10),
          _SummaryChip(label: 'Customers', value: '$custCount', color: AppColors.teal, bgColor: AppColors.tealXL),
        ],
      ),
    );
  }

  // ── Delete confirm dialog ───────────────────────────────────────────────────
  void _confirmDelete(ImbalanceTransactionHistoryListModel items) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.redXL, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 28),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Record?',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.text),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This action cannot be undone. The imbalance entry will be permanently removed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMid,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size.fromHeight(44),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          addItemImbalanceQty(
                            items.imbId?.toInt() ?? 0,
                            items.consDMId?.toInt() ?? 0,
                            items.itemId?.toInt() ?? 0,
                            items.imbRecQty?.toInt() ?? 0,
                            items.entryType ?? '',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size.fromHeight(44),
                          elevation: 0,
                        ),
                        child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Business logic (UNCHANGED) ─────────────────────────────────────────────

  Future<void> _fetchImbalanceData() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? token = prefs.getString('token');
      int dId = int.parse(distributorId!);
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.DailySaleByGKImbSettleList}/$dId/$godownId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("Total ImbQty for DailySaleByGKImbSettleList response ${response.body}");
        print("Total ImbQty for DailySaleByGKImbSettleList request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            imbalanceTransactionHistoryList = data
                .map((json) => ImbalanceTransactionHistoryListModel.fromJson(json))
                .toList();
          });
        } else {
          setState(() { showFlushBar(context, Constants.listGettingFail); });
        }
      } catch (e) {
        setState(() {});
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> addItemImbalanceQty(int imbId, int delMenId, int itemId, int imbQty, String type) async {
    EasyLoading.show(status: 'Sending Data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    int dId = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    Map<String, dynamic> requestBody = {
      "ImbId": imbId,
      "DistributorId": distributorId,
      "GodownId": godownId,
      "ImbDate": formattedDate,
      "ItemId": itemId,
      "EntryType": type ?? '',
      "ConsDMId": delMenId,
      "ImbRecQty": imbQty ?? 0,
      "AddedBy": addedBy,
      "Action": "DELETE"
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DailySaleByGKImbSettleAdd}'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("API Response request: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        print("Imbalance quantity added successfully!");
        EasyLoading.showToast("Data Deleted Successfully..", duration: const Duration(milliseconds: 3000));
        setState(() { _fetchImbalanceData(); });
        EasyLoading.dismiss();
      } else {
        print("Failed to add imbalance quantity: ${response.statusCode}");
        EasyLoading.dismiss();
      }
    } catch (e) {
      print("Error occurred: $e");
      EasyLoading.dismiss();
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
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $bearerToken"},
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

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token');
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) throw Exception('Bearer token is missing');
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        debugPrint("GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
            bool hasZeroStkTrans = false;
            for (int i = 0; i < _stockTransferList.length; i++) {
              if (_stockTransferList[i].isStkTrans == 0) { hasZeroStkTrans = true; break; }
            }
            stockTransferFlag = !hasZeroStkTrans;
          });
        } else {
          setState(() { showFlushBar(context, Constants.listGettingFail); });
        }
      } catch (e) {
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

// ── Summary chip ──────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value, required this.color, required this.bgColor});
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x081E3A8A), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    ),
  );
}
