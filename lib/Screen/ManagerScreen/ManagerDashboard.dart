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

import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../ConstantScreen/widgets.dart';
import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
import '../DashboardModel/TodaysOpeningStockDataModel.dart';
import '../GodownKeeper/DelBoyStockReturn/StockTransferToGodownScreen.dart';
import '../GodownKeeper/DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeDrawer.dart';
import '../Utils/CustomeDrawerManager.dart';
import '../Utils/Styling.dart';
import '../Utils/UpdateService.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';

import 'package:http/http.dart' as http;

import 'ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'ManagerModelClass/GetManagerDashboarDetailModel.dart';
import 'ManagerSingleItemUI/CDCMSStockItemUI.dart';
import 'ManagerSingleItemUI/EmptyInwardStockItemUI.dart';
import 'ManagerSingleItemUI/FilledInwardStockItemUI.dart';
import 'ManagerSingleItemUI/ImbalanceStockItemUI.dart';


class ManagerDashboardScreen extends StatefulWidget {
  static const screenName = '/managerDashboardScreen';

  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPhysicalStockListViewVisible = false;
  bool isDomesticListViewVisible = false;
  bool isNonDomesticListViewVisible = false;
  bool isTodayOpeningStockListViewVisible = false;
  bool isCurrentStockListViewVisible = false;
  List<GetManagerDashboarDetailModel> getManagerDashboarDetail = [];
  List<GetCurrentStockDetailManagerModel> getCurrentStockDetailManager = [];
  bool isLoading = true;
  String? mobileNo;
  int? deliveryMenCount;
  double? totalAmount,totalIncome,totalExpense,onAccountToday,onAccountAsOfDate;
  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    }else{
      debugPrint("Firebase not initialize");
    }
    fetchCurrentStock();
    fetchDashboarDetail();
    // Check if any item has a non-null, non-zero defectivCnt
    // bool hasDefectiveItems = getCurrentStockDetailManager.any((item) =>
    // item.defectivCnt != null && item.defectivCnt != 0);
  }
  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    fetchCurrentStock();
    fetchDashboarDetail();// Fetch the data again
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        key: _scaffoldKey,
        drawer: CustomeDrawerManager(), // Assign the scaffold key
        appBar:

        // PreferredSize(
        //   preferredSize: Size.fromHeight(120), // Custom height for the AppBar
        //   child:
        //   Container(
        //     color: Colors.blueAccent,
        //     // Custom background color
        //     padding: EdgeInsets.only(top: 40, left: 5, right: 16),
        //     // Padding for top & sides
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         IconButton(
        //           icon: Icon(Icons.menu, color: Colors.white),
        //           // Menu icon for Drawer
        //           onPressed: () {
        //             // Toggle the drawer open or closed
        //             if (_scaffoldKey.currentState!.isDrawerOpen) {
        //               _scaffoldKey.currentState!.closeDrawer();
        //             } else {
        //               _scaffoldKey.currentState!.openDrawer();
        //             }
        //           },
        //         ),
        //         SizedBox(width: 20),
        //         Text(
        //           'Dashboard', // Godown Name
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        PreferredSize(
          preferredSize: Size.fromHeight(120), // Custom height for the AppBar
          child: Container(
            color: Colors.blueAccent, // Custom background color
            padding: EdgeInsets.only(top: 40, left: 5, right: 16), // Padding for top & sides
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  // Menu icon for Drawer
                  onPressed: () {
                    // Toggle the drawer open or closed
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.closeDrawer();
                    } else {
                      _scaffoldKey.currentState!.openDrawer();
                    }
                  },
                ),
                SizedBox(width: 20),
                // Replacing the Text widget with the Row for Logo and App Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // App Logo
                    Image.asset(
                      'assets/playstore.png', // Path to your logo image
                      height: 40, // Adjust the height as needed
                    ),
                    SizedBox(width: 8), // Add some space between the logo and the app name
                    // App Name (Replace 'App Name' with your constant or dynamic value)
                    Text(
                      Constants.AppBarTitle, // Your app name constant or dynamic value
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
        body:
        RefreshIndicator(
          onRefresh: _onRefresh,
          child:
          Column(
            children: [
              Expanded
                (
                child: SingleChildScrollView(
                  // Ensures the content is scrollable
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Need Attention",style:Styling.bodyTitleWithBlueHight,),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Imbalance Stock",style:Styling.bodyTitleBig,),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          getManagerDashboarDetail.isNotEmpty
                                              ? Column(
                                            children: [
                                              getManagerDashboarDetail.any(
                                                      (sale) => sale.todayImbQty != 0 || sale.asOfDateImbQty != 0)
                                                  ? Wrap(
                                                spacing: 7, // Space between items
                                                runSpacing: 2, // Space between rows
                                                children: List.generate(getManagerDashboarDetail.length, (index) {
                                                  var sale = getManagerDashboarDetail[index];

                                                  if (sale.todayImbQty == 0 && sale.asOfDateImbQty == 0) {
                                                    return SizedBox(); // Hide item if both counts are zero
                                                  }

                                                  return Container(
                                                    width: 110, // Set the width for each item
                                                    child: ImbalanceStockItemUI(sale),
                                                  );
                                                }),
                                              )
                                                  : Center(child: Text("No data available")), // Show a message when no items meet the condition
                                            ],
                                          )
                                              : Container(
                                            child: Text("No Data Available"),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("CDCMS Stock Difference",style:Styling.bodyTitleBig,),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      getManagerDashboarDetail.isNotEmpty
                                          ? Column(
                                        children: [
                                          getManagerDashboarDetail.any((sale) => sale.filledDiff != 0 || sale.emptyDiff != 0 || sale.defectiveDiff != 0)
                                              ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: List.generate(getManagerDashboarDetail.length, (index) {
                                                var sale = getManagerDashboarDetail[index];
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 10.0),
                                                  child: CDCMSStockItemUI(sale),
                                                );
                                              }),
                                            ),
                                          )
                                              : Center(child: Text("No data available")), // Show a message when no items meet the condition
                                        ],
                                      )

                                          : Container(
                                        child: Text("No Data Available"),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Unsettled Sale",style:Styling.bodyTitleBig,),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      getManagerDashboarDetail.isNotEmpty
                                          ? Column(
                                        children: [
                                    Container(
                                    height: 100,
                                    child:
                                    Card(
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                                              children: [
                                                // Expanded widget on the left side for the first text
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerRight, // Align the first text to the right
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10.0),
                                                      child: Text(
                                                        deliveryMenCount.toString(), // Replace this with your dynamic data
                                                        style: Styling.countNumber,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Vertical divider centered in the row
                                                verticalDividerSmallest(),
                                                // Expanded widget on the right side for the second text
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft, // Align the second text to the left
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: Text(
                                                        formatCurrency(totalAmount!), // Replace this with your dynamic data
                                                        style: Styling.countNumber,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Pending",
                                                  style: Styling.textFormText,
                                                  textAlign: TextAlign.center,)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                               // Show a message when no items meet the condition
                                        ],
                                      )

                                          : Container(
                                        child: Text("No Data Available"),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Today's Cash Summary",style:Styling.bodyTitleBig,),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      getManagerDashboarDetail.isNotEmpty
                                          ? Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child:
                                            Card(
                                              margin: EdgeInsets.symmetric(vertical: 7),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                formatCurrency(totalIncome!),
                                                                // Replace this with your dynamic data
                                                                style: Styling.countNumber,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              SizedBox(height: 4), // Space between count and label
                                                              Text(
                                                                'Income', // Label for filledDiff
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),

                                                          Column(
                                                            children: [
                                                              Text(
                                                                formatCurrency(totalExpense!), // Replace this with your dynamic data
                                                                style: Styling.countNumber,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              SizedBox(height: 4), // Space between count and label
                                                              Text(
                                                                'Expense', // Label for emptyDiff
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),

                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 8.0),
                                                                    child: Text(
                                                                        formatCurrency(onAccountToday!),
                                                                       // Replace this with your dynamic data
                                                                      style: Styling.countNumber,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  verticalDividerSmallest(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 8.0),
                                                                    child: Text(
                                                                      formatCurrency(onAccountAsOfDate!),
                                                                      // Replace this with your dynamic data
                                                                      style: Styling.countNumber,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 4), // Space between count and label
                                                              Text(
                                                                'On Account', // Label for defectiveDiff
                                                                style: Styling.textFormText,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                    ],
                                                  )

                                              ),
                                            ),
                                          ),
                                          // Show a message when no items meet the condition
                                        ],
                                      )

                                          : Container(
                                        child: Text("No Data Available"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Inward",style:Styling.bodyTitleWithBlueHight,),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Current Inward Stock",style:Styling.bodyTitleBig,),
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: getCurrentStockDetailManager.any((item) => item.totalInvoiceCnt! > 0 || item.filledEMRCnt! > 0), // Condition to check visibility
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Filled",
                                                style: Styling.textFormText,
                                              ),

                                            ],
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Invoice',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'EMR',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              getCurrentStockDetailManager.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                // itemCount: getCurrentStockDetailManager.length,
                                                itemCount: getCurrentStockDetailManager
                                                    .where((item) => item.totalInvoiceCnt! > 0 || item.filledEMRCnt! > 0) // Filter items with defectivCnt > 0
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final items = getCurrentStockDetailManager[index];

                                                  return
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.itemName.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.totalInvoiceCnt.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),

                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.filledEMRCnt.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );


                                                },
                                              ):
                                              Container(
                                                child: Text("No Data Available"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 15,),
                                  Visibility(
                                    visible: getCurrentStockDetailManager.any((item) => item.emptyTVCnt! > 0 ), // Condition to check visibility
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Empty (TV)",
                                                    style: Styling.textFormText,
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child:
                                              Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              '',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              'TV',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  getCurrentStockDetailManager.isNotEmpty?
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    // itemCount: getCurrentStockDetailManager.length,
                                                    itemCount: getCurrentStockDetailManager
                                                        .where((item) => item.emptyTVCnt! > 0 ) // Filter items with defectivCnt > 0
                                                        .length,
                                                    itemBuilder: (context, index) {
                                                      final items = getCurrentStockDetailManager[index];

                                                      return
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.itemName.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.emptyTVCnt.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );


                                                    },
                                                  ):
                                                  Container(
                                                    child: Text("No Data Available"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 15,),
                                  // Check if any item has a non-null, non-zero defectivCnt
                                  Visibility(
                                    visible: getCurrentStockDetailManager.any((item) => item.defectivCnt! > 0), // Condition to check visibility
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Defective",
                                                  style: Styling.textFormText,
                                                ),

                                              ],
                                            ),
                                          ),
                                          Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child:
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(12),
                                                      topRight: Radius.circular(12),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          flex:1,
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex:1,
                                                          child: Text(
                                                            'Defective',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex:1,
                                                          child: Text(
                                                            'Since',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                getCurrentStockDetailManager.isNotEmpty?
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  // itemCount: getCurrentStockDetailManager.length,
                                                  itemCount: getCurrentStockDetailManager
                                                      .where((item) => item.defectivCnt! > 0) // Filter items with defectivCnt > 0
                                                      .length,
                                                  itemBuilder: (context, index) {
                                                    final items = getCurrentStockDetailManager[index];

                                                    return

                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.itemName.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.defectivCnt.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),

                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      DateFormat('dd-MM-yyyy').format(DateTime.parse(items.defectivFromDate.toString() ?? '')),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );


                                                  },
                                                ):
                                                Container(
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
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Outward",style:Styling.bodyTitleWithBlueHight,),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Current Outward Stock",style:Styling.bodyTitleBig,),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: getCurrentStockDetailManager.any((item) => item.emptyCRDCnt! > 0 || item.emptyDefectivCnt! > 0), // Condition to check visibility
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Empty",
                                                style: Styling.textFormText,
                                              ),
                                    
                                            ],
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'CRD',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Defective',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              getCurrentStockDetailManager.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                // itemCount: getCurrentStockDetailManager.length,
                                                itemCount: getCurrentStockDetailManager
                                                    .where((item) => item.emptyCRDCnt! > 0 || item.emptyDefectivCnt! > 0) // Filter items with defectivCnt > 0
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final items = getCurrentStockDetailManager[index];
                                    
                                                  return
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.itemName.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.emptyCRDCnt.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                    
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.emptyDefectivCnt.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                    
                                    
                                                },
                                              ):
                                              Container(
                                                child: Text("No Data Available"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 15,),
                                  Visibility(
                                    visible: getCurrentStockDetailManager.any((item) => item.sVQty! > 0 || item.refillSaleCnt! > 0), // Condition to check visibility
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Refill Sale",
                                                    style: Styling.textFormText,
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child:
                                              Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              '',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              'SV',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex:1,
                                                            child: Text(
                                                              'Refill Sale',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  getCurrentStockDetailManager.isNotEmpty?
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    // itemCount: getCurrentStockDetailManager.length,
                                                    itemCount: getCurrentStockDetailManager
                                                        .where((item) => item.sVQty! > 0 || item.refillSaleCnt! > 0) // Filter items with defectivCnt > 0
                                                        .length,
                                                    itemBuilder: (context, index) {
                                                      final items = getCurrentStockDetailManager[index];
                                                      return
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.itemName.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.sVQty.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:1,
                                                                    child: Text(
                                                                      items.refillSaleCnt.toString(),
                                                                      style:Styling.textFormText,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );

                                                    },
                                                  ):
                                                  Container(
                                                    child: Text("No Data Available"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: 15,),
                                  Visibility(
                                      visible: getCurrentStockDetailManager.any((item) => item.imbalanceCnt! > 0), // Condition to check visibility
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Imbalance",
                                                style: Styling.textFormText,
                                              ),

                                            ],
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Imbalance',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              getCurrentStockDetailManager.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                // itemCount: getCurrentStockDetailManager.length,
                                                itemCount: getCurrentStockDetailManager
                                                    .where((item) => item.imbalanceCnt! > 0) // Filter items with defectivCnt > 0
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final items = getCurrentStockDetailManager[index];

                                                  return

                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.itemName.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.imbalanceCnt.toString(),
                                                                  style:Styling.textFormText,
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                },
                                              ):
                                              Container(
                                                child: Text("No Data Available"),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
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
                        Navigator.of(context).pop(); // Close the dialog without action
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

          child: Icon(Icons.refresh, color: Colors.white),
        ),
      );
  }

  Future<void> fetchDashboarDetail() async {
    EasyLoading.show();
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
          Uri.parse('${AppUrl.GetMobDashboardSummaryForMgr}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );

        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetMobDashboardSummaryForMgr: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status GetMobDashboardSummaryForMgr: ${response.statusCode}");
        print("API Response GetMobDashboardSummaryForMgr: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getManagerDashboarDetail = data.map((json) => GetManagerDashboarDetailModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();

            // Initialize totalImbQty
            num dMCounts = 0;
            double totalAmounts = 0;
            double totalIncomes = 0;
            double totalExpenses = 0;
            double onAccountTodays = 0;
            double onAccountAsOfDates = 0;

            // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            for (var receipt in getManagerDashboarDetail) {
              // Add imbQty to totalImbQty, treating null as 0
              dMCounts += receipt.dMCount ?? 0;
              totalAmounts += receipt.totalAmount ?? 0;// Corrected summing of imbQty
              totalIncomes += receipt.totalIncome ?? 0;// Corrected summing of imbQty
              totalExpenses += receipt.totalExp ?? 0;// Corrected summing of imbQty
              onAccountTodays += receipt.staffOnAccToday ?? 0;// Corrected summing of imbQty
              onAccountAsOfDates += receipt.staffOnAccAsOf ?? 0;// Corrected summing of imbQty
            }
            // deliveryMenCount = dMCounts.toInt();
            // totalAmount = totalAmounts.toDouble();
            // totalIncome = totalIncomes.toDouble();
            // totalExpense = totalExpenses.toDouble();
            // onAccountToday = onAccountTodays.toDouble();
            // onAccountAsOfDate = onAccountAsOfDates.toDouble();

            // Print the totalAmount of the first item (if exists)
            if (getManagerDashboarDetail.isNotEmpty) {
              print('Total Amount of the first item: ${getManagerDashboarDetail[0].totalAmount}');
              deliveryMenCount =  getManagerDashboarDetail[0].dMCount?.toInt();
              totalAmount = getManagerDashboarDetail[0].totalAmount?.toDouble();
              totalIncome = getManagerDashboarDetail[0].totalIncome?.toDouble();
              totalExpense = getManagerDashboarDetail[0].totalExp?.toDouble();
              onAccountToday = getManagerDashboarDetail[0].staffOnAccToday?.toDouble();
              onAccountAsOfDate = getManagerDashboarDetail[0].staffOnAccAsOf?.toDouble();
            }
          });
        } else {
          // Handle non-200 responses
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
          refreshTokens();
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          refreshTokens();
          EasyLoading.dismiss();
          isLoading = false;
        });
        refreshTokens();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    }else{
      EasyLoading.dismiss();
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  Future<void> fetchCurrentStock() async {
    EasyLoading.show();
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
          Uri.parse('${AppUrl.InventoryCurrentStockDtlsForMobDash}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL InventoryCurrentStockDtlsForMobDash: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status InventoryCurrentStockDtlsForMobDash: ${response.statusCode}");
        print("API Response InventoryCurrentStockDtlsForMobDash: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStockDetailManager = data.map((json) => GetCurrentStockDetailManagerModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();

          });
        } else {
          // Handle non-200 responses
          setState(() {
            refreshTokens();
            isLoading = false;
            EasyLoading.dismiss();
          });
          refreshTokens();
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {

        setState(() {
          refreshTokens();
          EasyLoading.dismiss();
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        refreshTokens();
        showFlushBar(context, Constants.listGettingFail);
      }
    }else{
      EasyLoading.dismiss();
      showFlushBar(context,
          Constants.connectionMessage);
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
            fetchCurrentStock();
            fetchDashboarDetail();
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

  // String formatCurrency(double amount) {
  //   final format = NumberFormat.currency(
  //     locale: 'en_IN', // Indian locale
  //     symbol: '₹', // Specify the Rupee symbol
  //     decimalDigits: 2, // Optional: specify the number of decimal places (if needed)
  //   );
  //   return format.format(amount);
  // }
  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale without symbol

    return format.format(amount);
  }
}
