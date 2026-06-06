import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../ClickModelClass/DSRReportScreenDetailModel.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

class ManagerDSRReportScreenItemUI extends StatefulWidget {
  DsrReportScreenDetailModel dsrlistModel;
  String screenmode;
  int serialNumber;
  ManagerDSRReportScreenItemUI(this.dsrlistModel, this.screenmode, this.serialNumber, {Key? key}) : super(key: key);

  @override
  State<ManagerDSRReportScreenItemUI> createState() => _ManagerDSRReportScreenItemUI();
}

class _ManagerDSRReportScreenItemUI extends State<ManagerDSRReportScreenItemUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.dsrlistModel;
    var mode = widget.screenmode;
    var serialNumbers = widget.serialNumber;
    final isEven = serialNumbers % 2 == 0;

    final amountValue = mode == 'MERCHANT'
        ? formatCurrency((sale.merchantQR ?? 0).toDouble())
        : mode == 'Credit'
            ? formatCurrency((sale.creditAmt ?? 0).toDouble())
            : mode == 'PREPAID'
                ? formatCurrency((sale.prepaidAmt ?? 0).toDouble())
                : formatCurrency((sale.cashAmt ?? 0).toDouble());

    final amountColor = mode == 'MERCHANT'
        ? AppColors.teal
        : mode == 'Credit'
            ? AppColors.amber
            : mode == 'PREPAID'
                ? AppColors.orange
                : AppColors.green;

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
              decoration: BoxDecoration(color: AppColors.blueXXL, shape: BoxShape.circle),
              child: Center(child: Text('$serialNumbers', style: AppTypography.miniLabel.copyWith(color: AppColors.blue))),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sale.itemName == "" ? sale.transCate ?? '' : sale.itemName ?? '',
              style: AppTypography.cardTitle.copyWith(color: AppColors.textMid),
            ),
          ),
          if (mode == 'Credit') ...[
            Expanded(
              flex: 2,
              child: Text(sale.qtyName.toString(), style: AppTypography.labelMD.copyWith(color: AppColors.textMuted)),
            ),
            Expanded(
              flex: 3,
              child: Text(sale.coustemerName ?? '', style: AppTypography.labelMD.copyWith(color: AppColors.textMid), overflow: TextOverflow.ellipsis),
            ),
          ],
          Expanded(
            flex: mode == 'Credit' ? 2 : 2,
            child: Text('₹ $amountValue', style: AppTypography.cardTitle.copyWith(color: amountColor), textAlign: TextAlign.right),
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
