import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import 'package:http/http.dart' as http;

import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/UnsettledSaleListModel.dart';
class UnsettledSaleDetailList extends StatefulWidget {
  static const screenName = '/unsettledSaleDetailList';
  const UnsettledSaleDetailList({super.key});

  @override
  State<UnsettledSaleDetailList> createState() => _UnsettledSaleDetailListState();
}

class _UnsettledSaleDetailListState extends State<UnsettledSaleDetailList> {
  late List<UnsettledSaleListModel> unsettledList = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUnsettledList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Color(0xFFECEFFF),
        backgroundColor: Color(0xFFECEFFF),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.pushNamed(context, BottomNavBarExample.screenName);
                      },
                    ),
                    Text(
                      "Unsettled Sale Details  ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Staff Name',
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Item Name",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Quantity",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Total Amt.",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          // Scrollable ListView for content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  unsettledList.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: unsettledList.length,
                    itemBuilder: (context, index) {
                      UnsettledSaleListModel? unsettle = unsettledList[index];
                      return
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      unsettle.staffName.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      unsettle.itemName!.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      unsettle.unsettQty.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      unsettle.unsettSaleAmt!.toStringAsFixed(2),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                    },
                  )
                      : const Text('No Records Found'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchUnsettledList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardUnsettledAmtListMob_V1}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    debugPrint("GetDashboardUnsettledAmtListMob_V1" + '${AppUrl.GetDashboardUnsettledAmtListMob_V1}/$distributorId');
    debugPrint("GetDashboardUnsettledAmtListMob_V1" + '${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint("GetDashboardUnsettledAmtListMob_V1" + '$data');
      //
      // setState(() {
      //   unsettledList = data.map((json) => UnsettledSaleListModel.fromJson(json)).toList();
      //   isLoading = false;
      //   EasyLoading.dismiss();
      // });
      setState(() {
        unsettledList = data
            .map((json) => UnsettledSaleListModel.fromJson(json))
            .where((item) => item.unsettQty != null && item.unsettQty! > 0)
            .toList();

        isLoading = false;
        EasyLoading.dismiss();
      });

    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
}
