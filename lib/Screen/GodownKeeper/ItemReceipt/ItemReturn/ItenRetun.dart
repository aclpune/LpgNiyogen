
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
import '../../BottomNavigationForGodownKeeper.dart';
import '../../DashboardScreen.dart';
import '../../SQCRegister/SQCRegisterScreen.dart';
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
          title: 'Item Return', // Title or hint text for the text field
        ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            onPressed: () {
              _showSQCBottomSheet(context);
            },
            icon: Icon(Icons.list),
            label: Text(
              "SQC",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
  void _showSQCBottomSheet(BuildContext context) {

    var vehiclesNotOut = receiptList
        .where((v) => v.returnOn == "0001-01-01T00:00:00")
        .toList();

    if (vehiclesNotOut.isEmpty) {
      showFlushBar(context, "All vehicles are already out.");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SQC Vehicles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child:
                ListView.builder(
                  itemCount: vehiclesNotOut.length,
                  itemBuilder: (context, index) {
                    var vehicle = vehiclesNotOut[index];

                    // var item = (vehicle.itemDetails?.isNotEmpty ?? false)
                    //     ? vehicle.itemDetails![0]
                    //     : null;

                    return ListTile(
                        title: RichText(
                          text: TextSpan(
                            text: "Vehicle No: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "${vehicle.vehicleNo}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text("Vehicle No: ${vehicle.vehicleNo}"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        // onTap: () {
                        //   Navigator.pop(context);
                        //   Navigator.pushNamed(
                        //     context,
                        //     SQCRegisterScreen.screenName,
                        //     arguments: {
                        //       'vehicleNo': vehicle.vehicleNo.toString(),
                        //       'godownId': vehicle.godownId.toString(),
                        //       // 'itemId': item != null ? item.itemId.toString() : "",
                        //       // 'itemName': item != null ? item.itemName.toString() : "",
                        //     },
                        //   );
                        // },

                        onTap: () {
                          Navigator.pop(context);

                          // Prepare lists
                          var itemIds = <String>[];
                          var itemNames = <String>[];

                          if (vehicle.itemDetails != null && vehicle.itemDetails!.isNotEmpty) {
                            for (var item in vehicle.itemDetails!) {
                              itemIds.add(item.itemId.toString());
                              itemNames.add(item.itemName.toString());
                            }
                          }
                          Navigator.pushNamed(
                            context,
                            SQCRegisterScreen.screenName,
                            arguments: {
                              'vehicleNo': vehicle.vehicleNo.toString(),
                              'godownId': vehicle.godownId.toString(),
                              'itemIds': itemIds,
                              'itemNames': itemNames,
                            },
                          );
                        }
                      // onTap: () {
                      //   Navigator.pop(context);
                      //
                      //   // Prepare lists of item IDs and names
                      //   var itemIds = <String>[];
                      //   var itemNames = <String>[];
                      //
                      //   if (vehicle.itemDetails != null && vehicle.itemDetails!.isNotEmpty) {
                      //     for (var i in vehicle.itemDetails!) {
                      //       itemIds.add(i.itemId.toString());
                      //       itemNames.add(i.itemName.toString());
                      //     }
                      //   }
                      //
                      //   Navigator.pushNamed(
                      //     context,
                      //     SQCRegisterScreen.screenName,
                      //     arguments: {
                      //       'vehicleNo': vehicle.vehicleNo.toString(),
                      //       'godownId': vehicle.godownId.toString(),
                      //       'itemIds': itemIds,       // list of IDs
                      //       'itemNames': itemNames,   // list of names
                      //     },
                      //   );
                      // },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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



