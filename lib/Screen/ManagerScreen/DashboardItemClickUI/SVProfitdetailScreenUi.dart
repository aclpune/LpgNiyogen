import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/SVProfitDetailDataGetModel.dart';

class SVProfitDetailScreenUI extends StatefulWidget {
  static const screenName = '/sVProfitDetailScreenUI';
  const SVProfitDetailScreenUI({super.key});

  @override
  State<SVProfitDetailScreenUI> createState() => _SVProfitDetailScreenUIState();
}

class _SVProfitDetailScreenUIState extends State<SVProfitDetailScreenUI> {
  late List<SvProfitDetailDataGetModel> svProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      final String dayFlags = argValue?["DAYFLAG"] ?? '';
      flags = dayFlags;
      fetchSVDetailList(dayFlags);
    });
  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            surfaceTintColor: Color(0xFFECEFFF),
            backgroundColor: Color(0xFFECEFFF),
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
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "SV Detail - ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          flags == "TODAYS"?"Today's":flags == "THISMONTH"?"This Month":flags == "FINYEAR"?"Financial Year":"",
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
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    svProfitDetailDataGetModel.isNotEmpty?
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: svProfitDetailDataGetModel.length,
                      itemBuilder: (context, index) {
                        SvProfitDetailDataGetModel? sv = svProfitDetailDataGetModel[index];
                        return
                             Card(
                               elevation: 2,
                               margin: EdgeInsets.all(8),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(12),
                               ),
                               child:
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      itemSubLineWithBlackAndBlue("Item Name",sv.itemName.toString()),
                                      itemSubLine("QTY",sv.itemQty.toString()),
                                      itemSubLine("Prof.Amt.",sv.profitAmt!.toStringAsFixed(2)),
                                  ],),
                                ),
                             );


                      },
                    )
                        : Center(child: const Text('No Records Found')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchSVDetailList(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    try{
      final response = await http.get(
        Uri.parse('${AppUrl.GetDashboardSVProfitDtls_Mob}/$distributorId/$flag'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetDashboardSVProfitDtls_Mob request" + '${AppUrl.GetDashboardSVProfitDtls_Mob}/$distributorId/$flag');
      debugPrint("GetDashboardSVProfitDtls_Mob resposnse" + '${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint("GetDashboardSVProfitDtls_Mob" + '$data');
        setState(() {
          svProfitDetailDataGetModel = data
              .map((json) => SvProfitDetailDataGetModel.fromJson(json))
              .toList();

          isLoading = false;
          EasyLoading.dismiss();
        });

      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load items');
      }
    }catch(e){
      EasyLoading.dismiss();
      debugPrint("Exceptin $e");
    }

  }
}
