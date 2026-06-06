import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DSRReportExpenseModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerDSRExpenseUI extends StatefulWidget {
  DsrReportExpenseModel dsrexpenseModel;
  String screenmode;
  int serialNumber;
  ManagerDSRExpenseUI(this.dsrexpenseModel, this.screenmode, this.serialNumber, {Key? key}) : super(key: key);

  @override
  State<ManagerDSRExpenseUI> createState() => _ManagerDSRExpenseUI();
}

class _ManagerDSRExpenseUI extends State<ManagerDSRExpenseUI> {
  @override
  Widget build(BuildContext context) {
    var expensesale = widget.dsrexpenseModel;
    var serialNumbers = widget.serialNumber;
    final isEven = serialNumbers % 2 == 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isEven ? AppColors.bg : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: AppColors.orangeXXL, shape: BoxShape.circle),
              child: Center(child: Text('$serialNumbers', style: AppTypography.miniLabel.copyWith(color: AppColors.orange))),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(expensesale.expensehead ?? 'No Head', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹ ${formatCurrency(expensesale.cash!.toDouble())}',
                    style: AppTypography.labelMD.copyWith(color: AppColors.green)),
                Text('₹ ${formatCurrency(expensesale.bank!.toDouble())}',
                    style: AppTypography.labelMD.copyWith(color: AppColors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) formattedAmount = '0' + formattedAmount;
    return formattedAmount;
  }
}
