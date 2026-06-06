import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';

import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../ManagerModelClass/GetManagerDashboarDetailModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart' show ManagerUpdateSaleCashUpdation;

class CDCMSStockItemUI extends StatefulWidget {
  GetManagerDashboarDetailModel filteredSales;
  final bool isLastItem;

  CDCMSStockItemUI(this.filteredSales, {Key? key, required this.isLastItem})
      : super(key: key);

  @override
  State<CDCMSStockItemUI> createState() => _CDCMSStockItemUIState();
}

class _CDCMSStockItemUIState extends State<CDCMSStockItemUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statCell(sale.filledDiff.toString(), 'F'),
                  _divider(),
                  _statCell(sale.emptyDiff.toString(), 'E'),
                  _divider(),
                  _statCell(sale.defectiveDiff.toString(), 'D'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sale.itemName.toString(),
                    style: AppTypography.cardSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!widget.isLastItem)
          Container(
            width: 2,
            height: 70,
            color: AppColors.border2,
          ),
      ],
    );
  }

  Widget _statCell(String value, String label) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.kpiValueLG,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppTypography.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 40,
        color: AppColors.border,
      );
}
