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
class EditSaleScreen extends StatefulWidget {
  final StockSubmitToManagerListModel sale; // The sale data passed to the screen
  final String saleGKId;
  const EditSaleScreen({required this.sale, required this.saleGKId});

  @override
  _EditSaleScreenState createState() => _EditSaleScreenState();
}

// class _EditSaleScreenState extends State<EditSaleScreen> {
//   // late TextEditingController saleGKIdController;
//   late TextEditingController distributorIdController;
//   late TextEditingController staffNameController;
//   late TextEditingController vehicleNoController;
//   late TextEditingController deliveryDateController;
//   late TextEditingController dMIdController;
//   late TextEditingController addedOnController;
//   late TextEditingController saleGKIdController;
//
//   // Controllers for the item fields (for each item in the list)
//   List<TextEditingController> itemNameControllers = [];
//   List<TextEditingController> filledSaleQtyControllers = [];
//   List<TextEditingController> sVQtyControllers = [];
//   List<TextEditingController> tVQtyControllers = [];
//   List<TextEditingController> emptyRetQtyControllers = [];
//   List<TextEditingController> deffQtyControllers = [];
//   List<TextEditingController> lessEmptyQtyControllers = [];
//   List<TextEditingController> closingFilledControllers = [];
//   List<TextEditingController> closingEmptyControllers = [];
//   List<TextEditingController> closingDefControllers = [];
//   List<TextEditingController> remarkControllers = [];
//   List<TextEditingController> dailySaleStatusControllers = [];
//   List<TextEditingController> svConsumerControllers = [];
//   UpdateRefillSale? updateRefillSale;
//   late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
//   @override
//   void initState() {
//     super.initState();
//     // Call the async method after initState has completed
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     // Fetch shared preferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String saleGKId = widget.saleGKId;
//
//     // Fetch the stock data
//     updateRefillSale = UpdateRefillSale();
//     // stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(saleGKId, distributorId.toString());
//     debugPrint("stockDataFuture: ${stockDataFuture.toString()}");
//
//     // Initialize controllers for sale data fields
//     saleGKIdController = TextEditingController(text: widget.sale.saleGKId.toString());
//     distributorIdController = TextEditingController(text: widget.sale.distributorId.toString());
//     staffNameController = TextEditingController(text: widget.sale.staffName);
//     vehicleNoController = TextEditingController(text: widget.sale.vehicleId.toString());
//     deliveryDateController = TextEditingController(text: widget.sale.deliveryDate);
//     dMIdController = TextEditingController(text: widget.sale.dMId.toString());
//     addedOnController = TextEditingController(text: widget.sale.addedOn);
//     dailySaleStatusControllers.add(TextEditingController(text: widget.sale.dailySaleStatus.toString()));
//
//     // Initialize controllers for item list fields (if exists)
//     for (var item in widget.sale.itemList ?? []) {
//       itemNameControllers.add(TextEditingController(text: item.itemName));
//       filledSaleQtyControllers.add(TextEditingController(text: item.filledSaleQty.toString()));
//       sVQtyControllers.add(TextEditingController(text: item.sVQty.toString()));
//       tVQtyControllers.add(TextEditingController(text: item.tVQty.toString()));
//       emptyRetQtyControllers.add(TextEditingController(text: item.emptyRetQty.toString()));
//       deffQtyControllers.add(TextEditingController(text: item.deffQty.toString()));
//       lessEmptyQtyControllers.add(TextEditingController(text: item.lessEmptyQty.toString()));
//       closingFilledControllers.add(TextEditingController(text: item.closingFilled.toString()));
//       closingEmptyControllers.add(TextEditingController(text: item.closingEmpty.toString()));
//       closingDefControllers.add(TextEditingController(text: item.closingDef.toString()));
//       remarkControllers.add(TextEditingController(text: item.remark.toString()));
//       svConsumerControllers.add(TextEditingController(text: item.sVConsStr.toString()));
//     }
//
//     // If you want to reload UI after async operation
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     // Dispose the controllers
//     saleGKIdController.dispose();
//     distributorIdController.dispose();
//     staffNameController.dispose();
//     vehicleNoController.dispose();
//     deliveryDateController.dispose();
//     dMIdController.dispose();
//     addedOnController.dispose();
//
//     for (var controller in itemNameControllers) controller.dispose();
//     for (var controller in filledSaleQtyControllers) controller.dispose();
//     for (var controller in sVQtyControllers) controller.dispose();
//     for (var controller in tVQtyControllers) controller.dispose();
//     for (var controller in emptyRetQtyControllers) controller.dispose();
//     for (var controller in deffQtyControllers) controller.dispose();
//     for (var controller in lessEmptyQtyControllers) controller.dispose();
//     for (var controller in closingFilledControllers) controller.dispose();
//     for (var controller in closingEmptyControllers) controller.dispose();
//     for (var controller in closingDefControllers) controller.dispose();
//     for (var controller in remarkControllers) controller.dispose();
//     for (var controller in svConsumerControllers) controller.dispose();
//
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Sale Data")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Sale data fields
//               TextField(
//                 controller: saleGKIdController,
//                 decoration: InputDecoration(labelText: "Sale GK ID"),
//               ),
//               TextField(
//                 controller: distributorIdController,
//                 decoration: InputDecoration(labelText: "Distributor ID"),
//               ),
//               TextField(
//                 controller: staffNameController,
//                 decoration: InputDecoration(labelText: "Staff Name"),
//               ),
//               TextField(
//                 controller: vehicleNoController,
//                 decoration: InputDecoration(labelText: "Vehicle ID"),
//               ),
//               TextField(
//                 controller: deliveryDateController,
//                 decoration: InputDecoration(labelText: "Delivery Date"),
//               ),
//               TextField(
//                 controller: dMIdController,
//                 decoration: InputDecoration(labelText: "DMID"),
//               ),
//               TextField(
//                 controller: addedOnController,
//                 decoration: InputDecoration(labelText: "Added On"),
//               ),
//               SizedBox(height: 20),
//
//               // Item fields
//               Text("Items:"),
//               for (int i = 0; i < widget.sale.itemList!.length; i++) ...[
//                 TextField(
//                   controller: itemNameControllers[i],
//                   decoration: InputDecoration(labelText: "Item Name ${i + 1}"),
//                 ),
//                 TextField(
//                   controller: filledSaleQtyControllers[i],
//                   decoration: InputDecoration(labelText: "Filled Sale Qty ${i + 1}"),
//                 ),
//                 TextField(
//                   controller: sVQtyControllers[i],
//                   decoration: InputDecoration(labelText: "SV Qty ${i + 1}"),
//                 ),
//                 TextField(
//                   controller: tVQtyControllers[i],
//                   decoration: InputDecoration(labelText: "TV Qty ${i + 1}"),
//                 ),
//                 SizedBox(height: 10),
//               ],
//
//               ElevatedButton(
//                 onPressed: (){
//                   sendDataToAPI(context);
//                 },
//                 child: Text("Save Changes"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Method to send data to the API
//   void sendDataToAPI(BuildContext context) async {
//     // Prepare your API data, including sale data and items
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? addedBy = prefs.getString('StaffId');
//     List<Map<String, dynamic>> itemList = [];
//     for (int i = 0; i < itemNameControllers.length; i++) {
//       itemList.add({
//         "SaleGKItemId":widget.sale.itemList![i].SaleGKItemId,
//         "ItemId": widget.sale.itemList![i].itemId,  // Assuming itemList contains item IDs
//         "FilledSaleQty": int.parse(filledSaleQtyControllers[i].text),
//         "SVQty": int.parse(sVQtyControllers[i].text),
//         "TVQty": int.parse(tVQtyControllers[i].text),
//         "EmptyRetQty": int.parse(emptyRetQtyControllers[i].text),
//         "DeffQty": int.parse(deffQtyControllers[i].text),
//         "LessEmptyQty": int.parse(lessEmptyQtyControllers[i].text),
//         "Remark":"test",
//         "ClosingFilled": int.parse(closingFilledControllers[i].text),
//         "ClosingEmpty": int.parse(closingEmptyControllers[i].text),
//         "ClosingDef": int.parse(closingDefControllers[i].text),
//         "SVConsStr":"123456",
//       });
//     }
//
//     Map<String, dynamic> apiData = {
//       "SaleGKId": saleGKIdController.text,
//       "DistributorId": distributorIdController.text,
//       "DeliveryDate": deliveryDateController.text,
//       "DMId": dMIdController.text,
//       "VehicleId": vehicleNoController.text,
//       "AddedBy": addedBy,
//       "Action": "EDIT",
//       "ItemList": itemList,  // Pass the list of items
//     };
//
//     String jsonRequestBody = jsonEncode(apiData);
//     print("Request Body: $jsonRequestBody");
//     print("itemList: $itemList");
//
//     // Send the API request
//     final response = await http.post(
//       Uri.parse('${AppUrl.UpdateDailyRefillSale}'),  // Replace with your actual API URL
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken',  // Replace with actual token
//       },
//       body: jsonRequestBody,
//     );
//     print("response: ${response.body}");
//     print("response: ${response.request}");
//     // Check response status
//     if (response.statusCode == 200) {
//       Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Data sent successfully!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send data!')),
//       );
//     }
//   }
//
// }

