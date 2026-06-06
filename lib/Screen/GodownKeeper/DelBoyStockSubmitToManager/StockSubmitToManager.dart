// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../User/Login/provider/LoginProvider.dart';
// import '../../User/splashscreen/page/splash_screen.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/constants.dart';
// import '../../Utils/shared_preference.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../DashboardScreen.dart';
// import '../DelBoyStockReturn/StockReturnFromDelBoy.dart';
// import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
// import '../DeliveryBoyModel/GetStockTransferListModel.dart';
// import '../DeliveryBoyModel/ItemData.dart';
// import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
//
// // ── Design tokens (inline — no external import needed) ──────────────────────
// abstract final class _C {
//   static const bg          = Color(0xFFF1F5FE);
//   static const surface     = Color(0xFFFFFFFF);
//   static const blue        = Color(0xFF1E3A8A);
//   static const blueLight   = Color(0xFF2D52C5);
//   static const blueXL      = Color(0xFFEFF6FF);
//   static const blueXXL     = Color(0xFFDBEAFE);
//   static const teal        = Color(0xFF0F766E);
//   static const text        = Color(0xFF111827);
//   static const textMid     = Color(0xFF374151);
//   static const textMuted   = Color(0xFF6B7280);
//   static const border      = Color(0xFFE2E8F0);
//   static const divider     = Color(0xFFF1F5F9);
//   static const shadow      = Color(0x0D1E3A8A);
//   static const headerBg    = Color(0xFFF8FAFC);
//   static const pendingBg   = Color(0xFFFFF7ED);
//   static const pendingFg   = Color(0xFF9A3412);
//   static const doneBg      = Color(0xFFF0FDF4);
//   static const doneFg      = Color(0xFF166534);
//   static const orange      = Color(0xFFF97316);
//
//   static const LinearGradient gradPrimary = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
//   );
// }
//
// class StockSubmitToManager extends StatefulWidget {
//   static const screenName = '/stockSubmitToManager';
//
//   const StockSubmitToManager({super.key});
//
//   @override
//   State<StockSubmitToManager> createState() => _StockSubmitToManagerState();
// }
//
// class _StockSubmitToManagerState extends State<StockSubmitToManager> {
//   UpdateRefillSale? updateRefillSale;
//   List<StockSubmitToManagerListModel>? stockSubmitData = [];
//   late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
//   List<StockSubmitToManagerListModel> groupedData =[];
//   // late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
//   // List<StockSubmitToManagerListModel> stockSubmitData = [];
//   List<StockSubmitToManagerListModel> filteredData = [];
//   TextEditingController searchController = TextEditingController();
//   String? mobileNo;
//   bool isSearchActive = false;
//   bool saveFlag = false;
//
//   List<GetStockTransferListModel> _stockTransferList = [];
//   bool stockTransferFlag = false;
//   bool initiallyExpanded = true;
//   bool isTotalSaleExpanded = true;
//   @override
//   void initState() {
//     super.initState();
//     updateRefillSale = UpdateRefillSale();
//     insertDelBoyStockList();
//     stockDataFuture = updateRefillSale!.getDataFromDatabase();
//     debugPrint("stockDataFuture: $stockDataFuture");
//     filteredData = [];
//     fetchTransactionList();
//     checkAndSaveDayEndData();
//   }
//
//   // Handle the back press
//   Future<bool> onBackPressed() async {
//     bool shouldExit = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Exit Screen"),
//         content: Text("Do you really want to exit this screen?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false), // Stay on the screen
//             child: Text("No"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true), // Go back to the previous screen
//             child: Text("Yes"),
//           ),
//         ],
//       ),
//     );
//     return shouldExit;
//   }
//
//   Future<void> _refresh() async {
//     // Simulate a network call or data refresh.
//     await Future.delayed(Duration(seconds: 2));
//
//     // Update the data and refresh the UI.
//     setState(() {
//       stockDataFuture = updateRefillSale!.getDataFromDatabase();
//       debugPrint("stockDataFuture: $stockDataFuture");
//     });
//     insertDelBoyStockList();
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
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Submitted Stock', // Title or hint text for the text field
//         ),
//         backgroundColor: _C.bg,
//         // appBar: _buildAppBar(),
//         body: RefreshIndicator(
//           color: _C.blueLight,
//           backgroundColor: _C.surface,
//           onRefresh: _refresh,
//           child: FutureBuilder<List<StockSubmitToManagerListModel>>(
//             future: stockDataFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const _LoadingState();
//               } else if (snapshot.hasError) {
//                 return _ErrorState(error: snapshot.error.toString());
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const _EmptyState(message: 'No submitted stock data found.');
//               } else {
//                 stockSubmitData = snapshot.data!;
//                 stockSubmitData?.sort((a, b) {
//                   if (a.dailySaleStatus == 3 && b.dailySaleStatus != 3) return -1;
//                   if (a.dailySaleStatus != 3 && b.dailySaleStatus == 3) return 1;
//                   return 0;
//                 });
//                 if (!isSearchActive) {
//                   filteredData = stockSubmitData!;
//                 }
//                 return _buildBody(context);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   // Widget _buildBody(BuildContext context) {
//   //   return CustomScrollView(
//   //     physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//   //     slivers: [
//   //       // ── Search bar ──────────────────────────────────────────────────────
//   //       SliverToBoxAdapter(
//   //         child: Padding(
//   //           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//   //           child: _SearchBar(
//   //             controller: searchController,
//   //             onChanged: filterSearchResults,
//   //           ),
//   //         ),
//   //       ),
//   //
//   //       // ── Total Sale summary section ───────────────────────────────────────
//   //       SliverToBoxAdapter(
//   //         child: Padding(
//   //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//   //           child: _SectionHeader(
//   //             title: 'Total Sale',
//   //             icon: Icons.bar_chart_rounded,
//   //             color: _C.blue,
//   //           ),
//   //         ),
//   //       ),
//   //       SliverToBoxAdapter(
//   //         child: Padding(
//   //           padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
//   //           child: _SummaryTableCard(groupedData: groupedData),
//   //         ),
//   //       ),
//   //
//   //       // ── Delivery Men Wise Sale section ───────────────────────────────────
//   //       SliverToBoxAdapter(
//   //         child: Padding(
//   //           padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//   //           child: _SectionHeader(
//   //             title: 'Delivery Men Wise Sale',
//   //             icon: Icons.people_alt_rounded,
//   //             color: _C.teal,
//   //           ),
//   //         ),
//   //       ),
//   //
//   //       if (filteredData.isEmpty)
//   //         const SliverFillRemaining(
//   //           child: _EmptyState(message: 'No delivery men data found.'),
//   //         )
//   //       else
//   //         SliverPadding(
//   //           padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
//   //           sliver: SliverList(
//   //             delegate: SliverChildBuilderDelegate(
//   //               (context, index) {
//   //                 final sale = filteredData[index];
//   //                 return Padding(
//   //                   padding: const EdgeInsets.only(bottom: 12),
//   //                   child:
//   //                   _DeliveryManCard(
//   //                     sale: sale,
//   //                     isSearchActive: isSearchActive,
//   //                     stockTransferFlag: stockTransferFlag,
//   //                     saveFlag: saveFlag,
//   //                     onEdit: () => Navigator.push(
//   //                       context,
//   //                       MaterialPageRoute(
//   //                         builder: (context) => DailyRefillSalePage(
//   //                           sale: sale,
//   //                           saleGKId: sale.saleGKId,
//   //                           dMId: sale.dMId,
//   //                           flagAdd: "editMode",
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     onDelete: () => showDialog(
//   //                       context: context,
//   //                       builder: (BuildContext ctx) => _DeleteConfirmDialog(
//   //                         onConfirm: () async {
//   //                           Navigator.of(ctx).pop();
//   //                           await deleteDataToApi(sale.saleGKId!.toInt());
//   //                         },
//   //                         onCancel: () => Navigator.of(ctx).pop(),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 );
//   //               },
//   //               childCount: filteredData.length,
//   //             ),
//   //           ),
//   //         ),
//   //     ],
//   //   );
//   // }
//
//   Widget _buildBody(BuildContext context) {
//     return Column(
//       children: [
//
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: _SearchBar(
//             controller: searchController,
//             onChanged: filterSearchResults,
//           ),
//         ),
//
//         // Padding(
//         //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//         //   child: _SectionHeader(
//         //     title: 'Total Sale',
//         //     icon: Icons.bar_chart_rounded,
//         //     color: _C.blue,
//         //   ),
//         // ),
//
//         // Padding(
//         //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//         //   child: InkWell(
//         //     onTap: () {
//         //       setState(() {
//         //         isTotalSaleExpanded = !isTotalSaleExpanded;
//         //       });
//         //     },
//         //     child: Row(
//         //       children: [
//         //         Icon(
//         //           isTotalSaleExpanded
//         //               ? Icons.keyboard_arrow_down_rounded
//         //               : Icons.keyboard_arrow_right_rounded,
//         //           color: _C.blue,
//         //         ),
//         //         const SizedBox(width: 6),
//         //         const Icon(
//         //           Icons.bar_chart_rounded,
//         //           color: _C.blue,
//         //         ),
//         //         const SizedBox(width: 6),
//         //         const Text(
//         //           "Total Sale",
//         //           style: TextStyle(
//         //             fontSize: 15,
//         //             fontWeight: FontWeight.w700,
//         //             color: _C.text,
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 isTotalSaleExpanded = !isTotalSaleExpanded;
//               });
//             },
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.bar_chart_rounded,
//                   color: _C.blue,
//                 ),
//
//                 const SizedBox(width: 6),
//
//                 const Text(
//                   "Total Sale",
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: _C.text,
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 Icon(
//                   isTotalSaleExpanded
//                       ? Icons.keyboard_arrow_down_rounded
//                       : Icons.keyboard_arrow_right_rounded,
//                   color: _C.blue,
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
//           // child: _SummaryTableCard(groupedData: groupedData),
//           child: isTotalSaleExpanded
//               ? _SummaryTableCard(groupedData: groupedData)
//               : const SizedBox.shrink(),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//           child: _SectionHeader(
//             title: 'Delivery Men Wise Sale',
//             icon: Icons.people_alt_rounded,
//             color: _C.teal,
//           ),
//         ),
//
//         // ── Scrollable List Only ─────────────────────────
//
//         Expanded(
//           child: filteredData.isEmpty
//               ? const _EmptyState(
//             message: 'No delivery men data found.',
//           )
//               : ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
//             itemCount: filteredData.length,
//             itemBuilder: (context, index) {
//               final sale = filteredData[index];
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child:
//                 _DeliveryManCard(
//                   sale: sale,
//                   isSearchActive: isSearchActive,
//                   stockTransferFlag: stockTransferFlag,
//                   saveFlag: saveFlag,
//                   onEdit: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DailyRefillSalePage(
//                         sale: sale,
//                         saleGKId: sale.saleGKId,
//                         dMId: sale.dMId,
//                         flagAdd: "editMode",
//                       ),
//                     ),
//                   ),
//                   onDelete: () => showDialog(
//                     context: context,
//                     builder: (BuildContext ctx) => _DeleteConfirmDialog(
//                       onConfirm: () async {
//                         Navigator.of(ctx).pop();
//                         await deleteDataToApi(sale.saleGKId!.toInt());
//                       },
//                       onCancel: () => Navigator.of(ctx).pop(),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> insertDelBoyStockList() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? distributorId = prefs.getString('DistributorId');
//         String? bearerToken = prefs.getString('token');
//
//         if (bearerToken == null) {
//           throw Exception('Bearer token is missing');
//         }
//
//         final response = await http.get(
//           Uri.parse('${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         );
//
//         debugPrint("Response body: ${response.body}");
//         debugPrint("Response body: ${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'");
//         if (response.statusCode == 200) {
//           var data = json.decode(response.body);
//
//           // Parse the JSON response into a list of StockSubmitToManagerListModel
//           List<StockSubmitToManagerListModel> result = List<StockSubmitToManagerListModel>.from(
//             data.map((item) => StockSubmitToManagerListModel.fromJson(item)),
//           );
//
//           // Insert data into the database
//           await updateRefillSale?.insertDataToDatabase(result, "Pending", "Edit");
//
//           // Fetch data from the database
//           stockDataFuture = updateRefillSale!.getDataFromDatabase();
//           groupedData = _groupAndSumItems(result);
//           // Update the UI
//           stockDataFuture.then((data) {
//             setState(() {
//               stockSubmitData = data;
//               filteredData = data;
//               // Assign data to filteredData
//               EasyLoading.dismiss();
//             });
//           });
//
//           debugPrint("Fetched data: $stockSubmitData");
//         } else {
//           EasyLoading.dismiss();
//           refreshTokens();
//           debugPrint("Failed to fetch data from API: ${response.statusCode}");
//         }
//       } catch (e) {
//         EasyLoading.dismiss();
//         refreshTokens();
//         debugPrint("Error during API call: $e");
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   // Future<void> submitDelBoyStockList(String delManId,String gkId) async {
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if(Constants.isNetworkAvailable){
//   //     try {
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       String? distributorId = prefs.getString('DistributorId');
//   //       String? bearerToken = prefs.getString('token');
//   //
//   //       if (bearerToken == null) {
//   //         throw Exception('Bearer token is missing');
//   //       }
//   //
//   //       final response = await http.get(
//   //         Uri.parse('${AppUrl.DailySaleByGK_StatusUpdate}/$distributorId/$gkId/SubmitToManager'),
//   //         headers: {
//   //           'Authorization': 'Bearer $bearerToken',
//   //         },
//   //       );
//   //
//   //       debugPrint("request body DailySaleByGK_StatusUpdate: ${response.request}");
//   //       debugPrint("Response body DailySaleByGK_StatusUpdate: ${response.body}");
//   //
//   //       if (response.statusCode == 200) {
//   //         var data = json.decode(response.body);
//   //         updateRefillSale!.updateFlagToComplete(delManId,gkId);
//   //         Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
//   //         // stockDataFuture = updateRefillSale!.getDataFromDatabase();
//   //         // debugPrint("stockDataFuture: $stockDataFuture");
//   //       } else {
//   //         debugPrint("Failed to fetch data from API: ${response.statusCode}");
//   //       }
//   //     } catch (e) {
//   //       debugPrint("Error during API call: $e");
//   //     }
//   //   }else{
//   //     showFlushBar(context,
//   //         Constants.connectionMessage);
//   //   }
//   //
//   // }
//
//   Future<void> getstockDataFuture() async {
//     // Delay fetching the data by 2 seconds
//     await Future.delayed(const Duration(milliseconds: 2000));
//
//     // Fetch the data after the delay
//     Future<List<StockSubmitToManagerListModel>> getstockDataFutureDBSA =
//     updateRefillSale!.getDataFromDatabase();
//
//     // Set the future to the state variable
//     setState(() {
//       stockDataFuture = getstockDataFutureDBSA;
//     });
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
//             insertDelBoyStockList();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//
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
//         String message = "Your session is expire. Click ok to login again.";
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
//   void filterSearchResults(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         isSearchActive = false;
//         filteredData = stockSubmitData!;
//       });
//     } else {
//       setState(() {
//         isSearchActive = true;
//         filteredData = stockSubmitData!
//             .where((sale) {
//           final staffNameMatches = sale.staffName != null &&
//               sale.staffName!.toLowerCase().contains(query.toLowerCase());
//           final itemNameMatches = sale.itemList != null &&
//               sale.itemList!.any((item) =>
//               item.itemName != null &&
//                   item.itemName!.toLowerCase().contains(query.toLowerCase()));
//           return staffNameMatches || itemNameMatches;
//         })
//             .toList();
//
//         // Check if no results are found
//         if (filteredData.isEmpty) {
//           filteredData = [];
//           print('No matching data found');
//         }
//       });
//     }
//   }
//
//   String capitalizeFirstLetter(String text) {
//     return text.split(' ').map((word) {
//       if (word.isNotEmpty) {
//         return word[0].toUpperCase() + word.substring(1).toLowerCase();
//       }
//       return word;
//     }).join(' ');
//   }
//
//   Future<List<StockSubmitToManagerListModel>> fetchStockData() async {
//     // Simulate data fetching
//     await Future.delayed(Duration(seconds: 2));
//     return []; // Replace with your actual data
//   }
//
//   Future<void> deleteDataToApi(int salesGKID) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       try {
//         // Get shared preferences for distributorId and bearerToken
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? distributorId = prefs.getString('DistributorId');
//         String? bearerToken = prefs.getString('token');
//         String? godownKeeperID = prefs.getString('godownKeeperId');
//         String? addedBy = prefs.getString('StaffId');
//         String? godownID = prefs.getString('godownId');
//
//         if (distributorId == null || bearerToken == null) {
//           print('DistributorId or BearerToken is missing');
//           return;
//         }
//
//         List<ItemData> itemList = [];
//
//         // Convert the fetched data into ItemData objects
//         // for (var item in getUpdateRefillSale) {
//         //   itemList.add(ItemData.fromJson(item));
//         // }
//
//         // Prepare the entire data structure for the API
//         Map<String, dynamic> apiData = {
//           "SaleGKId": salesGKID,
//           "DistributorId": distributorId,
//           "GodownId": godownID,
//           "Action": "DELETE"
//         };
//
//         // Convert data to JSON and send it to the API
//         String jsonRequestBody = jsonEncode(apiData);
//         debugPrint("jsonRequestBody$jsonRequestBody");
//         if (salesGKID != null && salesGKID != 0) {
//           // Send the API request
//           final response = await http.post(
//             Uri.parse('${AppUrl.UpdateDailyRefillSale}'), // Your actual API URL
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $bearerToken',
//               // Authorization header with Bearer token
//             },
//             body: jsonRequestBody, // The body of the request
//           );
//           print('response  delete${response.body}');
//           print('response delete ${response}');
//           // Check response status
//           if (response.statusCode == 200) {
//             if (response == -1 ||
//                 response.body == -1 ||
//                 response == "-1" ||
//                 response.body == "-1") {
//               EasyLoading.showToast(Constants.failToDelete,
//                   duration: const Duration(milliseconds: 3000));
//               print('Data sent successfully1');
//             } else if (response == 0 ||
//                 response.body == 0 ||
//                 response == "0" ||
//                 response.body == "0") {
//               EasyLoading.showToast(Constants.failToInserRecord,
//                   duration: const Duration(milliseconds: 3000));
//               print('Data sent successfully2');
//             } else {
//               EasyLoading.showToast(Constants.dataDeleted,
//                   duration: const Duration(milliseconds: 3000));
//               print('Data sent successfully3');
//               // setState(() {
//               //   insertDelBoyStockList();
//               //
//               // });
//               Future.delayed(const Duration(milliseconds: 500), () {
//                 setState(() {
//                   insertDelBoyStockList();
//                 });
//               });
//             }
//             // Safely extract ItemIds (ensure they're integers)
//             // List<int> itemIds = apiItemList.map<int>((item) {
//             //   // Try to safely parse the ItemId string as an integer
//             //   int? itemIdInt = int.tryParse(item["ItemId"]);
//             //   if (itemIdInt == null) {
//             //     // Handle the case where ItemId is not a valid integer (fallback to 0)
//             //     print(
//             //         "Warning: ItemId '${item["ItemId"]}' is invalid. Defaulting to 0.");
//             //     itemIdInt = 0;
//             //   }
//             //   return itemIdInt!;
//             // }).toList();
//
//             // Update local database and UI
//
//
//           } else {
//             print('Failed to send data: ${response.statusCode}');
//             showFlushBar(context, Constants.dataDeletedFail);
//           }
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(Constants.failToInserRecord)),
//           );
//         }
//       } catch (e) {
//         print('Error sending data to API: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(Constants.failToInserRecord)),
//         );
//       }
//     } else {
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> refreshData() async {
//     try {
//       // Fetch the new data
//       await insertDelBoyStockList(); // Fetch the latest data and update `stockSubmitData`
//
//       // Reapply the filter with the current search query
//       if (searchController.text.isNotEmpty) {
//         filterSearchResults(searchController.text); // Apply the active search filter
//       } else {
//         setState(() {
//           filteredData = stockSubmitData ?? []; // Show all data if no search query
//         });
//       }
//
//       debugPrint("Data refreshed successfully with applied filter.");
//     } catch (e) {
//       debugPrint("Error refreshing data: $e");
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
//           // If there is data in the response, process it and save
//           saveFlag = true;
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
//         print("Error: ${response.statusCode}");
//       }
//     }
//     catch (e) {
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   List<StockSubmitToManagerListModel> _groupAndSumItems(List<StockSubmitToManagerListModel> result) {
//     Map<num, StockSubmitToManagerListModel> groupedDataMap = {};
//     EasyLoading.show();
//     // Loop through each StockSubmitToManagerListModel
//     for (var stock in result) {
//       for (var item in stock.itemList!) {
//         num itemId = item.itemId!;
//
//         // If itemId already exists in the map, sum the quantities
//         if (groupedDataMap.containsKey(itemId)) {
//           StockSubmitToManagerListModel existingStock = groupedDataMap[itemId]!;
//
//           // Find the corresponding ItemList in the existing stock
//           ItemList existingItem = existingStock.itemList!.firstWhere((i) => i.itemId == itemId);
//
//           // Create a new ItemList with summed quantities
//           ItemList updatedItem = existingItem.copyWith(
//             filledSaleQty: (existingItem.filledSaleQty ?? 0) + (item.filledSaleQty ?? 0),
//             sVQty: (existingItem.sVQty ?? 0) + (item.sVQty ?? 0),
//             tVQty: (existingItem.tVQty ?? 0) + (item.tVQty ?? 0),
//             emptyRetQty: (existingItem.emptyRetQty ?? 0) + (item.emptyRetQty ?? 0),
//             deffQty: (existingItem.deffQty ?? 0) + (item.deffQty ?? 0),
//             lessEmptyQty: (existingItem.lessEmptyQty ?? 0) + (item.lessEmptyQty ?? 0),
//           );
//
//           // Update the itemList with the new summed item
//           List<ItemList> updatedItemList = [
//             ...existingStock.itemList!.where((i) => i.itemId != itemId), // Remove the old item
//             updatedItem, // Add the updated item
//           ];
//
//           // Update the StockSubmitToManagerListModel with the new itemList
//           StockSubmitToManagerListModel updatedStock = existingStock.copyWith(
//             itemList: updatedItemList,
//           );
//
//           // Update the map with the modified StockSubmitToManagerListModel
//           groupedDataMap[itemId] = updatedStock;
//           EasyLoading.dismiss();
//         } else {
//           // If itemId doesn't exist in the map, create a new entry
//           groupedDataMap[itemId] = StockSubmitToManagerListModel(
//             saleGKId: stock.saleGKId,
//             distributorId: stock.distributorId,
//             deliveryDate: stock.deliveryDate,
//             dMId: stock.dMId,
//             vehicleId: stock.vehicleId,
//             dailySaleStatus: stock.dailySaleStatus,
//             staffNo: stock.staffNo,
//             staffName: stock.staffName,
//             vehicleNo: stock.vehicleNo,
//             statusStr: stock.statusStr,
//             addedOn: stock.addedOn,
//             addedByNo: stock.addedByNo,
//             addedByName: stock.addedByName,
//             addedBy: stock.addedBy,
//             action: stock.action,
//             itemList: [
//               ItemList(
//                 itemId: item.itemId,
//                 itemName: item.itemName,
//                 filledSaleQty: item.filledSaleQty,
//                 sVQty: item.sVQty,
//                 tVQty: item.tVQty,
//                 emptyRetQty: item.emptyRetQty,
//                 deffQty: item.deffQty,
//                 lessEmptyQty: item.lessEmptyQty,
//                 remark: item.remark,
//                 closingFilled: item.closingFilled,
//                 closingEmpty: item.closingEmpty,
//                 closingDef: item.closingDef,
//                 sVConsStr: item.sVConsStr,
//                 TVConsStr: item.TVConsStr,
//                 FlagColumnUpdate: item.FlagColumnUpdate,
//               )
//             ],
//           );
//           EasyLoading.dismiss();
//         }
//       }
//     }
//     EasyLoading.dismiss();
//     // Convert the map values to a list and return
//     return groupedDataMap.values.toList();
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint(
//           "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break; // No need to continue checking once we find an item with isStkTrans = 0
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false; // Disable the button
//           } else {
//             stockTransferFlag = true; // Enable the button
//           }
//         });
//       } else {
//         refreshTokens();
//         throw Exception('Failed To Load Items');
//       }
//     } else {
//       refreshTokens();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
// }
//
// // ═══════════════════════════════════════════════════════════════════════════════
// //  REUSABLE UI WIDGETS (UI only — no logic)
// // ═══════════════════════════════════════════════════════════════════════════════
//
// /// Gradient section header with icon dot.
// class _SectionHeader extends StatelessWidget {
//   const _SectionHeader({
//     required this.title,
//     required this.icon,
//     required this.color,
//   });
//
//   final String title;
//   final IconData icon;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 28,
//           height: 28,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: color),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title.toUpperCase(),
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: _C.textMid,
//             letterSpacing: 0.8,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Modern rounded search bar.
// class _SearchBar extends StatelessWidget {
//   const _SearchBar({required this.controller, required this.onChanged});
//
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 46,
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 8, offset: Offset(0, 2)),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         style: const TextStyle(
//           fontSize: 14,
//           color: _C.text,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           hintText: 'Search by staff or item name…',
//           hintStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
//           prefixIcon: const Icon(Icons.search_rounded, color: _C.blueLight, size: 20),
//           suffixIcon: ValueListenableBuilder<TextEditingValue>(
//             valueListenable: controller,
//             builder: (_, value, __) => value.text.isEmpty
//                 ? const SizedBox.shrink()
//                 : IconButton(
//                     icon: const Icon(Icons.close_rounded, size: 18, color: _C.textMuted),
//                     onPressed: () {
//                       controller.clear();
//                       onChanged('');
//                     },
//                   ),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: _C.surface,
//           contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
//         ),
//       ),
//     );
//   }
// }
//
// /// Table card showing aggregated totals across all items.
// class _SummaryTableCard extends StatelessWidget {
//   const _SummaryTableCard({required this.groupedData});
//
//   final List<StockSubmitToManagerListModel> groupedData;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 10, offset: Offset(0, 2)),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child:
//         Column(
//           children: [
//             const _StockTableHeader(altColor: _C.blueXL, textColor: _C.blueLight),
//             if (groupedData.isEmpty)
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 child: Center(
//                   child: Text(
//                     'No summary data',
//                     style: TextStyle(fontSize: 13, color: _C.textMuted),
//                   ),
//                 ),
//               )
//             else
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: groupedData.length,
//                 separatorBuilder: (_, __) =>
//                     const Divider(height: 1, thickness: 1, color: _C.divider),
//                 itemBuilder: (context, index) {
//                   final stock = groupedData[index];
//                   if (stock.itemList == null || stock.itemList!.isEmpty) {
//                     return const SizedBox.shrink();
//                   }
//                   final item = stock.itemList![0];
//                   return _StockDataRow(
//                     itemName: item.itemName ?? 'N/A',
//                     sale: item.filledSaleQty?.toString() ?? '0',
//                     sv: item.sVQty?.toString() ?? '0',
//                     tv: item.tVQty?.toString() ?? '0',
//                     empty: item.emptyRetQty?.toString() ?? '0',
//                     def: item.deffQty?.toString() ?? '0',
//                     lessEmpty: item.lessEmptyQty?.toString() ?? '0',
//                     isEven: index.isEven,
//                   );
//                 },
//               ),
//           ],
//         ),
//
//       ),
//     );
//   }
// }
//
// // class _SummaryTableCard extends StatelessWidget {
// //   const _SummaryTableCard({required this.groupedData});
// //
// //   final List<StockSubmitToManagerListModel> groupedData;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _C.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: const [
// //           BoxShadow(
// //             color: _C.shadow,
// //             blurRadius: 10,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: ExpansionTile(
// //         initiallyExpanded: true,
// //         tilePadding: const EdgeInsets.symmetric(horizontal: 16),
// //         childrenPadding: EdgeInsets.zero,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         collapsedShape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         backgroundColor: _C.surface,
// //         collapsedBackgroundColor: _C.surface,
// //         iconColor: _C.blue,
// //         collapsedIconColor: _C.blue,
// //
// //         // 👇 Custom header (icon + text in one row)
// //         title: Row(
// //           children: [
// //             // const Icon(
// //             //   Icons.expand_more,
// //             //   color: _C.blue,
// //             // ),
// //             const SizedBox(width: 6),
// //             const Text(
// //               "Total Sale",
// //               style: TextStyle(
// //                 fontSize: 15,
// //                 fontWeight: FontWeight.w700,
// //                 color: _C.text,
// //               ),
// //             ),
// //           ],
// //         ),
// //
// //         children: [
// //           const _StockTableHeader(
// //             altColor: _C.blueXL,
// //             textColor: _C.blueLight,
// //           ),
// //
// //           if (groupedData.isEmpty)
// //             const Padding(
// //               padding: EdgeInsets.symmetric(vertical: 16),
// //               child: Center(
// //                 child: Text(
// //                   'No summary data',
// //                   style: TextStyle(
// //                     fontSize: 13,
// //                     color: _C.textMuted,
// //                   ),
// //                 ),
// //               ),
// //             )
// //           else
// //             ListView.separated(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: groupedData.length,
// //               separatorBuilder: (_, __) => const Divider(
// //                 height: 1,
// //                 thickness: 1,
// //                 color: _C.divider,
// //               ),
// //               itemBuilder: (context, index) {
// //                 final stock = groupedData[index];
// //
// //                 if (stock.itemList == null ||
// //                     stock.itemList!.isEmpty) {
// //                   return const SizedBox.shrink();
// //                 }
// //
// //                 final item = stock.itemList![0];
// //
// //                 return _StockDataRow(
// //                   itemName: item.itemName ?? 'N/A',
// //                   sale: item.filledSaleQty?.toString() ?? '0',
// //                   sv: item.sVQty?.toString() ?? '0',
// //                   tv: item.tVQty?.toString() ?? '0',
// //                   empty: item.emptyRetQty?.toString() ?? '0',
// //                   def: item.deffQty?.toString() ?? '0',
// //                   lessEmpty: item.lessEmptyQty?.toString() ?? '0',
// //                   isEven: index.isEven,
// //                 );
// //               },
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// //
//
// /// Compact stock table column header row.
// class _StockTableHeader extends StatelessWidget {
//   const _StockTableHeader({
//     required this.altColor,
//     required this.textColor,
//   });
//
//   final Color altColor;
//   final Color textColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: altColor,
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: Row(
//         children: [
//           _headerCell('Item', flex: 3, color: textColor),
//           _vDivider(),
//           _headerCell('Sale', flex: 2, color: textColor),
//           _vDivider(),
//           _headerCell('SV', flex: 2, color: textColor),
//           _vDivider(),
//           _headerCell('TV', flex: 2, color: textColor),
//           _vDivider(),
//           _headerCell('Empty', flex: 2, color: textColor),
//           _vDivider(),
//           _headerCell('Def.', flex: 2, color: textColor),
//           _vDivider(),
//           _headerCell('Less\nEmpty', flex: 2, color: textColor),
//         ],
//       ),
//     );
//   }
//
//   static Widget _headerCell(String label, {required int flex, required Color color}) {
//     return Expanded(
//       flex: flex,
//       child: Center(
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w700,
//             color: color,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ),
//     );
//   }
//
//   static Widget _vDivider() => Container(
//         width: 1,
//         height: 32,
//         color: _C.border,
//       );
// }
//
// /// A single item data row in the stock table.
// class _StockDataRow extends StatelessWidget {
//   const _StockDataRow({
//     required this.itemName,
//     required this.sale,
//     required this.sv,
//     required this.tv,
//     required this.empty,
//     required this.def,
//     required this.lessEmpty,
//     required this.isEven,
//   });
//
//   final String itemName, sale, sv, tv, empty, def, lessEmpty;
//   final bool isEven;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: isEven ? _C.surface : const Color(0xFFF8FAFC),
//       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
//       child: Row(
//         children: [
//           _cell(itemName, flex: 3, align: TextAlign.left, bold: true, paddingLeft: 6),
//           _vDivider(),
//           _cell(sale, flex: 2),
//           _vDivider(),
//           _cell(sv, flex: 2),
//           _vDivider(),
//           _cell(tv, flex: 2),
//           _vDivider(),
//           _cell(empty, flex: 2),
//           _vDivider(),
//           _cell(def, flex: 2),
//           _vDivider(),
//           _cell(lessEmpty, flex: 2),
//         ],
//       ),
//     );
//   }
//
//   static Widget _cell(
//     String value, {
//     required int flex,
//     TextAlign align = TextAlign.center,
//     bool bold = false,
//     double paddingLeft = 0,
//   }) =>
//       Expanded(
//         flex: flex,
//         child: Padding(
//           padding: EdgeInsets.only(left: paddingLeft),
//           child: Text(
//             value,
//             textAlign: align,
//             style: TextStyle(
//               fontSize: 13,
//               color: _C.textMid,
//               fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
//             ),
//           ),
//         ),
//       );
//
//   static Widget _vDivider() => Container(
//         width: 1,
//         height: 20,
//         color: _C.divider,
//       );
// }
//
// /// Modern card for a single delivery man's sale entry.
// class _DeliveryManCard extends StatelessWidget {
//   const _DeliveryManCard({
//     required this.sale,
//     required this.isSearchActive,
//     required this.stockTransferFlag,
//     required this.saveFlag,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   final StockSubmitToManagerListModel sale;
//   final bool isSearchActive;
//   final bool stockTransferFlag;
//   final bool saveFlag;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   bool get _isEditable =>
//       !saveFlag &&
//       stockTransferFlag &&
//       !isSearchActive &&
//       (sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1);
//
//   bool get _isSubmitted => sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _isSubmitted ? _C.border : const Color(0xFFFFD5AD),
//           width: 1,
//         ),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 10, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Card header ─────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
//             child: Row(
//               children: [
//                 // Avatar circle
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     gradient: _isSubmitted
//                         ? const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
//                           )
//                         : const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Color(0xFFF97316), Color(0xFFD97706)],
//                           ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                     child: Text(
//                       sale.staffName != null && sale.staffName!.isNotEmpty
//                           ? sale.staffName![0].toUpperCase()
//                           : '?',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _capitalize(sale.staffName?.toString() ?? '—'),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: _C.text,
//                           letterSpacing: -0.1,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           _StatusBadge(isSubmitted: _isSubmitted),
//                           if (sale.statusStr != null && sale.statusStr!.isNotEmpty) ...[
//                             const SizedBox(width: 6),
//                             Text(
//                               sale.statusStr!,
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: _C.textMuted,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Popup menu
//                 if (_isEditable)
//                   PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == 'edit') onEdit();
//                       if (value == 'delete') onDelete();
//                     },
//                     itemBuilder: (_) => [
//                       PopupMenuItem<String>(
//                         value: 'edit',
//                         child: Row(
//                           children: const [
//                             Icon(Icons.edit_rounded, size: 16, color: _C.blueLight),
//                             SizedBox(width: 8),
//                             Text('Edit',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: _C.text)),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'delete',
//                         child: Row(
//                           children: const [
//                             Icon(Icons.delete_outline_rounded,
//                                 size: 16, color: Color(0xFFEF4444)),
//                             SizedBox(width: 8),
//                             Text('Delete',
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: _C.text)),
//                           ],
//                         ),
//                       ),
//                     ],
//                     shape:
//                         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 8,
//                     icon: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: _C.blueXL,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.more_vert_rounded,
//                           size: 18, color: _C.blueLight),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           // ── Item table ───────────────────────────────────────────────────
//           const Divider(height: 1, thickness: 1, color: _C.divider),
//           _StockTableHeader(
//             altColor: _isSubmitted ? _C.blueXL : _C.pendingBg,
//             textColor: _isSubmitted ? _C.blueLight : _C.pendingFg,
//           ),
//           const Divider(height: 1, thickness: 1, color: _C.divider),
//
//           sale.itemList != null && sale.itemList!.isNotEmpty
//               ? ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: sale.itemList!.length,
//                   separatorBuilder: (_, __) =>
//                       const Divider(height: 1, thickness: 1, color: _C.divider),
//                   itemBuilder: (context, idx) {
//                     final item = sale.itemList![idx];
//                     return _StockDataRow(
//                       itemName: item.itemName ?? 'N/A',
//                       sale: item.filledSaleQty?.toString() ?? '0',
//                       sv: item.sVQty?.toString() ?? '0',
//                       tv: item.tVQty?.toString() ?? '0',
//                       empty: item.emptyRetQty?.toString() ?? '0',
//                       def: item.deffQty?.toString() ?? '0',
//                       lessEmpty: item.lessEmptyQty?.toString() ?? '0',
//                       isEven: idx.isEven,
//                     );
//                   },
//                 )
//               : const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   child: Center(
//                     child: Text(
//                       'No item data available',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: _C.textMuted,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ),
//                 ),
//
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
//
//   String _capitalize(String text) {
//     return text.split(' ').map((w) {
//       if (w.isEmpty) return w;
//       return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
//     }).join(' ');
//   }
// }
//
// /// Status badge chip.
// class _StatusBadge extends StatelessWidget {
//   const _StatusBadge({required this.isSubmitted});
//   final bool isSubmitted;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//       decoration: BoxDecoration(
//         color: isSubmitted ? _C.doneBg : _C.pendingBg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         isSubmitted ? 'Submitted ✓' : 'Pending',
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w700,
//           color: isSubmitted ? _C.doneFg : _C.pendingFg,
//           letterSpacing: 0.2,
//         ),
//       ),
//     );
//   }
// }
//
// /// Loading spinner state.
// class _LoadingState extends StatelessWidget {
//   const _LoadingState();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircularProgressIndicator(color: _C.blueLight, strokeWidth: 3),
//           SizedBox(height: 16),
//           Text(
//             'Loading stock data…',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: _C.textMuted,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Empty state widget — wrapped in ListView so pull-to-refresh works.
// class _EmptyState extends StatelessWidget {
//   const _EmptyState({required this.message});
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       children: [
//         SizedBox(height: MediaQuery.of(context).size.height * 0.18),
//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: _C.blueXL,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Icon(Icons.inbox_rounded, size: 34, color: _C.blueLight),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'No Data Found',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: _C.text),
//               ),
//               const SizedBox(height: 6),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       color: _C.textMuted,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Pull down to refresh',
//                 style: TextStyle(
//                     fontSize: 13,
//                     color: _C.textMuted,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Error state widget.
// class _ErrorState extends StatelessWidget {
//   const _ErrorState({required this.error});
//   final String error;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFEF2F2),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: const Icon(Icons.error_outline_rounded,
//                 size: 32, color: Color(0xFFEF4444)),
//           ),
//           const SizedBox(height: 14),
//           const Text(
//             'Something went wrong',
//             style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: _C.text),
//           ),
//           const SizedBox(height: 6),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               error,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, color: _C.textMuted),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Delete confirmation dialog.
// class _DeleteConfirmDialog extends StatelessWidget {
//   const _DeleteConfirmDialog(
//       {required this.onConfirm, required this.onCancel});
//   final VoidCallback onConfirm;
//   final VoidCallback onCancel;
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
//       contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//       actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFEF2F2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.delete_outline_rounded,
//                 size: 20, color: Color(0xFFEF4444)),
//           ),
//           const SizedBox(width: 10),
//           const Text(
//             'Confirm Deletion',
//             style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: _C.text),
//           ),
//         ],
//       ),
//       content: const Text(
//         'Are you sure you want to delete this record? This action cannot be undone.',
//         style: TextStyle(fontSize: 13, color: _C.textMuted, height: 1.5),
//       ),
//       actions: [
//         TextButton(
//           onPressed: onCancel,
//           style: TextButton.styleFrom(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10)),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           ),
//           child: const Text('No',
//               style: TextStyle(
//                   color: _C.textMuted, fontWeight: FontWeight.w600)),
//         ),
//         ElevatedButton(
//           onPressed: onConfirm,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFEF4444),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10)),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             textStyle: const TextStyle(
//                 fontWeight: FontWeight.w700, fontSize: 14),
//           ),
//           child: const Text('Delete'),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../ConstantScreen/widgets.dart';
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DashboardScreen.dart';
import '../DelBoyStockReturn/StockReturnFromDelBoy.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../DeliveryBoyModel/ItemData.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';

// ── Design tokens (inline — no external import needed) ──────────────────────
abstract final class _C {
  static const bg          = Color(0xFFF1F5FE);
  static const surface     = Color(0xFFFFFFFF);
  static const blue        = Color(0xFF1E3A8A);
  static const blueLight   = Color(0xFF2D52C5);
  static const blueXL      = Color(0xFFEFF6FF);
  static const blueXXL     = Color(0xFFDBEAFE);
  static const teal        = Color(0xFF0F766E);
  static const text        = Color(0xFF111827);
  static const textMid     = Color(0xFF374151);
  static const textMuted   = Color(0xFF6B7280);
  static const border      = Color(0xFFE2E8F0);
  static const divider     = Color(0xFFF1F5F9);
  static const shadow      = Color(0x0D1E3A8A);
  static const headerBg    = Color(0xFFF8FAFC);
  static const pendingBg   = Color(0xFFFFF7ED);
  static const pendingFg   = Color(0xFF9A3412);
  static const doneBg      = Color(0xFFF0FDF4);
  static const doneFg      = Color(0xFF166534);
  static const orange      = Color(0xFFF97316);

  static const LinearGradient gradPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
  );
}

class StockSubmitToManager extends StatefulWidget {
  static const screenName = '/stockSubmitToManager';

  const StockSubmitToManager({super.key});

  @override
  State<StockSubmitToManager> createState() => _StockSubmitToManagerState();
}

class _StockSubmitToManagerState extends State<StockSubmitToManager> {
  UpdateRefillSale? updateRefillSale;
  List<StockSubmitToManagerListModel>? stockSubmitData = [];
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  List<StockSubmitToManagerListModel> groupedData =[];
  // late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  // List<StockSubmitToManagerListModel> stockSubmitData = [];
  List<StockSubmitToManagerListModel> filteredData = [];
  TextEditingController searchController = TextEditingController();
  String? mobileNo;
  bool isSearchActive = false;
  bool saveFlag = false;

  List<GetStockTransferListModel> _stockTransferList = [];
  bool stockTransferFlag = false;
  bool initiallyExpanded = true;
  bool isTotalSaleExpanded = true;
  @override
  void initState() {
    super.initState();
    updateRefillSale = UpdateRefillSale();
    insertDelBoyStockList();
    stockDataFuture = updateRefillSale!.getDataFromDatabase();
    debugPrint("stockDataFuture: $stockDataFuture");
    filteredData = [];
    fetchTransactionList();
    checkAndSaveDayEndData();
  }

  // Handle the back press
  Future<bool> onBackPressed() async {
    bool shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Screen"),
        content: Text("Do you really want to exit this screen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay on the screen
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Go back to the previous screen
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return shouldExit;
  }

  Future<void> _refresh() async {
    // Simulate a network call or data refresh.
    await Future.delayed(Duration(seconds: 2));

    // Update the data and refresh the UI.
    setState(() {
      stockDataFuture = updateRefillSale!.getDataFromDatabase();
      debugPrint("stockDataFuture: $stockDataFuture");
    });
    insertDelBoyStockList();
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
          title: 'Submitted Stock', // Title or hint text for the text field
        ),
        backgroundColor: _C.bg,
        // appBar: _buildAppBar(),
        body: RefreshIndicator(
          color: _C.blueLight,
          backgroundColor: _C.surface,
          onRefresh: _refresh,
          child: FutureBuilder<List<StockSubmitToManagerListModel>>(
            future: stockDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _LoadingState();
              } else if (snapshot.hasError) {
                return _ErrorState(error: snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const _EmptyState(message: 'No submitted stock data found.');
              } else {
                // Bug fix: copy the list before sorting so we never mutate
                // the original snapshot data. Sorting in-place inside builder
                // (which runs on every rebuild) was re-ordering the list
                // between a tap and the next frame, causing onEdit/onDelete
                // closures to fire with the wrong sale object.
                final sorted = List<StockSubmitToManagerListModel>.from(snapshot.data!);
                sorted.sort((a, b) {
                  if (a.dailySaleStatus == 3 && b.dailySaleStatus != 3) return -1;
                  if (a.dailySaleStatus != 3 && b.dailySaleStatus == 3) return 1;
                  return 0;
                });
                // Only update stockSubmitData / filteredData when the source
                // list actually changes (not on every cosmetic rebuild).
                if (stockSubmitData != sorted) {
                  stockSubmitData = sorted;
                  if (!isSearchActive) {
                    // Use a separate copy so sorting stockSubmitData later
                    // never silently re-orders filteredData mid-render.
                    filteredData = List<StockSubmitToManagerListModel>.from(sorted);
                  }
                }
                return _buildBody(context);
              }
            },
          ),
        ),
      ),
    );
  }


  // Widget _buildBody(BuildContext context) {
  //   return CustomScrollView(
  //     physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
  //     slivers: [
  //       // ── Search bar ──────────────────────────────────────────────────────
  //       SliverToBoxAdapter(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
  //           child: _SearchBar(
  //             controller: searchController,
  //             onChanged: filterSearchResults,
  //           ),
  //         ),
  //       ),
  //
  //       // ── Total Sale summary section ───────────────────────────────────────
  //       SliverToBoxAdapter(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
  //           child: _SectionHeader(
  //             title: 'Total Sale',
  //             icon: Icons.bar_chart_rounded,
  //             color: _C.blue,
  //           ),
  //         ),
  //       ),
  //       SliverToBoxAdapter(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
  //           child: _SummaryTableCard(groupedData: groupedData),
  //         ),
  //       ),
  //
  //       // ── Delivery Men Wise Sale section ───────────────────────────────────
  //       SliverToBoxAdapter(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
  //           child: _SectionHeader(
  //             title: 'Delivery Men Wise Sale',
  //             icon: Icons.people_alt_rounded,
  //             color: _C.teal,
  //           ),
  //         ),
  //       ),
  //
  //       if (filteredData.isEmpty)
  //         const SliverFillRemaining(
  //           child: _EmptyState(message: 'No delivery men data found.'),
  //         )
  //       else
  //         SliverPadding(
  //           padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
  //           sliver: SliverList(
  //             delegate: SliverChildBuilderDelegate(
  //               (context, index) {
  //                 final sale = filteredData[index];
  //                 return Padding(
  //                   padding: const EdgeInsets.only(bottom: 12),
  //                   child:
  //                   _DeliveryManCard(
  //                     sale: sale,
  //                     isSearchActive: isSearchActive,
  //                     stockTransferFlag: stockTransferFlag,
  //                     saveFlag: saveFlag,
  //                     onEdit: () => Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => DailyRefillSalePage(
  //                           sale: sale,
  //                           saleGKId: sale.saleGKId,
  //                           dMId: sale.dMId,
  //                           flagAdd: "editMode",
  //                         ),
  //                       ),
  //                     ),
  //                     onDelete: () => showDialog(
  //                       context: context,
  //                       builder: (BuildContext ctx) => _DeleteConfirmDialog(
  //                         onConfirm: () async {
  //                           Navigator.of(ctx).pop();
  //                           await deleteDataToApi(sale.saleGKId!.toInt());
  //                         },
  //                         onCancel: () => Navigator.of(ctx).pop(),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //               childCount: filteredData.length,
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    // Bug fix: replaced fixed Column + Expanded with a single CustomScrollView
    // so all sections scroll together. The old layout had a Column whose
    // fixed-height children (search bar + summary table + section header)
    // could exceed the available height on small screens, causing:
    // "RenderFlex overflowed by 88 pixels on the bottom."
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // ── Search bar ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _SearchBar(
              controller: searchController,
              onChanged: filterSearchResults,
            ),
          ),
        ),

        // ── Total Sale expand/collapse toggle ─────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  isTotalSaleExpanded = !isTotalSaleExpanded;
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.bar_chart_rounded,
                    color: _C.blue,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Total Sale",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _C.text,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isTotalSaleExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: _C.blue,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Summary table (collapsible) ───────────────────────────────
        if (isTotalSaleExpanded)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: _SummaryTableCard(groupedData: groupedData),
            ),
          ),

        // ── "Delivery Men Wise Sale" section header ───────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: _SectionHeader(
              title: 'Delivery Men Wise Sale',
              icon: Icons.people_alt_rounded,
              color: _C.teal,
            ),
          ),
        ),

        // ── Delivery man cards ────────────────────────────────────────
        if (filteredData.isEmpty)
          SliverFillRemaining(
            child: const _EmptyState(message: 'No delivery men data found.'),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final sale = filteredData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DeliveryManCard(
                      // Bug fix: stable key so Flutter never reuses a card
                      // widget for the wrong sale when list order changes.
                      key: ValueKey('${sale.saleGKId}_${sale.dMId}'),
                      sale: sale,
                      isSearchActive: isSearchActive,
                      stockTransferFlag: stockTransferFlag,
                      saveFlag: saveFlag,
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyRefillSalePage(
                            sale: sale,
                            saleGKId: sale.saleGKId,
                            dMId: sale.dMId,
                            flagAdd: "editMode",
                          ),
                        ),
                      ),
                      onDelete: () => showDialog(
                        context: context,
                        builder: (BuildContext ctx) => _DeleteConfirmDialog(
                          onConfirm: () async {
                            Navigator.of(ctx).pop();
                            await deleteDataToApi(sale.saleGKId!.toInt());
                          },
                          onCancel: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredData.length,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> insertDelBoyStockList() async {
    EasyLoading.show();
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body: ${response.body}");
        debugPrint("Response body: ${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'");
        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Parse the JSON response into a list of StockSubmitToManagerListModel
          List<StockSubmitToManagerListModel> result = List<StockSubmitToManagerListModel>.from(
            data.map((item) => StockSubmitToManagerListModel.fromJson(item)),
          );

          // Insert data into the database
          await updateRefillSale?.insertDataToDatabase(result, "Pending", "Edit");

          // Fetch data from the database
          stockDataFuture = updateRefillSale!.getDataFromDatabase();
          groupedData = _groupAndSumItems(result);
          // Update the UI
          stockDataFuture.then((data) {
            setState(() {
              stockSubmitData = data;
              // Bug fix: separate copy so filteredData and stockSubmitData
              // are never the same list object — prevents a sort on one from
              // silently reordering the other mid-render.
              filteredData = List<StockSubmitToManagerListModel>.from(data);
              // Assign data to filteredData
              EasyLoading.dismiss();
            });
          });

          debugPrint("Fetched data: $stockSubmitData");
        } else {
          EasyLoading.dismiss();
          refreshTokens();
          debugPrint("Failed to fetch data from API: ${response.statusCode}");
        }
      } catch (e) {
        EasyLoading.dismiss();
        refreshTokens();
        debugPrint("Error during API call: $e");
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // Future<void> submitDelBoyStockList(String delManId,String gkId) async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if(Constants.isNetworkAvailable){
  //     try {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       String? distributorId = prefs.getString('DistributorId');
  //       String? bearerToken = prefs.getString('token');
  //
  //       if (bearerToken == null) {
  //         throw Exception('Bearer token is missing');
  //       }
  //
  //       final response = await http.get(
  //         Uri.parse('${AppUrl.DailySaleByGK_StatusUpdate}/$distributorId/$gkId/SubmitToManager'),
  //         headers: {
  //           'Authorization': 'Bearer $bearerToken',
  //         },
  //       );
  //
  //       debugPrint("request body DailySaleByGK_StatusUpdate: ${response.request}");
  //       debugPrint("Response body DailySaleByGK_StatusUpdate: ${response.body}");
  //
  //       if (response.statusCode == 200) {
  //         var data = json.decode(response.body);
  //         updateRefillSale!.updateFlagToComplete(delManId,gkId);
  //         Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
  //         // stockDataFuture = updateRefillSale!.getDataFromDatabase();
  //         // debugPrint("stockDataFuture: $stockDataFuture");
  //       } else {
  //         debugPrint("Failed to fetch data from API: ${response.statusCode}");
  //       }
  //     } catch (e) {
  //       debugPrint("Error during API call: $e");
  //     }
  //   }else{
  //     showFlushBar(context,
  //         Constants.connectionMessage);
  //   }
  //
  // }

  Future<void> getstockDataFuture() async {
    // Delay fetching the data by 2 seconds
    await Future.delayed(const Duration(milliseconds: 2000));

    // Fetch the data after the delay
    Future<List<StockSubmitToManagerListModel>> getstockDataFutureDBSA =
    updateRefillSale!.getDataFromDatabase();

    // Set the future to the state variable
    setState(() {
      stockDataFuture = getstockDataFutureDBSA;
    });
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
            insertDelBoyStockList();
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
        String message = "Your session is expire. Click ok to login again.";
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
                // onPressed: () {},
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

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearchActive = false;
        // Bug fix: use a copy, not a direct reference, so future sorts on
        // stockSubmitData never silently re-order filteredData mid-render.
        filteredData = List<StockSubmitToManagerListModel>.from(stockSubmitData!);
      });
    } else {
      setState(() {
        isSearchActive = true;
        filteredData = stockSubmitData!
            .where((sale) {
          final staffNameMatches = sale.staffName != null &&
              sale.staffName!.toLowerCase().contains(query.toLowerCase());
          final itemNameMatches = sale.itemList != null &&
              sale.itemList!.any((item) =>
              item.itemName != null &&
                  item.itemName!.toLowerCase().contains(query.toLowerCase()));
          return staffNameMatches || itemNameMatches;
        })
            .toList();

        // Check if no results are found
        if (filteredData.isEmpty) {
          filteredData = [];
          print('No matching data found');
        }
      });
    }
  }

  String capitalizeFirstLetter(String text) {
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');
  }

  Future<List<StockSubmitToManagerListModel>> fetchStockData() async {
    // Simulate data fetching
    await Future.delayed(Duration(seconds: 2));
    return []; // Replace with your actual data
  }

  Future<void> deleteDataToApi(int salesGKID) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      try {
        // Get shared preferences for distributorId and bearerToken
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? godownKeeperID = prefs.getString('godownKeeperId');
        String? addedBy = prefs.getString('StaffId');
        String? godownID = prefs.getString('godownId');

        if (distributorId == null || bearerToken == null) {
          print('DistributorId or BearerToken is missing');
          return;
        }

        List<ItemData> itemList = [];

        // Convert the fetched data into ItemData objects
        // for (var item in getUpdateRefillSale) {
        //   itemList.add(ItemData.fromJson(item));
        // }

        // Prepare the entire data structure for the API
        Map<String, dynamic> apiData = {
          "SaleGKId": salesGKID,
          "DistributorId": distributorId,
          "GodownId": godownID,
          "Action": "DELETE"
        };

        // Convert data to JSON and send it to the API
        String jsonRequestBody = jsonEncode(apiData);
        debugPrint("jsonRequestBody$jsonRequestBody");
        if (salesGKID != null && salesGKID != 0) {
          // Send the API request
          final response = await http.post(
            Uri.parse('${AppUrl.UpdateDailyRefillSale}'), // Your actual API URL
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $bearerToken',
              // Authorization header with Bearer token
            },
            body: jsonRequestBody, // The body of the request
          );
          print('response  delete${response.body}');
          print('response delete ${response}');
          // Check response status
          if (response.statusCode == 200) {
            if (response == -1 ||
                response.body == -1 ||
                response == "-1" ||
                response.body == "-1") {
              EasyLoading.showToast(Constants.failToDelete,
                  duration: const Duration(milliseconds: 3000));
              print('Data sent successfully1');
            } else if (response == 0 ||
                response.body == 0 ||
                response == "0" ||
                response.body == "0") {
              EasyLoading.showToast(Constants.failToInserRecord,
                  duration: const Duration(milliseconds: 3000));
              print('Data sent successfully2');
            } else {
              EasyLoading.showToast(Constants.dataDeleted,
                  duration: const Duration(milliseconds: 3000));
              print('Data sent successfully3');
              // setState(() {
              //   insertDelBoyStockList();
              //
              // });
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  insertDelBoyStockList();
                });
              });
            }
            // Safely extract ItemIds (ensure they're integers)
            // List<int> itemIds = apiItemList.map<int>((item) {
            //   // Try to safely parse the ItemId string as an integer
            //   int? itemIdInt = int.tryParse(item["ItemId"]);
            //   if (itemIdInt == null) {
            //     // Handle the case where ItemId is not a valid integer (fallback to 0)
            //     print(
            //         "Warning: ItemId '${item["ItemId"]}' is invalid. Defaulting to 0.");
            //     itemIdInt = 0;
            //   }
            //   return itemIdInt!;
            // }).toList();

            // Update local database and UI


          } else {
            print('Failed to send data: ${response.statusCode}');
            showFlushBar(context, Constants.dataDeletedFail);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Constants.failToInserRecord)),
          );
        }
      } catch (e) {
        print('Error sending data to API: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Constants.failToInserRecord)),
        );
      }
    } else {
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> refreshData() async {
    try {
      // Fetch the new data
      await insertDelBoyStockList(); // Fetch the latest data and update `stockSubmitData`

      // Reapply the filter with the current search query
      if (searchController.text.isNotEmpty) {
        filterSearchResults(searchController.text); // Apply the active search filter
      } else {
        setState(() {
          filteredData = List<StockSubmitToManagerListModel>.from(stockSubmitData ?? []); // Show all data if no search query
        });
      }

      debugPrint("Data refreshed successfully with applied filter.");
    } catch (e) {
      debugPrint("Error refreshing data: $e");
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
          saveFlag = true;
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

  List<StockSubmitToManagerListModel> _groupAndSumItems(List<StockSubmitToManagerListModel> result) {
    Map<num, StockSubmitToManagerListModel> groupedDataMap = {};
    EasyLoading.show();
    // Loop through each StockSubmitToManagerListModel
    for (var stock in result) {
      for (var item in stock.itemList!) {
        num itemId = item.itemId!;

        // If itemId already exists in the map, sum the quantities
        if (groupedDataMap.containsKey(itemId)) {
          StockSubmitToManagerListModel existingStock = groupedDataMap[itemId]!;

          // Find the corresponding ItemList in the existing stock
          ItemList existingItem = existingStock.itemList!.firstWhere((i) => i.itemId == itemId);

          // Create a new ItemList with summed quantities
          ItemList updatedItem = existingItem.copyWith(
            filledSaleQty: (existingItem.filledSaleQty ?? 0) + (item.filledSaleQty ?? 0),
            sVQty: (existingItem.sVQty ?? 0) + (item.sVQty ?? 0),
            tVQty: (existingItem.tVQty ?? 0) + (item.tVQty ?? 0),
            emptyRetQty: (existingItem.emptyRetQty ?? 0) + (item.emptyRetQty ?? 0),
            deffQty: (existingItem.deffQty ?? 0) + (item.deffQty ?? 0),
            lessEmptyQty: (existingItem.lessEmptyQty ?? 0) + (item.lessEmptyQty ?? 0),
          );

          // Update the itemList with the new summed item
          List<ItemList> updatedItemList = [
            ...existingStock.itemList!.where((i) => i.itemId != itemId), // Remove the old item
            updatedItem, // Add the updated item
          ];

          // Update the StockSubmitToManagerListModel with the new itemList
          StockSubmitToManagerListModel updatedStock = existingStock.copyWith(
            itemList: updatedItemList,
          );

          // Update the map with the modified StockSubmitToManagerListModel
          groupedDataMap[itemId] = updatedStock;
          EasyLoading.dismiss();
        } else {
          // If itemId doesn't exist in the map, create a new entry
          groupedDataMap[itemId] = StockSubmitToManagerListModel(
            saleGKId: stock.saleGKId,
            distributorId: stock.distributorId,
            deliveryDate: stock.deliveryDate,
            dMId: stock.dMId,
            vehicleId: stock.vehicleId,
            dailySaleStatus: stock.dailySaleStatus,
            staffNo: stock.staffNo,
            staffName: stock.staffName,
            vehicleNo: stock.vehicleNo,
            statusStr: stock.statusStr,
            addedOn: stock.addedOn,
            addedByNo: stock.addedByNo,
            addedByName: stock.addedByName,
            addedBy: stock.addedBy,
            action: stock.action,
            itemList: [
              ItemList(
                itemId: item.itemId,
                itemName: item.itemName,
                filledSaleQty: item.filledSaleQty,
                sVQty: item.sVQty,
                tVQty: item.tVQty,
                emptyRetQty: item.emptyRetQty,
                deffQty: item.deffQty,
                lessEmptyQty: item.lessEmptyQty,
                remark: item.remark,
                closingFilled: item.closingFilled,
                closingEmpty: item.closingEmpty,
                closingDef: item.closingDef,
                sVConsStr: item.sVConsStr,
                TVConsStr: item.TVConsStr,
                FlagColumnUpdate: item.FlagColumnUpdate,
              )
            ],
          );
          EasyLoading.dismiss();
        }
      }
    }
    EasyLoading.dismiss();
    // Convert the map values to a list and return
    return groupedDataMap.values.toList();
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint(
          "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
          bool hasZeroStkTrans = false;
          for (int i = 0; i < _stockTransferList.length; i++) {
            if (_stockTransferList[i].isStkTrans == 0) {
              hasZeroStkTrans = true;
              debugPrint("Found item with isStkTrans = 0");
              break; // No need to continue checking once we find an item with isStkTrans = 0
            }
          }
          if (hasZeroStkTrans) {
            stockTransferFlag = false; // Disable the button
          } else {
            stockTransferFlag = true; // Enable the button
          }
        });
      } else {
        refreshTokens();
        throw Exception('Failed To Load Items');
      }
    } else {
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE UI WIDGETS (UI only — no logic)
// ═══════════════════════════════════════════════════════════════════════════════

/// Gradient section header with icon dot.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _C.textMid,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

/// Modern rounded search bar.
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: _C.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          color: _C.text,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search by staff or item name…',
          hintStyle: const TextStyle(fontSize: 13, color: _C.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: _C.blueLight, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: _C.textMuted),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: _C.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        ),
      ),
    );
  }
}

