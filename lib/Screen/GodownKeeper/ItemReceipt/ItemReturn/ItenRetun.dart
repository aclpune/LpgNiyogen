//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/app_url.dart';
// import 'package:http/http.dart' as http;
// import '../../../Utils/constants.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../SQCRegister/SQCRegisterScreen.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'ItenReturnItemUi.dart';
// class ItemReturnScreen extends StatefulWidget {
//   static const screenName = '/itemReturnScreen';
//   const ItemReturnScreen({super.key});
//
//   @override
//   State<ItemReturnScreen> createState() => _ItemReturnScreenState();
// }
//
// class _ItemReturnScreenState extends State<ItemReturnScreen> {
//   List<GetItemReceiptListModel> receiptList = [];
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     fetchItemReceipts();
//   }
//   // Pull-to-refresh function to trigger data fetch
//   Future<void> _refresh() async {
//     await fetchItemReceipts();  // Call fetchItemReceipts to get updated data
//   }
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
//
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Item Return', // Title or hint text for the text field
//         ),
//           floatingActionButton: FloatingActionButton.extended(
//             backgroundColor: Colors.blue,
//             onPressed: () {
//               _showSQCBottomSheet(context);
//             },
//             icon: Icon(Icons.list),
//             label: Text(
//               "SQC",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         body: RefreshIndicator(
//           onRefresh: _refresh,
//           child: isLoading?
//           Center(child: CircularProgressIndicator()):
//           receiptList.isNotEmpty?
//           ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: receiptList.length,
//             itemBuilder: (context, index) {
//               return  ItemReturnScreenListItem(
//                   receiptList[index]);
//               //   Card(
//               //   margin: EdgeInsets.all(8.0),
//               //   child: ListTile(
//               //     title: Text("Veh No: ${item['vehicleNo']}"),
//               //     subtitle: Text("Return: ${item['return']}"),
//               //     trailing: ElevatedButton(
//               //       onPressed: () {
//               //         showDetailsDialog(context, item);
//               //       },
//               //       child: Text("Out"),
//               //     ),
//               //   ),
//               // );
//             },
//           ):
//               Container(
//                 child: Text("No Data Found..!",style: TextStyle(fontSize: 16),),
//               ),
//         )
//       ),
//     );
//   }
//   void _showSQCBottomSheet(BuildContext context) {
//
//     var vehiclesNotOut = receiptList
//         .where((v) => v.returnOn == "0001-01-01T00:00:00")
//         .toList();
//
//     if (vehiclesNotOut.isEmpty) {
//       showFlushBar(context, "All vehicles are already out.");
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           height: 350,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "SQC Vehicles",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Expanded(
//                 child:
//                 ListView.builder(
//                   itemCount: vehiclesNotOut.length,
//                   itemBuilder: (context, index) {
//                     var vehicle = vehiclesNotOut[index];
//
//                     // var item = (vehicle.itemDetails?.isNotEmpty ?? false)
//                     //     ? vehicle.itemDetails![0]
//                     //     : null;
//
//                     return ListTile(
//                         title: RichText(
//                           text: TextSpan(
//                             text: "Vehicle No: ",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: "${vehicle.vehicleNo}",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Text("Vehicle No: ${vehicle.vehicleNo}"),
//                         trailing: Icon(Icons.arrow_forward_ios, size: 16),
//                         // onTap: () {
//                         //   Navigator.pop(context);
//                         //   Navigator.pushNamed(
//                         //     context,
//                         //     SQCRegisterScreen.screenName,
//                         //     arguments: {
//                         //       'vehicleNo': vehicle.vehicleNo.toString(),
//                         //       'godownId': vehicle.godownId.toString(),
//                         //       // 'itemId': item != null ? item.itemId.toString() : "",
//                         //       // 'itemName': item != null ? item.itemName.toString() : "",
//                         //     },
//                         //   );
//                         // },
//
//                         onTap: () {
//                           Navigator.pop(context);
//
//                           // Prepare lists
//                           var itemIds = <String>[];
//                           var itemNames = <String>[];
//
//                           if (vehicle.itemDetails != null && vehicle.itemDetails!.isNotEmpty) {
//                             for (var item in vehicle.itemDetails!) {
//                               itemIds.add(item.itemId.toString());
//                               itemNames.add(item.itemName.toString());
//                             }
//                           }
//                           Navigator.pushNamed(
//                             context,
//                             SQCRegisterScreen.screenName,
//                             arguments: {
//                               'vehicleNo': vehicle.vehicleNo.toString(),
//                               'godownId': vehicle.godownId.toString(),
//                               'itemIds': itemIds,
//                               'itemNames': itemNames,
//                             },
//                           );
//                         }
//                       // onTap: () {
//                       //   Navigator.pop(context);
//                       //
//                       //   // Prepare lists of item IDs and names
//                       //   var itemIds = <String>[];
//                       //   var itemNames = <String>[];
//                       //
//                       //   if (vehicle.itemDetails != null && vehicle.itemDetails!.isNotEmpty) {
//                       //     for (var i in vehicle.itemDetails!) {
//                       //       itemIds.add(i.itemId.toString());
//                       //       itemNames.add(i.itemName.toString());
//                       //     }
//                       //   }
//                       //
//                       //   Navigator.pushNamed(
//                       //     context,
//                       //     SQCRegisterScreen.screenName,
//                       //     arguments: {
//                       //       'vehicleNo': vehicle.vehicleNo.toString(),
//                       //       'godownId': vehicle.godownId.toString(),
//                       //       'itemIds': itemIds,       // list of IDs
//                       //       'itemNames': itemNames,   // list of names
//                       //     },
//                       //   );
//                       // },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> fetchItemReceipts() async {
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
//           // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
//           Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status Code: ${response.statusCode}");
//         print("API Response Body: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data.map((json) => GetItemReceiptListModel.fromJson(json)).toList();
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
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
// }
//
//
//


//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/app_url.dart';
// import 'package:http/http.dart' as http;
// import '../../../Utils/constants.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../SQCRegister/SQCRegisterScreen.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'ItenReturnItemUi.dart';
//
// class ItemReturnScreen extends StatefulWidget {
//   static const screenName = '/itemReturnScreen';
//   const ItemReturnScreen({super.key});
//
//   @override
//   State<ItemReturnScreen> createState() => _ItemReturnScreenState();
// }
//
// class _ItemReturnScreenState extends State<ItemReturnScreen> {
//   List<GetItemReceiptListModel> receiptList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItemReceipts();
//   }
//
//   Future<void> _refresh() async {
//     await fetchItemReceipts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
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
//         backgroundColor: colorScheme.surfaceContainerHighest,
//         appBar: CustomAppBar(
//           title: 'Item Return',
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           elevation: 2,
//           onPressed: () {
//             _showSQCBottomSheet(context);
//           },
//           icon: const Icon(Icons.list_alt_rounded),
//           label: const Text(
//             'SQC',
//             style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
//           ),
//         ),
//         body: RefreshIndicator(
//           color: colorScheme.primary,
//           backgroundColor: colorScheme.surface,
//           onRefresh: _refresh,
//           child: isLoading
//               ? const _LoadingView()
//               : receiptList.isNotEmpty
//               ? ListView.builder(
//             physics: const BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics(),
//             ),
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 12),
//             itemCount: receiptList.length,
//             itemBuilder: (context, index) {
//               return ItemReturnScreenListItem(receiptList[index]);
//             },
//           )
//               : const _EmptyView(),
//         ),
//       ),
//     );
//   }
//
//   void _showSQCBottomSheet(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     var vehiclesNotOut = receiptList
//         .where((v) => v.returnOn == "0001-01-01T00:00:00")
//         .toList();
//
//     if (vehiclesNotOut.isEmpty) {
//       showFlushBar(context, "All vehicles are already out.");
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//           height: 380,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Drag handle
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 16, top: 8),
//                   decoration: BoxDecoration(
//                     color: colorScheme.outline,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: BoxDecoration(
//                       color: colorScheme.primary,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'SQC VEHICLES',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                       color: colorScheme.onSurfaceVariant,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: ListView.separated(
//                   itemCount: vehiclesNotOut.length,
//                   separatorBuilder: (_, __) => Divider(
//                     height: 1,
//                     color: colorScheme.outline,
//                   ),
//                   itemBuilder: (context, index) {
//                     var vehicle = vehiclesNotOut[index];
//                     return ListTile(
//                       contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                       leading: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           Icons.local_shipping_rounded,
//                           color: colorScheme.primary,
//                           size: 20,
//                         ),
//                       ),
//                       title: Text(
//                         'Vehicle No.',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: colorScheme.onSurfaceVariant,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                       subtitle: Text(
//                         vehicle.vehicleNo ?? '',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                           color: colorScheme.primary,
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.chevron_right_rounded,
//                         color: colorScheme.onSurfaceVariant,
//                         size: 22,
//                       ),
//                       onTap: () {
//                         Navigator.pop(context);
//                         var itemIds = <String>[];
//                         var itemNames = <String>[];
//                         if (vehicle.itemDetails != null &&
//                             vehicle.itemDetails!.isNotEmpty) {
//                           for (var item in vehicle.itemDetails!) {
//                             itemIds.add(item.itemId.toString());
//                             itemNames.add(item.itemName.toString());
//                           }
//                         }
//                         Navigator.pushNamed(
//                           context,
//                           SQCRegisterScreen.screenName,
//                           arguments: {
//                             'vehicleNo': vehicle.vehicleNo.toString(),
//                             'godownId': vehicle.godownId.toString(),
//                             'itemIds': itemIds,
//                             'itemNames': itemNames,
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> fetchItemReceipts() async {
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
//           Uri.parse(
//               '${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status Code: ${response.statusCode}");
//         print("API Response Body: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data
//                 .map((json) => GetItemReceiptListModel.fromJson(json))
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
// }
//
// // ── Loading placeholder ──
// class _LoadingView extends StatelessWidget {
//   const _LoadingView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CircularProgressIndicator(
//         color: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }
//
// // ── Empty state ──
// class _EmptyView extends StatelessWidget {
//   const _EmptyView();
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return ListView(
//       // Wrap in ListView so RefreshIndicator can scroll
//       children: [
//         SizedBox(height: MediaQuery.of(context).size.height * 0.25),
//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 child: Icon(
//                   Icons.inbox_rounded,
//                   size: 32,
//                   color: colorScheme.primary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'No Data Found',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 'Pull down to refresh',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../ConstantScreen/widgets.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/app_url.dart';
// import 'package:http/http.dart' as http;
// import '../../../Utils/constants.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../SQCRegister/SQCRegisterScreen.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'ItenReturnItemUi.dart';
//
// class ItemReturnScreen extends StatefulWidget {
//   static const screenName = '/itemReturnScreen';
//   const ItemReturnScreen({super.key});
//
//   @override
//   State<ItemReturnScreen> createState() => _ItemReturnScreenState();
// }
//
// class _ItemReturnScreenState extends State<ItemReturnScreen> {
//   List<GetItemReceiptListModel> receiptList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItemReceipts();
//   }
//
//   Future<void> _refresh() async {
//     await fetchItemReceipts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
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
//         backgroundColor: colorScheme.surfaceContainerHighest,
//         appBar: CustomAppBar(
//           title: 'Item Return',
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           elevation: 2,
//           onPressed: () {
//             _showSQCBottomSheet(context);
//           },
//           icon: const Icon(Icons.list_alt_rounded),
//           label: const Text(
//             'SQC',
//             style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
//           ),
//         ),
//         body: RefreshIndicator(
//           color: colorScheme.primary,
//           backgroundColor: colorScheme.surface,
//           onRefresh: _refresh,
//           child: isLoading
//               ? const _LoadingView()
//               : receiptList.isNotEmpty
//               ? ListView.builder(
//             physics: const BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics(),
//             ),
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 10),
//             itemCount: receiptList.length,
//             itemBuilder: (context, index) {
//               return ItemReturnScreenListItem(receiptList[index]);
//             },
//           )
//               : const _EmptyView(),
//         ),
//       ),
//     );
//   }
//
//   void _showSQCBottomSheet(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     var vehiclesNotOut = receiptList
//         .where((v) => v.returnOn == "0001-01-01T00:00:00")
//         .toList();
//
//     if (vehiclesNotOut.isEmpty) {
//       showFlushBar(context, "All vehicles are already out.");
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.75,
//           minChildSize: 0.4,
//           maxChildSize: 0.75,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: colorScheme.surface,
//                 borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Drag handle
//                   Center(
//                     child: Container(
//                       width: 36,
//                       height: 4,
//                       margin: const EdgeInsets.only(top: 10, bottom: 14),
//                       decoration: BoxDecoration(
//                         color: colorScheme.outline.withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   // Header
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 7,
//                           height: 7,
//                           decoration: BoxDecoration(
//                             color: colorScheme.primary,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'SQC VEHICLES',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: colorScheme.onSurfaceVariant,
//                             letterSpacing: 0.8,
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           '${vehiclesNotOut.length} pending',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                       height: 1,
//                       color: colorScheme.outline.withOpacity(0.3)),
//                   // List
//                   Expanded(
//                     child: ListView.separated(
//                       controller: scrollController,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       itemCount: vehiclesNotOut.length,
//                       separatorBuilder: (_, __) =>
//                       const SizedBox(height: 4),
//                       itemBuilder: (context, index) {
//                         var vehicle = vehiclesNotOut[index];
//                         return Material(
//                           color: colorScheme.primaryContainer
//                               .withOpacity(0.35),
//                           borderRadius: BorderRadius.circular(12),
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(12),
//                             onTap: () {
//                               Navigator.pop(context);
//                               var itemIds = <String>[];
//                               var itemNames = <String>[];
//                               if (vehicle.itemDetails != null &&
//                                   vehicle.itemDetails!.isNotEmpty) {
//                                 for (var item in vehicle.itemDetails!) {
//                                   itemIds.add(item.itemId.toString());
//                                   itemNames
//                                       .add(item.itemName.toString());
//                                 }
//                               }
//                               Navigator.pushNamed(
//                                 context,
//                                 SQCRegisterScreen.screenName,
//                                 arguments: {
//                                   'vehicleNo':
//                                   vehicle.vehicleNo.toString(),
//                                   'godownId':
//                                   vehicle.godownId.toString(),
//                                   'itemIds': itemIds,
//                                   'itemNames': itemNames,
//                                 },
//                               );
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 10),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 34,
//                                     height: 34,
//                                     decoration: BoxDecoration(
//                                       color:
//                                       colorScheme.primaryContainer,
//                                       borderRadius:
//                                       BorderRadius.circular(10),
//                                     ),
//                                     child: Icon(
//                                       Icons.local_shipping_rounded,
//                                       color: colorScheme.primary,
//                                       size: 17,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Vehicle No.',
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w600,
//                                             color: colorScheme
//                                                 .onSurfaceVariant,
//                                             letterSpacing: 0.3,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 1),
//                                         Text(
//                                           vehicle.vehicleNo ?? '',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w800,
//                                             color: colorScheme.primary,
//                                             letterSpacing: -0.2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.chevron_right_rounded,
//                                     color: colorScheme.onSurfaceVariant,
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> fetchItemReceipts() async {
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
//           Uri.parse(
//               '${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status Code: ${response.statusCode}");
//         print("API Response Body: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data
//                 .map((json) => GetItemReceiptListModel.fromJson(json))
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
// }
//
// // ── Loading placeholder ──
// class _LoadingView extends StatelessWidget {
//   const _LoadingView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CircularProgressIndicator(
//         color: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }
//
// // ── Empty state ──
// class _EmptyView extends StatelessWidget {
//   const _EmptyView();
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return ListView(
//       children: [
//         SizedBox(height: MediaQuery.of(context).size.height * 0.25),
//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Icon(
//                   Icons.inbox_rounded,
//                   size: 28,
//                   color: colorScheme.primary,
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 'No Data Found',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 'Pull down to refresh',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/Widget.dart';
// import '../../../Utils/app_url.dart';
// import 'package:http/http.dart' as http;
// import '../../../Utils/constants.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../SQCRegister/SQCRegisterScreen.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'ItenReturnItemUi.dart';
// // ── Design system ──
// import '../../../Utils/styles/app_colors.dart';
// import '../../../Utils/styles/app_spacing.dart';
// import '../../../Utils/styles/app_text_styles.dart';
//
// class ItemReturnScreen extends StatefulWidget {
//   static const screenName = '/itemReturnScreen';
//   const ItemReturnScreen({super.key});
//
//   @override
//   State<ItemReturnScreen> createState() => _ItemReturnScreenState();
// }
//
// class _ItemReturnScreenState extends State<ItemReturnScreen> {
//   List<GetItemReceiptListModel> receiptList = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchItemReceipts();
//   }
//
//   Future<void> _refresh() async {
//     await fetchItemReceipts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
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
//         backgroundColor: colorScheme.surfaceContainerHighest,
//         // appBar: CustomAppBar(
//         //   title: 'Item Return',
//         // ),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           elevation: 2,
//           onPressed: () {
//             _showSQCBottomSheet(context);
//           },
//           icon: const Icon(Icons.list_alt_rounded),
//           label: const Text(
//             'SQC',
//             // ── was: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5)
//             style: AppTextStyles.itemReturnFabLabel,
//           ),
//         ),
//         // body: RefreshIndicator(
//         //   color: colorScheme.primary,
//         //   backgroundColor: colorScheme.surface,
//         //   onRefresh: _refresh,
//         //   child: isLoading
//         //       ? const _LoadingView()
//         //       : receiptList.isNotEmpty
//         //       ? ListView.builder(
//         //     physics: const BouncingScrollPhysics(
//         //       parent: AlwaysScrollableScrollPhysics(),
//         //     ),
//         //     // ── was: EdgeInsets.symmetric(horizontal: 12, vertical: 10)
//         //     padding: AppSpacing.itemReturnListPadding,
//         //     itemCount: receiptList.length,
//         //     itemBuilder: (context, index) {
//         //       return ItemReturnScreenListItem(receiptList[index]);
//         //     },
//         //   )
//         //       : const _EmptyView(),
//         // ),
//         body: Column(
//           children: [
//             AppGradientHeader(
//               title: 'Item Return',
//               subtitle: 'Track returned item details',
//               icon: Icons.receipt_long_rounded,
//               onBack: () => Navigator.pushReplacementNamed(
//                 context,
//                 BottomNavigationForGodownKeeper.screenName,
//                 arguments: "onBack",
//               ),
//             ),
//
//             Expanded(
//               child: RefreshIndicator(
//                 color: colorScheme.primary,
//                 backgroundColor: colorScheme.surface,
//                 onRefresh: _refresh,
//                 child: isLoading
//                     ? const _LoadingView()
//                     : receiptList.isNotEmpty
//                     ? ListView.builder(
//                   physics: const BouncingScrollPhysics(
//                     parent: AlwaysScrollableScrollPhysics(),
//                   ),
//                   padding: AppSpacing.itemReturnListPadding,
//                   itemCount: receiptList.length,
//                   itemBuilder: (context, index) {
//                     return ItemReturnScreenListItem(
//                       receiptList[index],
//                     );
//                   },
//                 )
//                     : const _EmptyView(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSQCBottomSheet(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     var vehiclesNotOut = receiptList
//         .where((v) => v.returnOn == "0001-01-01T00:00:00")
//         .toList();
//
//     if (vehiclesNotOut.isEmpty) {
//       showFlushBar(context, "All vehicles are already out.");
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         // ── was: BorderRadius.vertical(top: Radius.circular(20))
//         borderRadius: AppRadius.itemReturnSheet,
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.75,
//           minChildSize: 0.4,
//           maxChildSize: 0.75,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: colorScheme.surface,
//                 // ── was: BorderRadius.vertical(top: Radius.circular(20))
//                 borderRadius: AppRadius.itemReturnSheet,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Drag handle
//                   Center(
//                     child: Container(
//                       // ── was: width: 36, height: 4
//                       width: AppSizes.sqcDragHandleWidth,
//                       height: AppSizes.sqcDragHandleHeight,
//                       // ── was: EdgeInsets.only(top: 10, bottom: 14)
//                       margin: AppSpacing.sqcDragHandleMargin,
//                       decoration: BoxDecoration(
//                         color: colorScheme.outline.withOpacity(0.4),
//                         // ── was: BorderRadius.circular(2)
//                         borderRadius: AppRadius.sqcDragHandle,
//                       ),
//                     ),
//                   ),
//                   // Header
//                   Padding(
//                     // ── was: EdgeInsets.fromLTRB(20, 0, 20, 12)
//                     padding: AppSpacing.sqcHeaderPadding,
//                     child: Row(
//                       children: [
//                         Container(
//                           // ── was: width: 7, height: 7
//                           width: AppSizes.sqcDotSize,
//                           height: AppSizes.sqcDotSize,
//                           decoration: BoxDecoration(
//                             color: colorScheme.primary,
//                             // ── was: BorderRadius.circular(2)
//                             borderRadius: AppRadius.sqcDot,
//                           ),
//                         ),
//                         // ── was: SizedBox(width: 8)
//                         const SizedBox(width: AppSpacing.sm),
//                         Text(
//                           'SQC VEHICLES',
//                           // ── was: TextStyle(fontSize:12, fontWeight:w700, letterSpacing:0.8)
//                           style: AppTextStyles.sqcSheetTitle,
//                         ),
//                         const Spacer(),
//                         Text(
//                           '${vehiclesNotOut.length} pending',
//                           // ── was: TextStyle(fontSize:12, fontWeight:w600, color: primary)
//                           style: AppTextStyles.sqcPendingCount.copyWith(
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                       height: 1,
//                       color: colorScheme.outline.withOpacity(0.3)),
//                   // List
//                   Expanded(
//                     child: ListView.separated(
//                       controller: scrollController,
//                       // ── was: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
//                       padding: AppSpacing.sqcListPadding,
//                       itemCount: vehiclesNotOut.length,
//                       // ── was: SizedBox(height: 4)
//                       separatorBuilder: (_, __) =>
//                       const SizedBox(height: AppSpacing.xs),
//                       itemBuilder: (context, index) {
//                         var vehicle = vehiclesNotOut[index];
//                         return Material(
//                           color: colorScheme.primaryContainer
//                               .withOpacity(0.35),
//                           // ── was: BorderRadius.circular(12)
//                           borderRadius: AppRadius.itemReturnVehicleCard,
//                           child: InkWell(
//                             // ── was: BorderRadius.circular(12)
//                             borderRadius: AppRadius.itemReturnVehicleCard,
//                             onTap: () {
//                               Navigator.pop(context);
//                               var itemIds = <String>[];
//                               var itemNames = <String>[];
//                               if (vehicle.itemDetails != null &&
//                                   vehicle.itemDetails!.isNotEmpty) {
//                                 for (var item in vehicle.itemDetails!) {
//                                   itemIds.add(item.itemId.toString());
//                                   itemNames.add(item.itemName.toString());
//                                 }
//                               }
//                               Navigator.pushNamed(
//                                 context,
//                                 SQCRegisterScreen.screenName,
//                                 arguments: {
//                                   'vehicleNo': vehicle.vehicleNo.toString(),
//                                   'godownId': vehicle.godownId.toString(),
//                                   'itemIds': itemIds,
//                                   'itemNames': itemNames,
//                                 },
//                               );
//                             },
//                             child: Padding(
//                               // ── was: EdgeInsets.symmetric(horizontal:14, vertical:10)
//                               padding: AppSpacing.sqcVehicleRowPadding,
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     // ── was: width:34, height:34
//                                     width: AppSizes.sqcVehicleIconBox,
//                                     height: AppSizes.sqcVehicleIconBox,
//                                     decoration: BoxDecoration(
//                                       color: colorScheme.primaryContainer,
//                                       borderRadius: BorderRadius.circular(10),                                      // borderRadius: AppRadius.md,
//                                     ),
//                                     child: Icon(
//                                       Icons.local_shipping_rounded,
//                                       color: colorScheme.primary,
//                                       // ── was: size: 17
//                                       size: AppSizes.sqcVehicleIconSize,
//                                     ),
//                                   ),
//                                   // ── was: SizedBox(width: 12)
//                                   const SizedBox(width: AppSpacing.md),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Vehicle No.',
//                                           // ── was: TextStyle(fontSize:10, w600, letterSpacing:0.3)
//                                           style: AppTextStyles
//                                               .itemReturnVehicleLabel
//                                               .copyWith(
//                                             color: colorScheme.onSurfaceVariant,
//                                           ),
//                                         ),
//                                         const SizedBox(height: AppSpacing.xxs),
//                                         Text(
//                                           vehicle.vehicleNo ?? '',
//                                           // ── was: TextStyle(fontSize:15, w800, letterSpacing:-0.2)
//                                           style: AppTextStyles
//                                               .itemReturnVehicleNo
//                                               .copyWith(
//                                             color: colorScheme.primary,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.chevron_right_rounded,
//                                     color: colorScheme.onSurfaceVariant,
//                                     // ── was: size: 20
//                                     size: AppSizes.iconSm,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> fetchItemReceipts() async {
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
//           Uri.parse(
//               '${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status Code: ${response.statusCode}");
//         print("API Response Body: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data
//                 .map((json) => GetItemReceiptListModel.fromJson(json))
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
// }
//
// // ── Loading placeholder ──
// class _LoadingView extends StatelessWidget {
//   const _LoadingView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CircularProgressIndicator(
//         color: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }
//
// // ── Empty state ──
// class _EmptyView extends StatelessWidget {
//   const _EmptyView();
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return ListView(
//       children: [
//         SizedBox(height: MediaQuery.of(context).size.height * 0.25),
//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 // ── was: width:56, height:56, BorderRadius.circular(16)
//                 width: AppSizes.itemReturnEmptyIconBox,
//                 height: AppSizes.itemReturnEmptyIconBox,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: AppRadius.itemReturnEmptyIcon,
//                 ),
//                 child: Icon(
//                   Icons.inbox_rounded,
//                   // ── was: size: 28
//                   size: AppSizes.itemReturnEmptyIconPx,
//                   color: colorScheme.primary,
//                 ),
//               ),
// //              SizedBox(height: 14)
// //               SizedBox(height: AppSpacing.iconXss),
//               Text(
//                 'No Data Found',
//                 // ── was: TextStyle(fontSize:15, w700, color: onSurface)
//                 style: AppTextStyles.emptyTitle.copyWith(
//                   color: colorScheme.onSurface,
//                 ),
//               ),
//               // ── was: SizedBox(height: 5)
//               const SizedBox(height: AppSpacing.xs),
//               Text(
//                 'Pull down to refresh',
//                 // ── was: TextStyle(fontSize:12, w500, color: onSurfaceVariant)
//                 style: AppTextStyles.emptySubtitle.copyWith(
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../ConstantScreen/widgets.dart';
import '../../../Utils/CustomAppBar.dart';
import '../../../Utils/Widget.dart';
import '../../../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/constants.dart';
import '../../BottomNavigationForGodownKeeper.dart';
import '../../DashboardScreen.dart';
import '../../SQCRegister/SQCRegisterScreen.dart';
import '../EditItem/Model/GetItemReceiptListModel.dart';
import 'ItenReturnItemUi.dart';

// ── Design-system imports ──────────────────────────────────────────────
import '../../../Utils/styles/app_colors.dart';
import '../../../Utils/styles/app_spacing.dart';
import '../../../Utils/styles/app_text_styles.dart';

class ItemReturnScreen extends StatefulWidget {
  static const screenName = '/itemReturnScreen';
  const ItemReturnScreen({super.key});

  @override
  State<ItemReturnScreen> createState() => _ItemReturnScreenState();
}

class _ItemReturnScreenState extends State<ItemReturnScreen> {
  List<GetItemReceiptListModel> receiptList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemReceipts();
  }

  Future<void> _refresh() async {
    await fetchItemReceipts();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
            context,
            BottomNavigationForGodownKeeper.screenName,
            arguments: "onBack",
          );
          return false;
        } else {
          Navigator.pushReplacementNamed(
            context,
            BottomNavigationForGodownKeeper.screenName,
          );
          return false;
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () {
            _showSQCBottomSheet(context);
          },
          icon: const Icon(Icons.list, color: Colors.white),
          label: Text(
            "SQC",
            style: AppTextStyles.button.copyWith(color: Colors.white),
          ),
        ),
        // appBar: CustomAppBar(title: 'Item Return'),
        appBar: CustomGKAppBar(
          title: 'Item Return',
        ),
        body: Column(
          children: [
            // AppGradientHeader(
            //   title: 'Item Return',
            //   subtitle: 'Manage returned items',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () {
            //     if (argLRAdd == "fromDrawer") {
            //       Navigator.pushReplacementNamed(
            //         context,
            //         BottomNavigationForGodownKeeper.screenName,
            //         arguments: "onBack",
            //       );
            //     } else {
            //       Navigator.pushReplacementNamed(
            //         context,
            //         BottomNavigationForGodownKeeper.screenName,
            //       );
            //     }
            //   },
            // ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
                    : receiptList.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.sm,
                    right: AppSpacing.sm,
                    top: AppSpacing.sm,
                    bottom: 80,
                  ),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: receiptList.length,
                  itemBuilder: (context, index) {
                    return ItemReturnScreenListItem(
                      receiptList[index],
                    );
                  },
                )
                    : _buildEmptyState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: const Icon(
                Icons.inbox_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No Data Found",
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "There are no item receipts to display.",
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSQCBottomSheet(BuildContext context) {
    var vehiclesNotOut = receiptList
        .where((v) => v.returnOn == "0001-01-01T00:00:00")
        .toList();

    if (vehiclesNotOut.isEmpty) {
      showFlushBar(context, "All vehicles are already out.");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      backgroundColor: AppColors.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.imbalanceDragHandle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Sheet title
              Text(
                "SQC Vehicles",
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  itemCount: vehiclesNotOut.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final vehicle = vehiclesNotOut[index];
                    return _SQCVehicleTile(
                      vehicle: vehicle,
                      onTap: () {
                        Navigator.pop(context);
                        var itemIds = <String>[];
                        var itemNames = <String>[];
                        if (vehicle.itemDetails != null &&
                            vehicle.itemDetails!.isNotEmpty) {
                          for (var item in vehicle.itemDetails!) {
                            itemIds.add(item.itemId.toString());
                            itemNames.add(item.itemName.toString());
                          }
                        }
                        Navigator.pushNamed(
                          context,
                          SQCRegisterScreen.screenName,
                          arguments: {
                            'vehicleNo': vehicle.vehicleNo.toString(),
                            'godownId': vehicle.godownId.toString(),
                            'itemIds': itemIds,
                            'itemNames': itemNames,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchItemReceipts() async {
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
          Uri.parse(
              '${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print("Request URL: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print("API Response Status Code: ${response.statusCode}");
        print("API Response Body: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList = data
                .map((json) => GetItemReceiptListModel.fromJson(json))
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
}

// ─────────────────────────────────────────────────────────────────────────────
/// Private reusable tile for the SQC bottom sheet vehicle list.
// ─────────────────────────────────────────────────────────────────────────────
class _SQCVehicleTile extends StatelessWidget {
  const _SQCVehicleTile({
    required this.vehicle,
    required this.onTap,
  });

  final GetItemReceiptListModel vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card.topLeft.x),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Vehicle icon badge
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Vehicle number
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "Vehicle No:  ",
                    style: AppTextStyles.bodyMd
                        .copyWith(color: AppColors.textMuted),
                    children: [
                      TextSpan(
                        text: "${vehicle.vehicleNo}",
                        style: AppTextStyles.bodyMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}