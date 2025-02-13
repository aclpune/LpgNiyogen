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

class CDCMSStockItemUI extends StatefulWidget {
  GetManagerDashboarDetailModel filteredSales;


  CDCMSStockItemUI(this.filteredSales,{Key? key}) : super(key: key);

  @override
  State<CDCMSStockItemUI> createState() => _CDCMSStockItemUIState();
}

class _CDCMSStockItemUIState extends State<CDCMSStockItemUI> {

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return
      Container(
        width: 170,
        height: 130,
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
                    Column(
                      children: [
                        Text(
                          sale.filledDiff.toString(), // Replace this with your dynamic data
                          style: Styling.countNumber,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4), // Space between count and label
                        Text(
                          'F', // Label for filledDiff
                          style: Styling.textFormText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    verticalDividerSmallest(),
                    Column(
                      children: [
                        Text(
                          sale.emptyDiff.toString(), // Replace this with your dynamic data
                          style: Styling.countNumber,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4), // Space between count and label
                        Text(
                          'E', // Label for emptyDiff
                          style: Styling.textFormText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    verticalDividerSmallest(),
                    Column(
                      children: [
                        Text(
                          sale.defectiveDiff.toString(), // Replace this with your dynamic data
                          style: Styling.countNumber,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4), // Space between count and label
                        Text(
                          'D', // Label for defectiveDiff
                          style: Styling.textFormText,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sale.itemName.toString(),
                      style: Styling.textFormText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )

          ),
        ),
      );

  }

}
