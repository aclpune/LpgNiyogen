import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Widget.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'EditSaleScreen.dart';

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
  @override
  void initState() {
    super.initState();
    updateRefillSale = UpdateRefillSale();
    insertDelBoyStockList();
    stockDataFuture = updateRefillSale!.getDataFromDatabase();
    debugPrint("stockDataFuture: $stockDataFuture");
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Submit stock to manager', // Title or hint text for the text field
      ),
      body: FutureBuilder<List<StockSubmitToManagerListModel>>(
        future: stockDataFuture,  // Future to get the data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Show error message if any error occurs
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found.'));
          } else {
            // If the data is available
            List<StockSubmitToManagerListModel> stockSubmitData = snapshot.data!;

            return ListView.builder(
              itemCount: stockSubmitData.length,
              itemBuilder: (context, index) {
                final sale = stockSubmitData[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text('Delivery Men Name: ${sale.staffName}'),
                            subtitle: Text('Delivery Men Id: ${sale.dMId}'),

                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(width: 0.5)),
                            child: Column(
                              children: [
                                // Header Row with equal width for all columns using Expanded
                                Row(
                                  children: [
                                    Expanded(child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("SV",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("TV",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("Def.",style: TextStyle(fontWeight: FontWeight.bold)))),
                                    verticalDividerVerySmall(),
                                    Expanded(child: Center(child: Text("<Empty",style: TextStyle(fontWeight: FontWeight.bold)))),
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
                                    ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: sale.itemList!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    ItemList item = sale.itemList![index];
                                    bool isFlagPending = item.FlagColumnUpdate == 'Pending';
                                    debugPrint("flagUpdate${isFlagPending}");
                                    debugPrint("flagUpdate${item.FlagColumnUpdate}");
                                    // Get the item at the current index
                                    return Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              // Column 1: Item Name
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),

                                                  child: Text(item.itemName ?? 'N/A', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                                ),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 2: Filled
                                              Expanded(
                                                child: Text(item.filledSaleQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 3: SV
                                              Expanded(
                                                child: Text(item.sVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 4: TV
                                              Expanded(
                                                child: Text(item.tVQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 5: Empty
                                              Expanded(
                                                child: Text(item.emptyRetQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 6: Def
                                              Expanded(
                                                child: Text(item.deffQty.toString(), style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                              ),
                                              verticalDividerVerySmall(),
                                              // Column 7: Less Empty
                                              Expanded(
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
                          sale.dailySaleStatus != 3 && sale.dailySaleStatus != 2?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  num? dmId = sale.dMId;
                                  num? gkSalesId = sale.saleGKId;
                                  // Finalize and close the dialog after the user finishes adding remarks
                                  submitDelBoyStockList(dmId.toString(),gkSalesId.toString());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditSaleScreen(sale: sale),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ):
                              Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
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

  Future<void> insertDelBoyStockList() async {
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

        setState(() {
          // stockSubmitData = result;
          updateRefillSale?.insertDataToDatabase(result,"Pending","Edit");
          // stockDataFuture = updateRefillSale!.getDataFromDatabase();// This stores the sale records
        });
        // stockDataFuture = updateRefillSale!.getDataFromDatabase();
        // debugPrint("stockDataFuture: $stockDataFuture");
      } else {
        debugPrint("Failed to fetch data from API: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error during API call: $e");
    }
  }

  Future<void> submitDelBoyStockList(String delManId,String gkId) async {
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

      debugPrint("Response body: ${response.request}");
      debugPrint("Response body: ${response.body}");

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

}
