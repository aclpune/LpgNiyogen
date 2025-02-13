import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Widget.dart';
import 'package:http/http.dart' as http;

import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import 'StockReturnFromDelBoy.dart';

class StockTransferTOGodownScreenItemUI extends StatefulWidget {
  GetStockTransferListModel _listModel;


  StockTransferTOGodownScreenItemUI(this._listModel,{Key? key}) : super(key: key);
  // StockTransferTOGodownScreenItemUI({Key? key}) : super(key: key);

  @override
  State<StockTransferTOGodownScreenItemUI> createState() => _StockTransferTOGodownScreenItemUIState();
}

class _StockTransferTOGodownScreenItemUIState extends State<StockTransferTOGodownScreenItemUI> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool isLoading = true;
  List<GetStockTransferListModel> _stockTransferList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for SharedPreferences
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Get the stored godownId from SharedPreferences
          String? godownId = snapshot.data?.getString('godownId');

          // Check the conditions to hide the "Accept" button
          bool hideAcceptButton = (value.fromGodownId == int.parse(godownId ?? '0')) || value.isStkTrans == 1;

          return Card(
            elevation: 5,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 12),
              child: Column(
                children: [
                  // Date and Weight Row with icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${value.itemName ?? ''}', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1280b3),
                              fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(value.stkTransDate ?? '')),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1280b3),
                                  fontFamily: 'OpenSans')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Data values Row with icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Fill: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.filledStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Empty: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.emptyStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Defective: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.defectiveStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  // Hide the "Accept" button based on conditions
                  if (!hideAcceptButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Add your action here
                            int tGID = (value.toGodownId ?? 0).toInt();
                            int fGID = (value.fromGodownId ?? 0).toInt();
                            int fillQ = (value.filledStk ?? 0).toInt();
                            int emptyQ = (value.emptyStk ?? 0).toInt();
                            int defQ = (value.defectiveStk ?? 0).toInt();
                            int itemIDs = (value.itemId ?? 0).toInt();
                            String remark = value.remark ?? '';
                            submitStockToApi(tGID,fGID,itemIDs,fillQ,emptyQ,defQ,remark);
                          },
                          child: Text(
                            "Accept",
                            style: Styling.blueClrTextWithUnderline,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
  }

  Future<void> submitStockToApi(int toGodownId,int fromGodownId,int itemIds,int fillC,int emptyC,int defC,String remarks) async {
    // Construct the request payload
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token

    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    Map<String, dynamic> requestBody = {
      "DistributorId": dId,
      "FromGodownId": fromGodownId,
      "StkTransDate": formattedDate,
      "ToGodownId": toGodownId ?? 0,
      "ItemId": itemIds,
      "FilledStk": fillC,
      "EmptyStk": emptyC,
      "DefectiveStk": defC,
      "IsStkTrans": 1,
      "Remark": remarks ?? '',
      "AddedBy": addedBy
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.SaveGodownStockTransferDtls}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code SaveGodownStockTransferDtls: ${response.statusCode}");
      print("API Response Body SaveGodownStockTransferDtls: ${response.body}");
      print("API Response request SaveGodownStockTransferDtls: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        Navigator.pushReplacementNamed(context, '/godownDashboard');
        print("SaveGodownStockTransferDtls quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..", duration: const Duration(milliseconds: 3000));
        fetchTransactionList();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
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
          _stockTransferList =
              data.map((json) => GetStockTransferListModel.fromJson(json)).toList();

        });
        isLoading = false;
      } else {

        isLoading = false;
        throw Exception('Failed To Load Items');
      }
    } else {
      isLoading = false;
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }
}
