import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/GetBankMappingDetailsListModel.dart';
import 'DashboardPostPaidVerifPendDetailsUI.dart';

class DashboardPostPaidVerifPendDetails extends StatefulWidget {
  static const screenName = '/dashboardPostPaidVerifPendDetails';
  @override
  State<StatefulWidget> createState() {
    return _DashboardPostPaidVerifPendDetails();
  }
}

class _DashboardPostPaidVerifPendDetails extends State<DashboardPostPaidVerifPendDetails>{

  List<GetDashboardPostpaidVarifiPendCntLstForMobListModel> postpaidverifipending = [];
  List<GetDashboardPostpaidVarifiPendCntLstForMobListModel> filteredPostpaidModel = [];
  List<GetBankMappingDetailsListModel> bankmappingModel = [];
  String? flag;
  String? selectedBank;
  String? selectedBankName,selectedBankId;
  int? isActive;
  bool isLoading = true;
  bool isChecked = false;
  bool isSubmitEnabledBtn = false; // Initially disabled
  List<String> getTransactionForList = ["All","Daily Sales","SV Sales","ARB Sales","Receipt"];
  var argValue;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        flag = argValue["flag"];
        fetchPrepaid(flag!);

      });
    });
    fetchBank();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredPostpaidModel = postpaidverifipending
          .where((item) => item.staffName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchPrepaid(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,

    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDashboardPostpaidVarifiPendCntLstForMobListModel : " + '${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag');
    debugPrint("GetDashboardPostpaidVarifiPendCntLstForMobListModelresponse : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        postpaidverifipending = data.map((json) {
          String dateString = json['TransDate'];
          DateTime date = DateTime.parse(dateString);
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          json['TransDate'] = formattedDate;

          return GetDashboardPostpaidVarifiPendCntLstForMobListModel.fromJson(json);
        }).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankMappingDetailsListModel : " + '${AppUrl.GetBankMappingDetailsList}/$distributorId/1');
    debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        bankmappingModel = data.map((json) {
          return GetBankMappingDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    var postCount = postpaidverifipending.length;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Postpaid Verification',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              'Count: $postCount',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body:
      isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
              Row(
                children: [
                  Text("Select Item :",style: Styling.blueClrText),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      ),
                      style: Styling.itemBlackTest,
                      items: getTransactionForList
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          String? selectedPaymentMode = value;
                          String? newValue = selectedPaymentMode?.replaceAll(' ', '');
                          debugPrint(newValue);
                          fetchPrepaid(newValue!);
                        });
                      },
                      isExpanded: true,
                      hint: Text('All'),
                    ),
                  ),
                ],
              ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : postpaidverifipending.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: postpaidverifipending.length,
              itemBuilder: (context, index) {
                final sale = postpaidverifipending[index];
                debugPrint("Rendering Expense Item: $sale");
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Trans Time", nullToDash(sale.transTime))),
                        Expanded(flex: 1, child: countTextWidgetText(context, "Amount", nullToDash(formatCurrency((sale.amount ?? 0.0).toDouble())))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Trans For", nullToDash(sale.transFor))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Trans Date", nullToDash(sale.transDate))),
                      ],
                    ),

                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Trans Code", nullToDash(sale.transCode))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Staff Name", nullToDash(sale.staffName))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetRemark(context, "Remark", sale.remark ?? '')),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            )
                : const Center(child: Text('No Records Found')),
          ),
        ],
      ),
    );
  }

  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") {
      return "-";
    }
    return value;
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    debugPrint("Current selectedDate: ${postpaidverifipending[index].selectedDate}");

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: postpaidverifipending[index].selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      debugPrint("Picked date: $picked");
      setState(() {
        postpaidverifipending[index].selectedDate = picked;
      });
    } else {
      debugPrint("Date is null or canceled");
    }
  }

}

String formatCurrency(double amount) {
  if (amount == 0) {
    return '0.00'; // Return "0.00" if the amount is zero
  }
  final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator

  // Ensure the result always shows a leading zero before the decimal point
  String formattedAmount = format.format(amount);

  // If there's no integer part, it ensures that a leading zero is added before decimal
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0' + formattedAmount;
  }

  return formattedAmount;
}