class _EditSaleScreenState extends State<EditSaleScreen> {
  late TextEditingController saleGKIdController;
  late TextEditingController distributorIdController;
  late TextEditingController staffNameController;
  late TextEditingController vehicleNoController;
  late TextEditingController deliveryDateController;
  late TextEditingController dMIdController;
  late TextEditingController addedOnController;

  // List of controllers for the item fields
  List<TextEditingController> itemNameControllers = [];
  List<TextEditingController> filledSaleQtyControllers = [];
  List<TextEditingController> sVQtyControllers = [];
  List<TextEditingController> tVQtyControllers = [];
  List<TextEditingController> emptyRetQtyControllers = [];
  List<TextEditingController> deffQtyControllers = [];
  List<TextEditingController> lessEmptyQtyControllers = [];
  List<TextEditingController> closingFilledControllers = [];
  List<TextEditingController> closingEmptyControllers = [];
  List<TextEditingController> closingDefControllers = [];
  List<TextEditingController> remarkControllers = [];
  List<TextEditingController> dailySaleStatusControllers = [];
  List<TextEditingController> svConsumerControllers = [];

  UpdateRefillSale? updateRefillSale;
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize all controllers immediately with empty text values
    saleGKIdController = TextEditingController();
    distributorIdController = TextEditingController();
    staffNameController = TextEditingController();
    vehicleNoController = TextEditingController();
    deliveryDateController = TextEditingController();
    dMIdController = TextEditingController();
    addedOnController = TextEditingController();