/// Table card showing aggregated totals across all items.
class _SummaryTableCard extends StatelessWidget {
  const _SummaryTableCard({required this.groupedData});

  final List<StockSubmitToManagerListModel> groupedData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: _C.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
        Column(
          children: [
            const _StockTableHeader(altColor: _C.blueXL, textColor: _C.blueLight),
            if (groupedData.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No summary data',
                    style: TextStyle(fontSize: 13, color: _C.textMuted),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedData.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1, thickness: 1, color: _C.divider),
                itemBuilder: (context, index) {
                  final stock = groupedData[index];
                  if (stock.itemList == null || stock.itemList!.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final item = stock.itemList![0];
                  return _StockDataRow(
                    itemName: item.itemName ?? 'N/A',
                    sale: item.filledSaleQty?.toString() ?? '0',
                    sv: item.sVQty?.toString() ?? '0',
                    tv: item.tVQty?.toString() ?? '0',
                    empty: item.emptyRetQty?.toString() ?? '0',
                    def: item.deffQty?.toString() ?? '0',
                    lessEmpty: item.lessEmptyQty?.toString() ?? '0',
                    isEven: index.isEven,
                  );
                },
              ),
          ],
        ),

      ),
    );
  }
}

// class _SummaryTableCard extends StatelessWidget {
//   const _SummaryTableCard({required this.groupedData});
//
//   final List<StockSubmitToManagerListModel> groupedData;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: _C.shadow,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         initiallyExpanded: true,
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16),
//         childrenPadding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         collapsedShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         backgroundColor: _C.surface,
//         collapsedBackgroundColor: _C.surface,
//         iconColor: _C.blue,
//         collapsedIconColor: _C.blue,
//
//         // 👇 Custom header (icon + text in one row)
//         title: Row(
//           children: [
//             // const Icon(
//             //   Icons.expand_more,
//             //   color: _C.blue,
//             // ),
//             const SizedBox(width: 6),
//             const Text(
//               "Total Sale",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: _C.text,
//               ),
//             ),
//           ],
//         ),
//
//         children: [
//           const _StockTableHeader(
//             altColor: _C.blueXL,
//             textColor: _C.blueLight,
//           ),
//
//           if (groupedData.isEmpty)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               child: Center(
//                 child: Text(
//                   'No summary data',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: _C.textMuted,
//                   ),
//                 ),
//               ),
//             )
//           else
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: groupedData.length,
//               separatorBuilder: (_, __) => const Divider(
//                 height: 1,
//                 thickness: 1,
//                 color: _C.divider,
//               ),
//               itemBuilder: (context, index) {
//                 final stock = groupedData[index];
//
//                 if (stock.itemList == null ||
//                     stock.itemList!.isEmpty) {
//                   return const SizedBox.shrink();
//                 }
//
//                 final item = stock.itemList![0];
//
//                 return _StockDataRow(
//                   itemName: item.itemName ?? 'N/A',
//                   sale: item.filledSaleQty?.toString() ?? '0',
//                   sv: item.sVQty?.toString() ?? '0',
//                   tv: item.tVQty?.toString() ?? '0',
//                   empty: item.emptyRetQty?.toString() ?? '0',
//                   def: item.deffQty?.toString() ?? '0',
//                   lessEmpty: item.lessEmptyQty?.toString() ?? '0',
//                   isEven: index.isEven,
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }

