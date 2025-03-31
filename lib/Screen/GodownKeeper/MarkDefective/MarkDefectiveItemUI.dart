import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import 'package:http/http.dart' as http;

import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';

class MarkdefectiveItemUI extends StatefulWidget {
  GetDefectiveStockListModel _listModel;

  MarkdefectiveItemUI(this._listModel,{Key? key}) : super(key: key);
  @override
  State<MarkdefectiveItemUI> createState() => _MarkdefectiveItemUIState();
}

class _MarkdefectiveItemUIState extends State<MarkdefectiveItemUI> {
  List<GetDefectiveStockListModel> _defectiveStockList = [];
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child:Center(
                            child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(value.defDate ?? '')),
                              style: Styling.itemBlackTestSmall,
                            ),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child:
                               Center(
                                 child: Text(
                                 value.itemName.toString(),
                                  style: Styling.itemBlackTestSmall,
                                                               ),
                               )
                      ),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text(
                                value.defQty.toString(),
                                style: Styling.itemBlackTestSmall,
                              )
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Confirm Deletion"),
                                        content: Text("Are you sure you want to delete this record?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close dialog without action
                                            },
                                            child: Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop(); // Close dialog
                                               deleteDefectiveToApi(value.defId!.toInt());
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ))),
                    ],
                  ),
                ],
              ),
            );
  }

  Future<void> deleteDefectiveToApi(int defectiveId) async {
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
    // String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);

    Map<String, dynamic> requestBody = {
        "DefId":defectiveId,
        "DistributorId":dId,
        "DefDate":formattedDate,
        "GodownId":gId,
        "ItemId":0,
        "DefQty":0,
        "Remark":"",
        "Action":"DELETE",
        "AddedBy":0
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
      print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
      print("API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        print("DefectiveMasterAdd_Mob quantity added successfully!");
        Navigator.pushReplacementNamed(context, '/markDefectiveItemScreen');
        EasyLoading.showToast(Constants.dataDeleted, duration: const Duration(milliseconds: 3000));
        _fetchDefectiveData();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  Future<void> _fetchDefectiveData() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);// This is your bearer token
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now); // Format selectedDate
    // String formattedDate = "2025-03-20"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDefectiveList_Mob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode(
            {
              "DistributorId":dId,
              "DefDate":formattedDate,
              "GodownId":gId,
            }
        ),
      );

      debugPrint('jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
      debugPrint('responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _defectiveStockList = data.map((json) => GetDefectiveStockListModel.fromJson(json)).toList();
          EasyLoading.dismiss();
        });


      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
