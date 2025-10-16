import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetDashboardTVStockPendCtnListForMob.dart';
import 'DashboardTVDetailUI.dart';

class DashboardTVDetails extends StatefulWidget {
  static const screenName = '/dashboardTVDetails';
  @override
  State<StatefulWidget> createState() {
    return _DashboardTVDetails();
  }
}

class _DashboardTVDetails extends State<DashboardTVDetails>{
  List<GetDashboardTvStockPendCtnListForMob> tvmodel = [];
  bool isLoading = true;
  String todayDate = DateTime.now().toString();
  var argValue;
  int? flag;
  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;
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
        fetchTV(flag!);
      });
    });

    fetchItems();
    _selectedItemModel = allItem;

  }

  Future<void> fetchTV(int flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardTVStockPendCtnListForMob}/$distributorId/$flag'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDashboardTVStockPendCtnListForMob : " + '${AppUrl.GetDashboardTVStockPendCtnListForMob}/$distributorId/$flag');
    debugPrint("GetDashboardTVStockPendCtnListForMobresponse : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        tvmodel = data
            .map((json) => GetDashboardTvStockPendCtnListForMob.fromJson(json))
            .toList();
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
    final totalCylQty = tvmodel.fold<num>(0, (sum, item) => sum + (item.clyReceivedQty ?? 0));
    final totalAmount = tvmodel.fold<double>(0.0, (sum, item) => sum + (item.paidAmt?? 0.0));
    final regReceivedCount = tvmodel.where((item) => item.isRegulator == 'Yes').length;
    final formattedAmount = formatCurrency(totalAmount);
    var tvCount = tvmodel.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Color(0xFFECEFFF),
        backgroundColor: Color(0xFFECEFFF),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TV Stock Movement',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            'Count: $tvCount',
                            style: TextStyle(fontSize: 12, color: Colors.black),
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
                              item.itemName ?? 'Unknown',
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

                             fetchTV(flag!);

                            } else {
                              _selectedItem = selectedItem.itemName!;
                              selectedItemId = selectedItem.itemId?.toInt();
                              fetchTV(selectedItemId!);
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
            child: tvmodel.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tvmodel.length,
              itemBuilder: (context, index) {
                debugPrint(
                    "Rendering Expense Item: ${tvmodel[index]}");
                return DashboardTVDetailUI(
                  tvmodel[index],
                );
              },
            )
                : Center(
              child: Text('No Records Found'),
            ),
          ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${tvmodel.isNotEmpty ? totalCylQty : 0}',                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Reg Rec: ${tvmodel.isNotEmpty ? regReceivedCount : 0}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Amount: ${tvmodel.isNotEmpty ? formattedAmount : '0.00'}',
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