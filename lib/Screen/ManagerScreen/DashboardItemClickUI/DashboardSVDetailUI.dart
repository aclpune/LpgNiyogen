import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ConstantScreen/widgets.dart';
import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
import 'DashboardSVDetails.dart';

class DashboardSVDetailUI extends StatefulWidget {
  GetDashboardSvStockPendCtnListForMobListModel svmodel;

  DashboardSVDetailUI( this.svmodel,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardSVDetailUI();
  }
}


class _DashboardSVDetailUI extends State<DashboardSVDetailUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.svmodel;

    String nullToDash(String? value) {
      if (value == null || value.toLowerCase() == "null") {
        return "-";  // If value is null or the string "null", replace with '-'
      }
      return value;  // If not null or "null", return the original value
    }
    return
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context,DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? '')))),
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.itemName))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Cons./Challan", nullToDash(sale.consuDCNo))),
              Expanded(flex:1,child: countTextWidgetText(context,"Cyl. Qty", nullToDash(sale.cylQty.toString()))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Doc. Status", nullToDash("Received"))),
              Expanded(flex:1,child: countTextWidgetText(context,"Amount", nullToDash(formatCurrency((sale.totalAmount ?? 0.0).toDouble())))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Stock Status", nullToDash(sale.stockStatus))),
              Expanded(flex:1,child: countTextWidgetText(context,"Delivery Date", '')),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Consumer No.", sale.consumerNo ?? '-')),
              Expanded(flex:1,child: countTextWidgetText(context,"SV Type", sale.sVType ?? '')),

            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Con Name", nullToDash(sale.consumerName))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Ref. By", sale.referredBy ?? '')),
            ],
          ),

          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Delivery Men", '')),
            ],
          ),

          Divider(),
        ],
      );
  }
}
//