    // Initialize controllers for item list fields
    itemNameControllers = [];
    filledSaleQtyControllers = [];
    sVQtyControllers = [];
    tVQtyControllers = [];
    emptyRetQtyControllers = [];
    deffQtyControllers = [];
    lessEmptyQtyControllers = [];
    closingFilledControllers = [];
    closingEmptyControllers = [];
    closingDefControllers = [];
    remarkControllers = [];
    dailySaleStatusControllers = [];
    svConsumerControllers = [];

    // Call the async method to load data
    _loadData();
  }

  Future<void> _loadData() async {
    // Fetch shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String saleGKId = widget.saleGKId;

    // Fetch the stock data
    updateRefillSale = UpdateRefillSale();
    // stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(saleGKId, distributorId.toString());
    debugPrint("stockDataFuture: ${stockDataFuture.toString()}");

    // Now, update the controllers with the fetched data
    saleGKIdController.text = widget.sale.saleGKId.toString();
    distributorIdController.text = widget.sale.distributorId.toString();
    staffNameController.text = widget.sale.staffName!;
    vehicleNoController.text = widget.sale.vehicleId.toString();
    deliveryDateController.text = widget.sale.deliveryDate!;
    dMIdController.text = widget.sale.dMId.toString();
    addedOnController.text = widget.sale.addedOn!;
    dailySaleStatusControllers.add(TextEditingController(text: widget.sale.dailySaleStatus.toString()));

    // Initialize controllers for item list fields
    for (var item in widget.sale.itemList ?? []) {
      itemNameControllers.add(TextEditingController(text: item.itemName));
      filledSaleQtyControllers.add(TextEditingController(text: item.filledSaleQty.toString()));
      sVQtyControllers.add(TextEditingController(text: item.sVQty.toString()));
      tVQtyControllers.add(TextEditingController(text: item.tVQty.toString()));
      emptyRetQtyControllers.add(TextEditingController(text: item.emptyRetQty.toString()));
      deffQtyControllers.add(TextEditingController(text: item.deffQty.toString()));
      lessEmptyQtyControllers.add(TextEditingController(text: item.lessEmptyQty.toString()));
      closingFilledControllers.add(TextEditingController(text: item.closingFilled.toString()));
      closingEmptyControllers.add(TextEditingController(text: item.closingEmpty.toString()));
      closingDefControllers.add(TextEditingController(text: item.closingDef.toString()));
      remarkControllers.add(TextEditingController(text: item.remark.toString()));
      svConsumerControllers.add(TextEditingController(text: item.sVConsStr.toString()));
    }

    // If you want to reload UI after async operation
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose the controllers
    saleGKIdController.dispose();
    distributorIdController.dispose();
    staffNameController.dispose();
    vehicleNoController.dispose();
    deliveryDateController.dispose();
    dMIdController.dispose();
    addedOnController.dispose();

    for (var controller in itemNameControllers) controller.dispose();
    for (var controller in filledSaleQtyControllers) controller.dispose();
    for (var controller in sVQtyControllers) controller.dispose();
    for (var controller in tVQtyControllers) controller.dispose();
    for (var controller in emptyRetQtyControllers) controller.dispose();
    for (var controller in deffQtyControllers) controller.dispose();
    for (var controller in lessEmptyQtyControllers) controller.dispose();
    for (var controller in closingFilledControllers) controller.dispose();
    for (var controller in closingEmptyControllers) controller.dispose();
    for (var controller in closingDefControllers) controller.dispose();
    for (var controller in remarkControllers) controller.dispose();
    for (var controller in svConsumerControllers) controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Sale Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sale data fields
              TextField(
                controller: saleGKIdController,
                decoration: InputDecoration(labelText: "Sale GK ID"),
              ),
              TextField(
                controller: distributorIdController,
                decoration: InputDecoration(labelText: "Distributor ID"),
              ),
              TextField(
                controller: staffNameController,
                decoration: InputDecoration(labelText: "Staff Name"),
              ),
              TextField(
                controller: vehicleNoController,
                decoration: InputDecoration(labelText: "Vehicle ID"),
              ),
              TextField(
                controller: deliveryDateController,
                decoration: InputDecoration(labelText: "Delivery Date"),
              ),
              TextField(
                controller: dMIdController,
                decoration: InputDecoration(labelText: "DMID"),
              ),
              TextField(
                controller: addedOnController,
                decoration: InputDecoration(labelText: "Added On"),
              ),
              SizedBox(height: 20),

              // Item fields
              Text("Items:"),
              for (int i = 0; i < widget.sale.itemList!.length; i++) ...[
                TextField(
                  controller: itemNameControllers[i],
                  decoration: InputDecoration(labelText: "Item Name ${i + 1}"),
                ),
                TextField(
                  controller: filledSaleQtyControllers[i],
                  decoration: InputDecoration(labelText: "Filled Sale Qty ${i + 1}"),
                ),
                TextField(
                  controller: sVQtyControllers[i],
                  decoration: InputDecoration(labelText: "SV Qty ${i + 1}"),
                ),
                TextField(
                  controller: tVQtyControllers[i],
                  decoration: InputDecoration(labelText: "TV Qty ${i + 1}"),
                ),
                SizedBox(height: 10),
              ],

              ElevatedButton(
                onPressed: () {
                  sendDataToAPI(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to send data to the API
  void sendDataToAPI(BuildContext context) async {
    // Prepare your API data, including sale data and items
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? addedBy = prefs.getString('StaffId');
      String? godownID = prefs.getString('godownId');
      List<Map<String, dynamic>> itemList = [];
      for (int i = 0; i < itemNameControllers.length; i++) {
        itemList.add({
          "SaleGKItemId":widget.sale.itemList![i].SaleGKItemId,
          "ItemId": widget.sale.itemList![i].itemId,  // Assuming itemList contains item IDs
          "FilledSaleQty": int.parse(filledSaleQtyControllers[i].text),
          "SVQty": int.parse(sVQtyControllers[i].text),
          "TVQty": int.parse(tVQtyControllers[i].text),
          "EmptyRetQty": int.parse(emptyRetQtyControllers[i].text),
          "DeffQty": int.parse(deffQtyControllers[i].text),
          "LessEmptyQty": int.parse(lessEmptyQtyControllers[i].text),
          "Remark":"test",
          "ClosingFilled": int.parse(closingFilledControllers[i].text),
          "ClosingEmpty": int.parse(closingEmptyControllers[i].text),
          "ClosingDef": int.parse(closingDefControllers[i].text),
          "SVConsStr":"123456",
        });
      }

      Map<String, dynamic> apiData = {
        "SaleGKId": saleGKIdController.text,
        "DistributorId": distributorIdController.text,
        "GodownId" : godownID,
        "DeliveryDate": deliveryDateController.text,
        "DMId": dMIdController.text,
        "VehicleId": vehicleNoController.text,
        "AddedBy": addedBy,
        "Action": "EDIT",
        "ItemList": itemList,  // Pass the list of items
      };

      String jsonRequestBody = jsonEncode(apiData);
      print("Request Body: $jsonRequestBody");
      print("itemList: $itemList");

      // Send the API request
      final response = await http.post(
        Uri.parse('${AppUrl.UpdateDailyRefillSale}'),  // Replace with your actual API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',  // Replace with actual token
        },
        body: jsonRequestBody,
      );
      print("response: ${response.body}");
      print("response: ${response.request}");
      // Check response status
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
