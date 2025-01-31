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
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeDrawer.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';
import 'DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'package:http/http.dart' as http;

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
  List<PhysicalStockImbalanceDataModel> receiptList = [];
  List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
  bool isLoading = true;
  String? mobileNo;
  @override
  void initState() {
    super.initState();
    updateRefillSale = UpdateRefillSale();
    // Call the insert method when the screen is loaded
    insertDelBoyStockList();
    _fetchImbalanceData();
    _fetchTodaysOpeningStockData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomeDrawer(), // Assign the scaffold key
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Custom height for the AppBar
        child: Container(
          color: Colors.blueAccent,
          // Custom background color
          padding: EdgeInsets.only(top: 40, left: 5, right: 16),
          // Padding for top & sides
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Text(
                'Dashboard', // Godown Name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // Ensures the content is scrollable
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, bottom: 5.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title for Cylinder Categories Table
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPhysicalStockListViewVisible =
                                  !isPhysicalStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child:
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        bodyTitleBlue("Physical Stock Imbalance As Of Today"),

                                        // Text(
                                        //   'Physical Stock Imbalance As Of Today',
                                        //   // style: TextStyle(
                                        //   //   fontSize: 14,
                                        //   //   color: Colors.black,
                                        //   //   fontWeight: FontWeight.bold,
                                        //   // ),
                                        //   style: Styling.bodyTitle,
                                        // ),
                                        Icon(
                                          isPhysicalStockListViewVisible
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          size: 30, // Bigger icon for a more clickable feel
                                          color: Color(0xff1280b3),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Visibility(
                                  //   visible: isPhysicalStockListViewVisible,
                                  //   child:
                                  //   Container(
                                  //     decoration: BoxDecoration(
                                  //       // Background color of the box
                                  //       borderRadius: BorderRadius.circular(8),
                                  //       border: Border.all(
                                  //           width:
                                  //               0.5), // Optional: Add rounded corners
                                  //     ),
                                  //     child: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         // Header Row
                                  //         Container(
                                  //           decoration: BoxDecoration(
                                  //             // Background color of the box
                                  //             borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8)),
                                  //             color: Colors.blue.shade100,
                                  //             // Optional: Add rounded corners
                                  //           ),
                                  //           child: Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.center,
                                  //             children: [
                                  //               Expanded(
                                  //                   child: Text('Cylinder',
                                  //                       style: TextStyle(
                                  //                           fontWeight: FontWeight
                                  //                               .bold,),textAlign: TextAlign.center,)),
                                  //               verticalDividerSmall(),
                                  //               Expanded(
                                  //                   child: Text('Imbalance Qty',
                                  //                       style: TextStyle(
                                  //                           fontWeight: FontWeight
                                  //                               .bold),textAlign: TextAlign.center)),
                                  //
                                  //             ],
                                  //           ),
                                  //         ),
                                  //
                                  //         Container(
                                  //           color: Colors.black12,
                                  //           height: 1,
                                  //           width: MediaQuery.of(context)
                                  //               .size
                                  //               .width,
                                  //         ),
                                  //         // Adds a divider below the header for separation
                                  //         // List of Entries
                                  //         ListView.builder(
                                  //           shrinkWrap: true,
                                  //           // To make the ListView occupy only the space it needs
                                  //           physics:
                                  //               NeverScrollableScrollPhysics(),
                                  //           // Prevents scrolling inside the ListView
                                  //           itemCount:
                                  //               cylinderData.entries.length,
                                  //           itemBuilder: (context, index) {
                                  //             var entry = cylinderData.entries
                                  //                 .elementAt(index);
                                  //             String category = entry.key;
                                  //             int emptyCount =
                                  //                 entry.value['Empty'] ?? 0;
                                  //             int filledCount = entry.value['Filled'] ?? 0;
                                  //             int defectiveCount = entry.value['Defective'] ?? 0;
                                  //
                                  //             return Column(
                                  //               children: [
                                  //                 Row(
                                  //                   mainAxisAlignment: MainAxisAlignment.center,
                                  //                   children: [
                                  //                     Expanded(
                                  //                       child:Text(
                                  //                           category,
                                  //                           textAlign: TextAlign.center,
                                  //                         ),
                                  //
                                  //                     ),
                                  //                     verticalDividerVerySmall(),
                                  //                     Expanded(
                                  //                       child: GestureDetector(
                                  //                         onTap: () {
                                  //                           // Handle the tap on the 'emptyCount' text
                                  //                           setState(() {
                                  //                             // Perform any action when clicked (e.g., toggle underline state)
                                  //                           });
                                  //                         },
                                  //                         child: Text(
                                  //                           '$emptyCount',
                                  //                           textAlign: TextAlign.center,
                                  //                           style: TextStyle(
                                  //                             decoration: TextDecoration.underline, // Add blue underline
                                  //                             decorationColor: Colors.blue, // Set the underline color
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //
                                  //                 Container(
                                  //                   color: Colors.black12,
                                  //                   height: 1,
                                  //                   width:
                                  //                       MediaQuery.of(context)
                                  //                           .size
                                  //                           .width,
                                  //                 ),
                                  //               ],
                                  //             );
                                  //           },
                                  //         ),
                                  //
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Visibility(
                                    visible: isPhysicalStockListViewVisible,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // Header Row for Cylinder Categories
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Cylinder',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                VerticalDivider(thickness: 1, color: Colors.grey),
                                                Expanded(
                                                  child: Text(
                                                    'Imbalance Qty',
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

                                          // List of Cylinder Categories
                                          receiptList.isNotEmpty?
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: receiptList.length,
                                            itemBuilder: (context, index) {
                                              final item = receiptList[index];
                                              return Card(
                                                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // Cylinder Category Text
                                                      Expanded(
                                                        child: Text(
                                                      item.itemName ?? "Unknown",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      // Divider between Texts
                                                      VerticalDivider(thickness: 1, color: Colors.grey),
                                                      // Imbalance Quantity with Tap Gesture
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // Handle the tap on the 'emptyCount' text
                                                            setState(() {
                                                              // Perform any action when clicked
                                                            });
                                                          },
                                                          child: Text(
                                                            '${item.imbalanceStk ?? 0}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              decoration: TextDecoration.underline,
                                                              decorationColor: Color(0xff1280b3),
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff1280b3),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ):
                                              Container(
                                                child: Text("No Data Available"),
                                              )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title for Cylinder Categories Table
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isTodayOpeningStockListViewVisible =
                                  !isTodayOpeningStockListViewVisible; // Toggle ListView visibility
                            });
                          },
                          child:
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text(
                                        //   "View Today's Opening Stock",
                                        //   style: TextStyle(
                                        //       fontSize: 14,
                                        //       color: Colors.black,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        bodyTitleBlue("View Today's Opening Stock"),
                                        Icon(
                                          isTodayOpeningStockListViewVisible
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          size: 30, // Bigger icon for a more clickable feel
                                          color:Color(0xff1280b3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible:
                                          isTodayOpeningStockListViewVisible,
                                      child:Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade100,
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
                                                        'Filled',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 14
                                                          ,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child: Text(
                                                        'Empty',
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

                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: todaysOpeningStock.length,
                                              itemBuilder: (context, index) {
                                                final items = todaysOpeningStock[index];

                                                return
                                                  Card(
                                                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                    elevation: 4,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12)),
                                                    child: Padding(
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
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.filledOpeningStk.toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.emptyOpeningStk.toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex:1,
                                                                child: Text(
                                                                  items.defOpeningStk.toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.normal,
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                //                       Container(
                //                         decoration: BoxDecoration(
                //                           // Background color of the box
                //                           borderRadius: BorderRadius.circular(8),
                //                           border: Border.all(
                //                               width:
                //                               0.5), // Optional: Add rounded corners
                //                         ),
                //                         child: Column(
                //                           crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                           children: [
                //                             // Header Row
                //                             Container(
                //                               decoration: BoxDecoration(
                //                                 // Background color of the box
                //                                 borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8)),
                //                                 color: Colors.blue.shade100,
                //                                 // Optional: Add rounded corners
                //                               ),
                //
                //                               child:
                //                               Row(
                //                                 mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                                 children: [
                //                                   Expanded(
                //                                       child: Text('Cylinder',
                //                                         style: TextStyle(
                //                                           fontWeight: FontWeight
                //                                               .bold,),textAlign: TextAlign.center,)),
                //                                   verticalDividerSmall(),
                //                                   Expanded(
                //                                       child: Text('Filled',
                //                                           style: TextStyle(
                //                                               fontWeight: FontWeight
                //                                                   .bold),textAlign: TextAlign.center)),
                //                                   verticalDividerSmall(),
                //                                   Expanded(
                //                                       child: Text('Empty',
                //                                           style: TextStyle(
                //                                               fontWeight: FontWeight
                //                                                   .bold),textAlign: TextAlign.center)),
                //                                   verticalDividerSmall(),
                //                                   Expanded(
                //                                       child: Text('Def.',
                //                                           style: TextStyle(
                //                                               fontWeight: FontWeight
                //                                                   .bold),textAlign: TextAlign.center)),
                //                                 ],
                //                               ),
                //                             ),
                //
                //                             Container(
                //                               color: Colors.black12,
                //                               height: 1,
                //                               width: MediaQuery.of(context)
                //                                   .size
                //                                   .width,
                //                             ),
                //                             // Adds a divider below the header for separation
                //                             // List of Entries
                //                             // ListView.builder(
                //                             //   shrinkWrap: true,
                //                             //   // To make the ListView occupy only the space it needs
                //                             //   physics:
                //                             //   NeverScrollableScrollPhysics(),
                //                             //   // Prevents scrolling inside the ListView
                //                             //   itemCount:
                //                             //   cylinderData.entries.length,
                //                             //   itemBuilder: (context, index) {
                //                             //     var entry = cylinderData.entries
                //                             //         .elementAt(index);
                //                             //     String category = entry.key;
                //                             //     int emptyCount =
                //                             //         entry.value['Empty'] ?? 0;
                //                             //     int filledCount =
                //                             //         entry.value['Filled'] ?? 0;
                //                             //     int defectiveCount = entry.value['Defective'] ?? 0;
                //                             //     return Column(
                //                             //       children: [
                //                             //         Row(
                //                             //           mainAxisAlignment:
                //                             //           MainAxisAlignment
                //                             //               .center,
                //                             //           children: [
                //                             //             Expanded(
                //                             //                 child:
                //                             //                 Text(category,textAlign: TextAlign.center)),
                //                             //             verticalDividerVerySmall(),
                //                             //             Expanded(
                //                             //                 child: Text(
                //                             //                     '$emptyCount',textAlign: TextAlign.center)),
                //                             //             verticalDividerVerySmall(),
                //                             //             Expanded(
                //                             //                 child: Text(
                //                             //                     '$filledCount',textAlign: TextAlign.center)),
                //                             //             verticalDividerVerySmall(),
                //                             //             Expanded(
                //                             //                 child: Text('$defectiveCount',textAlign: TextAlign.center)),
                //                             //           ],
                //                             //         ),
                //                             //         Container(
                //                             //           color: Colors.black12,
                //                             //           height: 1,
                //                             //           width:
                //                             //           MediaQuery.of(context)
                //                             //               .size
                //                             //               .width,
                //                             //         ),
                //                             //       ],
                //                             //     );
                //                             //   },
                //                             // ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: cylinderData.entries.length,
                //   itemBuilder: (context, index) {
                //     var entry = cylinderData.entries.elementAt(index);
                //     String category = entry.key;
                //     int emptyCount = entry.value['Empty'] ?? 0;
                //     int filledCount = entry.value['Filled'] ?? 0;
                //     int defectiveCount = entry.value['Defective'] ?? 0;
                //
                //     // Calculate total count
                //     int total = emptyCount + filledCount + defectiveCount;
                //
                //     // Calculate percentage for each type
                //     double emptyPercentage = (emptyCount / total) * 100;
                //     double filledPercentage = (filledCount / total) * 100;
                //     double defectivePercentage = (defectiveCount / total) * 100;
                //
                //     return Card(
                //       elevation: 5,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               category,
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 16,
                //                 color: Colors.black,
                //               ),
                //             ),
                //             SizedBox(height: 10),
                //             Text('Empty: $emptyCount'),
                //             LinearProgressIndicator(
                //               value: emptyPercentage / 100,
                //               backgroundColor: Colors.grey.shade300,
                //               color: Colors.blue,
                //             ),
                //             SizedBox(height: 10),
                //             Text('Filled: $filledCount'),
                //             LinearProgressIndicator(
                //               value: filledPercentage / 100,
                //               backgroundColor: Colors.grey.shade300,
                //               color: Colors.green,
                //             ),
                //             SizedBox(height: 10),
                //             Text('Defective: $defectiveCount'),
                //             LinearProgressIndicator(
                //               value: defectivePercentage / 100,
                //               backgroundColor: Colors.grey.shade300,
                //               color: Colors.red,
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
                //
                // ],
                //                         ),
                //                       ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(bottom: 0.0, top: 0, left: 10),
                    //   child: Text(
                    //     "Total Current Stock Itemised",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16,
                    //         color: Colors.blueAccent),
                    //   ),
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     // Title for Cylinder Categories Table
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           isDomesticListViewVisible =
                    //               !isDomesticListViewVisible; // Toggle ListView visibility
                    //         });
                    //       },
                    //       child: Card(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Text(
                    //                       'Domestic',
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                     Icon(
                    //                       isDomesticListViewVisible
                    //                           ? Icons.arrow_drop_up
                    //                           : Icons.arrow_drop_down,
                    //                       size: 30, // Bigger icon for a more clickable feel
                    //                       color: Colors.blue.shade600,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Visibility(
                    //                 visible: isDomesticListViewVisible,
                    //                 child:
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     // Background color of the box
                    //                     borderRadius: BorderRadius.circular(8),
                    //                     border: Border.all(
                    //                         width:
                    //                         0.5), // Optional: Add rounded corners
                    //                   ),
                    //                   child: Column(
                    //                     crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                     children: [
                    //                       // Header Row
                    //                       Container(
                    //                         decoration: BoxDecoration(
                    //                           // Background color of the box
                    //                           borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8)),
                    //                           color: Colors.blue.shade100,
                    //                           // Optional: Add rounded corners
                    //                         ),
                    //
                    //                         child:
                    //                         Row(
                    //                           mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                           children: [
                    //                             Expanded(
                    //                                 child: Text('Cylinder',
                    //                                   style: TextStyle(
                    //                                     fontWeight: FontWeight
                    //                                         .bold,),textAlign: TextAlign.center,)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Filled',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Empty',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Def.',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                           ],
                    //                         ),
                    //                       ),
                    //
                    //                       Container(
                    //                         color: Colors.black12,
                    //                         height: 1,
                    //                         width: MediaQuery.of(context)
                    //                             .size
                    //                             .width,
                    //                       ),
                    //                       // Adds a divider below the header for separation
                    //                       // List of Entries
                    //                       ListView.builder(
                    //                         shrinkWrap: true,
                    //                         // To make the ListView occupy only the space it needs
                    //                         physics:
                    //                         NeverScrollableScrollPhysics(),
                    //                         // Prevents scrolling inside the ListView
                    //                         itemCount:
                    //                         cylinderData.entries.length,
                    //                         itemBuilder: (context, index) {
                    //                           var entry = cylinderData.entries
                    //                               .elementAt(index);
                    //                           String category = entry.key;
                    //                           int emptyCount =
                    //                               entry.value['Empty'] ?? 0;
                    //                           int filledCount =
                    //                               entry.value['Filled'] ?? 0;
                    //                           int defectiveCount = entry.value['Defective'] ?? 0;
                    //                           return Column(
                    //                             children: [
                    //                               Row(
                    //                                 mainAxisAlignment:
                    //                                 MainAxisAlignment
                    //                                     .center,
                    //                                 children: [
                    //                                   Expanded(
                    //                                       child:
                    //                                       Text(category,textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(
                    //                                       child: Text(
                    //                                           '$emptyCount',textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(
                    //                                       child: Text(
                    //                                           '$filledCount',textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(
                    //                                       child: Text('$defectiveCount',textAlign: TextAlign.center)),
                    //                                 ],
                    //                               ),
                    //                               Container(
                    //                                 color: Colors.black12,
                    //                                 height: 1,
                    //                                 width:
                    //                                 MediaQuery.of(context)
                    //                                     .size
                    //                                     .width,
                    //                               ),
                    //                             ],
                    //                           );
                    //                         },
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     // Title for Cylinder Categories Table
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           isNonDomesticListViewVisible =
                    //               !isNonDomesticListViewVisible; // Toggle ListView visibility
                    //         });
                    //       },
                    //       child: Card(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Text(
                    //                       'Non-Domestic',
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold),
                    //                     ),
                    //                     Icon(
                    //                       isNonDomesticListViewVisible
                    //                           ? Icons.arrow_drop_up
                    //                           : Icons.arrow_drop_down,
                    //                       size: 30, // Bigger icon for a more clickable feel
                    //                       color: Colors.blue.shade600,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Visibility(
                    //                 visible: isNonDomesticListViewVisible,
                    //                 child:
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     // Background color of the box
                    //                     borderRadius: BorderRadius.circular(8),
                    //                     border: Border.all(
                    //                         width:
                    //                         0.5), // Optional: Add rounded corners
                    //                   ),
                    //                   child: Column(
                    //                     crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                     children: [
                    //                       // Header Row
                    //                       Container(
                    //                         decoration: BoxDecoration(
                    //                           // Background color of the box
                    //                           borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8)),
                    //                           color: Colors.blue.shade100,
                    //                           // Optional: Add rounded corners
                    //                         ),
                    //
                    //                         child:
                    //                         Row(
                    //                           mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                           children: [
                    //                             Expanded(
                    //                                 child: Text('Cylinder',
                    //                                   style: TextStyle(
                    //                                     fontWeight: FontWeight
                    //                                         .bold,),textAlign: TextAlign.center,)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Filled',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Empty',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                             verticalDividerSmall(),
                    //                             Expanded(
                    //                                 child: Text('Def.',
                    //                                     style: TextStyle(
                    //                                         fontWeight: FontWeight
                    //                                             .bold),textAlign: TextAlign.center)),
                    //                           ],
                    //                         ),
                    //                       ),
                    //
                    //                       Container(
                    //                         color: Colors.black12,
                    //                         height: 1,
                    //                         width: MediaQuery.of(context)
                    //                             .size
                    //                             .width,
                    //                       ),
                    //                       // Adds a divider below the header for separation
                    //                       // List of Entries
                    //                       ListView.builder(
                    //                         shrinkWrap: true,
                    //                         // To make the ListView occupy only the space it needs
                    //                         physics:
                    //                         NeverScrollableScrollPhysics(),
                    //                         // Prevents scrolling inside the ListView
                    //                         itemCount:
                    //                         cylinderData.entries.length,
                    //                         itemBuilder: (context, index) {
                    //                           var entry = cylinderData.entries
                    //                               .elementAt(index);
                    //                           String category = entry.key;
                    //                           int emptyCount =
                    //                               entry.value['Empty'] ?? 0;
                    //                           int filledCount =
                    //                               entry.value['Filled'] ?? 0;
                    //                           int defectiveCount = entry.value['Defective'] ?? 0;
                    //                           return Column(
                    //                             children: [
                    //                               Row(
                    //                                 mainAxisAlignment:
                    //                                 MainAxisAlignment
                    //                                     .center,
                    //                                 children: [
                    //                                   Expanded(
                    //                                       child:
                    //                                       Text(category,textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(
                    //                                       child: Text(
                    //                                           '$emptyCount',textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(
                    //                                       child: Text(
                    //                                           '$filledCount',textAlign: TextAlign.center)),
                    //                                   verticalDividerVerySmall(),
                    //                                   Expanded(child: Text('$defectiveCount',textAlign: TextAlign.center)),
                    //                                 ],
                    //                               ),
                    //                               Container(
                    //                                 color: Colors.black12,
                    //                                 height: 1,
                    //                                 width:
                    //                                 MediaQuery.of(context)
                    //                                     .size
                    //                                     .width,
                    //                               ),
                    //                             ],
                    //                           );
                    //                         },
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/stockReturnFromDelBoy');
                    },
                    icon: Icon(Icons.update, size: 20), // Add icon
                    label: Text("Update Sale"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/stockSubmitToManager');
                    },
                    icon: Icon(Icons.list_alt, size: 20), // Add icon
                    label: Text("Today's Summary"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> insertDelBoyStockList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
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
        refreshTokens();
        debugPrint("Error during API call: $e");
      }
    }else{
      showFlushBar(context,Constants.connectionTitle,
          Constants.connectionMessage);
    }

  }

  Future<void> _fetchImbalanceData() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
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
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );
        print("Total ImbQty ImbalanceAsOfDateStkForGK response ${response.body}");
        print("Total ImbQty ImbalanceAsOfDateStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptList = data.map((json) => PhysicalStockImbalanceDataModel.fromJson(json)).toList();
            isLoading = false;

            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      showFlushBar(context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }

  Future<void> _fetchTodaysOpeningStockData() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
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
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );
        print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
        print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            todaysOpeningStock = data.map((json) => TodaysOpeningStockDataModel.fromJson(json)).toList();
            isLoading = false;

            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      showFlushBar(context, Constants.connectionTitle, Constants.connectionMessage);
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
}
