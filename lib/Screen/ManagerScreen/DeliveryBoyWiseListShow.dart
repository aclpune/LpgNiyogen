import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomAppBarManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/size_config.dart';
import 'ManagerModelClass/DailySaleSaummaryListModel.dart';
import 'package:http/http.dart' as http;

import 'ManagerModelClass/GetLastUploadedFrileDifferenceModel.dart';
import 'ManagerSingleItemUI/DeliveryBoyWiseListItem.dart';
class DeliveryBoyWiseListShow extends StatefulWidget {
  static const screenName = '/deliveryBoyWiseListShow';
  const DeliveryBoyWiseListShow({super.key});

  @override
  State<DeliveryBoyWiseListShow> createState() => _DeliveryBoyWiseListShowState();
}

class _DeliveryBoyWiseListShowState extends State<DeliveryBoyWiseListShow> {
  TextEditingController searchController = TextEditingController();
  List<DailySaleSaummaryListModel> dailySales = [];
  List<DailySaleSaummaryListModel> filteredSales = []; // List for filtered results

  bool _isExpanded = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchDailySales();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Scaffold(
        body:isLoading?Center(child: CircularProgressIndicator()):
        // SingleChildScrollView(
        //   padding: const EdgeInsets.all(8.0),
        //   child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black,fontFamily: 'OpenSans',fontSize: 14),
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize:
                        14, // Size = 16-- [18/8.66] = 2.07
                        fontFamily: 'OpenSans'),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,),
                    /*enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),*/
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  onChanged: (value) {
                    filterSearchResults(value);
                    debugPrint("SearchVal: " + value.toString());
                  },
                ),
              ),
            ),

            Expanded(
              child: filteredSales.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredSales.length,
                itemBuilder: (context, index) {
                  var sale = filteredSales[index]; // Access the current item
                  return DeliveryBoyWiseListItem(
                      filteredSales[index]);
                },
              ):
              Center(child: Text("No Data Available")),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Future<void> fetchDailySales() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,
          Constants.connectionMessage);
      isLoading = false;
    }else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetDailySaleSummaryListDMWiseForMob}/$distributorId/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetDailySaleSummaryListDMWiseForMob: ${response.body}");
        debugPrint("request body GetDailySaleSummaryListDMWiseForMob: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            dailySales = data.map((jsonItem) =>
                DailySaleSaummaryListModel.fromJson(jsonItem)).toList();
            filteredSales = dailySales;
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSales = dailySales;
      });
    } else {
      setState(() {
        filteredSales = dailySales
            .where((sale) =>
        sale.staffName!.toLowerCase().contains(query.toLowerCase()) ||
            sale.totalAmt.toString().contains(query) ||
            sale.totalFilledQty.toString().contains(query) ||
        sale.totalTVQty.toString().contains(query) ||
        sale.totalSVQty.toString().contains(query))
            .toList();
      });
    }
  }


}
