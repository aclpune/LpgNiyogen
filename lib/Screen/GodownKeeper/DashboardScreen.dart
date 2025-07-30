import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../ConstantScreen/widgets.dart';
import '../DashboardModel/PhysicalStockImbalanceDataModel.dart';
import '../DashboardModel/TodaysOpeningStockDataModel.dart';
import '../User/Login/provider/LoginProvider.dart';
import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeAlertDialog.dart';
import '../Utils/CustomeDrawer.dart';
import '../Utils/Styling.dart';
import '../Utils/UpdateService.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';
import 'DelBoyStockReturn/StockTransferToGodownScreen.dart';
import 'DeliveryBoyModel/GetStockTransferListModel.dart';
import 'DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'package:http/http.dart' as http;

import 'ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';

class DashboardScreen extends StatefulWidget {
  static const screenName = '/godownDashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UpdateRefillSale? updateRefillSale;
  bool isPhysicalStockListViewVisible = false;
  bool isDomesticListViewVisible = false;
  bool isNonDomesticListViewVisible = false;
  bool isTodayOpeningStockListViewVisible = false;
  bool isCurrentStockListViewVisible = false;
  List<PhysicalStockImbalanceDataModel> receiptList = [];
  List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  List<GetStockTransferListModel> _stockTransferList = [];
  bool isLoading = true;
  String? mobileNo;
  String? userName,role,distributorName,roleId;
  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    }else{
      debugPrint("Firebase not initialize");
    }
    updateRefillSale = UpdateRefillSale();
    // Call the insert method when the screen is loaded
    insertDelBoyStockList();
    _fetchImbalanceData();
    _fetchTodaysOpeningStockData();
    fetchCurrentStock();
    checkAndSaveDayEndData();
    fetchTransactionList();
    fetchSavedData();
  }
  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    insertDelBoyStockList();
    _fetchImbalanceData();
    _fetchTodaysOpeningStockData();
    fetchCurrentStock();
    checkAndSaveDayEndData();// Fetch the data again
    fetchTransactionList();
  }
  bool saveFlag = false;
  bool stockTransferFlag = false;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        key: _scaffoldKey,
        body:
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  // Ensures the content is scrollable
                  child:
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isTodayOpeningStockListViewVisible =
                                  !isTodayOpeningStockListViewVisible; // Toggle ListView visibility
                                });
                              },
                              child:
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [

                                            bodyTitleBlue("View Today's Opening Stock"),
                                            Icon(
                                              isTodayOpeningStockListViewVisible
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              size: 30, // Bigger icon for a more clickable feel
                                              color:Color(0xff1280b3),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                        isTodayOpeningStockListViewVisible,
                                        child:Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Filled',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14
                                                            ,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Empty',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Defective',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              todaysOpeningStock.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: todaysOpeningStock.length,
                                                itemBuilder: (context, index) {
                                                  final items = todaysOpeningStock[index];

                                                  return
                                                    Card(
                                                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                      elevation: 4,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child:
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.itemName.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.filledOpeningStk.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.emptyOpeningStk.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.defOpeningStk.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                },
                                              ):
                                              Container(
                                                child: Text("No Data Available"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPhysicalStockListViewVisible =
                                      !isPhysicalStockListViewVisible; // Toggle ListView visibility
                                });
                              },
                              child:
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            bodyTitleBlue("Physical Stock Imbalance As Of Today"),


                                            Icon(
                                              isPhysicalStockListViewVisible
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              size: 30, // Bigger icon for a more clickable feel
                                              color: Color(0xff1280b3),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Visibility(
                                        visible: isPhysicalStockListViewVisible,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              // Header Row for Cylinder Categories
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10),
                                                child:
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Cylinder',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    VerticalDivider(thickness: 1, color: Colors.grey),
                                                    Expanded(
                                                      child: Text(
                                                        'Imbalance Qty',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // List of Cylinder Categories
                                              receiptList.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: receiptList.length,
                                                itemBuilder: (context, index) {
                                                  final item = receiptList[index];
                                                  return Card(
                                                    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                    elevation: 4,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          // Cylinder Category Text
                                                          Expanded(
                                                            child: Text(
                                                          item.itemName ?? "Unknown",
                                                              style:Styling.textFormText,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          // Divider between Texts
                                                          VerticalDivider(thickness: 1, color: Colors.grey),
                                                          // Imbalance Quantity with Tap Gesture
                                                          Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                // Handle the tap on the 'emptyCount' text
                                                                setState(() {
                                                                  // Perform any action when clicked
                                                                });
                                                              },
                                                              child: Text(
                                                                '${item.imbalanceStk ?? 0}',
                                                                textAlign: TextAlign.center,
                                                                style:Styling.textFormText
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ):
                                                  Container(
                                                    child: Text("No Data Available"),
                                                  )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCurrentStockListViewVisible =
                                  !isCurrentStockListViewVisible; // Toggle ListView visibility
                                });
                              },
                              child:
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   "View Today's Opening Stock",
                                            //   style: TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.black,
                                            //       fontWeight: FontWeight.bold),
                                            // ),
                                            bodyTitleBlue("View Current Stock"),
                                            Icon(
                                              isCurrentStockListViewVisible
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              size: 30, // Bigger icon for a more clickable feel
                                              color:Color(0xff1280b3),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                        isCurrentStockListViewVisible,
                                        child:
                                        Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Filled',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14
                                                            ,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Empty',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          'Defective',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:1,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              getCurrentStcOfGodownKeeper.isNotEmpty?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: getCurrentStcOfGodownKeeper.length,
                                                itemBuilder: (context, index) {
                                                  final items = getCurrentStcOfGodownKeeper[index];

                                                  return
                                                    Card(
                                                      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                                                      elevation: 4,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child:
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.itemName.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.currentStkFilled.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.currentStkEmpty.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: Text(
                                                                    items.currentStkDefective.toString(),
                                                                    style:Styling.textFormText,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      if(saveFlag){
                                                                        showFlushBar(context,
                                                                            Constants.dayEndCompleted);
                                                                      }else{
                                                                        // if(stockTransferFlag){
                                                                          Navigator.pushNamed(
                                                                              context,
                                                                              StockTransferTOGodownScreen
                                                                                  .screenName,
                                                                              arguments: {
                                                                                "itemName": items.itemName,
                                                                                "itemID" : items.itemId,
                                                                                "filledStock" :items.currentStkFilled,
                                                                                "emptyStock" :items.currentStkEmpty,
                                                                                "defectiveStock" :items.currentStkDefective,
                                                                              });
                                                                        // }else{
                                                                        //   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                                                                        // }

                                                                      }

                                                                    },
                                                                    child: Text(
                                                                      "Transfer",
                                                                      style:saveFlag? Styling.blueClrTextWithUnderlineGrey:Styling.blueClrTextWithUnderline,
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                },
                                              ):
                                              Container(
                                                child: Text("No Data Available"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(50), // Adjust the radius as needed
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Refresh"),
                  content: Text("Do You Want To Refresh Data?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog without action
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        setState(() {
                          // Refresh the data by reassigning the future
                          // stockDataFuture = updateRefillSale!.getDataFromDatabase();
                          _onRefresh();
                        });
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },

          child: Icon(Icons.refresh, color: Colors.white),
        ),
      );
  }

  Future<void> insertDelBoyStockList() async {
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
          // You can also update the state here if you need to trigger UI changes
          setState(() {
            updateRefillSale?.insertDataToDatabase(result, "Pending", "Edit");
            //Update the UI with the result data if necessary
          });
        } else {
          refreshTokens();
          debugPrint("Failed to fetch data from API: ${response.statusCode}");
        }
      } catch (e) {
        refreshTokens();
        debugPrint("Error during API call: $e");
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  Future<void> _fetchImbalanceData() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);
      int godownIdId = int.parse(godownId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ImbalanceAsOfDateStkForGK}/$dId/$godownIdId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );
        print("Total ImbQty ImbalanceAsOfDateStkForGK response ${response.body}");
        print("Total ImbQty ImbalanceAsOfDateStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptList = data.map((json) => PhysicalStockImbalanceDataModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();
            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            refreshTokens();
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Constants.listGettingFail)),
        );
      }
    } else {
      refreshTokens();
      EasyLoading.dismiss();
      showFlushBar(context,Constants.connectionMessage);
    }
  }

  Future<void> _fetchTodaysOpeningStockData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);
      int godownIdId = int.parse(godownId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$godownIdId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );
        print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
        print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            todaysOpeningStock = data.map((json) => TodaysOpeningStockDataModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();
            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
            refreshTokens();
          });
          showFlushBar(context,
              Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
    showFlushBar(context,
        Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> fetchCurrentStock() async {
    EasyLoading.show(status: 'Loading..');
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();

          });
        } else {
          // Handle non-200 responses

          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
            refreshTokens();
          });
          showFlushBar(context,
              Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        showFlushBar(context,
            Constants.listGettingFail);
      }
    }else{
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try{


      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );


      debugPrint(
          "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
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
        isLoading = false;
      } else {
        setState(() {
          refreshTokens();
          isLoading = false;
          showFlushBar(context,
              Constants.listGettingFail);
        });
      }
      }catch(e){
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {
      refreshTokens();
      isLoading = false;
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      String roles = preferences.getString("RoleName").toString();
      distributorName = preferences.getString("IsAlreadyLogin").toString();
      String isAlreadyLogin = preferences.getString("IsAlreadyLogin").toString();
      debugPrint("User Name:- $userName");
      if(isAlreadyLogin == "0" || isAlreadyLogin == null || isAlreadyLogin == "null" || isAlreadyLogin.isEmpty){
        _showLogoutDialog(context);
      }else{

      }
    } catch (error) {
      rethrow;
    }
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
            _fetchImbalanceData();
            _fetchTodaysOpeningStockData();
            fetchCurrentStock();
            checkAndSaveDayEndData();
            fetchTransactionList();
          } else if (response['message'] == "Token Expired") {
            debugPrint('RefreshTokenExc401 - true');
            showDialogToExpireSession(context);
          } else{
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
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

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
        refreshTokens();
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      refreshTokens();
      // Exception handling
      print("Exception: $e");
    }
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text(" Please log in to the application again."),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for confirming logout
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call logout function here
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
