import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ConstantScreen/widgets.dart';
import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
import '../ClickModelClass/GetDashboardTVStockPendCtnListForMob.dart';
import 'DashboardSVDetails.dart';

class DashboardTVDetailUI extends StatefulWidget {
  GetDashboardTvStockPendCtnListForMob tvmodel;

  DashboardTVDetailUI( this.tvmodel,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardTVDetailUI();
  }
}

class _DashboardTVDetailUI extends State<DashboardTVDetailUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.tvmodel;

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
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, sale.itemName ?? '')),
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.tVDate ?? '')))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Cons No", "${nullToDash(sale.consumerNo)}")),
              Expanded(flex:1,child: countTextWidgetText(context,"Cyl Qty.", "${nullToDash(sale.clyHoldQty.toString())}")),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Reg. Rec", "${nullToDash(sale.isRegulator)}")),
              Expanded(flex:1,child: countTextWidgetText(context,"Paid Amount", "${nullToDash(formatCurrency((sale.paidAmt ?? 0.0).toDouble()))}")),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Stock Status", "${nullToDash(sale.stockStatus)}")),
              Expanded(flex:1,child: countTextWidgetText(context,"Rec Date", '')),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Cons. Name", "${sale.consumerName ?? ''}")),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Godown No.", '')),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Del Men", '')),
            ],
          ),
          Divider(),
        ],
      );
  }
}
