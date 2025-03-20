import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

class MarkdefectiveItemUI extends StatefulWidget {
  const MarkdefectiveItemUI({super.key});

  @override
  State<MarkdefectiveItemUI> createState() => _MarkdefectiveItemUIState();
}

class _MarkdefectiveItemUIState extends State<MarkdefectiveItemUI> {
  @override
  Widget build(BuildContext context) {
    return
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child:  Text(
                                "29-09-2024",
                                style: Styling.itemBlackTestSmall,
                              )

                      ),
                      Expanded(
                          flex: 2,
                          child:
                               Text(
                                "14.2 kg",
                                style: Styling.itemBlackTestSmall,
                              )

    ),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text(
                                "4",
                                style: Styling.itemBlackTestSmall,
                              ))),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: GestureDetector(
                                onTap: (){
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
                                              // await deleteDataToApi(sale.saleGKId!.toInt());
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ))),
                    ],
                  ),
                ],
              ),
            );
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

        // // Prepare the entire data structure for the API
        // Map<String, dynamic> apiData = {
        //   "SaleGKId": salesGKID, // Assuming this is always 0 for the new sale
        //   "DistributorId": distributorId,
        //   "GodownId": godownID,
        //   "Action": "DELETE"
        // };
        //
        // // Convert data to JSON and send it to the API
        // String jsonRequestBody = jsonEncode(apiData);
        // debugPrint("jsonRequestBody$jsonRequestBody");
        // if (salesGKID != null && salesGKID != 0) {
        //   // Send the API request
        //   final response = await http.post(
        //     Uri.parse('${AppUrl.UpdateDailyRefillSale}'), // Your actual API URL
        //     headers: {
        //       'Content-Type': 'application/json',
        //       'Authorization': 'Bearer $bearerToken',
        //       // Authorization header with Bearer token
        //     },
        //     body: jsonRequestBody, // The body of the request
        //   );
        //   print('response ${response.body}');
        //   print('response ${response}');
        //   // Check response status
        //   if (response.statusCode == 200) {
        //     print('Data sent successfully');
        //     EasyLoading.showToast(Constants.dataDeleted,
        //         duration: const Duration(milliseconds: 3000));
        //     setState(() {
        //
        //     });
        //   } else {
        //     print('Failed to send data: ${response.statusCode}');
        //     showFlushBar(context, Constants.dataDeletedFail);
        //   }
        // } else {
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   SnackBar(content: Text('Enter record for that delivery boy..!')),
        //   // );
        // }
      } catch (e) {
        print('Error sending data to API: $e');
      }
    } else {
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }
}
