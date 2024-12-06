
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/CustomAppBar.dart';
import '../../../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../EditItem/Model/GetItemReceiptListModel.dart';
import 'ItenReturnItemUi.dart';
class ItemReturnScreen extends StatefulWidget {
  static const screenName = '/itemReturnScreen';
  const ItemReturnScreen({super.key});

  @override
  State<ItemReturnScreen> createState() => _ItemReturnScreenState();
}

class _ItemReturnScreenState extends State<ItemReturnScreen> {
  List<GetItemReceiptListModel> receiptList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchItemReceipts();
  }
  void showDetailsDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details for ${item['vehicleNo']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("14.2 Kg Empty Return: 200"),
              Text("14.2 Kg Defective: --"),
              Text("19 Kg Empty Return: 50"),
              Text("19 Kg Defective: --"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the "Out" action
                Navigator.of(context).pop();
              },
              child: Text("Out"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Item Return', // Title or hint text for the text field
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: receiptList.length,
          itemBuilder: (context, index) {
            return  ItemReturnScreenListItem(
                receiptList[index]);
            //   Card(
            //   margin: EdgeInsets.all(8.0),
            //   child: ListTile(
            //     title: Text("Veh No: ${item['vehicleNo']}"),
            //     subtitle: Text("Return: ${item['return']}"),
            //     trailing: ElevatedButton(
            //       onPressed: () {
            //         showDetailsDialog(context, item);
            //       },
            //       child: Text("Out"),
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
  Future<void> fetchItemReceipts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('refNo');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('userId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token

    try {
      final response = await http.get(
        Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/$godownKeeperId'),
        headers: {
          'Authorization': 'Bearer $token',  // Add the Bearer token here
          // Any other headers you need can go here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          receiptList = data.map((json) => GetItemReceiptListModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        // Handle non-200 responses
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}



