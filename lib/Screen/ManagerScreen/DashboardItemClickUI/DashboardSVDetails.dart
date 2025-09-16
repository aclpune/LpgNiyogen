import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetailUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';

class DashboardSVDetails extends StatefulWidget {
  static const screenName = '/dashboardSVDetails';
  @override
  State<StatefulWidget> createState() {
    return _DashboardSVDetails();
  }
}

class _DashboardSVDetails extends State<DashboardSVDetails>{
  List<GetDashboardSvStockPendCtnListForMobListModel> svmodel = [];
  bool isLoading = true;
  String todayDate = DateTime.now().toString();
  int? flag;
  DateTime? date;
  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;
  var argValue;
  final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: "ALL");
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
        fetchSV(flag!);
      });
    });
    fetchItems();
    _selectedItemModel = allItem;
  }

  Future<void> fetchSV(int flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDashboardSvStockPendCtnListForMobListModel : " + '${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag');
    debugPrint("GetDashboardSvStockPendCtnListForMobListModelresponsebody " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        svmodel = data.map((json) {
          // String dateString = json[''];
          // DateTime date = DateTime.parse(dateString);
          // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // json[''] = formattedDate;


         // Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(value.stkTransDate ?? '')),

          //     String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
          // debugPrint("formattedDate :- ${formattedDate.toString()}");
          return GetDashboardSvStockPendCtnListForMobListModel.fromJson(json);
        }).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/c');
      debugPrint("item" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(
          context,Constants.connectionMessage);
    }
  }
  @override
  Widget build(BuildContext context) {

    final totalCylQty = svmodel.fold<num>(0, (sum, item) => sum + (item.cylQty ?? 0));
    final totalAmount = svmodel.fold<double>(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
    final formattedAmount = formatCurrency(totalAmount);
    var svCount = svmodel.length;

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
                          Text('SV Stock Movement',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            'Count: $svCount',
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
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('Postpaid Verification'),
      //       Text(
      //         'Count: $svCount',
      //         style: TextStyle(fontSize: 14, color: Colors.white70),
      //       ),
      //     ],
      //   ),
      // ),
      body: isLoading
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
                    child: DropdownButtonFormField<CylItemListModel>(
                      decoration: buildInputBorderUpdateStatus("ALL", context),
                      value: _selectedItemModel,
                      items: [
                        DropdownMenuItem<CylItemListModel>(
                          value: allItem,
                          child: Text(
                            "ALL",
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                        ..._items.map((CylItemListModel item) {
                          return DropdownMenuItem<CylItemListModel>(
                            value: item,
                            child: Text(
                              item.itemName ?? '',
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (CylItemListModel? selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            _selectedItemModel = selectedItem;

                            if (selectedItem.itemId == -1) {
                              _selectedItem = "ALL";
                              selectedItemId = -1;

                              fetchSV(flag!); // ← Add this to fetch all again
                            } else {
                              _selectedItem = selectedItem.itemName!;
                              selectedItemId = selectedItem.itemId?.toInt();
                              fetchSV(selectedItemId!);
                            }
                          });
                        }
                      },
                      hint: Text('ALL'),
                    ),
                  ),
                ],
              ),

          ),
          Expanded(
            child: svmodel.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: svmodel.length,
              itemBuilder: (context, index) {
                debugPrint(
                    "Rendering Expense Item: ${svmodel[index]}");
                return DashboardSVDetailUI(
                  svmodel[index],
                );
              },
            )
                : Center(
              child: Text('No Records Found'),
            ),
          ),
          //if (svmodel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   // 'Cyl. Qty: $totalCylQty',
                    'Cyl. Qty: ${svmodel.isNotEmpty ? totalCylQty : 0}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                   // 'Amount: ₹${formattedAmount}',
                    'Amount: ${svmodel.isNotEmpty ? formattedAmount : '0.00'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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