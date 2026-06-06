import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';

void main() {
  group('dashboard_models', () {
    test('StockSummary total and percentages work', () {
      const stock = StockSummary(filled: 10, empty: 5, defective: 5, weightKg: 14.2);
      expect(stock.total, 20);
      expect(stock.filledPct, 0.5);
      expect(stock.emptyPct, 0.25);
      expect(stock.defectPct, 0.25);
    });

    test('StockSummary zero total returns zero percentages', () {
      const stock = StockSummary(filled: 0, empty: 0, defective: 0, weightKg: 14.2);
      expect(stock.total, 0);
      expect(stock.filledPct, 0);
      expect(stock.emptyPct, 0);
      expect(stock.defectPct, 0);
    });

    test('DashboardData netProfit subtracts totalExpenses', () {
      final data = DashboardData(
        businessName: 'Biz',
        ownerName: 'Owner',
        ownerInitials: 'OW',
        date: DateTime(2026, 1, 1),
        revenueToday: 0,
        stockSummary: const StockSummary(filled: 1, empty: 1, defective: 1, weightKg: 14.2),
        alerts: const [],
        financialKpis: const [],
        onAccountToday: 0,
        onAccountTotal: 0,
        svPending: 0,
        tvPending: 0,
        unsettledCount: 0,
        unsettledAmount: 0,
        imbalanceToday: 0,
        imbalanceTotal: 0,
        outstandingSettlement: 0,
        profitRows: const [
          ProfitRow(label: 'A', grossRevenue: 100, grossProfit: 40),
          ProfitRow(label: 'B', grossRevenue: 100, grossProfit: 10),
        ],
        totalExpenses: 20,
      );
      expect(data.netProfit, 30);
    });

    test('AlertItem stores callback and values', () {
      var tapped = false;
      final item = AlertItem(
        title: 'Title',
        subtitle: 'Subtitle',
        value: '10',
        severity: AlertSeverity.info,
        icon: Icons.info,
        onTap: () => tapped = true,
      );
      expect(item.title, 'Title');
      item.onTap?.call();
      expect(tapped, isTrue);
    });

    test('FinancialKpi stores colors and icon', () {
      const kpi = FinancialKpi(
        label: 'KPI',
        value: '₹0',
        subtitle: 'Sub',
        badgeLabel: 'Badge',
        badgeColor: AppColors.blueXL,
        badgeFg: AppColors.blue,
        iconBg: AppColors.tealXL,
        icon: Icons.wallet,
      );
      expect(kpi.label, 'KPI');
      expect(kpi.badgeColor, AppColors.blueXL);
      expect(kpi.icon, Icons.wallet);
    });
  });
}
