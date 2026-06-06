import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ClickModelClass/DsrReportCashInHandModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerCashInHandScreenDetailsUI extends StatefulWidget {
  DsrReportCashInHandModel cashInHandModel;
  int serialNumber;
  ManagerCashInHandScreenDetailsUI(this.cashInHandModel, this.serialNumber, {super.key});

  @override
  _ManagerCashInHandScreenDeailsUI createState() => _ManagerCashInHandScreenDeailsUI();
}

class _ManagerCashInHandScreenDeailsUI extends State<ManagerCashInHandScreenDetailsUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.cashInHandModel;
    var serialNumbers = widget.serialNumber;
    final isEven = serialNumbers % 2 == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              width: 26, height: 26,
              decoration: BoxDecoration(color: AppColors.blueXXL, shape: BoxShape.circle),
              child: Center(child: Text('$serialNumbers', style: AppTypography.miniLabel.copyWith(color: AppColors.blue))),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(sale.itemName ?? '', style: AppTypography.cardTitle.copyWith(color: AppColors.textMid)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹ ${formatCurrency(sale.totalAmount!.toDouble())}',
              style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
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