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
import '../DashboardScreen.dart';
import '../DelBoyStockReturn/StockReturnFromDelBoy.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/ItemData.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';


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
  @override
  void initState() {
    super.initState();
    updateRefillSale = UpdateRefillSale();
    insertDelBoyStockList();
    stockDataFuture = updateRefillSale!.getDataFromDatabase();
    debugPrint("stockDataFuture: $stockDataFuture");
    filteredData = [];
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
      debugPrint("stockDataFuture: $stockDataFuture");    });
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CustomAppBar(
  //       title: 'Submit stock to manager', // Title or hint text for the text field
  //     ),
  //     body:
  //     ListView.builder(
  //       itemCount: stockSubmitData?.length ?? 0,
  //       itemBuilder: (context, index) {
  //         final sale = stockSubmitData?[index];
  //         return Padding(
  //           padding: const EdgeInsets.all(5.0),
  //           child: Card(color: Colors.white,
  //             child:
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ListTile(
  //                     title: Text('Delivery Boy Name: ${sale?.staffName}'),
  //                     subtitle: Text('Delivery Boy Id: ${sale?.dMId}'),
  //                   ),
  //                   // Display items list (items in `ItemList`)
  //                   Container(
  //                     decoration: BoxDecoration(border: Border.all(width: 0.5)),
  //                     child: Column(
  //                       children: [
  //                         // Header Row with equal width for all columns using Expanded
  //                         Row(
  //                           children: [
  //                             Expanded(child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("SV",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("TV",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("Def.",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                             verticalDividerVerySmall(),
  //                             Expanded(child: Center(child: Text("<Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
  //                           ],
  //                         ),
  //
  //                         // Divider between header and data rows
  //                         Container(
  //                           color: const Color(0xff1280B3),
  //                           height: 1,
  //                           width: MediaQuery.of(context).size.width,
  //                         ),
  //
  //                         // ListView to display the data
  //                         Container(
  //                           child: sale!.itemList!.isNotEmpty
  //                               ?
  //                           ListView.builder(
  //                             physics: const BouncingScrollPhysics(),
  //                             itemCount: sale!.itemList!.length,
  //                             shrinkWrap: true,
  //                             itemBuilder: (BuildContext context, int index) {
  //                               ItemList item = sale!.itemList![index];
  //                                // Get the item at the current index
  //                               // You can access the columns in your database result like this:
  //                               String itemId = item.itemId.toString();
  //                               String itemName = item.itemName.toString();
  //                               String filledSaleQty = item.filledSaleQty.toString();
  //                               String svQty = item.sVQty.toString();
  //                               String tvQty = item.tVQty.toString();
  //                               String emptyRetQty = item.emptyRetQty.toString();
  //                               String deffQty = item.deffQty.toString();
  //                               String lessEmptyQty = item.lessEmptyQty.toString();
  //                               String remark = item.remark.toString();
  //                               return Column(
  //                                 children: [
  //                                   Container(
  //                                     child: Row(
  //                                       children: [
  //                                         // Column 1: Item Name
  //                                         Expanded(
  //                                             child:
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 5.0),
  //                                               child: Text(itemName,style: TextStyle(fontSize: 14, color: Colors.black54)),
  //                                             )),
  //                                         verticalDividerVerySmall(),
  //                                         // Column 2: Filled
  //                                         Expanded(child: Text(filledSaleQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                         verticalDividerVerySmall(),
  //                                         // Column 3: Empty
  //                                         Expanded(child: Text(svQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                         verticalDividerVerySmall(),
  //                                         // Column 4: Defective
  //                                         Expanded(child: Text(tvQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                         verticalDividerVerySmall(),
  //                                         Expanded(child: Text(emptyRetQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                         verticalDividerVerySmall(),
  //                                         Expanded(child: Text(deffQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                         verticalDividerVerySmall(),
  //                                         Expanded(child: Text(lessEmptyQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   Container(
  //                                     color: Colors.grey,
  //                                     height: 1,
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           )
  //                               : Container(
  //                             padding: EdgeInsets.all(5),
  //                             child: const Center(child: Text("No pending data..!")),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           num? dmId = sale?.dMId;
  //                           // Finalize and close the dialog after the user finishes adding remarks
  //                           submitDelBoyStockList(dmId.toString());
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.blue,
  //                           // Button expands to fill available width// Text color of the button
  //                           shape: RoundedRectangleBorder(
  //                             // Optional: Set rounded corners
  //                             borderRadius: BorderRadius.circular(50),
  //                           ),
  //                         ),
  //                         child: const Text(
  //                           "Submit",
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                       SizedBox(width: 20,),
  //                       ElevatedButton(
  //                         onPressed: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => EditSaleScreen(sale: sale!),
  //                             ),
  //                           );
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.blue,
  //                           // Button expands to fill available width// Text color of the button
  //                           shape: RoundedRectangleBorder(
  //                             // Optional: Set rounded corners
  //                             borderRadius: BorderRadius.circular(50),
  //                           ),
  //                         ),
  //                         child: const Text(
  //                           "Edit",
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, DashboardScreen.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, DashboardScreen.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Submitted Stock', // Title or hint text for the text field
        ),
        body:
        // FutureBuilder<List<StockSubmitToManagerListModel>>(
        //   future: stockDataFuture,  // Future to get the data
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());  // Show loading while waiting
        //     } else if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));  // Show error message if any error occurs
        //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //       return Center(child: Text('No data found.'));
        //     } else {
        //       // If the data is available
        //       List<StockSubmitToManagerListModel> stockSubmitData = snapshot.data!;
        //
        //       return
        //         ListView.builder(
        //         itemCount: stockSubmitData.length,
        //         itemBuilder: (context, index) {
        //           final sale = stockSubmitData[index];
        //           return Padding(
        //             padding: const EdgeInsets.all(5.0),
        //             child: Card(
        //               color: Colors.white,
        //               child: Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     ListTile(
        //                       title:Text('Delivery Men Name: ${capitalizeFirstLetter(sale.staffName.toString())}'),
        //                     ),
        //                     Container(
        //                       decoration: BoxDecoration(border: Border.all(width: 0.5)),
        //                       child: Column(
        //                         children: [
        //                           // Header Row with equal width for all columns using Expanded
        //                           Row(
        //                             children: [
        //                               Expanded(
        //                                   flex:2,child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:2,child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:2,child: Center(child: Text("SV",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:2,child: Center(child: Text("TV",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:3,child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:2,child: Center(child: Text("Def.",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                               verticalDividerVerySmall(),
        //                               Expanded(flex:3,child: Center(child: Text("Less\nEmpty",style: TextStyle(fontWeight: FontWeight.bold)))),
        //                             ],
        //                           ),
        //                           // Divider between header and data rows
        //                           Container(
        //                             color: const Color(0xff1280B3),
        //                             height: 1,
        //                             width: MediaQuery.of(context).size.width,
        //                           ),
        //                           // ListView to display the data
        //                           sale.itemList!.isNotEmpty
        //                               ? ListView.builder(
        //                             physics: const BouncingScrollPhysics(),
        //                             itemCount: sale.itemList!.length,
        //                             shrinkWrap: true,
        //                             itemBuilder: (BuildContext context, int index) {
        //                               ItemList item = sale.itemList![index];
        //                               bool isFlagPending = item.FlagColumnUpdate == 'Pending';
        //                               debugPrint("flagUpdate${isFlagPending}");
        //                               debugPrint("flagUpdate${item.FlagColumnUpdate}");
        //                               // Get the item at the current index
        //                               return Column(
        //                                 children: [
        //                                   Container(
        //                                     child: Row(
        //                                       children: [
        //                                         // Column 1: Item Name
        //                                         Expanded(flex:2,
        //                                           child: Padding(
        //                                             padding: const EdgeInsets.only(left: 5.0),
        //
        //                                             child: Text(item.itemName ?? 'N/A', style: TextStyle(fontSize: 14, color: Colors.black54)),
        //                                           ),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 2: Filled
        //                                         Expanded(flex:2,
        //                                           child: Text(item.filledSaleQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 3: SV
        //                                         Expanded(flex:2,
        //                                           child: Text(item.sVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 4: TV
        //                                         Expanded(flex:2,
        //                                           child: Text(item.tVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 5: Empty
        //                                         Expanded(flex:3,
        //                                           child: Text(item.emptyRetQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 6: Def
        //                                         Expanded(flex:2,
        //                                           child: Text(item.deffQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                         verticalDividerVerySmall(),
        //                                         // Column 7: Less Empty
        //                                         Expanded(flex:3,
        //                                           child: Text(item.lessEmptyQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                   Container(
        //                                     color:Colors.black12,
        //                                     height: 1,
        //                                     width: MediaQuery.of(context).size.width,
        //                                   ),
        //                                   // Container(
        //                                   //   color: Colors.grey,
        //                                   //   height: 1,
        //                                   // ),
        //                                   // SizedBox(height: 10),
        //                                   // isFlagPending?
        //                                   // Row(
        //                                   //   mainAxisAlignment: MainAxisAlignment.end,
        //                                   //   children: [
        //                                   //     ElevatedButton(
        //                                   //       onPressed: () {
        //                                   //         num? dmId = sale.dMId;
        //                                   //         num? gkId = sale.saleGKId;
        //                                   //         // Finalize and close the dialog after the user finishes adding remarks
        //                                   //         submitDelBoyStockList(dmId.toString(),gkId.toString());
        //                                   //       },
        //                                   //       style: ElevatedButton.styleFrom(
        //                                   //         backgroundColor: Colors.blue,
        //                                   //         shape: RoundedRectangleBorder(
        //                                   //           borderRadius: BorderRadius.circular(50),
        //                                   //         ),
        //                                   //       ),
        //                                   //       child: const Text(
        //                                   //         "Submit",
        //                                   //         style: TextStyle(color: Colors.white),
        //                                   //       ),
        //                                   //     ),
        //                                   //     SizedBox(width: 20),
        //                                   //     ElevatedButton(
        //                                   //       onPressed: () {
        //                                   //         Navigator.push(
        //                                   //           context,
        //                                   //           MaterialPageRoute(
        //                                   //             builder: (context) => EditSaleScreen(sale: sale),
        //                                   //           ),
        //                                   //         );
        //                                   //       },
        //                                   //       style: ElevatedButton.styleFrom(
        //                                   //         backgroundColor: Colors.blue,
        //                                   //         shape: RoundedRectangleBorder(
        //                                   //           borderRadius: BorderRadius.circular(50),
        //                                   //         ),
        //                                   //       ),
        //                                   //       child: const Text(
        //                                   //         "Edit",
        //                                   //         style: TextStyle(color: Colors.white),
        //                                   //       ),
        //                                   //     ),
        //                                   //   ],
        //                                   // ):
        //                                   //     Container(),
        //                                 ],
        //                               );
        //                             },
        //                           )
        //                               : Container(
        //                             padding: EdgeInsets.all(5),
        //                             child: const Center(child: Text("No pending data..!")),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     // sale.dailySaleStatus != 3 && sale.dailySaleStatus != 2?
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.end,
        //                       children: [
        //                         // ElevatedButton(
        //                         //   onPressed: () {
        //                         //     num? dmId = sale.dMId;
        //                         //     num? gkSalesId = sale.saleGKId;
        //                         //     // Finalize and close the dialog after the user finishes adding remarks
        //                         //     submitDelBoyStockList(dmId.toString(),gkSalesId.toString());
        //                         //   },
        //                         //   style: ElevatedButton.styleFrom(
        //                         //     backgroundColor: Colors.blue,
        //                         //     shape: RoundedRectangleBorder(
        //                         //       borderRadius: BorderRadius.circular(50),
        //                         //     ),
        //                         //   ),
        //                         //   child: const Text(
        //                         //     "Submit",
        //                         //     style: TextStyle(color: Colors.white),
        //                         //   ),
        //                         // ),
        //                         // SizedBox(width: 20),
        //                         ElevatedButton(
        //                           onPressed: () {
        //                             Navigator.push(
        //                               context,
        //                               MaterialPageRoute(
        //                                 // builder: (context) => EditSaleScreen(sale: sale, saleGKId: sale.saleGKId.toString(),),
        //                                 // builder: (context) => EditSaleScreenNew(sale: sale, saleGKId:sale.saleGKId,dMId:sale.dMId),
        //                                 builder: (context) => EditSaleLocalDatabase(sale: sale, saleGKId:sale.saleGKId,dMId:sale.dMId),
        //                               ),
        //                             );
        //                           },
        //                           style: ElevatedButton.styleFrom(
        //                             backgroundColor: Colors.blue,
        //                             shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(50),
        //                             ),
        //                           ),
        //                           child: const Text(
        //                             "Edit",
        //                             style: TextStyle(color: Colors.white),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                         // Container(),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     }
        //   },
        // ),
        RefreshIndicator(
          onRefresh: _refresh,
          child:
          FutureBuilder<List<StockSubmitToManagerListModel>>(
            future: stockDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Data Found.'));
              } else {
                stockSubmitData = snapshot.data!;

                // Sort data to prioritize dailySaleStatus == 3 at the top
                stockSubmitData?.sort((a, b) {
                  if (a.dailySaleStatus == 3 && b.dailySaleStatus != 3) {
                    return -1; // Place `a` before `b`
                  } else if (a.dailySaleStatus != 3 && b.dailySaleStatus == 3) {
                    return 1; // Place `b` before `a`
                  }
                  return 0; // Keep original order if both are the same
                });

                if (!isSearchActive) {
                  filteredData = stockSubmitData!;
                }

                return
                  Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(height: 40,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) => filterSearchResults(value),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child:
                    //   Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child:
                    //     Card(
                    //       color: Colors.white,shape: BeveledRectangleBorder(),
                    //       child:
                    //       Container(
                    //         decoration: BoxDecoration(border: Border.all(width: 0.5)),
                    //         child:
                    //         Column(
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Expanded(
                    //                   flex: 2,
                    //                   child: Center(child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 2,
                    //                   child: Center(child: Text("Sale", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 2,
                    //                   child: Center(child: Text("SV", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 2,
                    //                   child: Center(child: Text("TV", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 3,
                    //                   child: Center(child: Text("Empty", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 2,
                    //                   child: Center(child: Text("Def.", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //                 verticalDividerVerySmall(),
                    //                 Expanded(
                    //                   flex: 3,
                    //                   child: Center(child: Text("Less\nEmpty", style: TextStyle(fontWeight: FontWeight.bold))),
                    //                 ),
                    //               ],
                    //             ),
                    //             Container(
                    //               color: const Color(0xff1280B3),
                    //               height: 1,
                    //               width: MediaQuery.of(context).size.width,
                    //             ),
                    //             Expanded(
                    //               child:
                    //               ListView.builder(
                    //                 itemCount: groupedData.length ?? 0, // Check if the list is null and provide a default value of 0
                    //                 itemBuilder: (context, index) {
                    //                   // Add a null check to ensure stock is not null
                    //                   StockSubmitToManagerListModel? stock = groupedData[index];
                    //
                    //                   // Return a widget only if stock is not null
                    //                   if (stock == null) {
                    //                     return SizedBox.shrink(); // Return an empty widget if stock is null
                    //                   }
                    //
                    //                   // Use a Container instead of ListTile to remove extra padding
                    //                   return
                    //                     Container(
                    //                     padding: EdgeInsets.symmetric(vertical: 0.0), // Control the vertical padding
                    //                     child: Column(
                    //                       children: [
                    //                         Container(
                    //                           padding: EdgeInsets.symmetric(horizontal: 0.0), // Control horizontal padding
                    //                           child: Row(
                    //                             children: [
                    //                               // Column 1: Item Name
                    //                               Expanded(
                    //                                 flex: 2,
                    //                                 child: Padding(
                    //                                   padding: const EdgeInsets.only(left: 5.0),
                    //                                   child: Text(
                    //                                     stock.itemList![0].itemName ?? 'N/A',
                    //                                     style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 2: Filled
                    //                               Expanded(
                    //                                 flex: 2,
                    //                                 child: Text(
                    //                                   stock.itemList![0].sVQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 3: SV
                    //                               Expanded(
                    //                                 flex: 2,
                    //                                 child: Text(
                    //                                   stock.itemList![0].filledSaleQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 4: TV
                    //                               Expanded(
                    //                                 flex: 2,
                    //                                 child: Text(
                    //                                   stock.itemList![0].tVQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 5: Empty
                    //                               Expanded(
                    //                                 flex: 3,
                    //                                 child: Text(
                    //                                   stock.itemList![0].emptyRetQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 6: Def
                    //                               Expanded(
                    //                                 flex: 2,
                    //                                 child: Text(
                    //                                   stock.itemList![0].deffQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                               verticalDividerVerySmall(),
                    //                               // Column 7: Less Empty
                    //                               Expanded(
                    //                                 flex: 3,
                    //                                 child: Text(
                    //                                   stock.itemList![0].lessEmptyQty.toString(),
                    //                                   style: TextStyle(fontSize: 14, color: Colors.black54),
                    //                                   textAlign: TextAlign.center,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           color: Colors.black12,
                    //                           height: 1,
                    //                           width: MediaQuery.of(context).size.width,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //
                    //   ),
                    //
                    // ),
                    Align(
                      alignment: Alignment.centerLeft,  // Ensures left alignment
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Total Sale",
                          style: Styling.bodyTitleWithBlue,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        color: Colors.white,
                        shape: BeveledRectangleBorder(),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(width: 0.5)),
                          child: Column(
                            children: [
                              // Header row with column titles
                              Row(
                                children: [
                                  Expanded(flex: 2, child: Center(child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 2, child: Center(child: Text("Sale", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 2, child: Center(child: Text("SV", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 2, child: Center(child: Text("TV", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 3, child: Center(child: Text("Empty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 2, child: Center(child: Text("Def.", style: TextStyle(fontWeight: FontWeight.bold)))),
                                  verticalDividerVerySmall(),
                                  Expanded(flex: 3, child: Center(child: Text("Less\nEmpty", style: TextStyle(fontWeight: FontWeight.bold)))),
                                ],
                              ),
                              // Divider below header row
                              Container(
                                color: const Color(0xff1280B3),
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                              ),
                              // ListView.builder with shrinkWrap
                              ListView.builder(
                                shrinkWrap: true, // This ensures the ListView takes only as much space as it needs
                                physics: NeverScrollableScrollPhysics(), // Disable internal scrolling if you want to scroll the parent instead
                                itemCount: groupedData.length ?? 0, // Number of items in your data list
                                itemBuilder: (context, index) {
                                  StockSubmitToManagerListModel? stock = groupedData[index]; // Get stock item at index

                                  // If the stock data is null, skip to the next item
                                  if (stock == null) {
                                    return SizedBox.shrink(); // Return an empty widget if stock is null
                                  }

                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 0.0), // Remove unnecessary vertical padding
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 0.0), // Remove horizontal padding
                                          child: Row(
                                            children: [
                                              // Column 1: Item Name
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                    stock.itemList![0].itemName ?? 'N/A',
                                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 2: Filled
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  stock.itemList![0].filledSaleQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 3: SV
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  stock.itemList![0].sVQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 4: TV
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  stock.itemList![0].tVQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 5: Empty
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  stock.itemList![0].emptyRetQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 6: Def
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  stock.itemList![0].deffQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 7: Less Empty
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  stock.itemList![0].lessEmptyQty.toString(),
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Divider between items
                                        Container(
                                          color: Colors.black12,
                                          height: 1,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,  // Ensures left alignment
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Delivery Men Wise Sale",
                          style: Styling.bodyTitleWithBlue,
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                    filteredData.isNotEmpty?
                        ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final sale = filteredData[index];
                            return
                              Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                              Card(
                                color: Colors.white,shape: BeveledRectangleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Delivery Men : ', style: Styling.itemGreyTextSmall),
                                                Text(
                                                  '${capitalizeFirstLetter(sale.staffName.toString())}',
                                                  style: Styling.itemBlackTestSmall,
                                                ),
                                              ],
                                            ),
                                            saveFlag ? Container():
                                            sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1?
                                            !isSearchActive?
                                            PopupMenuButton<String>(
                                              onSelected: (String value) {
                                                if (value == 'edit') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      // builder: (context) => EditSaleScreen(sale: sale, saleGKId: sale.saleGKId.toString(),),
                                                      // builder: (context) => EditSaleScreenNew(sale: sale, saleGKId:sale.saleGKId,dMId:sale.dMId),
                                                      builder: (context) => DailyRefillSalePage(sale : sale , saleGKId:sale.saleGKId,dMId:sale.dMId,flagAdd:"editMode"),
                                                    ),
                                                  );
                                                } else if (value == 'delete') {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Confirm Deletion"),
                                                          content: Text("Are you sure you want to delete this record?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(); // Close dialog without action
                                                            },
                                                            child: Text("No"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              Navigator.of(context).pop(); // Close dialog
                                                              // Simulate API call and remove item from list
                                                              await deleteDataToApi(sale.saleGKId!.toInt());
                                                              // Update filteredData by removing the deleted item

                                                            },
                                                            child: Text("Yes"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return [
                                                  PopupMenuItem<String>(
                                                    value: 'edit',
                                                    child: Text('Edit',style: Styling.textFormText,),
                                                  ),
                                                  PopupMenuItem<String>(
                                                    value: 'delete',
                                                    child: Text('Delete',style: Styling.textFormText),
                                                  ),
                                                ];
                                              },
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.blue,
                                              ),
                                            ):
                                                Container():
                                            Container()
                                          ],
                                        ),
                                      ),

                                      Container(
                                        decoration: BoxDecoration(border: Border.all(width: 0.5)),
                                        child:
                                        Column(
                                          children: [
                                            // Header Row with equal width for all columns using Expanded
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex:2,child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:2,child: Center(child: Text("Sale",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:2,child: Center(child: Text("SV",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:2,child: Center(child: Text("TV",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:3,child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:2,child: Center(child: Text("Def.",style: TextStyle(fontWeight: FontWeight.bold)))),
                                                verticalDividerVerySmall(),
                                                Expanded(flex:3,child: Center(child: Text("Less\nEmpty",style: TextStyle(fontWeight: FontWeight.bold)))),
                                              ],
                                            ),
                                            // Divider between header and data rows
                                            Container(
                                              color: const Color(0xff1280B3),
                                              height: 1,
                                              width: MediaQuery.of(context).size.width,
                                            ),
                                            // ListView to display the data
                                            sale.itemList!.isNotEmpty
                                                ?
                                            ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              itemCount: sale.itemList!.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                ItemList item = sale.itemList![index];
                                                bool isFlagPending = item.FlagColumnUpdate == 'Pending';
                                                debugPrint("flagUpdate${isFlagPending}");
                                                debugPrint("flagUpdate${item.FlagColumnUpdate}");
                                                // Get the item at the current index
                                                return
                                                  Column(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          // Column 1: Item Name
                                                          Expanded(flex:2,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 5.0),

                                                              child: Text(item.itemName ?? 'N/A', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                                            ),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 2: Filled
                                                          Expanded(flex:2,
                                                            child: Text(item.filledSaleQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 3: SV
                                                          Expanded(flex:2,
                                                            child: Text(item.sVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 4: TV
                                                          Expanded(flex:2,
                                                            child: Text(item.tVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 5: Empty
                                                          Expanded(flex:3,
                                                            child: Text(item.emptyRetQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 6: Def
                                                          Expanded(flex:2,
                                                            child: Text(item.deffQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                          verticalDividerVerySmall(),
                                                          // Column 7: Less Empty
                                                          Expanded(flex:3,
                                                            child: Text(item.lessEmptyQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color:Colors.black12,
                                                      height: 1,
                                                      width: MediaQuery.of(context).size.width,
                                                    ),
                                                    // Container(
                                                    //   color: Colors.grey,
                                                    //   height: 1,
                                                    // ),
                                                    // SizedBox(height: 10),
                                                    // isFlagPending?
                                                    // Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                                    //   children: [
                                                    //     ElevatedButton(
                                                    //       onPressed: () {
                                                    //         num? dmId = sale.dMId;
                                                    //         num? gkId = sale.saleGKId;
                                                    //         // Finalize and close the dialog after the user finishes adding remarks
                                                    //         submitDelBoyStockList(dmId.toString(),gkId.toString());
                                                    //       },
                                                    //       style: ElevatedButton.styleFrom(
                                                    //         backgroundColor: Colors.blue,
                                                    //         shape: RoundedRectangleBorder(
                                                    //           borderRadius: BorderRadius.circular(50),
                                                    //         ),
                                                    //       ),
                                                    //       child: const Text(
                                                    //         "Submit",
                                                    //         style: TextStyle(color: Colors.white),
                                                    //       ),
                                                    //     ),
                                                    //     SizedBox(width: 20),
                                                    //     ElevatedButton(
                                                    //       onPressed: () {
                                                    //         Navigator.push(
                                                    //           context,
                                                    //           MaterialPageRoute(
                                                    //             builder: (context) => EditSaleScreen(sale: sale),
                                                    //           ),
                                                    //         );
                                                    //       },
                                                    //       style: ElevatedButton.styleFrom(
                                                    //         backgroundColor: Colors.blue,
                                                    //         shape: RoundedRectangleBorder(
                                                    //           borderRadius: BorderRadius.circular(50),
                                                    //         ),
                                                    //       ),
                                                    //       child: const Text(
                                                    //         "Edit",
                                                    //         style: TextStyle(color: Colors.white),
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ):
                                                    //     Container(),
                                                  ],
                                                );
                                              },
                                            )
                                                : Container(
                                              padding: EdgeInsets.all(5),
                                              child: const Center(child: Text("No pending data..!")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // sale.dailySaleStatus == 3 || sale.dailySaleStatus == 1?
                                      // !isSearchActive?
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     ElevatedButton(
                                      //       onPressed: () {
                                      //         Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             // builder: (context) => EditSaleScreen(sale: sale, saleGKId: sale.saleGKId.toString(),),
                                      //             // builder: (context) => EditSaleScreenNew(sale: sale, saleGKId:sale.saleGKId,dMId:sale.dMId),
                                      //             builder: (context) => DailyRefillSalePage(sale : sale , saleGKId:sale.saleGKId,dMId:sale.dMId,flagAdd:"editMode"),
                                      //           ),
                                      //         );
                                      //       },
                                      //       style: ElevatedButton.styleFrom(
                                      //         backgroundColor: Colors.blue,
                                      //         shape: RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.circular(50),
                                      //         ),
                                      //       ),
                                      //       child: const Text(
                                      //         "Edit",
                                      //         style: TextStyle(color: Colors.white),
                                      //       ),
                                      //     ),
                                      //     SizedBox(width: 10),
                                      //     ElevatedButton(
                                      //       onPressed: () {
                                      //         showDialog(
                                      //           context: context,
                                      //           builder: (BuildContext context) {
                                      //             return AlertDialog(
                                      //               title: Text("Confirm Deletion"),
                                      //               content: Text("Are you sure you want to delete this record?"),
                                      //               actions: [
                                      //                 TextButton(
                                      //                   onPressed: () {
                                      //                     Navigator.of(context).pop(); // Close dialog without action
                                      //                   },
                                      //                   child: Text("No"),
                                      //                 ),
                                      //                 TextButton(
                                      //                   onPressed: () async {
                                      //                     Navigator.of(context).pop(); // Close dialog
                                      //                     // Simulate API call and remove item from list
                                      //                     await deleteDataToApi(sale.saleGKId!.toInt());
                                      //                     // Update filteredData by removing the deleted item
                                      //
                                      //                   },
                                      //                   child: Text("Yes"),
                                      //                 ),
                                      //               ],
                                      //             );
                                      //           },
                                      //         );
                                      //       },
                                      //       style: ElevatedButton.styleFrom(
                                      //         backgroundColor: Colors.blue,
                                      //         shape: RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.circular(50),
                                      //         ),
                                      //       ),
                                      //       child: const Text(
                                      //         "Delete",
                                      //         style: TextStyle(color: Colors.white),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ):
                                      // Container():
                                      //     Container(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ):
                    Center(child: Text('No Data Found.'))
                    ),
                  ],
                );
              }
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return AlertDialog(
        //           title: Text("Confirm Refresh"),
        //           content: Text("Do You Want To Refresh Data?"),
        //           actions: [
        //             TextButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop(); // Close the dialog without action
        //               },
        //               child: Text("No"),
        //             ),
        //             TextButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop(); // Close the dialog
        //                 setState(() {
        //                   // Refresh the data by reassigning the future
        //                   stockDataFuture = updateRefillSale!.getDataFromDatabase();
        //                   // refreshData();
        //                 });
        //               },
        //               child: Text("Yes"),
        //             ),
        //           ],
        //         );
        //       },
        //     );
        //   },
        //   backgroundColor: Colors.blue,
        //   child: Icon(Icons.refresh, color: Colors.white),
        // ),
      ),
    );
  }
  // Future<void> insertDelBoyStockList() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken = prefs.getString('token');
  //
  //     if (bearerToken == null) {
  //       throw Exception('Bearer token is missing');
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //       },
  //     );
  //     debugPrint("UpdateDailyRefillSaleList"+'${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0');
  //     debugPrint("UpdateDailyRefillSaleList"+response.body);
  //
  //     if (response.statusCode == 200) {
  //       // try {
  //         var data = json.decode(response.body);
  //         // Parse the JSON into StockSubmitToManagerListModel
  //         StockSubmitToManagerListModel result = StockSubmitToManagerListModel
  //             .fromJson(data);
  //         stockSubmitData = result;
  //         // Insert the data into the combined table in the database
  //         // await updateRefillSale?.insertDataToDatabase(result);
  //       // } catch (e) {
  //       //   debugPrint("Error parsing data: $e");
  //       // }
  //     } else {
  //       debugPrint("Failed to fetch data from API: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error during API call: $e");
  //   }
  // }

  // Future<void> insertDelBoyStockList() async {
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
  //         Uri.parse('${AppUrl.UpdateDailyRefillSaleList}/$distributorId/0'),
  //         headers: {
  //           'Authorization': 'Bearer $bearerToken',
  //         },
  //       );
  //
  //       debugPrint("Response body: ${response.body}");
  //       debugPrint("request body DailySaleByGK_StatusUpdate: ${response.request}");
  //       debugPrint("Response body DailySaleByGK_StatusUpdate: ${response.body}");
  //       if (response.statusCode == 200) {
  //         var data = json.decode(response.body);
  //
  //         // Parse the JSON response into a list of StockSubmitToManagerListModel
  //         List<StockSubmitToManagerListModel> result =
  //         List<StockSubmitToManagerListModel>.from(data
  //             .map((item) => StockSubmitToManagerListModel.fromJson(item)));
  //
  //         setState(() {
  //           // stockSubmitData = result;
  //           updateRefillSale?.insertDataToDatabase(result,"Pending","Edit");
  //           stockDataFuture = updateRefillSale!.getDataFromDatabase();
  //           debugPrint("stockDataFuture: $stockDataFuture");
  //
  //         });
  //         // stockDataFuture = updateRefillSale!.getDataFromDatabase();
  //         // debugPrint("stockDataFuture: $stockDataFuture");
  //       } else {
  //         refreshTokens();
  //         debugPrint("Failed to fetch data from API: ${response.statusCode}");
  //       }
  //     } catch (e) {
  //       refreshTokens();
  //       debugPrint("Error during API call: $e");
  //     }
  //   }else{
  //     showFlushBar(context,Constants.connectionTitle,
  //         Constants.connectionMessage);
  //   }
  //
  // }
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
              filteredData = data;
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

  Future<void> submitDelBoyStockList(String delManId,String gkId) async {
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
          Uri.parse('${AppUrl.DailySaleByGK_StatusUpdate}/$distributorId/$gkId/SubmitToManager'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("request body DailySaleByGK_StatusUpdate: ${response.request}");
        debugPrint("Response body DailySaleByGK_StatusUpdate: ${response.body}");

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          updateRefillSale!.updateFlagToComplete(delManId,gkId);
          Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
          // stockDataFuture = updateRefillSale!.getDataFromDatabase();
          // debugPrint("stockDataFuture: $stockDataFuture");
        } else {
          debugPrint("Failed to fetch data from API: ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Error during API call: $e");
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

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
  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       filteredData = stockSubmitData!;
  //     });
  //   } else {
  //     setState(() {
  //       filteredData = stockSubmitData
  //           !.where((sale) => sale.staffName
  //           !.toLowerCase()
  //           .contains(query.toLowerCase()))
  //           .toList();
  //     });
  //   }
  // }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearchActive = false;
        filteredData = stockSubmitData!;
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

        // Fetch the data for the deliveryBoyId
        // var getUpdateRefillSale =
        // await updateRefillSale?.getUpdateRefillSaleData2(
        //     deliveryBoyId.toString(), delDate.toString());
        //
        // if (getUpdateRefillSale == null) {
        //   print('No data found for this deliveryBoyId');
        //   return;
        // }

        List<ItemData> itemList = [];

        // Convert the fetched data into ItemData objects
        // for (var item in getUpdateRefillSale) {
        //   itemList.add(ItemData.fromJson(item));
        // }

        // Prepare the entire data structure for the API
        Map<String, dynamic> apiData = {
          "SaleGKId": salesGKID, // Assuming this is always 0 for the new sale
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
          print('response ${response.body}');
          print('response ${response}');
          // Check response status
          if (response.statusCode == 200) {
            print('Data sent successfully');
            EasyLoading.showToast(Constants.dataDeleted,
                duration: const Duration(milliseconds: 3000));

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

            setState(() {
               insertDelBoyStockList();
               // setState(() {
               //   stockDataFuture = updateRefillSale!.getDataFromDatabase();
               //   debugPrint("Updated stockDataFuture: $stockDataFuture");
               // });

            });
          } else {
            print('Failed to send data: ${response.statusCode}');
            showFlushBar(context, Constants.dataDeletedFail);
          }
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Enter record for that delivery boy..!')),
          // );
        }
      } catch (e) {
        print('Error sending data to API: $e');
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
          filteredData = stockSubmitData ?? []; // Show all data if no search query
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
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            // If the conditions are met, set the flag and save the data
            print("Data is valid, proceeding to save.");
          } else {
            // If any condition is not met, print a message
            print("Data is incomplete. Cannot proceed to save.");
          }
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


  // List<StockSubmitToManagerListModel> _groupAndSumItems(List<StockSubmitToManagerListModel> result) {
  //   Map<num, StockSubmitToManagerListModel> groupedDataMap = {};
  //
  //   // Loop through each StockSubmitToManagerListModel in the filtered result
  //   for (var stock in result) {
  //     for (var item in stock.itemList!) {
  //       num itemId = item.itemId!;
  //
  //       // If itemId already exists in the map, sum the quantities
  //       if (groupedDataMap.containsKey(itemId)) {
  //         StockSubmitToManagerListModel existingStock = groupedDataMap[itemId]!;
  //
  //         // Find the corresponding ItemList in the existing stock
  //         ItemList existingItem = existingStock.itemList!.firstWhere((i) => i.itemId == itemId);
  //
  //         // Create a new ItemList with summed quantities
  //         ItemList updatedItem = existingItem.copyWith(
  //           filledSaleQty: (existingItem.filledSaleQty ?? 0) + (item.filledSaleQty ?? 0),
  //           sVQty: (existingItem.sVQty ?? 0) + (item.sVQty ?? 0),
  //           tVQty: (existingItem.tVQty ?? 0) + (item.tVQty ?? 0),
  //           emptyRetQty: (existingItem.emptyRetQty ?? 0) + (item.emptyRetQty ?? 0),
  //           deffQty: (existingItem.deffQty ?? 0) + (item.deffQty ?? 0),
  //           lessEmptyQty: (existingItem.lessEmptyQty ?? 0) + (item.lessEmptyQty ?? 0),
  //         );
  //
  //         // Update the itemList with the new summed item
  //         List<ItemList> updatedItemList = [
  //           ...existingStock.itemList!.where((i) => i.itemId != itemId), // Remove the old item
  //           updatedItem, // Add the updated item
  //         ];
  //
  //         // Update the StockSubmitToManagerListModel with the new itemList
  //         StockSubmitToManagerListModel updatedStock = existingStock.copyWith(
  //           itemList: updatedItemList,
  //         );
  //
  //         // Update the map with the modified StockSubmitToManagerListModel
  //         groupedDataMap[itemId] = updatedStock;
  //       } else {
  //         // If itemId doesn't exist in the map, create a new entry
  //         groupedDataMap[itemId] = StockSubmitToManagerListModel(
  //           saleGKId: stock.saleGKId,
  //           distributorId: stock.distributorId,
  //           deliveryDate: stock.deliveryDate,
  //           dMId: stock.dMId,
  //           vehicleId: stock.vehicleId,
  //           dailySaleStatus: stock.dailySaleStatus,
  //           staffNo: stock.staffNo,
  //           staffName: stock.staffName,
  //           vehicleNo: stock.vehicleNo,
  //           statusStr: stock.statusStr,
  //           addedOn: stock.addedOn,
  //           addedByNo: stock.addedByNo,
  //           addedByName: stock.addedByName,
  //           addedBy: stock.addedBy,
  //           action: stock.action,
  //           itemList: [
  //             ItemList(
  //               itemId: item.itemId,
  //               itemName: item.itemName,
  //               filledSaleQty: item.filledSaleQty,
  //               sVQty: item.sVQty,
  //               tVQty: item.tVQty,
  //               emptyRetQty: item.emptyRetQty,
  //               deffQty: item.deffQty,
  //               lessEmptyQty: item.lessEmptyQty,
  //               remark: item.remark,
  //               closingFilled: item.closingFilled,
  //               closingEmpty: item.closingEmpty,
  //               closingDef: item.closingDef,
  //               sVConsStr: item.sVConsStr,
  //               TVConsStr: item.TVConsStr,
  //               FlagColumnUpdate: item.FlagColumnUpdate,
  //             )
  //           ],
  //         );
  //       }
  //     }
  //   }
  //
  //   // Convert the map values to a list and return
  //   return groupedDataMap.values.toList();
  // }
  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       isSearchActive = false;
  //       filteredData = stockSubmitData!;  // Reset to original data when query is empty
  //       // After resetting, perform grouping and summing
  //       groupedData = _groupAndSumItems(filteredData);
  //     });
  //   } else {
  //     setState(() {
  //       isSearchActive = true;
  //       filteredData = stockSubmitData!
  //           .where((sale) {
  //         final staffNameMatches = sale.staffName != null &&
  //             sale.staffName!.toLowerCase().contains(query.toLowerCase());
  //         final itemNameMatches = sale.itemList != null &&
  //             sale.itemList!.any((item) =>
  //             item.itemName != null &&
  //                 item.itemName!.toLowerCase().contains(query.toLowerCase()));
  //         return staffNameMatches || itemNameMatches;
  //       })
  //           .toList();
  //
  //       // Check if no results are found
  //       if (filteredData.isEmpty) {
  //         print('No matching data found');
  //         filteredData = [];
  //       }
  //
  //       // Now call _groupAndSumItems with the filtered data
  //       groupedData = _groupAndSumItems(filteredData);
  //     });
  //   }
  // }


}

