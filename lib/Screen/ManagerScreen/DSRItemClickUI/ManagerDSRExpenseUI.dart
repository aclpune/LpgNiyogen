import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DSRReportExpenseModel.dart';



class ManagerDSRExpenseUI extends StatefulWidget{

  DsrReportExpenseModel dsrexpenseModel;
  String screenmode;
  int serialNumber;

  ManagerDSRExpenseUI( this.dsrexpenseModel,this.screenmode, this.serialNumber,{Key? key}) : super(key: key);

  @override
  State<ManagerDSRExpenseUI> createState() => _ManagerDSRExpenseUI();
}

class _ManagerDSRExpenseUI extends State<ManagerDSRExpenseUI> {
  @override
  Widget build(BuildContext context) {

    var expensesale = widget.dsrexpenseModel;
    var mode = widget.screenmode;
    var serialNumbers = widget.serialNumber;
    return
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "$serialNumbers", // Dynamically display serial numbers (index + 1 or any other dynamic value)
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            Expanded(
              flex: 3,
              child: Text(
                expensesale.expensehead ?? "No Head", // Replace with actual field name
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                expensesale.cash!.toStringAsFixed(2) ?? "0", // Replace with actual field name
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                expensesale.bank!.toStringAsFixed(2) ?? "0", // Replace with actual field name
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
          ),
            Divider(), // Add a divider after each row
          ],
        ),
      );

  }

}

