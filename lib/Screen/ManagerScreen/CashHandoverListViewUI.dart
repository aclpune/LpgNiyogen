import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/Widget.dart';
import 'CashHandoverModelClass/GetCashHandOverDtlsModel.dart';



class CashHandoverListViewUI extends StatefulWidget {
  GetCashHandOverDtlsModel cashHandovermodel;
  int serialNumber;
  int listLength;
  // final List<DSRReportCashInHandModel> cashInHandModel;

  // Constructor to receive the deliveryMenList
  //ManagerCashInHandScreenDetails({Key? key, required this.deliveryMenList}) : super(key: key);
  CashHandoverListViewUI(this.cashHandovermodel,
      this.serialNumber,
      this.listLength,
      {super.key});

  @override
  _CashHandoverListViewUI createState() =>
      _CashHandoverListViewUI();
}

class _CashHandoverListViewUI extends State<CashHandoverListViewUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.cashHandovermodel;
    var serialNumbers = widget.serialNumber;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "$serialNumbers", // Dynamically display serial numbers (index + 1 or any other dynamic value)
                  style: TextStyle(fontSize: 16),
                  //textAlign: TextAlign.center,

                ),
              ),
              //verticalDividerVerySmallWidth(),
              Divider(),
              Expanded(
                flex: 2,
                child: Text(
                  sale.staffName ?? '',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              //verticalDividerVerySmallWidth(),
              Expanded(
                flex: 2,
                child: Text(
                formatCurrency(sale.totalAmt!.toDouble()), // The amount text
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
            ],
          ),
          if (widget.serialNumber != widget.listLength)
            Divider(),
        ],
      ),
    );
  }

}
String formatCurrency(double amount) {
  if (amount == 0) {
    return '0.00'; // Return "0.00" if the amount is zero
  }
  final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator

  // Ensure the result always shows a leading zero before the decimal point
  String formattedAmount = format.format(amount);

  // If there's no integer part, it ensures that a leading zero is added before decimal
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0' + formattedAmount;
  }

  return formattedAmount;
}
