import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/GetItemReceiptListModel.dart';
class ReceiptEditPage extends StatelessWidget {
  final GetItemReceiptListModel receipt;

  const ReceiptEditPage({required this.receipt});

  @override
  Widget build(BuildContext context) {
    // Use the correct getter `itemDetails` instead of `items`
    TextEditingController receiptDateController = TextEditingController(text: receipt.receiptDate);
    TextEditingController vehicleNoController = TextEditingController(text: receipt.vehicleNo);

    List<Map<String, TextEditingController>> itemControllers = (receipt.itemDetails ?? [])
        .map<Map<String, TextEditingController>>((item) => {
      'itemName': TextEditingController(text: item.itemName),
      'receivedQty': TextEditingController(
          text: item.filledQty?.toString() ?? ''), // Convert to String
      'invoiceQty': TextEditingController(
          text: item.invoiceQty?.toString() ?? ''), // Convert to String
      'emrQty': TextEditingController(text: item.eMRQty?.toString() ?? ''), // Convert to String
      'ItemID': TextEditingController(text: item.itemId?.toString() ?? ''), // Convert to String
    })
        .toList();



    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Receipt Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt Date:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: receiptDateController,
              decoration: InputDecoration(hintText: 'Enter Receipt Date'),
            ),
            SizedBox(height: 10),
            Text('Vehicle Number:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: vehicleNoController,
              decoration: InputDecoration(hintText: 'Enter Vehicle Number'),
            ),
            SizedBox(height: 20),
            Text('Items List:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: receipt.itemDetails?.length,  // Use itemDetails instead of items
                itemBuilder: (context, itemIndex) {
                  final item = receipt.itemDetails?[itemIndex];  // Same here
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: itemControllers[itemIndex]['itemName'],
                            decoration: InputDecoration(
                              labelText: 'Item Name',
                            ),
                            enabled: false,
                          ),
                          TextField(
                            controller: itemControllers[itemIndex]['receivedQty'],
                            decoration: InputDecoration(
                              labelText: 'Received Quantity',
                            ),
                          ),
                          TextField(
                            controller: itemControllers[itemIndex]['invoiceQty'],
                            decoration: InputDecoration(
                              labelText: 'Invoice Quantity',
                            ),
                          ),
                          TextField(
                            controller: itemControllers[itemIndex]['emrQty'],
                            decoration: InputDecoration(
                              labelText: 'EMR Quantity',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Collect updated receipt and items data
                final updatedReceipt = {
                  'receiptDate': receiptDateController.text,
                  'vehicleNo': vehicleNoController.text,
                  'items': itemControllers
                      .map((controllers) => {
                    'ItemID': controllers['ItemID']!.text,
                    'receivedQty': controllers['receivedQty']!.text,
                    'invoiceQty': controllers['invoiceQty']!.text,
                    'emrQty': controllers['emrQty']!.text,
                  })
                      .toList(),
                };

                // Now you can send this updated receipt to your API
                _submitData(updatedReceipt, context);
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _submitData(Map<String, dynamic> updatedReceipt, BuildContext context) async {
    // Fetch shared preference values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('refNo');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('userId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');


    // Attach additional required fields to the updatedReceipt
    updatedReceipt['distributorId'] = distributorId;
    updatedReceipt['godownId'] = godownId;
    updatedReceipt['addedBy'] = addedBy;
    updatedReceipt['godownKeeperId'] = godownKeeperId;
    // Structure the request body correctly
    // Debugging: Check values of receiptId and vehicleNo

    Map<String, dynamic> requestBody = {
      'ReceiptId': 0, // Add receiptId if available (or 0 if not)
      'DistributorId': distributorId,
      'GodownId': godownId,
      'ReceiptDate':updatedReceipt['receiptDate'],
      'VehicleNo':updatedReceipt['vehicleNo'],
      'GodownKeeperId': godownKeeperId,
      'AddedBy': addedBy,
      'Action': 'EDIT', // Indicating that this is an edit action
      'ItemDetails': updatedReceipt['items'] ?? [],
    };
    // Convert the map to a JSON string
    String jsonRequestBody = jsonEncode(requestBody);

    debugPrint("edit"+jsonRequestBody);



    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(AppUrl.ItemReceiptAddEdit),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequestBody,
      );

      // Check the response status
      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body}');
        int responseValue = int.tryParse(response.body) ?? 0;

        // Show appropriate message based on the response
        if (responseValue > 0) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Inserted successfully!')),
          // );
          debugPrint('Error3: ${response.statusCode}');
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Fail to insert record!')),
          // );
          debugPrint('Error2: ${response.statusCode}');
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Fail to insert record! ${response.statusCode}')),
        // );
        debugPrint('Error1: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Fail to insert record! $e')),
      // );
    }
  }

}