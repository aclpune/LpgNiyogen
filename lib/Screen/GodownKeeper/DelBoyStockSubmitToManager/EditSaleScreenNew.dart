import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'package:http/http.dart' as http;
class EditSaleScreenNew extends StatefulWidget {
  final StockSubmitToManagerListModel sale;
  final num? saleGKId;
  final num? dMId;

  const EditSaleScreenNew({required this.sale, required this.saleGKId, required this.dMId});

  @override
  _EditSaleScreenNewState createState() => _EditSaleScreenNewState();
}

class _EditSaleScreenNewState extends State<EditSaleScreenNew> {
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  UpdateRefillSale? updateRefillSale;
  // List of controllers for the editable fields
  List<TextEditingController> filledSaleQtyControllers = [];
  List<TextEditingController> sVQtyControllers = [];
  List<TextEditingController> tVQtyControllers = [];
  List<TextEditingController> emptyRetQtyControllers = [];
  List<TextEditingController> deffQtyControllers = [];
  List<TextEditingController> lessEmptyQtyControllers = [];

  @override
  void initState() {
    super.initState();
    debugPrint("${widget.saleGKId}");
    updateRefillSale = UpdateRefillSale();
    stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
        widget.saleGKId?.toInt() ?? 0,
        widget.dMId?.toInt() ?? 0
    );
    debugPrint("stockDataFuture${stockDataFuture}");
    // Initialize controllers based on the sale's item list
    for (var item in widget.sale.itemList!) {
      filledSaleQtyControllers.add(TextEditingController(text: item.filledSaleQty.toString()));
      sVQtyControllers.add(TextEditingController(text: item.sVQty.toString()));
      tVQtyControllers.add(TextEditingController(text: item.tVQty.toString()));
      emptyRetQtyControllers.add(TextEditingController(text: item.emptyRetQty.toString()));
      deffQtyControllers.add(TextEditingController(text: item.deffQty.toString()));
      lessEmptyQtyControllers.add(TextEditingController(text: item.lessEmptyQty.toString()));
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    for (var controller in filledSaleQtyControllers) controller.dispose();
    for (var controller in sVQtyControllers) controller.dispose();
    for (var controller in tVQtyControllers) controller.dispose();
    for (var controller in emptyRetQtyControllers) controller.dispose();
    for (var controller in deffQtyControllers) controller.dispose();
    for (var controller in lessEmptyQtyControllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Sale Data")),
      body: FutureBuilder<List<StockSubmitToManagerListModel>>(
        future: stockDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<StockSubmitToManagerListModel> stockDataList = snapshot.data!;

            return
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // ListView.builder for displaying the stock data
                    Expanded(
                      child: ListView.builder(
                        itemCount: stockDataList.length,
                        itemBuilder: (context, index) {
                          StockSubmitToManagerListModel stock = stockDataList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sale Data ${index + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: stock.vehicleNo ?? ''),
                                decoration: InputDecoration(
                                    labelText: "Vehicle No"),
                                readOnly: false, // Made editable
                              ),
                              SizedBox(height: 20),

                              Text("Items for Sale Data ${index + 1}:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: stock.itemList?.length ?? 0,
                                  itemBuilder: (context, itemIndex) {
                                    var item = stock.itemList![itemIndex];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: TextEditingController(
                                                    text: item.itemName),
                                                decoration: InputDecoration(
                                                    labelText: "Item Name ${itemIndex +
                                                        1}"),
                                                enabled: false, // Made editable
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: filledSaleQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "Filled Sale Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: sVQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "SV Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: tVQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "TV Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: emptyRetQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "Empty Ret Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: deffQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "Deff Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: lessEmptyQtyControllers[itemIndex],
                                                // Editable controller
                                                decoration: InputDecoration(
                                                    labelText: "Less Empty Qty ${itemIndex +
                                                        1}"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Divider(color: Colors.grey, thickness: 1),
                              SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                    // The Evaluate Button at the bottom of the ListView
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Action to take when Submit button is pressed
                          sendDataToAPI(context);
                          // Call your API sending function here, passing updated values from controllers
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );

          } else {
            return Center(child: Text("No data available."));
          }
        },
      ),
    );
  }

  void sendDataToAPI(BuildContext context) async {
    // Get the shared preferences for required values
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? addedBy = prefs.getString('StaffId');
      String? godownID = prefs.getString('godownId');

      // Prepare your item list data from the sale object
      List<Map<String, dynamic>> itemList = [];

      // Assuming sale is passed via widget or retrieved from state
      for (int i = 0; i < widget.sale.itemList!.length; i++) {
        var item = widget.sale.itemList![i];

        // Retrieve the quantities from controllers, ensuring they are integers or defaults to 0
        int filledSaleQty = int.tryParse(filledSaleQtyControllers[i].text) ?? 0;
        int sVQty = int.tryParse(sVQtyControllers[i].text) ?? 0;
        int tVQty = int.tryParse(tVQtyControllers[i].text) ?? 0;
        int emptyRetQty = int.tryParse(emptyRetQtyControllers[i].text) ?? 0;
        int deffQty = int.tryParse(deffQtyControllers[i].text) ?? 0;
        int lessEmptyQty = int.tryParse(lessEmptyQtyControllers[i].text) ?? 0;
        int closingFilled = int.tryParse(item.closingFilled.toString()) ?? 0;
        int closingEmpty = int.tryParse(item.closingEmpty.toString()) ?? 0;
        int closingDef = int.tryParse(item.closingDef.toString()) ?? 0;
        int sVConsStr = int.tryParse(item.sVConsStr.toString()) ?? 0;
        String remarks = item.remark ?? '';

        // Prepare item data with updated values from controllers
        itemList.add({
          "SaleGKItemId": item.SaleGKItemId,
          "ItemId": item.itemId,
          "FilledSaleQty": filledSaleQty,
          "SVQty": sVQty,
          "TVQty": tVQty,
          "EmptyRetQty": emptyRetQty,
          "DeffQty": deffQty,
          "LessEmptyQty": lessEmptyQty,
          "Remark": remarks,  // Adjust logic if needed
          "ClosingFilled": closingFilled,
          "ClosingEmpty": closingEmpty,
          "ClosingDef": closingDef,
          "SVConsStr": sVConsStr,  // Adjust according to actual requirements
        });
      }

      // Prepare the main data to send to the API
      Map<String, dynamic> apiData = {
        "SaleGKId": widget.sale.saleGKId,
        "DistributorId": distributorId ?? '',
        "GodownId" : godownID,
        "DeliveryDate": widget.sale.deliveryDate ?? '',
        "DMId": widget.sale.dMId ?? '',
        "VehicleId": widget.sale.vehicleId ?? '',
        "AddedBy": addedBy ?? '',
        "Action": "EDIT",
        "ItemList": itemList,
      };

      // Convert data to JSON format
      String jsonRequestBody = jsonEncode(apiData);
      print("Request Body: $jsonRequestBody");
      print("Item List: $itemList");

      // Send the API request
      final response = await http.post(
        Uri.parse('${AppUrl.UpdateDailyRefillSale}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonRequestBody,
      );

      // Debugging output
      print("Response: ${response.body}");

      // Check if the response was successful
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send data!')),
        );
      }
    }else{
      showFlushBar(context,Constants.connectionTitle,
          Constants.connectionMessage);
    }
  }
}



