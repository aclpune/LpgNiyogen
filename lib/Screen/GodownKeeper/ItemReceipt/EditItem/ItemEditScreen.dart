import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/CustomAppBar.dart';
import 'Model/GetItemReceiptListModel.dart';
import 'ReceiptEditPage.dart';


class EditItemReceiptPage extends StatefulWidget {
  static const screenName = '/editItemReceiptPage';
  @override
  _EditItemReceiptPageState createState() => _EditItemReceiptPageState();
}

class _EditItemReceiptPageState extends State<EditItemReceiptPage> {
  List<GetItemReceiptListModel> receiptList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemReceipts();
  }

  Future<void> fetchItemReceipts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('userId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token

    try {
      final response = await http.get(
        // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
        Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
        headers: {
          'Authorization': 'Bearer $token',  // Add the Bearer token here
          // Any other headers you need can go here
        },
      );
      // Print the URL and the headers (including the Bearer token)
      print("Request URL: ${response.request}");
      print("Request Headers: {'Authorization': 'Bearer $token'}");
      // Print the raw response for debugging
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          receiptList = data.map((json) => GetItemReceiptListModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        // Handle non-200 responses
        print("Failed Response: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: CustomAppBar(
          title: 'Item Edit', // Title or hint text for the text field
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: receiptList.length,
          itemBuilder: (context, index) {
            final receipt = receiptList[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receipt Date: ${receipt.receiptDate}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Vehicle No: ${receipt.vehicleNo}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // The trailing arrow is handled automatically by ExpansionTile
                children: [
                  // List of items in the receipt
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: receipt.itemDetails?.length ?? 0,
                    itemBuilder: (context, itemIndex) {
                      final item = receipt.itemDetails![itemIndex];
                      return ListTile(
                        title: Text('Item Name: ${item.itemName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Received Qty: ${item.filledQty}'),
                            Text('Invoice Qty: ${item.invoiceQty}'),
                            Text('EMR Qty: ${item.eMRQty}'),
                            Text('ItemID: ${item.itemId}'),
                          ],
                        ),
                      );
                    },
                  ),
                  // Edit Button placed below the items
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle your navigation to the edit page here if needed
                          // Example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptEditPage(
                                  receipt: receipt),
                            ),
                          );
                        },
                        child: Text('Edit Receipt'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}
