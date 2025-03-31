import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../ConstantScreen/widgets.dart';
import '../../Utils/constants.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import '../ManagerModelClass/RSPAmountOFItemListModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart';

class ManagerUpdateSaleListItem extends StatefulWidget {
  DilySaleSummaryDeliveryBoyWiseListModel filteredSales;
  int? vehicleIDs;

  ManagerUpdateSaleListItem(this.filteredSales,this.vehicleIDs,{Key? key}) : super(key: key);

  @override
  State<ManagerUpdateSaleListItem> createState() => _ManagerUpdateSaleListItemState();
}

class _ManagerUpdateSaleListItemState extends State<ManagerUpdateSaleListItem> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool _isExpanded = false;
  List<RspAmountOfItemListModel> rspAmountOfItemList = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return
      Card(
        elevation: 5,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Date and Weight Row with icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Text('${sale.itemName ?? ''}',
                          style: Styling.itemTitle,),
                    ],
                  ),
                  Row(
                    children: [
                      Text('${sale.userName ?? ''}',
                        style: Styling.itemTitle,),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              // Data values Row with icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First Column (Refill and TV)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('Sale:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.gDFilledSale ?? 0}', style: Styling.itemBlackTestSmall),
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('TV:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.tVQty ?? 0}', style: Styling.itemBlackTestSmall),

                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('Act.Sale:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.gDFilledSale ?? 0}', style: Styling.itemBlackTestSmall),
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('Def.:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.deffQty ?? 0}', style: Styling.itemBlackTestSmall),

                        ],
                      ),
                    ],
                  ),
                  // Second Column (SV and Amount)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('SV:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.sVQty ?? 0}',style: Styling.itemBlackTestSmall),

                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 65,
                              child: Text('Amount:', style: Styling.itemGreyTextSmall)),
                          Text('${sale.amount ?? 0}',style: Styling.itemBlackTestSmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Details section with visibility toggle

              Visibility(
                visible: _isExpanded,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    // First Row: Cash and Prepaid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cash Section
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              SizedBox(width: 70,
                                  child: Text('Cash :', style: Styling.itemGreyTextVerySmall)),
                              // Quantity Text
                              Row(
                                children: [
                                  Text('${sale.cashQty ?? 0}', style: Styling.itemBlackTestVerySmall),
                                  SizedBox(width: 5),
                                  // Amount Text
                                  Icon(Icons.currency_rupee,size: 12,),
                                  Text('${sale.cashAmt ?? 0}', style: Styling.itemBlackTestVerySmall),
                                ],
                              ),

                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 20.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        // Prepaid Section
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              SizedBox(width: 70,
                                  child: Text('Prepaid :', style: Styling.itemGreyTextVerySmall)),
                              // Quantity Text
                              Row(
                                children: [
                                  Text('${sale.prepaidQty ?? 0}', style: Styling.itemBlackTestVerySmall),
                                  SizedBox(width: 5),
                                  Icon(Icons.currency_rupee,size: 12,),
                                  Text('${sale.prepaidAmt ?? 0}', style: Styling.itemBlackTestVerySmall),
                                ],
                              ),

                              // Amount Text
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5), // Space between rows
                    // Second Row: Post and Credit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Post Section
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              SizedBox(width: 70,
                                  child: Text('Postpaid :', style: Styling.itemGreyTextVerySmall)),
                              // Quantity Text
                              Row(
                                children: [
                                  Text('${sale.postQty ?? 0}',style: Styling.itemBlackTestVerySmall),
                                  SizedBox(width: 5),
                                  Icon(Icons.currency_rupee,size: 12,),
                                  Text('${sale.postAmt ?? 0}', style: Styling.itemBlackTestVerySmall),

                                ],
                              ),

                              // Amount Text
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 20.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        // Credit Section
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              SizedBox(width: 70,
                                  child: Text('Credit :',style: Styling.itemGreyTextVerySmall)),
                              // Quantity Text
                              Row(
                                children: [
                                  Text('${sale.creditQty ?? 0}', style: Styling.itemBlackTestVerySmall),
                                  SizedBox(width: 5),
                                  Icon(Icons.currency_rupee,size: 12,),
                                  Text('${sale.creditAmt ?? 0}', style: Styling.itemBlackTestVerySmall),
                                ],
                              ),

                              // Amount Text

                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     SizedBox(
                    //         child: Text('Received Amt.:', style: Styling.itemGreyTextSmall)),
                    //     Text('${sale.amount ?? 0}',style: Styling.itemBlackTestSmall),
                    //
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Row for expand/collapse and update button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          child: Text('Received Amt.:', style: Styling.itemGreyTextSmall)),
                      Text('${sale.amount ?? 0}',style: Styling.itemBlackTestSmall),

                    ],
                  ),
                  // Arrow icon placed on the left
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _isExpanded = !_isExpanded;  // Toggle the expand/collapse state
                      });
                    },
                    child: Row(
                      children: [
                        Text(_isExpanded?"View Less":"View More",style: Styling.blueClrTextSmall,),
                        IconButton(
                          icon: _isExpanded
                              ? Icon(Icons.arrow_drop_up, color: Color(0xff1280b3))
                              : Icon(Icons.arrow_drop_down, color: Color(0xff1280b3)),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;  // Toggle the expand/collapse state
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   // style: ElevatedButton.styleFrom(
                  //   //   // Button color
                  //   //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  //   //     backgroundColor: Colors.blueAccent
                  //   // ),
                  //   style: ButtonStyle(
                  //     backgroundColor:
                  //     MaterialStateProperty.all<Color>(
                  //         const Color(0xff1280b3)),
                  //   ),
                  //   onPressed: () async {
                  //     // Handle update action
                  //     // Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
                  //     int? itemIds = sale.itemId?.toInt();
                  //     int itemId = sale.itemId?.toInt() ?? 0;  // Get itemId and convert to int
                  //
                  //     // Fetch item rate from the API
                  //     double? itemRate = await fetchItemRate(itemId);
                  //     debugPrint("${itemRate}");
                  //     Navigator.pushNamed(
                  //         context,
                  //         ManagerUpdateSaleCashUpdation
                  //             .screenName,
                  //         arguments: {
                  //           "delBoyName": sale.staffName,
                  //           "itemName": sale.itemName,
                  //           "saleQty" : sale.gDFilledSale,
                  //           "svQty" : sale.sVQty,
                  //           "tvQty" : sale.tVQty,
                  //           "amountTotal" : sale.amount,
                  //           "expAmount" : "",
                  //           "dmBal" : "",
                  //           "itemRate" :itemRate,
                  //           "delBoyID" : sale.staffId,
                  //           "itemID":sale.itemId,
                  //           "salesGkId" : sale.saleGKId,
                  //           "sakesGKItemID" : sale.saleGKItemId,
                  //           "vehicleID" :widget.vehicleIDs,
                  //
                  //         });
                  //   },
                  //   child: Text('Update', style: TextStyle(color: Colors.white, fontSize: 16)),
                  // ),

                  Row(
                    children: [
                      GestureDetector(
                        onTap:() async {
                          // Handle update action
                          // Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
                          int? itemIds = sale.itemId?.toInt();
                          int itemId = sale.itemId?.toInt() ?? 0;  // Get itemId and convert to int

                          // Fetch item rate from the API
                          double? itemRate = await fetchItemRate(itemId);
                          debugPrint("${itemRate}");
                          Navigator.pushNamed(
                              context,
                              ManagerUpdateSaleCashUpdation
                                  .screenName,
                              arguments: {
                                "delBoyName": sale.staffName,
                                "itemName": sale.itemName,
                                "saleQty" : sale.gDFilledSale,
                                "svQty" : sale.sVQty,
                                "tvQty" : sale.tVQty,
                                "amountTotal" : sale.amount,
                                "expAmount" : "",
                                "dmBal" : "",
                                "itemRate" :itemRate,
                                "delBoyID" : sale.staffId,
                                "itemID":sale.itemId,
                                "salesGkId" : sale.saleGKId,
                                "sakesGKItemID" : sale.saleGKItemId,
                                "vehicleID" :widget.vehicleIDs,

                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Update",style: Styling.blueClrTextWithUnderline
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
  // Future<void> fetchItemRate(int itemID) async {
  //   Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
  //
  //   if (!Constants.isNetworkAvailable) {
  //     // Return an empty list if there is no network connection
  //     showFlushBar(context,Constants.connectionTitle,
  //         Constants.connectionMessage);
  //     isLoading = false;
  //   }else {
  //     try {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       String? distributorId = prefs.getString('DistributorId');
  //       String? bearerToken = prefs.getString('token');
  //
  //       if (bearerToken == null) {
  //         isLoading = false;
  //         throw Exception('Bearer token is missing');
  //       }
  //
  //       final response = await http.get(
  //         Uri.parse(
  //             '${AppUrl.GetRSPDetailsList}/$distributorId/Today'),
  //         headers: {
  //           'Authorization': 'Bearer $bearerToken',
  //         },
  //       );
  //
  //       debugPrint("Response body GetDailySaleSummaryListDMWiseForMob: ${response.body}");
  //       debugPrint("request body GetDailySaleSummaryListDMWiseForMob: ${response.request}");
  //
  //       if (response.statusCode == 200) {
  //         // Parse the JSON response
  //         final List<dynamic> data = json.decode(response.body);
  //         // return data
  //         //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
  //         //     .toList();
  //         setState(() {
  //           rspAmountOfItemList = data.map((jsonItem) =>
  //               RspAmountOfItemListModel.fromJson(jsonItem)).toList();
  //
  //           isLoading = false;
  //         });
  //       } else {
  //         isLoading = false;
  //         throw Exception('Failed to load sales data');
  //       }
  //     } catch (error) {
  //       isLoading = false;
  //       debugPrint("Error: $error");
  //       // Return an empty list in case of an error
  //     }
  //   }
  // }

  Future<double?> fetchItemRate(int itemID) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      return null;  // Returning null if there's no connection
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetRSPDetailsList}/$distributorId/Today'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetRSPDetailsList: ${response.body}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);

          // Find the item rate for the given itemId
          var item = data.firstWhere((jsonItem) => jsonItem['ItemId'] == itemID, orElse: () => null);

          if (item != null) {
            double? itemRate = item['RSP_Price']?.toDouble();
            return itemRate;
          } else {
            debugPrint('Item not found');
            return null;
          }
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
        return null;  // Return null in case of an error
      }
    }
  }

}
