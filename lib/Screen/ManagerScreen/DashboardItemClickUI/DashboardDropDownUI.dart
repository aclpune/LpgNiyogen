import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ConstantScreen/widgets.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';

class DashboardDropDownUI extends StatefulWidget {

  ConsumerDetails punchCtnLstModel;
  int serialNumber;
  int listLength;

  DashboardDropDownUI( this.punchCtnLstModel,this.serialNumber,this.listLength,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardDropDownUI();
  }
}

class _DashboardDropDownUI extends State<DashboardDropDownUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.punchCtnLstModel;
    var serialNumbers = widget.serialNumber;

    String nullToDash(String? value) {
      if (value == null || value.toLowerCase() == "null") {
        return "-";  // If value is null or the string "null", replace with '-'
      }
      return value;  // If not null or "null", return the original value
    }
    return
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.consumerNo))),
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.orderDate))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Name", nullToDash(sale.consumerName))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"C Memo Date", nullToDash(sale.cashMemoDate))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Settle Date", nullToDash(sale.settlementDate))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Delivery Date", nullToDash(sale.deliveryDate))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Remark", nullToDash(sale.remark))),
            ],
          ),
          if (widget.serialNumber != widget.listLength)
            Divider(),
        ],
      );
  }
}