//

/// Compact stock table column header row.
class _StockTableHeader extends StatelessWidget {
  const _StockTableHeader({
    required this.altColor,
    required this.textColor,
  });

  final Color altColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: altColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          _headerCell('Item', flex: 3, color: textColor),
          _vDivider(),
          _headerCell('Sale', flex: 2, color: textColor),
          _vDivider(),
          _headerCell('SV', flex: 2, color: textColor),
          _vDivider(),
          _headerCell('TV', flex: 2, color: textColor),
          _vDivider(),
          _headerCell('Empty', flex: 2, color: textColor),
          _vDivider(),
          _headerCell('Def.', flex: 2, color: textColor),
          _vDivider(),
          _headerCell('Less\nEmpty', flex: 2, color: textColor),
        ],
      ),
    );
  }

  static Widget _headerCell(String label, {required int flex, required Color color}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  static Widget _vDivider() => Container(
    width: 1,
    height: 32,
    color: _C.border,
  );
}

/// A single item data row in the stock table.
class _StockDataRow extends StatelessWidget {
  const _StockDataRow({
    required this.itemName,
    required this.sale,
    required this.sv,
    required this.tv,
    required this.empty,
    required this.def,
    required this.lessEmpty,
    required this.isEven,
  });

  final String itemName, sale, sv, tv, empty, def, lessEmpty;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? _C.surface : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Row(
        children: [
          _cell(itemName, flex: 3, align: TextAlign.left, bold: true, paddingLeft: 6),
          _vDivider(),
          _cell(sale, flex: 2),
          _vDivider(),
          _cell(sv, flex: 2),
          _vDivider(),
          _cell(tv, flex: 2),
          _vDivider(),
          _cell(empty, flex: 2),
          _vDivider(),
          _cell(def, flex: 2),
          _vDivider(),
          _cell(lessEmpty, flex: 2),
        ],
      ),
    );
  }

  static Widget _cell(
      String value, {
        required int flex,
        TextAlign align = TextAlign.center,
        bool bold = false,
        double paddingLeft = 0,
      }) =>
      Expanded(
        flex: flex,
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft),
          child: Text(
            value,
            textAlign: align,
            style: TextStyle(
              fontSize: 13,
              color: _C.textMid,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      );

  static Widget _vDivider() => Container(
    width: 1,
    height: 20,
    color: _C.divider,
  );
}

