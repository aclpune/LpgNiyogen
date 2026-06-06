import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ConstantScreen/widgets.dart';

class SVSaleReportScreenUI extends StatefulWidget {
  // GetDashboardTvStockPendCtnListForMob tvmodel;
  //GetStaffDetailsListModel staffdetailsmodel;
  final dynamic data;
  int serialNumber;
  int listLength;

  SVSaleReportScreenUI({super.key, required this.data, required this.serialNumber, required this.listLength});

  @override
  State<StatefulWidget> createState() {
    return _SVSaleReportScreenUI();
  }
}

class _SVSaleReportScreenUI extends State<SVSaleReportScreenUI> {
  @override
  Widget build(BuildContext context) {
    //var sale = widget.tvmodel;

    var data = widget.data; // Access the passed data

    String nullToDash(dynamic value) {
      if (value == null) {
        return "-";
      }
      final text = value.toString();
      if (text.toLowerCase() == "null") {
        return "-";
      }
      return text;
    }
    // Safely extract fields from 'data' (assuming it's a Map or Object)
    String consNo = nullToDash(data['Product ']);
    String cylQty = nullToDash(data['cylQty']);
    String regRec = nullToDash(data['regRec']);


    return
      Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, regRec)),
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                  children: [
                    // Edit Icon
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                      onPressed: () {
                        // Handle the edit action
                        print('Edit button pressed');
                      },
                    ),
                    // Delete Icon
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),  // Icon for delete
                      onPressed: () {
                        // Handle the delete action
                        print('Delete button pressed');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"SV Date", consNo)),
              Expanded(flex:1,child: countTextWidgetText(context,"SV Type", cylQty)),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"SV Pending", "")),
              Expanded(flex:1,child: countTextWidgetText(context,"Cons.No./DC No.", "")),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Cons. Name", "")),
              Expanded(flex:1,child: countTextWidgetText(context,"Total Amt.", '')),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Mode", "")),
            ],
          ),
          if (widget.serialNumber != widget.listLength)
            Divider(),
        ],
      );
  }
}
