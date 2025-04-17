import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ClickModelClass/DsrReportCashInHandModel.dart';


class ManagerCashInHandScreenDetailsUI extends StatefulWidget {
  DsrReportCashInHandModel cashInHandModel;
  int serialNumber;
 // final List<DSRReportCashInHandModel> cashInHandModel;

  // Constructor to receive the deliveryMenList
  //ManagerCashInHandScreenDetails({Key? key, required this.deliveryMenList}) : super(key: key);
  ManagerCashInHandScreenDetailsUI(this.cashInHandModel,
      this.serialNumber,
      {super.key});

  @override
  _ManagerCashInHandScreenDeailsUI createState() =>
      _ManagerCashInHandScreenDeailsUI();
}

class _ManagerCashInHandScreenDeailsUI extends State<ManagerCashInHandScreenDetailsUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.cashInHandModel;
    var serialNumbers = widget.serialNumber;
   return Padding(
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
                 sale.itemName ?? '',
                 style: TextStyle(fontSize: 16),
               ),
             ),

             Expanded(
               flex: 2,
               child: Text(
                 sale.totalAmount!.toStringAsFixed(2),
                 style: TextStyle(fontSize: 16),

               ),
             ),
             Divider(),
           ],
         ),
         Divider(),
       ],
     ),
   );
  }

}