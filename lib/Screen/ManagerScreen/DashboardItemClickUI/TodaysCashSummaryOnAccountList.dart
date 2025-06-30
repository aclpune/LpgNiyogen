import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/TodaysCashSummaryOnAccountListModel.dart';
import 'package:http/http.dart' as http;
class TodaysCashSummaryOnAccountList extends StatefulWidget {
  static const screenName = '/todaysCashSummaryOnAccountList';
  const TodaysCashSummaryOnAccountList({super.key});

  @override
  State<TodaysCashSummaryOnAccountList> createState() => _TodaysCashSummaryOnAccountListState();
}

class _TodaysCashSummaryOnAccountListState extends State<TodaysCashSummaryOnAccountList> {
  late List<TodaysCashSummaryOnAccountListModel> onAccountList = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOnAccountList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                    Text(
                      "On Account Details",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
                        "Today's Amt.",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),

                    Expanded(
                      flex: 2,
                      child: Text(
                       "As Of Date Amt.",
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
                  onAccountList.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: onAccountList.length,
                    itemBuilder: (context, index) {
                      TodaysCashSummaryOnAccountListModel? onAccount = onAccountList[index];
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
                                      onAccount.staffName.toString(),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      onAccount.staffOnAccToday!.toStringAsFixed(2),
                                      style: Styling.buttonTextBlack,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  verticalDividerVerySmallWidth(),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      onAccount.staffOnAccAsOf!.toStringAsFixed(2),
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

  Future<void> fetchOnAccountList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardOnAccAmtCtnListMob_V1}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    debugPrint("GetDashboardOnAccAmtCtnListMob_V1" + '${AppUrl.GetDashboardOnAccAmtCtnListMob_V1}/$distributorId');
    debugPrint("GetDashboardOnAccAmtCtnListMob_V1" + '${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint("GetDashboardOnAccAmtCtnListMob_V1" + '$data');

      setState(() {
        onAccountList = data.map((json) => TodaysCashSummaryOnAccountListModel.fromJson(json)).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
}
