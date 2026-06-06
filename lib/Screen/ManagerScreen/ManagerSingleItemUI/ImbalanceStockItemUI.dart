import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';

import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../DashboardItemClickUI/ImbalanceCountClickUI.dart';
import '../ManagerModelClass/GetManagerDashboarDetailModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart' show ManagerUpdateSaleCashUpdation;

class ImbalanceStockItemUI extends StatefulWidget {
  GetManagerDashboarDetailModel filteredSales;
  final bool isLastItem;

  ImbalanceStockItemUI(this.filteredSales, {Key? key, required this.isLastItem})
      : super(key: key);

  @override
  State<ImbalanceStockItemUI> createState() => _ImbalanceStockItemUIState();
}

class _ImbalanceStockItemUIState extends State<ImbalanceStockItemUI> {
  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ImbalanceCountClickUI.screenName,
                      arguments: {"ItemId": sale.itemId},
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        sale.todayImbQty.toString(),
                        style: AppTypography.kpiValueLG.copyWith(
                          color: AppColors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      verticalDividerSmallestRed(),
                      Text(
                        sale.asOfDateImbQty.toString(),
                        style: AppTypography.kpiValueLG.copyWith(
                          color: AppColors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
}
