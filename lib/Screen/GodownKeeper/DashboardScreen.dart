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
import '../Utils/CustomeDrawer.dart';
import '../Utils/Styling.dart';
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
import 'SQCRegister/GetSqcCardCntListModel.dart';

class DashboardScreen extends StatefulWidget {
  static const screenName = '/godownDashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UpdateRefillSale? updateRefillSale;
  bool isPhysicalStockListViewVisible = false;
  bool isDomesticListViewVisible = false;
  bool isNonDomesticListViewVisible = false;
  bool isTodayOpeningStockListViewVisible = false;
  bool isCurrentStockListViewVisible = false;
  List<PhysicalStockImbalanceDataModel> receiptList = [];
  List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  List<GetStockTransferListModel> _stockTransferList = [];
  List<CylItemListModel> _items = [];
  num? selectedItemId;
  bool isLoading = true;
  String? mobileNo;
  String? userName, role, distributorName, roleId;
  int? selectedItemIdTodayStock;
  int? todayOpeningFilledDiffShow = 0;
  int? todayOpeningEmptyDiffShow = 0;
  int? todayOpeningDefectiveDiffShow = 0;

  int? selectedItemIdTodayStockCurrentStock;
  int? todayOpeningFilledDiffShowCurrentStock = 0;
  int? todayOpeningEmptyDiffShowCurrentStock = 0;
  int? todayOpeningDefectiveDiffShowCurrentStock = 0;