/// Modern card for a single delivery man's sale entry.
class _DeliveryManCard extends StatelessWidget {
  const _DeliveryManCard({
    super.key,
    required this.sale,
    required this.isSearchActive,
    required this.stockTransferFlag,
    required this.saveFlag,
    required this.onEdit,
    required this.onDelete,
  });

  final StockSubmitToManagerListModel sale;
  final bool isSearchActive;
  final bool stockTransferFlag;
  final bool saveFlag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  // Bug fix: removed `!isSearchActive` — the three-dot menu was hidden for
  // every card whenever the user typed in the search bar, because isSearchActive
  // was true even after the correct delivery man appeared in the results.
  // Edit/delete availability should depend on status and flags, not on search.
  bool get _isEditable =>
      !saveFlag &&
          stockTransferFlag &&
          (sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1);

  bool get _isSubmitted => sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSubmitted ? _C.border : const Color(0xFFFFD5AD),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(color: _C.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: _isSubmitted
                        ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
                    )
                        : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF97316), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      sale.staffName != null && sale.staffName!.isNotEmpty
                          ? sale.staffName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _capitalize(sale.staffName?.toString() ?? '—'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _C.text,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _StatusBadge(isSubmitted: _isSubmitted),
                          if (sale.statusStr != null && sale.statusStr!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Text(
                              sale.statusStr!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: _C.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Popup menu
                if (_isEditable)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit_rounded, size: 16, color: _C.blueLight),
                            SizedBox(width: 8),
                            Text('Edit',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _C.text)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(Icons.delete_outline_rounded,
                                size: 16, color: Color(0xFFEF4444)),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _C.text)),
                          ],
                        ),
                      ),
                    ],
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _C.blueXL,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.more_vert_rounded,
                          size: 18, color: _C.blueLight),
                    ),
                  ),
              ],
            ),
          ),

          // ── Item table ───────────────────────────────────────────────────
          const Divider(height: 1, thickness: 1, color: _C.divider),
          _StockTableHeader(
            altColor: _isSubmitted ? _C.blueXL : _C.pendingBg,
            textColor: _isSubmitted ? _C.blueLight : _C.pendingFg,
          ),
          const Divider(height: 1, thickness: 1, color: _C.divider),

          sale.itemList != null && sale.itemList!.isNotEmpty
              ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sale.itemList!.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, thickness: 1, color: _C.divider),
            itemBuilder: (context, idx) {
              final item = sale.itemList![idx];
              return _StockDataRow(
                itemName: item.itemName ?? 'N/A',
                sale: item.filledSaleQty?.toString() ?? '0',
                sv: item.sVQty?.toString() ?? '0',
                tv: item.tVQty?.toString() ?? '0',
                empty: item.emptyRetQty?.toString() ?? '0',
                def: item.deffQty?.toString() ?? '0',
                lessEmpty: item.lessEmptyQty?.toString() ?? '0',
                isEven: idx.isEven,
              );
            },
          )
              : const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                'No item data available',
                style: TextStyle(
                  fontSize: 13,
                  color: _C.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    return text.split(' ').map((w) {
      if (w.isEmpty) return w;
      return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
    }).join(' ');
  }
}

