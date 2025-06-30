import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ConstantScreen/widgets.dart';
import '../../../../Utils/CustomAppBar.dart';
import '../../../../Utils/app_url.dart';
import '../../../../Utils/constants.dart';
import '../../../BottomNavigationForGodownKeeper.dart';
import '../../../DashboardScreen.dart';
import '../../EditItem/Model/GetItemReceiptListModel.dart';
import 'package:http/http.dart' as http;

import '../model/GetEXMIListModel.dart';
import 'ItemReturnXMIListItemUI.dart';
class ItemReturnXMIListScreen extends StatefulWidget {
  static const screenName = '/itemReturnXMIListScreen';
  const ItemReturnXMIListScreen({super.key});

  @override
  State<ItemReturnXMIListScreen> createState() => _ItemReturnXMIListScreenState();
}

class _ItemReturnXMIListScreenState extends State<ItemReturnXMIListScreen> {
  List<GetExmiListModel> receiptList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemReceipts();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },

      child: Scaffold(
          appBar: CustomAppBar(
            title: 'Receipt EXMI', // Title or hint text for the text field
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
                return  ItemReturnXMIListItemUI(
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

  Future<void> _refresh() async {
    await fetchItemReceipts();  // Call fetchItemReceipts to get updated data
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
          Uri.parse('${AppUrl.GetItemEXMIDetailList}/$distributorId/$godownId/$godownKeeperId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL GetItemEXMIDetailList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status Code GetItemEXMIDetailList: ${response.statusCode}");
        print("API Response Body GetItemEXMIDetailList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList = data.map((json) => GetExmiListModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          showFlushBar(context,Constants.listGettingFail);
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
