import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ClickModelClass/DSRReportScreenDetailModel.dart';



class ManagerDSRReportScreenItemUI extends StatefulWidget{
  DsrReportScreenDetailModel dsrlistModel;
  // DsrReportExpenseModel? dsrexpenseModel;
  String screenmode;
  int serialNumber;

  ManagerDSRReportScreenItemUI( this.dsrlistModel,this.screenmode, this.serialNumber,{Key? key}) : super(key: key);

  @override
  State<ManagerDSRReportScreenItemUI> createState() => _ManagerDSRReportScreenItemUI();
}

class _ManagerDSRReportScreenItemUI extends State<ManagerDSRReportScreenItemUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.dsrlistModel;
    var mode = widget.screenmode;
    var serialNumbers = widget.serialNumber;
   return
     Padding(
       padding: EdgeInsets.only(left:5.0,right: 5,top: 2,bottom: 2),
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
               (sale.itemName == "" ? sale.transCate ?? '' : sale.itemName ?? ''),  // Otherwise show item name or transCate
               style: TextStyle(fontSize: 16),
             ),
           ),

// Quantity Column (Only for Credit Mode)
           Visibility(
             visible: mode == 'Credit',
             child: Expanded(
               flex: 2,
               child: Text(
                 sale.qtyName.toString() ?? '0' ,  // Show qtyName if creditAmt is >= 0
                 style: TextStyle(fontSize: 16),
               ),
             ),
           ),
           Visibility(
             visible: mode == 'Credit' ,
             child: Expanded(
               flex: mode == 'Credit' ? 4: 2,
               child: Text(
                sale.coustemerName ?? '' , // Show customerName for Credit mode if creditAmt >= 0
                 style: TextStyle(fontSize: 16),
               ),
             ),
           ),

           Expanded(
             flex: mode == 'Credit' ? 3: 2,
             child:
             // Text(
             //   mode == 'MERCHANT'
             //       ? (formatCurrency(sale.merchantQR!.toDouble()))  // Show bankAmt for Bank mode if >= 0
             //       : mode == 'Credit'
             //       ? (formatCurrency(sale.creditAmt!.toDouble()))  // Show creditAmt if >= 0 for Credit mode
             //       : (formatCurrency(sale.cashAmt!.toDouble())),  // Show cashAmt if >= 0 for Cash mode
             //   style: TextStyle(fontSize: 16),
             // ),
               Text(
                 mode == 'MERCHANT'
                     ? formatCurrency((sale.merchantQR ?? 0).toDouble())
                     : mode == 'Credit'
                     ? formatCurrency((sale.creditAmt ?? 0).toDouble())
                     : mode == 'PREPAID'
                     ? formatCurrency((sale.prepaidAmt ?? 0).toDouble())
                     : formatCurrency((sale.cashAmt ?? 0).toDouble()),
                 style: TextStyle(fontSize: 16),
               )

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
