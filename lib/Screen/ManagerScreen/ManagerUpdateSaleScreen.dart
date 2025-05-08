import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import 'package:http/http.dart' as http;

import 'ManagerModelClass/GetExpenceHeadAmountListModel.dart';
import 'ManagerModelClass/GetExpenseDetailListModel.dart';
import 'ManagerModelClass/RSPAmountOFItemListModel.dart';
import 'ManagerSingleItemUI/ManagerUpdateSaleListItem.dart';
class ManagerUpdateSaleScreen extends StatefulWidget {
  static const screenName = '/managerUpdateSaleScreen';
  const ManagerUpdateSaleScreen({super.key});

  @override
  State<ManagerUpdateSaleScreen> createState() => _ManagerUpdateSaleScreenState();
}

class _ManagerUpdateSaleScreenState extends State<ManagerUpdateSaleScreen> {
  TextEditingController searchController = TextEditingController();
  List<DilySaleSummaryDeliveryBoyWiseListModel> dailySales = [];
  List<GetExpenseDetailListModel> getExpenseDetailListModel = [];
  bool isLoading = true;
  var argValue;
  String? delBoyNameName,receiptDate,receiptNoText,vehicleNos;
  int? delBoyId,salesGKId,vehicleIDs,expenseAmtTotal;
  String? formattedDate;
  double expenseTotalAmount= 0;
  @override
  void initState() {

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        delBoyNameName = argValue["delBoyName"];
        receiptDate = argValue["receiptDate"];
        delBoyId = argValue["delBoyId"];
        salesGKId = argValue["saledgkID"];
        vehicleNos = argValue["vehicleNo"];
        vehicleIDs = argValue["vehicleID"];
        DateTime dateTime = DateTime.parse(receiptDate!);
        // Format the DateTime object to a string in the desired format (yyyy-MM-dd)
        formattedDate = "${dateTime.year.toString().padLeft(4, '0')}-${(dateTime.month).toString().padLeft(2, '0')}-${(dateTime.day).toString().padLeft(2, '0')}";
        debugPrint("customerHoldingData :- ${delBoyNameName.toString()}");
        debugPrint("roleValue :- $receiptDate");
        debugPrint("roleValue :- $delBoyId");
        debugPrint("roleValue :- $salesGKId");
        fetchDailySales(delBoyId!,formattedDate!,salesGKId!);
        fetchAndInitialize();
        fetchExpenseDetailList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff1280b3), // You can change the color as needed
        automaticallyImplyLeading: false, // Disable default back button
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            children: [
              // Back Arrow Button
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Text Field
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Sales Summary",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Scaffold(
        body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.blue[50],
                child: 
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 5,bottom: 5),
                  child:
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width : 140,
                            child: Text(
                              'Receipt No',
                              style: Styling.itemGreyText,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ":  $receiptNoText",
                              style: Styling.textFormText,

                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SizedBox(width : 140,
                            child: Text(
                              'Receipt Date',
                              style: Styling.itemGreyText,
                            ),
                          ),
                          Expanded(
                            child: Text(
                             ":  $formattedDate",
                              style: Styling.textFormText,

                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SizedBox(width : 140,
                            child: Text(
                              'Delivery Men',
                              style: Styling.itemGreyText,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ":  $delBoyNameName",

                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SizedBox(width : 140,
                            child: Text(
                              'Vehicle No.',
                              style: Styling.itemGreyText,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ":  $vehicleNos",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          SizedBox(width : 140,
                            child: Text(
                              'Expense Amt.',
                              style: Styling.itemGreyText,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ":  ${expenseTotalAmount.toStringAsFixed(2)}",

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dailySales.length, // You can replace this with your actual list length
                      itemBuilder: (context, index) {
                        return ManagerUpdateSaleListItem(
                            dailySales[index],vehicleIDs,vehicleNos,receiptNoText);
                        },
                    ),
                ),

            ],
          ),
      ),

      );
  }

  Future<void> fetchDailySales(int staffId,String delDate,int salesGKId) async {
    EasyLoading.show();
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      EasyLoading.dismiss();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId, // Example: you can replace this with `distributorId` if needed
          "StaffId": staffId, // Replace with actual staff ID if needed
          "DelDate": delDate, // You can replace this with a dynamic date if needed
          "SaleGKId": salesGKId, // Example sale GK ID, replace if needed
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetDailySaleDetailsByStaffIdForMob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json', // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetDailySaleDetailsByStaffIdForMob: ${response.body}");
        debugPrint("Request body GetDailySaleDetailsByStaffIdForMob: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            dailySales = data.map((jsonItem) =>
                DilySaleSummaryDeliveryBoyWiseListModel.fromJson(jsonItem)).toList();
            // filteredSales = dailySales;
            isLoading = false;
            EasyLoading.dismiss();
          });
        } else {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        EasyLoading.dismiss();
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> fetchAndInitialize() async {
    EasyLoading.show();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDailySaleCollReceiptNo}/$distributorId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      if (response.statusCode == 200) {
        // Assuming response.body is the string you want to set.
        String receiptNo = response.body.trim();  // Remove any leading/trailing spaces
        receiptNo = receiptNo.replaceAll('"', '');
        setState(() {
          // receiptNoController.text = receiptNo;
          receiptNoText = receiptNo;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error: $e');
    }
  }

  Future<void> fetchExpenseDetailList() async {
    EasyLoading.show();
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,
          Constants.connectionMessage);
      isLoading = false;
      EasyLoading.dismiss();
    }else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetExpenseDetailsListByStaffId}/$distributorId/$delBoyId/1/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetExpenseDetailsListByStaffId: ${response.body}");
        debugPrint("request body GetExpenseDetailsListByStaffId: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getExpenseDetailListModel = data.map((jsonItem) =>
                GetExpenseDetailListModel.fromJson(jsonItem)).toList();
            isLoading = false;
            EasyLoading.dismiss();
          });
          double expenseDetailList = 0;

          for (var i = 0; i < getExpenseDetailListModel!.length; i++) {
            double? getExpenseDetailList = getExpenseDetailListModel![i].expAmount?.toDouble();
            expenseDetailList += getExpenseDetailList!;
          }
          debugPrint("Response body expenseDetailList: ${expenseDetailList}");
          expenseTotalAmount = expenseDetailList;
        } else {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        EasyLoading.dismiss();
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

}

