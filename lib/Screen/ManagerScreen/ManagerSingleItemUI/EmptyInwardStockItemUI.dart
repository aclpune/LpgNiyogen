import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';

import 'package:http/http.dart' as http;


import '../ManagerModelClass/GetCurrentStockDetailManagerModel.dart';


class EmptyInwardStockItemUI extends StatefulWidget {
  GetCurrentStockDetailManagerModel filteredSales;


  EmptyInwardStockItemUI(this.filteredSales,{Key? key}) : super(key: key);

  @override
  State<EmptyInwardStockItemUI> createState() => _EmptyInwardStockItemUIState();
}

class _EmptyInwardStockItemUIState extends State<EmptyInwardStockItemUI> {

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return
      Container(
        width: 130,
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
                      sale.emptyTVCnt.toString(), // Replace this with your dynamic data
                      style: Styling.countNumberReds,
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
