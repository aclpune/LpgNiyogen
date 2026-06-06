import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ClickModelClass/GetexpensepopupListModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerExpenseTabScreenUI extends StatefulWidget {
  GetexpensepopupListModel getExpenseModel;
  int serialNumber;
  String screenmode;
  ManagerExpenseTabScreenUI(this.getExpenseModel, this.serialNumber, this.screenmode, {super.key});

  @override
  _ManagerExpenseTabScreenUI createState() => _ManagerExpenseTabScreenUI();
}

class _ManagerExpenseTabScreenUI extends State<ManagerExpenseTabScreenUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.getExpenseModel;
    var mode = widget.screenmode;
    var serialNumbers = widget.serialNumber;
    debugPrint("mode $mode");
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
            flex: 2,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: AppColors.redXL, shape: BoxShape.circle),
              child: Center(child: Text('$serialNumbers', style: AppTypography.miniLabel.copyWith(color: AppColors.red))),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              sale.staffName == null ? '' : sale.staffName.toString(),
              style: AppTypography.cardTitle.copyWith(color: AppColors.textMid),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sale.qty == null ? '' : sale.qty.toString(),
              style: AppTypography.labelMD.copyWith(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '₹ ${formatCurrency(sale.cash!.toDouble())}',
              style: AppTypography.labelMD.copyWith(color: AppColors.green),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '₹ ${formatCurrency(sale.bank!.toDouble())}',
              style: AppTypography.labelMD.copyWith(color: AppColors.blue),
              textAlign: TextAlign.right,
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