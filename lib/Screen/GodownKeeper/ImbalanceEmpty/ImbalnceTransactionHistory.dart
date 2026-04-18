import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import 'ImbalanceTransactionHistoryListModel.dart';
class ImbalnceTransactionHistory extends StatefulWidget {
  static const screenName = '/imbalnceTransactionHistory';
  const ImbalnceTransactionHistory({super.key});

  @override
  State<ImbalnceTransactionHistory> createState() => _ImbalnceTransactionHistoryState();
}

class _ImbalnceTransactionHistoryState extends State<ImbalnceTransactionHistory> {
  List<ImbalanceTransactionHistoryListModel> imbalanceTransactionHistoryList = [];
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndSaveDayEndData();
    fetchTransactionList();
    _fetchImbalanceData();

  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          // Navigator.pushReplacementNamed(context, DashboardScreen.screenName,
          //     arguments: "onBack");
          Navigator.pop(context);
          return false;
        } else {
          Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Color(0xFFECEFFF),
          backgroundColor: Color(0xFFECEFFF), // Set your desired background color
          automaticallyImplyLeading: false, // Disable default back button
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // 🔙 Back Button
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/bottomNavigationForGodownKeeper');
                },
              ),

              // 🖼 Logo
              Image.asset(
                'assets/playstore.png',
                height: 40,
                width: 40,
              ),

              const SizedBox(width: 8),

              // 📝 App Name + Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.appName,
                    style: Styling.appBarTitle.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Imbalance Transaction History",
                    style: Styling.appBarDesc.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        body:
        SingleChildScrollView(
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imbalanceTransactionHistoryList.isNotEmpty?
              ListView.builder(
                // Combine both lists for display
                shrinkWrap: true, // 👈 Add this
                physics: const NeverScrollableScrollPhysics(), // 👈 Add this
                itemCount: imbalanceTransactionHistoryList.length,
                itemBuilder: (context, index) {
                  // Logic to pick the item from the correct list
                  ImbalanceTransactionHistoryListModel? items = imbalanceTransactionHistoryList[index];
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 1. Wrap the helper in Expanded so its internal Expanded/Flexible
                                // knows the available width.
                                Expanded(
                                  child: Column(
                                    children: [
                                       itemSubLine(
                                          "Imbalance Qty.",
                                          items.imbRecQty.toString(),
                                        ),

                                      itemSubLine(
                                          "Item Name",
                                          items.itemName?.toString() ?? ''
                                        ),

                                    ],
                                  ),
                                ),
                                // 2. The Icon stays on the right
                                GestureDetector(
                                  onTap: () {
                                    // Show confirmation dialog
                                    if (saveFlag) {
                                      showFlushBar(
                                          context,
                                          Constants
                                              .dayEndCompleted);
                                    } else {
                                      if(stockTransferFlag){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm Delete"),
                                              content: const Text("Are you sure you want to delete this record?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context), // Close dialog
                                                  child: const Text("No"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context); // Close dialog
                                                    // Call the delete function
                                                    addItemImbalanceQty(
                                                      items.imbId?.toInt() ?? 0,
                                                      items.consDMId?.toInt() ?? 0,
                                                      items.itemId?.toInt() ?? 0,
                                                      items.imbRecQty?.toInt() ?? 0,
                                                      items.entryType ?? '',
                                                    );
                                                  },
                                                  child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }else{
                                        CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                                      }
                                    }

                                  },
                                  child: Icon(Icons.delete, size: 16, color: Colors.redAccent),

                                ),

                              ],
                            ),

                            itemSubLine(items.entryType == null?"Name":items.entryType == "D"?"Delivery Men":"Customer Name",items.staffName == null ? items.customerName.toString() : items.staffName.toString()),
                          ],
                        ),
                      ),
                    ),
                  );

                },
              ):
              Center(child: const Text('No Records Found')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchImbalanceData() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
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
          Uri.parse('${AppUrl.DailySaleByGKImbSettleList}/$dId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("Total ImbQty for DailySaleByGKImbSettleList response ${response.body}");
        print("Total ImbQty for DailySaleByGKImbSettleList request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            imbalanceTransactionHistoryList = data
                .map((json) => ImbalanceTransactionHistoryListModel.fromJson(json))
                .toList();

          });

        } else {
          // Handle non-200 responses
          setState(() {
            // EasyLoading.dismiss();
            showFlushBar(context, Constants.listGettingFail);
          });

        }
      } catch (e) {
        setState(() {
          // EasyLoading.dismiss();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    } else {
      // EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> addItemImbalanceQty(int imbId, int delMenId, int itemId, int imbQty, String type) async {
    // Construct the request payload
    EasyLoading.show(status: 'Sending Data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    int dId = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);


    Map<String, dynamic> requestBody = {
    "ImbId": imbId,
    "DistributorId": distributorId,
    "GodownId": godownId,
    "ImbDate": formattedDate,
    "ItemId": itemId,
    "EntryType":type ?? '',
    "ConsDMId": delMenId,
    "ImbRecQty": imbQty ?? 0,
    "AddedBy": addedBy,
    "Action": "DELETE"
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DailySaleByGKImbSettleAdd}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("API Response request: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        print("Imbalance quantity added successfully!");
        EasyLoading.showToast("Data Deleted Successfully..",
            duration: const Duration(milliseconds: 3000));
        setState(() {
          _fetchImbalanceData();

        });

        EasyLoading.dismiss();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
        EasyLoading.dismiss();
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
      EasyLoading.dismiss();
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
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
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
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[
          0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   // If the conditions are met, set the flag and save the data
          //   print("Data is valid, proceeding to save.");
          // } else {
          //   // If any condition is not met, print a message
          //   print("Data is incomplete. Cannot proceed to save.");
          // }
        }
      } else {

        // Handle API error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Exception handling
      print("Exception: $e");
    }
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );

        debugPrint("GetStockTransferDtls" +
            '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data
                .map((json) => GetStockTransferListModel.fromJson(json))
                .toList();
            bool hasZeroStkTrans = false;
            for (int i = 0; i < _stockTransferList.length; i++) {
              if (_stockTransferList[i].isStkTrans == 0) {
                hasZeroStkTrans = true;
                debugPrint("Found item with isStkTrans = 0");
                break; // No need to continue checking once we find an item with isStkTrans = 0
              }
            }
            if (hasZeroStkTrans) {
              stockTransferFlag = false; // Disable the button
              // showFlushBar(
              //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
            } else {
              stockTransferFlag = true; // Enable the button
            }
          });

        } else {
          setState(() {

            showFlushBar(context, Constants.listGettingFail);
          });
        }
      } catch (e) {
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {

      showFlushBar(context, Constants.connectionMessage);
    }
  }
}
