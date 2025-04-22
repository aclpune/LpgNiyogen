import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DSRReportExpenseModel.dart';

import '../ClickModelClass/DSRReportScreenDetailModel.dart';
import '../ClickModelClass/GetUnsettledAmountListModel.dart';

class ManagerIncomeUnsettledScreenDetailUI extends StatefulWidget{
  GetUnsettledAmountListModel unsettledModelList;

  int serialNumber;
  //String? flahcheck;

  ManagerIncomeUnsettledScreenDetailUI( this.unsettledModelList, this.serialNumber,{Key? key}) : super(key: key);

  @override
  State<ManagerIncomeUnsettledScreenDetailUI> createState() => _ManagerIncomeUnsettledScreenDetailUI();
}

class _ManagerIncomeUnsettledScreenDetailUI extends State<ManagerIncomeUnsettledScreenDetailUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.unsettledModelList;
    //var mode = widget.flahcheck;
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
                     sale.staffName ?? '',
                    //(sale.itemName == "" ? sale.transCate ?? '' : sale.itemName ?? ''),  // Otherwise show item name or transCate
                    style: TextStyle(fontSize: 16),
                  ),
                ),
               Expanded(
                    flex: 1,
                    child: Text(
                     sale.qty.toString(),
                      //(sale.creditAmt != null && sale.creditAmt! >= 0) ? sale.qtyName?.toString() ?? '' : 'No record found',  // Show qtyName if creditAmt is >= 0
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
             Expanded(
                    flex: 2,
                    child: Text(
                      formatCurrency(sale.amount!.toDouble()),
                      //(sale.coustemerName != null && sale.creditAmt! >= 0 ? sale.coustemerName ?? '' : 'No record found'), // Show customerName for Credit mode if creditAmt >= 0
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
}

