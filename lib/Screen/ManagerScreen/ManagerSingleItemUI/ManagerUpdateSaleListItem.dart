import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/DeliveryBoyModel/GetSVTVConsumerListModel.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import '../ManagerModelClass/RSPAmountOFItemListModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart';
import '../SVSaleModel/GetSVConsumerListForCashCollectionMode.dart';

class ManagerUpdateSaleListItem extends StatefulWidget {
  DilySaleSummaryDeliveryBoyWiseListModel filteredSales;
  int? vehicleIDs;
  String? vehicleNumber;
  String? receiptNoText;

  ManagerUpdateSaleListItem(this.filteredSales, this.vehicleIDs,
      this.vehicleNumber, this.receiptNoText,
      {Key? key})
      : super(key: key);

  @override
  State<ManagerUpdateSaleListItem> createState() =>
      _ManagerUpdateSaleListItemState();
}

class _ManagerUpdateSaleListItemState extends State<ManagerUpdateSaleListItem> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool _isExpanded = false;
  List<RspAmountOfItemListModel> rspAmountOfItemList = [];
  bool isLoading = true;
  List<GetSvConsumerListForCashCollectionMode> getSvtvConsumerList = [];

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return Card(
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
                    Text(
                      '${sale.itemName ?? ''}',
                      style: Styling.itemTitle,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${sale.userName ?? ''}',
                      style: Styling.itemTitle,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
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
                        SizedBox(
                            width: 65,
                            child: Text('Sale:',
                                style: Styling.itemGreyTextSmall)),
                        Text('${sale.gDFilledSale ?? 0}',
                            style: Styling.itemBlackTestSmall),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 65,
                            child:
                                Text('TV:', style: Styling.itemGreyTextSmall)),
                        Text('${sale.tVQty ?? 0}',
                            style: Styling.itemBlackTestSmall),
                      ],
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 65,
                            child: Text('Act.Sale:',
                                style: Styling.itemGreyTextSmall)),
                        Text('${sale.actualSaleQty ?? 0}',
                            style: Styling.itemBlackTestSmall),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 65,
                            child: Text('Def.:',
                                style: Styling.itemGreyTextSmall)),
                        Text('${sale.deffQty ?? 0}',
                            style: Styling.itemBlackTestSmall),
                      ],
                    ),
                  ],
                ),
                // Second Column (SV and Amount)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _fetchSVConsumerData("sv", sale.saleGKItemId!.toInt());
                      },
                      child: Row(
                        children: [
                          SizedBox(
                              width: 65,
                              child: Text('SV:',
                                  style: Styling.itemGreyTextSmall)),
                          Text('${sale.sVQty ?? 0}',
                              style: Styling.blueClrTextWithUnderline),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 65,
                            child: Text('Amount:',
                                style: Styling.itemGreyTextSmall)),
                        Text(formatCurrency((sale.amount ?? 0).toDouble()),
                            style: Styling.itemBlackTestSmall),
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
                  SizedBox(
                    height: 10,
                  ),
                  // First Row: Cash and Prepaid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cash Section
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            SizedBox(
                                width: 70,
                                child: Text('Cash :',
                                    style: Styling.itemGreyTextVerySmall)),
                            // Quantity Text
                            Row(
                              children: [
                                Text('${sale.cashQty ?? 0}',
                                    style: Styling.itemBlackTestVerySmall),
                                SizedBox(width: 5),
                                // Amount Text
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.cashAmt ?? 0).toDouble()),
                                    style: Styling.itemBlackTestVerySmall),
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
                            SizedBox(
                                width: 70,
                                child: Text('Online/Prepaid :',
                                    style: Styling.itemGreyTextVerySmall)),
                            // Quantity Text
                            Row(
                              children: [
                                Text('${sale.prepaidQty ?? 0}',
                                    style: Styling.itemBlackTestVerySmall),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.prepaidAmt ?? 0).toDouble()),
                                    style: Styling.itemBlackTestVerySmall),
                              ],
                            ),

                            // Amount Text
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  // Space between rows
                  // Second Row: Post and Credit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Post Section
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            SizedBox(
                                width: 70,
                                child: Text('Merchant QR :',
                                    style: Styling.itemGreyTextVerySmall)),
                            // Quantity Text
                            Row(
                              children: [
                                Text('${sale.postQty ?? 0}',
                                    style: Styling.itemBlackTestVerySmall),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.postAmt ?? 0).toDouble()),
                                    style: Styling.itemBlackTestVerySmall),
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
                            SizedBox(
                                width: 70,
                                child: Text('Credit :',
                                    style: Styling.itemGreyTextVerySmall)),
                            // Quantity Text
                            Row(
                              children: [
                                Text('${sale.creditQty ?? 0}',
                                    style: Styling.itemBlackTestVerySmall),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.creditAmt ?? 0).toDouble()),
                                    style: Styling.itemBlackTestVerySmall),
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
                        child: Text('Received Amt.:',
                            style: Styling.itemGreyTextSmall)),
                    Text(formatCurrency((sale.denoCashRcvd ?? 0).toDouble()),
                        style: Styling.itemBlackTestSmall),
                  ],
                ),
                // Arrow icon placed on the left
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded =
                          !_isExpanded; // Toggle the expand/collapse state
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? "View Less" : "View More",
                        style: Styling.blueClrTextSmall,
                      ),
                      IconButton(
                        icon: _isExpanded
                            ? Icon(Icons.arrow_drop_up,
                                color: Color(0xff1280b3))
                            : Icon(Icons.arrow_drop_down,
                                color: Color(0xff1280b3)),
                        onPressed: () {
                          setState(() {
                            _isExpanded =
                                !_isExpanded; // Toggle the expand/collapse state
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
                      onTap: () async {
                        // Handle update action
                        // Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
                        int? itemIds = sale.itemId?.toInt();
                        int itemId = sale.itemId?.toInt() ??
                            0; // Get itemId and convert to int
                        // Fetch item rate from the API
                        double? itemRate = await fetchItemRate(itemId);
                        debugPrint("${itemRate}");

                        if ((sale.cashQty == 0 &&
                            sale.prepaidQty == 0 &&
                            sale.postQty == 0 &&
                            sale.creditQty == 0 &&
                            sale.cashAmt == 0 &&
                            sale.postAmt == 0 &&
                            sale.actualSaleQty != 0)) {
                          Navigator.pushNamed(
                              context, ManagerUpdateSaleCashUpdation.screenName,
                              arguments: {
                                "delBoyName": sale.staffName,
                                "itemName": sale.itemName,
                                "saleQty": sale.actualSaleQty,
                                "svQty": sale.sVQty,
                                "tvQty": sale.tVQty,
                                "amountTotal": sale.amount,
                                "expAmount": "",
                                "dmBal": "",
                                "itemRate": itemRate,
                                "delBoyID": sale.staffId,
                                "itemID": sale.itemId,
                                "salesGkId": sale.saleGKId,
                                "sakesGKItemID": sale.saleGKItemId,
                                "vehicleID": widget.vehicleIDs,
                                "dSCollMgrId": sale.dSCollMgrId,
                                "vehicleNumber": widget.vehicleNumber,
                                "receiptNoText": widget.receiptNoText,
                                "actionModeApi": '',
                                "prepaidQtyApi": sale.prepaidQty,
                                "prepaidAmountApi": sale.prepaidAmt,
                                "postpaidQtyApi": sale.postQty,
                                "postpaidAmountApi": sale.postAmt,
                                "creditQtyApi": sale.creditQty,
                                "creditAmountApi": sale.creditAmt,
                                "cashQtyApi": sale.cashQty,
                                "cashAmountApi": sale.cashAmt,
                                "cashTotalExpectedAmount": sale.denoCashExptd,
                                "cashTotalReceiveAmount": sale.denoCashRcvd,
                                "cashBalanceAmount": sale.cashBalance,
                              });
                        } else if ((sale.cashQty != 0 ||
                            sale.prepaidQty != 0 ||
                            sale.postQty != 0 ||
                            sale.creditQty != 0 ||
                            sale.cashAmt != 0 ||
                            sale.postAmt != 0 && sale.actualSaleQty != 0)) {
                          Navigator.pushNamed(
                              context, ManagerUpdateSaleCashUpdation.screenName,
                              arguments: {
                                "delBoyName": sale.staffName,
                                "itemName": sale.itemName,
                                "saleQty": sale.actualSaleQty,
                                "svQty": sale.sVQty,
                                "tvQty": sale.tVQty,
                                "amountTotal": sale.amount,
                                "expAmount": "",
                                "dmBal": "",
                                "itemRate": itemRate,
                                "delBoyID": sale.staffId,
                                "itemID": sale.itemId,
                                "salesGkId": sale.saleGKId,
                                "sakesGKItemID": sale.saleGKItemId,
                                "vehicleID": widget.vehicleIDs,
                                "dSCollMgrId": sale.dSCollMgrId,
                                "vehicleNumber": widget.vehicleNumber,
                                "receiptNoText": widget.receiptNoText,
                                "actionModeApi": 'EDIT',
                                "prepaidQtyApi": sale.prepaidQty,
                                "prepaidAmountApi": sale.prepaidAmt,
                                "postpaidQtyApi": sale.postQty,
                                "postpaidAmountApi": sale.postAmt,
                                "creditQtyApi": sale.creditQty,
                                "creditAmountApi": sale.creditAmt,
                                "cashQtyApi": sale.cashQty,
                                "cashAmountApi": sale.cashAmt,
                                "cashTotalExpectedAmount": sale.denoCashExptd,
                                "cashTotalReceiveAmount": sale.denoCashRcvd,
                                "cashBalanceAmount": sale.cashBalance,
                              });
                        } else if ((sale.actualSaleQty == 0 ||
                            sale.dailySaleStatus != 13)) {
                          int? saleGk = sale.saleGKId?.toInt();
                          int? saleGkItemId = sale.saleGKItemId?.toInt();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            // prevent tapping outside to dismiss
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    24.0, 20.0, 24.0, 24.0),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      size: 48,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No cash against only SV sale",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "You want to settle sale",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            statusChangeApi(
                                                saleGk!,
                                                saleGkItemId!,
                                                13,
                                                Constants.acceptSale);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Yes,settle",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Cancle",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            (sale.cashQty == 0 &&
                                    sale.prepaidQty == 0 &&
                                    sale.postQty == 0 &&
                                    sale.creditQty == 0 &&
                                    sale.cashAmt == 0 &&
                                    sale.postAmt == 0 &&
                                    sale.actualSaleQty != 0)
                                ? "Update"
                                : (sale.cashQty != 0 ||
                                        sale.prepaidQty != 0 ||
                                        sale.postQty != 0 ||
                                        sale.creditQty != 0 ||
                                        sale.cashAmt != 0 ||
                                        sale.postAmt != 0 &&
                                            sale.actualSaleQty != 0)
                                    ? "Edit"
                                    : (sale.actualSaleQty == 0 ||
                                            sale.dailySaleStatus != 13)
                                        ? "No Cash"
                                        : "",
                            style: Styling.blueClrTextWithUnderline),
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
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      return null; // Returning null if there's no connection
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
          var item = data.firstWhere((jsonItem) => jsonItem['ItemId'] == itemID,
              orElse: () => null);

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
        return null; // Return null in case of an error
      }
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat(
        '#,##,###.00', 'en_IN'); // Indian locale with comma separator

    // Ensure the result always shows a leading zero before the decimal point
    String formattedAmount = format.format(amount);

    // If there's no integer part, it ensures that a leading zero is added before decimal
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }

    return formattedAmount;
  }

  Future<void> statusChangeApi(int salesGKId, int salesGKItemId, int flagUpdate,
      String messageShow) async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.DailySaleByGK_StatusUpdate}/$distributorId/$salesGKId/$salesGKItemId/$flagUpdate'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint(
            "Response body DailySaleByGK_StatusUpdate: ${response.body}");
        debugPrint(
            "request body DailySaleByGK_StatusUpdate: ${response.request}");

        if (response.statusCode == 200) {
          final body = response.body;

          EasyLoading.showToast(messageShow,
              duration: const Duration(milliseconds: 3000));
          // Example: refresh screen or go back to previous screen
          // Navigator.pop(context); // or do a refresh using setState()
          Navigator.pushNamed(
            context,
            BottomNavBarExample.screenName,
            arguments: 2, // This opens the third tab
          );
          setState(() {
            // update your UI or state variables if needed
          });
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  void showYesCancelDialog(
    BuildContext context, {
    required String title,
    required String content,
    String yesText = 'Yes',
    String cancelText = 'Cancel',
    required VoidCallback onYesPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent tapping outside to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 48,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onYesPressed(); // Handle "Yes" action
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        yesText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cancelText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchSVConsumerData(String flag, int saleGkItemId) async {
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
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetDailySaleSVTVConsumerDtls}/$dId/$flag/$saleGkItemId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("GetDailySaleSVTVConsumerDtls_Mob response ${response.body}");
        print("GetDailySaleSVTVConsumerDtls_Mobrequest ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            getSvtvConsumerList = data
                .map((json) => GetSvConsumerListForCashCollectionMode.fromJson(json))
                .toList();
            showDetailsDialog(context,getSvtvConsumerList);
            EasyLoading.dismiss();
          });
        } else {
          // Handle non-200 responses
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  void showDetailsDialog(
      BuildContext context,
      List<GetSvConsumerListForCashCollectionMode> itemss,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(10), // Margin from all sides
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                // Top bar with title and close button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical:6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SV Consumer Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),

                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 2),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('DC/Challan', style: Styling.blueClrText),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Cons. No.', style: Styling.blueClrText),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Consumer Name', style: Styling.blueClrText),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Cyl.Qty.', style: Styling.blueClrText, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Date', style: Styling.blueClrText, textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                Divider(),

                // Table Content
                Expanded(
                  child: itemss.isNotEmpty
                      ? ListView.builder(
                    itemCount: itemss.length,
                    itemBuilder: (context, index) {
                      final items = itemss[index];
                      Color backgroundColor = (index % 2 == 0)
                          ? Colors.grey[300]!
                          : Colors.white;
                      return Container(
                        color: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(items.dCChallanNo.toString(), style: Styling.buttonTextBlack,textAlign: TextAlign.left),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(items.consumerNo.toString(), style: Styling.buttonTextBlack,textAlign: TextAlign.left),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(items.consumerName.toString(), style: Styling.buttonTextBlack,textAlign: TextAlign.left),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(items.cylQty.toString(), style: Styling.buttonTextBlack, textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 2,
                                child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(items.sVTVDate ?? '')),style: Styling.buttonTextBlack, textAlign: TextAlign.right),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      : Center(child: Text("No Data Available")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
