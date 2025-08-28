import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';
import 'DashboardPunchDetailUI.dart';

class DashboardPrepaidDetails extends StatefulWidget {
  static const screenName = '/dashboardPrepaidDetails';
  @override
  State<StatefulWidget> createState() {
    return _DashboardPrepaidDetailsState();
  }
}

class _DashboardPrepaidDetailsState extends State<DashboardPrepaidDetails> {
  TextEditingController _searchController = TextEditingController();
  late List<GetDashboardSettlementCtnListModel> prepaidModel = [];
  late List<GetDashboardNiyojanPunchCtnLstModel> punchModel = [];
  List<GetDashboardSettlementCtnListModel> filteredPrepaidModel = [];
  List<GetDashboardNiyojanPunchCtnLstModel> filteredPunchModel = [];
  bool isLoading = true;
  String todayDate = DateTime.now().toString();
  var argValue;
  String? flag;
  bool isSearchActive = false;


  @override
  void initState() {
    super.initState();
    filteredPrepaidModel = prepaidModel;  // Initializing with the original list
    filteredPunchModel = punchModel;  // Initializing with the original list

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        flag = argValue["flag"];

        debugPrint("flag :- ${flag.toString()}");
        fetchSettled(flag!);
        fetchPunch(flag!);
      });
    });

  }
  void filterSearchResults(String query) {
    setState(() {
      // Convert query to lowercase for case-insensitive matching
      String lowerQuery = query.toLowerCase();
      print("Filtering with query: $query");

      // Filter prepaidModel based on all relevant fields
      filteredPrepaidModel = prepaidModel.where((item) {
        bool matches = (item.consumerNo != null && item.consumerNo!.toLowerCase().contains(lowerQuery)) ||
            (item.consumerName != null && item.consumerName!.toLowerCase().contains(lowerQuery)) ||
            (item.orderDate != null && item.orderDate!.toLowerCase().contains(lowerQuery)) ||
            (item.deliveryDate != null && item.deliveryDate!.toLowerCase().contains(lowerQuery));
        if (matches) {
          print("Prepaid match found: ${item.consumerNo}, ${item.consumerName}");
        }
        return matches;
      }).toList();

      // Filter punchModel based on all relevant fields
      filteredPunchModel = punchModel.where((item) {
        bool matches = (item.staffName != null && item.staffName!.toLowerCase().contains(lowerQuery)) ||
            (item.niyojanPunQty != null && item.niyojanPunQty!.toString().toLowerCase().contains(lowerQuery)) ||
            (item.settlementQty != null && item.settlementQty!.toString().toLowerCase().contains(lowerQuery));
        if (matches) {
          print("Punch match found: ${item.staffName}, ${item.niyojanPunQty}");
        }
        return matches;
      }).toList();
    });
  }
  Future<void> fetchPunch(String flags) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardNiyojanPunchCtnLstForMob}/$distributorId/$flags'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDashboardNiyojanPunchCtnLstForMob" + '${AppUrl.GetDashboardNiyojanPunchCtnLstForMob}/$distributorId/$flags');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        punchModel = data.map((json) {
              // String dateString = json['TodayDate'];
              // DateTime date = DateTime.parse(dateString);
              // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
              // json['TodayDate'] = formattedDate;
              if (json['TodayDate'] != null) {
                try {
                  DateTime date = DateTime.parse(json['TodayDate']);
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  json['TodayDate'] = formattedDate;
                } catch (e) {
                  debugPrint("Date parsing failed for: ${json['TodayDate']}, error: $e");
                  json['TodayDate'] = ''; // Or set to null or leave as-is
                }
              } else {
                json['TodayDate'] = ''; // Handle missing date gracefully
              }
          return GetDashboardNiyojanPunchCtnLstModel.fromJson(json);
        }).toList();
        filteredPunchModel = List.from(punchModel); // <-- Add this
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchSettled(String flags) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    final response = await http.get(
      Uri.parse('${AppUrl.GetDashboardSettlementCtnList}/$distributorId/$flags'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    debugPrint("GetDashboardSettlementCtnList" + '${AppUrl.GetDashboardSettlementCtnList}/$distributorId/$flags');
    debugPrint("GetDashboardSettlementCtnList" + '${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // setState(() {
      //   prepaidModel = data.map((json) =>
      //       GetDashboardSettlementCtnListModel.fromJson(json)).toList();
      //   isLoading = false;
      //   EasyLoading.dismiss();
      // });
      debugPrint("GetDashboardSettlementCtnList" + '$data');

      setState(() {
        prepaidModel = data.map((json) => GetDashboardSettlementCtnListModel.fromJson(json)).toList();
        filteredPrepaidModel = List.from(prepaidModel); // <-- Add this
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  String _getDisplayText(String flag) {
    switch (flag) {
      case "Delivered":
        return "Delivered,payment pending";
      case "Settled":
        return "Payment done,delivery pending";
      case "cDCMS":
        return "Pending in cDCMS";
      case "DelDonNiyoJanPunPend":
        return "Punched in cDCMS,pending in Niyojan";
      case "OldBkgPendNewBkgRecv":
        return "Old punching pending but....";
      case "Punching":
        return "Today's Niyojan Punched";
      case "Incorrect":
        return "Today's incorrect";
      case "NiyoJanPunDelPend":
        return "Punched in Niyojan,pending in cDCMS";
      case "TotalOutstanding":
        return "Total Outstanding Pending";
      default:
        return "Prepaid Details";
    }
  }

  @override
  Widget build(BuildContext context) {
    var preCount = prepaidModel.length;
    var punchCount = punchModel.length;

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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDisplayText(flag?? ''),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            (flag == "Delivered"
                                || flag == "Settled"
                                || flag == "TotalOutstanding"
                                || flag == "cDCMS"
                                || flag == "DelDonNiyoJanPunPend"
                                || flag == "OldBkgPendNewBkgRecv")
                                ? 'List Count: $preCount'
                                : 'List Count: $punchCount',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
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
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: (flag == "Punching" || flag == "Incorrect" || flag == "NiyoJanPunDelPend"),
                      child: Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                            style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex:(flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                      ?2:4,
                      child: Text(
                        (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                            ? "Consumer No."
                            : "Staff Name",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),

                    Expanded(
                      flex:(flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                      ?3:2,
                      child: Text(
                        (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                            ? "Consumer \n Name"
                            : "Niyojan \n Punching",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                            ? "Order Date"
                            : "Settl Qty.",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalDividerVerySmallWidth(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv")
                            ? "Delivery Date"
                            : "Settl Pen Qty.",
                        style: Styling.buttonTextBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Visibility( visible: (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv"),
                        child: verticalDividerVerySmallWidth()),
                    Visibility(
                      visible: (flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv"),
                      child:  Expanded(
                        flex: 2,
                        child: Text(
                          'Settlement \n Date',
                          style: Styling.buttonTextBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          // Scrollable ListView for content
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         flag == "Delivered" || flag == "Settled" || flag == "TotalOutstanding" || flag == "cDCMS" || flag == "DelDonNiyoJanPunPend" || flag == "OldBkgPendNewBkgRecv"
          //             ? filteredPrepaidModel.isNotEmpty
          //             ? ListView.builder(
          //           physics: const BouncingScrollPhysics(),
          //           shrinkWrap: true,
          //           itemCount: filteredPrepaidModel.length,
          //           itemBuilder: (context, index) {
          //             debugPrint("Rendering Prepaid Item: ${filteredPrepaidModel[index]}");
          //             return DashboardPrepaidDetailUI(
          //               filteredPrepaidModel[index],
          //               index + 1,
          //             );
          //           },
          //         )
          //             : const Text('No Records Found')
          //             : (filteredPunchModel.isNotEmpty &&
          //             (flag == "Punching" || flag == "Incorrect" || flag == "NiyoJanPunDelPend"))
          //             ? ListView.builder(
          //           physics: const BouncingScrollPhysics(),
          //           shrinkWrap: true,
          //           itemCount: filteredPunchModel.length,
          //           itemBuilder: (context, index) {
          //             debugPrint("Rendering Punch Item: ${filteredPunchModel[index]}");
          //             return DashbobardPunchDetailUI(
          //               filteredPunchModel[index],
          //             );
          //           },
          //         )
          //             : const Text('No Records Found'),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : flag == "Delivered" ||
                flag == "Settled" ||
                flag == "TotalOutstanding" ||
                flag == "cDCMS" ||
                flag == "DelDonNiyoJanPunPend" ||
                flag == "OldBkgPendNewBkgRecv"
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredPrepaidModel.length,
              itemBuilder: (context, index) {
                return DashboardPrepaidDetailUI(
                  filteredPrepaidModel[index],
                  index + 1,
                );
              },
            )
                : (flag == "Punching" ||
                flag == "Incorrect" ||
                flag == "NiyoJanPunDelPend")
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredPunchModel.length,
              itemBuilder: (context, index) {
                return DashbobardPunchDetailUI(
                  filteredPunchModel[index],
                );
              },
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
