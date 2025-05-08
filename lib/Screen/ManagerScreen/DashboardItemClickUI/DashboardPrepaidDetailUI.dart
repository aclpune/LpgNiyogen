import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';

class DashboardPrepaidDetailUI extends StatefulWidget {
  GetDashboardSettlementCtnListModel prepaidModel;
  int serialNumber;

  DashboardPrepaidDetailUI( this.prepaidModel,this.serialNumber,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardPrepaidDetailUIState();
  }
}


class _DashboardPrepaidDetailUIState extends State<DashboardPrepaidDetailUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.prepaidModel;
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     "$serialNumbers",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 2,
                child: Text(
                 nullToDash(sale.consumerNo),
                  style: Styling.itemBlackTestVerySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              verticalDividerVerySmallWidth(),
              Expanded(
                flex: 3,
                child: Text(
                  nullToDash(sale.consumerName),
                  style: Styling.itemBlackTestVerySmall,textAlign: TextAlign.center,
                ),
              ),
              verticalDividerVerySmallWidth(),
              Expanded(
                flex: 2,
                child: Text(
                  nullToDash(sale.orderDate),
                  style: Styling.itemBlackTestVerySmall,textAlign: TextAlign.center,
                ),
              ),
              verticalDividerVerySmallWidth(),
              Expanded(
                flex: 2,
                child: Text(
                  nullToDash(sale.deliveryDate),
                  style: Styling.itemBlackTestVerySmall,textAlign: TextAlign.center,
                ),
              ),
              verticalDividerVerySmallWidth(),
              Expanded(
                flex: 2,
                child: Text(
                  nullToDash(sale.settlementDate),
                  style: Styling.itemBlackTestVerySmall,textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      );
  }
}
