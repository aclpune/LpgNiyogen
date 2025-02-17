import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import '../../Utils/constants.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import '../ManagerModelClass/GetManagerDashboarDetailModel.dart';
import '../ManagerModelClass/RSPAmountOFItemListModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart';

class ImbalanceStockItemUI extends StatefulWidget {
  GetManagerDashboarDetailModel filteredSales;


  ImbalanceStockItemUI(this.filteredSales,{Key? key}) : super(key: key);

  @override
  State<ImbalanceStockItemUI> createState() => _ImbalanceStockItemUIState();
}

class _ImbalanceStockItemUIState extends State<ImbalanceStockItemUI> {

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return
      Container(
        width: 110,
        height: 90,
        child:
        Card(
          margin: EdgeInsets.symmetric(vertical: 7),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      sale.todayImbQty.toString(), // Replace this with your dynamic data
                      style: Styling.countNumber,
                      textAlign: TextAlign.center,
                    ),
                    verticalDividerSmallest(),
                    Text(
                      sale.asOfDateImbQty.toString(), // Replace this with your dynamic data
                      style: Styling.countNumber,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sale.itemName.toString(),
                      style: Styling.textFormText,
                      textAlign: TextAlign.center,)
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}
