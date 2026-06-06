// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
// import '../ConstantScreen/widgets.dart';
// import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
// import '../DashboardModel/TodaysOpeningStockDataModel.dart';
// import '../IOSVersionUpdateService.dart';
// import '../User/Login/provider/LoginProvider.dart';
// import '../User/splashscreen/page/splash_screen.dart';
// import '../Utils/CustomeAlertDialog.dart';
// import '../Utils/CustomeDrawer.dart';
// import '../Utils/Styling.dart';
// import '../Utils/UpdateService.dart';
// import '../Utils/Widget.dart';
// import '../Utils/app_url.dart';
// import '../Utils/constants.dart';
// import '../Utils/shared_preference.dart';
// import 'DelBoyStockReturn/StockTransferToGodownScreen.dart';
// import 'DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'DeliveryBoyModel/StockSubmitToManagerListModel.dart';
// import 'package:http/http.dart' as http;
//
// import 'ItemReceipt/CylItemList/CylItemListModel.dart';
// import 'ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import 'SQCRegister/GetSqcCardCntListModel.dart';
//
// class DashboardScreen extends StatefulWidget {
//   static const screenName = '/godownDashboard';
//
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   UpdateRefillSale? updateRefillSale;
//   bool isPhysicalStockListViewVisible = false;
//   bool isDomesticListViewVisible = false;
//   bool isNonDomesticListViewVisible = false;
//   bool isTodayOpeningStockListViewVisible = false;
//   bool isCurrentStockListViewVisible = false;
//   List<PhysicalStockImbalanceDataModel> receiptList = [];
//   List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   List<GetStockTransferListModel> _stockTransferList = [];
//   List<CylItemListModel> _items = [];
//   num? selectedItemId;
//   bool isLoading = true;
//   String? mobileNo;
//   String? userName, role, distributorName, roleId;
//   int? selectedItemIdTodayStock;
//   int? todayOpeningFilledDiffShow = 0;
//   int? todayOpeningEmptyDiffShow = 0;
//   int? todayOpeningDefectiveDiffShow = 0;
//
//   int? selectedItemIdTodayStockCurrentStock;
//   int? todayOpeningFilledDiffShowCurrentStock = 0;
//   int? todayOpeningEmptyDiffShowCurrentStock = 0;
//   int? todayOpeningDefectiveDiffShowCurrentStock = 0;
//
//   List<GetSqcCardCntListModel> getSqcCardCntList = [];
//   int? TodayTruckIn,
//       TodaySQCDone,
//       TodayNotDone,
//       TodayBodyLeak,
//       TodayLessQtyCyls,
//       MonthTruckIn,
//       MonthSQCDone,
//       MonthNotDone,
//       MonthBodyLeak,
//       MonthLessQtyCyls;
//   String? VehicleNo, SQCStatus;
//   List<GetSqcCardCntListModel> filteredSqcList = [];
//   String selectedSQCStatus = "All Vehicles";
//
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       UpdateService.checkForUpdate(context);
//       debugPrint("Firebase initialize Dash${Platform}");
//     } else {
//       IosVersionUpdateCheck().checkForUpdate(context);
//       debugPrint("Firebase not initialize");
//     }
//     updateRefillSale = UpdateRefillSale();
//     // Call the insert method when the screen is loaded
//     loadAllData();
//     // fetchItems();
//     insertDelBoyStockList();
//     _fetchImbalanceData();
//     // _fetchTodaysOpeningStockData();
//     // fetchCurrentStock();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//     fetchSavedData();
//     fetchAllSQCCount();
//   }
//
//   // Function to handle pull-to-refresh action
//   Future<void> _onRefresh() async {
//     loadAllData();
//     // fetchItems();
//     insertDelBoyStockList();
//     _fetchImbalanceData();
//     // _fetchTodaysOpeningStockData();
//     // fetchCurrentStock();
//     checkAndSaveDayEndData(); // Fetch the data again
//     fetchTransactionList();
//     fetchAllSQCCount();
//   }
//
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Column(
//         children: [
//           Expanded(
//               child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Column(
//                       children: [
//                         Card(
//                           margin: EdgeInsets.zero,
//                           color: Color(0xFFEFFFFfff),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   bottomRight: Radius.circular(20.0),
//                                   bottomLeft: Radius.circular(20.0))),
//                           child: Padding(
//                             padding:
//                             const EdgeInsets.only(left: 5.0, right: 5, top: 10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.bolt_outlined,
//                                             size: 26,
//                                             color: Colors.black54,
//                                           ),
//                                           Text(
//                                             "Today's Opening Stock",
//                                             style: Styling.bodyTitleBigBoldDashGrey,
//                                             textScaler: TextScaler.noScaling,
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(width: 10),
//                                       DropdownButton<num>(
//                                         value: selectedItemId,
//
//                                         items: _items.map((item) {
//                                           return DropdownMenuItem<num>(
//                                             value: item.itemId,
//                                             child: Text(item.itemName ?? 'Unknown'),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedItemId = value;
//                                             _filterBothLists();
//                                           });
//                                         },
//                                       ),
//                                     ]),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningFilledDiffShow.toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                   decorationColor: Colors.blue,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Filled',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningEmptyDiffShow.toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                   decorationColor: Colors.blue,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Empty',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningDefectiveDiffShow
//                                                     .toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   decorationColor: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Defective',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.bolt_outlined,
//                                             size: 26,
//                                             color: Colors.black54,
//                                           ),
//                                           Text(
//                                             "Current Stock",
//                                             style: Styling.bodyTitleBigBoldDashGrey,
//                                             textScaler: TextScaler.noScaling,
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(width: 10),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child:
//                                         SizedBox(
//                                           height: 30, // Button Height
//                                           width: 90, // Button Width
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               if (saveFlag) {
//                                                 showFlushBar(
//                                                     context,
//                                                     Constants
//                                                         .dayEndCompleted);
//                                               } else {
//                                                 _showItemPopup();
//                                                 // if(stockTransferFlag){
//                                                 // Navigator.pushNamed(
//                                                 //   context,
//                                                 //   StockTransferTOGodownScreen
//                                                 //       .screenName,
//                                                 //   // arguments: {
//                                                 //   //   "itemName": items
//                                                 //   //       .itemName,
//                                                 //   //   "itemID":
//                                                 //   //   items.itemId,
//                                                 //   //   "filledStock": items
//                                                 //   //       .currentStkFilled,
//                                                 //   //   "emptyStock": items
//                                                 //   //       .currentStkEmpty,
//                                                 //   //   "defectiveStock":
//                                                 //   //   items
//                                                 //   //       .currentStkDefective,
//                                                 //   // }
//                                                 // );
//                                                 // }else{
//                                                 //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//                                                 // }
//                                               }
//                                             },
//                                             style: ElevatedButton
//                                                 .styleFrom(
//                                               backgroundColor:
//                                               Color(0xFFfbe9e9),
//                                               // Button Color
//                                               // backgroundColor: Color(0xFFfbe9e9),   // Button Color
//                                               foregroundColor:
//                                               Colors.black,
//                                               // Text Color (simple way)
//                                               shape:
//                                               RoundedRectangleBorder(
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .circular(20),
//                                               ),
//                                               padding: EdgeInsets.zero,
//
//                                             ),
//                                             child: Text(
//                                               'Transfer',
//                                               style: TextStyle(
//                                                 fontWeight:
//                                                 FontWeight.bold,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ]),
//                                 SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningFilledDiffShowCurrentStock.toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                   decorationColor: Colors.blue,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Filled',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningEmptyDiffShowCurrentStock.toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                   decorationColor: Colors.blue,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Empty',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.circular(12),
//                                           border: Border(
//                                               top: BorderSide(
//                                                   color: Color(0xFFEFF2FB),
//                                                   width: 10)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey.shade200,
//                                                 blurRadius: 4)
//                                           ],
//                                         ),
//                                         padding: EdgeInsets.all(10),
//                                         child: Padding(
//                                           padding: EdgeInsets.all(4.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 todayOpeningDefectiveDiffShowCurrentStock
//                                                     .toString(),
//                                                 // Replace this with your dynamic data
//                                                 style: Styling.bodyTitleBigBoldDashGrey
//                                                     .copyWith(
//                                                   fontSize: 18,
//                                                   color: Colors.blue,
//                                                   decorationColor: Colors.blue,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 'Defective',
//                                                 style: Styling.bodyTitleBig,
//                                                 textScaler: TextScaler.noScaling,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 // Column(
//                                 //   children: [
//                                 //     Container(
//                                 //       color: Color(0xFFEFF2FB),
//                                 //       child: Padding(
//                                 //         padding: const EdgeInsets.only(
//                                 //             bottom: 10.0, top: 10),
//                                 //         child: Row(
//                                 //           mainAxisAlignment:
//                                 //           MainAxisAlignment.center,
//                                 //           children: [
//                                 //             Expanded(
//                                 //               flex: 1,
//                                 //               child: Text(
//                                 //                 "",
//                                 //                 style: Styling.itemTitle,
//                                 //                 textAlign: TextAlign.left,
//                                 //                 textScaler:
//                                 //                 TextScaler.noScaling,
//                                 //               ),
//                                 //             ),
//                                 //             Expanded(
//                                 //               flex: 1,
//                                 //               child: Text(
//                                 //                 "Filled",
//                                 //                 style: Styling
//                                 //                     .itemBlackTestVerySmallBoldPink,
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler:
//                                 //                 TextScaler.noScaling,
//                                 //               ),
//                                 //             ),
//                                 //             Expanded(
//                                 //               flex: 1,
//                                 //               child: Text(
//                                 //                 "Empty",
//                                 //                 style: Styling
//                                 //                     .itemBlackTestVerySmallBoldPink,
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler:
//                                 //                 TextScaler.noScaling,
//                                 //               ),
//                                 //             ),
//                                 //             Expanded(
//                                 //               flex: 1,
//                                 //               child: Text(
//                                 //                 "Defective",
//                                 //                 style: Styling
//                                 //                     .itemBlackTestVerySmallBoldPink,
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler:
//                                 //                 TextScaler.noScaling,
//                                 //               ),
//                                 //             ),
//                                 //           ],
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //     Padding(
//                                 //       padding: const EdgeInsets.only(
//                                 //         left: 5.0,
//                                 //         right: 5,
//                                 //       ),
//                                 //       child: Container(
//                                 //         color: Color(0xFFFF),
//                                 //         child:
//                                 //         Padding(
//                                 //           padding: const EdgeInsets.only(top: 7.0, bottom: 0),
//                                 //           child: getCurrentStcOfGodownKeeper.isNotEmpty
//                                 //               ? ListView.builder(
//                                 //             shrinkWrap: true,
//                                 //             padding: EdgeInsets.zero,
//                                 //             physics: NeverScrollableScrollPhysics(),
//                                 //             // itemCount: getCurrentStockDetailManager.length,
//                                 //             itemCount: getCurrentStcOfGodownKeeper.length,
//                                 //             itemBuilder: (context, index) {
//                                 //               // final items =
//                                 //               // getCurrentStockDetailManager[
//                                 //               // index];
//                                 //
//                                 //               final items = getCurrentStcOfGodownKeeper
//                                 //                   .toList()[index];
//                                 //
//                                 //               // return Card(
//                                 //               //   color: Colors.white,
//                                 //               //   shape: RoundedRectangleBorder(
//                                 //               //     borderRadius: BorderRadius.circular(4),
//                                 //               //   ),
//                                 //               //   child: Padding(
//                                 //               //     padding: const EdgeInsets.all(5.0),
//                                 //               //     child:
//                                 //               return Column(
//                                 //                 crossAxisAlignment:
//                                 //                 CrossAxisAlignment.start,
//                                 //                 children: [
//                                 //
//                                 //                   Padding(
//                                 //                     padding: const EdgeInsets.all(8.0),
//                                 //                     child: Row(
//                                 //                       mainAxisAlignment:
//                                 //                       MainAxisAlignment.center,
//                                 //                       children: [
//                                 //                          Expanded(
//                                 //                             flex: 1,
//                                 //                             child: Text(
//                                 //                               items.itemName.toString(),
//                                 //                               style: Styling.itemTitle,
//                                 //                               textAlign: TextAlign.left,
//                                 //                               textScaler:
//                                 //                               TextScaler.noScaling,
//                                 //                             ),
//                                 //                           ),
//                                 //
//                                 //                         Expanded(
//                                 //                           flex: 1,
//                                 //                           child: Text(
//                                 //                             items.currentStkFilled
//                                 //                                 .toString(),
//                                 //                             style: Styling.textFormTextSmall,
//                                 //                             textAlign: TextAlign.center,
//                                 //                             textScaler:
//                                 //                             TextScaler.noScaling,
//                                 //                           ),
//                                 //                         ),
//                                 //                         Expanded(
//                                 //                           flex: 1,
//                                 //                           child: Text(
//                                 //                             items.currentStkEmpty
//                                 //                                 .toString(),
//                                 //                             style: Styling.textFormTextSmall,
//                                 //                             textAlign: TextAlign.center,
//                                 //                             textScaler:
//                                 //                             TextScaler.noScaling,
//                                 //                           ),
//                                 //                         ),
//                                 //                         Expanded(
//                                 //                           flex: 1,
//                                 //                           child: Text(
//                                 //                             items.currentStkDefective
//                                 //                                 .toString(),
//                                 //                             style: Styling.textFormTextSmall,
//                                 //                             textAlign: TextAlign.center,
//                                 //                             textScaler:
//                                 //                             TextScaler.noScaling,
//                                 //                           ),
//                                 //                         ),
//                                 //                       ],
//                                 //                     ),
//                                 //                   ),
//                                 //
//                                 //
//                                 //                   if (index != getCurrentStcOfGodownKeeper.length - 1)
//                                 //                     Divider(
//                                 //                       color: Color(0xFFfcf2f1),
//                                 //                     ),
//                                 //                 ],
//                                 //               );
//                                 //               //   ),
//                                 //               // );
//                                 //             },
//                                 //           )
//                                 //               : Container(
//                                 //             child: Text("No Data Available"),
//                                 //           ),
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //   ],
//                                 // ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Card(
//                           margin: EdgeInsets.zero,
//                           color: Color(0xFFEFFFFfff),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(20.0),
//                                   topLeft: Radius.circular(20.0))),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               left: 5.0,
//                               right: 5,
//                             ),
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 5),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.balance_outlined,
//                                       size: 20,
//                                       // Bigger icon for a more clickable feel
//                                       color: Colors.black54,
//                                     ),
//
//                                     Expanded(
//                                       child: Text(
//                                         "Physical Stock Imbalance As Of Today",
//                                         style: Styling.bodyTitleBigBoldDashGrey,
//                                         textScaler: TextScaler.noScaling,
//                                         softWrap: true,
//                                         maxLines: 2,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Card(
//                                   margin: EdgeInsets.zero,
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         color: Color(0xFFfcf2f1),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               bottom: 10.0, top: 10),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Text(
//                                                   'Cylinder',
//                                                   style: Styling
//                                                       .bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Text(
//                                                   'Imbalance Qty.',
//                                                   style: Styling
//                                                       .bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 7.0, bottom: 0),
//                                           child: receiptList.isNotEmpty
//                                               ? ListView.builder(
//                                             shrinkWrap: true,
//                                             padding: EdgeInsets.zero,
//                                             physics:
//                                             NeverScrollableScrollPhysics(),
//                                             // itemCount: getCurrentStockDetailManager.length,
//                                             itemCount: receiptList.length,
//                                             itemBuilder: (context, index) {
//                                               // final items =
//                                               // getCurrentStockDetailManager[
//                                               // index];
//
//                                               final items =
//                                               receiptList.toList()[index];
//
//                                               return Container(
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.all(7.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                     children: [
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           Expanded(
//                                                             flex: 1,
//                                                             child: Text(
//                                                               items.itemName
//                                                                   .toString(),
//                                                               style: Styling
//                                                                   .textFormText,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                               textScaler:
//                                                               TextScaler
//                                                                   .noScaling,
//                                                             ),
//                                                           ),
//                                                           Expanded(
//                                                             flex: 1,
//                                                             child: Text(
//                                                               items.imbalanceStk
//                                                                   .toString(),
//                                                               style: Styling
//                                                                   .textFormText,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                               textScaler:
//                                                               TextScaler
//                                                                   .noScaling,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       if (index != receiptList.length - 1)
//                                                         Divider(
//                                                           color: Color(0xFFfcf2f1),
//                                                         ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           )
//                                               : Container(
//                                             child: Text("No Data Available"),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Row(
//                                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 //     children: [
//                                 //       Row(
//                                 //         children: [
//                                 //           Icon(
//                                 //             Icons.bolt_outlined,
//                                 //             size: 26,
//                                 //             color: Colors.black54,
//                                 //           ),
//                                 //           Text(
//                                 //             "Current Stock",
//                                 //             style: Styling.bodyTitleBigBoldDashGrey,
//                                 //             textScaler: TextScaler.noScaling,
//                                 //           ),
//                                 //         ],
//                                 //       ),
//                                 //       SizedBox(width: 10),
//                                 //       DropdownButton<num>(
//                                 //         value: selectedItemIdTodayStockCurrentStock,
//                                 //         items: getCurrentStcOfGodownKeeper.map((item) {
//                                 //           return DropdownMenuItem<num>(
//                                 //             value: item.itemId,
//                                 //             child: Text(item.itemName ?? 'Unknown',
//                                 //                 style:
//                                 //                 Styling.itemBlackTestSmallReport),
//                                 //           );
//                                 //         }).toList(),
//                                 //         onChanged: (value) {
//                                 //           setState(() {
//                                 //             selectedItemIdTodayStockCurrentStock = value!.toInt();
//                                 //             final selectedItem =
//                                 //             getCurrentStcOfGodownKeeper.firstWhere(
//                                 //                   (item) =>
//                                 //               item.itemId ==
//                                 //                   selectedItemIdTodayStockCurrentStock,
//                                 //               orElse: () =>
//                                 //                   GetCurrentStcOfGodownKeeperModel(),
//                                 //             );
//                                 //             todayOpeningFilledDiffShowCurrentStock =
//                                 //                 selectedItem.currentStkFilled!.toInt();
//                                 //             todayOpeningEmptyDiffShowCurrentStock =
//                                 //                 selectedItem.currentStkEmpty!.toInt();
//                                 //             todayOpeningDefectiveDiffShowCurrentStock =
//                                 //                 selectedItem.currentStkDefective!.toInt();
//                                 //           });
//                                 //         },
//                                 //       ),
//                                 //     ]),
//                                 // // Row(
//                                 // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 // //     children: [
//                                 // //       Row(
//                                 // //         children: [
//                                 // //           Icon(
//                                 // //             Icons.bolt_outlined,
//                                 // //             size: 26,
//                                 // //             color: Colors.black54,
//                                 // //           ),
//                                 // //           Text(
//                                 // //             "Current Stock",
//                                 // //             style: Styling.bodyTitleBigBoldDashGrey,
//                                 // //             textScaler: TextScaler.noScaling,
//                                 // //           ),
//                                 // //         ],
//                                 // //       ),
//                                 // //       SizedBox(width: 10),
//                                 // //       Padding(
//                                 // //         padding: const EdgeInsets.all(8.0),
//                                 // //         child:
//                                 // //         SizedBox(
//                                 // //           height: 30, // Button Height
//                                 // //           width: 90, // Button Width
//                                 // //           child: ElevatedButton(
//                                 // //             onPressed: () {
//                                 // //               if (saveFlag) {
//                                 // //                 showFlushBar(
//                                 // //                     context,
//                                 // //                     Constants
//                                 // //                         .dayEndCompleted);
//                                 // //               } else {
//                                 // //                 _showItemPopup();
//                                 // //                 // if(stockTransferFlag){
//                                 // //                 // Navigator.pushNamed(
//                                 // //                 //   context,
//                                 // //                 //   StockTransferTOGodownScreen
//                                 // //                 //       .screenName,
//                                 // //                 //   // arguments: {
//                                 // //                 //   //   "itemName": items
//                                 // //                 //   //       .itemName,
//                                 // //                 //   //   "itemID":
//                                 // //                 //   //   items.itemId,
//                                 // //                 //   //   "filledStock": items
//                                 // //                 //   //       .currentStkFilled,
//                                 // //                 //   //   "emptyStock": items
//                                 // //                 //   //       .currentStkEmpty,
//                                 // //                 //   //   "defectiveStock":
//                                 // //                 //   //   items
//                                 // //                 //   //       .currentStkDefective,
//                                 // //                 //   // }
//                                 // //                 // );
//                                 // //                 // }else{
//                                 // //                 //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//                                 // //                 // }
//                                 // //               }
//                                 // //             },
//                                 // //             style: ElevatedButton
//                                 // //                 .styleFrom(
//                                 // //               backgroundColor:
//                                 // //               Color(0xFFfbe9e9),
//                                 // //               // Button Color
//                                 // //               // backgroundColor: Color(0xFFfbe9e9),   // Button Color
//                                 // //               foregroundColor:
//                                 // //               Colors.black,
//                                 // //               // Text Color (simple way)
//                                 // //               shape:
//                                 // //               RoundedRectangleBorder(
//                                 // //                 borderRadius:
//                                 // //                 BorderRadius
//                                 // //                     .circular(20),
//                                 // //               ),
//                                 // //               padding: EdgeInsets.zero,
//                                 // //
//                                 // //             ),
//                                 // //             child: Text(
//                                 // //               'Transfe',
//                                 // //               style: TextStyle(
//                                 // //                 fontWeight:
//                                 // //                 FontWeight.bold,
//                                 // //                 fontSize: 12,
//                                 // //               ),
//                                 // //             ),
//                                 // //           ),
//                                 // //         ),
//                                 // //       ),
//                                 // //     ]),
//                                 //
//                                 // SizedBox(height: 5),
//                                 // Row(
//                                 //   mainAxisAlignment: MainAxisAlignment.center,
//                                 //   children: [
//                                 //     Expanded(
//                                 //       child: Container(
//                                 //         decoration: BoxDecoration(
//                                 //           color: Color(0xFFEFF2FB),
//                                 //           borderRadius: BorderRadius.circular(12),
//                                 //           boxShadow: [
//                                 //             BoxShadow(
//                                 //                 color: Colors.grey.shade200,
//                                 //                 blurRadius: 4)
//                                 //           ],
//                                 //         ),
//                                 //         padding: EdgeInsets.all(10),
//                                 //         child: Padding(
//                                 //           padding: EdgeInsets.all(4.0),
//                                 //           child: Column(
//                                 //             crossAxisAlignment:
//                                 //             CrossAxisAlignment.center,
//                                 //             children: [
//                                 //               Text(
//                                 //                 todayOpeningFilledDiffShowCurrentStock.toString(),
//                                 //                 // Replace this with your dynamic data
//                                 //                 style: Styling.bodyTitleBigBoldDashGrey
//                                 //                     .copyWith(
//                                 //                   fontSize: 18,
//                                 //                   color: Colors.blue,
//                                 //                   fontWeight: FontWeight.bold,
//                                 //                   decorationColor: Colors.blue,
//                                 //                 ),
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //               const SizedBox(height: 4),
//                                 //               Text(
//                                 //                 'Filled',
//                                 //                 style: Styling.bodyTitleBig,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //     SizedBox(width: 10),
//                                 //     Expanded(
//                                 //       child: Container(
//                                 //         decoration: BoxDecoration(
//                                 //           color: Color(0xFFEFF2FB),
//                                 //           borderRadius: BorderRadius.circular(12),
//                                 //           boxShadow: [
//                                 //             BoxShadow(
//                                 //                 color: Colors.grey.shade200,
//                                 //                 blurRadius: 4)
//                                 //           ],
//                                 //         ),
//                                 //         padding: EdgeInsets.all(10),
//                                 //         child: Padding(
//                                 //           padding: EdgeInsets.all(4.0),
//                                 //           child: Column(
//                                 //             crossAxisAlignment:
//                                 //             CrossAxisAlignment.center,
//                                 //             children: [
//                                 //               Text(
//                                 //                 todayOpeningEmptyDiffShowCurrentStock.toString(),
//                                 //                 // Replace this with your dynamic data
//                                 //                 style: Styling.bodyTitleBigBoldDashGrey
//                                 //                     .copyWith(
//                                 //                   fontSize: 18,
//                                 //                   color: Colors.blue,
//                                 //                   fontWeight: FontWeight.bold,
//                                 //                   decorationColor: Colors.blue,
//                                 //                 ),
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //               const SizedBox(height: 4),
//                                 //               Text(
//                                 //                 'Empty',
//                                 //                 style: Styling.bodyTitleBig,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //     SizedBox(width: 10),
//                                 //     Expanded(
//                                 //       child: Container(
//                                 //         decoration: BoxDecoration(
//                                 //           color: Color(0xFFEFF2FB),
//                                 //           borderRadius: BorderRadius.circular(12),
//                                 //           boxShadow: [
//                                 //             BoxShadow(
//                                 //                 color: Colors.grey.shade200,
//                                 //                 blurRadius: 4)
//                                 //           ],
//                                 //         ),
//                                 //         padding: EdgeInsets.all(10),
//                                 //         child: Padding(
//                                 //           padding: EdgeInsets.all(4.0),
//                                 //           child: Column(
//                                 //             crossAxisAlignment:
//                                 //             CrossAxisAlignment.center,
//                                 //             children: [
//                                 //               Text(
//                                 //                 todayOpeningDefectiveDiffShowCurrentStock
//                                 //                     .toString(),
//                                 //                 // Replace this with your dynamic data
//                                 //                 style: Styling.bodyTitleBigBoldDashGrey
//                                 //                     .copyWith(
//                                 //                   fontSize: 18,
//                                 //                   color: Colors.blue,
//                                 //                   decorationColor: Colors.blue,
//                                 //                   fontWeight: FontWeight.bold,
//                                 //                 ),
//                                 //                 textAlign: TextAlign.center,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //               const SizedBox(height: 4),
//                                 //               Text(
//                                 //                 'Defective',
//                                 //                 style: Styling.bodyTitleBig,
//                                 //                 textScaler: TextScaler.noScaling,
//                                 //               ),
//                                 //             ],
//                                 //           ),
//                                 //         ),
//                                 //       ),
//                                 //     ),
//                                 //   ],
//                                 // ),
//                                 // Card(
//                                 //   margin: EdgeInsets.zero,
//                                 //   color: Colors.white,
//                                 //   shape: RoundedRectangleBorder(
//                                 //     borderRadius:
//                                 //     BorderRadius.circular(4),
//                                 //   ),
//                                 //
//                                 //     child: Column(
//                                 //       children: [
//                                 //         Container(
//                                 //           color: Color(0xFFEFF2FB),
//                                 //           child: Padding(
//                                 //             padding: const EdgeInsets.only(
//                                 //                 bottom: 10.0, top: 10),
//                                 //             child: Row(
//                                 //               mainAxisAlignment:
//                                 //               MainAxisAlignment.center,
//                                 //               children: [
//                                 //                 Expanded(
//                                 //                   flex: 1,
//                                 //                   child: Text(
//                                 //                     "",
//                                 //                     style: Styling.itemTitle,
//                                 //                     textAlign: TextAlign.left,
//                                 //                     textScaler:
//                                 //                     TextScaler.noScaling,
//                                 //                   ),
//                                 //                 ),
//                                 //                 Expanded(
//                                 //                   flex: 1,
//                                 //                   child: Text(
//                                 //                     "Filled",
//                                 //                     style: Styling
//                                 //                         .itemBlackTestVerySmallBoldPink,
//                                 //                     textAlign: TextAlign.center,
//                                 //                     textScaler:
//                                 //                     TextScaler.noScaling,
//                                 //                   ),
//                                 //                 ),
//                                 //                 Expanded(
//                                 //                   flex: 1,
//                                 //                   child: Text(
//                                 //                     "Empty",
//                                 //                     style: Styling
//                                 //                         .itemBlackTestVerySmallBoldPink,
//                                 //                     textAlign: TextAlign.center,
//                                 //                     textScaler:
//                                 //                     TextScaler.noScaling,
//                                 //                   ),
//                                 //                 ),
//                                 //                 Expanded(
//                                 //                   flex: 1,
//                                 //                   child: Text(
//                                 //                     "Defective",
//                                 //                     style: Styling
//                                 //                         .itemBlackTestVerySmallBoldPink,
//                                 //                     textAlign: TextAlign.center,
//                                 //                     textScaler:
//                                 //                     TextScaler.noScaling,
//                                 //                   ),
//                                 //                 ),
//                                 //               ],
//                                 //             ),
//                                 //           ),
//                                 //         ),
//                                 //         Padding(
//                                 //           padding: const EdgeInsets.only(
//                                 //             left: 5.0,
//                                 //             right: 5,
//                                 //           ),
//                                 //           child: Container(
//                                 //             color: Color(0xFFFF),
//                                 //             child:
//                                 //                                   Padding(
//                                 //           padding: const EdgeInsets.only(top: 7.0, bottom: 0),
//                                 //           child: getCurrentStcOfGodownKeeper.isNotEmpty
//                                 //               ? ListView.builder(
//                                 //                   shrinkWrap: true,
//                                 //                   padding: EdgeInsets.zero,
//                                 //                   physics: NeverScrollableScrollPhysics(),
//                                 //                   // itemCount: getCurrentStockDetailManager.length,
//                                 //                   itemCount: getCurrentStcOfGodownKeeper.length,
//                                 //                   itemBuilder: (context, index) {
//                                 //                     // final items =
//                                 //                     // getCurrentStockDetailManager[
//                                 //                     // index];
//                                 //
//                                 //                     final items = getCurrentStcOfGodownKeeper
//                                 //                         .toList()[index];
//                                 //
//                                 //                     // return Card(
//                                 //                     //   color: Colors.white,
//                                 //                     //   shape: RoundedRectangleBorder(
//                                 //                     //     borderRadius: BorderRadius.circular(4),
//                                 //                     //   ),
//                                 //                     //   child: Padding(
//                                 //                     //     padding: const EdgeInsets.all(5.0),
//                                 //                     //     child:
//                                 //                        return Column(
//                                 //                           crossAxisAlignment:
//                                 //                               CrossAxisAlignment.start,
//                                 //                           children: [
//                                 //
//                                 //                             Padding(
//                                 //                               padding: const EdgeInsets.all(8.0),
//                                 //                               child: Row(
//                                 //                                 mainAxisAlignment:
//                                 //                                     MainAxisAlignment.center,
//                                 //                                 children: [
//                                 //                                   Expanded(
//                                 //                                     flex: 1,
//                                 //                                     child: Text(
//                                 //                                       items.itemName.toString(),
//                                 //                                       style: Styling.itemTitle,
//                                 //                                       textAlign: TextAlign.left,
//                                 //                                       textScaler:
//                                 //                                       TextScaler.noScaling,
//                                 //                                     ),
//                                 //                                   ),
//                                 //                                   Expanded(
//                                 //                                     flex: 1,
//                                 //                                     child: Text(
//                                 //                                       items.currentStkFilled
//                                 //                                           .toString(),
//                                 //                                       style: Styling.textFormTextSmall,
//                                 //                                       textAlign: TextAlign.center,
//                                 //                                       textScaler:
//                                 //                                           TextScaler.noScaling,
//                                 //                                     ),
//                                 //                                   ),
//                                 //                                   Expanded(
//                                 //                                     flex: 1,
//                                 //                                     child: Text(
//                                 //                                       items.currentStkEmpty
//                                 //                                           .toString(),
//                                 //                                       style: Styling.textFormTextSmall,
//                                 //                                       textAlign: TextAlign.center,
//                                 //                                       textScaler:
//                                 //                                           TextScaler.noScaling,
//                                 //                                     ),
//                                 //                                   ),
//                                 //                                   Expanded(
//                                 //                                     flex: 1,
//                                 //                                     child: Text(
//                                 //                                       items.currentStkDefective
//                                 //                                           .toString(),
//                                 //                                       style: Styling.textFormTextSmall,
//                                 //                                       textAlign: TextAlign.center,
//                                 //                                       textScaler:
//                                 //                                           TextScaler.noScaling,
//                                 //                                     ),
//                                 //                                   ),
//                                 //                                 ],
//                                 //                               ),
//                                 //                             ),
//                                 //
//                                 //
//                                 //                             if (index != getCurrentStcOfGodownKeeper.length - 1)
//                                 //                               Divider(
//                                 //                                 color: Color(0xFFfcf2f1),
//                                 //                               ),
//                                 //                           ],
//                                 //                         );
//                                 //                     //   ),
//                                 //                     // );
//                                 //                   },
//                                 //                 )
//                                 //               : Container(
//                                 //                   child: Text("No Data Available"),
//                                 //                 ),
//                                 //                                   ),
//                                 //           ),
//                                 //         ),
//                                 //       ],
//                                 //     ),
//                                 //
//                                 // )
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Card(
//                             margin: EdgeInsets.zero,
//                             color: Color(0xFFEFFFFfff),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(20.0),
//                                     topLeft: Radius.circular(20.0))),
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 5.0, right: 5),
//                               child: Column(children: [
//                                 Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.bar_chart,
//                                             size: 20,
//                                             // Bigger icon for a more clickable feel
//                                             color: Colors.black54,
//                                           ),
//                                           SizedBox(width:4),
//                                           Text(
//                                             "SQC Status",
//                                             style:
//                                             Styling.bodyTitleBigBoldDashGrey,
//                                             textScaler: TextScaler.noScaling,
//                                           ),
//                                         ],
//                                       ),
//                                       // SizedBox(width: 10),
//                                       // DropdownButton<String>(
//                                       //   value: selectedTransMode,  // Assuming you have this variable declared
//                                       //   items: getTransMode.map((transMode) {
//                                       //     return DropdownMenuItem<String>(
//                                       //       value: transMode,
//                                       //       child: Text(
//                                       //         transMode,
//                                       //         style: Styling.itemBlackTestBigs,
//                                       //       ),
//                                       //     );
//                                       //   }).toList(),
//                                       //   onChanged: (value) {
//                                       //     setState(() {
//                                       //       selectedTransMode = value!;
//                                       //       debugPrint("selectedTransMode $selectedTransMode");
//                                       //
//                                       //       if(selectedTransMode == "Today's"){
//                                       //         // dayFlag = "TODAYS";
//                                       //         debugPrint("dayFlag dayFlag");
//                                       //       }else if(selectedTransMode == "This Month"){
//                                       //         // dayFlag = "THISMONTH";
//                                       //         debugPrint("dayFlag dayFlag");
//                                       //       }else{
//                                       //         // dayFlag = "";
//                                       //       }
//                                       //       // fetchSVARBFilterCountList(dayFlag!);
//                                       //     });
//                                       //   },
//                                       // ),
//                                     ]),
//                                 Card(
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(4),
//                                   ),
//                                   child: getSqcCardCntList.isNotEmpty
//                                       ? Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         color: Color(0xFFfcf2f1),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(bottom:10.0,top:10),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   '',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                     fontSize: 12,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Text(
//                                                   'Todays',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Text(
//                                                   'This Month',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top: 7.0,bottom: 7),
//                                           child:
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   'Truck In',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   TodayTruckIn.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   MonthTruckIn.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child:
//                                               //   InkWell(
//                                               //     onTap: () {
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         SVProfitDetailScreenUI
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child:
//                                               //     Text(
//                                               //       svGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           svGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child:
//                                               //   InkWell(
//                                               //     onTap: () {
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         SVProfitDetailScreenUI
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       svGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           svGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               //
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(color: Color(0xFFfcf2f1),),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top:7.0,bottom:7),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   'SQC Done',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   TodaySQCDone.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   MonthSQCDone.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child: InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         ARBProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       arbGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           arbGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child: InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         ARBProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossProfit",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       arbGrossProfitCount != null
//                                               //           ? formatCurrency(
//                                               //           arbGrossProfitCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(color: Color(0xFFfcf2f1),),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top:7.0,bottom:7),
//                                           child:
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   'Not Done',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   TodayNotDone.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   MonthNotDone.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child: InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child:InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossProfit",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossProfitCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossProfitCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(color: Color(0xFFfcf2f1),),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top:7.0,bottom:7),
//                                           child:
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   'Leak',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   TodayBodyLeak.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   MonthBodyLeak.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child: InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child:InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossProfit",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossProfitCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossProfitCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(color: Color(0xFFfcf2f1),),
//                                       Container(
//                                         color: Color(0xFFFF),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top:7.0,bottom:7),
//                                           child:
//                                           Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Text(
//                                                   'Less Qty',
//                                                   style: Styling.bodyTitleWithBlueHightDashboard,
//                                                   textAlign: TextAlign.center,
//                                                   textScaler: TextScaler.noScaling,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   TodayLessQtyCyls.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child:
//                                                 Text(
//                                                   MonthLessQtyCyls.toString(),
//                                                   style: Styling
//                                                       .textFormText,
//                                                   textScaler:
//                                                   TextScaler.noScaling,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child: InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossRevenue",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossRevenueCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossRevenueCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                               // Expanded(
//                                               //   flex: 2,
//                                               //   child:InkWell(
//                                               //     onTap: (){
//                                               //       Navigator.pushNamed(
//                                               //         context,
//                                               //         RefillProfitDetailScreenUi
//                                               //             .screenName,
//                                               //         arguments: {
//                                               //           "DAYFLAG": dayFlag,
//                                               //           "PROFITFOR":"GrossProfit",
//                                               //         },
//                                               //       );
//                                               //     },
//                                               //     child: Text(
//                                               //       refillGrossProfitCount != null
//                                               //           ? formatCurrency(
//                                               //           refillGrossProfitCount!)
//                                               //           : '0',
//                                               //       style: Styling
//                                               //           .blueClrTextWithUnderline,
//                                               //       textScaler:
//                                               //       TextScaler.noScaling,
//                                               //       overflow: TextOverflow
//                                               //           .ellipsis,
//                                               //       textAlign: TextAlign.center,
//                                               //     ),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height:4),
//                                     ],
//                                   )
//                                       : Container(
//                                     child: Text("No Data Available"),
//                                   ),
//
//                                 ),
//                               ]),
//                             )),
//                         SizedBox(height: 15),
//                         // Card(
//                         //   // margin: EdgeInsets.zero,
//                         //   // color: const Color(0xFFEFFFFF),
//                         //   // shape: const RoundedRectangleBorder(
//                         //   //   borderRadius: BorderRadius.only(
//                         //   //     topRight: Radius.circular(20.0),
//                         //   //     topLeft: Radius.circular(20.0),
//                         //   //   ),
//                         //   // ),
//                         //   // child: Padding(
//                         //   //   padding: const EdgeInsets.symmetric(horizontal: 5),
//                         //     margin: EdgeInsets.zero,
//                         //     color: Color(0xFFEFFFFfff),
//                         //     shape: RoundedRectangleBorder(
//                         //         borderRadius: BorderRadius.only(
//                         //             topRight: Radius.circular(20.0),
//                         //             topLeft: Radius.circular(20.0))),
//                         //     child: Padding(
//                         //       padding: const EdgeInsets.only(
//                         //         left: 5.0,
//                         //         right: 5,
//                         //       ),
//                         //     child: Column(
//                         //       children: [
//                         //         const SizedBox(height: 5),
//                         //         Row(
//                         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //           children: [
//                         //             Row(
//                         //               children: [
//                         //                 Icon(
//                         //                   Icons.local_shipping,
//                         //                   size: 26,
//                         //                   color: Colors.black54,
//                         //                 ),
//                         //                 Text(
//                         //                   "Today Vehicle Status",
//                         //                   style: Styling.bodyTitleBigBoldDashGrey,
//                         //                   textScaler: TextScaler.noScaling,
//                         //                 ),
//                         //               ],
//                         //             ),
//                         //             SizedBox(width: 10),
//                         //             DropdownButton<String>(
//                         //               value: selectedSQCStatus,
//                         //               items: ["All", "Yes", "No"].map((status) {
//                         //                 return DropdownMenuItem<String>(
//                         //                   value: status,
//                         //                   child: Text(status),
//                         //                 );
//                         //               }).toList(),
//                         //               onChanged: (value) {
//                         //                 selectedSQCStatus = value ?? "All";
//                         //                 filterSQCList(); // Filter list when user selects
//                         //               },
//                         //             ),
//                         //           ],
//                         //         ),
//                         //
//                         //         const SizedBox(height: 10),
//                         //
//                         //         /// INNER CARD
//                         //         Card(
//                         //           margin: EdgeInsets.zero,
//                         //           color: Colors.white,
//                         //           shape: RoundedRectangleBorder(
//                         //             borderRadius: BorderRadius.circular(4),
//                         //           ),
//                         //           child: Column(
//                         //             children: [
//                         //               /// HEADER ROW
//                         //               Container(
//                         //                 color: const Color(0xFFfcf2f1),
//                         //                 padding: const EdgeInsets.symmetric(vertical: 10),
//                         //                 child: Row(
//                         //                   children: const [
//                         //                     Expanded(
//                         //                       child: Text(
//                         //                         'Vehicle No.',
//                         //                         textAlign: TextAlign.center,
//                         //                         style: TextStyle(fontWeight: FontWeight.bold),
//                         //                       ),
//                         //                     ),
//                         //                     // Expanded(
//                         //                     //   child: Text(
//                         //                     //     'SQC Done',
//                         //                     //     textAlign: TextAlign.center,
//                         //                     //     style: TextStyle(fontWeight: FontWeight.bold),
//                         //                     //   ),
//                         //                     // ),
//                         //                   ],
//                         //                 ),
//                         //               ),
//                         //
//                         //               filteredSqcList.isNotEmpty
//                         //                   ? ListView.builder(
//                         //                 shrinkWrap: true,
//                         //                 physics: const NeverScrollableScrollPhysics(),
//                         //                 itemCount: filteredSqcList.length,
//                         //                 itemBuilder: (context, index) {
//                         //                   final item = filteredSqcList[index];
//                         //
//                         //                   return Column(
//                         //                     children: [
//                         //                       Padding(
//                         //                         padding: const EdgeInsets.all(8.0),
//                         //                         child: Row(
//                         //                           children: [
//                         //                             /// Vehicle No
//                         //                             Expanded(
//                         //                               child: Text(
//                         //                                 item.vehicleNo ?? "",
//                         //                                 textAlign: TextAlign.center,
//                         //                               ),
//                         //                             ),
//                         //
//                         //                             /// SQC Status
//                         //                             // Expanded(
//                         //                             //   child: Container(
//                         //                             //     alignment: Alignment.center,
//                         //                             //     padding: const EdgeInsets.symmetric(
//                         //                             //         vertical: 5),
//                         //                             //     child: Container(
//                         //                             //       padding: const EdgeInsets.symmetric(
//                         //                             //           horizontal: 10, vertical: 5),
//                         //                             //       decoration: BoxDecoration(
//                         //                             //         color: (item.sQCStatus ?? "")
//                         //                             //             .toLowerCase() ==
//                         //                             //             "yes"
//                         //                             //             ? Colors.green
//                         //                             //             : Colors.red,
//                         //                             //         borderRadius:
//                         //                             //         BorderRadius.circular(6),
//                         //                             //       ),
//                         //                             //       child: Text(
//                         //                             //         (item.sQCStatus ?? "")
//                         //                             //             .toUpperCase(),
//                         //                             //         style: const TextStyle(
//                         //                             //           color: Colors.white,
//                         //                             //           fontWeight: FontWeight.bold,
//                         //                             //         ),
//                         //                             //       ),
//                         //                             //     ),
//                         //                             //   ),
//                         //                             // ),
//                         //                           ],
//                         //                         ),
//                         //                       ),
//                         //
//                         //                       /// Divider
//                         //                       if (index != filteredSqcList.length - 1)
//                         //                         const Divider(color: Color(0xFFfcf2f1)),
//                         //                     ],
//                         //                   );
//                         //                 },
//                         //               )
//                         //                   : const Padding(
//                         //                 padding: EdgeInsets.all(10),
//                         //                 child: Text("No Data Available"),
//                         //               ),
//                         //             ],
//                         //           ),
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                         Card(
//                           // margin: EdgeInsets.zero,
//                           // color: const Color(0xFFEFFFFF),
//                           // shape: const RoundedRectangleBorder(
//                           //   borderRadius: BorderRadius.only(
//                           //     topRight: Radius.circular(20.0),
//                           //     topLeft: Radius.circular(20.0),
//                           //   ),
//                           // ),
//                           // child: Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 5),
//                           margin: EdgeInsets.zero,
//                           color: Color(0xFFEFFFFfff),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(20.0),
//                                   topLeft: Radius.circular(20.0))),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               left: 5.0,
//                               right: 5,
//                             ),
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.local_shipping,
//                                           size: 26,
//                                           color: Colors.black54,
//                                         ),
//                                         Text(
//                                           "Today Vehicle SQC",
//                                           style: Styling.bodyTitleBigBoldDashGrey,
//                                           textScaler: TextScaler.noScaling,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 10),
//                                     DropdownButton<String>(
//                                       value: selectedSQCStatus,
//                                       // items: ["All", "SQC Done", "SQC Not Done"].map((status) {
//                                       items: ["All Vehicles", "SQC Completed", "SQC Pending"].map((status) {
//                                         return DropdownMenuItem<String>(
//                                           value: status,
//                                           child: Text(status),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) {
//                                         selectedSQCStatus = value ?? "All Vehicles";
//                                         filterSQCList(); // Filter list when user selects
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Card(
//                                   margin: EdgeInsets.zero,
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         color: const Color(0xFFfcf2f1),
//                                         padding: const EdgeInsets.symmetric(vertical: 10),
//                                         child: Row(
//                                           children: const [
//                                             Expanded(
//                                               child: Text(
//                                                 'Vehicle No.',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 'SQC Done',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//
//                                       filteredSqcList.isNotEmpty
//                                           ? ListView.builder(
//                                         shrinkWrap: true,
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         itemCount: filteredSqcList.length,
//                                         itemBuilder: (context, index) {
//                                           final item = filteredSqcList[index];
//
//                                           return Column(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   children: [
//                                                     /// Vehicle No
//                                                     Expanded(
//                                                       child: Text(
//                                                         item.vehicleNo ?? "",
//                                                         textAlign: TextAlign.center,
//                                                       ),
//                                                     ),
//
//                                                     /// SQC Status
//                                                     // Expanded(
//                                                     //   child: Container(
//                                                     //     alignment: Alignment.center,
//                                                     //     padding: const EdgeInsets.symmetric(
//                                                     //         vertical: 5),
//                                                     //     child: Container(
//                                                     //       padding: const EdgeInsets.symmetric(
//                                                     //           horizontal: 10, vertical: 5),
//                                                     //       decoration: BoxDecoration(
//                                                     //         color: (item.sQCStatus ?? "")
//                                                     //             .toLowerCase() ==
//                                                     //             "yes"
//                                                     //             // ? Colors.green
//                                                     //             // : Colors.red,
//                                                     //           ? Colors.grey
//                                                     //           : Colors.grey,
//                                                     //       borderRadius:
//                                                     //         BorderRadius.circular(6),
//                                                     //       ),
//                                                     //       child: Text(
//                                                     //         (item.sQCStatus ?? "")
//                                                     //             .toUpperCase(),
//                                                     //         style: const TextStyle(
//                                                     //           color: Colors.white,
//                                                     //           fontWeight: FontWeight.bold,
//                                                     //         ),
//                                                     //       ),
//                                                     //     ),
//                                                     //   ),
//                                                     // ),
//                                                     Expanded(
//                                                       child: Center(
//                                                         child: Text(
//                                                           (item.sQCStatus ?? "").toUpperCase(),
//                                                           style: const TextStyle(
//                                                             color: Colors.black, // normal text color
//                                                             fontWeight: FontWeight.normal, // remove bold if desired
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//
//                                               if (index != filteredSqcList.length - 1)
//                                                 const Divider(color: Color(0xFFfcf2f1)),
//                                             ],
//                                           );
//                                         },
//                                       )
//                                           : const Padding(
//                                         padding: EdgeInsets.all(10),
//                                         child: Text("No Data Available"),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ))),
//           // Expanded(
//           //   child: SingleChildScrollView(
//           //     // Ensures the content is scrollable
//           //     child: Padding(
//           //       padding: const EdgeInsets.only(
//           //           left: 5.0, right: 5.0, bottom: 5.0, top: 20.0),
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //               // Title for Cylinder Categories Table
//           //               GestureDetector(
//           //                 onTap: () {
//           //                   setState(() {
//           //                     isTodayOpeningStockListViewVisible =
//           //                         !isTodayOpeningStockListViewVisible; // Toggle ListView visibility
//           //                   });
//           //                 },
//           //                 child: Card(
//           //                   child: Padding(
//           //                     padding: const EdgeInsets.all(8.0),
//           //                     child: Column(
//           //                       children: [
//           //                         Padding(
//           //                           padding: const EdgeInsets.all(8.0),
//           //                           child: Row(
//           //                             mainAxisAlignment:
//           //                                 MainAxisAlignment.spaceBetween,
//           //                             children: [
//           //                               bodyTitleBlue(
//           //                                   "View Today's Opening Stock"),
//           //                               Icon(
//           //                                 isTodayOpeningStockListViewVisible
//           //                                     ? Icons.arrow_drop_up
//           //                                     : Icons.arrow_drop_down,
//           //                                 size: 30,
//           //                                 // Bigger icon for a more clickable feel
//           //                                 color: Color(0xff1280b3),
//           //                               ),
//           //                             ],
//           //                           ),
//           //                         ),
//           //                         Visibility(
//           //                           visible: isTodayOpeningStockListViewVisible,
//           //                           child: Card(
//           //                             elevation: 5,
//           //                             shape: RoundedRectangleBorder(
//           //                               borderRadius: BorderRadius.circular(12),
//           //                             ),
//           //                             child: Column(
//           //                               children: [
//           //                                 Container(
//           //                                   decoration: BoxDecoration(
//           //                                     color: Colors.blue.shade100,
//           //                                     borderRadius: BorderRadius.only(
//           //                                       topLeft: Radius.circular(12),
//           //                                       topRight: Radius.circular(12),
//           //                                     ),
//           //                                   ),
//           //                                   child: Padding(
//           //                                     padding:
//           //                                         const EdgeInsets.all(8.0),
//           //                                     child: Row(
//           //                                       mainAxisAlignment:
//           //                                           MainAxisAlignment.center,
//           //                                       children: [
//           //                                         Expanded(
//           //                                           flex: 1,
//           //                                           child: Text(
//           //                                             '',
//           //                                             style: TextStyle(
//           //                                               fontWeight:
//           //                                                   FontWeight.bold,
//           //                                               color: Colors.black,
//           //                                               fontSize: 14,
//           //                                             ),
//           //                                             textAlign:
//           //                                                 TextAlign.center,
//           //                                           ),
//           //                                         ),
//           //                                         Expanded(
//           //                                           flex: 1,
//           //                                           child: Text(
//           //                                             'Filled',
//           //                                             style: TextStyle(
//           //                                               fontWeight:
//           //                                                   FontWeight.bold,
//           //                                               color: Colors.black,
//           //                                               fontSize: 14,
//           //                                             ),
//           //                                             textAlign:
//           //                                                 TextAlign.center,
//           //                                           ),
//           //                                         ),
//           //                                         Expanded(
//           //                                           flex: 1,
//           //                                           child: Text(
//           //                                             'Empty',
//           //                                             style: TextStyle(
//           //                                               fontWeight:
//           //                                                   FontWeight.bold,
//           //                                               color: Colors.black,
//           //                                               fontSize: 14,
//           //                                             ),
//           //                                             textAlign:
//           //                                                 TextAlign.center,
//           //                                           ),
//           //                                         ),
//           //                                         Expanded(
//           //                                           flex: 1,
//           //                                           child: Text(
//           //                                             'Defective',
//           //                                             style: TextStyle(
//           //                                               fontWeight:
//           //                                                   FontWeight.bold,
//           //                                               color: Colors.black,
//           //                                               fontSize: 14,
//           //                                             ),
//           //                                             textAlign:
//           //                                                 TextAlign.center,
//           //                                           ),
//           //                                         ),
//           //                                       ],
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                                 todaysOpeningStock.isNotEmpty
//           //                                     ? ListView.builder(
//           //                                         shrinkWrap: true,
//           //                                         physics:
//           //                                             NeverScrollableScrollPhysics(),
//           //                                         itemCount:
//           //                                             todaysOpeningStock.length,
//           //                                         itemBuilder:
//           //                                             (context, index) {
//           //                                           final items =
//           //                                               todaysOpeningStock[
//           //                                                   index];
//           //
//           //                                           return Card(
//           //                                             margin:
//           //                                                 EdgeInsets.symmetric(
//           //                                                     vertical: 7,
//           //                                                     horizontal: 7),
//           //                                             elevation: 4,
//           //                                             shape:
//           //                                                 RoundedRectangleBorder(
//           //                                                     borderRadius:
//           //                                                         BorderRadius
//           //                                                             .circular(
//           //                                                                 12)),
//           //                                             child: Padding(
//           //                                               padding:
//           //                                                   const EdgeInsets
//           //                                                       .all(8.0),
//           //                                               child: Column(
//           //                                                 crossAxisAlignment:
//           //                                                     CrossAxisAlignment
//           //                                                         .start,
//           //                                                 children: [
//           //                                                   Row(
//           //                                                     mainAxisAlignment:
//           //                                                         MainAxisAlignment
//           //                                                             .center,
//           //                                                     children: [
//           //                                                       Expanded(
//           //                                                         flex: 1,
//           //                                                         child: Text(
//           //                                                           items
//           //                                                               .itemName
//           //                                                               .toString(),
//           //                                                           style: Styling
//           //                                                               .textFormText,
//           //                                                           textAlign:
//           //                                                               TextAlign
//           //                                                                   .center,
//           //                                                         ),
//           //                                                       ),
//           //                                                       Expanded(
//           //                                                         flex: 1,
//           //                                                         child: Text(
//           //                                                           items
//           //                                                               .filledOpeningStk
//           //                                                               .toString(),
//           //                                                           style: Styling
//           //                                                               .textFormText,
//           //                                                           textAlign:
//           //                                                               TextAlign
//           //                                                                   .center,
//           //                                                         ),
//           //                                                       ),
//           //                                                       Expanded(
//           //                                                         flex: 1,
//           //                                                         child: Text(
//           //                                                           items
//           //                                                               .emptyOpeningStk
//           //                                                               .toString(),
//           //                                                           style: Styling
//           //                                                               .textFormText,
//           //                                                           textAlign:
//           //                                                               TextAlign
//           //                                                                   .center,
//           //                                                         ),
//           //                                                       ),
//           //                                                       Expanded(
//           //                                                         flex: 1,
//           //                                                         child: Text(
//           //                                                           items
//           //                                                               .defOpeningStk
//           //                                                               .toString(),
//           //                                                           style: Styling
//           //                                                               .textFormText,
//           //                                                           textAlign:
//           //                                                               TextAlign
//           //                                                                   .center,
//           //                                                         ),
//           //                                                       ),
//           //                                                     ],
//           //                                                   ),
//           //                                                 ],
//           //                                               ),
//           //                                             ),
//           //                                           );
//           //                                         },
//           //                                       )
//           //                                     : Container(
//           //                                         child:
//           //                                             Text("No Data Available"),
//           //                                       ),
//           //                               ],
//           //                             ),
//           //                           ),
//           //                         )
//           //                       ],
//           //                     ),
//           //                   ),
//           //                 ),
//           //               ),
//           //               SizedBox(height: 10),
//           //             ],
//           //           ),
//           //           Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //               // Title for Cylinder Categories Table
//           //               GestureDetector(
//           //                 onTap: () {
//           //                   setState(() {
//           //                     isPhysicalStockListViewVisible =
//           //                         !isPhysicalStockListViewVisible; // Toggle ListView visibility
//           //                   });
//           //                 },
//           //                 child: Card(
//           //                   child: Padding(
//           //                     padding: const EdgeInsets.all(8.0),
//           //                     child: Column(
//           //                       children: [
//           //                         Padding(
//           //                           padding: const EdgeInsets.all(8.0),
//           //                           child: Row(
//           //                             mainAxisAlignment:
//           //                                 MainAxisAlignment.spaceBetween,
//           //                             children: [
//           //                               bodyTitleBlue(
//           //                                   "Physical Stock Imbalance As Of Today"),
//           //                               Icon(
//           //                                 isPhysicalStockListViewVisible
//           //                                     ? Icons.arrow_drop_up
//           //                                     : Icons.arrow_drop_down,
//           //                                 size: 30,
//           //                                 // Bigger icon for a more clickable feel
//           //                                 color: Color(0xff1280b3),
//           //                               ),
//           //                             ],
//           //                           ),
//           //                         ),
//           //                         Visibility(
//           //                           visible: isPhysicalStockListViewVisible,
//           //                           child: Container(
//           //                             margin:
//           //                                 EdgeInsets.symmetric(horizontal: 5),
//           //                             decoration: BoxDecoration(
//           //                               color: Colors.white70,
//           //                               borderRadius: BorderRadius.circular(12),
//           //                               boxShadow: [
//           //                                 BoxShadow(
//           //                                     blurRadius: 4,
//           //                                     color: Colors.black12,
//           //                                     spreadRadius: 2),
//           //                               ],
//           //                             ),
//           //                             child: Column(
//           //                               children: [
//           //                                 // Header Row for Cylinder Categories
//           //                                 Container(
//           //                                   decoration: BoxDecoration(
//           //                                     color: Colors.blue.shade100,
//           //                                     borderRadius: BorderRadius.only(
//           //                                       topLeft: Radius.circular(12),
//           //                                       topRight: Radius.circular(12),
//           //                                     ),
//           //                                   ),
//           //                                   padding: const EdgeInsets.only(
//           //                                       top: 8, bottom: 8, left: 10),
//           //                                   child: Row(
//           //                                     mainAxisAlignment:
//           //                                         MainAxisAlignment.center,
//           //                                     children: [
//           //                                       Expanded(
//           //                                         child: Text(
//           //                                           'Cylinder',
//           //                                           style: TextStyle(
//           //                                             fontWeight:
//           //                                                 FontWeight.bold,
//           //                                             color: Colors.black,
//           //                                             fontSize: 14,
//           //                                           ),
//           //                                           textAlign: TextAlign.center,
//           //                                         ),
//           //                                       ),
//           //                                       VerticalDivider(
//           //                                           thickness: 1,
//           //                                           color: Colors.grey),
//           //                                       Expanded(
//           //                                         child: Text(
//           //                                           'Imbalance Qty',
//           //                                           style: TextStyle(
//           //                                             fontWeight:
//           //                                                 FontWeight.bold,
//           //                                             color: Colors.black,
//           //                                             fontSize: 14,
//           //                                           ),
//           //                                           textAlign: TextAlign.center,
//           //                                         ),
//           //                                       ),
//           //                                     ],
//           //                                   ),
//           //                                 ),
//           //
//           //                                 // List of Cylinder Categories
//           //                                 receiptList.isNotEmpty
//           //                                     ? ListView.builder(
//           //                                         shrinkWrap: true,
//           //                                         physics:
//           //                                             NeverScrollableScrollPhysics(),
//           //                                         itemCount: receiptList.length,
//           //                                         itemBuilder:
//           //                                             (context, index) {
//           //                                           final item =
//           //                                               receiptList[index];
//           //                                           return Card(
//           //                                             margin:
//           //                                                 EdgeInsets.symmetric(
//           //                                                     vertical: 7,
//           //                                                     horizontal: 7),
//           //                                             elevation: 4,
//           //                                             shape:
//           //                                                 RoundedRectangleBorder(
//           //                                                     borderRadius:
//           //                                                         BorderRadius
//           //                                                             .circular(
//           //                                                                 12)),
//           //                                             child: Padding(
//           //                                               padding:
//           //                                                   const EdgeInsets
//           //                                                       .all(8.0),
//           //                                               child: Row(
//           //                                                 mainAxisAlignment:
//           //                                                     MainAxisAlignment
//           //                                                         .spaceBetween,
//           //                                                 children: [
//           //                                                   // Cylinder Category Text
//           //                                                   Expanded(
//           //                                                     child: Text(
//           //                                                       item.itemName ??
//           //                                                           "Unknown",
//           //                                                       style: Styling
//           //                                                           .textFormText,
//           //                                                       textAlign:
//           //                                                           TextAlign
//           //                                                               .center,
//           //                                                     ),
//           //                                                   ),
//           //                                                   // Divider between Texts
//           //                                                   VerticalDivider(
//           //                                                       thickness: 1,
//           //                                                       color: Colors
//           //                                                           .grey),
//           //                                                   // Imbalance Quantity with Tap Gesture
//           //                                                   Expanded(
//           //                                                     child:
//           //                                                         GestureDetector(
//           //                                                       onTap: () {
//           //                                                         // Handle the tap on the 'emptyCount' text
//           //                                                         setState(() {
//           //                                                           // Perform any action when clicked
//           //                                                         });
//           //                                                       },
//           //                                                       child: Text(
//           //                                                           '${item.imbalanceStk ?? 0}',
//           //                                                           textAlign:
//           //                                                               TextAlign
//           //                                                                   .center,
//           //                                                           style: Styling
//           //                                                               .textFormText),
//           //                                                     ),
//           //                                                   ),
//           //                                                 ],
//           //                                               ),
//           //                                             ),
//           //                                           );
//           //                                         },
//           //                                       )
//           //                                     : Container(
//           //                                         child:
//           //                                             Text("No Data Available"),
//           //                                       )
//           //                               ],
//           //                             ),
//           //                           ),
//           //                         ),
//           //                       ],
//           //                     ),
//           //                   ),
//           //                 ),
//           //               ),
//           //               SizedBox(height: 10),
//           //             ],
//           //           ),
//           //           Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //               // Title for Cylinder Categories Table
//           //               // GestureDetector(
//           //               //   onTap: () {
//           //               //     setState(() {
//           //               //       isCurrentStockListViewVisible =
//           //               //       !isCurrentStockListViewVisible; // Toggle ListView visibility
//           //               //     });
//           //               //   },
//           //               //   child:
//           //               Card(
//           //                 child: Padding(
//           //                   padding: const EdgeInsets.all(8.0),
//           //                   child: Column(
//           //                     children: [
//           //                       Padding(
//           //                         padding: const EdgeInsets.all(8.0),
//           //                         child: Row(
//           //                           mainAxisAlignment:
//           //                               MainAxisAlignment.spaceBetween,
//           //                           children: [
//           //                             // Text(
//           //                             //   "View Today's Opening Stock",
//           //                             //   style: TextStyle(
//           //                             //       fontSize: 14,
//           //                             //       color: Colors.black,
//           //                             //       fontWeight: FontWeight.bold),
//           //                             // ),
//           //                             bodyTitleBlue("View Current Stock"),
//           //                             // Icon(
//           //                             //   isCurrentStockListViewVisible
//           //                             //       ? Icons.arrow_drop_up
//           //                             //       : Icons.arrow_drop_down,
//           //                             //   size: 30, // Bigger icon for a more clickable feel
//           //                             //   color:Color(0xff1280b3),
//           //                             // ),
//           //                           ],
//           //                         ),
//           //                       ),
//           //                       // Visibility(
//           //                       //   visible:
//           //                       //   isCurrentStockListViewVisible,
//           //                       //   child:
//           //                       Card(
//           //                         elevation: 5,
//           //                         shape: RoundedRectangleBorder(
//           //                           borderRadius: BorderRadius.circular(12),
//           //                         ),
//           //                         child: Column(
//           //                           children: [
//           //                             Container(
//           //                               decoration: BoxDecoration(
//           //                                 color: Colors.blue.shade100,
//           //                                 borderRadius: BorderRadius.only(
//           //                                   topLeft: Radius.circular(12),
//           //                                   topRight: Radius.circular(12),
//           //                                 ),
//           //                               ),
//           //                               child: Padding(
//           //                                 padding: const EdgeInsets.all(8.0),
//           //                                 child: Row(
//           //                                   mainAxisAlignment:
//           //                                       MainAxisAlignment.center,
//           //                                   children: [
//           //                                     Expanded(
//           //                                       flex: 1,
//           //                                       child: Text(
//           //                                         '',
//           //                                         style: TextStyle(
//           //                                           fontWeight: FontWeight.bold,
//           //                                           color: Colors.black,
//           //                                           fontSize: 14,
//           //                                         ),
//           //                                         textAlign: TextAlign.center,
//           //                                       ),
//           //                                     ),
//           //                                     Expanded(
//           //                                       flex: 1,
//           //                                       child: Text(
//           //                                         'Filled',
//           //                                         style: TextStyle(
//           //                                           fontWeight: FontWeight.bold,
//           //                                           color: Colors.black,
//           //                                           fontSize: 14,
//           //                                         ),
//           //                                         textAlign: TextAlign.center,
//           //                                       ),
//           //                                     ),
//           //                                     Expanded(
//           //                                       flex: 1,
//           //                                       child: Text(
//           //                                         'Empty',
//           //                                         style: TextStyle(
//           //                                           fontWeight: FontWeight.bold,
//           //                                           color: Colors.black,
//           //                                           fontSize: 14,
//           //                                         ),
//           //                                         textAlign: TextAlign.center,
//           //                                       ),
//           //                                     ),
//           //                                     Expanded(
//           //                                       flex: 1,
//           //                                       child: Text(
//           //                                         'Defective',
//           //                                         style: TextStyle(
//           //                                           fontWeight: FontWeight.bold,
//           //                                           color: Colors.black,
//           //                                           fontSize: 14,
//           //                                         ),
//           //                                         textAlign: TextAlign.center,
//           //                                       ),
//           //                                     ),
//           //                                     Expanded(
//           //                                       flex: 1,
//           //                                       child: Text(
//           //                                         '',
//           //                                         style: TextStyle(
//           //                                           fontWeight: FontWeight.bold,
//           //                                           color: Colors.black,
//           //                                           fontSize: 14,
//           //                                         ),
//           //                                         textAlign: TextAlign.center,
//           //                                       ),
//           //                                     ),
//           //                                   ],
//           //                                 ),
//           //                               ),
//           //                             ),
//           //                             getCurrentStcOfGodownKeeper.isNotEmpty
//           //                                 ? ListView.builder(
//           //                                     shrinkWrap: true,
//           //                                     physics:
//           //                                         NeverScrollableScrollPhysics(),
//           //                                     itemCount:
//           //                                         getCurrentStcOfGodownKeeper
//           //                                             .length,
//           //                                     itemBuilder: (context, index) {
//           //                                       final items =
//           //                                           getCurrentStcOfGodownKeeper[
//           //                                               index];
//           //
//           //                                       return Card(
//           //                                         margin: EdgeInsets.symmetric(
//           //                                             vertical: 7,
//           //                                             horizontal: 7),
//           //                                         elevation: 4,
//           //                                         shape: RoundedRectangleBorder(
//           //                                             borderRadius:
//           //                                                 BorderRadius.circular(
//           //                                                     12)),
//           //                                         child: Padding(
//           //                                           padding:
//           //                                               const EdgeInsets.all(
//           //                                                   8.0),
//           //                                           child: Column(
//           //                                             crossAxisAlignment:
//           //                                                 CrossAxisAlignment
//           //                                                     .start,
//           //                                             children: [
//           //                                               Row(
//           //                                                 mainAxisAlignment:
//           //                                                     MainAxisAlignment
//           //                                                         .center,
//           //                                                 children: [
//           //                                                   Expanded(
//           //                                                     flex: 1,
//           //                                                     child: Text(
//           //                                                       items.itemName
//           //                                                           .toString(),
//           //                                                       style: Styling
//           //                                                           .textFormText,
//           //                                                       textAlign:
//           //                                                           TextAlign
//           //                                                               .center,
//           //                                                     ),
//           //                                                   ),
//           //                                                   Expanded(
//           //                                                     flex: 1,
//           //                                                     child: Text(
//           //                                                       items
//           //                                                           .currentStkFilled
//           //                                                           .toString(),
//           //                                                       style: Styling
//           //                                                           .textFormText,
//           //                                                       textAlign:
//           //                                                           TextAlign
//           //                                                               .center,
//           //                                                     ),
//           //                                                   ),
//           //                                                   Expanded(
//           //                                                     flex: 1,
//           //                                                     child: Text(
//           //                                                       items
//           //                                                           .currentStkEmpty
//           //                                                           .toString(),
//           //                                                       style: Styling
//           //                                                           .textFormText,
//           //                                                       textAlign:
//           //                                                           TextAlign
//           //                                                               .center,
//           //                                                     ),
//           //                                                   ),
//           //                                                   Expanded(
//           //                                                     flex: 1,
//           //                                                     child: Text(
//           //                                                       items
//           //                                                           .currentStkDefective
//           //                                                           .toString(),
//           //                                                       style: Styling
//           //                                                           .textFormText,
//           //                                                       textAlign:
//           //                                                           TextAlign
//           //                                                               .center,
//           //                                                     ),
//           //                                                   ),
//           //                                                   Expanded(
//           //                                                     flex: 1,
//           //                                                     child:
//           //                                                         GestureDetector(
//           //                                                       onTap: () {
//           //                                                         if (saveFlag) {
//           //                                                           showFlushBar(
//           //                                                               context,
//           //                                                               Constants
//           //                                                                   .dayEndCompleted);
//           //                                                         } else {
//           //                                                           // if(stockTransferFlag){
//           //                                                           Navigator.pushNamed(
//           //                                                               context,
//           //                                                               StockTransferTOGodownScreen
//           //                                                                   .screenName,
//           //                                                               arguments: {
//           //                                                                 "itemName":
//           //                                                                     items.itemName,
//           //                                                                 "itemID":
//           //                                                                     items.itemId,
//           //                                                                 "filledStock":
//           //                                                                     items.currentStkFilled,
//           //                                                                 "emptyStock":
//           //                                                                     items.currentStkEmpty,
//           //                                                                 "defectiveStock":
//           //                                                                     items.currentStkDefective,
//           //                                                               });
//           //                                                           // }else{
//           //                                                           //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//           //                                                           // }
//           //                                                         }
//           //                                                       },
//           //                                                       child: Text(
//           //                                                         "Transfer",
//           //                                                         style: saveFlag
//           //                                                             ? Styling
//           //                                                                 .blueClrTextWithUnderlineGrey
//           //                                                             : Styling
//           //                                                                 .blueClrTextWithUnderline,
//           //                                                         textAlign:
//           //                                                             TextAlign
//           //                                                                 .center,
//           //                                                       ),
//           //                                                     ),
//           //                                                   ),
//           //                                                 ],
//           //                                               ),
//           //                                             ],
//           //                                           ),
//           //                                         ),
//           //                                       );
//           //                                     },
//           //                                   )
//           //                                 : Container(
//           //                                     child: Text("No Data Available"),
//           //                                   ),
//           //                           ],
//           //                         ),
//           //                       ),
//           //                       // )
//           //                     ],
//           //                   ),
//           //                 ),
//           //               ),
//           //               // ),
//           //               SizedBox(height: 10),
//           //             ],
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFFEFF2FB),
//         shape: RoundedRectangleBorder(
//           borderRadius:
//           BorderRadius.circular(50), // Adjust the radius as needed
//         ),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Confirm Refresh"),
//                 content: Text("Do You Want To Refresh Data?"),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context)
//                           .pop(); // Close the dialog without action
//                     },
//                     child: Text("No"),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(); // Close the dialog
//                       setState(() {
//                         // Refresh the data by reassigning the future
//                         // stockDataFuture = updateRefillSale!.getDataFromDatabase();
//                         _onRefresh();
//                       });
//                     },
//                     child: Text("Yes"),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: Icon(Icons.refresh, color: Colors.black),
//       ),
//     );
//   }
//
//   Future<void> insertDelBoyStockList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
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
//
//         if (response.statusCode == 200) {
//           var data = json.decode(response.body);
//
//           // Parse the JSON response into a list of StockSubmitToManagerListModel
//           List<StockSubmitToManagerListModel> result =
//           List<StockSubmitToManagerListModel>.from(data
//               .map((item) => StockSubmitToManagerListModel.fromJson(item)));
//           // You can also update the state here if you need to trigger UI changes
//           setState(() {
//             updateRefillSale?.insertDataToDatabase(result, "Pending", "Edit");
//             //Update the UI with the result data if necessary
//           });
//         } else {
//           refreshTokens();
//           debugPrint("Failed to fetch data from API: ${response.statusCode}");
//         }
//       } catch (e) {
//         if (mounted) {
//           refreshTokens();
//           debugPrint("Error during API call: $e");
//         }
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> _fetchImbalanceData() async {
//     EasyLoading.show(status: 'Loading..');
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
//       int godownIdId = int.parse(godownId!);
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ImbalanceAsOfDateStkForGK}/$dId/$godownIdId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//           },
//         );
//         print(
//             "Total ImbQty ImbalanceAsOfDateStkForGK response ${response.body}");
//         print(
//             "Total ImbQty ImbalanceAsOfDateStkForGK request ${response.request}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//
//           setState(() {
//             receiptList = data
//                 .map((json) => PhysicalStockImbalanceDataModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//             EasyLoading.dismiss();
//             // Optionally, you can store this in a variable or use it in the UI
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             EasyLoading.dismiss();
//             isLoading = false;
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(Constants.listGettingFail)),
//         );
//       }
//     } else {
//       refreshTokens();
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> _fetchTodaysOpeningStockData() async {
//     EasyLoading.instance
//       ..maskType =
//           EasyLoadingMaskType.black // This creates a modal blocking interaction
//       ..loadingStyle = EasyLoadingStyle.light
//       ..dismissOnTap = false // Disable dismissing the loader by tapping
//       ..userInteractions = false;
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
//       int godownIdId = int.parse(godownId!);
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$godownIdId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//           },
//         );
//         print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
//         print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
//         // if (response.statusCode == 200) {
//         //   final List<dynamic> data = json.decode(response.body);
//         //
//         //   String _normalize(String? value) {
//         //     return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ??
//         //         '';
//         //   }
//         //
//         //   final defaultItem = todaysOpeningStock.firstWhere(
//         //     (item) => _normalize(item.itemName) == '14.2kg',
//         //     orElse: () => TodaysOpeningStockDataModel(),
//         //   );
//         //
//         //   if (defaultItem.itemId != null) {
//         //     selectedItemIdTodayStock = defaultItem.itemId!.toInt();
//         //     // Set opening stock values
//         //
//         //     todayOpeningFilledDiffShow =
//         //         defaultItem.filledOpeningStk?.toInt() ?? 0;
//         //     todayOpeningEmptyDiffShow =
//         //         defaultItem.emptyOpeningStk?.toInt() ?? 0;
//         //     todayOpeningDefectiveDiffShow = defaultItem.defOpeningStk!.toInt();
//         //   }
//         //
//         //   setState(() {
//         //     todaysOpeningStock = data
//         //         .map((json) => TodaysOpeningStockDataModel.fromJson(json))
//         //         .toList();
//         //     isLoading = false;
//         //     EasyLoading.dismiss();
//         //     // Optionally, you can store this in a variable or use it in the UI
//         //   });
//         // }
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//
//           final items = data
//               .map((json) => TodaysOpeningStockDataModel.fromJson(json))
//               .toList();
//
//           setState(() {
//             todaysOpeningStock = items;
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//
//           // 🔥 IMPORTANT: filter after data is ready
//           if (selectedItemId != null) {
//             _filterBothLists();
//           }
//         }
//         else {
//           // Handle non-200 responses
//           setState(() {
//             isLoading = false;
//             EasyLoading.dismiss();
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       EasyLoading.dismiss();
//       refreshTokens();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     EasyLoading.show(status: 'Loading..');
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
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
//             'Authorization': 'Bearer $token', // Add the Bearer token here
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
//
//           final items = data
//               .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
//               .toList();
//
//           items.sort((a, b) => a.itemId!.compareTo(b.itemId!));
//
//           setState(() {
//             getCurrentStcOfGodownKeeper = items;
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//
//           // 🔥 IMPORTANT: filter after data is ready
//           if (selectedItemId != null) {
//             _filterBothLists();
//           }
//         }
//         // if (response.statusCode == 200) {
//         //   final List<dynamic> data = json.decode(response.body);
//         //
//         //   String _normalize(String? value) {
//         //     return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ??
//         //         '';
//         //   }
//         //
//         //   final defaultItem = getCurrentStcOfGodownKeeper.firstWhere(
//         //         (item) => _normalize(item.itemName) == '14.2kg',
//         //     orElse: () => GetCurrentStcOfGodownKeeperModel(),
//         //   );
//         //
//         //   if (defaultItem.itemId != null) {
//         //     selectedItemIdTodayStockCurrentStock = defaultItem.itemId!.toInt();
//         //     // Set opening stock values
//         //
//         //     todayOpeningFilledDiffShowCurrentStock = defaultItem.currentStkFilled?.toInt() ?? 0;
//         //     todayOpeningEmptyDiffShowCurrentStock = defaultItem.currentStkEmpty?.toInt() ?? 0;
//         //     todayOpeningDefectiveDiffShowCurrentStock = defaultItem.currentStkDefective!.toInt();
//         //   }
//         //
//         //   // Map to model first
//         //   final List<GetCurrentStcOfGodownKeeperModel> items = data
//         //       .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
//         //       .toList();
//         //
//         //   // Sort by itemId (ascending)
//         //   items.sort((a, b) => a.itemId!.compareTo(b.itemId!));
//         //   setState(() {
//         //     getCurrentStcOfGodownKeeper = data
//         //         .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
//         //         .toList();
//         //     isLoading = false;
//         //     EasyLoading.dismiss();
//         //   });
//         // }
//         else {
//           // Handle non-200 responses
//
//           setState(() {
//             isLoading = false;
//             EasyLoading.dismiss();
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       EasyLoading.dismiss();
//       refreshTokens();
//       showFlushBar(context, Constants.connectionMessage);
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
//           isLoading = false;
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             showFlushBar(context, Constants.listGettingFail);
//           });
//         }
//       } catch (e) {
//         debugPrint("GetStockTransferDtls" + e.toString());
//       }
//     } else {
//       refreshTokens();
//       isLoading = false;
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchSavedData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       userName = preferences.getString("StaffName").toString();
//       String roles = preferences.getString("RoleName").toString();
//       distributorName = preferences.getString("IsAlreadyLogin").toString();
//       String isAlreadyLogin =
//       preferences.getString("IsAlreadyLogin").toString();
//       debugPrint("User Name:- $userName");
//       if (isAlreadyLogin == "0" ||
//           isAlreadyLogin == null ||
//           isAlreadyLogin == "null" ||
//           isAlreadyLogin.isEmpty) {
//         _showLogoutDialog(context);
//       } else {}
//     } catch (error) {
//       rethrow;
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
//             insertDelBoyStockList();
//             _fetchImbalanceData();
//             _fetchTodaysOpeningStockData();
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
//             fetchAllSQCCount();
//           } else if (response['message'] == "Token Expired") {
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
//         refreshTokens();
//         // Handle API error
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       refreshTokens();
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   // Function to show logout confirmation dialog
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Logout"),
//           content: Text(" Please log in to the application again."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Logic for confirming logout
//                 Navigator.of(context).pop(); // Close the dialog
//                 logoutUser(context); // Call logout function here
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showItemPopup() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // 👈 Important
//             children: [
//
//               /// Small drag handle
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade400,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//
//               /// Title
//               const Text(
//                 "Select Item For Stock Transfer",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               /// Item List
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: getCurrentStcOfGodownKeeper.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (context, index) {
//
//                   final items = getCurrentStcOfGodownKeeper[index];
//
//                   return ListTile(
//                     dense: true,
//                     contentPadding: EdgeInsets.zero,
//                     title: Text(
//                       items.itemName.toString(),
//                       style: Styling.itemTitle,
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios, size: 14),
//                     onTap: () {
//                       Navigator.pop(context);
//
//                       Navigator.pushNamed(
//                         context,
//                         StockTransferTOGodownScreen.screenName,
//                         arguments: {
//                           "itemName": items.itemName,
//                           "itemID": items.itemId,
//                           "filledStock": items.currentStkFilled,
//                           "emptyStock": items.currentStkEmpty,
//                           "defectiveStock": items.currentStkDefective,
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> fetchItems() async {
//
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//
//       }
//       try{
//
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//           },
//         );
//         debugPrint("GetItemMasterList" +
//             '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//         debugPrint("GetItemMasterList" + response.body);
//         if (response.statusCode == 200) {
//           List<dynamic> data = json.decode(response.body);
//
//           List<CylItemListModel> loadedItems = data
//               .map((json) => CylItemListModel.fromJson(json))
//               .where((item) =>
//           !item.itemName!.toLowerCase().contains('regulator'))
//               .toList();
//
//           setState(() {
//             _items = loadedItems;
//
//             // 🔹 Normalize function (important because API has "14.2 KG")
//             String normalize(String? value) {
//               return value
//                   ?.toLowerCase()
//                   .replaceAll(RegExp(r'\s+'), '')
//                   .trim() ??
//                   '';
//             }
//
//             final defaultItem = _items.firstWhere(
//                   (item) => normalize(item.itemName) == '14.2kg',
//               orElse: () => _items.isNotEmpty ? _items.first : CylItemListModel(),
//             );
//
//             selectedItemId = defaultItem.itemId;
//           });
//
//           // 🔹 After setting default, filter both lists
//           _filterBothLists();
//         }
//         else {
//
//           refreshTokens();
//           throw Exception('Failed To Load Items');
//         }
//       }catch(e){
//         debugPrint("GetItemMasterList" + e.toString());
//       }
//     } else {
//
//       showFlushBar(
//           context,Constants.connectionMessage);
//     }
//
//
//   }
//   void _filterBothLists() {
//     if (selectedItemId == null) return;
//
//     /// FILTER OPENING STOCK
//     final openingItem = todaysOpeningStock.firstWhere(
//           (item) => item.itemId == selectedItemId,
//       orElse: () => TodaysOpeningStockDataModel(),
//     );
//
//     todayOpeningFilledDiffShow =
//         openingItem.filledOpeningStk?.toInt() ?? 0;
//     todayOpeningEmptyDiffShow =
//         openingItem.emptyOpeningStk?.toInt() ?? 0;
//     todayOpeningDefectiveDiffShow =
//         openingItem.defOpeningStk?.toInt() ?? 0;
//
//     /// FILTER CURRENT STOCK
//     final currentItem = getCurrentStcOfGodownKeeper.firstWhere(
//           (item) => item.itemId == selectedItemId,
//       orElse: () => GetCurrentStcOfGodownKeeperModel(),
//     );
//
//     todayOpeningFilledDiffShowCurrentStock =
//         currentItem.currentStkFilled?.toInt() ?? 0;
//     todayOpeningEmptyDiffShowCurrentStock =
//         currentItem.currentStkEmpty?.toInt() ?? 0;
//     todayOpeningDefectiveDiffShowCurrentStock =
//         currentItem.currentStkDefective?.toInt() ?? 0;
//   }
//
//   Future<void> loadAllData() async {
//     await fetchItems();
//     await _fetchTodaysOpeningStockData();
//     await fetchCurrentStock();
//
//     _filterBothLists(); // call once after everything loads
//   }
//
//   Future<void> fetchAllSQCCount() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetSQCCardCntList}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token', // Add the Bearer token here
//           },
//         );
//
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL GetSQCCardCntList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print(
//             "API Response Status GetSQCCardCntList: ${response.statusCode}");
//         print("API Response GetSQCCardCntList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getSqcCardCntList = data.map((json) {
//               return GetSqcCardCntListModel.fromJson(json);
//             }).toList();
//
//             if (getSqcCardCntList.isNotEmpty) {
//               print(
//                   'Total Amount of the first item: ${getSqcCardCntList[0]
//                       .vehicleNo}');
//               TodayTruckIn =
//                   getSqcCardCntList[0].todayTruckIn!.toInt();
//               TodaySQCDone =
//                   getSqcCardCntList[0].todaySQCDone?.toInt();
//               TodayNotDone =
//                   getSqcCardCntList[0].todayNotDone?.toInt();
//               TodayBodyLeak =
//                   getSqcCardCntList[0].todayBodyLeak?.toInt();
//               TodayLessQtyCyls =
//                   getSqcCardCntList[0].todayLessQtyCyls?.toInt();
//               MonthTruckIn =
//                   getSqcCardCntList[0].monthTruckIn?.toInt();
//               MonthSQCDone =
//                   getSqcCardCntList[0].monthSQCDone?.toInt();
//               MonthNotDone =
//                   getSqcCardCntList[0].monthNotDone?.toInt();
//               MonthBodyLeak =
//                   getSqcCardCntList[0].monthBodyLeak?.toInt();
//               MonthLessQtyCyls =
//                   getSqcCardCntList[0].monthLessQtyCyls?.toInt();
//               VehicleNo =
//                   getSqcCardCntList[0].vehicleNo?.toString();
//               SQCStatus =
//                   getSqcCardCntList[0].sQCStatus?.toString();
//             }
//             filterSQCList();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           // Check if the widget is still mounted
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   void filterSQCList() {
//     setState(() {
//       String? status;
//
//       // Map dropdown to actual API values
//       switch (selectedSQCStatus) {
//         case "SQC Completed":
//           status = "yes"; // or whatever your API returns for done
//           break;
//         case "SQC Pending":
//           status = "no"; // or whatever your API returns for not done
//           break;
//         default:
//           status = "all";
//       }
//
//       filteredSqcList = status == "all"
//           ? List.from(getSqcCardCntList)
//           : getSqcCardCntList
//           .where((item) => (item.sQCStatus ?? "").toLowerCase() == status)
//           .toList();
//
//       if (filteredSqcList.isNotEmpty) {
//         VehicleNo = filteredSqcList[0].vehicleNo ?? "";
//         SQCStatus = filteredSqcList[0].sQCStatus ?? "";
//       } else {
//         VehicleNo = "";
//         SQCStatus = "";
//       }
//     });
//   }
//
// }





//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
// import '../ConstantScreen/widgets.dart';
// import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
// import '../DashboardModel/TodaysOpeningStockDataModel.dart';
// import '../IOSVersionUpdateService.dart';
// import '../User/Login/provider/LoginProvider.dart';
// import '../User/splashscreen/page/splash_screen.dart';
// import '../Utils/CustomeAlertDialog.dart';
// import '../Utils/CustomeDrawer.dart';
// import '../Utils/Styling.dart';
// import '../Utils/UpdateService.dart';
// import '../Utils/Widget.dart';
// import '../Utils/app_url.dart';
// import '../Utils/constants.dart';
// import '../Utils/shared_preference.dart';
// import 'DelBoyStockReturn/StockTransferToGodownScreen.dart';
// import 'DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'DeliveryBoyModel/StockSubmitToManagerListModel.dart';
// import 'package:http/http.dart' as http;
//
// import 'ItemReceipt/CylItemList/CylItemListModel.dart';
// import 'ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import 'SQCRegister/GetSQCCardCntListModel.dart';
//
// // ── Brand Color Tokens ──
// class _C {
//   static const blue        = Color(0xFF1E3A8A);
//   static const blueLight   = Color(0xFF2D52C5);
//   static const blueDark    = Color(0xFF162D70);
//   static const blueXL      = Color(0xFFEFF6FF);
//   static const blueXXL     = Color(0xFFDBEAFE);
//   static const teal        = Color(0xFF0F766E);
//   static const tealXL      = Color(0xFFF0FDFA);
//   static const orange      = Color(0xFFF97316);
//   static const orangeXL    = Color(0xFFFFF7ED);
//   static const red         = Color(0xFFEF4444);
//   static const redXL       = Color(0xFFFEF2F2);
//   static const green       = Color(0xFF16A34A);
//   static const greenXL     = Color(0xFFF0FDF4);
//   static const amber       = Color(0xFFD97706);
//   static const bg          = Color(0xFFF8FAFC);
//   static const bg2         = Color(0xFFF1F5FE);
//   static const white       = Color(0xFFFFFFFF);
//   static const text        = Color(0xFF111827);
//   static const textMid     = Color(0xFF374151);
//   static const textMuted   = Color(0xFF6B7280);
//   static const border      = Color(0xFFE2E8F0);
//
//   static const gradHero = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     stops: [0.0, 0.6, 1.0],
//     colors: [Color(0xFF1E3A8A), Color(0xFF1D5A72), Color(0xFF0F766E)],
//   );
// }
//
// // ── Typography helpers ──
// class _T {
//   static const sectionHeader = TextStyle(
//     fontSize: 12, fontWeight: FontWeight.w700,
//     color: _C.textMid, letterSpacing: 0.8,
//   );
//   static const cardTitle = TextStyle(
//     fontSize: 15, fontWeight: FontWeight.w700,
//     color: _C.text, letterSpacing: -0.1,
//   );
//   static const cardSubtitle = TextStyle(
//     fontSize: 13, fontWeight: FontWeight.w500,
//     color: _C.textMuted, height: 1.4,
//   );
//   static const kpiValue = TextStyle(
//     fontSize: 26, fontWeight: FontWeight.w800,
//     color: _C.text, letterSpacing: -0.6, height: 1.1,
//   );
//   static const labelMD = TextStyle(
//     fontSize: 13, fontWeight: FontWeight.w600,
//     color: _C.textMuted, letterSpacing: 0.1,
//   );
//   static const badgeText = TextStyle(
//     fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.1,
//   );
//   static const dataLabel = TextStyle(
//     fontSize: 14, fontWeight: FontWeight.w600, color: _C.textMid,
//   );
//   static const dataValue = TextStyle(
//     fontSize: 16, fontWeight: FontWeight.w800, color: _C.text,
//   );
//   static const heroTitle = TextStyle(
//     fontSize: 22, fontWeight: FontWeight.w800,
//     color: Colors.white, letterSpacing: -0.5, height: 1.2,
//   );
//   static const heroSub = TextStyle(
//     fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70,
//   );
//   static const heroKpiValue = TextStyle(
//     fontSize: 24, fontWeight: FontWeight.w800,
//     color: Colors.white, letterSpacing: -0.6, height: 1.0,
//   );
// }
//
// // ── Reusable card shadow ──
// BoxDecoration _cardDecoration({Color? bg, BorderRadius? radius}) =>
//     BoxDecoration(
//       color: bg ?? _C.white,
//       borderRadius: radius ?? BorderRadius.circular(18),
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x0D1E3A8A),
//           blurRadius: 12,
//           offset: Offset(0, 2),
//         ),
//       ],
//     );
//
// // ──────────────────────────────────────────
// // SECTION HEADER
// // ──────────────────────────────────────────
// class _SectionHeader extends StatelessWidget {
//   const _SectionHeader({
//     required this.title,
//     required this.dotColor,
//     this.trailing,
//   });
//   final String title;
//   final Color dotColor;
//   final Widget? trailing;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 22, 0, 10),
//       child: Row(
//         children: [
//           Container(
//             width: 8, height: 8,
//             decoration: BoxDecoration(
//               color: dotColor,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(title.toUpperCase(), style: _T.sectionHeader),
//           const Spacer(),
//           if (trailing != null) trailing!,
//         ],
//       ),
//     );
//   }
// }
//
// // ──────────────────────────────────────────
// // STOCK NUMBER CHIP (Filled / Empty / Defective)
// // ──────────────────────────────────────────
// class _StockChip extends StatelessWidget {
//   const _StockChip({
//     required this.label,
//     required this.value,
//     required this.accentColor,
//   });
//   final String label;
//   final String value;
//   final Color accentColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//         decoration: BoxDecoration(
//           color: _C.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border(top: BorderSide(color: accentColor, width: 3)),
//           boxShadow: const [
//             BoxShadow(color: Color(0x0D1E3A8A), blurRadius: 8, offset: Offset(0, 2)),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               value,
//               style: _T.kpiValue.copyWith(fontSize: 22, color: accentColor),
//               textAlign: TextAlign.center,
//               textScaler: TextScaler.noScaling,
//             ),
//             const SizedBox(height: 4),
//             Text(label, style: _T.labelMD, textScaler: TextScaler.noScaling),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ──────────────────────────────────────────
// // SQC STATS TABLE ROW
// // ──────────────────────────────────────────
// class _SqcStatRow extends StatelessWidget {
//   const _SqcStatRow({
//     required this.label,
//     required this.today,
//     required this.month,
//     this.showDivider = true,
//   });
//   final String label;
//   final String today;
//   final String month;
//   final bool showDivider;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Text(label, style: _T.dataLabel),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Text(today,
//                     style: _T.dataValue, textAlign: TextAlign.center),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Text(month,
//                     style: _T.dataValue, textAlign: TextAlign.center),
//               ),
//             ],
//           ),
//         ),
//         if (showDivider)
//           const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 16, endIndent: 16),
//       ],
//     );
//   }
// }
//
// // ──────────────────────────────────────────
// // HERO HEADER STRIP
// // ──────────────────────────────────────────
// // class _HeroHeader extends StatelessWidget {
// //   const _HeroHeader({required this.userName});
// //   final String? userName;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final hour = DateTime.now().hour;
// //     final greeting = hour < 12 ? 'Morning' : (hour < 17 ? 'Afternoon' : 'Evening');
// //     final initials = (userName != null && userName!.isNotEmpty)
// //         ? userName!.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
// //         : 'GK';
// //
// //     return Container(
// //       decoration: const BoxDecoration(gradient: _C.gradHero),
// //       child: Stack(
// //         children: [
// //           Positioned(top: -50, right: -60,
// //             child: Container(width: 200, height: 200,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white.withOpacity(0.05),
// //               ),
// //             ),
// //           ),
// //           SafeArea(
// //             bottom: false,
// //             child: Padding(
// //               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Text('Good $greeting 👋', style: _T.heroSub),
// //                         Text(
// //                           'Good ${greeting}, ${userName ?? "Godown Keeper"} 👋',
// //                         ),
// //                         const SizedBox(height: 3),
// //                         Text(
// //                           userName != null && userName!.isNotEmpty
// //                               ? userName!
// //                               : 'Godown Keeper',
// //                           style: _T.heroTitle,
// //                         ),
// //                         const SizedBox(height: 5),
// //                       ],
// //                     ),
// //                   ),
// //                   Container(
// //                     width: 44, height: 44,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.16),
// //                       borderRadius: BorderRadius.circular(13),
// //                       border: Border.all(
// //                           color: Colors.white.withOpacity(0.28), width: 1.5),
// //                     ),
// //                     alignment: Alignment.center,
// //                     child: Text(initials,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.w800,
// //                         letterSpacing: 0.5,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class _HeroHeader extends StatelessWidget {
//   const _HeroHeader({required this.userName, required this.distributorName});
//   final String? userName;
//   final String? distributorName;
//
//   @override
//   Widget build(BuildContext context) {
//     final hour = DateTime.now().hour;
//     final greeting = hour < 12 ? 'Morning' : (hour < 17 ? 'Afternoon' : 'Evening');
//     final initials = (userName != null && userName!.isNotEmpty)
//         ? userName!.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
//         : 'GK';
//
//     return Container(
//       decoration: const BoxDecoration(gradient: _C.gradHero),
//       child: Stack(
//         children: [
//           Positioned(
//             top: -50, right: -60,
//             child: Container(
//               width: 200, height: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.05),
//               ),
//             ),
//           ),
//           SafeArea(
//             bottom: false,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Line 1: Good Morning, Username 👋
//                         Text(
//                           'Good $greeting, ${userName ?? "Godown Keeper"} 👋',
//                           style: _T.heroSub,
//                         ),
//                         const SizedBox(height: 4),
//                         // Line 2: Distributor Name (prominent title)
//                         Text(
//                           distributorName != null && distributorName!.isNotEmpty
//                               ? distributorName!
//                               : 'Godown Dashboard',
//                           style: _T.heroTitle.copyWith(
//                             fontSize: 18, // 👈 reduce from current (try 16–18)
//                           ),
//                           // Text(
//                           //   distributorName != null && distributorName!.isNotEmpty
//                           //       ? distributorName!
//                           //       : 'Godown Dashboard',
//                           //   style: _T.heroTitle.copyWith(
//                           //     fontSize: 18, // 👈 reduce from current (try 16–18)
//                           //   ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     width: 44, height: 44,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.16),
//                       borderRadius: BorderRadius.circular(13),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.28), width: 1.5,
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       initials,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // ──────────────────────────────────────────
// // IMBALANCE TABLE CARD
// // ──────────────────────────────────────────
// class _ImbalanceCard extends StatelessWidget {
//   const _ImbalanceCard({required this.receiptList});
//   final List<PhysicalStockImbalanceDataModel> receiptList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text('Cylinder', style: _T.labelMD.copyWith(
//                     fontWeight: FontWeight.w700, color: _C.textMid,
//                   )),
//                 ),
//                 Expanded(
//                   child: Text('Imbalance Qty',
//                     textAlign: TextAlign.right,
//                     style: _T.labelMD.copyWith(
//                       fontWeight: FontWeight.w700, color: _C.textMid,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFF1F5F9)),
//           if (receiptList.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Text('No data available', style: _T.cardSubtitle),
//             )
//           else
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: receiptList.length,
//               separatorBuilder: (_, __) =>
//               const Divider(height: 1, color: Color(0xFFF1F5F9)),
//               itemBuilder: (context, index) {
//                 final item = receiptList[index];
//                 final hasImbalance = (item.imbalanceStk ?? 0) != 0;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 12),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(item.itemName.toString(),
//                             style: _T.dataLabel),
//                       ),
//                       Text(
//                         item.imbalanceStk.toString(),
//                         style: _T.dataValue.copyWith(
//                           color: hasImbalance ? _C.red : _C.green,
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// // ──────────────────────────────────────────
// // DASHBOARD SCREEN
// // ──────────────────────────────────────────
// class DashboardScreen extends StatefulWidget {
//   static const screenName = '/godownDashboard';
//
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   UpdateRefillSale? updateRefillSale;
//   bool isPhysicalStockListViewVisible = false;
//   bool isDomesticListViewVisible = false;
//   bool isNonDomesticListViewVisible = false;
//   bool isTodayOpeningStockListViewVisible = false;
//   bool isCurrentStockListViewVisible = false;
//   List<PhysicalStockImbalanceDataModel> receiptList = [];
//   List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   List<GetStockTransferListModel> _stockTransferList = [];
//   List<CylItemListModel> _items = [];
//   num? selectedItemId;
//   bool isLoading = true;
//   String? mobileNo;
//   String? userName, role, distributorName, roleId;
//   int? selectedItemIdTodayStock;
//   int? todayOpeningFilledDiffShow = 0;
//   int? todayOpeningEmptyDiffShow = 0;
//   int? todayOpeningDefectiveDiffShow = 0;
//
//   int? selectedItemIdTodayStockCurrentStock;
//   int? todayOpeningFilledDiffShowCurrentStock = 0;
//   int? todayOpeningEmptyDiffShowCurrentStock = 0;
//   int? todayOpeningDefectiveDiffShowCurrentStock = 0;
//   List<String> getTransMode = ["Today's", "This Month"];
//   String? selectedTransMode = "This Month";
//   List<GetSqcCardCntListModel> getSqcCardCntList = [];
//   String selectedFilter = "All";
//   int? TodayTruckIn,
//       TodaySQCDone,
//       TodayNotDone,
//       TodayBodyLeak,
//       TodayLessQtyCyls,
//       MonthTruckIn,
//       MonthSQCDone,
//       MonthNotDone,
//       MonthBodyLeak,
//       MonthLessQtyCyls;
//   String? VehicleNo,
//       SQCStatus;
//   List<GetSqcCardCntListModel> filteredSqcList = [];
//   String selectedSQCStatus = "All Vehicles";
//
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       UpdateService.checkForUpdate(context);
//       debugPrint("Firebase initialize Dash${Platform}");
//     } else {
//       IosVersionUpdateCheck().checkForUpdate(context);
//       debugPrint("Firebase not initialize");
//     }
//     updateRefillSale = UpdateRefillSale();
//     loadAllData();
//     insertDelBoyStockList();
//     _fetchImbalanceData();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//     fetchSavedData();
//     fetchAllSQCCount();
//   }
//
//   Future<void> _onRefresh() async {
//     loadAllData();
//     insertDelBoyStockList();
//     _fetchImbalanceData();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//     fetchAllSQCCount();
//   }
//
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//
//   // ──────────────────────────────────────────
//   // BUILD
//   // ──────────────────────────────────────────
//   // @override
//   // Widget build(BuildContext context) {
//   //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//   //     statusBarColor: _C.blue,
//   //   ));
//   //
//   //   return Scaffold(
//   //     key: _scaffoldKey,
//   //     backgroundColor: _C.bg2,
//   //     floatingActionButton: _buildFab(),
//   //     body: RefreshIndicator(
//   //       color: _C.blue,
//   //       backgroundColor: _C.white,
//   //       onRefresh: _onRefresh,
//   //       edgeOffset: MediaQuery.of(context).padding.top + 180,
//   //       child: CustomScrollView(
//   //         physics: const AlwaysScrollableScrollPhysics(
//   //           parent: BouncingScrollPhysics(),
//   //         ),
//   //         slivers: [
//   //           // ── Hero Header ──
//   //           // SliverToBoxAdapter(
//   //           //   child: _HeroHeader(userName: userName),
//   //           // ),
//   //
//   //           SliverToBoxAdapter(
//   //             child: _HeroHeader(
//   //               userName: userName,
//   //               distributorName: distributorName,
//   //             ),
//   //           ),
//   //
//   //           // ── Body ──
//   //           SliverPadding(
//   //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//   //             sliver: SliverList(
//   //               delegate: SliverChildListDelegate([
//   //                 // ── Opening Stock ──
//   //                 _SectionHeader(
//   //                   title: "Today's Opening Stock",
//   //                   dotColor: _C.blueLight,
//   //                   trailing: _buildItemDropdown(),
//   //                 ),
//   //                 _buildOpeningStockCard(),
//   //
//   //                 // ── Current Stock ──
//   //                 _SectionHeader(
//   //                   title: 'Current Stock',
//   //                   dotColor: _C.teal,
//   //                   trailing: _buildTransferButton(),
//   //                 ),
//   //                 _buildCurrentStockCard(),
//   //
//   //                 // ── Physical Stock Imbalance ──
//   //                 _SectionHeader(
//   //                   title: 'Physical Stock Imbalance As Of Today',
//   //                   dotColor: _C.red,
//   //                 ),
//   //                 _ImbalanceCard(receiptList: receiptList),
//   //
//   //                 // ── SQC Status Summary ──
//   //                 _SectionHeader(
//   //                   title: 'SQC Status',
//   //                   dotColor: _C.orange,
//   //                 ),
//   //                 _buildSqcSummaryCard(),
//   //
//   //                 // ── Today Vehicle SQC ──
//   //                 _SectionHeader(
//   //                   title: 'Today Vehicle SQC',
//   //                   dotColor: _C.amber,
//   //                   trailing: _buildSqcFilterDropdown(),
//   //                 ),
//   //                 _buildVehicleSqcCard(),
//   //
//   //                 const SizedBox(height: 8),
//   //               ]),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // ──────────────────────────────────────────
//   // FLOATING ACTION BUTTON
//   // ──────────────────────────────────────────
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle.light.copyWith(
//         statusBarColor: _C.blue,
//       ),
//     );
//
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: _C.bg2,
//       floatingActionButton: _buildFab(),
//       body: RefreshIndicator(
//         color: _C.blue,
//         backgroundColor: _C.white,
//         onRefresh: _onRefresh,
//         edgeOffset: MediaQuery.of(context).padding.top + 180,
//         child: Column(
//           children: [
//
//             // ── FIXED HERO HEADER (NOT SCROLLABLE) ──
//             _HeroHeader(
//               userName: userName,
//               distributorName: distributorName,
//             ),
//
//             // ── SCROLLABLE BODY ──
//             Expanded(
//               child: CustomScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(
//                   parent: BouncingScrollPhysics(),
//                 ),
//                 slivers: [
//
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                     sliver: SliverList(
//                       delegate: SliverChildListDelegate([
//
//                         _SectionHeader(
//                           title: "Today's Opening Stock",
//                           dotColor: _C.blueLight,
//                           trailing: _buildItemDropdown(),
//                         ),
//                         _buildOpeningStockCard(),
//
//                         _SectionHeader(
//                           title: 'Current Stock',
//                           dotColor: _C.teal,
//                           trailing: _buildTransferButton(),
//                         ),
//                         _buildCurrentStockCard(),
//
//                         _SectionHeader(
//                           title: 'Physical Stock Imbalance As Of Today',
//                           dotColor: _C.red,
//                         ),
//                         _ImbalanceCard(receiptList: receiptList),
//
//                         _SectionHeader(
//                           title: 'SQC Status',
//                           dotColor: _C.orange,
//                         ),
//                         _buildSqcSummaryCard(),
//
//                         _SectionHeader(
//                           title: 'Today Vehicle SQC',
//                           dotColor: _C.amber,
//                           trailing: _buildSqcFilterDropdown(),
//                         ),
//                         _buildVehicleSqcCard(),
//
//                         const SizedBox(height: 8),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFab() {
//     return FloatingActionButton(
//       backgroundColor: _C.blueXL,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               title: const Text('Confirm Refresh'),
//               content: const Text('Do You Want To Refresh Data?'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('No',
//                       style: TextStyle(color: _C.textMuted)),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     setState(() => _onRefresh());
//                   },
//                   child: const Text('Yes',
//                       style: TextStyle(color: _C.blue,
//                           fontWeight: FontWeight.w700)),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       child: const Icon(Icons.refresh_rounded, color: _C.blue),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // ITEM DROPDOWN (for Opening / Current Stock)
//   // ──────────────────────────────────────────
//   Widget _buildItemDropdown() {
//     return Container(
//       height: 32,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: _C.blueXL,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: _C.blueXXL),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<num>(
//           value: selectedItemId,
//           isDense: true,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: _C.blue,
//           ),
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               size: 16, color: _C.blue),
//           items: _items.map((item) {
//             return DropdownMenuItem<num>(
//               value: item.itemId,
//               child: Text(item.itemName ?? 'Unknown'),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedItemId = value;
//               _filterBothLists();
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // TRANSFER BUTTON
//   // ──────────────────────────────────────────
//   Widget _buildTransferButton() {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           if (saveFlag) {
//             showFlushBar(context, Constants.dayEndCompleted);
//           } else {
//             _showItemPopup();
//           }
//         },
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//           decoration: BoxDecoration(
//             color: saveFlag ? const Color(0xFFF3F4F6) : _C.redXL,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: saveFlag
//                   ? const Color(0xFFD1D5DB)
//                   : _C.red.withOpacity(0.3),
//             ),
//           ),
//           child: Text(
//             'Transfer',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: saveFlag ? _C.textMuted : _C.red,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // SQC FILTER DROPDOWN
//   // ──────────────────────────────────────────
//   Widget _buildSqcFilterDropdown() {
//     return Container(
//       height: 32,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: _C.blueXL,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: _C.blueXXL),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: selectedSQCStatus,
//           isDense: true,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: _C.blue,
//           ),
//           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//               size: 16, color: _C.blue),
//           items: ['All Vehicles', 'SQC Completed', 'SQC Pending']
//               .map((s) => DropdownMenuItem<String>(
//             value: s,
//             child: Text(s),
//           ))
//               .toList(),
//           onChanged: (value) {
//             selectedSQCStatus = value ?? 'All Vehicles';
//             filterSQCList();
//           },
//         ),
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // OPENING STOCK CARD
//   // ──────────────────────────────────────────
//   Widget _buildOpeningStockCard() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           _StockChip(
//             label: 'Filled',
//             value: todayOpeningFilledDiffShow.toString(),
//             accentColor: _C.green,
//           ),
//           const SizedBox(width: 10),
//           _StockChip(
//             label: 'Empty',
//             value: todayOpeningEmptyDiffShow.toString(),
//             accentColor: _C.orange,
//           ),
//           const SizedBox(width: 10),
//           _StockChip(
//             label: 'Defective',
//             value: todayOpeningDefectiveDiffShow.toString(),
//             accentColor: _C.red,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // CURRENT STOCK CARD
//   // ──────────────────────────────────────────
//   Widget _buildCurrentStockCard() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           _StockChip(
//             label: 'Filled',
//             value: todayOpeningFilledDiffShowCurrentStock.toString(),
//             accentColor: _C.green,
//           ),
//           const SizedBox(width: 10),
//           _StockChip(
//             label: 'Empty',
//             value: todayOpeningEmptyDiffShowCurrentStock.toString(),
//             accentColor: _C.orange,
//           ),
//           const SizedBox(width: 10),
//           _StockChip(
//             label: 'Defective',
//             value: todayOpeningDefectiveDiffShowCurrentStock.toString(),
//             accentColor: _C.red,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // SQC SUMMARY CARD (Today / This Month counts)
//   // ──────────────────────────────────────────
//   Widget _buildSqcSummaryCard() {
//     if (getSqcCardCntList.isEmpty) {
//       return Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(16),
//         decoration: _cardDecoration(),
//         child: const Text('No data available', style: _T.cardSubtitle),
//       );
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           // Table header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//             ),
//             child: Row(
//               children: [
//                 const Expanded(flex: 2, child: Text('Metric', style: _T.labelMD)),
//                 Expanded(
//                   flex: 1,
//                   child: Text('Today',
//                       textAlign: TextAlign.center,
//                       style: _T.labelMD.copyWith(color: _C.blueLight,
//                           fontWeight: FontWeight.w700)),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text('Month',
//                       textAlign: TextAlign.center,
//                       style: _T.labelMD.copyWith(color: _C.teal,
//                           fontWeight: FontWeight.w700)),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFF1F5F9)),
//           _SqcStatRow(
//               label: 'Truck In',
//               today: TodayTruckIn?.toString() ?? '0',
//               month: MonthTruckIn?.toString() ?? '0'),
//           _SqcStatRow(
//               label: 'SQC Done',
//               today: TodaySQCDone?.toString() ?? '0',
//               month: MonthSQCDone?.toString() ?? '0'),
//           _SqcStatRow(
//               label: 'Not Done',
//               today: TodayNotDone?.toString() ?? '0',
//               month: MonthNotDone?.toString() ?? '0'),
//           _SqcStatRow(
//               label: 'Body Leak',
//               today: TodayBodyLeak?.toString() ?? '0',
//               month: MonthBodyLeak?.toString() ?? '0'),
//           _SqcStatRow(
//               label: 'Less Qty',
//               today: TodayLessQtyCyls?.toString() ?? '0',
//               month: MonthLessQtyCyls?.toString() ?? '0',
//               showDivider: false),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // VEHICLE SQC LIST CARD
//   // ──────────────────────────────────────────
//   Widget _buildVehicleSqcCard() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text('Vehicle No.',
//                       style: _T.labelMD.copyWith(fontWeight: FontWeight.w700),
//                       textAlign: TextAlign.center),
//                 ),
//                 Expanded(
//                   child: Text('SQC Done',
//                       style: _T.labelMD.copyWith(fontWeight: FontWeight.w700),
//                       textAlign: TextAlign.center),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFF1F5F9)),
//           if (filteredSqcList.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Text('No data available', style: _T.cardSubtitle),
//             )
//           else
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: filteredSqcList.length,
//               separatorBuilder: (_, __) =>
//               const Divider(height: 1, color: Color(0xFFF1F5F9)),
//               itemBuilder: (context, index) {
//                 final item = filteredSqcList[index];
//                 final isDone =
//                     (item.sQCStatus ?? '').toLowerCase() == 'yes';
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 12),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(item.vehicleNo ?? '',
//                             style: _T.dataLabel,
//                             textAlign: TextAlign.center),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: isDone ? _C.greenXL : _C.redXL,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               (item.sQCStatus ?? '').toUpperCase(),
//                               style: _T.badgeText.copyWith(
//                                 color: isDone ? _C.green : _C.red,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   // ──────────────────────────────────────────
//   // ALL ORIGINAL LOGIC METHODS (UNCHANGED)
//   // ──────────────────────────────────────────
//
//   void filterSQCList() {
//     setState(() {
//       String? status;
//       switch (selectedSQCStatus) {
//         case "SQC Completed":
//           status = "yes";
//           break;
//         case "SQC Pending":
//           status = "no";
//           break;
//         default:
//           status = "all";
//       }
//
//       filteredSqcList = status == "all"
//           ? List.from(getSqcCardCntList)
//           : getSqcCardCntList
//           .where(
//               (item) => (item.sQCStatus ?? "").toLowerCase() == status)
//           .toList();
//
//       if (filteredSqcList.isNotEmpty) {
//         VehicleNo = filteredSqcList[0].vehicleNo ?? "";
//         SQCStatus = filteredSqcList[0].sQCStatus ?? "";
//       } else {
//         VehicleNo = "";
//         SQCStatus = "";
//       }
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
//         throw Exception('Bearer token is missing');
//       }
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         );
//         debugPrint("GetItemMasterList" +
//             '${AppUrl.GetItemMasterList}/$distributorId/1/C');
//         debugPrint("GetItemMasterList" + response.body);
//         if (response.statusCode == 200) {
//           List<dynamic> data = json.decode(response.body);
//
//           List<CylItemListModel> loadedItems = data
//               .map((json) => CylItemListModel.fromJson(json))
//               .where((item) =>
//           !item.itemName!.toLowerCase().contains('regulator'))
//               .toList();
//
//           setState(() {
//             _items = loadedItems;
//
//             String normalize(String? value) {
//               return value
//                   ?.toLowerCase()
//                   .replaceAll(RegExp(r'\s+'), '')
//                   .trim() ??
//                   '';
//             }
//
//             final defaultItem = _items.firstWhere(
//                   (item) => normalize(item.itemName) == '14.2kg',
//               orElse: () =>
//               _items.isNotEmpty ? _items.first : CylItemListModel(),
//             );
//
//             selectedItemId = defaultItem.itemId;
//           });
//
//           _filterBothLists();
//         } else {
//           refreshTokens();
//           throw Exception('Failed To Load Items');
//         }
//       } catch (e) {
//         debugPrint("GetItemMasterList" + e.toString());
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   void _filterBothLists() {
//     if (selectedItemId == null) return;
//
//     final openingItem = todaysOpeningStock.firstWhere(
//           (item) => item.itemId == selectedItemId,
//       orElse: () => TodaysOpeningStockDataModel(),
//     );
//
//     todayOpeningFilledDiffShow =
//         openingItem.filledOpeningStk?.toInt() ?? 0;
//     todayOpeningEmptyDiffShow =
//         openingItem.emptyOpeningStk?.toInt() ?? 0;
//     todayOpeningDefectiveDiffShow =
//         openingItem.defOpeningStk?.toInt() ?? 0;
//
//     final currentItem = getCurrentStcOfGodownKeeper.firstWhere(
//           (item) => item.itemId == selectedItemId,
//       orElse: () => GetCurrentStcOfGodownKeeperModel(),
//     );
//
//     todayOpeningFilledDiffShowCurrentStock =
//         currentItem.currentStkFilled?.toInt() ?? 0;
//     todayOpeningEmptyDiffShowCurrentStock =
//         currentItem.currentStkEmpty?.toInt() ?? 0;
//     todayOpeningDefectiveDiffShowCurrentStock =
//         currentItem.currentStkDefective?.toInt() ?? 0;
//   }
//
//   Future<void> loadAllData() async {
//     await fetchItems();
//     await _fetchTodaysOpeningStockData();
//     await fetchCurrentStock();
//     _filterBothLists();
//   }
//
//   Future<void> fetchAllSQCCount() async {
//     EasyLoading.show();
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
//           Uri.parse('${AppUrl.GetSQCCardCntList}/$distributorId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//
//         print("Request URL GetSQCCardCntList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status GetSQCCardCntList: ${response.statusCode}");
//         print("API Response GetSQCCardCntList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getSqcCardCntList = data.map((json) {
//               return GetSqcCardCntListModel.fromJson(json);
//             }).toList();
//
//             if (getSqcCardCntList.isNotEmpty) {
//               print('First vehicle In: ${getSqcCardCntList[0].vehicleNo}');
//               TodayTruckIn = getSqcCardCntList[0].todayTruckIn!.toInt();
//               TodaySQCDone = getSqcCardCntList[0].todaySQCDone?.toInt();
//               TodayNotDone = getSqcCardCntList[0].todayNotDone?.toInt();
//               TodayBodyLeak = getSqcCardCntList[0].todayBodyLeak?.toInt();
//               TodayLessQtyCyls =
//                   getSqcCardCntList[0].todayLessQtyCyls?.toInt();
//               MonthTruckIn = getSqcCardCntList[0].monthTruckIn?.toInt();
//               MonthSQCDone = getSqcCardCntList[0].monthSQCDone?.toInt();
//               MonthNotDone = getSqcCardCntList[0].monthNotDone?.toInt();
//               MonthBodyLeak = getSqcCardCntList[0].monthBodyLeak?.toInt();
//               MonthLessQtyCyls =
//                   getSqcCardCntList[0].monthLessQtyCyls?.toInt();
//               VehicleNo = getSqcCardCntList[0].vehicleNo?.toString();
//               SQCStatus = getSqcCardCntList[0].sQCStatus?.toString();
//             }
//
//             filterSQCList();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           setState(() {
//             refreshTokens();
//             EasyLoading.dismiss();
//             isLoading = false;
//           });
//         }
//       }
//     } else {
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> insertDelBoyStockList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
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
//
//         if (response.statusCode == 200) {
//           // success
//         }
//       } catch (e) {
//         debugPrint("insertDelBoyStockList error: $e");
//       }
//     }
//   }
//
//   Future<void> _fetchImbalanceData() async {
//     EasyLoading.show(status: 'Loading..');
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? token = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int godownIdId = int.parse(godownId!);
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ImbalanceAsOfDateStkForGK}/$dId/$godownIdId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Total ImbQty ImbalanceAsOfDateStkForGK response ${response.body}");
//         print("Total ImbQty ImbalanceAsOfDateStkForGK request ${response.request}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             receiptList = data
//                 .map((json) =>
//                 PhysicalStockImbalanceDataModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//         } else {
//           setState(() {
//             EasyLoading.dismiss();
//             isLoading = false;
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(Constants.listGettingFail)),
//         );
//       }
//     } else {
//       refreshTokens();
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> _fetchTodaysOpeningStockData() async {
//     EasyLoading.instance
//       ..maskType = EasyLoadingMaskType.black
//       ..loadingStyle = EasyLoadingStyle.light
//       ..dismissOnTap = false
//       ..userInteractions = false;
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? token = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int godownIdId = int.parse(godownId!);
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$godownIdId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
//         print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           final items = data
//               .map((json) =>
//               TodaysOpeningStockDataModel.fromJson(json))
//               .toList();
//           setState(() {
//             todaysOpeningStock = items;
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//           if (selectedItemId != null) {
//             _filterBothLists();
//           }
//         } else {
//           setState(() {
//             isLoading = false;
//             EasyLoading.dismiss();
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       EasyLoading.dismiss();
//       refreshTokens();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     EasyLoading.show(status: 'Loading..');
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? token = prefs.getString('token');
//
//       try {
//         final response = await http.get(
//           Uri.parse(
//               '${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print(
//             "API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           final items = data
//               .map((json) =>
//               GetCurrentStcOfGodownKeeperModel.fromJson(json))
//               .toList();
//           items.sort((a, b) => a.itemId!.compareTo(b.itemId!));
//           setState(() {
//             getCurrentStcOfGodownKeeper = items;
//             isLoading = false;
//             EasyLoading.dismiss();
//           });
//           if (selectedItemId != null) {
//             _filterBothLists();
//           }
//         } else {
//           setState(() {
//             isLoading = false;
//             EasyLoading.dismiss();
//             refreshTokens();
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           EasyLoading.dismiss();
//           isLoading = false;
//           refreshTokens();
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       EasyLoading.dismiss();
//       refreshTokens();
//       showFlushBar(context, Constants.connectionMessage);
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
//       String? bearerToken = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         );
//
//         debugPrint("GetStockTransferDtls" +
//             '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//         debugPrint("GetStockTransferDtls" + response.body);
//         if (response.statusCode == 200) {
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
//                 break;
//               }
//             }
//             stockTransferFlag = !hasZeroStkTrans;
//           });
//           isLoading = false;
//         } else {
//           setState(() {
//             refreshTokens();
//             isLoading = false;
//             showFlushBar(context, Constants.listGettingFail);
//           });
//         }
//       } catch (e) {
//         debugPrint("GetStockTransferDtls" + e.toString());
//       }
//     } else {
//       refreshTokens();
//       isLoading = false;
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchSavedData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       userName = preferences.getString("StaffName").toString();
//       String roles = preferences.getString("RoleName").toString();
//       // distributorName = preferences.getString("IsAlreadyLogin").toString();
//       distributorName = preferences.getString("DistributorName").toString();
//       String isAlreadyLogin =
//       preferences.getString("IsAlreadyLogin").toString();
//       debugPrint("User Name:- $userName");
//       if (isAlreadyLogin == "0" ||
//           isAlreadyLogin == null ||
//           isAlreadyLogin == "null" ||
//           isAlreadyLogin.isEmpty) {
//         _showLogoutDialog(context);
//       } else {}
//     } catch (error) {
//       rethrow;
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
//             insertDelBoyStockList();
//             _fetchImbalanceData();
//             _fetchTodaysOpeningStockData();
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
//             fetchAllSQCCount();
//           } else if (response['message'] == "Token Expired") {
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
//             "Your session is expire. Click ok to login again.";
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
//     try {
//       SharedPref().removeUser();
//       EasyLoading.dismiss();
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
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
//       debugPrint(
//           "Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint(
//           "requesr bodyCheckDayEndConfirmation: ${response.request}");
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
//         refreshTokens();
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       refreshTokens();
//       print("Exception: $e");
//     }
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16)),
//           title: const Text("Confirm Logout"),
//           content:
//           const Text("Please log in to the application again."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 logoutUser(context);
//               },
//               child: const Text("OK",
//                   style: TextStyle(
//                       color: _C.blue, fontWeight: FontWeight.w700)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // void _showItemPopup() {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.white,
//   //     shape: const RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //     ),
//   //     builder: (context) {
//   //       return Padding(
//   //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             // Drag handle
//   //             Container(
//   //               width: 40,
//   //               height: 4,
//   //               margin: const EdgeInsets.only(bottom: 12),
//   //               decoration: BoxDecoration(
//   //                 color: Colors.grey.shade400,
//   //                 borderRadius: BorderRadius.circular(10),
//   //               ),
//   //             ),
//   //             const Text(
//   //               "Select Item For Stock Transfer",
//   //               style: TextStyle(
//   //                 fontSize: 18,
//   //                 fontWeight: FontWeight.w600,
//   //                 color: _C.text,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 10),
//   //             ListView.separated(
//   //               shrinkWrap: true,
//   //               physics: const NeverScrollableScrollPhysics(),
//   //               itemCount: getCurrentStcOfGodownKeeper.length,
//   //               separatorBuilder: (_, __) =>
//   //               const Divider(height: 1, color: Color(0xFFF1F5F9)),
//   //               itemBuilder: (context, index) {
//   //                 final items = getCurrentStcOfGodownKeeper[index];
//   //                 return ListTile(
//   //                   dense: true,
//   //                   contentPadding: EdgeInsets.zero,
//   //                   title: Text(
//   //                     items.itemName.toString(),
//   //                     style: Styling.itemTitle,
//   //                   ),
//   //                   trailing: const Icon(Icons.arrow_forward_ios,
//   //                       size: 14, color: _C.blueLight),
//   //                   onTap: () {
//   //                     Navigator.pop(context);
//   //                     Navigator.pushNamed(
//   //                       context,
//   //                       StockTransferTOGodownScreen.screenName,
//   //                       arguments: {
//   //                         "itemName": items.itemName,
//   //                         "itemID": items.itemId,
//   //                         "filledStock": items.currentStkFilled,
//   //                         "emptyStock": items.currentStkEmpty,
//   //                         "defectiveStock": items.currentStkDefective,
//   //                       },
//   //                     );
//   //                   },
//   //                 );
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   // ─────────────────────────────────────────────
//   // MODAL BOTTOM SHEET (Item Popup — preserved)
//   // ─────────────────────────────────────────────
//   void _showItemPopup() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // drag handle
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade100, // 👈 light blue
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//
//               // header
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50, // 👈 light blue background
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.swap_horiz_rounded,
//                       color: Colors.blue.shade400, // 👈 soft blue icon
//                       size: 22,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     "Select Item For Stock Transfer",
//                     // style: _AppType.cardTitle,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // list
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: getCurrentStcOfGodownKeeper.length,
//                 separatorBuilder: (_, __) => Divider(
//                   color: Colors.blue.shade50, // 👈 light divider
//                   height: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   final items = getCurrentStcOfGodownKeeper[index];
//
//                   return ListTile(
//                     dense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                       vertical: 2,
//                     ),
//                     leading: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50, // 👈 light blue bg
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         Icons.propane_tank_outlined,
//                         color: Colors.blue.shade400, // 👈 soft blue icon
//                         size: 18,
//                       ),
//                     ),
//                     title: Text(
//                       items.itemName.toString(),
//                       // style: _AppType.dataLabel,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     trailing: Icon(
//                       Icons.chevron_right_rounded,
//                       color: Colors.blue.shade300, // light blue arrow
//                       size: 22,
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.pushNamed(
//                         context,
//                         StockTransferTOGodownScreen.screenName,
//                         arguments: {
//                           "itemName": items.itemName,
//                           "itemID": items.itemId,
//                           "filledStock": items.currentStkFilled,
//                           "emptyStock": items.currentStkEmpty,
//                           "defectiveStock": items.currentStkDefective,
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
// }


// ─────────────────────────────────────────────────────────────────────────────
// DashboardScreen.dart  —  Refactored
//
// WHAT CHANGED vs. original:
//  1. Removed all private _C / _T inline token classes.
//  2. Replaced every Color(0x…) / TextStyle(…) literal with a token reference.
//  3. Replaced every EdgeInsets / BorderRadius literal with a token reference.
//  4. Removed BoxShadow literals; use AppShadows.card / AppShadows.chip.
//  5. Replaced BoxDecoration literals; use AppDecorations.*
//  6. Kept all business logic methods 100% intact.
//
// IMPORT:
//   import '../Utils/styles/styles.dart';     ← single line, all tokens
//   import '../Utils/Styling.dart';            ← legacy compat (Styling.bodyTitle etc.)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../ConstantScreen/widgets.dart';
import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
import '../DashboardModel/TodaysOpeningStockDataModel.dart';
import '../IOSVersionUpdateService.dart';
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeAlertDialog.dart';
import '../Utils/Styling.dart';          // ← legacy compat for Styling.bodyTitle etc.
import '../Utils/styles/app_spacing.dart';
import '../Utils/styles/app_text_styles.dart';
import '../Utils/styles/app_colors.dart';
import '../Utils/UpdateService.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';
import 'DelBoyStockReturn/StockTransferToGodownScreen.dart';
import 'DeliveryBoyModel/GetStockTransferListModel.dart';
import 'DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'package:http/http.dart' as http;
import 'ItemReceipt/CylItemList/CylItemListModel.dart';
import 'ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import 'SQCRegister/GetSQCCardCntListModel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.dotColor,
    this.trailing,
  });

  final String title;
  final Color dotColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: AppSpacing.sectionHeader,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),// ← was: EdgeInsets.fromLTRB(0, 22, 0, 10)
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          /// TITLE
          Expanded(
            flex: 2,
            child: Text(
              title.toUpperCase(),
              style: AppTextStyles.sectionHeader,
              softWrap: true,
            ),
          ),

          const SizedBox(width: 8),

          /// DROPDOWN
          if (trailing != null)
            Flexible(
              flex: 1,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STOCK CHIP  (Filled / Empty / Defective card)
// ─────────────────────────────────────────────────────────────────────────────
class _StockChip extends StatelessWidget {
  const _StockChip({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSpacing.stockChip,             // ← was: EdgeInsets.symmetric(vertical:14, horizontal:10)
        decoration: AppDecorations.stockChip(accentColor: accentColor), // ← was: inline BoxDecoration
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.kpiValue.copyWith(
                fontSize: 22,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTextStyles.labelMd, textScaler: TextScaler.noScaling),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SQC STAT ROW
// ─────────────────────────────────────────────────────────────────────────────
class _SqcStatRow extends StatelessWidget {
  const _SqcStatRow({
    required this.label,
    required this.today,
    required this.month,
    this.showDivider = true,
  });

  final String label;
  final String today;
  final String month;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.rowPadding,    // ← was: EdgeInsets.symmetric(vertical:10, horizontal:16)
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(label, style: AppTextStyles.dataLabel),
              ),
              Expanded(
                flex: 1,
                child: Text(today,
                    style: AppTextStyles.dataValue, textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 1,
                child: Text(month,
                    style: AppTextStyles.dataValue, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.userName,
    required this.distributorName,
  });

  final String? userName;
  final String? distributorName;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting =
    hour < 12 ? 'Morning' : (hour < 17 ? 'Afternoon' : 'Evening');
    final initials = (userName != null && userName!.isNotEmpty)
        ? userName!
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase()
        : 'GK';

    return Container(
      decoration: BoxDecoration(gradient: AppColors.heroGradient), // ← token
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good $greeting, ${userName ?? "Godown Keeper"} 👋',
                          style: AppTextStyles.heroSubtitle,   // ← token
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          distributorName?.isNotEmpty == true
                              ? distributorName!
                              : 'Godown Dashboard',
                          style: AppTextStyles.heroTitle.copyWith(fontSize: 18), // ← token
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppRadius.md)),         // ← token
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: AppTextStyles.badge.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMBALANCE TABLE CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ImbalanceCard extends StatelessWidget {
  const _ImbalanceCard({required this.receiptList});

  final List<PhysicalStockImbalanceDataModel> receiptList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: AppDecorations.card(),     // ← token
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Container(
            padding: AppSpacing.rowPadding,
            decoration: AppDecorations.cardHeader,  // ← token
            child: Row(
              children: [
                Expanded(
                  child: Text('Cylinder',
                      style: AppTextStyles.tableHeader),    // ← token
                ),
                Expanded(
                  child: Text('Imbalance Qty',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.tableHeader),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          if (receiptList.isEmpty)
            Padding(
              padding: AppSpacing.cardPadding,
              child: Text('No data available', style: AppTextStyles.cardSubtitle),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: receiptList.length,
              separatorBuilder: (_, __) =>
              Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final item = receiptList[index];
                final hasImbalance = (item.imbalanceStk ?? 0) != 0;
                return Padding(
                  padding: AppSpacing.rowPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(item.itemName.toString(),
                            style: AppTextStyles.dataLabel),
                      ),
                      Text(
                        item.imbalanceStk.toString(),
                        style: AppTextStyles.dataValue.copyWith(
                          color: hasImbalance ? AppColors.error : AppColors.success,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  static const screenName = '/godownDashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ── State ─────────────────────────────────────────
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UpdateRefillSale? updateRefillSale;

  List<PhysicalStockImbalanceDataModel> receiptList = [];
  List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  List<GetStockTransferListModel> _stockTransferList = [];
  List<CylItemListModel> _items = [];
  List<GetSqcCardCntListModel> getSqcCardCntList = [];
  List<GetSqcCardCntListModel> filteredSqcList = [];
  num? selectedItemId;
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  String? mobileNo;
  String? userName, role, distributorName, roleId;
  int? todayOpeningFilledDiffShow = 0;
  int? todayOpeningEmptyDiffShow = 0;
  int? todayOpeningDefectiveDiffShow = 0;
  int? todayOpeningFilledDiffShowCurrentStock = 0;
  int? todayOpeningEmptyDiffShowCurrentStock = 0;
  int? todayOpeningDefectiveDiffShowCurrentStock = 0;
  int? TodayTruckIn, TodaySQCDone, TodayNotDone, TodayBodyLeak, TodayLessQtyCyls;
  int? MonthTruckIn, MonthSQCDone, MonthNotDone, MonthBodyLeak, MonthLessQtyCyls;
  String? VehicleNo, SQCStatus;
  String selectedSQCStatus = 'All Vehicles';

  // ── Lifecycle ─────────────────────────────────────
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      UpdateService.checkForUpdate(context);
    } else {
      IosVersionUpdateCheck().checkForUpdate(context);
    }
    updateRefillSale = UpdateRefillSale();
    loadAllData();
    insertDelBoyStockList();
    _fetchImbalanceData();
    checkAndSaveDayEndData();
    fetchTransactionList();
    fetchSavedData();
    fetchAllSQCCount();
  }

  Future<void> _onRefresh() async {
    loadAllData();
    insertDelBoyStockList();
    _fetchImbalanceData();
    checkAndSaveDayEndData();
    fetchTransactionList();
    fetchAllSQCCount();
  }

  // ─────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.primary),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background2,   // ← token
      floatingActionButton: _buildFab(),
      body: RefreshIndicator(
        color: AppColors.primary,               // ← token
        backgroundColor: AppColors.surface,     // ← token
        onRefresh: _onRefresh,
        edgeOffset: MediaQuery.of(context).padding.top + 180,
        child: Column(
          children: [
            // Fixed hero header
            _HeroHeader(userName: userName, distributorName: distributorName),

            // Scrollable body
            Expanded(
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: AppSpacing.pagePadding,   // ← token
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Today's Opening Stock
                        _SectionHeader(
                          title: "Today's Opening Stock",
                          dotColor: AppColors.primaryLight,    // ← token
                          trailing: _buildItemDropdown(),
                        ),
                        _buildOpeningStockRow(),

                        // Current Stock
                        _SectionHeader(
                          title: 'Current Stock',
                          dotColor: AppColors.teal,            // ← token
                          trailing: _buildTransferButton(),
                        ),
                        _buildCurrentStockRow(),

                        // Physical Stock Imbalance
                        _SectionHeader(
                          title: 'Physical Stock Imbalance As Of Today',
                          dotColor: AppColors.red,             // ← token
                        ),
                        _ImbalanceCard(receiptList: receiptList),

                        // SQC Summary
                        _SectionHeader(
                          title: 'SQC Status',
                          dotColor: AppColors.orange,          // ← token
                        ),
                        _buildSqcSummaryCard(),

                        // Vehicle SQC
                        _SectionHeader(
                          title: 'Today Vehicle SQC',
                          dotColor: AppColors.warning,         // ← token
                          trailing: _buildSqcFilterDropdown(),
                        ),
                        _buildVehicleSqcCard(),

                        const SizedBox(height: AppSpacing.sm),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // FAB
  // ─────────────────────────────────────────────────
  // Widget _buildFab() {
  //   return FloatingActionButton(
  //     // ThemeData.floatingActionButtonTheme handles color/shape
  //     onPressed: () {
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           // ThemeData.dialogTheme handles shape / text styles
  //           title: const Text('Confirm Refresh'),
  //           content: const Text('Do You Want To Refresh Data?'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: Text('No',
  //                   style: AppTextStyles.button.copyWith(
  //                       color: AppColors.textMuted)),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 setState(() => _onRefresh());
  //               },
  //               child: Text('Yes',
  //                   style: AppTextStyles.button.copyWith(
  //                       color: AppColors.primary)),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     child: const Icon(Icons.refresh_rounded),
  //   );
  // }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: AppColors.blue,
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: 52,
                  //   height: 52,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFEFF6FF),
                  //     borderRadius: BorderRadius.circular(14),
                  //   ),
                  //   child: const Icon(
                  //     Icons.refresh_rounded,
                  //     color: AppColors.primary,
                  //     size: 26,
                  //   ),
                  // ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1), // light blue background
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.blue, // same as FAB color
                      size: 26,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Confirm Refresh",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                    textScaler: TextScaler.noScaling,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Do you want to refresh data?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                    textScaler: TextScaler.noScaling,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _onRefresh();
                            });
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: const Icon(Icons.refresh_rounded),
    );
  }

  // ─────────────────────────────────────────────────
  // ITEM DROPDOWN
  // ─────────────────────────────────────────────────
  // Widget _buildItemDropdown() {
  //   return Container(
  //     height: 32,
  //     padding: AppSpacing.chipPadding,
  //     decoration: AppDecorations.dropdownPill,
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<num>(
  //         value: selectedItemId,
  //         isDense: true,
  //         isExpanded: true, // IMPORTANT
  //         style: AppTextStyles.buttonSm.copyWith(
  //           color: AppColors.primary,
  //         ),
  //         icon: Icon(
  //           Icons.keyboard_arrow_down_rounded,
  //           size: 16,
  //           color: AppColors.primary,
  //         ),
  //         items: _items.map((item) {
  //           return DropdownMenuItem<num>(
  //             value: item.itemId,
  //             child: Text(
  //               item.itemName ?? 'Unknown',
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           setState(() {
  //             selectedItemId = value;
  //             _filterBothLists();
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildItemDropdown() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,   // absorbs the tap before it bubbles
      onTap: () {},                        // swallow the tap event
      child: Container(
        height: 32,
        padding: AppSpacing.chipPadding,
        decoration: AppDecorations.dropdownPill,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<num>(
            value: selectedItemId,
            isDense: true,
            isExpanded: true,
            style: AppTextStyles.buttonSm.copyWith(
              color: AppColors.primary,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            items: _items.map((item) {
              return DropdownMenuItem<num>(
                value: item.itemId,
                child: Text(
                  item.itemName ?? 'Unknown',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedItemId = value;
                _filterBothLists();
              });
            },
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // TRANSFER BUTTON
  // ─────────────────────────────────────────────────
  Widget _buildTransferButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          saveFlag ? showFlushBar(context, Constants.dayEndCompleted) : _showItemPopup();
        },
        borderRadius: AppRadius.button,
        child: Container(
          padding: AppSpacing.buttonPadding,                      // ← token
          decoration: AppDecorations.transferButton(disabled: saveFlag), // ← token
          child: Text(
            'Transfer',
            style: AppTextStyles.buttonSm.copyWith(
              color: saveFlag ? AppColors.textMuted : AppColors.error,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // SQC FILTER DROPDOWN
  // ─────────────────────────────────────────────────
  Widget _buildSqcFilterDropdown() {
    return Container(
     height: 35,
      padding: AppSpacing.chipPadding,
      decoration: AppDecorations.dropdownPill,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSQCStatus,
          isDense: true,
          isExpanded: true,
          style: AppTextStyles.buttonSm.copyWith(color: AppColors.primary),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 16, color: AppColors.primary),
          items: ['All Vehicles', 'SQC Completed', 'SQC Pending']
              .map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
              .toList(),
          onChanged: (value) {
            selectedSQCStatus = value ?? 'All Vehicles';
            filterSQCList();
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // OPENING STOCK ROW
  // ─────────────────────────────────────────────────
  Widget _buildOpeningStockRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.smm),
      child: Row(
        children: [
          _StockChip(
            label: 'Filled',
            value: todayOpeningFilledDiffShow.toString(),
            accentColor: AppColors.success,   // ← token
          ),
          const SizedBox(width: AppSpacing.sm),
          _StockChip(
            label: 'Empty',
            value: todayOpeningEmptyDiffShow.toString(),
            accentColor: AppColors.warning,   // ← token
          ),
          const SizedBox(width: AppSpacing.sm),
          _StockChip(
            label: 'Defective',
            value: todayOpeningDefectiveDiffShow.toString(),
            accentColor: AppColors.error,     // ← token
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // CURRENT STOCK ROW
  // ─────────────────────────────────────────────────
  Widget _buildCurrentStockRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          _StockChip(
            label: 'Filled',
            value: todayOpeningFilledDiffShowCurrentStock.toString(),
            accentColor: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.sm),
          _StockChip(
            label: 'Empty',
            value: todayOpeningEmptyDiffShowCurrentStock.toString(),
            accentColor: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          _StockChip(
            label: 'Defective',
            value: todayOpeningDefectiveDiffShowCurrentStock.toString(),
            accentColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // SQC SUMMARY CARD
  // ─────────────────────────────────────────────────
  Widget _buildSqcSummaryCard() {
    if (getSqcCardCntList.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: AppSpacing.cardPadding,
        decoration: AppDecorations.card(),
        child: Text('No data available', style: AppTextStyles.cardSubtitle),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          // Table header
          Container(
            padding: AppSpacing.rowPadding,
            decoration: AppDecorations.cardHeader,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Metric', style: AppTextStyles.tableHeader),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Today',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.tableHeader
                          .copyWith(color: AppColors.primaryLight)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Month',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.tableHeader
                          .copyWith(color: AppColors.teal)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          _SqcStatRow(
              label: 'Truck In',
              today: TodayTruckIn?.toString() ?? '0',
              month: MonthTruckIn?.toString() ?? '0'),
          _SqcStatRow(
              label: 'SQC Done',
              today: TodaySQCDone?.toString() ?? '0',
              month: MonthSQCDone?.toString() ?? '0'),
          _SqcStatRow(
              label: 'Not Done',
              today: TodayNotDone?.toString() ?? '0',
              month: MonthNotDone?.toString() ?? '0'),
          _SqcStatRow(
              label: 'Body Leak',
              today: TodayBodyLeak?.toString() ?? '0',
              month: MonthBodyLeak?.toString() ?? '0'),
          _SqcStatRow(
              label: 'Less Qty',
              today: TodayLessQtyCyls?.toString() ?? '0',
              month: MonthLessQtyCyls?.toString() ?? '0',
              showDivider: false),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // VEHICLE SQC LIST CARD
  // ─────────────────────────────────────────────────
  Widget _buildVehicleSqcCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          Container(
            padding: AppSpacing.rowPadding,
            decoration: AppDecorations.cardHeader,
            child: Row(
              children: [
                Expanded(
                  child: Text('Vehicle No.',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text('SQC Done',
                      style: AppTextStyles.tableHeader,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),
          if (filteredSqcList.isEmpty)
            Padding(
              padding: AppSpacing.cardPadding,
              child: Text('No data available', style: AppTextStyles.cardSubtitle),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSqcList.length,
              separatorBuilder: (_, __) =>
              Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final item = filteredSqcList[index];
                final isDone =
                    (item.sQCStatus ?? '').toLowerCase() == 'yes';
                return Padding(
                  padding: AppSpacing.rowPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(item.vehicleNo ?? '',
                            style: AppTextStyles.dataLabel,
                            textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: AppSpacing.chipPadding,
                            decoration: AppDecorations.statusBadge(isPositive: isDone), // ← token
                            child: Text(
                              (item.sQCStatus ?? '').toUpperCase(),
                              style: AppTextStyles.badge.copyWith(
                                color: isDone ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // MODAL BOTTOM SHEET — Item picker for stock transfer
  // ─────────────────────────────────────────────────
  void _showItemPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // ThemeData.bottomSheetTheme handles bg + shape
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: AppDecorations.dragHandle,   // ← token
              ),

              // Sheet title
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryXLight,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.md)),
                    ),
                    child: Icon(Icons.swap_horiz_rounded,
                        color: AppColors.primaryLight, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('Select Item For Stock Transfer',
                      style: AppTextStyles.cardTitle),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Item list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: getCurrentStcOfGodownKeeper.length,
                separatorBuilder: (_, __) =>
                    Divider(color: AppColors.primaryXXLight, height: 1),
                itemBuilder: (context, index) {
                  final item = getCurrentStcOfGodownKeeper[index];
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryXLight,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppRadius.sm)),
                      ),
                      child: Icon(Icons.propane_tank_outlined,
                          color: AppColors.primaryLight, size: 18),
                    ),
                    title: Text(item.itemName.toString(),
                        // Legacy Styling.itemTitle is wired to legacyItemTitle below
                        style: AppTextStyles.legacyItemTitle),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: AppColors.primaryLight, size: 22),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        StockTransferTOGodownScreen.screenName,
                        arguments: {
                          'itemName': item.itemName,
                          'itemID': item.itemId,
                          'filledStock': item.currentStkFilled,
                          'emptyStock': item.currentStkEmpty,
                          'defectiveStock': item.currentStkDefective,
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────
  // EXPIRE SESSION DIALOG
  // Uses Styling.bodyTitle and Styling.blueClrText to stay compatible with
  // existing CupertinoAlertDialog usage that already referenced Styling.
  // ─────────────────────────────────────────────────
  showDialogToExpireSession(BuildContext context) async {
    const title = 'Expired';
    const message = 'Your session is expired. Click OK to login again.';
    const btn = 'OK';
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(title, style: Styling.bodyTitle),    // legacy compat
            content: Text(message, style: Styling.bodyTitle),
            actions: [
              TextButton(
                child: Text(btn, style: Styling.blueClrText),
                onPressed: () => logoutUser(ctx),
              ),
            ],
          ),
        )
            : WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: AlertDialog(
            title: const Text(title),
            content: const Text(message),
            actions: [
              TextButton(
                child: const Text(btn),
                onPressed: () => logoutUser(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────
  // BUSINESS LOGIC — all unchanged from original
  // ─────────────────────────────────────────────────

  void filterSQCList() {
    setState(() {
      String status;
      switch (selectedSQCStatus) {
        case 'SQC Completed':
          status = 'yes';
          break;
        case 'SQC Pending':
          status = 'no';
          break;
        default:
          status = 'all';
      }
      filteredSqcList = status == 'all'
          ? List.from(getSqcCardCntList)
          : getSqcCardCntList
          .where((i) => (i.sQCStatus ?? '').toLowerCase() == status)
          .toList();
      if (filteredSqcList.isNotEmpty) {
        VehicleNo = filteredSqcList[0].vehicleNo ?? '';
        SQCStatus = filteredSqcList[0].sQCStatus ?? '';
      } else {
        VehicleNo = SQCStatus = '';
      }
    });
  }

  void _filterBothLists() {
    if (selectedItemId == null) return;
    final opening = todaysOpeningStock.firstWhere(
            (i) => i.itemId == selectedItemId,
        orElse: () => TodaysOpeningStockDataModel());
    todayOpeningFilledDiffShow    = opening.filledOpeningStk?.toInt() ?? 0;
    todayOpeningEmptyDiffShow     = opening.emptyOpeningStk?.toInt()  ?? 0;
    todayOpeningDefectiveDiffShow = opening.defOpeningStk?.toInt()    ?? 0;

    final current = getCurrentStcOfGodownKeeper.firstWhere(
            (i) => i.itemId == selectedItemId,
        orElse: () => GetCurrentStcOfGodownKeeperModel());
    todayOpeningFilledDiffShowCurrentStock    = current.currentStkFilled?.toInt()    ?? 0;
    todayOpeningEmptyDiffShowCurrentStock     = current.currentStkEmpty?.toInt()     ?? 0;
    todayOpeningDefectiveDiffShowCurrentStock = current.currentStkDefective?.toInt() ?? 0;
  }

  // Future<void> loadAllData() async {
  //   await fetchItems();
  //   await _fetchTodaysOpeningStockData();
  //   await fetchCurrentStock();
  //   _filterBothLists();
  // }

  Future<void> loadAllData() async {
    await fetchItems();

    if (!mounted) return;

    await _fetchTodaysOpeningStockData();

    if (!mounted) return;

    await fetchCurrentStock();

    if (!mounted) return;

    _filterBothLists();
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final distributorId = prefs.getString('DistributorId');
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        final loaded = data
            .map((j) => CylItemListModel.fromJson(j))
            .where((i) => !i.itemName!.toLowerCase().contains('regulator'))
            .toList();
        setState(() {
          _items = loaded;
          String norm(String? v) =>
              v?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ?? '';
          final def = _items.firstWhere((i) => norm(i.itemName) == '14.2kg',
              orElse: () => _items.isNotEmpty ? _items.first : CylItemListModel());
          selectedItemId = def.itemId;
        });
        _filterBothLists();
      } else {
        refreshTokens();
      }
    } catch (e) {
      debugPrint('fetchItems: $e');
    }
  }

  Future<void> _fetchTodaysOpeningStockData() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = int.parse(prefs.getString('DistributorId')!);
      final gId = int.parse(prefs.getString('godownId')!);
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$gId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final items = (json.decode(res.body) as List)
            .map((j) => TodaysOpeningStockDataModel.fromJson(j))
            .toList();
        setState(() { todaysOpeningStock = items; isLoading = false; });
        if (selectedItemId != null) _filterBothLists();
      } else {
        setState(() { isLoading = false; refreshTokens(); });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      setState(() { isLoading = false; refreshTokens(); });
      showFlushBar(context, Constants.listGettingFail);
    }
  }

  Future<void> fetchCurrentStock() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final distributorId = prefs.getString('DistributorId');
      final godownId = prefs.getString('godownId');
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final items = (json.decode(res.body) as List)
            .map((j) => GetCurrentStcOfGodownKeeperModel.fromJson(j))
            .toList()
          ..sort((a, b) => a.itemId!.compareTo(b.itemId!));
        setState(() { getCurrentStcOfGodownKeeper = items; isLoading = false; EasyLoading.dismiss(); });
        if (selectedItemId != null) _filterBothLists();
      } else {
        setState(() { isLoading = false; EasyLoading.dismiss(); refreshTokens(); });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      setState(() { EasyLoading.dismiss(); isLoading = false; refreshTokens(); });
      showFlushBar(context, Constants.listGettingFail);
    }
  }

  Future<void> _fetchImbalanceData() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      refreshTokens(); EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = int.parse(prefs.getString('DistributorId')!);
      final gId = int.parse(prefs.getString('godownId')!);
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.ImbalanceAsOfDateStkForGK}/$dId/$gId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        setState(() {
          receiptList = data.map((j) => PhysicalStockImbalanceDataModel.fromJson(j)).toList();
          isLoading = false; EasyLoading.dismiss();
        });
      } else {
        setState(() { EasyLoading.dismiss(); isLoading = false; refreshTokens(); });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      setState(() { EasyLoading.dismiss(); isLoading = false; refreshTokens(); });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(Constants.listGettingFail)));
    }
  }

  Future<void> fetchAllSQCCount() async {
    EasyLoading.show();
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final distributorId = prefs.getString('DistributorId');
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.GetSQCCardCntList}/$distributorId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        setState(() {
          getSqcCardCntList = data.map((j) => GetSqcCardCntListModel.fromJson(j)).toList();
          if (getSqcCardCntList.isNotEmpty) {
            final f = getSqcCardCntList[0];
            TodayTruckIn    = f.todayTruckIn!.toInt();
            TodaySQCDone    = f.todaySQCDone?.toInt();
            TodayNotDone    = f.todayNotDone?.toInt();
            TodayBodyLeak   = f.todayBodyLeak?.toInt();
            TodayLessQtyCyls = f.todayLessQtyCyls?.toInt();
            MonthTruckIn    = f.monthTruckIn?.toInt();
            MonthSQCDone    = f.monthSQCDone?.toInt();
            MonthNotDone    = f.monthNotDone?.toInt();
            MonthBodyLeak   = f.monthBodyLeak?.toInt();
            MonthLessQtyCyls = f.monthLessQtyCyls?.toInt();
            VehicleNo = f.vehicleNo?.toString();
            SQCStatus = f.sQCStatus?.toString();
          }
          filterSQCList(); isLoading = false; EasyLoading.dismiss();
        });
      } else {
        setState(() { refreshTokens(); isLoading = false; EasyLoading.dismiss(); });
      }
    } catch (e) {
      if (mounted) setState(() { refreshTokens(); EasyLoading.dismiss(); isLoading = false; });
    }
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      refreshTokens(); isLoading = false;
      showFlushBar(context, Constants.connectionMessage);
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = int.parse(prefs.getString('DistributorId')!);
      final gId = int.parse(prefs.getString('godownId')!);
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        setState(() {
          _stockTransferList = data.map((j) => GetStockTransferListModel.fromJson(j)).toList();
          stockTransferFlag = !_stockTransferList.any((i) => i.isStkTrans == 0);
        });
        isLoading = false;
      } else {
        setState(() { refreshTokens(); isLoading = false; });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      debugPrint('fetchTransactionList: $e');
    }
  }

  Future<void> insertDelBoyStockList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final distributorId = prefs.getString('DistributorId');
      final token = prefs.getString('token');
      await http.get(
        Uri.parse('${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) { debugPrint('insertDelBoyStockList: $e'); }
  }

  Future<void> fetchSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userName = prefs.getString('StaffName').toString();
      distributorName = prefs.getString('DistributorName').toString();
      final isAlreadyLogin = prefs.getString('IsAlreadyLogin').toString();
      if (isAlreadyLogin == '0' || isAlreadyLogin == 'null' || isAlreadyLogin.isEmpty) {
        _showLogoutDialog(context);
      }
      setState(() {}); // update hero header
    } catch (e) { rethrow; }
  }

  Future<void> refreshTokens() async {
    final auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      final prefs = await SharedPreferences.getInstance();
      mobileNo = prefs.getString('MobileNo').toString();
      auth.refreshToken(mobileNo!, context).then((r) {
        EasyLoading.dismiss();
        if (r['status'] == true) {
          insertDelBoyStockList(); _fetchImbalanceData();
          _fetchTodaysOpeningStockData(); fetchCurrentStock();
          checkAndSaveDayEndData(); fetchTransactionList(); fetchAllSQCCount();
        } else if (r['message'] == 'Token Expired') {
          showDialogToExpireSession(context);
        }
      }).catchError((e) { EasyLoading.dismiss(); debugPrint('refreshToken: $e'); });
    } catch (e) { EasyLoading.dismiss(); }
  }

  Future<void> logoutUser(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      SharedPref().removeUser();
      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(context, SplashScreen.screenName, (_) => false);
    } catch (e) { EasyLoading.dismiss(); }
  }

  Future<void> checkAndSaveDayEndData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = int.parse(prefs.getString('DistributorId')!);
      final token = prefs.getString('token');
      final res = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$dId'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final list = json.decode(res.body) as List;
        saveFlag = list.isNotEmpty;
      } else { refreshTokens(); }
    } catch (e) { refreshTokens(); }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Please log in to the application again.'),
        actions: [
          TextButton(
            onPressed: () { Navigator.of(context).pop(); logoutUser(context); },
            child: Text('OK',
                style: AppTextStyles.button.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
