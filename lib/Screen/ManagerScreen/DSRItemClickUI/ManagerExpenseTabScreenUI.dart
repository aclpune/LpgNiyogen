import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ClickModelClass/GetexpensepopupListModel.dart';



class ManagerExpenseTabScreenUI extends StatefulWidget {

  GetexpensepopupListModel getExpenseModel;

  int serialNumber;
  String screenmode;
  // Constructor to receive the deliveryMenList
  //ManagerCashInHandScreenDetails({Key? key, required this.deliveryMenList}) : super(key: key);
  ManagerExpenseTabScreenUI(this.getExpenseModel,this.serialNumber, this.screenmode,{super.key});

  @override
  _ManagerExpenseTabScreenUI createState() =>
      _ManagerExpenseTabScreenUI();
}
class _ManagerExpenseTabScreenUI extends State<ManagerExpenseTabScreenUI>{
  @override
  Widget build(BuildContext context) {
     var sale = widget.getExpenseModel;
    var mode = widget.screenmode;
     var serialNumbers = widget.serialNumber;
     debugPrint("mode $mode");
    return
       Padding(
         padding: EdgeInsets.only(left:5.0,right: 5,top: 2,bottom: 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                        "$serialNumbers", // Dynamically display serial numbers (index + 1 or any other dynamic value)
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(sale.staffName == null ? '':
                      sale.staffName.toString() ?? '',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                        formatCurrency(sale.cash!.toDouble()),
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                 Expanded(
                      flex: 3,
                      child: Text(
                          formatCurrency(sale.bank!.toDouble()),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),

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