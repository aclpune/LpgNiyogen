import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Widget.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import 'package:http/http.dart' as http;

import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import 'StockReturnFromDelBoy.dart';

class DeliveryMenListShowScreenItemUI extends StatefulWidget {
  DeliveryMenSaleListModel _listModel;


  DeliveryMenListShowScreenItemUI(this._listModel,{Key? key}) : super(key: key);

  @override
  State<DeliveryMenListShowScreenItemUI> createState() => _DeliveryMenListShowScreenItemUIState();
}

class _DeliveryMenListShowScreenItemUIState extends State<DeliveryMenListShowScreenItemUI> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
      value != null && value != ""?
        SingleChildScrollView(  // Make the Column scrollable
          child:
          Container(
            child:
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0,bottom: 0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(
                                      context,
                                      DailyRefillSalePage
                                          .screenName,
                                      arguments: {
                                        "delBoyName": value.staffName,
                                        "delBoyID" : value.dMId,
                                        "vehicleNo" :value.vehicleNo,
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    value.staffName.toString(),
                                    textAlign: TextAlign.left,
                                    style:Styling.textFormTextWithUnderline,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              ),
                            ),
                            verticalDividerVerySmall(),
                            Container(
                              width: 100,
                              child: Column(
                                children: [
                                  Text(
                                    value.filledSaleQty.toString(),
                                    style:Styling.textFormText,
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(  // Add a horizontal line (divider) after each item
                  color: Colors.grey,
                  height: 1.0,
                ),
              ],
            ),
          ),

        ):
      Container(
        child:  Text("No data found"),
      );
  }

}
