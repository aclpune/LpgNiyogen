import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import 'GetDashProductSaleComparisonMob.dart';

class SalesComparisonScreen extends StatefulWidget{
  static const screenName = '/salesComparisonScreen';

  @override
  State<SalesComparisonScreen> createState() => _SalesComparisonScreenState();

}

class _SalesComparisonScreenState extends State<SalesComparisonScreen> {
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];  // Make sure you populate this list with items
  String _selectedItem = '';
  int? selectedItemId;
  List<GetDashProductSaleComparisonMob> _salesItem = [];
  GetDashProductSaleComparisonMob? _selectedSalesItemModel;
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);


  @override
  void initState() {
    super.initState();
    fetchItems();
  }


  @override
  Widget build(BuildContext context) {

    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushNamedAndRemoveUntil(context, '/bottomNavBarExample', (route) => false);
          return false;
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/bottomNavBarExample', (route) => false);
          return false;
        }
      },
            child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Color(0xFFECEFFF),
          backgroundColor: Color(0xFFECEFFF),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "Sales Comparion",
                            style: TextStyle(fontSize: 18, color: Colors.black),

                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Sales Comparison -',
                        style: Styling.bodyTitleBigBoldExp,
                       textScaler: TextScaler.noScaling,
                                         ),
                    ),
                    SizedBox(width: 10),
                      Flexible(
                        child: DropdownButtonFormField<CylItemListModel>(
                          decoration: buildInputBorderUpdateStatus("", context),
                          value: _selectedItemModel,
                          items: _items.map((CylItemListModel item) {
                            return DropdownMenuItem<CylItemListModel>(
                              value: item,
                              child: Text(
                                item.itemName ?? '',
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                              ),
                            );
                          }).toList(),
                          onChanged: (CylItemListModel? selectedItem) async {
                            if (selectedItem != null) {
                              setState(() {
                                _selectedItemModel = selectedItem;
                                _selectedItem = selectedItem.itemName!;
                                selectedItemId = selectedItem.itemId?.toInt();
                              });
                              await getDashProductSaleComparisonMob(selectedItem.itemId?.toInt() ?? 0);
                            }
                          },
                          hint: Text(''),
                        ),
                      ),

                  ],
                ),
            ),
            SizedBox(height: 8,),
            SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(isVisible: false), // Hide the legend completely
              primaryXAxis: CategoryAxis(
                isVisible: true,
                interval: 3, // Reduces the spacing between X-axis labels
                labelRotation: 2,  // Adjust the rotation if needed
                edgeLabelPlacement: EdgeLabelPlacement.shift, // Shift labels for a better fit
                majorTickLines: MajorTickLines(size: 0), // Optional: Remove major ticks
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
              ),
              series: <CartesianSeries>[
                ColumnSeries<SalesData, String>(
                  dataSource: [
                    SalesData(_selectedSalesItemModel?.thisMonthSaleQty?.toDouble() ?? 0.0),
                    SalesData(_selectedSalesItemModel?.preMonthSaleQty?.toDouble() ?? 0.0),
                    SalesData(_selectedSalesItemModel?.preYearSameMonthSaleQty?.toDouble() ?? 0.0),
                  ],
                  xValueMapper: (SalesData sales, int index) => index.toString(),
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  width: 0.9, // Adjust the bar width
                  spacing: 0.4,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                  ),
                  pointColorMapper: (SalesData sales, int index) {
                    if (index == 0) return Colors.lightBlueAccent;
                    if (index == 1) return Color(0xFF1271b5);
                    if (index == 2) return Colors.orange;
                    return Colors.grey;
                  },
                ),
              ],
            ),
            Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text('This Month', style: TextStyle(fontSize: 12)),
                              SizedBox(width: 10),
                              Container(
                                width: 10,
                                height: 10,
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Last Month', style: TextStyle(fontSize: 12)),
                              SizedBox(width: 8),
                              Container(
                                width: 10,
                                height: 10,
                                color: Color(0XFF1271b5)
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Last Year Same Month', style: TextStyle(fontSize: 12)),
                              SizedBox(width: 8),
                              Container(
                                width: 10,
                                height: 10,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
         ),
      );
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      debugPrint("Fetching Items from: ${AppUrl.GetItemMasterList}/$distributorId/1/c");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint("Decoded Response: $data");


        if (data.isNotEmpty) {
          setState(() {
            _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
          });
          debugPrint("Items List: $_items");


          _selectedItemModel = _items.firstWhere(
                (item) => item.itemName == '14.2 KG',
            orElse: () => _items.first,
          );

          _selectedItem = _selectedItemModel?.itemName ?? 'All Items';
          selectedItemId = _selectedItemModel?.itemId?.toInt();

          await getDashProductSaleComparisonMob(selectedItemId ?? 0);
        } else {
          debugPrint("No items found in the response.");
        }
      } else {
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> getDashProductSaleComparisonMob(int itemId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetDashProductSaleComparisonMob}/$distributorId/$itemId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      debugPrint("item" + '${AppUrl.GetDashProductSaleComparisonMob}/$distributorId/$itemId');
      debugPrint("item" + response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _salesItem = data.map((json) => GetDashProductSaleComparisonMob.fromJson(json)).toList();
            _selectedSalesItemModel = _salesItem[0];
          } else {
            _salesItem = [];
            _selectedSalesItemModel = null;
          }
        });
      } else {
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

class SalesData {
  SalesData(this.sales);
  final double sales;
}