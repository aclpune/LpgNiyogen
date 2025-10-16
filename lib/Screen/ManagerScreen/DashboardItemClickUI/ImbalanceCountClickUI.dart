import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import 'package:http/http.dart' as http;

import '../ClickModelClass/ImbalanceItemWiseCountListModel.dart';
class ImbalanceCountClickUI extends StatefulWidget {
  static const screenName = '/imbalanceCountClickUI';
  const ImbalanceCountClickUI({super.key});

  @override
  State<ImbalanceCountClickUI> createState() => _ImbalanceCountClickUIState();
}

class _ImbalanceCountClickUIState extends State<ImbalanceCountClickUI> {
  late List<ImbalanceItemWiseCountListModel> imbalanceList = [];
  List<ImbalanceItemWiseCountListModel> filteredImbalanceList = []; // Display list
  bool isLoading = true;
  var argValue;
  int? itemIds;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        itemIds = argValue["ItemId"];
        debugPrint("itemIds :- ${itemIds.toString()}");
        fetchImbalanceListList(itemIds!);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
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
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Current Imbalance Stock",
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
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => filterSearchResults(query),
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
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
                        "Imbalance Qty.",
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
                  filteredImbalanceList.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredImbalanceList.length,
                    itemBuilder: (context, index) {
                      ImbalanceItemWiseCountListModel? imbalance = filteredImbalanceList[index];
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
                                      imbalance.staffName.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      imbalance.itemName.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      imbalance.imbalanceQty.toString(),
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

  Future<void> fetchImbalanceListList(int itemId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardImbalanceDtlsListMob_V1}/$distributorId/$itemId/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    debugPrint("GetDashboardImbalanceDtlsListMob_V1" + '${AppUrl.GetDashboardImbalanceDtlsListMob_V1}/$distributorId');
    debugPrint("GetDashboardImbalanceDtlsListMob_V1" + '${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint("GetDashboardImbalanceDtlsListMob_V1" + '$data');

      setState(() {
        imbalanceList = data.map((json) => ImbalanceItemWiseCountListModel.fromJson(json)).toList();
        filteredImbalanceList = List.from(imbalanceList);
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredImbalanceList = List.from(imbalanceList); // Reset to full list
      } else {
        filteredImbalanceList = imbalanceList.where((item) {
          final lowerQuery = query.toLowerCase();
          return item.staffName?.toLowerCase().contains(lowerQuery) == true ||
              item.itemName?.toLowerCase().contains(lowerQuery) == true ||
              item.imbalanceQty?.toString().contains(lowerQuery) == true;
        }).toList();
      }
    });
  }

}
