import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ClickModelClass/GetUnsettledAmountListModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerIncomeUnsettledScreenDetailUI extends StatefulWidget {
  GetUnsettledAmountListModel unsettledModelList;
  int serialNumber;
  ManagerIncomeUnsettledScreenDetailUI(this.unsettledModelList, this.serialNumber, {Key? key}) : super(key: key);

  @override
  State<ManagerIncomeUnsettledScreenDetailUI> createState() => _ManagerIncomeUnsettledScreenDetailUI();
}

class _ManagerIncomeUnsettledScreenDetailUI extends State<ManagerIncomeUnsettledScreenDetailUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.unsettledModelList;
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
              decoration: BoxDecoration(color: AppColors.tealXXL, shape: BoxShape.circle),
              child: Center(child: Text('$serialNumbers', style: AppTypography.miniLabel.copyWith(color: AppColors.teal))),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(sale.staffName ?? '', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)),
          ),
          Expanded(
            flex: 1,
            child: Text(sale.qty.toString(), style: AppTypography.labelMD.copyWith(color: AppColors.textMuted), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹ ${formatCurrency(sale.amount!.toDouble())}',
              style: AppTypography.cardTitle.copyWith(color: AppColors.teal),
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