/// Status badge chip.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isSubmitted});
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isSubmitted ? _C.doneBg : _C.pendingBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isSubmitted ? 'Submitted ✓' : 'Pending',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isSubmitted ? _C.doneFg : _C.pendingFg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Loading spinner state.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _C.blueLight, strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'Loading stock data…',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _C.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget — wrapped in ListView so pull-to-refresh works.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _C.blueXL,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.inbox_rounded, size: 34, color: _C.blueLight),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Data Found',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _C.text),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      color: _C.textMuted,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pull down to refresh',
                style: TextStyle(
                    fontSize: 13,
                    color: _C.textMuted,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final String error;

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
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.error_outline_rounded,
                size: 32, color: Color(0xFFEF4444)),
          ),
          const SizedBox(height: 14),
          const Text(
            'Something went wrong',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _C.text),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: _C.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Delete confirmation dialog.
class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog(
      {required this.onConfirm, required this.onCancel});
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                size: 20, color: Color(0xFFEF4444)),
          ),
          const SizedBox(width: 10),
          const Text(
            'Confirm Deletion',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _C.text),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to delete this record? This action cannot be undone.',
        style: TextStyle(fontSize: 13, color: _C.textMuted, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('No',
              style: TextStyle(
                  color: _C.textMuted, fontWeight: FontWeight.w600)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}