
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../../Utils/CustomAppBar.dart';
import '../../../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../../../Utils/constants.dart';
import '../../DashboardScreen.dart';
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
  // Pull-to-refresh function to trigger data fetch
  Future<void> _refresh() async {
    await fetchItemReceipts();  // Call fetchItemReceipts to get updated data
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
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, DashboardScreen.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, DashboardScreen.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },

      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Item Return', // Title or hint text for the text field
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: isLoading?
          Center(child: CircularProgressIndicator()):
          receiptList.isNotEmpty?
          ListView.builder(
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
          ):
              Container(
                child: Text("No Data Found..!",style: TextStyle(fontSize: 16),),
              ),
        )
      ),
    );
  }

  Future<void> fetchItemReceipts() async {
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
          // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
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
          setState(() {
            isLoading = false;
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }
}



