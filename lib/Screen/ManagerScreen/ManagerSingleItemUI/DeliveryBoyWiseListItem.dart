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
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../DeliveryBoyWiseListShow.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/GetLastUploadedFrileDifferenceModel.dart';
import '../ManagerUpdateSaleScreen.dart';

class DeliveryBoyWiseListItem extends StatefulWidget {
  DailySaleSaummaryListModel filteredSales;

  DeliveryBoyWiseListItem(this.filteredSales, {Key? key}) : super(key: key);

  @override
  State<DeliveryBoyWiseListItem> createState() =>
      _DeliveryBoyWiseListItemState();
}

class _DeliveryBoyWiseListItemState extends State<DeliveryBoyWiseListItem> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool _isExpanded = false;
  List<GetLastUploadedFrileDifferenceModel> getLastUploadedFile =
      []; // List for filtered results
  bool saveFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndSaveDayEndData();
    getLastUploadedFileDifference();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Column(
          children: [
            // Date and Weight Row with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(sale.staffName ?? '',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1280b3),
                            fontFamily: 'OpenSans')),
                  ],
                ),
                Row(
                  children: [
                    Text('Status :',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            color: Color(0xff1280b3))),
                    SizedBox(width: 5),
                    Text('${sale.statusStr ?? 0}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            color: Colors.black)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            // Data values Row with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('SV ',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('TV',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('Sale',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('Def.',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('Act. Sale',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('${sale.totalSVQty ?? 0}',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('${sale.totalTVQty ?? 0}',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('${sale.totalFilledQty ?? 0}',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('${sale.totalDefQty ?? 0}',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text('${sale.totalActualSaleQty ?? 0}',
                          style:
                              TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Row(
                    children: [
                      Text('Total Amt.: ',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                      Text(
                        formatCurrency((sale.totalAmt ?? 0).toDouble()),
                        style: TextStyle(fontSize: 14, fontFamily: 'OpenSans'),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Row(
                    children: [
                      Text('Recieved Amt.',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                      Text(
                        formatCurrency((sale.totRecievedcAmt ?? 0).toDouble()),
                        style: TextStyle(fontSize: 14, fontFamily: 'OpenSans'),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // Expandable section
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
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontFamily: 'OpenSans'))),
                            // Quantity Text
                            Row(
                              children: [
                                // Text('${sale.cashQty ?? 0}',
                                //     style: TextStyle(
                                //         fontSize: 12,
                                //         color: Colors.black,
                                //         fontFamily: 'OpenSans')),
                                // SizedBox(width: 5),
                                // Amount Text
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.cashAmt ?? 0).toDouble()),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'OpenSans')),
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
                                child: Text('Prepaid :',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontFamily: 'OpenSans'))),
                            // Quantity Text
                            Row(
                              children: [
                                // Text('${sale.prepaidQty ?? 0}',
                                //     style: TextStyle(
                                //         fontSize: 12,
                                //         color: Colors.black,
                                //         fontFamily: 'OpenSans')),
                                // SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),

                                Text(
                                    formatCurrency(
                                        (sale.prepaidAmt ?? 0).toDouble()),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'OpenSans')),
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
                            SizedBox(
                                width: 70,
                                child: Text('Postpaid :',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontFamily: 'OpenSans'))),
                            // Quantity Text
                            Row(
                              children: [
                                // Text('${sale.postPaidQty ?? 0}',
                                //     style: TextStyle(
                                //         fontSize: 12,
                                //         color: Colors.black,
                                //         fontFamily: 'OpenSans')),
                                // SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),
                                Text(
                                    formatCurrency(
                                        (sale.postPaidAmt ?? 0).toDouble()),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'OpenSans')),
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
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontFamily: 'OpenSans'))),
                            // Quantity Text
                            Row(
                              children: [
                                // Text('${sale.retiCrQty ?? 0}',
                                //     style: TextStyle(
                                //         fontSize: 12,
                                //         color: Colors.black,
                                //         fontFamily: 'OpenSans')),
                                // SizedBox(width: 5),
                                Icon(
                                  Icons.currency_rupee,
                                  size: 12,
                                ),

                                Text(
                                    formatCurrency(
                                        (sale.retiCrAmt ?? 0).toDouble()),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontFamily: 'OpenSans')),
                              ],
                            ),

                            // Amount Text
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Expand/Collapse row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? "View Less .." : "View More ..",
                        style: TextStyle(
                            color: Color(0xff1280b3),
                            fontFamily: 'OpenSans',
                            fontSize: 14),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Color(0xff1280b3),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (saveFlag) {
                          print('saveFlag $saveFlag');
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if ((sale.dailySaleStatus == 1 ||
                              sale.dailySaleStatus == 4)) {
                            int? saleGk = sale.saleGKId?.toInt();
                            statusChangeApi(saleGk!, 0, 2, Constants.acceptSale);
                          } else {
                            if (getLastUploadedFile[0].bkgHrDiff == 0 &&
                                getLastUploadedFile[0].settHrDiff == 0) {
                              Navigator.pushNamed(
                                  context, ManagerUpdateSaleScreen.screenName,
                                  arguments: {
                                    "delBoyName": sale.staffName,
                                    "receiptNo": "",
                                    "receiptDate": sale.delDate,
                                    "delBoyId": sale.dMId,
                                    "saledgkID": sale.saleGKId,
                                    "vehicleNo": sale.vehicleNo,
                                    "vehicleID": sale.vehicleId,
                                  });
                            } else {
                              showCustomAlertDialog(
                                context,
                                title: 'You have not uploaded latest file',
                                content:
                                'To complete the cash collection, you need to upload the latest file. Please log in to the Niyojan web portal to upload the file.',
                              );
                            }
                          }
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            (sale.dailySaleStatus == 1 ||
                                    sale.dailySaleStatus == 4)
                                ? "Accept"
                                : ((sale.dailySaleStatus == 2) ||
                                        (sale.dailySaleStatus != 3 &&
                                            sale.dailySaleStatus != 1 &&
                                            sale.dailySaleStatus != 4 &&
                                            sale.dailySaleStatus != 7))
                                    ? "Update"
                                    : "",
                            style: Styling.blueClrTextWithUnderline),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((sale.dailySaleStatus != 3 &&
                            sale.dailySaleStatus != 5 &&
                            sale.dailySaleStatus != 6 &&
                            sale.dailySaleStatus != 7 &&
                            sale.dailySaleStatus != 8)) {
                          int? saleGk = sale.saleGKId?.toInt();
                          statusChangeApi(
                              saleGk!, 0, 3, Constants.correctionRequestMethod);
                        } else {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            (sale.dailySaleStatus != 3 &&
                                    sale.dailySaleStatus != 5 &&
                                    sale.dailySaleStatus != 6 &&
                                    sale.dailySaleStatus != 7 &&
                                    sale.dailySaleStatus != 8)
                                ? "Correction"
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

  Future<void> getLastUploadedFileDifference() async {
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
          Uri.parse('${AppUrl.GetLastUploadedTimeDiff}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetLastUploadedTimeDiff: ${response.body}");
        debugPrint("request body GetLastUploadedTimeDiff: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getLastUploadedFile = data
                .map((jsonItem) =>
                    GetLastUploadedFrileDifferenceModel.fromJson(jsonItem))
                .toList();
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

  // void showCustomAlertDialog(BuildContext context, {
  //   required String title,
  //   required String content,
  //   String cancelText = 'OK',
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title,style: Styling.bodyTitleWithBlue,textAlign: TextAlign.center,),
  //         content: Text(content,style: Styling.textFormText,textAlign: TextAlign.center,),
  //         actions: [
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.redAccent,
  //               // Button expands to fill available width// Text color of the button
  //               shape: RoundedRectangleBorder(
  //                 // Optional: Set rounded corners
  //                 borderRadius: BorderRadius.circular(50),
  //               ),
  //             ),
  //             child: Text(cancelText,style: TextStyle(color: Colors.white),),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void showCustomAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = 'OK',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: prevent tap outside to dismiss
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
                style: Styling.bodyTitleWithBlue,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: Styling.textFormText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
        );
      },
    );
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
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
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            print("Data is valid, proceeding to save.");
          } else {
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
