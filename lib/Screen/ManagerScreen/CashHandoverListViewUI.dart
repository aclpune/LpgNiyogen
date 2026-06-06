import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';

import 'CashHandoverModelClass/GetCashHandOverDtlsModel.dart';



class CashHandoverListViewUI extends StatefulWidget {
  final GetCashHandOverDtlsModel cashHandovermodel;
  final int serialNumber;
  final int listLength;
  // final List<DSRReportCashInHandModel> cashInHandModel;

  // Constructor to receive the deliveryMenList
  //ManagerCashInHandScreenDetails({Key? key, required this.deliveryMenList}) : super(key: key);
  CashHandoverListViewUI(this.cashHandovermodel,
      this.serialNumber,
      this.listLength,
      {super.key});

  @override
  State<CashHandoverListViewUI> createState() =>
      _CashHandoverListViewUI();
}

class _CashHandoverListViewUI extends State<CashHandoverListViewUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.cashHandovermodel;
    var serialNumbers = widget.serialNumber;
    return Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "$serialNumbers",
                    style: AppTypography.dataRowValue,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    sale.staffName ?? '',
                    style: AppTypography.dataRowLabel.copyWith(color: AppColors.text),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    formatCurrency(sale.totalAmt!.toDouble()),
                    style: AppTypography.dataRowValue.copyWith(color: AppColors.blueLight),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          if (widget.serialNumber != widget.listLength)
            const Divider(color: AppColors.border),
        ],
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
