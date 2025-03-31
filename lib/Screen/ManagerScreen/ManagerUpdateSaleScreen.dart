import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // TextEditingController deliveryBoyNameController = TextEditingController();
  // TextEditingController receiptDataController = TextEditingController();
  // TextEditingController receiptNoController = TextEditingController();
  List<DilySaleSummaryDeliveryBoyWiseListModel> dailySales = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  String? _selectedExpenseHead;
  int? _selectedExpenseHeadId;
  List<GetExpenceHeadAmountListModel> _expensesHeaders = [];
  List<GetExpenseDetailListModel> getExpenseDetailListModel = [];
  // List<DilySaleSummaryDeliveryBoyWiseListModel> filteredSales = []; // List for filtered results

  bool _isExpanded = false;
  bool isLoading = true;
  var argValue;
  String? delBoyNameName,receiptDate,receiptNoText,vehicleNos;
  int? delBoyId,salesGKId,vehicleIDs,expenseAmtTotal;
  String? formattedDate;
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
        // deliveryBoyNameController.text = delBoyNameName!;
        // receiptDataController.text = formattedDate!;
        fetchExpenseHeaderDetails();
        fetchExpenseDetailList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blue, // You can change the color as needed
        automaticallyImplyLeading: false, // Disable default back button
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            children: [
              // Back Arrow Button
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, '/managerUpdateSaleScreen');
                  // Navigator.pushNamed(
                  //     context,
                  //     ManagerUpdateSaleScreen
                  //         .screenName);
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
      // CustomAppBarManager(
      //   title: 'Update Sale', // Title or hint text for the text field
      // ),
    //   AppBar(
    //   backgroundColor: Colors.blue, // You can change the color as needed
    //   automaticallyImplyLeading: false, // Disable default back button
    //   title: Padding(
    //     padding: const EdgeInsets.only(left: 0),
    //     child: Row(
    //       children: [
    //         // Back Arrow Button
    //         IconButton(
    //           icon: Icon(Icons.arrow_back, color: Colors.white),
    //           onPressed: () {
    //             Navigator.pushReplacementNamed(context, '/managerUpdateSaleScreen');
    //           },
    //         ),
    //         // Text Field
    //         SizedBox(width: 10,),
    //         Expanded(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 "Update Sale",
    //                 style: TextStyle(color: Colors.white,fontSize: 20),
    //               ),
    //               ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   // Button color
    //                     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    //                     shape: CircleBorder(),
    //                     backgroundColor: Colors.blue[300]
    //                 ),
    //                 onPressed: () {
    //                   // Handle update action
    //                   Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
    //                 },
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Text('Expense', style: TextStyle(color: Colors.black, fontSize: 12)),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
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
                              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            dailySales[index],vehicleIDs);


                        //   Card(
                        //   elevation: 5,
                        //   margin: EdgeInsets.all(8),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: Column(
                        //       children: [
                        //         // Date and Weight Row with icons
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //
                        //             Row(
                        //               children: [
                        //                 Icon(Icons.scale, size: 16, color: Colors.blue),
                        //                 SizedBox(width: 5),
                        //                 Text('14.2 Kg', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //        SizedBox(height: 5,),
                        //         // Data values Row with icons
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             // First Column (Refill and TV)
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Icon(Icons.replay_circle_filled, size: 16, color: Colors.blue),
                        //                     SizedBox(width: 5),
                        //                     SizedBox(width: 60,
                        //                         child: Text('Refill:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        //                     Text('20', style: TextStyle(fontSize: 14)),
                        //
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Icon(Icons.replay_circle_filled, size: 16, color: Colors.blue),
                        //                     SizedBox(width: 5),
                        //                     SizedBox(width: 60,
                        //                         child: Text('TV:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        //                     Text('20', style: TextStyle(fontSize: 14)),
                        //
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //             // Second Column (SV and Amount)
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Icon(Icons.replay_circle_filled, size: 16, color: Colors.blue),
                        //                     SizedBox(width: 5),
                        //                     SizedBox(width: 60,
                        //                         child: Text('SV:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        //                     Text('202222', style: TextStyle(fontSize: 14)),
                        //
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Icon(Icons.currency_rupee, size: 16, color: Colors.blue),
                        //                     SizedBox(width: 5),
                        //                     SizedBox(width: 60,
                        //                         child: Text('Amount:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        //                     Text('2000', style: TextStyle(fontSize: 14)),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //
                        //         // Details section with visibility toggle
                        //
                        //         Visibility(
                        //           visible: _isExpanded,
                        //           child: Column(
                        //             children: [
                        //               SizedBox(height: 10,),
                        //               // First Row: Cash and Prepaid
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                 children: [
                        //                   // Cash Section
                        //                   Expanded(
                        //                     child: Row(
                        //                       children: [
                        //                         SizedBox(width: 8),
                        //                         SizedBox(width: 70,
                        //                             child: Text('Cash :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        //                         // Quantity Text
                        //                         Row(
                        //                           children: [
                        //                             Text('5', style: TextStyle(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                        //                             SizedBox(width: 5),
                        //                             // Amount Text
                        //                             Icon(Icons.currency_rupee,size: 12,),
                        //                             Text('5000', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        //                           ],
                        //                         ),
                        //
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 5),
                        //       Container(
                        //         width: 1.0, // Width of the vertical line
                        //         height: 20.0, // Height of the vertical line
                        //         color: Colors.black, // Color of the line
                        //       ),
                        //                   // Prepaid Section
                        //                   Expanded(
                        //                     child: Row(
                        //                       children: [
                        //                         SizedBox(width: 8),
                        //                         SizedBox(width: 70,
                        //                             child: Text('Prepaid :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        //                         // Quantity Text
                        //                         Row(
                        //                           children: [
                        //                             Text('3', style: TextStyle(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                        //                             SizedBox(width: 5),
                        //                             Icon(Icons.currency_rupee,size: 12,),
                        //                             Text('300000', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        //                           ],
                        //                         ),
                        //
                        //                         // Amount Text
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //
                        //               SizedBox(height: 5), // Space between rows
                        //               // Second Row: Post and Credit
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   // Post Section
                        //                   Expanded(
                        //                     child: Row(
                        //                       children: [
                        //                         SizedBox(width: 8),
                        //                         SizedBox(width: 70,
                        //                             child: Text('Postpaid :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        //                         // Quantity Text
                        //                         Row(
                        //                           children: [
                        //                             Text('2', style: TextStyle(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                        //                             SizedBox(width: 5),
                        //                             Icon(Icons.currency_rupee,size: 12,),
                        //                             Text('20', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        //
                        //                           ],
                        //                         ),
                        //
                        //                         // Amount Text
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: 5),
                        //                   Container(
                        //                     width: 1.0, // Width of the vertical line
                        //                     height: 20.0, // Height of the vertical line
                        //                     color: Colors.black, // Color of the line
                        //                   ),
                        //                   // Credit Section
                        //                   Expanded(
                        //                     child: Row(
                        //                       children: [
                        //                         SizedBox(width: 8),
                        //                         SizedBox(width: 70,
                        //                             child: Text('Credit :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        //                         // Quantity Text
                        //                         Row(
                        //                           children: [
                        //                             Text('1', style: TextStyle(fontSize: 14, color: Colors.grey[700],fontWeight: FontWeight.bold)),
                        //                             SizedBox(width: 5),
                        //                             Icon(Icons.currency_rupee,size: 12,),
                        //                             Text('10', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        //                           ],
                        //                         ),
                        //
                        //                         // Amount Text
                        //
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         // Row for expand/collapse and update button
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             // Arrow icon placed on the left
                        //             GestureDetector(
                        //               onTap: (){
                        //                 setState(() {
                        //                   _isExpanded = !_isExpanded;  // Toggle the expand/collapse state
                        //                 });
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Text(_isExpanded?"View Less":"View More"),
                        //                   IconButton(
                        //                     icon: _isExpanded
                        //                         ? Icon(Icons.arrow_drop_up, color: Colors.blue)
                        //                         : Icon(Icons.arrow_drop_down, color: Colors.blue),
                        //                     onPressed: () {
                        //                       setState(() {
                        //                         _isExpanded = !_isExpanded;  // Toggle the expand/collapse state
                        //                       });
                        //                     },
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             ElevatedButton(
                        //               style: ElevatedButton.styleFrom(
                        //                  // Button color
                        //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //                   backgroundColor: Colors.blueAccent
                        //               ),
                        //               onPressed: () {
                        //                 // Handle update action
                        //                 Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
                        //               },
                        //               child: Text('Update', style: TextStyle(color: Colors.white, fontSize: 16)),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                ),

            ],
          ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add Expense action
            _showExpenseDialog(context,delBoyNameName!,vehicleNos!);
          },
          backgroundColor: Color(0xff1280b3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Exp",style: TextStyle(color: Colors.white,fontSize: 14),),
              Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
      );
  }

  Future<void> fetchDailySales(int staffId,String delDate,int salesGKId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
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
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> fetchAndInitialize() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        isLoading = false;
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
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showExpenseDialog(BuildContext context,String deliveryBoyName,String VehicleNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text("Delivery Men: ${deliveryBoyName}"),
                 Text("Vehicle No.: ${VehicleNo}"),
              const SizedBox(height: 10),
              DropdownButtonFormField<GetExpenceHeadAmountListModel>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                ),
                style: Styling.itemBlackTest,
                items: _expensesHeaders.map((GetExpenceHeadAmountListModel expenses) {
                  return DropdownMenuItem<GetExpenceHeadAmountListModel>(
                    value: expenses,
                    child: Text(expenses.expHeadName ?? ''),
                  );
                }).toList(),
                onChanged: (GetExpenceHeadAmountListModel? selectedVendor) {
                  if (selectedVendor != null) {
                    _selectedExpenseHead = selectedVendor.expHeadName;
                    _selectedExpenseHeadId = selectedVendor.expHeadId?.toInt();
                    // Handle dropdown selection here
                    print("Selected Vendor Name: $_selectedExpenseHead");
                    print("Selected Vendor ID: $_selectedExpenseHeadId");
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Expense Amt. *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _remarkController,
                decoration: const InputDecoration(
                  labelText: "Remark *",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: (){
                int expenseAmt = int.parse(_amountController.text);
                addExpenseAPI(_selectedExpenseHeadId!,_selectedExpenseHead!,expenseAmt,_remarkController.text);
              },
              child: const Text("Save"),
            ),
            // getExpenseDetailListModel.isEmpty
            //     ? const Text('No expenses added yet.')
            //     : Container(
            //   height: 200, // Adjust the height of the list as needed
            //   child: ListView.builder(
            //     itemCount: getExpenseDetailListModel.length,
            //     itemBuilder: (context, index) {
            //       final expense = getExpenseDetailListModel[index];
            //       return Card(
            //         child: ListTile(
            //           title: Text("Head: ${expense.expHeadName}"),
            //           subtitle: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text("Amount: ${expense.expAmount}"),
            //               Text("Remark: ${expense.remark}"),
            //             ],
            //           ),
            //           trailing: IconButton(
            //             icon: const Icon(Icons.delete, color: Colors.red),
            //             onPressed: () {
            //               setState(() {
            //                 getExpenseDetailListModel.removeAt(index);
            //               });
            //             },
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

          ],
        );
      },
    );
  }

  Future<void> fetchExpenseHeaderDetails() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,
          Constants.connectionMessage);
      isLoading = false;
    }else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetExpenseHeaderList}/$distributorId/1'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetExpenseHeaderList: ${response.body}");
        debugPrint("request body GetExpenseHeaderList: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            _expensesHeaders = data.map((jsonItem) =>
                GetExpenceHeadAmountListModel.fromJson(jsonItem)).toList();
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> addExpenseAPI(int expHeadId,String expHeadName,int expAmount,String remark) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? StaffId = prefs.getString('StaffId');
        int? staffIds = int.parse(StaffId!);
        int? distributorIds = int.parse(distributorId!);
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
            "ExpId":0,
            "ExpHeadId":expHeadId,
            "ExpHeadName":expHeadName,
            "DistributorId":distributorIds,
            "VehicleId":vehicleIDs,
            "ExpDate":formattedDate,
            "StaffId":delBoyId,
            "ExpAmount":expAmount,
            "Remark":remark,
            "AddedOn":formattedDate,
            "Action":"ADD",
            "AddedBy":staffIds
        };

        final response = await http.post(
          Uri.parse('${AppUrl.ExpenseDetailsAddEdit}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json', // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body ExpenseDetailsAddEdit: ${response.body}");
        debugPrint("Request body ExpenseDetailsAddEdit: ${response.request}${requestBody}");

        if (response.statusCode == 200) {

          debugPrint("Response body ExpenseDetailsAddEdit: ${response.body}");
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> fetchExpenseDetailList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,
          Constants.connectionMessage);
      isLoading = false;
    }else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetExpenseDetailsListByStaffId}/$distributorId/$delBoyId'),
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
          });
          int expenseDetailList = 0;

          for (var i = 0; i < getExpenseDetailListModel!.length; i++) {
            int? getExpenseDetailList = getExpenseDetailListModel![i].expAmount?.toInt();
            expenseDetailList += getExpenseDetailList!;
          }
          debugPrint("Response body expenseDetailList: ${expenseDetailList}");
          expenseAmtTotal = expenseDetailList;
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

}

