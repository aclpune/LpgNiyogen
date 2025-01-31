import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'package:http/http.dart' as http;

import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'StockSubmitToManager.dart';
class EditSaleLocalDatabase extends StatefulWidget {
  final StockSubmitToManagerListModel sale;
  final num? saleGKId;
  final num? dMId;
  final String flagAdd;

  const EditSaleLocalDatabase({required this.sale, required this.saleGKId, required this.dMId,required this.flagAdd});

  @override
  _EditSaleLocalDatabaseState createState() => _EditSaleLocalDatabaseState();
}

class _EditSaleLocalDatabaseState extends State<EditSaleLocalDatabase> {
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  UpdateRefillSale? updateRefillSale;
  // List of controllers for the editable fields
  List<TextEditingController> filledSaleQtyControllers = [];
  List<TextEditingController> sVQtyControllers = [];
  List<TextEditingController> tVQtyControllers = [];
  List<TextEditingController> emptyRetQtyControllers = [];
  List<TextEditingController> deffQtyControllers = [];
  List<TextEditingController> lessEmptyQtyControllers = [];
  List<CylItemListModel> _items = [];
  // String? _selectedItem;
  int? selectedItemId;
  CylItemListModel? _selectedItem;
  @override
  void initState() {
    super.initState();
    debugPrint("${widget.saleGKId}");
    fetchItems();
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

  // Variables for editing the item
  String? selectedItem;
  String? selectedItemName;
  TextEditingController filledSaleQtyController = TextEditingController();
  TextEditingController sVQtyController = TextEditingController();
  TextEditingController tVQtyController = TextEditingController();
  TextEditingController emptyRetQtyController = TextEditingController();
  TextEditingController deffQtyController = TextEditingController();
  TextEditingController lessEmptyQtyController = TextEditingController();
  void _onEditItem(ItemList item) {
    // Populate the fields with the current item data
    setState(() {
      selectedItem = item.itemId.toString();
      selectedItemName =  item.itemName.toString();
      filledSaleQtyController.text = item.filledSaleQty.toString();
      sVQtyController.text = item.sVQty.toString();
      tVQtyController.text = item.tVQty.toString();
      emptyRetQtyController.text = item.emptyRetQty.toString();
      deffQtyController.text = item.deffQty.toString();
      lessEmptyQtyController.text = item.lessEmptyQty.toString();
      setState(() {
        selectedItem = item.itemId.toString();
      });
    });
  }
  void _onDeleteItem(int selectedItems) async {
    // Populate the fields with the current item data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    await updateRefillSale!.deleteItemFromDatabase(
    itemId: selectedItems,
    saleGKId: widget.saleGKId?.toInt() ?? 0,
    distributorId: int.parse(distributorId!),
    );
    // Update state after async operation
    setState(() {
      stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
        widget.saleGKId?.toInt() ?? 0,
        widget.dMId?.toInt() ?? 0,
      );
    });
  }

  void _updateItem() async {
    // Perform asynchronous operations
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');

    // Debug prints
    print("Item updated: $selectedItem");
    print("Item selectedItemName: $selectedItemName");
    print("Filled Sale Qty: ${filledSaleQtyController.text}");
    print("SV Qty: ${sVQtyController.text}");
    print("TV Qty: ${tVQtyController.text}");
    print("Empty Ret Qty: ${emptyRetQtyController.text}");
    print("Def Qty: ${deffQtyController.text}");
    print("Less Empty Qty: ${lessEmptyQtyController.text}");

    await updateRefillSale!.updateItemInDatabase(
      itemId: int.parse(selectedItem!),
      saleGKId: widget.saleGKId?.toInt() ?? 0,
      distributorId: int.parse(distributorId!),
      itemName: selectedItemName.toString(),
      filled: int.parse(filledSaleQtyController.text),
      sv: int.parse(sVQtyController.text),
      tv: int.parse(tVQtyController.text),
      wmpty: int.parse(emptyRetQtyController.text),
      defective: int.parse(deffQtyController.text),
      lessEmpty: int.parse(lessEmptyQtyController.text),
      remark:"",
      svList:"",
    );

    // Update state after async operation
    setState(() {
      stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
        widget.saleGKId?.toInt() ?? 0,
        widget.dMId?.toInt() ?? 0,
      );
    });
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
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          // Show a confirmation dialog
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(
                context, StockSubmitToManager.screenName,
                arguments: "onBack");
            return false;
          } else {
            Navigator.pushReplacementNamed(
                context, StockSubmitToManager.screenName);
            return false;
          } // In case `null` is returned, return `false`
        },
        child: Scaffold(
          appBar: AppBar(
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
                      Navigator.pushReplacementNamed(context, '/stockSubmitToManager');
                    },
                  ),
                  // Text Field
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Edit Sale Data", // You can pass dynamic title here
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<StockSubmitToManagerListModel>>(
                  future: stockDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      List<StockSubmitToManagerListModel> stockDataList = snapshot.data!;

                      return
                        SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(width: 0.5)),
                            child:
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 250, // Set a reasonable height
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey, width: 1), // Border around dropdown
                                            borderRadius: BorderRadius.circular(8), // Rounded corners (optional)
                                          ),
                                          child: DropdownButton<String>(
                                            value: selectedItem,
                                            hint: Text('Select Item', style: TextStyle(color: Colors.grey)), // Placeholder text
                                            onChanged: (String? newValue) {
                                              final selectedItemData = stockDataList
                                                  .expand((stock) => stock.itemList!)
                                                  .firstWhere((item) => item.itemId.toString() == newValue);

                                              if (selectedItemData != null) {
                                                _onEditItem(selectedItemData);
                                              }
                                            },
                                            items: stockDataList
                                                .expand((stock) => stock.itemList!)
                                                .toSet() // Remove duplicates
                                                .map((item) => DropdownMenuItem<String>(
                                              value: item.itemId.toString(),
                                              child: Text(item.itemName ?? 'Unnamed Item'),
                                            ))
                                                .toList(),
                                          ),
                                        ),
                                      ),


                                      Row(
                                        children: [
                                          Expanded(
                                            flex:1,
                                            child: TextField(
                                              controller: filledSaleQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'Filled Sale Qty'),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: sVQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'SV Qty'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // TextField(
                                      //   controller: sVQtyController,
                                      //   keyboardType: TextInputType.number,
                                      //   decoration: InputDecoration(labelText: 'SV Qty'),
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: tVQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'TV Qty'),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: emptyRetQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'Empty Ret Qty'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: deffQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'Def Qty'),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: lessEmptyQtyController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(labelText: 'Less Empty Qty'),
                                            ),
                                          ),
                                        ],
                                      ),
                                        SizedBox(height: 20,),
                                      ElevatedButton(
                                        onPressed: _updateItem,
                                        child: Text("Update",style: TextStyle(color: Colors.white),),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(double.minPositive, 40),
                                          backgroundColor: Colors.blue,// Button expands to fill available width// Text color of the button
                                          shape: RoundedRectangleBorder( // Optional: Set rounded corners
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Editable fields for selected item
                                // if (selectedItem != null)
                                // Header Row with equal width for all columns using Expanded
                                  Row(
                                    children: [
                                      Expanded(child: Center(child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("Filled", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("SV", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("TV", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("Emp", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("Def.", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("<Emp", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                      VerticalDivider(),
                                      Expanded(child: Center(child: Text("", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)))),
                                    ],
                                  ),
                                // Divider between header and data rows
                                Container(
                                  color: const Color(0xff1280B3),
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                // ListView to display the data
                                stockDataList.isNotEmpty
                                    ?
                                ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: stockDataList.length,
                                  itemBuilder: (context, stockIndex) {
                                    StockSubmitToManagerListModel stock = stockDataList[stockIndex];
                                    return
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: Text(
                                          //     'Vehicle ID: ${stock.vehicleId ?? 'N/A'}',
                                          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          //   ),
                                          // ),
                                          ...stock.itemList!.map((item) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Item Name
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0),
                                                      child: Text(
                                                        item.itemName ?? 'N/A',
                                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // Filled Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.filledSaleQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // SV Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.sVQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // TV Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.tVQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // Empty Ret Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.emptyRetQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // Def Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.deffQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  VerticalDivider(),
                                                  // Less Empty Quantity
                                                  Expanded(
                                                    child: Text(
                                                      item.lessEmptyQty.toString(),
                                                      style: TextStyle(fontSize: 14, color: Colors.black54),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _onEditItem(item);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _onDeleteItem(int.parse(item.itemId.toString()));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          Divider(color: Colors.black12),
                                        ],
                                      );
                                  },
                                )
                                    : Container(
                                  padding: EdgeInsets.all(5),
                                  child: const Center(child: Text("No pending data..!")),
                                ),
                              ],
                            ),
                          ),
                        );
                    } else {
                      return Center(child: Text("No data available."));
                    }
                  },
                ),
                ElevatedButton(
                  onPressed:(){
                    sendDataToApi(context);
                  },
                  child: const Text(
                    'Submit To Manager',
                    style: TextStyle(color: Colors.white,fontSize: 14), // Set text color directly if needed
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.blue,// Button expands to fill available width// Text color of the button
                    shape: RoundedRectangleBorder( // Optional: Set rounded corners
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
  //
  // void sendDataToAPI(BuildContext context) async {
  //   // Get the shared preferences for required values
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? addedBy = prefs.getString('StaffId');
  //
  //   // Prepare your item list data from the sale object
  //   List<Map<String, dynamic>> itemList = [];
  //
  //   // Assuming sale is passed via widget or retrieved from state
  //   for (int i = 0; i < widget.sale.itemList!.length; i++) {
  //     var item = widget.sale.itemList![i];
  //
  //     // Retrieve the quantities from controllers, ensuring they are integers or defaults to 0
  //     int filledSaleQty = int.tryParse(filledSaleQtyControllers[i].text) ?? 0;
  //     int sVQty = int.tryParse(sVQtyControllers[i].text) ?? 0;
  //     int tVQty = int.tryParse(tVQtyControllers[i].text) ?? 0;
  //     int emptyRetQty = int.tryParse(emptyRetQtyControllers[i].text) ?? 0;
  //     int deffQty = int.tryParse(deffQtyControllers[i].text) ?? 0;
  //     int lessEmptyQty = int.tryParse(lessEmptyQtyControllers[i].text) ?? 0;
  //     int closingFilled = int.tryParse(item.closingFilled.toString()) ?? 0;
  //     int closingEmpty = int.tryParse(item.closingEmpty.toString()) ?? 0;
  //     int closingDef = int.tryParse(item.closingDef.toString()) ?? 0;
  //     int sVConsStr = int.tryParse(item.sVConsStr.toString()) ?? 0;
  //     String remarks = item.remark ?? '';
  //
  //     // Prepare item data with updated values from controllers
  //     itemList.add({
  //       "SaleGKItemId": item.SaleGKItemId,
  //       "ItemId": item.itemId,
  //       "FilledSaleQty": filledSaleQty,
  //       "SVQty": sVQty,
  //       "TVQty": tVQty,
  //       "EmptyRetQty": emptyRetQty,
  //       "DeffQty": deffQty,
  //       "LessEmptyQty": lessEmptyQty,
  //       "Remark": remarks,  // Adjust logic if needed
  //       "ClosingFilled": closingFilled,
  //       "ClosingEmpty": closingEmpty,
  //       "ClosingDef": closingDef,
  //       "SVConsStr": sVConsStr,  // Adjust according to actual requirements
  //     });
  //   }
  //
  //   // Prepare the main data to send to the API
  //   Map<String, dynamic> apiData = {
  //     "SaleGKId": widget.sale.saleGKId,
  //     "DistributorId": distributorId ?? '',
  //     "DeliveryDate": widget.sale.deliveryDate ?? '',
  //     "DMId": widget.sale.dMId ?? '',
  //     "VehicleId": widget.sale.vehicleNo ?? '',
  //     "AddedBy": addedBy ?? '',
  //     "Action": "EDIT",
  //     "ItemList": itemList,
  //   };
  //
  //   // Convert data to JSON format
  //   String jsonRequestBody = jsonEncode(apiData);
  //   print("Request Body: $jsonRequestBody");
  //   print("Item List: $itemList");
  //
  //   // Send the API request
  //   final response = await http.post(
  //     Uri.parse('${AppUrl.UpdateDailyRefillSale}'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $bearerToken',
  //     },
  //     body: jsonRequestBody,
  //   );
  //
  //   // Debugging output
  //   print("Response: ${response.body}");
  //
  //   // Check if the response was successful
  //   if (response.statusCode == 200) {
  //     Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Data sent successfully!')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to send data!')),
  //     );
  //   }
  // }

  void sendDataToApi(BuildContext context) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId') ?? '0';
        String? bearerToken = prefs.getString('token');
        String? addedBy = prefs.getString('StaffId');
        String? godownID = prefs.getString('godownId');

        if (bearerToken == null) {
          print('Bearer token is missing');
          return;
        }

        // Fetch data
        List<StockSubmitToManagerListModel> deliveryData =
        await updateRefillSale!.getDeliveryMenDataForEdit(
            widget.saleGKId?.toInt() ?? 0, widget.dMId?.toInt() ?? 0);
        print('No data found for delivery ${deliveryData}');
        if (deliveryData.isEmpty) {
          print('No data found for delivery');
          return;
        }

        // Convert delivery data into API format
        List<Map<String, dynamic>> apiItemList = [];
        for (var data in deliveryData) {
          if (data.itemList != null) {
            for (var item in data.itemList!) {
              apiItemList.add({
                "SaleGKItemId": item.SaleGKItemId,
                "ItemId": item.itemId,
                "FilledSaleQty":  item.filledSaleQty.toString(),
                "SVQty": item.sVQty.toString(),
                "TVQty": item.tVQty.toString(),
                "EmptyRetQty": item.emptyRetQty.toString(),
                "DeffQty": item.deffQty.toString(),
                "LessEmptyQty": item.lessEmptyQty.toString(),
                "Remark": item.remark ?? "",  // Adjust logic if needed
                "ClosingFilled": "",
                "ClosingEmpty": "",
                "ClosingDef": "",
                "SVConsStr":item.sVConsStr,
              });
            }
          }
        }

        if (apiItemList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No records available to send!')),
          );
          return;
        }

        // Construct API data
        Map<String, dynamic> apiData = {
          "SaleGKId": widget.saleGKId?.toString() ?? "0",
          "DistributorId": distributorId ?? '',
          "GodownId" : godownID,
          "DeliveryDate": widget.sale.deliveryDate ?? '',
          "DMId": widget.sale.dMId ?? '',
          "VehicleId": widget.sale.vehicleId ?? '',
          "AddedBy": addedBy ?? '',
          "Action": "EDIT",
          "ItemList": apiItemList,
        };
        print('jsonEncode(apiData): ${(apiData)}');
        // Send API request
        final response = await http.post(
          Uri.parse('${AppUrl.UpdateDailyRefillSale}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonEncode(apiData),
        );
        print('jsonEncode(apiData): ${jsonEncode(apiData)}');
        if (response.statusCode == 200) {
          print('Data sent successfully: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data sent successfully!')),
          );
          Navigator.pushReplacementNamed(context, '/godownDashboard');
        } else {
          print('Failed to send data: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        print('Error in sending data: $e');
      }
    }else{
      showFlushBar(context,Constants.connectionTitle,
          Constants.connectionMessage);
    }

  }


  // Future<void> sendDataToApi(BuildContext context) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId') ?? '0';
  //     String? bearerToken = prefs.getString('token');
  //     String? addedBy = prefs.getString('StaffId');
  //
  //     if (bearerToken == null) {
  //       print('Bearer token is missing');
  //       return;
  //     }
  //
  //     // Fetch data
  //     List<StockSubmitToManagerListModel> deliveryData =
  //     await updateRefillSale!.getDeliveryMenDataForEdit(
  //         widget.saleGKId?.toInt() ?? 0, widget.dMId?.toInt() ?? 0);
  //
  //     if (deliveryData.isEmpty) {
  //       print('No data found for delivery');
  //       return;
  //     }
  //
  //     // Convert delivery data into API format
  //     List<Map<String, dynamic>> apiItemList = [];
  //     for (var data in deliveryData) {
  //       if (data.itemList != null) {
  //         for (var item in data.itemList!) {
  //           apiItemList.add({
  //             "ItemId": item.itemId.toString(),
  //             "FilledSaleQty": item.filledSaleQty.toString(),
  //             "SVQty": item.sVQty.toString(),
  //             "TVQty": item.tVQty.toString(),
  //             "EmptyRetQty": item.emptyRetQty.toString(),
  //             "DeffQty": item.deffQty.toString(),
  //             "LessEmptyQty": item.lessEmptyQty.toString(),
  //             "Remark": item.remark ?? "",
  //           });
  //         }
  //       }
  //     }
  //
  //     if (apiItemList.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('No records available to send!')),
  //       );
  //       return;
  //     }
  //
  //     // Construct API data
  //     Map<String, dynamic> apiData = {
  //       "SaleGKId": widget.saleGKId?.toString() ?? "0",
  //       "DistributorId": distributorId,
  //       "DeliveryDate": delDate,
  //       "DMId": widget.dMId?.toString() ?? "0",
  //       "VehicleId": widget.vehicleId?.toString() ?? "",
  //       "AddedBy": addedBy,
  //       "Action": "ADD",
  //       "ItemList": apiItemList,
  //     };
  //
  //     // Send API request
  //     final response = await http.post(
  //       Uri.parse('${AppUrl.UpdateDailyRefillSale}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //       body: jsonEncode(apiData),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Data sent successfully: ${response.body}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Data sent successfully!')),
  //       );
  //     } else {
  //       print('Failed to send data: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to send data: ${response.reasonPhrase}')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error in sending data: $e');
  //   }
  // }

  // Fetch data from API Item
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetItemMasterList"+'${AppUrl.GetItemMasterList}/$distributorId/0/C');
    debugPrint("GetItemMasterList"+response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      // refreshTokens();
      throw Exception('Failed to load items');
    }
  }

}