  List<GetSqcCardCntListModel> getSqcCardCntList = [];
  int? TodayTruckIn,
      TodaySQCDone,
      TodayNotDone,
      TodayBodyLeak,
      TodayLessQtyCyls,
      MonthTruckIn,
      MonthSQCDone,
      MonthNotDone,
      MonthBodyLeak,
      MonthLessQtyCyls;
      String? VehicleNo, SQCStatus;
  List<GetSqcCardCntListModel> filteredSqcList = [];
  String selectedSQCStatus = "All Vehicles";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    } else {
      IosVersionUpdateCheck().checkForUpdate(context);
      debugPrint("Firebase not initialize");
    }
    updateRefillSale = UpdateRefillSale();
    // Call the insert method when the screen is loaded
    loadAllData();
    // fetchItems();
    insertDelBoyStockList();
    _fetchImbalanceData();
    // _fetchTodaysOpeningStockData();
    // fetchCurrentStock();
    checkAndSaveDayEndData();
    fetchTransactionList();
    fetchSavedData();
    fetchAllSQCCount();
  }

  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    loadAllData();
    // fetchItems();
    insertDelBoyStockList();
    _fetchImbalanceData();
    // _fetchTodaysOpeningStockData();
    // fetchCurrentStock();
    checkAndSaveDayEndData(); // Fetch the data again
    fetchTransactionList();
    fetchAllSQCCount();
  }

  bool saveFlag = false;
  bool stockTransferFlag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 5.0, right: 5, top: 10),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.bolt_outlined,
                                            size: 26,
                                            color: Colors.black54,
                                          ),
                                          Text(
                                            "Today's Opening Stock",
                                            style: Styling.bodyTitleBigBoldDashGrey,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      DropdownButton<num>(
                                        value: selectedItemId,

                                        items: _items.map((item) {
                                          return DropdownMenuItem<num>(
                                            value: item.itemId,
                                            child: Text(item.itemName ?? 'Unknown'),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedItemId = value;
                                            _filterBothLists();
                                          });
                                        },
                                      ),
                                    ]),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningFilledDiffShow.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Filled',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningEmptyDiffShow.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Empty',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningDefectiveDiffShow
                                                    .toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  decorationColor: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Defective',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.bolt_outlined,
                                            size: 26,
                                            color: Colors.black54,
                                          ),
                                          Text(
                                            "Current Stock",
                                            style: Styling.bodyTitleBigBoldDashGrey,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        SizedBox(
                                          height: 30, // Button Height
                                          width: 90, // Button Width
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (saveFlag) {
                                                showFlushBar(
                                                    context,
                                                    Constants
                                                        .dayEndCompleted);
                                              } else {
                                                _showItemPopup();
                                                // if(stockTransferFlag){
                                                // Navigator.pushNamed(
                                                //   context,
                                                //   StockTransferTOGodownScreen
                                                //       .screenName,
                                                //   // arguments: {
                                                //   //   "itemName": items
                                                //   //       .itemName,
                                                //   //   "itemID":
                                                //   //   items.itemId,
                                                //   //   "filledStock": items
                                                //   //       .currentStkFilled,
                                                //   //   "emptyStock": items
                                                //   //       .currentStkEmpty,
                                                //   //   "defectiveStock":
                                                //   //   items
                                                //   //       .currentStkDefective,
                                                //   // }
                                                // );
                                                // }else{
                                                //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                                                // }
                                              }
                                            },
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                              Color(0xFFfbe9e9),
                                              // Button Color
                                              // backgroundColor: Color(0xFFfbe9e9),   // Button Color
                                              foregroundColor:
                                              Colors.black,
                                              // Text Color (simple way)
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20),
                                              ),
                                              padding: EdgeInsets.zero,

                                            ),
                                            child: Text(
                                              'Transfer',
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningFilledDiffShowCurrentStock.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Filled',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningEmptyDiffShowCurrentStock.toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  decorationColor: Colors.blue,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Empty',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border(
                                              top: BorderSide(
                                                  color: Color(0xFFEFF2FB),
                                                  width: 10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 4)
                                          ],
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                todayOpeningDefectiveDiffShowCurrentStock
                                                    .toString(),
                                                // Replace this with your dynamic data
                                                style: Styling.bodyTitleBigBoldDashGrey
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.blue,
                                                  decorationColor: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Defective',
                                                style: Styling.bodyTitleBig,
                                                textScaler: TextScaler.noScaling,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     Container(
                                //       color: Color(0xFFEFF2FB),
                                //       child: Padding(
                                //         padding: const EdgeInsets.only(
                                //             bottom: 10.0, top: 10),
                                //         child: Row(
                                //           mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //           children: [
                                //             Expanded(
                                //               flex: 1,
                                //               child: Text(
                                //                 "",
                                //                 style: Styling.itemTitle,
                                //                 textAlign: TextAlign.left,
                                //                 textScaler:
                                //                 TextScaler.noScaling,
                                //               ),
                                //             ),
                                //             Expanded(
                                //               flex: 1,
                                //               child: Text(
                                //                 "Filled",
                                //                 style: Styling
                                //                     .itemBlackTestVerySmallBoldPink,
                                //                 textAlign: TextAlign.center,
                                //                 textScaler:
                                //                 TextScaler.noScaling,
                                //               ),
                                //             ),
                                //             Expanded(
                                //               flex: 1,
                                //               child: Text(
                                //                 "Empty",
                                //                 style: Styling
                                //                     .itemBlackTestVerySmallBoldPink,
                                //                 textAlign: TextAlign.center,
                                //                 textScaler:
                                //                 TextScaler.noScaling,
                                //               ),
                                //             ),
                                //             Expanded(
                                //               flex: 1,
                                //               child: Text(
                                //                 "Defective",
                                //                 style: Styling
                                //                     .itemBlackTestVerySmallBoldPink,
                                //                 textAlign: TextAlign.center,
                                //                 textScaler:
                                //                 TextScaler.noScaling,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(
                                //         left: 5.0,
                                //         right: 5,
                                //       ),
                                //       child: Container(
                                //         color: Color(0xFFFF),
                                //         child:
                                //         Padding(
                                //           padding: const EdgeInsets.only(top: 7.0, bottom: 0),
                                //           child: getCurrentStcOfGodownKeeper.isNotEmpty
                                //               ? ListView.builder(
                                //             shrinkWrap: true,
                                //             padding: EdgeInsets.zero,
                                //             physics: NeverScrollableScrollPhysics(),
                                //             // itemCount: getCurrentStockDetailManager.length,
                                //             itemCount: getCurrentStcOfGodownKeeper.length,
                                //             itemBuilder: (context, index) {
                                //               // final items =
                                //               // getCurrentStockDetailManager[
                                //               // index];
                                //
                                //               final items = getCurrentStcOfGodownKeeper
                                //                   .toList()[index];
                                //
                                //               // return Card(
                                //               //   color: Colors.white,
                                //               //   shape: RoundedRectangleBorder(
                                //               //     borderRadius: BorderRadius.circular(4),
                                //               //   ),
                                //               //   child: Padding(
                                //               //     padding: const EdgeInsets.all(5.0),
                                //               //     child:
                                //               return Column(
                                //                 crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //                 children: [
                                //
                                //                   Padding(
                                //                     padding: const EdgeInsets.all(8.0),
                                //                     child: Row(
                                //                       mainAxisAlignment:
                                //                       MainAxisAlignment.center,
                                //                       children: [
                                //                          Expanded(
                                //                             flex: 1,
                                //                             child: Text(
                                //                               items.itemName.toString(),
                                //                               style: Styling.itemTitle,
                                //                               textAlign: TextAlign.left,
                                //                               textScaler:
                                //                               TextScaler.noScaling,
                                //                             ),
                                //                           ),
                                //
                                //                         Expanded(
                                //                           flex: 1,
                                //                           child: Text(
                                //                             items.currentStkFilled
                                //                                 .toString(),
                                //                             style: Styling.textFormTextSmall,
                                //                             textAlign: TextAlign.center,
                                //                             textScaler:
                                //                             TextScaler.noScaling,
                                //                           ),
                                //                         ),
                                //                         Expanded(
                                //                           flex: 1,
                                //                           child: Text(
                                //                             items.currentStkEmpty
                                //                                 .toString(),
                                //                             style: Styling.textFormTextSmall,
                                //                             textAlign: TextAlign.center,
                                //                             textScaler:
                                //                             TextScaler.noScaling,
                                //                           ),
                                //                         ),
                                //                         Expanded(
                                //                           flex: 1,
                                //                           child: Text(
                                //                             items.currentStkDefective
                                //                                 .toString(),
                                //                             style: Styling.textFormTextSmall,
                                //                             textAlign: TextAlign.center,
                                //                             textScaler:
                                //                             TextScaler.noScaling,
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //
                                //
                                //                   if (index != getCurrentStcOfGodownKeeper.length - 1)
                                //                     Divider(
                                //                       color: Color(0xFFfcf2f1),
                                //                     ),
                                //                 ],
                                //               );
                                //               //   ),
                                //               // );
                                //             },
                                //           )
                                //               : Container(
                                //             child: Text("No Data Available"),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Card(
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.balance_outlined,
                                      size: 20,
                                      // Bigger icon for a more clickable feel
                                      color: Colors.black54,
                                    ),

                                    Expanded(
                                      child: Text(
                                        "Physical Stock Imbalance As Of Today",
                                        style: Styling.bodyTitleBigBoldDashGrey,
                                        textScaler: TextScaler.noScaling,
                                        softWrap: true,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Color(0xFFfcf2f1),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0, top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Cylinder',
                                                  style: Styling
                                                      .bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Imbalance Qty.',
                                                  style: Styling
                                                      .bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 7.0, bottom: 0),
                                          child: receiptList.isNotEmpty
                                              ? ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            // itemCount: getCurrentStockDetailManager.length,
                                            itemCount: receiptList.length,
                                            itemBuilder: (context, index) {
                                              // final items =
                                              // getCurrentStockDetailManager[
                                              // index];

                                              final items =
                                              receiptList.toList()[index];

                                              return Container(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(7.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              items.itemName
                                                                  .toString(),
                                                              style: Styling
                                                                  .textFormText,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              textScaler:
                                                              TextScaler
                                                                  .noScaling,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              items.imbalanceStk
                                                                  .toString(),
                                                              style: Styling
                                                                  .textFormText,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              textScaler:
                                                              TextScaler
                                                                  .noScaling,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (index != receiptList.length - 1)
                                                        Divider(
                                                          color: Color(0xFFfcf2f1),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Row(
                                //         children: [
                                //           Icon(
                                //             Icons.bolt_outlined,
                                //             size: 26,
                                //             color: Colors.black54,
                                //           ),
                                //           Text(
                                //             "Current Stock",
                                //             style: Styling.bodyTitleBigBoldDashGrey,
                                //             textScaler: TextScaler.noScaling,
                                //           ),
                                //         ],
                                //       ),
                                //       SizedBox(width: 10),
                                //       DropdownButton<num>(
                                //         value: selectedItemIdTodayStockCurrentStock,
                                //         items: getCurrentStcOfGodownKeeper.map((item) {
                                //           return DropdownMenuItem<num>(
                                //             value: item.itemId,
                                //             child: Text(item.itemName ?? 'Unknown',
                                //                 style:
                                //                 Styling.itemBlackTestSmallReport),
                                //           );
                                //         }).toList(),
                                //         onChanged: (value) {
                                //           setState(() {
                                //             selectedItemIdTodayStockCurrentStock = value!.toInt();
                                //             final selectedItem =
                                //             getCurrentStcOfGodownKeeper.firstWhere(
                                //                   (item) =>
                                //               item.itemId ==
                                //                   selectedItemIdTodayStockCurrentStock,
                                //               orElse: () =>
                                //                   GetCurrentStcOfGodownKeeperModel(),
                                //             );
                                //             todayOpeningFilledDiffShowCurrentStock =
                                //                 selectedItem.currentStkFilled!.toInt();
                                //             todayOpeningEmptyDiffShowCurrentStock =
                                //                 selectedItem.currentStkEmpty!.toInt();
                                //             todayOpeningDefectiveDiffShowCurrentStock =
                                //                 selectedItem.currentStkDefective!.toInt();
                                //           });
                                //         },
                                //       ),
                                //     ]),
                                // // Row(
                                // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // //     children: [
                                // //       Row(
                                // //         children: [
                                // //           Icon(
                                // //             Icons.bolt_outlined,
                                // //             size: 26,
                                // //             color: Colors.black54,
                                // //           ),
                                // //           Text(
                                // //             "Current Stock",
                                // //             style: Styling.bodyTitleBigBoldDashGrey,
                                // //             textScaler: TextScaler.noScaling,
                                // //           ),
                                // //         ],
                                // //       ),
                                // //       SizedBox(width: 10),
                                // //       Padding(
                                // //         padding: const EdgeInsets.all(8.0),
                                // //         child:
                                // //         SizedBox(
                                // //           height: 30, // Button Height
                                // //           width: 90, // Button Width
                                // //           child: ElevatedButton(
                                // //             onPressed: () {
                                // //               if (saveFlag) {
                                // //                 showFlushBar(
                                // //                     context,
                                // //                     Constants
                                // //                         .dayEndCompleted);
                                // //               } else {
                                // //                 _showItemPopup();
                                // //                 // if(stockTransferFlag){
                                // //                 // Navigator.pushNamed(
                                // //                 //   context,
                                // //                 //   StockTransferTOGodownScreen
                                // //                 //       .screenName,
                                // //                 //   // arguments: {
                                // //                 //   //   "itemName": items
                                // //                 //   //       .itemName,
                                // //                 //   //   "itemID":
                                // //                 //   //   items.itemId,
                                // //                 //   //   "filledStock": items
                                // //                 //   //       .currentStkFilled,
                                // //                 //   //   "emptyStock": items
                                // //                 //   //       .currentStkEmpty,
                                // //                 //   //   "defectiveStock":
                                // //                 //   //   items
                                // //                 //   //       .currentStkDefective,
                                // //                 //   // }
                                // //                 // );
                                // //                 // }else{
                                // //                 //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                                // //                 // }
                                // //               }
                                // //             },
                                // //             style: ElevatedButton
                                // //                 .styleFrom(
                                // //               backgroundColor:
                                // //               Color(0xFFfbe9e9),
                                // //               // Button Color
                                // //               // backgroundColor: Color(0xFFfbe9e9),   // Button Color
                                // //               foregroundColor:
                                // //               Colors.black,
                                // //               // Text Color (simple way)
                                // //               shape:
                                // //               RoundedRectangleBorder(
                                // //                 borderRadius:
                                // //                 BorderRadius
                                // //                     .circular(20),
                                // //               ),
                                // //               padding: EdgeInsets.zero,
                                // //
                                // //             ),
                                // //             child: Text(
                                // //               'Transfe',
                                // //               style: TextStyle(
                                // //                 fontWeight:
                                // //                 FontWeight.bold,
                                // //                 fontSize: 12,
                                // //               ),
                                // //             ),
                                // //           ),
                                // //         ),
                                // //       ),
                                // //     ]),
                                //
                                // SizedBox(height: 5),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Expanded(
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color: Color(0xFFEFF2FB),
                                //           borderRadius: BorderRadius.circular(12),
                                //           boxShadow: [
                                //             BoxShadow(
                                //                 color: Colors.grey.shade200,
                                //                 blurRadius: 4)
                                //           ],
                                //         ),
                                //         padding: EdgeInsets.all(10),
                                //         child: Padding(
                                //           padding: EdgeInsets.all(4.0),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //             children: [
                                //               Text(
                                //                 todayOpeningFilledDiffShowCurrentStock.toString(),
                                //                 // Replace this with your dynamic data
                                //                 style: Styling.bodyTitleBigBoldDashGrey
                                //                     .copyWith(
                                //                   fontSize: 18,
                                //                   color: Colors.blue,
                                //                   fontWeight: FontWeight.bold,
                                //                   decorationColor: Colors.blue,
                                //                 ),
                                //                 textAlign: TextAlign.center,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //               const SizedBox(height: 4),
                                //               Text(
                                //                 'Filled',
                                //                 style: Styling.bodyTitleBig,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 10),
                                //     Expanded(
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color: Color(0xFFEFF2FB),
                                //           borderRadius: BorderRadius.circular(12),
                                //           boxShadow: [
                                //             BoxShadow(
                                //                 color: Colors.grey.shade200,
                                //                 blurRadius: 4)
                                //           ],
                                //         ),
                                //         padding: EdgeInsets.all(10),
                                //         child: Padding(
                                //           padding: EdgeInsets.all(4.0),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //             children: [
                                //               Text(
                                //                 todayOpeningEmptyDiffShowCurrentStock.toString(),
                                //                 // Replace this with your dynamic data
                                //                 style: Styling.bodyTitleBigBoldDashGrey
                                //                     .copyWith(
                                //                   fontSize: 18,
                                //                   color: Colors.blue,
                                //                   fontWeight: FontWeight.bold,
                                //                   decorationColor: Colors.blue,
                                //                 ),
                                //                 textAlign: TextAlign.center,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //               const SizedBox(height: 4),
                                //               Text(
                                //                 'Empty',
                                //                 style: Styling.bodyTitleBig,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 10),
                                //     Expanded(
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           color: Color(0xFFEFF2FB),
                                //           borderRadius: BorderRadius.circular(12),
                                //           boxShadow: [
                                //             BoxShadow(
                                //                 color: Colors.grey.shade200,
                                //                 blurRadius: 4)
                                //           ],
                                //         ),
                                //         padding: EdgeInsets.all(10),
                                //         child: Padding(
                                //           padding: EdgeInsets.all(4.0),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //             children: [
                                //               Text(
                                //                 todayOpeningDefectiveDiffShowCurrentStock
                                //                     .toString(),
                                //                 // Replace this with your dynamic data
                                //                 style: Styling.bodyTitleBigBoldDashGrey
                                //                     .copyWith(
                                //                   fontSize: 18,
                                //                   color: Colors.blue,
                                //                   decorationColor: Colors.blue,
                                //                   fontWeight: FontWeight.bold,
                                //                 ),
                                //                 textAlign: TextAlign.center,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //               const SizedBox(height: 4),
                                //               Text(
                                //                 'Defective',
                                //                 style: Styling.bodyTitleBig,
                                //                 textScaler: TextScaler.noScaling,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Card(
                                //   margin: EdgeInsets.zero,
                                //   color: Colors.white,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius:
                                //     BorderRadius.circular(4),
                                //   ),
                                //
                                //     child: Column(
                                //       children: [
                                //         Container(
                                //           color: Color(0xFFEFF2FB),
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(
                                //                 bottom: 10.0, top: 10),
                                //             child: Row(
                                //               mainAxisAlignment:
                                //               MainAxisAlignment.center,
                                //               children: [
                                //                 Expanded(
                                //                   flex: 1,
                                //                   child: Text(
                                //                     "",
                                //                     style: Styling.itemTitle,
                                //                     textAlign: TextAlign.left,
                                //                     textScaler:
                                //                     TextScaler.noScaling,
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   flex: 1,
                                //                   child: Text(
                                //                     "Filled",
                                //                     style: Styling
                                //                         .itemBlackTestVerySmallBoldPink,
                                //                     textAlign: TextAlign.center,
                                //                     textScaler:
                                //                     TextScaler.noScaling,
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   flex: 1,
                                //                   child: Text(
                                //                     "Empty",
                                //                     style: Styling
                                //                         .itemBlackTestVerySmallBoldPink,
                                //                     textAlign: TextAlign.center,
                                //                     textScaler:
                                //                     TextScaler.noScaling,
                                //                   ),
                                //                 ),
                                //                 Expanded(
                                //                   flex: 1,
                                //                   child: Text(
                                //                     "Defective",
                                //                     style: Styling
                                //                         .itemBlackTestVerySmallBoldPink,
                                //                     textAlign: TextAlign.center,
                                //                     textScaler:
                                //                     TextScaler.noScaling,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         Padding(
                                //           padding: const EdgeInsets.only(
                                //             left: 5.0,
                                //             right: 5,
                                //           ),
                                //           child: Container(
                                //             color: Color(0xFFFF),
                                //             child:
                                //                                   Padding(
                                //           padding: const EdgeInsets.only(top: 7.0, bottom: 0),
                                //           child: getCurrentStcOfGodownKeeper.isNotEmpty
                                //               ? ListView.builder(
                                //                   shrinkWrap: true,
                                //                   padding: EdgeInsets.zero,
                                //                   physics: NeverScrollableScrollPhysics(),
                                //                   // itemCount: getCurrentStockDetailManager.length,
                                //                   itemCount: getCurrentStcOfGodownKeeper.length,
                                //                   itemBuilder: (context, index) {
                                //                     // final items =
                                //                     // getCurrentStockDetailManager[
                                //                     // index];
                                //
                                //                     final items = getCurrentStcOfGodownKeeper
                                //                         .toList()[index];
                                //
                                //                     // return Card(
                                //                     //   color: Colors.white,
                                //                     //   shape: RoundedRectangleBorder(
                                //                     //     borderRadius: BorderRadius.circular(4),
                                //                     //   ),
                                //                     //   child: Padding(
                                //                     //     padding: const EdgeInsets.all(5.0),
                                //                     //     child:
                                //                        return Column(
                                //                           crossAxisAlignment:
                                //                               CrossAxisAlignment.start,
                                //                           children: [
                                //
                                //                             Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: Row(
                                //                                 mainAxisAlignment:
                                //                                     MainAxisAlignment.center,
                                //                                 children: [
                                //                                   Expanded(
                                //                                     flex: 1,
                                //                                     child: Text(
                                //                                       items.itemName.toString(),
                                //                                       style: Styling.itemTitle,
                                //                                       textAlign: TextAlign.left,
                                //                                       textScaler:
                                //                                       TextScaler.noScaling,
                                //                                     ),
                                //                                   ),
                                //                                   Expanded(
                                //                                     flex: 1,
                                //                                     child: Text(
                                //                                       items.currentStkFilled
                                //                                           .toString(),
                                //                                       style: Styling.textFormTextSmall,
                                //                                       textAlign: TextAlign.center,
                                //                                       textScaler:
                                //                                           TextScaler.noScaling,
                                //                                     ),
                                //                                   ),
                                //                                   Expanded(
                                //                                     flex: 1,
                                //                                     child: Text(
                                //                                       items.currentStkEmpty
                                //                                           .toString(),
                                //                                       style: Styling.textFormTextSmall,
                                //                                       textAlign: TextAlign.center,
                                //                                       textScaler:
                                //                                           TextScaler.noScaling,
                                //                                     ),
                                //                                   ),
                                //                                   Expanded(
                                //                                     flex: 1,
                                //                                     child: Text(
                                //                                       items.currentStkDefective
                                //                                           .toString(),
                                //                                       style: Styling.textFormTextSmall,
                                //                                       textAlign: TextAlign.center,
                                //                                       textScaler:
                                //                                           TextScaler.noScaling,
                                //                                     ),
                                //                                   ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //
                                //
                                //                             if (index != getCurrentStcOfGodownKeeper.length - 1)
                                //                               Divider(
                                //                                 color: Color(0xFFfcf2f1),
                                //                               ),
                                //                           ],
                                //                         );
                                //                     //   ),
                                //                     // );
                                //                   },
                                //                 )
                                //               : Container(
                                //                   child: Text("No Data Available"),
                                //                 ),
                                //                                   ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //
                                // )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Card(
                            margin: EdgeInsets.zero,
                            color: Color(0xFFEFFFFfff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5),
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.bar_chart,
                                            size: 20,
                                            // Bigger icon for a more clickable feel
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width:4),
                                          Text(
                                            "SQC Status",
                                            style:
                                            Styling.bodyTitleBigBoldDashGrey,
                                            textScaler: TextScaler.noScaling,
                                          ),
                                        ],
                                      ),
                                      // SizedBox(width: 10),
                                      // DropdownButton<String>(
                                      //   value: selectedTransMode,  // Assuming you have this variable declared
                                      //   items: getTransMode.map((transMode) {
                                      //     return DropdownMenuItem<String>(
                                      //       value: transMode,
                                      //       child: Text(
                                      //         transMode,
                                      //         style: Styling.itemBlackTestBigs,
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       selectedTransMode = value!;
                                      //       debugPrint("selectedTransMode $selectedTransMode");
                                      //
                                      //       if(selectedTransMode == "Today's"){
                                      //         // dayFlag = "TODAYS";
                                      //         debugPrint("dayFlag dayFlag");
                                      //       }else if(selectedTransMode == "This Month"){
                                      //         // dayFlag = "THISMONTH";
                                      //         debugPrint("dayFlag dayFlag");
                                      //       }else{
                                      //         // dayFlag = "";
                                      //       }
                                      //       // fetchSVARBFilterCountList(dayFlag!);
                                      //     });
                                      //   },
                                      // ),
                                    ]),
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                  child: getSqcCardCntList.isNotEmpty
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Color(0xFFfcf2f1),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom:10.0,top:10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Todays',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'This Month',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 7.0,bottom: 7),
                                          child:
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Truck In',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  TodayTruckIn.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  MonthTruckIn.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child:
                                              //   InkWell(
                                              //     onTap: () {
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         SVProfitDetailScreenUI
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child:
                                              //     Text(
                                              //       svGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           svGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child:
                                              //   InkWell(
                                              //     onTap: () {
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         SVProfitDetailScreenUI
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       svGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           svGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              //
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xFFfcf2f1),),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:7.0,bottom:7),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'SQC Done',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  TodaySQCDone.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  MonthSQCDone.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child: InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         ARBProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       arbGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           arbGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child: InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         ARBProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossProfit",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       arbGrossProfitCount != null
                                              //           ? formatCurrency(
                                              //           arbGrossProfitCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xFFfcf2f1),),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:7.0,bottom:7),
                                          child:
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Not Done',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  TodayNotDone.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  MonthNotDone.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child: InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child:InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossProfit",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossProfitCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossProfitCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xFFfcf2f1),),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:7.0,bottom:7),
                                          child:
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Leak',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  TodayBodyLeak.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  MonthBodyLeak.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child: InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child:InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossProfit",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossProfitCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossProfitCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Color(0xFFfcf2f1),),
                                      Container(
                                        color: Color(0xFFFF),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:7.0,bottom:7),
                                          child:
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Less Qty',
                                                  style: Styling.bodyTitleWithBlueHightDashboard,
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.noScaling,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  TodayLessQtyCyls.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child:
                                                Text(
                                                  MonthLessQtyCyls.toString(),
                                                  style: Styling
                                                      .textFormText,
                                                  textScaler:
                                                  TextScaler.noScaling,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child: InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossRevenue",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossRevenueCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossRevenueCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //   flex: 2,
                                              //   child:InkWell(
                                              //     onTap: (){
                                              //       Navigator.pushNamed(
                                              //         context,
                                              //         RefillProfitDetailScreenUi
                                              //             .screenName,
                                              //         arguments: {
                                              //           "DAYFLAG": dayFlag,
                                              //           "PROFITFOR":"GrossProfit",
                                              //         },
                                              //       );
                                              //     },
                                              //     child: Text(
                                              //       refillGrossProfitCount != null
                                              //           ? formatCurrency(
                                              //           refillGrossProfitCount!)
                                              //           : '0',
                                              //       style: Styling
                                              //           .blueClrTextWithUnderline,
                                              //       textScaler:
                                              //       TextScaler.noScaling,
                                              //       overflow: TextOverflow
                                              //           .ellipsis,
                                              //       textAlign: TextAlign.center,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:4),
                                    ],
                                  )
                                      : Container(
                                    child: Text("No Data Available"),
                                  ),

                                ),
                              ]),
                            )),
                        SizedBox(height: 15),
                        // Card(
                        //   // margin: EdgeInsets.zero,
                        //   // color: const Color(0xFFEFFFFF),
                        //   // shape: const RoundedRectangleBorder(
                        //   //   borderRadius: BorderRadius.only(
                        //   //     topRight: Radius.circular(20.0),
                        //   //     topLeft: Radius.circular(20.0),
                        //   //   ),
                        //   // ),
                        //   // child: Padding(
                        //   //   padding: const EdgeInsets.symmetric(horizontal: 5),
                        //     margin: EdgeInsets.zero,
                        //     color: Color(0xFFEFFFFfff),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(20.0),
                        //             topLeft: Radius.circular(20.0))),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(
                        //         left: 5.0,
                        //         right: 5,
                        //       ),
                        //     child: Column(
                        //       children: [
                        //         const SizedBox(height: 5),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 Icon(
                        //                   Icons.local_shipping,
                        //                   size: 26,
                        //                   color: Colors.black54,
                        //                 ),
                        //                 Text(
                        //                   "Today Vehicle Status",
                        //                   style: Styling.bodyTitleBigBoldDashGrey,
                        //                   textScaler: TextScaler.noScaling,
                        //                 ),
                        //               ],
                        //             ),
                        //             SizedBox(width: 10),
                        //             DropdownButton<String>(
                        //               value: selectedSQCStatus,
                        //               items: ["All", "Yes", "No"].map((status) {
                        //                 return DropdownMenuItem<String>(
                        //                   value: status,
                        //                   child: Text(status),
                        //                 );
                        //               }).toList(),
                        //               onChanged: (value) {
                        //                 selectedSQCStatus = value ?? "All";
                        //                 filterSQCList(); // Filter list when user selects
                        //               },
                        //             ),
                        //           ],
                        //         ),
                        //
                        //         const SizedBox(height: 10),
                        //
                        //         /// INNER CARD
                        //         Card(
                        //           margin: EdgeInsets.zero,
                        //           color: Colors.white,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(4),
                        //           ),
                        //           child: Column(
                        //             children: [
                        //               /// HEADER ROW
                        //               Container(
                        //                 color: const Color(0xFFfcf2f1),
                        //                 padding: const EdgeInsets.symmetric(vertical: 10),
                        //                 child: Row(
                        //                   children: const [
                        //                     Expanded(
                        //                       child: Text(
                        //                         'Vehicle No.',
                        //                         textAlign: TextAlign.center,
                        //                         style: TextStyle(fontWeight: FontWeight.bold),
                        //                       ),
                        //                     ),
                        //                     // Expanded(
                        //                     //   child: Text(
                        //                     //     'SQC Done',
                        //                     //     textAlign: TextAlign.center,
                        //                     //     style: TextStyle(fontWeight: FontWeight.bold),
                        //                     //   ),
                        //                     // ),
                        //                   ],
                        //                 ),
                        //               ),
                        //
                        //               filteredSqcList.isNotEmpty
                        //                   ? ListView.builder(
                        //                 shrinkWrap: true,
                        //                 physics: const NeverScrollableScrollPhysics(),
                        //                 itemCount: filteredSqcList.length,
                        //                 itemBuilder: (context, index) {
                        //                   final item = filteredSqcList[index];
                        //
                        //                   return Column(
                        //                     children: [
                        //                       Padding(
                        //                         padding: const EdgeInsets.all(8.0),
                        //                         child: Row(
                        //                           children: [
                        //                             /// Vehicle No
                        //                             Expanded(
                        //                               child: Text(
                        //                                 item.vehicleNo ?? "",
                        //                                 textAlign: TextAlign.center,
                        //                               ),
                        //                             ),
                        //
                        //                             /// SQC Status
                        //                             // Expanded(
                        //                             //   child: Container(
                        //                             //     alignment: Alignment.center,
                        //                             //     padding: const EdgeInsets.symmetric(
                        //                             //         vertical: 5),
                        //                             //     child: Container(
                        //                             //       padding: const EdgeInsets.symmetric(
                        //                             //           horizontal: 10, vertical: 5),
                        //                             //       decoration: BoxDecoration(
                        //                             //         color: (item.sQCStatus ?? "")
                        //                             //             .toLowerCase() ==
                        //                             //             "yes"
                        //                             //             ? Colors.green
                        //                             //             : Colors.red,
                        //                             //         borderRadius:
                        //                             //         BorderRadius.circular(6),
                        //                             //       ),
                        //                             //       child: Text(
                        //                             //         (item.sQCStatus ?? "")
                        //                             //             .toUpperCase(),
                        //                             //         style: const TextStyle(
                        //                             //           color: Colors.white,
                        //                             //           fontWeight: FontWeight.bold,
                        //                             //         ),
                        //                             //       ),
                        //                             //     ),
                        //                             //   ),
                        //                             // ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //
                        //                       /// Divider
                        //                       if (index != filteredSqcList.length - 1)
                        //                         const Divider(color: Color(0xFFfcf2f1)),
                        //                     ],
                        //                   );
                        //                 },
                        //               )
                        //                   : const Padding(
                        //                 padding: EdgeInsets.all(10),
                        //                 child: Text("No Data Available"),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Card(
                          // margin: EdgeInsets.zero,
                          // color: const Color(0xFFEFFFFF),
                          // shape: const RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(20.0),
                          //     topLeft: Radius.circular(20.0),
                          //   ),
                          // ),
                          // child: Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: EdgeInsets.zero,
                          color: Color(0xFFEFFFFfff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_shipping,
                                          size: 26,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          "Today Vehicle SQC",
                                          style: Styling.bodyTitleBigBoldDashGrey,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    DropdownButton<String>(
                                      value: selectedSQCStatus,
                                      // items: ["All", "SQC Done", "SQC Not Done"].map((status) {
                                      items: ["All Vehicles", "SQC Completed", "SQC Pending"].map((status) {
                                        return DropdownMenuItem<String>(
                                          value: status,
                                          child: Text(status),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedSQCStatus = value ?? "All Vehicles";
                                        filterSQCList(); // Filter list when user selects
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: const Color(0xFFfcf2f1),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: const [
                                            Expanded(
                                              child: Text(
                                                'Vehicle No.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                'SQC Done',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      filteredSqcList.isNotEmpty
                                          ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: filteredSqcList.length,
                                        itemBuilder: (context, index) {
                                          final item = filteredSqcList[index];

                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    /// Vehicle No
                                                    Expanded(
                                                      child: Text(
                                                        item.vehicleNo ?? "",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),

                                                    /// SQC Status
                                                    // Expanded(
                                                    //   child: Container(
                                                    //     alignment: Alignment.center,
                                                    //     padding: const EdgeInsets.symmetric(
                                                    //         vertical: 5),
                                                    //     child: Container(
                                                    //       padding: const EdgeInsets.symmetric(
                                                    //           horizontal: 10, vertical: 5),
                                                    //       decoration: BoxDecoration(
                                                    //         color: (item.sQCStatus ?? "")
                                                    //             .toLowerCase() ==
                                                    //             "yes"
                                                    //             // ? Colors.green
                                                    //             // : Colors.red,
                                                    //           ? Colors.grey
                                                    //           : Colors.grey,
                                                    //       borderRadius:
                                                    //         BorderRadius.circular(6),
                                                    //       ),
                                                    //       child: Text(
                                                    //         (item.sQCStatus ?? "")
                                                    //             .toUpperCase(),
                                                    //         style: const TextStyle(
                                                    //           color: Colors.white,
                                                    //           fontWeight: FontWeight.bold,
                                                    //         ),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          (item.sQCStatus ?? "").toUpperCase(),
                                                          style: const TextStyle(
                                                            color: Colors.black, // normal text color
                                                            fontWeight: FontWeight.normal, // remove bold if desired
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              if (index != filteredSqcList.length - 1)
                                                const Divider(color: Color(0xFFfcf2f1)),
                                            ],
                                          );
                                        },
                                      )
                                          : const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("No Data Available"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
          // Expanded(
          //   child: SingleChildScrollView(
          //     // Ensures the content is scrollable
          //     child: Padding(
          //       padding: const EdgeInsets.only(
          //           left: 5.0, right: 5.0, bottom: 5.0, top: 20.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // Title for Cylinder Categories Table
          //               GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     isTodayOpeningStockListViewVisible =
          //                         !isTodayOpeningStockListViewVisible; // Toggle ListView visibility
          //                   });
          //                 },
          //                 child: Card(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Column(
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               bodyTitleBlue(
          //                                   "View Today's Opening Stock"),
          //                               Icon(
          //                                 isTodayOpeningStockListViewVisible
          //                                     ? Icons.arrow_drop_up
          //                                     : Icons.arrow_drop_down,
          //                                 size: 30,
          //                                 // Bigger icon for a more clickable feel
          //                                 color: Color(0xff1280b3),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         Visibility(
          //                           visible: isTodayOpeningStockListViewVisible,
          //                           child: Card(
          //                             elevation: 5,
          //                             shape: RoundedRectangleBorder(
          //                               borderRadius: BorderRadius.circular(12),
          //                             ),
          //                             child: Column(
          //                               children: [
          //                                 Container(
          //                                   decoration: BoxDecoration(
          //                                     color: Colors.blue.shade100,
          //                                     borderRadius: BorderRadius.only(
          //                                       topLeft: Radius.circular(12),
          //                                       topRight: Radius.circular(12),
          //                                     ),
          //                                   ),
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.all(8.0),
          //                                     child: Row(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.center,
          //                                       children: [
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Text(
          //                                             '',
          //                                             style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold,
          //                                               color: Colors.black,
          //                                               fontSize: 14,
          //                                             ),
          //                                             textAlign:
          //                                                 TextAlign.center,
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Text(
          //                                             'Filled',
          //                                             style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold,
          //                                               color: Colors.black,
          //                                               fontSize: 14,
          //                                             ),
          //                                             textAlign:
          //                                                 TextAlign.center,
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Text(
          //                                             'Empty',
          //                                             style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold,
          //                                               color: Colors.black,
          //                                               fontSize: 14,
          //                                             ),
          //                                             textAlign:
          //                                                 TextAlign.center,
          //                                           ),
          //                                         ),
          //                                         Expanded(
          //                                           flex: 1,
          //                                           child: Text(
          //                                             'Defective',
          //                                             style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold,
          //                                               color: Colors.black,
          //                                               fontSize: 14,
          //                                             ),
          //                                             textAlign:
          //                                                 TextAlign.center,
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 todaysOpeningStock.isNotEmpty
          //                                     ? ListView.builder(
          //                                         shrinkWrap: true,
          //                                         physics:
          //                                             NeverScrollableScrollPhysics(),
          //                                         itemCount:
          //                                             todaysOpeningStock.length,
          //                                         itemBuilder:
          //                                             (context, index) {
          //                                           final items =
          //                                               todaysOpeningStock[
          //                                                   index];
          //
          //                                           return Card(
          //                                             margin:
          //                                                 EdgeInsets.symmetric(
          //                                                     vertical: 7,
          //                                                     horizontal: 7),
          //                                             elevation: 4,
          //                                             shape:
          //                                                 RoundedRectangleBorder(
          //                                                     borderRadius:
          //                                                         BorderRadius
          //                                                             .circular(
          //                                                                 12)),
          //                                             child: Padding(
          //                                               padding:
          //                                                   const EdgeInsets
          //                                                       .all(8.0),
          //                                               child: Column(
          //                                                 crossAxisAlignment:
          //                                                     CrossAxisAlignment
          //                                                         .start,
          //                                                 children: [
          //                                                   Row(
          //                                                     mainAxisAlignment:
          //                                                         MainAxisAlignment
          //                                                             .center,
          //                                                     children: [
          //                                                       Expanded(
          //                                                         flex: 1,
          //                                                         child: Text(
          //                                                           items
          //                                                               .itemName
          //                                                               .toString(),
          //                                                           style: Styling
          //                                                               .textFormText,
          //                                                           textAlign:
          //                                                               TextAlign
          //                                                                   .center,
          //                                                         ),
          //                                                       ),
          //                                                       Expanded(
          //                                                         flex: 1,
          //                                                         child: Text(
          //                                                           items
          //                                                               .filledOpeningStk
          //                                                               .toString(),
          //                                                           style: Styling
          //                                                               .textFormText,
          //                                                           textAlign:
          //                                                               TextAlign
          //                                                                   .center,
          //                                                         ),
          //                                                       ),
          //                                                       Expanded(
          //                                                         flex: 1,
          //                                                         child: Text(
          //                                                           items
          //                                                               .emptyOpeningStk
          //                                                               .toString(),
          //                                                           style: Styling
          //                                                               .textFormText,
          //                                                           textAlign:
          //                                                               TextAlign
          //                                                                   .center,
          //                                                         ),
          //                                                       ),
          //                                                       Expanded(
          //                                                         flex: 1,
          //                                                         child: Text(
          //                                                           items
          //                                                               .defOpeningStk
          //                                                               .toString(),
          //                                                           style: Styling
          //                                                               .textFormText,
          //                                                           textAlign:
          //                                                               TextAlign
          //                                                                   .center,
          //                                                         ),
          //                                                       ),
          //                                                     ],
          //                                                   ),
          //                                                 ],
          //                                               ),
          //                                             ),
          //                                           );
          //                                         },
          //                                       )
          //                                     : Container(
          //                                         child:
          //                                             Text("No Data Available"),
          //                                       ),
          //                               ],
          //                             ),
          //                           ),
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 10),
          //             ],
          //           ),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // Title for Cylinder Categories Table
          //               GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     isPhysicalStockListViewVisible =
          //                         !isPhysicalStockListViewVisible; // Toggle ListView visibility
          //                   });
          //                 },
          //                 child: Card(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Column(
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               bodyTitleBlue(
          //                                   "Physical Stock Imbalance As Of Today"),
          //                               Icon(
          //                                 isPhysicalStockListViewVisible
          //                                     ? Icons.arrow_drop_up
          //                                     : Icons.arrow_drop_down,
          //                                 size: 30,
          //                                 // Bigger icon for a more clickable feel
          //                                 color: Color(0xff1280b3),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         Visibility(
          //                           visible: isPhysicalStockListViewVisible,
          //                           child: Container(
          //                             margin:
          //                                 EdgeInsets.symmetric(horizontal: 5),
          //                             decoration: BoxDecoration(
          //                               color: Colors.white70,
          //                               borderRadius: BorderRadius.circular(12),
          //                               boxShadow: [
          //                                 BoxShadow(
          //                                     blurRadius: 4,
          //                                     color: Colors.black12,
          //                                     spreadRadius: 2),
          //                               ],
          //                             ),
          //                             child: Column(
          //                               children: [
          //                                 // Header Row for Cylinder Categories
          //                                 Container(
          //                                   decoration: BoxDecoration(
          //                                     color: Colors.blue.shade100,
          //                                     borderRadius: BorderRadius.only(
          //                                       topLeft: Radius.circular(12),
          //                                       topRight: Radius.circular(12),
          //                                     ),
          //                                   ),
          //                                   padding: const EdgeInsets.only(
          //                                       top: 8, bottom: 8, left: 10),
          //                                   child: Row(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment.center,
          //                                     children: [
          //                                       Expanded(
          //                                         child: Text(
          //                                           'Cylinder',
          //                                           style: TextStyle(
          //                                             fontWeight:
          //                                                 FontWeight.bold,
          //                                             color: Colors.black,
          //                                             fontSize: 14,
          //                                           ),
          //                                           textAlign: TextAlign.center,
          //                                         ),
          //                                       ),
          //                                       VerticalDivider(
          //                                           thickness: 1,
          //                                           color: Colors.grey),
          //                                       Expanded(
          //                                         child: Text(
          //                                           'Imbalance Qty',
          //                                           style: TextStyle(
          //                                             fontWeight:
          //                                                 FontWeight.bold,
          //                                             color: Colors.black,
          //                                             fontSize: 14,
          //                                           ),
          //                                           textAlign: TextAlign.center,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //
          //                                 // List of Cylinder Categories
          //                                 receiptList.isNotEmpty
          //                                     ? ListView.builder(
          //                                         shrinkWrap: true,
          //                                         physics:
          //                                             NeverScrollableScrollPhysics(),
          //                                         itemCount: receiptList.length,
          //                                         itemBuilder:
          //                                             (context, index) {
          //                                           final item =
          //                                               receiptList[index];
          //                                           return Card(
          //                                             margin:
          //                                                 EdgeInsets.symmetric(
          //                                                     vertical: 7,
          //                                                     horizontal: 7),
          //                                             elevation: 4,
          //                                             shape:
          //                                                 RoundedRectangleBorder(
          //                                                     borderRadius:
          //                                                         BorderRadius
          //                                                             .circular(
          //                                                                 12)),
          //                                             child: Padding(
          //                                               padding:
          //                                                   const EdgeInsets
          //                                                       .all(8.0),
          //                                               child: Row(
          //                                                 mainAxisAlignment:
          //                                                     MainAxisAlignment
          //                                                         .spaceBetween,
          //                                                 children: [
          //                                                   // Cylinder Category Text
          //                                                   Expanded(
          //                                                     child: Text(
          //                                                       item.itemName ??
          //                                                           "Unknown",
          //                                                       style: Styling
          //                                                           .textFormText,
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .center,
          //                                                     ),
          //                                                   ),
          //                                                   // Divider between Texts
          //                                                   VerticalDivider(
          //                                                       thickness: 1,
          //                                                       color: Colors
          //                                                           .grey),
          //                                                   // Imbalance Quantity with Tap Gesture
          //                                                   Expanded(
          //                                                     child:
          //                                                         GestureDetector(
          //                                                       onTap: () {
          //                                                         // Handle the tap on the 'emptyCount' text
          //                                                         setState(() {
          //                                                           // Perform any action when clicked
          //                                                         });
          //                                                       },
          //                                                       child: Text(
          //                                                           '${item.imbalanceStk ?? 0}',
          //                                                           textAlign:
          //                                                               TextAlign
          //                                                                   .center,
          //                                                           style: Styling
          //                                                               .textFormText),
          //                                                     ),
          //                                                   ),
          //                                                 ],
          //                                               ),
          //                                             ),
          //                                           );
          //                                         },
          //                                       )
          //                                     : Container(
          //                                         child:
          //                                             Text("No Data Available"),
          //                                       )
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 10),
          //             ],
          //           ),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // Title for Cylinder Categories Table
          //               // GestureDetector(
          //               //   onTap: () {
          //               //     setState(() {
          //               //       isCurrentStockListViewVisible =
          //               //       !isCurrentStockListViewVisible; // Toggle ListView visibility
          //               //     });
          //               //   },
          //               //   child:
          //               Card(
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Column(
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             // Text(
          //                             //   "View Today's Opening Stock",
          //                             //   style: TextStyle(
          //                             //       fontSize: 14,
          //                             //       color: Colors.black,
          //                             //       fontWeight: FontWeight.bold),
          //                             // ),
          //                             bodyTitleBlue("View Current Stock"),
          //                             // Icon(
          //                             //   isCurrentStockListViewVisible
          //                             //       ? Icons.arrow_drop_up
          //                             //       : Icons.arrow_drop_down,
          //                             //   size: 30, // Bigger icon for a more clickable feel
          //                             //   color:Color(0xff1280b3),
          //                             // ),
          //                           ],
          //                         ),
          //                       ),
          //                       // Visibility(
          //                       //   visible:
          //                       //   isCurrentStockListViewVisible,
          //                       //   child:
          //                       Card(
          //                         elevation: 5,
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(12),
          //                         ),
          //                         child: Column(
          //                           children: [
          //                             Container(
          //                               decoration: BoxDecoration(
          //                                 color: Colors.blue.shade100,
          //                                 borderRadius: BorderRadius.only(
          //                                   topLeft: Radius.circular(12),
          //                                   topRight: Radius.circular(12),
          //                                 ),
          //                               ),
          //                               child: Padding(
          //                                 padding: const EdgeInsets.all(8.0),
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: [
          //                                     Expanded(
          //                                       flex: 1,
          //                                       child: Text(
          //                                         '',
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           color: Colors.black,
          //                                           fontSize: 14,
          //                                         ),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                     Expanded(
          //                                       flex: 1,
          //                                       child: Text(
          //                                         'Filled',
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           color: Colors.black,
          //                                           fontSize: 14,
          //                                         ),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                     Expanded(
          //                                       flex: 1,
          //                                       child: Text(
          //                                         'Empty',
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           color: Colors.black,
          //                                           fontSize: 14,
          //                                         ),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                     Expanded(
          //                                       flex: 1,
          //                                       child: Text(
          //                                         'Defective',
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           color: Colors.black,
          //                                           fontSize: 14,
          //                                         ),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                     Expanded(
          //                                       flex: 1,
          //                                       child: Text(
          //                                         '',
          //                                         style: TextStyle(
          //                                           fontWeight: FontWeight.bold,
          //                                           color: Colors.black,
          //                                           fontSize: 14,
          //                                         ),
          //                                         textAlign: TextAlign.center,
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             getCurrentStcOfGodownKeeper.isNotEmpty
          //                                 ? ListView.builder(
          //                                     shrinkWrap: true,
          //                                     physics:
          //                                         NeverScrollableScrollPhysics(),
          //                                     itemCount:
          //                                         getCurrentStcOfGodownKeeper
          //                                             .length,
          //                                     itemBuilder: (context, index) {
          //                                       final items =
          //                                           getCurrentStcOfGodownKeeper[
          //                                               index];
          //
          //                                       return Card(
          //                                         margin: EdgeInsets.symmetric(
          //                                             vertical: 7,
          //                                             horizontal: 7),
          //                                         elevation: 4,
          //                                         shape: RoundedRectangleBorder(
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     12)),
          //                                         child: Padding(
          //                                           padding:
          //                                               const EdgeInsets.all(
          //                                                   8.0),
          //                                           child: Column(
          //                                             crossAxisAlignment:
          //                                                 CrossAxisAlignment
          //                                                     .start,
          //                                             children: [
          //                                               Row(
          //                                                 mainAxisAlignment:
          //                                                     MainAxisAlignment
          //                                                         .center,
          //                                                 children: [
          //                                                   Expanded(
          //                                                     flex: 1,
          //                                                     child: Text(
          //                                                       items.itemName
          //                                                           .toString(),
          //                                                       style: Styling
          //                                                           .textFormText,
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .center,
          //                                                     ),
          //                                                   ),
          //                                                   Expanded(
          //                                                     flex: 1,
          //                                                     child: Text(
          //                                                       items
          //                                                           .currentStkFilled
          //                                                           .toString(),
          //                                                       style: Styling
          //                                                           .textFormText,
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .center,
          //                                                     ),
          //                                                   ),
          //                                                   Expanded(
          //                                                     flex: 1,
          //                                                     child: Text(
          //                                                       items
          //                                                           .currentStkEmpty
          //                                                           .toString(),
          //                                                       style: Styling
          //                                                           .textFormText,
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .center,
          //                                                     ),
          //                                                   ),
          //                                                   Expanded(
          //                                                     flex: 1,
          //                                                     child: Text(
          //                                                       items
          //                                                           .currentStkDefective
          //                                                           .toString(),
          //                                                       style: Styling
          //                                                           .textFormText,
          //                                                       textAlign:
          //                                                           TextAlign
          //                                                               .center,
          //                                                     ),
          //                                                   ),
          //                                                   Expanded(
          //                                                     flex: 1,
          //                                                     child:
          //                                                         GestureDetector(
          //                                                       onTap: () {
          //                                                         if (saveFlag) {
          //                                                           showFlushBar(
          //                                                               context,
          //                                                               Constants
          //                                                                   .dayEndCompleted);
          //                                                         } else {
          //                                                           // if(stockTransferFlag){
          //                                                           Navigator.pushNamed(
          //                                                               context,
          //                                                               StockTransferTOGodownScreen
          //                                                                   .screenName,
          //                                                               arguments: {
          //                                                                 "itemName":
          //                                                                     items.itemName,
          //                                                                 "itemID":
          //                                                                     items.itemId,
          //                                                                 "filledStock":
          //                                                                     items.currentStkFilled,
          //                                                                 "emptyStock":
          //                                                                     items.currentStkEmpty,
          //                                                                 "defectiveStock":
          //                                                                     items.currentStkDefective,
          //                                                               });
          //                                                           // }else{
          //                                                           //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
          //                                                           // }
          //                                                         }
          //                                                       },
          //                                                       child: Text(
          //                                                         "Transfer",
          //                                                         style: saveFlag
          //                                                             ? Styling
          //                                                                 .blueClrTextWithUnderlineGrey
          //                                                             : Styling
          //                                                                 .blueClrTextWithUnderline,
          //                                                         textAlign:
          //                                                             TextAlign
          //                                                                 .center,
          //                                                       ),
          //                                                     ),
          //                                                   ),
          //                                                 ],
          //                                               ),
          //                                             ],
          //                                           ),
          //                                         ),
          //                                       );
          //                                     },
          //                                   )
          //                                 : Container(
          //                                     child: Text("No Data Available"),
          //                                   ),
          //                           ],
          //                         ),
          //                       ),
          //                       // )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //               // ),
          //               SizedBox(height: 10),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFEFF2FB),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(50), // Adjust the radius as needed
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Refresh"),
                content: Text("Do You Want To Refresh Data?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Close the dialog without action
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        // Refresh the data by reassigning the future
                        // stockDataFuture = updateRefillSale!.getDataFromDatabase();
                        _onRefresh();
                      });
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Future<void> insertDelBoyStockList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
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

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Parse the JSON response into a list of StockSubmitToManagerListModel
          List<StockSubmitToManagerListModel> result =
          List<StockSubmitToManagerListModel>.from(data
              .map((item) => StockSubmitToManagerListModel.fromJson(item)));
          // You can also update the state here if you need to trigger UI changes
          setState(() {
            updateRefillSale?.insertDataToDatabase(result, "Pending", "Edit");
            //Update the UI with the result data if necessary
          });
        } else {
          refreshTokens();
          debugPrint("Failed to fetch data from API: ${response.statusCode}");
        }
      } catch (e) {
        if (mounted) {
          refreshTokens();
          debugPrint("Error during API call: $e");
        }
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> _fetchImbalanceData() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);
      int godownIdId = int.parse(godownId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ImbalanceAsOfDateStkForGK}/$dId/$godownIdId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print(
            "Total ImbQty ImbalanceAsOfDateStkForGK response ${response.body}");
        print(
            "Total ImbQty ImbalanceAsOfDateStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptList = data
                .map((json) => PhysicalStockImbalanceDataModel.fromJson(json))
                .toList();
            isLoading = false;
            EasyLoading.dismiss();
            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            refreshTokens();
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Constants.listGettingFail)),
        );
      }
    } else {
      refreshTokens();
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> _fetchTodaysOpeningStockData() async {
    EasyLoading.instance
      ..maskType =
          EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);
      int godownIdId = int.parse(godownId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$godownIdId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
        print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
        // if (response.statusCode == 200) {
        //   final List<dynamic> data = json.decode(response.body);
        //
        //   String _normalize(String? value) {
        //     return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ??
        //         '';
        //   }
        //
        //   final defaultItem = todaysOpeningStock.firstWhere(
        //     (item) => _normalize(item.itemName) == '14.2kg',
        //     orElse: () => TodaysOpeningStockDataModel(),
        //   );
        //
        //   if (defaultItem.itemId != null) {
        //     selectedItemIdTodayStock = defaultItem.itemId!.toInt();
        //     // Set opening stock values
        //
        //     todayOpeningFilledDiffShow =
        //         defaultItem.filledOpeningStk?.toInt() ?? 0;
        //     todayOpeningEmptyDiffShow =
        //         defaultItem.emptyOpeningStk?.toInt() ?? 0;
        //     todayOpeningDefectiveDiffShow = defaultItem.defOpeningStk!.toInt();
        //   }
        //
        //   setState(() {
        //     todaysOpeningStock = data
        //         .map((json) => TodaysOpeningStockDataModel.fromJson(json))
        //         .toList();
        //     isLoading = false;
        //     EasyLoading.dismiss();
        //     // Optionally, you can store this in a variable or use it in the UI
        //   });
        // }
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          final items = data
              .map((json) => TodaysOpeningStockDataModel.fromJson(json))
              .toList();

          setState(() {
            todaysOpeningStock = items;
            isLoading = false;
            EasyLoading.dismiss();
          });

          // 🔥 IMPORTANT: filter after data is ready
          if (selectedItemId != null) {
            _filterBothLists();
          }
        }
        else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
            refreshTokens();
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchCurrentStock() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
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
            'Authorization': 'Bearer $token', // Add the Bearer token here
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

          final items = data
              .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
              .toList();

          items.sort((a, b) => a.itemId!.compareTo(b.itemId!));

          setState(() {
            getCurrentStcOfGodownKeeper = items;
            isLoading = false;
            EasyLoading.dismiss();
          });

          // 🔥 IMPORTANT: filter after data is ready
          if (selectedItemId != null) {
            _filterBothLists();
          }
        }
        // if (response.statusCode == 200) {
        //   final List<dynamic> data = json.decode(response.body);
        //
        //   String _normalize(String? value) {
        //     return value?.toLowerCase().replaceAll(RegExp(r'\s+'), '').trim() ??
        //         '';
        //   }
        //
        //   final defaultItem = getCurrentStcOfGodownKeeper.firstWhere(
        //         (item) => _normalize(item.itemName) == '14.2kg',
        //     orElse: () => GetCurrentStcOfGodownKeeperModel(),
        //   );
        //
        //   if (defaultItem.itemId != null) {
        //     selectedItemIdTodayStockCurrentStock = defaultItem.itemId!.toInt();
        //     // Set opening stock values
        //
        //     todayOpeningFilledDiffShowCurrentStock = defaultItem.currentStkFilled?.toInt() ?? 0;
        //     todayOpeningEmptyDiffShowCurrentStock = defaultItem.currentStkEmpty?.toInt() ?? 0;
        //     todayOpeningDefectiveDiffShowCurrentStock = defaultItem.currentStkDefective!.toInt();
        //   }
        //
        //   // Map to model first
        //   final List<GetCurrentStcOfGodownKeeperModel> items = data
        //       .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
        //       .toList();
        //
        //   // Sort by itemId (ascending)
        //   items.sort((a, b) => a.itemId!.compareTo(b.itemId!));
        //   setState(() {
        //     getCurrentStcOfGodownKeeper = data
        //         .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
        //         .toList();
        //     isLoading = false;
        //     EasyLoading.dismiss();
        //   });
        // }
        else {
          // Handle non-200 responses

          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
            refreshTokens();
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );

        debugPrint("GetStockTransferDtls" +
            '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data
                .map((json) => GetStockTransferListModel.fromJson(json))
                .toList();
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
              // showFlushBar(
              //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
            } else {
              stockTransferFlag = true; // Enable the button
            }
          });
          isLoading = false;
        } else {
          setState(() {
            refreshTokens();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
      } catch (e) {
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {
      refreshTokens();
      isLoading = false;
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      String roles = preferences.getString("RoleName").toString();
      distributorName = preferences.getString("IsAlreadyLogin").toString();
      String isAlreadyLogin =
      preferences.getString("IsAlreadyLogin").toString();
      debugPrint("User Name:- $userName");
      if (isAlreadyLogin == "0" ||
          isAlreadyLogin == null ||
          isAlreadyLogin == "null" ||
          isAlreadyLogin.isEmpty) {
        _showLogoutDialog(context);
      } else {}
    } catch (error) {
      rethrow;
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
            insertDelBoyStockList();
            _fetchImbalanceData();
            _fetchTodaysOpeningStockData();
            fetchCurrentStock();
            checkAndSaveDayEndData();
            fetchTransactionList();
            fetchAllSQCCount();
          } else if (response['message'] == "Token Expired") {
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
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
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
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[
          0]; // Access the first item in the list (assuming it's an object)

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
        refreshTokens();
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      refreshTokens();
      // Exception handling
      print("Exception: $e");
    }
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text(" Please log in to the application again."),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for confirming logout
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call logout function here
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  void _showItemPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 Important
            children: [

              /// Small drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// Title
              const Text(
                "Select Item For Stock Transfer",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              /// Item List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: getCurrentStcOfGodownKeeper.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {

                  final items = getCurrentStcOfGodownKeeper[index];

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      items.itemName.toString(),
                      style: Styling.itemTitle,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(
                        context,
                        StockTransferTOGodownScreen.screenName,
                        arguments: {
                          "itemName": items.itemName,
                          "itemID": items.itemId,
                          "filledStock": items.currentStkFilled,
                          "emptyStock": items.currentStkEmpty,
                          "defectiveStock": items.currentStkDefective,
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchItems() async {

    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');

      }
      try{

        final response = await http.get(
          Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint("GetItemMasterList" +
            '${AppUrl.GetItemMasterList}/$distributorId/1/C');
        debugPrint("GetItemMasterList" + response.body);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);

          List<CylItemListModel> loadedItems = data
              .map((json) => CylItemListModel.fromJson(json))
              .where((item) =>
          !item.itemName!.toLowerCase().contains('regulator'))
              .toList();

          setState(() {
            _items = loadedItems;

            // 🔹 Normalize function (important because API has "14.2 KG")
            String normalize(String? value) {
              return value
                  ?.toLowerCase()
                  .replaceAll(RegExp(r'\s+'), '')
                  .trim() ??
                  '';
            }

            final defaultItem = _items.firstWhere(
                  (item) => normalize(item.itemName) == '14.2kg',
              orElse: () => _items.isNotEmpty ? _items.first : CylItemListModel(),
            );

            selectedItemId = defaultItem.itemId;
          });

          // 🔹 After setting default, filter both lists
          _filterBothLists();
        }
        else {

          refreshTokens();
          throw Exception('Failed To Load Items');
        }
      }catch(e){
        debugPrint("GetItemMasterList" + e.toString());
      }
    } else {

      showFlushBar(
          context,Constants.connectionMessage);
    }


  }
  void _filterBothLists() {
    if (selectedItemId == null) return;

    /// FILTER OPENING STOCK
    final openingItem = todaysOpeningStock.firstWhere(
          (item) => item.itemId == selectedItemId,
      orElse: () => TodaysOpeningStockDataModel(),
    );

    todayOpeningFilledDiffShow =
        openingItem.filledOpeningStk?.toInt() ?? 0;
    todayOpeningEmptyDiffShow =
        openingItem.emptyOpeningStk?.toInt() ?? 0;
    todayOpeningDefectiveDiffShow =
        openingItem.defOpeningStk?.toInt() ?? 0;

    /// FILTER CURRENT STOCK
    final currentItem = getCurrentStcOfGodownKeeper.firstWhere(
          (item) => item.itemId == selectedItemId,
      orElse: () => GetCurrentStcOfGodownKeeperModel(),
    );

    todayOpeningFilledDiffShowCurrentStock =
        currentItem.currentStkFilled?.toInt() ?? 0;
    todayOpeningEmptyDiffShowCurrentStock =
        currentItem.currentStkEmpty?.toInt() ?? 0;
    todayOpeningDefectiveDiffShowCurrentStock =
        currentItem.currentStkDefective?.toInt() ?? 0;
  }

  Future<void> loadAllData() async {
    await fetchItems();
    await _fetchTodaysOpeningStockData();
    await fetchCurrentStock();

    _filterBothLists(); // call once after everything loads
  }

  Future<void> fetchAllSQCCount() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token


      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetSQCCardCntList}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );

        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetSQCCardCntList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print(
            "API Response Status GetSQCCardCntList: ${response.statusCode}");
        print("API Response GetSQCCardCntList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getSqcCardCntList = data.map((json) {
              return GetSqcCardCntListModel.fromJson(json);
            }).toList();

            if (getSqcCardCntList.isNotEmpty) {
              print(
                  'Total Amount of the first item: ${getSqcCardCntList[0]
                      .vehicleNo}');
              TodayTruckIn =
                  getSqcCardCntList[0].todayTruckIn!.toInt();
              TodaySQCDone =
                  getSqcCardCntList[0].todaySQCDone?.toInt();
              TodayNotDone =
                  getSqcCardCntList[0].todayNotDone?.toInt();
              TodayBodyLeak =
                  getSqcCardCntList[0].todayBodyLeak?.toInt();
              TodayLessQtyCyls =
                  getSqcCardCntList[0].todayLessQtyCyls?.toInt();
              MonthTruckIn =
                  getSqcCardCntList[0].monthTruckIn?.toInt();
              MonthSQCDone =
                  getSqcCardCntList[0].monthSQCDone?.toInt();
              MonthNotDone =
                  getSqcCardCntList[0].monthNotDone?.toInt();
              MonthBodyLeak =
                  getSqcCardCntList[0].monthBodyLeak?.toInt();
              MonthLessQtyCyls =
                  getSqcCardCntList[0].monthLessQtyCyls?.toInt();
              VehicleNo =
                  getSqcCardCntList[0].vehicleNo?.toString();
              SQCStatus =
                  getSqcCardCntList[0].sQCStatus?.toString();
            }
            filterSQCList();
            isLoading = false;
            EasyLoading.dismiss();
          });
        } else {
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
        }
      } catch (e) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            refreshTokens();
            EasyLoading.dismiss();
            isLoading = false;
          });
        }
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  void filterSQCList() {
    setState(() {
      String? status;

      // Map dropdown to actual API values
      switch (selectedSQCStatus) {
        case "SQC Completed":
          status = "yes"; // or whatever your API returns for done
          break;
        case "SQC Pending":
          status = "no"; // or whatever your API returns for not done
          break;
        default:
          status = "all";
      }

      filteredSqcList = status == "all"
          ? List.from(getSqcCardCntList)
          : getSqcCardCntList
          .where((item) => (item.sQCStatus ?? "").toLowerCase() == status)
          .toList();

      if (filteredSqcList.isNotEmpty) {
        VehicleNo = filteredSqcList[0].vehicleNo ?? "";
        SQCStatus = filteredSqcList[0].sQCStatus ?? "";
      } else {
        VehicleNo = "";
        SQCStatus = "";
      }
    });
  }

}
