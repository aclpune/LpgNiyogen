import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Widget.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import 'package:http/http.dart' as http;

import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import 'StockReturnFromDelBoy.dart';

class DeliveryMenListShowScreenItemUI extends StatefulWidget {
  DeliveryMenSaleListModel _listModel;


  DeliveryMenListShowScreenItemUI(this._listModel,{Key? key}) : super(key: key);

  @override
  State<DeliveryMenListShowScreenItemUI> createState() => _DeliveryMenListShowScreenItemUIState();
}

class _DeliveryMenListShowScreenItemUIState extends State<DeliveryMenListShowScreenItemUI> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool isLoading = true;
  bool saveFlag = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndSaveDayEndData();
  }
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
      value != null && value != ""?
        SingleChildScrollView(  // Make the Column scrollable
          child:
          Container(
            child:
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0,bottom: 0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                              GestureDetector(
                                onTap: (){
                                  if(saveFlag){

                                  }else{
                                    Navigator.pushNamed(
                                        context,
                                        DailyRefillSalePage
                                            .screenName,
                                        arguments: {
                                          "delBoyName": value.staffName,
                                          "delBoyID" : value.dMId,
                                          "vehicleNo" :value.vehicleNo,
                                        });
                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    value.staffName.toString(),
                                    textAlign: TextAlign.left,
                                    style:saveFlag? Styling.blueClrTextWithUnderlineGrey:Styling.blueClrTextWithUnderline,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              ),
                            ),
                            verticalDividerVerySmall(),
                            Container(
                              width: 100,
                              child: Column(
                                children: [
                                  Text(
                                    value.filledSaleQty.toString(),
                                    style:Styling.textFormText,
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.noScaling,
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
                Divider(  // Add a horizontal line (divider) after each item
                  color: Colors.grey,
                  height: 1.0,
                ),
              ],
            ),
          ),

        ):
      Container(
        child:  Text("No data found"),
      );
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
}
